package mg.gestion.cinema.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import mg.gestion.cinema.models.Billet;
import mg.gestion.cinema.models.Film;
import mg.gestion.cinema.models.Historique;
import mg.gestion.cinema.models.Place;
import mg.gestion.cinema.models.Reservation;
import mg.gestion.cinema.models.Seance;
import mg.gestion.cinema.models.Statut;
import mg.gestion.cinema.models.Tarif;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.service.TransactionCallback;
import mg.gestion.cinema.utils.CGenericUtils;
import mg.gestion.cinema.utils.DataUtil;

@Controller
@RequestMapping("/reservations")
public class ReservationController {

    @Autowired
    private ConnexionService connexionService;

    @GetMapping
    public String listeReservation(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) Integer filmId,
            @RequestParam(required = false) String dateReservation,
            Model model) {
        try (var conn = connexionService.getConnection()) {
            StringBuilder sql = new StringBuilder("SELECT * FROM reservation WHERE 1=1");

            if (dateReservation != null && !dateReservation.isEmpty()) {
                sql.append(" AND DATE(date_creation) = '").append(dateReservation).append("'");
            }

            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND (CAST(id AS TEXT) LIKE '%").append(search).append("%'")
                        .append(" OR LOWER(numero) LIKE LOWER('%").append(search).append("%'))");
            }

            sql.append(" ORDER BY date_creation DESC");

            List<Reservation> reservations = CGenericUtils.executeQuery(conn, Reservation.class, sql.toString());

            for (Reservation reservation : reservations) {
                reservation.loadAttributes(conn);
            }

            List<Film> films = CGenericUtils.find(conn, Film.class, null);

            model.addAttribute("reservations", reservations);
            model.addAttribute("films", films);
            model.addAttribute("search", search);
            model.addAttribute("filmId", filmId);
            model.addAttribute("dateReservation", dateReservation);

            return "reservation/listeReservation";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des réservations : " + e.getMessage());
            model.addAttribute("reservations", List.of());
            return "reservation/listeReservation";
        }
    }

    @GetMapping("/form")
    public String reservationForm(Model model) {
        try (var conn = connexionService.getConnection()) {
            List<Film> films = CGenericUtils.find(conn, Film.class, null);
            List<Tarif> tarifs = CGenericUtils.find(conn, Tarif.class, null);

            model.addAttribute("films", films);
            model.addAttribute("tarifs", tarifs);
            return "reservation/formulaireReservation";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement du formulaire : " + e.getMessage());
            return "reservation/formulaireReservation";
        }

    }

    @PostMapping("/reserver")
    public String reserverBillet(Model model,
            @RequestParam("seanceId") Integer seanceId,
            @RequestParam("tarifId") Integer tarifId,
            @RequestParam("dateReservation") String dateReservation,
            @RequestParam("nombreBillets") Integer nombreBillets) {
        try (var conn = connexionService.getConnection()) {
            LocalDateTime dateRes = DataUtil.convertStringToDateTime(dateReservation, "yyyy-MM-dd'T'HH:mm");
            LocalDateTime now = LocalDateTime.now();

            if (!CGenericUtils.exist(conn, Seance.class, seanceId)) {
                throw new IllegalArgumentException("La séance sélectionnée n'existe pas.");
            }
            if (!CGenericUtils.exist(conn, Tarif.class, tarifId)) {
                throw new IllegalArgumentException("Le tarif sélectionné n'existe pas.");
            }
            if (nombreBillets == null || nombreBillets < 1 || nombreBillets > 10) {
                throw new IllegalArgumentException("Le nombre de billets doit être entre 1 et 10.");
            }

            Seance seance = CGenericUtils.findOne(conn, Seance.class, Map.of("id", seanceId));
            Tarif tarif = CGenericUtils.findOne(conn, Tarif.class, Map.of("id", tarifId));

            List<Place> placesLibres = seance.getPlacesLibre(conn, now);
            if (placesLibres.size() < nombreBillets) {
                throw new IllegalStateException("Seulement " + placesLibres.size()
                        + " place(s) disponible(s) pour cette séance. Vous en avez demandé " + nombreBillets + ".");
            }

            Statut statutBillet = CGenericUtils.findOne(conn, Statut.class,
                    Map.of("code", "PANIER", "categorie", "BILLET"));
            Statut statutPlace = CGenericUtils.findOne(conn, Statut.class,
                    Map.of("code", "SELECTION", "categorie", "PLACE"));
            Statut statutReservation = CGenericUtils.findOne(conn, Statut.class,
                    Map.of("code", "PANIER", "categorie", "RESERVATION"));

            final int nombreBilletsRequis = nombreBillets;
            final double prixUnitaire = tarif.getPrixBase();
            final double montantTotal = prixUnitaire * nombreBilletsRequis;

            connexionService.executeInTransaction((TransactionCallback) (connection -> {
                Reservation reservation = new Reservation();
                reservation.setDateCreation(now);
                reservation.setMontantTotal(montantTotal);
                reservation.setStatutId(statutReservation.getId());
                Reservation savedReservation = (Reservation) reservation.save(connection);

                for (int i = 0; i < nombreBilletsRequis; i++) {
                    List<Place> placesDisponibles = seance.getPlacesLibre(connection, now);
                    if (placesDisponibles.isEmpty()) {
                        throw new IllegalStateException(
                                "Plus de place disponible après avoir réservé " + i + " billet(s).");
                    }
                    Place placeAffectee = placesDisponibles.get(0);

                    Billet billet = new Billet();
                    billet.setReservationId(savedReservation.getId());
                    billet.setSeanceId(seanceId);
                    billet.setTarifId(tarifId);
                    billet.setPlaceId(placeAffectee.getId());
                    billet.setPrixReel(prixUnitaire);
                    billet.setDateAchat(dateRes);
                    billet.setStatut(statutBillet.getId());

                    Billet result = (Billet) billet.save(connection);

                    Historique historique = new Historique();
                    historique.setTableName("billet");
                    historique.setClePrimaire(result.getId());
                    historique.setStatut(statutBillet.getId());
                    historique.setDateModification(now);
                    CGenericUtils.save(connection, historique);

                    placeAffectee.setStatut(statutPlace.getId());
                    placeAffectee.save(connection);

                    Historique historiquePlace = new Historique();
                    historiquePlace.setTableName("place");
                    historiquePlace.setClePrimaire(placeAffectee.getId());
                    historiquePlace.setStatut(statutPlace.getId());
                    historiquePlace.setDateModification(now);
                    CGenericUtils.save(connection, historiquePlace);
                }
            }));

            model.addAttribute("success", nombreBillets + " billet(s) réservé(s) avec succès !");

            List<Film> films = CGenericUtils.find(conn, Film.class, null);
            List<Tarif> tarifs = CGenericUtils.find(conn, Tarif.class, null);
            model.addAttribute("films", films);
            model.addAttribute("tarifs", tarifs);

            return "reservation/formulaireReservation";
        } catch (Exception e) {
            e.printStackTrace();
            String errorMessage = "Erreur lors de la réservation : " + e.getMessage();
            if (e.getCause() != null) {
                errorMessage += " | Cause: " + e.getCause().getMessage();
            }
            model.addAttribute("error", errorMessage);

            try (var conn = connexionService.getConnection()) {
                List<Film> films = CGenericUtils.find(conn, Film.class, null);
                List<Tarif> tarifs = CGenericUtils.find(conn, Tarif.class, null);
                model.addAttribute("films", films);
                model.addAttribute("tarifs", tarifs);
            } catch (Exception ex) {
                model.addAttribute("error", "Erreur lors du chargement du formulaire : " + ex.getMessage());
            }
            return "reservation/formulaireReservation";
        }
    }

    @GetMapping("/payement/{id}")
    public String confirmerReservation(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try (var conn = connexionService.getConnection()) {
            Reservation reservation = CGenericUtils.findOne(conn, Reservation.class, Map.of("id", id),true);
            LocalDateTime now = LocalDateTime.now();

            if (reservation == null) {
                redirectAttributes.addFlashAttribute("error", "Réservation introuvable");
                return "redirect:/reservations";
            }

            Statut statutPaye = CGenericUtils.findOne(conn, Statut.class,
                    Map.of("code", "PAYEE", "categorie", "RESERVATION"));

            Statut statutBillet = CGenericUtils.findOne(conn, Statut.class,
                    Map.of("code", "PAYE", "categorie", "BILLET"));

            connexionService.executeInTransaction((TransactionCallback) (connection -> {
                List<Billet> billets = reservation.getBillets();
                for (Billet billet : billets) {
                    billet.setStatut(statutBillet.getId());

                    billet.save(connection);
                    Historique historiqueBillet = new Historique();
                    historiqueBillet.setTableName("billet");
                    historiqueBillet.setClePrimaire(billet.getId());
                    historiqueBillet.setStatut(statutBillet.getId());
                    historiqueBillet.setDateModification(now);
                    historiqueBillet.save(connection);
                }
                
                reservation.setStatutId(statutPaye.getId());

                Historique historiqueReservation = new Historique();
                historiqueReservation.setTableName("reservation");
                historiqueReservation.setClePrimaire(reservation.getId());
                historiqueReservation.setStatut(statutPaye.getId());
                historiqueReservation.setDateModification(now);
                historiqueReservation.save(connection);

                CGenericUtils.save(connection, reservation);
            }));

            redirectAttributes.addFlashAttribute("message", "Réservation #" + id + " confirmée avec succès !");
            return "redirect:/reservations";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la confirmation : " + e.getMessage());
            return "redirect:/reservations";
        }
    }

    @GetMapping("/annuler/{id}")
    public String annulerReservation(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try (var conn = connexionService.getConnection()) {
            Reservation reservation = CGenericUtils.findOne(conn, Reservation.class, Map.of("id", id));

            if (reservation == null) {
                redirectAttributes.addFlashAttribute("error", "Réservation introuvable");
                return "redirect:/reservations";
            }

            Statut statutAnnule = CGenericUtils.findOne(conn, Statut.class,
                    Map.of("code", "ANNULE", "categorie", "RESERVATION"));

            connexionService.executeInTransaction((TransactionCallback) (connection -> {
                reservation.setStatutId(statutAnnule.getId());
                CGenericUtils.save(connection, reservation);
            }));

            redirectAttributes.addFlashAttribute("message", "Réservation #" + id + " annulée avec succès !");
            return "redirect:/reservations";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'annulation : " + e.getMessage());
            return "redirect:/reservations";
        }
    }

    @GetMapping("/view/{id}")
    public String voirReservation(@PathVariable Integer id, Model model) {
        try (var conn = connexionService.getConnection()) {
            Reservation reservation = CGenericUtils.findOne(conn, Reservation.class, Map.of("id", id), true);

            if (reservation == null) {
                model.addAttribute("error", "Réservation introuvable");
                return "redirect:/reservations";
            }

            List<Billet> billets = reservation.getBillets();

            model.addAttribute("billets", billets);
            model.addAttribute("reservation", reservation);

            return "reservation/detailReservation";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement de la réservation : " + e.getMessage());
            return "redirect:/reservations";
        }
    }
}

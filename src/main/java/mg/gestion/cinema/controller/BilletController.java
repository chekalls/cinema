package mg.gestion.cinema.controller;

import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mg.gestion.cinema.models.Billet;
import mg.gestion.cinema.models.Film;
import mg.gestion.cinema.models.Historique;
import mg.gestion.cinema.models.Place;
import mg.gestion.cinema.models.Seance;
import mg.gestion.cinema.models.Statut;
import mg.gestion.cinema.models.Tarif;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;

@Controller
@RequestMapping("/billets")
public class BilletController {
    @Autowired
    private ConnexionService connexionService;

    @GetMapping
    public String listeBillet(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) Integer filmId,
            @RequestParam(required = false) Integer statutId,
            @RequestParam(required = false) String dateAchat,
            Model model) {
        try (var conn = connexionService.getConnection()) {
            StringBuilder sql = new StringBuilder(
                "SELECT b.* FROM billet b " +
                "INNER JOIN seance s ON b.seance_id = s.id " +
                "WHERE 1=1");
            
            if (filmId != null) {
                sql.append(" AND s.film_id = ").append(filmId);
            }
            
            if (statutId != null) {
                sql.append(" AND b.statut = ").append(statutId);
            }
            
            if (dateAchat != null && !dateAchat.isEmpty()) {
                sql.append(" AND DATE(b.date_achat) = '").append(dateAchat).append("'");
            }
            
            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND (CAST(b.id AS TEXT) LIKE '%").append(search).append("%'"
                          + " OR EXISTS (SELECT 1 FROM film f WHERE f.id = s.film_id AND LOWER(f.titre) LIKE LOWER('%")
                   .append(search).append("%')))" );
            }
            
            sql.append(" ORDER BY b.date_achat DESC");
            
            List<Billet> billets = CGenericUtils.executeQuery(conn, Billet.class, sql.toString());
            
            for (Billet billet : billets) {
                billet.loadAttributes(conn);
            }
            
            List<Film> films = CGenericUtils.find(conn, Film.class, null);
            List<Statut> statuts = CGenericUtils.find(conn, Statut.class, 
                Map.of("categorie", "BILLET"));
            
            model.addAttribute("billets", billets);
            model.addAttribute("films", films);
            model.addAttribute("statuts", statuts);
            model.addAttribute("search", search);
            model.addAttribute("filmId", filmId);
            model.addAttribute("statutId", statutId);
            model.addAttribute("dateAchat", dateAchat);
            
            return "billet/listeBillet";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des billets : " + e.getMessage());
            model.addAttribute("billets", List.of());
            return "billet/listeBillet";
        }
    }

    @PostMapping("/acheter")
    public String acheterBillet(Model model, @RequestParam("seanceId") Integer seanceId,
            @RequestParam("tarifId") Integer tarifId) {
        try (var conn = connexionService.getConnection()) {
            LocalDateTime now = LocalDateTime.now();

            if (!CGenericUtils.exist(conn, Seance.class, seanceId)) {
                throw new IllegalArgumentException("La séance sélectionnée n'existe pas.");
            }
            if (!CGenericUtils.exist(conn, Tarif.class, tarifId)) {
                throw new IllegalArgumentException("Le tarif sélectionné n'existe pas.");
            }
            Seance seance = CGenericUtils.findOne(conn, Seance.class, Map.of("id", seanceId));
            Tarif tarif = CGenericUtils.findOne(conn, Tarif.class, Map.of("id", tarifId));
            List<Place> placesLibres = seance.getPlacesLibre(conn, now);
            if (placesLibres.isEmpty()) {
                throw new IllegalStateException("Aucune place disponible pour cette séance.");
            }
            Place placeAffectee = placesLibres.get(0);
            Statut statutBillet = CGenericUtils.findOne(conn, Statut.class, Map.of("code", "PAYE"));

            Billet billet = new Billet();
            billet.setSeanceId(seanceId);
            billet.setTarifId(tarifId);
            billet.setPlaceId(placeAffectee.getId());
            billet.setPrixReel(tarif.getPrixBase());
            billet.setDateAchat(now);
            billet.setStatut(statutBillet.getId());

            connexionService.executeInTransaction(connection -> {
                Billet result = (Billet) billet.save(connection);

                Historique historique = new Historique();
                historique.setTableName("billet");
                historique.setClePrimaire(result.getId());
                historique.setStatut(statutBillet.getId());
                historique.setDateModification(now);
                CGenericUtils.save(connection, historique);
            });

            model.addAttribute("success", "Billet acheté avec succès !");
            return "billet/formulaireAchatBillet";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors de l'achat du billet : " + e.getMessage());
            return "billet/formulaireAchatBillet";
        }
    }

    // @GetMapping("/details/{id}")
    // public String detailsBillet(Model model,@PathVariable("id") Integer billetId){

    // }

    @GetMapping("/achatForm")
    public String achatBilletForm(Model model) {
        try (var conn = connexionService.getConnection()) {
            List<Film> films = CGenericUtils.find(conn, Film.class, null);
            model.addAttribute("films", films);
            List<Tarif> tarifs = CGenericUtils.find(conn, Tarif.class, null);
            model.addAttribute("tarifs", tarifs);
            return "billet/formulaireAchatBillet";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement du formulaire : " + e.getMessage());
            return "billet/formulaireAchatBillet";
        }
    }

    @GetMapping("/api/seances-par-film/{filmId}")
    @ResponseBody
    public ResponseEntity<?> getSeancesParFilm(@PathVariable Integer filmId) {
        try (Connection conn = connexionService.getConnection()) {
            List<Seance> seances = Seance.getProchainSeances(conn, LocalDate.now());

            seances = seances.stream()
                    .filter(s -> s.getFilmId() != null && s.getFilmId().equals(filmId))
                    .toList();

            return ResponseEntity.ok(seances);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur : " + e.getMessage());
        }
    }
}

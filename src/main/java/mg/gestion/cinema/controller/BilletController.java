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
import mg.gestion.cinema.models.Sceance;
import mg.gestion.cinema.models.Statut;
import mg.gestion.cinema.models.Tarif;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;

@Controller
@RequestMapping("/billets")
public class BilletController {
    @Autowired
    private ConnexionService connexionService;

    @PostMapping("/acheter")
    public String acheterBillet(Model model, @RequestParam("seanceId") Integer seanceId,
            @RequestParam("tarifId") Integer tarifId) {
        try (var conn = connexionService.getConnection()) {
            LocalDateTime now = LocalDateTime.now();

            if (!CGenericUtils.exist(conn, Sceance.class, seanceId)) {
                throw new IllegalArgumentException("La séance sélectionnée n'existe pas.");
            }
            if (!CGenericUtils.exist(conn, Tarif.class, tarifId)) {
                throw new IllegalArgumentException("Le tarif sélectionné n'existe pas.");
            }
            Sceance sceance = CGenericUtils.findOne(conn, Sceance.class, Map.of("id", seanceId));
            Tarif tarif = CGenericUtils.findOne(conn, Tarif.class, Map.of("id", tarifId));
            List<Place> placesLibres = sceance.getPlacesLibre(conn, now);
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

    @GetMapping("/api/sceances-par-film/{filmId}")
    @ResponseBody
    public ResponseEntity<?> getSceancesParFilm(@PathVariable Integer filmId) {
        try (Connection conn = connexionService.getConnection()) {
            // Récupérer les séances futures pour ce film
            List<Sceance> sceances = Sceance.getProchainSceances(conn, LocalDate.now());

            // Filtrer uniquement celles qui correspondent au film
            sceances = sceances.stream()
                    .filter(s -> s.getFilmId() != null && s.getFilmId().equals(filmId))
                    .toList();

            return ResponseEntity.ok(sceances);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur : " + e.getMessage());
        }
    }
}

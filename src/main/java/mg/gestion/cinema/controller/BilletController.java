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
import mg.gestion.cinema.models.TypePersone;
import mg.gestion.cinema.models.TypePlace;
import mg.gestion.cinema.models.TypePlacePrix;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;

@Controller
@RequestMapping("/billets")
public class BilletController {
    @Autowired
    private ConnexionService connexionService;

    @GetMapping("/tarifs")
    public String listTarif(
            @RequestParam(required = false) Integer typePlaceId,
            @RequestParam(required = false) Integer typePersonneId,
            @RequestParam(required = false) String statut,
            @RequestParam(required = false) Double prixMin,
            @RequestParam(required = false) Double prixMax,
            @RequestParam(required = false) String search,
            Model model) {
        try (var conn = connexionService.getConnection()) {
            StringBuilder sql = new StringBuilder(
                    "SELECT * FROM type_place_prix WHERE 1=1");

            if (typePlaceId != null) {
                sql.append(" AND type_place_id = ").append(typePlaceId);
            }

            if (typePersonneId != null) {
                sql.append(" AND type_personne_id = ").append(typePersonneId);
            }

            if (statut != null && !statut.isEmpty()) {
                if ("principal".equals(statut)) {
                    sql.append(" AND parent_id IS NULL");
                } else if ("derive".equals(statut)) {
                    sql.append(" AND parent_id IS NOT NULL");
                }
            }

            if (prixMin != null) {
                sql.append(" AND prix_place >= ").append(prixMin);
            }

            if (prixMax != null) {
                sql.append(" AND prix_place <= ").append(prixMax);
            }

            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND CAST(id AS TEXT) LIKE '%").append(search).append("%'");
            }

            sql.append(" ORDER BY id ASC");

            List<TypePlacePrix> tarifs = CGenericUtils.executeQuery(conn, TypePlacePrix.class, sql.toString());
            
            for (TypePlacePrix tarif : tarifs) {
                tarif.loadAttribute(conn);
            }

            List<TypePlace> typePlaces = CGenericUtils.find(conn, TypePlace.class, null);
            List<TypePersone> typePersonnes = CGenericUtils.find(conn, TypePersone.class, null);

            model.addAttribute("tarifs", tarifs);
            model.addAttribute("typePlaces", typePlaces);
            model.addAttribute("typePersonnes", typePersonnes);
            model.addAttribute("typePlaceId", typePlaceId);
            model.addAttribute("typePersonneId", typePersonneId);
            model.addAttribute("statut", statut);
            model.addAttribute("prixMin", prixMin);
            model.addAttribute("prixMax", prixMax);
            model.addAttribute("search", search);

            return "billet/listTarif";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Erreur lors du chargement des tarifs : " + e.getMessage());
            model.addAttribute("tarifs", List.of());
            return "billet/listTarif";
        }
    }

    @GetMapping("/tarifs/form")
    public String tarifForm(@RequestParam(required = false) Integer id, Model model) {
        try (var conn = connexionService.getConnection()) {
            if (id != null) {
                TypePlacePrix tarif = CGenericUtils.findOne(conn, TypePlacePrix.class, Map.of("id", id), true);
                if (tarif == null) {
                    model.addAttribute("error", "Tarif non trouvé");
                    return "redirect:/billets/tarifs";
                }
                model.addAttribute("tarif", tarif);
            }
            
            List<TypePlace> typePlaces = CGenericUtils.find(conn, TypePlace.class, null);
            List<TypePersone> typePersonnes = CGenericUtils.find(conn, TypePersone.class, null);
            List<TypePlacePrix> tarifsParents = CGenericUtils.find(conn, TypePlacePrix.class, null,true);
            
            model.addAttribute("typePlaces", typePlaces);
            model.addAttribute("typePersonnes", typePersonnes);
            model.addAttribute("tarifsParents", tarifsParents);
            
            return "billet/formulaireTarif";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement du formulaire : " + e.getMessage());
            return "redirect:/billets/tarifs";
        }
    }

    @PostMapping("/tarifs/save")
    public String saveTarif(
            @RequestParam(required = false) Integer id,
            @RequestParam("prixPlace") Double prixPlace,
            @RequestParam("typePlaceId") Integer typePlaceId,
            @RequestParam(required = false) Integer typePersonneId,
            @RequestParam(required = false) Integer parentId,
            @RequestParam(required = false) Double reduction,
            Model model) {
        try (var conn = connexionService.getConnection()) {
            TypePlacePrix tarif;
            
            if (id != null) {
                tarif = CGenericUtils.findOne(conn, TypePlacePrix.class, Map.of("id", id));
                if (tarif == null) {
                    model.addAttribute("error", "Tarif non trouvé");
                    return "redirect:/billets/tarifs";
                }
            } else {
                tarif = new TypePlacePrix();
            }
            
            tarif.setPrixPlace(prixPlace);
            tarif.setTypePlaceId(typePlaceId);
            tarif.setTypePersonneId(typePersonneId);
            tarif.setParentId(parentId);
            tarif.setReduction(reduction);
            
            connexionService.executeInTransaction(connection -> {
                try {
                    CGenericUtils.save(connection, tarif);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            });
            
            model.addAttribute("success", id != null ? "Tarif modifié avec succès" : "Tarif créé avec succès");
            return "redirect:/billets/tarifs";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors de l'enregistrement du tarif : " + e.getMessage());
            return tarifForm(id, model);
        }
    }

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
                        .append(search).append("%')))");
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
            @RequestParam("typePlaceId") Integer typePlaceId,
            @RequestParam(name = "typePersonneId", required = false) Integer typePersonneId,
            @RequestParam(name = "quantite", required = false, defaultValue = "1") Integer quantite) {
        try (var conn = connexionService.getConnection()) {
            LocalDateTime now = LocalDateTime.now();

            if (!CGenericUtils.exist(conn, Seance.class, seanceId)) {
                throw new IllegalArgumentException("La séance sélectionnée n'existe pas.");
            }
            if (!CGenericUtils.exist(conn, TypePlace.class, typePlaceId)) {
                throw new IllegalArgumentException("Le type de place sélectionné n'existe pas.");
            }
            Seance seance = CGenericUtils.findOne(conn, Seance.class, Map.of("id", seanceId));
            for (int i = 0; i < quantite; i++) {
                List<Place> placesLibres = seance.getPlacesLibre(conn,typePlaceId, now);
                if (placesLibres.isEmpty()) {
                    throw new IllegalStateException("Aucune place disponible pour cette séance.");
                }
                Place placeAffectee = placesLibres.get(0);
                Statut statutBillet = CGenericUtils.findOne(conn, Statut.class, Map.of("code", "PAYE"));
                Statut statutPlace = CGenericUtils.findOne(conn, Statut.class,
                        Map.of("code", "VENDUE", "categorie", "PLACE"));

                Billet billet = new Billet();
                billet.setSeanceId(seanceId);
                billet.setTarifId(null);
                billet.setPlaceId(placeAffectee.getId());
                billet.setDateAchat(now);
                billet.setStatut(statutBillet.getId());
                billet.setType_personne(typePersonneId);
                billet.setPrixReel(billet.getPrixWithReduction(conn));
              
                connexionService.executeInTransaction(connection -> {
                    try {
                        Billet result = (Billet) billet.save(connection);

                        Historique historique = new Historique();
                        historique.setTableName("billet");
                        historique.setClePrimaire(result.getId());
                        historique.setStatut(statutBillet.getId());
                        historique.setDateModification(now);
                        CGenericUtils.save(connection, historique);

                        Historique historiquePlace = new Historique();
                        historiquePlace.setTableName("place");
                        historiquePlace.setClePrimaire(billet.getPlaceId());
                        historiquePlace.setStatut(statutPlace.getId());
                        historiquePlace.setDateModification(now);
                        CGenericUtils.save(connection, historiquePlace);

                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                });
            }

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
            List<TypePlace> typePlaces = CGenericUtils.find(conn, TypePlace.class, null);
            List<TypePersone> typePersones = CGenericUtils.find(conn, TypePersone.class, null);

            model.addAttribute("typePersonnes", typePersones);
            model.addAttribute("films", films);
            model.addAttribute("typePlaces", typePlaces);
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

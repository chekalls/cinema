package mg.gestion.cinema.controller;

import java.sql.Connection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import mg.gestion.cinema.models.Cinema;
import mg.gestion.cinema.models.Place;
import mg.gestion.cinema.models.Salle;
import mg.gestion.cinema.models.TypePlace;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;

@Controller
@RequestMapping("/salles")
public class SalleController {
    @Autowired
    private ConnexionService connexionService;

    @GetMapping
    public String listeSalles(@RequestParam(required = false) String search, Model model) {
        try (Connection conn = connexionService.getConnection()) {
            List<Salle> salles;
            if (search != null && !search.trim().isEmpty()) {
                salles = CGenericUtils.search(conn, Salle.class, search);
                model.addAttribute("search", search);
            } else {
                salles = CGenericUtils.find(conn, Salle.class, new HashMap<>());
            }

            Map<Integer, Double> revenueMaxBySalleId = calculateMaxRevenueBySalleId(conn, salles);

            List<Cinema> cinemas = CGenericUtils.find(conn, Cinema.class, new HashMap<>());
            Map<Integer, Cinema> cinemasById = new HashMap<>();
            for (Cinema cinema : cinemas) {
                if (cinema.getId() != null) {
                    cinemasById.put(cinema.getId(), cinema);
                }
            }

            model.addAttribute("salles", salles);
            model.addAttribute("cinemasById", cinemasById);
            model.addAttribute("revenueMaxBySalleId", revenueMaxBySalleId);
            return "salle/listeSalle";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des salles : " + e.getMessage());
            return "salle/listeSalle";
        }
    }

    private Map<Integer, Double> calculateMaxRevenueBySalleId(Connection conn, List<Salle> salles) {
        if (salles == null || salles.isEmpty()) {
            return Collections.emptyMap();
        }

        List<Integer> salleIds = salles.stream()
                .map(Salle::getId)
                .filter(id -> id != null)
                .collect(Collectors.toList());

        if (salleIds.isEmpty()) {
            return Collections.emptyMap();
        }

        String inClause = buildInClausePlaceholders(salleIds.size());
        String sql = "SELECT p.salle_id, COALESCE(SUM(COALESCE(tp.prix, 0)), 0) AS revenue_max " +
                "FROM place p " +
                "LEFT JOIN type_place tp ON p.type_place_id = tp.id " +
                "WHERE p.salle_id IN (" + inClause + ") " +
                "GROUP BY p.salle_id";

        List<Map<String, Object>> rows = Salle.executeRawQuery(conn, sql, salleIds.toArray());
        Map<Integer, Double> result = new HashMap<>();
        for (Map<String, Object> row : rows) {
            if (row == null || row.get("salle_id") == null) {
                continue;
            }
            Integer salleId = Integer.parseInt(row.get("salle_id").toString());
            Object revenueObj = row.get("revenue_max");
            double revenue = revenueObj == null ? 0 : Double.parseDouble(revenueObj.toString());
            result.put(salleId, revenue);
        }

        return result;
    }

    private String buildInClausePlaceholders(int count) {
        if (count <= 0) {
            throw new IllegalArgumentException("count must be positive");
        }
        return String.join(", ", java.util.Collections.nCopies(count, "?"));
    }

    @GetMapping("/form")
    public String formulaireSalle(Model model) {
        try (Connection conn = connexionService.getConnection()) {
            if (!model.containsAttribute("salle")) {
                model.addAttribute("salle", new Salle());
            }

            List<Cinema> cinemas = CGenericUtils.find(conn, Cinema.class, new HashMap<>());
            List<TypePlace> typePlaces = CGenericUtils.find(conn, TypePlace.class, null);

            model.addAttribute("typePlaces", typePlaces);
            Map<Integer, Integer> typePlaceCounts = getTypePlaceCountsFromModelOrDefault(model, typePlaces, null, conn);
            model.addAttribute("typePlaceCounts", typePlaceCounts);
            model.addAttribute("cinemas", cinemas);
            return "salle/formulaireSalle";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement du formulaire : " + e.getMessage());
            return "salle/listeSalle";
        }
    }

    @GetMapping("/edit/{id}")
    public String editerSalle(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Salle salle = CGenericUtils.findOne(conn, Salle.class, criteria);

            if (salle == null) {
                redirectAttributes.addFlashAttribute("error", "Salle non trouvée");
                return "redirect:/salles";
            }

            model.addAttribute("salle", salle);
            List<Cinema> cinemas = CGenericUtils.find(conn, Cinema.class, new HashMap<>());
            List<TypePlace> typePlaces = CGenericUtils.find(conn, TypePlace.class, null);

            Map<Integer, Integer> typePlaceCounts = getTypePlaceCountsFromModelOrDefault(model, typePlaces, salle.getId(), conn);

            model.addAttribute("cinemas", cinemas);
            model.addAttribute("typePlaces", typePlaces);
            model.addAttribute("typePlaceCounts", typePlaceCounts);
            return "salle/formulaireSalle";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement de la salle : " + e.getMessage());
            return "redirect:/salles";
        }
    }

    @PostMapping("/save")
    public String enregistrerSalle(@ModelAttribute Salle salle,
            @RequestParam Map<String, String> allParams,
            RedirectAttributes redirectAttributes) {
        try {
            boolean isNew = salle.getId() == null;

            Map<Integer, Integer> typePlaceCounts = extractTypePlaceCounts(allParams);
            if (typePlaceCounts.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Veuillez renseigner au moins un type de place avec une quantité");
                redirectAttributes.addFlashAttribute("salle", salle);
                redirectAttributes.addFlashAttribute("typePlaceCounts", typePlaceCounts);
                return "redirect:/salles/form";
            }

            if (salle.getCinemaId() == null) {
                redirectAttributes.addFlashAttribute("error", "Le cinéma est obligatoire");
                redirectAttributes.addFlashAttribute("salle", salle);
                redirectAttributes.addFlashAttribute("typePlaceCounts", typePlaceCounts);
                return "redirect:/salles/form";
            }
            if (salle.getNumero() == null || salle.getNumero().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Le numéro de salle est obligatoire");
                redirectAttributes.addFlashAttribute("salle", salle);
                redirectAttributes.addFlashAttribute("typePlaceCounts", typePlaceCounts);
                return "redirect:/salles/form";
            }
            if (salle.getDesignation() == null || salle.getDesignation().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "La désignation est obligatoire");
                redirectAttributes.addFlashAttribute("salle", salle);
                redirectAttributes.addFlashAttribute("typePlaceCounts", typePlaceCounts);
                return "redirect:/salles/form";
            }

            int totalPlaces = typePlaceCounts.values().stream().mapToInt(Integer::intValue).sum();

            if (salle.getNbColonnes() != null && salle.getNbRangees() != null) {
                int capacite = salle.getNbColonnes() * salle.getNbRangees();
                if (capacite < totalPlaces) {
                    redirectAttributes.addFlashAttribute("error", "La grille (rangées x colonnes) est insuffisante pour le nombre total de places");
                    redirectAttributes.addFlashAttribute("salle", salle);
                    redirectAttributes.addFlashAttribute("typePlaceCounts", typePlaceCounts);
                    return "redirect:/salles/form";
                }
                salle.setCapaciteTotal(totalPlaces);
            } else {
                salle.setCapaciteTotal(totalPlaces);
            }

            if ((salle.getNbColonnes() == null || salle.getNbRangees() == null) && salle.getCapaciteTotal() != null) {
                salle.setAutoNbRangeesAndColonnes(null);
            }

            if (salle.getCapaciteTotal() == null || salle.getCapaciteTotal() <= 0) {
                redirectAttributes.addFlashAttribute("error", "La capacité totale doit être supérieure à 0");
                redirectAttributes.addFlashAttribute("salle", salle);
                redirectAttributes.addFlashAttribute("typePlaceCounts", typePlaceCounts);
                return "redirect:/salles/form";
            }

            connexionService.executeInTransaction(conn ->{
                CGenericUtils.save(conn, salle);

                if(salle.getNbColonnes()==null || salle.getNbRangees()==null) {
                    salle.setAutoNbRangeesAndColonnes(conn);
                }

                String deleteBilletsSql = "DELETE FROM billet WHERE place_id IN (SELECT id FROM place WHERE salle_id = ?)";
                CGenericUtils.executeUpdate(conn, deleteBilletsSql, salle.getId());
                
                CGenericUtils.executeUpdate(conn, "DELETE FROM place WHERE salle_id = ?", salle.getId());
                
                salle.insererPlace(typePlaceCounts, conn);
            });

            String message = isNew ? "Salle ajoutée avec succès" : "Salle modifiée avec succès";
            redirectAttributes.addFlashAttribute("message", message);
            return "redirect:/salles";
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
            redirectAttributes.addFlashAttribute("salle", salle);
            redirectAttributes.addFlashAttribute("typePlaceCounts", extractTypePlaceCounts(allParams));
            return "redirect:/salles/form";
        }
    }

    private Map<Integer, Integer> extractTypePlaceCounts(Map<String, String> params) {
        final String prefix = "typePlaceCount_";
        Map<Integer, Integer> result = new HashMap<>();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (entry.getKey().startsWith(prefix)) {
                String idStr = entry.getKey().substring(prefix.length());
                try {
                    Integer typePlaceId = Integer.valueOf(idStr);
                    String rawValue = entry.getValue();
                    if (rawValue != null && !rawValue.trim().isEmpty()) {
                        int count = Integer.parseInt(rawValue.trim());
                        if (count < 0) {
                            throw new IllegalArgumentException("La quantité pour un type de place ne peut pas être négative");
                        }
                        result.put(typePlaceId, count);
                    }
                } catch (NumberFormatException ignored) {
                    // ignore invalid ids or values
                }
            }
        }
        // remove zero counts
        result = result.entrySet().stream()
                .filter(e -> e.getValue() != null && e.getValue() > 0)
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
        return result;
    }

    private Map<Integer, Integer> getTypePlaceCountsFromModelOrDefault(Model model, List<TypePlace> typePlaces, Integer salleId, Connection conn) {
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> existing = (Map<Integer, Integer>) model.asMap().get("typePlaceCounts");
        if (existing != null) {
            return existing;
        }

        if (salleId != null) {
            String sql = "SELECT type_place_id, COUNT(*) AS nb FROM place WHERE salle_id = ? GROUP BY type_place_id";
            List<Map<String, Object>> rows = Salle.executeRawQuery(conn, sql, salleId);
            Map<Integer, Integer> counts = new HashMap<>();
            for (Map<String, Object> row : rows) {
                Object tpIdObj = row.get("type_place_id");
                Object nbObj = row.get("nb");
                if (tpIdObj != null && nbObj != null) {
                    counts.put(Integer.valueOf(tpIdObj.toString()), Integer.valueOf(nbObj.toString()));
                }
            }
            return counts;
        }

        Map<Integer, Integer> defaults = new HashMap<>();
        for (TypePlace tp : typePlaces) {
            defaults.put(tp.getId(), 0);
        }
        return defaults;
    }

    @PostMapping("/delete/{id}")
    public String supprimerSalle(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Salle salle = CGenericUtils.findOne(conn, Salle.class, criteria);

            if (salle == null) {
                redirectAttributes.addFlashAttribute("error", "Salle non trouvée");
                return "redirect:/salles";
            }

            CGenericUtils.delete(conn, salle);
            redirectAttributes.addFlashAttribute("message", "Salle supprimée avec succès");
            return "redirect:/salles";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
            return "redirect:/salles";
        }
    }

    @GetMapping("/view/{id}")
    public String voirSalle(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Salle salle = CGenericUtils.findOne(conn, Salle.class, criteria);

            if (salle == null) {
                redirectAttributes.addFlashAttribute("error", "Salle non trouvée");
                return "redirect:/salles";
            }

            Map<String, Object> cinemaCriteria = new HashMap<>();
            cinemaCriteria.put("id", salle.getCinemaId());
            Cinema cinema = CGenericUtils.findOne(conn, Cinema.class, cinemaCriteria);

            List<Place> places = CGenericUtils.find(conn,Place.class,Map.of("salle_id",salle.getId()),true);

            double revenueMax = calculateMaxRevenue(places);
            Map<String, Object> placesByType = calculatePlacesByType(places);

            model.addAttribute("salle", salle);
            model.addAttribute("cinema", cinema);
            model.addAttribute("places", places);
            model.addAttribute("revenueMax", revenueMax);
            model.addAttribute("placesByType", placesByType);
            return "salle/detailSalle";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement de la salle : " + e.getMessage());
            return "redirect:/salles";
        }
    }

    private double calculateMaxRevenue(List<Place> places) {
        double total = 0.0;
        for (Place place : places) {
            if (place.getTypePlace() != null && place.getTypePlace().getPrix() > 0) {
                total += place.getTypePlace().getPrix();
            }
        }
        return total;
    }

    private Map<String, Object> calculatePlacesByType(List<Place> places) {
        Map<Integer, Integer> counts = new HashMap<>();
        Map<Integer, TypePlace> types = new HashMap<>();
        
        for (Place place : places) {
            if (place.getTypePlaceId() != null) {
                counts.put(place.getTypePlaceId(), counts.getOrDefault(place.getTypePlaceId(), 0) + 1);
                if (place.getTypePlace() != null) {
                    types.put(place.getTypePlaceId(), place.getTypePlace());
                }
            }
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("counts", counts);
        result.put("types", types);
        return result;
    }
}

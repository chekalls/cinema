package mg.gestion.cinema.controller;

import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import mg.gestion.cinema.models.Cinema;
import mg.gestion.cinema.models.TypePlace;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;

@Controller
public class CinemaController {

    @Autowired
    private ConnexionService connexionService;

    @GetMapping("/type-place/form")
    public String typePlaceForm(Model model){
        if (!model.containsAttribute("typePlace")) {
            model.addAttribute("typePlace", new TypePlace());
        }
        return "typePlace/formTypePlace";
    }

    @GetMapping("/type-place/edit/{id}")
    public String editTypePlace(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try (var conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            TypePlace typePlace = CGenericUtils.findOne(conn, TypePlace.class, criteria);

            if (typePlace == null) {
                redirectAttributes.addFlashAttribute("error", "Type de place non trouvé");
                return "redirect:/type-place";
            }

            model.addAttribute("typePlace", typePlace);
            return "typePlace/formTypePlace";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement : " + e.getMessage());
            return "redirect:/type-place";
        }
    }

    @PostMapping("/type-place/save")
    public String saveTypePlace(@ModelAttribute TypePlace typePlace, RedirectAttributes redirectAttributes) {
        try (var conn = connexionService.getConnection()) {
            boolean isNew = typePlace.getId() == null;

            if (typePlace.getNom() == null || typePlace.getNom().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Le nom est obligatoire");
                redirectAttributes.addFlashAttribute("typePlace", typePlace);
                return "redirect:/type-place/form";
            }

            if (typePlace.getCode() == null || typePlace.getCode().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Le code est obligatoire");
                redirectAttributes.addFlashAttribute("typePlace", typePlace);
                return "redirect:/type-place/form";
            }

            if (typePlace.getPrix() <= 0) {
                redirectAttributes.addFlashAttribute("error", "Le prix doit être supérieur à 0");
                redirectAttributes.addFlashAttribute("typePlace", typePlace);
                return "redirect:/type-place/form";
            }

            CGenericUtils.save(conn, typePlace);

            String message = isNew ? "Type de place ajouté avec succès" : "Type de place modifié avec succès";
            redirectAttributes.addFlashAttribute("message", message);
            return "redirect:/type-place";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
            redirectAttributes.addFlashAttribute("typePlace", typePlace);
            return "redirect:/type-place/form";
        }
    }

    @GetMapping("/type-place")
    public String listTypePlace(Model model){
        try (var conn = connexionService.getConnection()) {
            List<TypePlace> typePlaces = CGenericUtils.find(conn, TypePlace.class, null);

            model.addAttribute(typePlaces);
            return "typePlace/listeTypePlace";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des types de place : " + e.getMessage());
            return "typePlace/listeTypePlace";
        }
    }

    @GetMapping("/cinemas")
    public String listeCinemas(@RequestParam(required = false) String search, Model model) {
        try (Connection conn = connexionService.getConnection()) {
            List<Cinema> cinemas;

            if (search != null && !search.trim().isEmpty()) {
                cinemas = CGenericUtils.search(conn, Cinema.class, search);
                model.addAttribute("search", search);
            } else {
                cinemas = CGenericUtils.find(conn, Cinema.class, new HashMap<>());
            }

            model.addAttribute("cinemas", cinemas);
            return "cinema/listeCinema";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des cinémas : " + e.getMessage());
            return "cinema/listeCinema";
        }
    }

    @GetMapping("/cinemas/form")
    public String formulaireCinema(Model model) {
        model.addAttribute("cinema", new Cinema());
        return "cinema/formulaireCinema";
    }

    @GetMapping("/cinemas/edit/{id}")
    public String editerCinema(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Cinema cinema = CGenericUtils.findOne(conn, Cinema.class, criteria);

            if (cinema == null) {
                redirectAttributes.addFlashAttribute("error", "Cinéma non trouvé");
                return "redirect:/cinemas";
            }

            model.addAttribute("cinema", cinema);
            return "cinema/formulaireCinema";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement du cinéma : " + e.getMessage());
            return "redirect:/cinemas";
        }
    }

    @PostMapping("/cinemas/save")
    public String enregistrerCinema(@ModelAttribute Cinema cinema, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            if (cinema.getNom() == null || cinema.getNom().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Le nom du cinéma est obligatoire");
                redirectAttributes.addFlashAttribute("cinema", cinema);
                return "redirect:/cinemas/form";
            }

            if (cinema.getAdresse() == null || cinema.getAdresse().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "L'adresse est obligatoire");
                redirectAttributes.addFlashAttribute("cinema", cinema);
                return "redirect:/cinemas/form";
            }

            if (cinema.getEmail() == null || cinema.getEmail().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "L'email est obligatoire");
                redirectAttributes.addFlashAttribute("cinema", cinema);
                return "redirect:/cinemas/form";
            }

            if (cinema.getId() == null) {
                cinema.setCreatedAt(LocalDateTime.now());
            } else {
                Map<String, Object> criteria = new HashMap<>();
                criteria.put("id", cinema.getId());
                Cinema existingCinema = CGenericUtils.findOne(conn, Cinema.class, criteria);
                if (existingCinema != null) {
                    cinema.setCreatedAt(existingCinema.getCreatedAt());
                }
                cinema.setUpdatedAt(LocalDateTime.now());
            }

            CGenericUtils.save(conn, cinema);

            String message = cinema.getId() != null
                    ? "Cinéma modifié avec succès"
                    : "Cinéma ajouté avec succès";
            redirectAttributes.addFlashAttribute("message", message);

            return "redirect:/cinemas";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
            redirectAttributes.addFlashAttribute("cinema", cinema);
            return "redirect:/cinemas/form";
        }
    }

    @PostMapping("/cinemas/delete/{id}")
    public String supprimerCinema(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Cinema cinema = CGenericUtils.findOne(conn, Cinema.class, criteria);

            if (cinema == null) {
                redirectAttributes.addFlashAttribute("error", "Cinéma non trouvé");
                return "redirect:/cinemas";
            }

            CGenericUtils.delete(conn, cinema);
            redirectAttributes.addFlashAttribute("message", "Cinéma supprimé avec succès");

            return "redirect:/cinemas";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
            return "redirect:/cinemas";
        }
    }

    @GetMapping("/cinemas/view/{id}")
    public String voirCinema(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Cinema cinema = CGenericUtils.findOne(conn, Cinema.class, criteria);

            if (cinema == null) {
                redirectAttributes.addFlashAttribute("error", "Cinéma non trouvé");
                return "redirect:/cinemas";
            }

            model.addAttribute("cinema", cinema);
            return "cinema/detailCinema";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement du cinéma : " + e.getMessage());
            return "redirect:/cinemas";
        }
    }
}

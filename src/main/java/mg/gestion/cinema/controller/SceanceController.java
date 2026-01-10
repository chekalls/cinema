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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import mg.gestion.cinema.models.Billet;
import mg.gestion.cinema.models.Film;
import mg.gestion.cinema.models.Place;
import mg.gestion.cinema.models.Salle;
import mg.gestion.cinema.models.Sceance;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;
import mg.gestion.cinema.utils.DataUtil;
import mg.gestion.cinema.utils.Page;

@Controller
@RequestMapping("/sceances")
public class SceanceController {
    @Autowired
    private ConnexionService connexionService;

    @GetMapping
    public String listeSceances(@RequestParam(required = false) String search,
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam(required = false, defaultValue = "10") int size,
            Model model) {
        try (Connection conn = connexionService.getConnection()) {
            Page<Sceance> sceancePage = CGenericUtils.searchPaginated(conn, Sceance.class, search, page, size, true);

            model.addAttribute("sceances", sceancePage.getContent());
            model.addAttribute("page", sceancePage.getNumber());
            model.addAttribute("size", sceancePage.getSize());
            model.addAttribute("total", sceancePage.getTotalElements());
            model.addAttribute("totalPages", sceancePage.getTotalPages());
            
            if (search != null && !search.trim().isEmpty()) {
                model.addAttribute("search", search);
            }

            return "sceance/listeSceance";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des séances : " + e.getMessage());
            return "sceance/listeSceance";
        }
    }

    @GetMapping("/form")
    public String formulaireSceance(Model model) {
        try (Connection conn = connexionService.getConnection()) {
            if (!model.containsAttribute("sceance")) {
                model.addAttribute("sceance", new Sceance());
            }
            List<Film> films = CGenericUtils.find(conn, Film.class, new HashMap<>());
            List<Salle> salles = CGenericUtils.find(conn, Salle.class, new HashMap<>());
            model.addAttribute("films", films);
            model.addAttribute("salles", salles);
            return "sceance/formulaireSceance";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement du formulaire : " + e.getMessage());
            return "sceance/formulaireSceance";
        }
    }

    @GetMapping("/edit/{id}")
    public String editerSceance(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Sceance sceance = CGenericUtils.findOne(conn, Sceance.class, criteria, true);

            if (sceance == null) {
                redirectAttributes.addFlashAttribute("error", "Séance non trouvée");
                return "redirect:/sceances";
            }

            List<Film> films = CGenericUtils.find(conn, Film.class, new HashMap<>());
            List<Salle> salles = CGenericUtils.find(conn, Salle.class, new HashMap<>());
            model.addAttribute("sceance", sceance);
            model.addAttribute("films", films);
            model.addAttribute("salles", salles);
            return "sceance/formulaireSceance";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement de la séance : " + e.getMessage());
            return "redirect:/sceances";
        }
    }

    @PostMapping("/save")
    public String enregistrerSceance(@ModelAttribute Sceance sceance, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            boolean isNew = sceance.getId() == null;

            if (sceance.getFilmId() == null) {
                redirectAttributes.addFlashAttribute("error", "Le film est obligatoire");
                redirectAttributes.addFlashAttribute("sceance", sceance);
                return "redirect:/sceances/form";
            }

            if (sceance.getSalleId() == null) {
                redirectAttributes.addFlashAttribute("error", "La salle est obligatoire");
                redirectAttributes.addFlashAttribute("sceance", sceance);
                return "redirect:/sceances/form";
            }

            if (sceance.getDebut() == null) {
                redirectAttributes.addFlashAttribute("error", "L'heure de début est obligatoire");
                redirectAttributes.addFlashAttribute("sceance", sceance);
                return "redirect:/sceances/form";
            }

            if (sceance.getFin() == null) {
                Film film = CGenericUtils.findOne(conn, Film.class, Map.of("id",sceance.getFilmId()));
                sceance.setFin(
                    sceance.getDebut().plusMinutes(film.getDureeMinutes())
                );
            }

            else if (sceance.getFin().isBefore(sceance.getDebut())) {
                redirectAttributes.addFlashAttribute("error", "L'heure de fin doit être après l'heure de début");
                redirectAttributes.addFlashAttribute("sceance", sceance);
                return "redirect:/sceances/form";
            }

            CGenericUtils.save(conn, sceance);

            String message = isNew ? "Séance ajoutée avec succès" : "Séance modifiée avec succès";
            redirectAttributes.addFlashAttribute("message", message);
            return "redirect:/sceances";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
            redirectAttributes.addFlashAttribute("sceance", sceance);
            return "redirect:/sceances/form";
        }
    }

    @PostMapping("/delete/{id}")
    public String supprimerSceance(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Sceance sceance = CGenericUtils.findOne(conn, Sceance.class, criteria, false);

            if (sceance == null) {
                redirectAttributes.addFlashAttribute("error", "Séance non trouvée");
                return "redirect:/sceances";
            }

            CGenericUtils.delete(conn, sceance);
            redirectAttributes.addFlashAttribute("message", "Séance supprimée avec succès");
            return "redirect:/sceances";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
            return "redirect:/sceances";
        }
    }

    @GetMapping("/view/{id}")
    public String voirSceance(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes,@RequestParam(name = "date",required = false) String date) {

        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Sceance sceance = CGenericUtils.findOne(conn, Sceance.class, criteria, true);
            
            LocalDateTime dateTime = (date!=null && !date.isEmpty()) ? DataUtil.convertStringToDateTime(date) : LocalDateTime.now();

            if (sceance == null) {
                redirectAttributes.addFlashAttribute("error", "Séance non trouvée");
                return "redirect:/sceances";
            }
            List<Billet> billets = CGenericUtils.find(conn, Billet.class, Map.of("seanceId", sceance.getId())); 
            int billetDisponible = sceance.getSalle().getCapaciteTotal() - billets.size();
            List<Place> places = sceance.getPlaces(conn, dateTime);


            model.addAttribute("disponible",billetDisponible);
            model.addAttribute("sceance", sceance);
            model.addAttribute("billets",billets);
            model.addAttribute("places",places);
            return "sceance/detailSceance";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement : " + e.getMessage());
            return "redirect:/sceances";
        }
    }
}

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
import mg.gestion.cinema.models.Seance;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;
import mg.gestion.cinema.utils.DataUtil;
import mg.gestion.cinema.utils.Page;

@Controller
@RequestMapping("/seances")
public class SeanceController {
    @Autowired
    private ConnexionService connexionService;

    @GetMapping
    public String listeSeances(@RequestParam(required = false) String search,
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam(required = false, defaultValue = "10") int size,
            Model model) {
        try (Connection conn = connexionService.getConnection()) {
            Page<Seance> seancePage = CGenericUtils.searchPaginated(conn, Seance.class, search, page, size, true);

            model.addAttribute("seances", seancePage.getContent());
            model.addAttribute("page", seancePage.getNumber());
            model.addAttribute("size", seancePage.getSize());
            model.addAttribute("total", seancePage.getTotalElements());
            model.addAttribute("totalPages", seancePage.getTotalPages());
            
            if (search != null && !search.trim().isEmpty()) {
                model.addAttribute("search", search);
            }

            return "seance/listeSeance";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des séances : " + e.getMessage());
            return "seance/listeSeance";
        }
    }

    @GetMapping("/form")
    public String formulaireSeance(Model model) {
        try (Connection conn = connexionService.getConnection()) {
            if (!model.containsAttribute("seance")) {
                model.addAttribute("seance", new Seance());
            }
            List<Film> films = CGenericUtils.find(conn, Film.class, new HashMap<>());
            List<Salle> salles = CGenericUtils.find(conn, Salle.class, new HashMap<>());
            model.addAttribute("films", films);
            model.addAttribute("salles", salles);
            return "seance/formulaireSeance";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement du formulaire : " + e.getMessage());
            return "seance/formulaireSeance";
        }
    }

    @GetMapping("/edit/{id}")
    public String editerSeance(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Seance seance = CGenericUtils.findOne(conn, Seance.class, criteria, true);

            if (seance == null) {
                redirectAttributes.addFlashAttribute("error", "Séance non trouvée");
                return "redirect:/seances";
            }

            List<Film> films = CGenericUtils.find(conn, Film.class, new HashMap<>());
            List<Salle> salles = CGenericUtils.find(conn, Salle.class, new HashMap<>());
            model.addAttribute("seance", seance);
            model.addAttribute("films", films);
            model.addAttribute("salles", salles);
            return "seance/formulaireSeance";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement de la séance : " + e.getMessage());
            return "redirect:/seances";
        }
    }

    @PostMapping("/save")
    public String enregistrerSeance(@ModelAttribute Seance seance, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            boolean isNew = seance.getId() == null;

            if (seance.getFilmId() == null) {
                redirectAttributes.addFlashAttribute("error", "Le film est obligatoire");
                redirectAttributes.addFlashAttribute("seance", seance);
                return "redirect:/seances/form";
            }

            if (seance.getSalleId() == null) {
                redirectAttributes.addFlashAttribute("error", "La salle est obligatoire");
                redirectAttributes.addFlashAttribute("seance", seance);
                return "redirect:/seances/form";
            }

            if (seance.getDebut() == null) {
                redirectAttributes.addFlashAttribute("error", "L'heure de début est obligatoire");
                redirectAttributes.addFlashAttribute("seance", seance);
                return "redirect:/seances/form";
            }

            if (seance.getFin() == null) {
                Film film = CGenericUtils.findOne(conn, Film.class, Map.of("id",seance.getFilmId()));
                seance.setFin(
                    seance.getDebut().plusMinutes(film.getDureeMinutes())
                );
            }

            else if (seance.getFin().isBefore(seance.getDebut())) {
                redirectAttributes.addFlashAttribute("error", "L'heure de fin doit être après l'heure de début");
                redirectAttributes.addFlashAttribute("seance", seance);
                return "redirect:/seances/form";
            }

            CGenericUtils.save(conn, seance);

            String message = isNew ? "Séance ajoutée avec succès" : "Séance modifiée avec succès";
            redirectAttributes.addFlashAttribute("message", message);
            return "redirect:/seances";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
            redirectAttributes.addFlashAttribute("seance", seance);
            return "redirect:/seances/form";
        }
    }

    @PostMapping("/delete/{id}")
    public String supprimerSeance(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Seance seance = CGenericUtils.findOne(conn, Seance.class, criteria, false);

            if (seance == null) {
                redirectAttributes.addFlashAttribute("error", "Séance non trouvée");
                return "redirect:/seances";
            }

            CGenericUtils.delete(conn, seance);
            redirectAttributes.addFlashAttribute("message", "Séance supprimée avec succès");
            return "redirect:/seances";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
            return "redirect:/seances";
        }
    }

    @GetMapping("/view/{id}")
    public String voirSeance(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes,@RequestParam(name = "date",required = false) String date) {

        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Seance seance = CGenericUtils.findOne(conn, Seance.class, criteria, true);
            
            LocalDateTime dateTime = (date!=null && !date.isEmpty()) ? DataUtil.convertStringToDateTime(date, "yyyy-MM-dd'T'HH:mm") : LocalDateTime.now();

            if (seance == null) {
                redirectAttributes.addFlashAttribute("error", "Séance non trouvée");
                return "redirect:/seances";
            }
            List<Billet> billets = seance.getBillets(conn, dateTime);
            int billetDisponible = seance.getSalle().getCapaciteTotal() - billets.size();
            List<Place> places = seance.getPlaces(conn, dateTime);


            model.addAttribute("disponible",billetDisponible);
            model.addAttribute("seance", seance);
            model.addAttribute("billets",billets);
            model.addAttribute("places",places);
            return "seance/detailSeance";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement : " + e.getMessage());
            return "redirect:/seances";
        }
    }
}

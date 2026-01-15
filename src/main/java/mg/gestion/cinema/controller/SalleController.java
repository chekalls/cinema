package mg.gestion.cinema.controller;

import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import mg.gestion.cinema.utils.DataUtil;
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

            List<Cinema> cinemas = CGenericUtils.find(conn, Cinema.class, new HashMap<>());
            Map<Integer, Cinema> cinemasById = new HashMap<>();
            for (Cinema cinema : cinemas) {
                if (cinema.getId() != null) {
                    cinemasById.put(cinema.getId(), cinema);
                }
            }

            model.addAttribute("salles", salles);
            model.addAttribute("cinemasById", cinemasById);
            return "salle/listeSalle";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des salles : " + e.getMessage());
            return "salle/listeSalle";
        }
    }

    @GetMapping("/form")
    public String formulaireSalle(Model model) {
        try (Connection conn = connexionService.getConnection()) {
            if (!model.containsAttribute("salle")) {
                model.addAttribute("salle", new Salle());
            }

            List<Cinema> cinemas = CGenericUtils.find(conn, Cinema.class, new HashMap<>());
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
            model.addAttribute("cinemas", cinemas);
            return "salle/formulaireSalle";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement de la salle : " + e.getMessage());
            return "redirect:/salles";
        }
    }

    @PostMapping("/save")
    public String enregistrerSalle(@ModelAttribute Salle salle, RedirectAttributes redirectAttributes) {
        try {
            boolean isNew = salle.getId() == null;

            if (salle.getCinemaId() == null) {
                redirectAttributes.addFlashAttribute("error", "Le cinéma est obligatoire");
                redirectAttributes.addFlashAttribute("salle", salle);
                return "redirect:/salles/form";
            }
            if (salle.getNumero() == null || salle.getNumero().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Le numéro de salle est obligatoire");
                redirectAttributes.addFlashAttribute("salle", salle);
                return "redirect:/salles/form";
            }
            if (salle.getDesignation() == null || salle.getDesignation().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "La désignation est obligatoire");
                redirectAttributes.addFlashAttribute("salle", salle);
                return "redirect:/salles/form";
            }

            if(salle.getNbColonnes()!=null && salle.getNbRangees()!=null){
                int capacite = salle.getNbColonnes() * salle.getNbRangees();
                salle.setCapaciteTotal(capacite);
            } 

            if (salle.getCapaciteTotal() == null || salle.getCapaciteTotal() <= 0) {
                redirectAttributes.addFlashAttribute("error", "La capacité totale doit être supérieure à 0");
                redirectAttributes.addFlashAttribute("salle", salle);
                return "redirect:/salles/form";
            }

            connexionService.executeInTransaction(conn ->{
                CGenericUtils.save(conn, salle);

                if(salle.getNbColonnes()==null || salle.getNbRangees()==null) {
                    salle.setAutoNbRangeesAndColonnes(conn);
                }

                //salle.insererPlace(salle.getNbColonnes(), salle.getNbRangees(), conn,);
            });

            String message = isNew ? "Salle ajoutée avec succès" : "Salle modifiée avec succès";
            redirectAttributes.addFlashAttribute("message", message);
            return "redirect:/salles";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
            redirectAttributes.addFlashAttribute("salle", salle);
            return "redirect:/salles/form";
        }
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

            model.addAttribute("salle", salle);
            model.addAttribute("cinema", cinema);
            model.addAttribute("places",places);
            model.addAttribute("nbrMaxGenerer",salle.getSoldeMaxGenererBySalle(conn, DataUtil.convertStringToDateTime("2024-01-15 09:00:00"), LocalDateTime.now(),1));
            return "salle/detailSalle";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement de la salle : " + e.getMessage());
            return "redirect:/salles";
        }
    }
}

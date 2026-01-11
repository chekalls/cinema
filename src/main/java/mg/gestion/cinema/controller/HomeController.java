package mg.gestion.cinema.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import mg.gestion.cinema.models.Film;
import mg.gestion.cinema.models.Reservation;
import mg.gestion.cinema.models.Salle;
import mg.gestion.cinema.models.Seance;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;

@Controller
public class HomeController {

    @Autowired
    private ConnexionService connexionService;

    @GetMapping("/")
    public String home(Model model) {
        try (var conn = connexionService.getConnection()) {
            long nbFilms = CGenericUtils.count(conn, Film.class, null);
            long nbSeances = CGenericUtils.count(conn, Seance.class, null);
            long reservations = CGenericUtils.count(conn, Reservation.class, null);
            long salles = CGenericUtils.count(conn, Salle.class, null);

            model.addAttribute("nbFilms", nbFilms);
            model.addAttribute("nbSeances", nbSeances);
            model.addAttribute("nbReservations", reservations);
            model.addAttribute("nbSalles", salles);
        } catch (Exception e) {

            e.printStackTrace();
            model.addAttribute("nbFilms", 0);
            model.addAttribute("nbSeances", 0);
            model.addAttribute("reservations", 0);
            model.addAttribute("salles", 0);

        }

        model.addAttribute("message", "Bienvenue sur le site de gestion du cinéma");
        return "index";
    }

    @GetMapping("/about")
    public String about(Model model) {
        model.addAttribute("title", "À propos");
        model.addAttribute("description", "Application de gestion de cinéma avec Spring Boot");
        return "about";
    }
}

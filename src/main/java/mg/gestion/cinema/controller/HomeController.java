package mg.gestion.cinema.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(Model model) {
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

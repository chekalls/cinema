package mg.gestion.cinema.controller;

import java.sql.Connection;
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

import mg.gestion.cinema.models.GenreFilm;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;

@Controller
@RequestMapping("/films/genres")
public class GenreFilmController {
    @Autowired
    private ConnexionService connexionService;

    @GetMapping
    public String listeGenreFilm(@RequestParam(required = false) String search, Model model) {
        try (Connection conn = connexionService.getConnection()) {
            List<GenreFilm> genres;
            if (search != null && !search.trim().isEmpty()) {
                genres = CGenericUtils.search(conn, GenreFilm.class, search);
                model.addAttribute("search", search);
            } else {
                genres = CGenericUtils.find(conn, GenreFilm.class, new HashMap<>());
            }
            model.addAttribute("genres", genres);
            return "genre/listeGenre";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des genres : " + e.getMessage());
            return "genre/listeGenre";
        }
    }

    @GetMapping("/form")
    public String formulaireGenre(Model model) {
        if (!model.containsAttribute("genre")) {
            model.addAttribute("genre", new GenreFilm());
        }
        return "genre/formulaireGenre";
    }

    @GetMapping("/edit/{id}")
    public String editerGenre(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            GenreFilm genre = CGenericUtils.findOne(conn, GenreFilm.class, criteria);

            if (genre == null) {
                redirectAttributes.addFlashAttribute("error", "Genre non trouvé");
                return "redirect:/films/genres";
            }

            model.addAttribute("genre", genre);
            return "genre/formulaireGenre";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement du genre : " + e.getMessage());
            return "redirect:/films/genres";
        }
    }

    @PostMapping("/save")
    public String enregistrerGenre(@ModelAttribute GenreFilm genre, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            boolean isNew = genre.getId() == null;

            if (genre.getNom() == null || genre.getNom().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Le nom du genre est obligatoire");
                redirectAttributes.addFlashAttribute("genre", genre);
                return "redirect:/films/genres/form";
            }

            if (genre.getCode() == null || genre.getCode().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Le code est obligatoire");
                redirectAttributes.addFlashAttribute("genre", genre);
                return "redirect:/films/genres/form";
            }

            CGenericUtils.save(conn, genre);
            String message = isNew ? "Genre ajouté avec succès" : "Genre modifié avec succès";
            redirectAttributes.addFlashAttribute("message", message);
            return "redirect:/films/genres";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
            redirectAttributes.addFlashAttribute("genre", genre);
            return "redirect:/films/genres/form";
        }
    }

    @PostMapping("/delete/{id}")
    public String supprimerGenre(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            GenreFilm genre = CGenericUtils.findOne(conn, GenreFilm.class, criteria);

            if (genre == null) {
                redirectAttributes.addFlashAttribute("error", "Genre non trouvé");
                return "redirect:/films/genres";
            }

            CGenericUtils.delete(conn, genre);
            redirectAttributes.addFlashAttribute("message", "Genre supprimé avec succès");
            return "redirect:/films/genres";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
            return "redirect:/films/genres";
        }
    }

    @GetMapping("/view/{id}")
    public String voirGenre(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            GenreFilm genre = CGenericUtils.findOne(conn, GenreFilm.class, criteria);

            if (genre == null) {
                redirectAttributes.addFlashAttribute("error", "Genre non trouvé");
                return "redirect:/films/genres";
            }

            model.addAttribute("genre", genre);
            return "genre/detailGenre";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement du genre : " + e.getMessage());
            return "redirect:/films/genres";
        }
    }
}
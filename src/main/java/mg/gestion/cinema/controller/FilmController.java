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

import mg.gestion.cinema.models.Film;
import mg.gestion.cinema.models.GenreFilm;
import mg.gestion.cinema.models.LGenreFilm;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;
import mg.gestion.cinema.utils.Page;

@Controller
@RequestMapping("/films")
public class FilmController {
    @Autowired
    private ConnexionService connexionService;

    @GetMapping("/form")
    public String formulaireFilm(Model model){
        try (Connection conn = connexionService.getConnection()) {
            if (!model.containsAttribute("film")) {
                model.addAttribute("film", new Film());
            }
            List<GenreFilm> genres = CGenericUtils.find(conn, GenreFilm.class, new HashMap<>());
            model.addAttribute("genres", genres);
            return "film/formulaireFilm";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement du formulaire : " + e.getMessage());
            return "film/formulaireFilm";
        }
    }

    @GetMapping
    public String listeFilms(@RequestParam(required = false) String search,
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam(required = false, defaultValue = "10") int size,
            Model model) {
        try (Connection conn = connexionService.getConnection()) {
            Page<Film> filmPage = CGenericUtils.searchPaginated(conn, Film.class, search, page, size, false);

            model.addAttribute("films", filmPage.getContent());
            model.addAttribute("page", filmPage.getNumber());
            model.addAttribute("size", filmPage.getSize());
            model.addAttribute("total", filmPage.getTotalElements());
            model.addAttribute("totalPages", filmPage.getTotalPages());
            
            if (search != null && !search.trim().isEmpty()) {
                model.addAttribute("search", search);
            }

            return "film/listeFilm";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des films : " + e.getMessage());
            return "film/listeFilm";
        }
    }

    @GetMapping("/edit/{id}")
    public String editerFilm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Film film = CGenericUtils.findOne(conn, Film.class, criteria, true);

            if (film == null) {
                redirectAttributes.addFlashAttribute("error", "Film non trouvé");
                return "redirect:/films";
            }

            List<GenreFilm> genres = CGenericUtils.find(conn, GenreFilm.class, new HashMap<>());
            model.addAttribute("film", film);
            model.addAttribute("genres", genres);
            return "film/formulaireFilm";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement du film : " + e.getMessage());
            return "redirect:/films";
        }
    }

    @PostMapping("/save")
    public String enregistrerFilm(@ModelAttribute Film film, 
            @RequestParam(required = false) List<Integer> genreIds,
            RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            boolean isNew = film.getId() == null;

            if (film.getTitre() == null || film.getTitre().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Le titre est obligatoire");
                redirectAttributes.addFlashAttribute("film", film);
                return "redirect:/films/form";
            }

            if (film.getDureeMinutes() != null && film.getDureeMinutes() <= 0) {
                redirectAttributes.addFlashAttribute("error", "La durée doit être positive");
                redirectAttributes.addFlashAttribute("film", film);
                return "redirect:/films/form";
            }

            CGenericUtils.save(conn, film);

            String deleteSql = "DELETE FROM l_genre_film WHERE film_id = ?";
            CGenericUtils.executeUpdate(conn, deleteSql, film.getId());

            if (genreIds != null && !genreIds.isEmpty()) {
                for (Integer genreId : genreIds) {
                    LGenreFilm lGenreFilm = new LGenreFilm();
                    lGenreFilm.setFilmId(film.getId());
                    lGenreFilm.setGenreFilmId(genreId);
                    CGenericUtils.save(conn, lGenreFilm);
                }
            }

            String message = isNew ? "Film ajouté avec succès" : "Film modifié avec succès";
            redirectAttributes.addFlashAttribute("message", message);
            return "redirect:/films";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
            redirectAttributes.addFlashAttribute("film", film);
            return "redirect:/films/form";
        }
    }

    @PostMapping("/delete/{id}")
    public String supprimerFilm(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Film film = CGenericUtils.findOne(conn, Film.class, criteria, false);

            if (film == null) {
                redirectAttributes.addFlashAttribute("error", "Film non trouvé");
                return "redirect:/films";
            }

            CGenericUtils.delete(conn, film);
            redirectAttributes.addFlashAttribute("message", "Film supprimé avec succès");
            return "redirect:/films";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
            return "redirect:/films";
        }
    }

    @GetMapping("/view/{id}")
    public String voirFilm(@PathVariable("id") Integer id, Model model, RedirectAttributes redirectAttributes) {
        try (Connection conn = connexionService.getConnection()) {
            Map<String, Object> criteria = new HashMap<>();
            criteria.put("id", id);
            Film film = CGenericUtils.findOne(conn, Film.class, criteria, true);

            if (film == null) {
                redirectAttributes.addFlashAttribute("error", "Film non trouvé");
                return "redirect:/films";
            }

            model.addAttribute("film", film);
            return "film/detailFilm";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du chargement : " + e.getMessage());
            return "redirect:/films";
        }
    }
}

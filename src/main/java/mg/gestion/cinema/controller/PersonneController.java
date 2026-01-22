package mg.gestion.cinema.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import mg.gestion.cinema.models.TypePersone;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;

@Controller
@RequestMapping("/personnes")
public class PersonneController {
    @Autowired
    private ConnexionService connexionService;

    @GetMapping("/types")
    public String listTypePersonnes(Model model) {
        try (var conn = connexionService.getConnection()) {
            List<TypePersone> typePersonnes = CGenericUtils.find(conn, TypePersone.class, null);
            model.addAttribute("typePersonnes", typePersonnes);
            return "personne/listTypePersonne";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des types de personnes : " + e.getMessage());
            model.addAttribute("typePersonnes", List.of());
            return "personne/listTypePersonne";
        }
    }

    @GetMapping("/types/form")
    public String typePersonneForm(@RequestParam(required = false) Integer id, Model model) {
        try (var conn = connexionService.getConnection()) {
            if (id != null) {
                TypePersone typePersonne = CGenericUtils.findOne(conn, TypePersone.class, Map.of("id", id));
                if (typePersonne == null) {
                    model.addAttribute("error", "Type de personne non trouvé");
                    return "redirect:/personnes/types";
                }
                model.addAttribute("typePersonne", typePersonne);
            }
            return "personne/formulaireTypePersonne";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement du formulaire : " + e.getMessage());
            return "redirect:/personnes/types";
        }
    }

    @PostMapping("/types/save")
    public String saveTypePersonne(
            @RequestParam(required = false) Integer id,
            @RequestParam("nom") String nom,
            RedirectAttributes redirectAttributes) {
        try (var conn = connexionService.getConnection()) {
            TypePersone typePersonne;
            
            if (id != null) {
                typePersonne = CGenericUtils.findOne(conn, TypePersone.class, Map.of("id", id));
                if (typePersonne == null) {
                    redirectAttributes.addFlashAttribute("error", "Type de personne non trouvé");
                    return "redirect:/personnes/types";
                }
            } else {
                typePersonne = new TypePersone();
            }
            
            typePersonne.setNom(nom);
            
            connexionService.executeInTransaction(connection -> {
                try {
                    CGenericUtils.save(connection, typePersonne);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            });
            
            redirectAttributes.addFlashAttribute("success", 
                id != null ? "Type de personne modifié avec succès" : "Type de personne créé avec succès");
            return "redirect:/personnes/types";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Erreur lors de l'enregistrement du type de personne : " + e.getMessage());
            return "redirect:/personnes/types/form" + (id != null ? "?id=" + id : "");
        }
    }

    @PostMapping("/types/delete")
    public String deleteTypePersonne(@RequestParam("id") Integer id, RedirectAttributes redirectAttributes) {
        try (var conn = connexionService.getConnection()) {
            TypePersone typePersonne = CGenericUtils.findOne(conn, TypePersone.class, Map.of("id", id));
            if (typePersonne == null) {
                redirectAttributes.addFlashAttribute("error", "Type de personne non trouvé");
                return "redirect:/personnes/types";
            }
            
            connexionService.executeInTransaction(connection -> {
                try {
                    CGenericUtils.delete(connection, typePersonne);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            });
            
            redirectAttributes.addFlashAttribute("success", "Type de personne supprimé avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Erreur lors de la suppression : " + e.getMessage());
        }
        return "redirect:/personnes/types";
    }
}

package mg.gestion.cinema.controller;

import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import mg.gestion.cinema.models.PrixBillet;
import mg.gestion.cinema.models.TypePersone;
import mg.gestion.cinema.models.TypePlace;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;

@Controller
@RequestMapping("/prix-billets")
public class PrixBilletController {
    @Autowired
    private ConnexionService connexionService;

    @GetMapping("")
    public String listPrixBillet(
            @RequestParam(required = false) Integer typePlaceId,
            @RequestParam(required = false) Integer typePersonneId,
            @RequestParam(required = false) Boolean actif,
            @RequestParam(required = false) Double prixMin,
            @RequestParam(required = false) Double prixMax,
            Model model) {
        try (var conn = connexionService.getConnection()) {
            StringBuilder sql = new StringBuilder(
                    "SELECT * FROM prix_billet WHERE 1=1");

            if (typePlaceId != null) {
                sql.append(" AND type_place_id = ").append(typePlaceId);
            }
            if (typePersonneId != null) {
                sql.append(" AND type_personne_id = ").append(typePersonneId);
            }
            if (actif != null) {
                sql.append(" AND actif = ").append(actif);
            }
            if (prixMin != null) {
                sql.append(" AND prix_reel >= ").append(prixMin);
            }
            if (prixMax != null) {
                sql.append(" AND prix_reel <= ").append(prixMax);
            }

            sql.append(" ORDER BY date_prix DESC, id DESC");

            List<PrixBillet> prixBillets = CGenericUtils.executeQuery(conn, PrixBillet.class, sql.toString());
            
            for (PrixBillet pb : prixBillets) {
                if (pb.getTypePlaceId() != null) {
                    TypePlace tp = CGenericUtils.findOne(conn, TypePlace.class, Map.of("id", pb.getTypePlaceId()));
                    pb.setTypePlace(tp);
                }
                if (pb.getTypePersonneId() != null) {
                    TypePersone tper = CGenericUtils.findOne(conn, TypePersone.class, Map.of("id", pb.getTypePersonneId()));
                    pb.setTypePersone(tper);
                }
            }

            List<TypePlace> typePlaces = CGenericUtils.executeQuery(conn, TypePlace.class, "SELECT * FROM type_place ORDER BY nom");
            List<TypePersone> typePersonnes = CGenericUtils.executeQuery(conn, TypePersone.class, "SELECT * FROM type_personne ORDER BY nom");

            model.addAttribute("prixBillets", prixBillets);
            model.addAttribute("typePlaces", typePlaces);
            model.addAttribute("typePersonnes", typePersonnes);
            model.addAttribute("typePlaceId", typePlaceId);
            model.addAttribute("typePersonneId", typePersonneId);
            model.addAttribute("actif", actif);
            model.addAttribute("prixMin", prixMin);
            model.addAttribute("prixMax", prixMax);

            return "prixBillet/list";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Erreur lors du chargement des prix: " + e.getMessage());
            return "prixBillet/list";
        }
    }

    @GetMapping("/form")
    public String showForm(@RequestParam(required = false) Integer id, Model model) {
        try (var conn = connexionService.getConnection()) {
            PrixBillet prixBillet;
            if (id != null) {
                prixBillet = CGenericUtils.findOne(conn, PrixBillet.class, Map.of("id", id));
                if (prixBillet == null) {
                    model.addAttribute("error", "Prix billet non trouvé");
                    return "redirect:/prix-billets";
                }
                // Charger les relations
                if (prixBillet.getTypePlaceId() != null) {
                    TypePlace tp = CGenericUtils.findOne(conn, TypePlace.class, Map.of("id", prixBillet.getTypePlaceId()));
                    prixBillet.setTypePlace(tp);
                }
                if (prixBillet.getTypePersonneId() != null) {
                    TypePersone tper = CGenericUtils.findOne(conn, TypePersone.class, Map.of("id", prixBillet.getTypePersonneId()));
                    prixBillet.setTypePersone(tper);
                }
            } else {
                prixBillet = new PrixBillet();
                prixBillet.setActif(true);
            }

            // Charger les types de places et personnes
            List<TypePlace> typePlaces = CGenericUtils.executeQuery(conn, TypePlace.class, "SELECT * FROM type_place ORDER BY nom");
            List<TypePersone> typePersonnes = CGenericUtils.executeQuery(conn, TypePersone.class, "SELECT * FROM type_personne ORDER BY nom");

            model.addAttribute("prixBillet", prixBillet);
            model.addAttribute("typePlaces", typePlaces);
            model.addAttribute("typePersonnes", typePersonnes);
            model.addAttribute("isEdit", id != null);

            return "prixBillet/form";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Erreur lors du chargement du formulaire: " + e.getMessage());
            return "redirect:/prix-billets";
        }
    }

    @PostMapping("/save")
    public String save(
            @RequestParam(required = false) Integer id,
            @RequestParam Integer typePlaceId,
            @RequestParam(required = false) Integer typePersonneId,
            @RequestParam double prixBase,
            @RequestParam(defaultValue = "0") double reduction,
            @RequestParam boolean actif,
            RedirectAttributes redirectAttributes) {
        try (var conn = connexionService.getConnection()) {
            PrixBillet prixBillet;
            boolean isNew = (id == null);

            if (isNew) {
                prixBillet = new PrixBillet();
                prixBillet.setDatePrix(LocalDateTime.now());
            } else {
                prixBillet = CGenericUtils.findOne(conn, PrixBillet.class, Map.of("id", id));
                if (prixBillet == null) {
                    redirectAttributes.addFlashAttribute("error", "Prix billet non trouvé");
                    return "redirect:/prix-billets";
                }
            }

            prixBillet.setTypePlaceId(typePlaceId);
            prixBillet.setTypePersonneId(typePersonneId);
            prixBillet.setPrixBase(prixBase);
            prixBillet.setReduction(reduction);
            prixBillet.setPrixReel(prixBase - (prixBase * reduction / 100));
            prixBillet.setActif(actif);

            CGenericUtils.save(conn, prixBillet);
            
            if (isNew) {
                redirectAttributes.addFlashAttribute("success", "Prix billet ajouté avec succès");
            } else {
                redirectAttributes.addFlashAttribute("success", "Prix billet modifié avec succès");
            }

            return "redirect:/prix-billets";
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement: " + e.getMessage());
            return "redirect:/prix-billets/form" + (id != null ? "?id=" + id : "");
        }
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try (var conn = connexionService.getConnection()) {
            PrixBillet prixBillet = CGenericUtils.findOne(conn, PrixBillet.class, Map.of("id", id));
            if (prixBillet == null) {
                redirectAttributes.addFlashAttribute("error", "Prix billet non trouvé");
                return "redirect:/prix-billets";
            }

            CGenericUtils.delete(conn, prixBillet);
            redirectAttributes.addFlashAttribute("success", "Prix billet supprimé avec succès");

            return "redirect:/prix-billets";
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression: " + e.getMessage());
            return "redirect:/prix-billets";
        }
    }

    @PostMapping("/toggle-actif/{id}")
    public String toggleActif(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try (var conn = connexionService.getConnection()) {
            PrixBillet prixBillet = CGenericUtils.findOne(conn, PrixBillet.class, Map.of("id", id));
            if (prixBillet == null) {
                redirectAttributes.addFlashAttribute("error", "Prix billet non trouvé");
                return "redirect:/prix-billets";
            }

            prixBillet.setActif(!prixBillet.isActif());
            CGenericUtils.save(conn, prixBillet);

            String status = prixBillet.isActif() ? "activé" : "désactivé";
            redirectAttributes.addFlashAttribute("success", "Prix billet " + status + " avec succès");

            return "redirect:/prix-billets";
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur lors du changement de statut: " + e.getMessage());
            return "redirect:/prix-billets";
        }
    }

    @GetMapping("/historique")
    public String historique(
            @RequestParam(required = false) Integer typePlaceId,
            @RequestParam(required = false) Integer typePersonneId,
            Model model) {
        try (var conn = connexionService.getConnection()) {
            StringBuilder sql = new StringBuilder(
                    "SELECT * FROM prix_billet WHERE 1=1");

            if (typePlaceId != null) {
                sql.append(" AND type_place_id = ").append(typePlaceId);
            }
            if (typePersonneId != null) {
                sql.append(" AND type_personne_id = ").append(typePersonneId);
            }

            sql.append(" ORDER BY date_prix DESC, id DESC");

            List<PrixBillet> prixBillets = CGenericUtils.executeQuery(conn, PrixBillet.class, sql.toString());
            
            for (PrixBillet pb : prixBillets) {
                if (pb.getTypePlaceId() != null) {
                    TypePlace tp = CGenericUtils.findOne(conn, TypePlace.class, Map.of("id", pb.getTypePlaceId()));
                    pb.setTypePlace(tp);
                }
                if (pb.getTypePersonneId() != null) {
                    TypePersone tper = CGenericUtils.findOne(conn, TypePersone.class, Map.of("id", pb.getTypePersonneId()));
                    pb.setTypePersone(tper);
                }
            }

            List<TypePlace> typePlaces = CGenericUtils.executeQuery(conn, TypePlace.class, "SELECT * FROM type_place ORDER BY nom");
            List<TypePersone> typePersonnes = CGenericUtils.executeQuery(conn, TypePersone.class, "SELECT * FROM type_personne ORDER BY nom");

            model.addAttribute("prixBillets", prixBillets);
            model.addAttribute("typePlaces", typePlaces);
            model.addAttribute("typePersonnes", typePersonnes);
            model.addAttribute("typePlaceId", typePlaceId);
            model.addAttribute("typePersonneId", typePersonneId);

            return "prixBillet/historique";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Erreur lors du chargement de l'historique: " + e.getMessage());
            return "prixBillet/historique";
        }
    }
}   
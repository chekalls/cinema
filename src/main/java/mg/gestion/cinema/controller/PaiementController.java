package mg.gestion.cinema.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import mg.gestion.cinema.models.PaiementMethode;
import mg.gestion.cinema.models.Reservation;
import mg.gestion.cinema.models.Statut;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;

@Controller
@RequestMapping("/paiements")
public class PaiementController {
    @Autowired
    private ConnexionService connexionService;

    @GetMapping("/form")
    public String paiementForm(Model model) {
        try (var conn = connexionService.getConnection()) {
            List<PaiementMethode> methodes = CGenericUtils.find(conn, PaiementMethode.class, Map.of("actif","TRUE"));
            Statut statutReservation = CGenericUtils.findOne(conn, Statut.class, Map.of("code","PANIER"));            
            List<Reservation> reservations = CGenericUtils.find(conn, Reservation.class, Map.of("statut_id",statutReservation.getId()));

            model.addAttribute("reservations",reservations);
            model.addAttribute("methodes",methodes);
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement du formulaire : " + e.getMessage());
            return "paiement/formulairePaiement";
        }
        return "paiement/formulairePaiement";
    }
}
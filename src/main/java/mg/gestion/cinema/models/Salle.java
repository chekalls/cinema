package mg.gestion.cinema.models;

import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;
import mg.gestion.cinema.utils.CGenericUtils;

@Table(name = "salle")
public class Salle extends BaseEntity {
    @PrimaryKey
    private Integer id;

    @Column(name = "cinema_id")
    private Integer cinemaId;

    @Column(name = "numero")
    private String numero;

    @Column(name = "designation")
    private String designation;

    @Column(name = "capacite_total")
    private Integer capaciteTotal;

    @Column(name = "nb_rangees")
    private Integer nbRangees;

    @Column(name = "nb_colonnes")
    private Integer nbColonnes;

    @Column(ignore = true)
    private Integer nbrVip;
    @Column(ignore = true)
    private Integer nbrStanart;

    public void setAutoNbRangeesAndColonnes(Connection conn) {
        if (this.capaciteTotal == null || this.capaciteTotal <= 0) {
            throw new IllegalArgumentException("La capacité totale doit être un entier positif");
        }

        int tailleRang = (int) Math.sqrt(this.capaciteTotal);
        int tailleCol = (int) Math.ceil((double) this.capaciteTotal / tailleRang);

        this.nbRangees = tailleRang;
        this.nbColonnes = tailleCol;
    }

    public void insererPlace(int tailleCol, int tailleRang, Connection conn){
        if (this.id == null) {
            throw new IllegalStateException("La salle doit être sauvegardée avant de créer les places");
        }

        Statut statutPlace = CGenericUtils.findOne(conn, Statut.class, Map.of("code","DISPO","categorie","PLACE"));

        for (int rang = 1; rang <= tailleRang; rang++) {
            for (int col = 1; col <= tailleCol; col++) {
                Place place = new Place();
                place.setSalleId(this.id);
                place.setRang(rang);
                place.setCol(col);
                place.setStatut(statutPlace.getId());
                CGenericUtils.save(conn, place);
            }
        }
    }
    public double getSoldeMaxGenererBySalle(Connection conn, LocalDateTime dateDebut, LocalDateTime dateFin, int idFilm) {
        String sql = "SELECT * FROM seance WHERE film_id = ? AND salle_id = ? AND fin >= ? AND fin < ?";
        List<Seance> seanceList = CGenericUtils.executeQuery(conn, Seance.class, sql, idFilm, this.getId(), dateDebut, dateFin);
        List<Double> prixBySeance = new ArrayList<>();
        for (Seance seance : seanceList) {
            prixBySeance.add(seance.getSoldeGenerer(conn));
        }
        return prixBySeance.stream()
                .max(Double::compare)
                .orElse(1.0);
        // Retourne le maximum ou 0 si la liste est vide

    }




    public void insererPlace(int tailleCol, int tailleRang, Connection conn,int idTypeSalle){
        if (this.id == null) {
            throw new IllegalStateException("La salle doit être sauvegardée avant de créer les places");
        }

        Statut statutPlace = CGenericUtils.findOne(conn, Statut.class, Map.of("code","DISPO","categorie","PLACE"));
        TypePlace typePlace=CGenericUtils.findOne(conn, TypePlace.class, Map.of("id",idTypeSalle));

        for (int rang = 1; rang <= tailleRang; rang++) {
            for (int col = 1; col <= tailleCol; col++) {
                Place place = new Place();
                place.setSalleId(this.id);
                place.setRang(rang);
                place.setCol(col);
                place.setTypePlaceId(idTypeSalle);
                place.setStatut(statutPlace.getId());
                CGenericUtils.save(conn, place);
            }
        }
    }

    public double getValeurMaexGenerer(Connection conn){
        List<Place> placeList=CGenericUtils.find(conn, Place.class, Map.of("salle_id",this.getId()),true);
        double resutt=0;
        for (Place place : placeList) {
            resutt +=place.getTypePlace().getPrix();
        }
        return resutt;
    }



    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getCinemaId() {
        return cinemaId;
    }

    public void setCinemaId(Integer cinemaId) {
        this.cinemaId = cinemaId;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public Integer getCapaciteTotal() {
        return capaciteTotal;
    }

    public void setCapaciteTotal(Integer capaciteTotal) {
        this.capaciteTotal = capaciteTotal;
    }

    public Integer getNbRangees() {
        return nbRangees;
    }

    public void setNbRangees(Integer nbRangees) {
        this.nbRangees = nbRangees;
    }

    public Integer getNbColonnes() {
        return nbColonnes;
    }

    public void setNbColonnes(Integer nbColonnes) {
        this.nbColonnes = nbColonnes;
    }

}

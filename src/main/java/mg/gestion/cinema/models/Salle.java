package mg.gestion.cinema.models;

import java.sql.Connection;
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

    public void setAutoNbRangeesAndColonnes(Connection conn) {
        if (this.capaciteTotal == null || this.capaciteTotal <= 0) {
            throw new IllegalArgumentException("La capacité totale doit être un entier positif");
        }

        int tailleRang = (int) Math.sqrt(this.capaciteTotal);
        int tailleCol = (int) Math.ceil((double) this.capaciteTotal / tailleRang);

        this.nbRangees = tailleRang;
        this.nbColonnes = tailleCol;
    }

    public void insererPlace(int tailleCol, int tailleRang, Connection conn) {
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

package mg.gestion.cinema.models;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;

@Table(name = "paiement_methode")
public class PaiementMethode extends BaseEntity {
    @PrimaryKey
    private Integer id;
    @Column
    private String code;
    @Column
    private String nom;
    @Column
    private boolean actif;
    @Column(name = "frais_pourcent")
    private double fraisPourcent;
    @Column
    private int ordre;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public boolean isActif() {
        return actif;
    }

    public void setActif(boolean actif) {
        this.actif = actif;
    }

    public double getFraisPourcent() {
        return fraisPourcent;
    }

    public void setFraisPourcent(double fraisPourcent) {
        this.fraisPourcent = fraisPourcent;
    }

    public int getOrdre() {
        return ordre;
    }

    public void setOrdre(int ordre) {
        this.ordre = ordre;
    }
}

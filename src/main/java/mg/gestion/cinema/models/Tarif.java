package mg.gestion.cinema.models;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;

@Table(name = "tarif")
public class Tarif extends BaseEntity{
    @PrimaryKey
    private Integer id;
    @Column
    private String nom;
    @Column(name = "prix_base")
    private double prixBase;
    @Column(name = "type_tarif_id")
    private Integer typeTarifId;
    @Column
    private boolean actif;
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getNom() {
        return nom;
    }
    public void setNom(String nom) {
        this.nom = nom;
    }
    public double getPrixBase() {
        return prixBase;
    }
    public void setPrixBase(double prixBase) {
        this.prixBase = prixBase;
    }
    public Integer getTypeTarifId() {
        return typeTarifId;
    }
    public void setTypeTarifId(Integer typeTarifId) {
        this.typeTarifId = typeTarifId;
    }
    public boolean isActif() {
        return actif;
    }
    public void setActif(boolean actif) {
        this.actif = actif;
    }
}
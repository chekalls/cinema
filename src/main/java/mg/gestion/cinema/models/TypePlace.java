package mg.gestion.cinema.models;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;
@Table(name = "type_place")
public class TypePlace extends BaseEntity{
    @PrimaryKey
    private Integer id;
    @Column
    private double prix;
    @Column
    private String nom;
    @Column
    private String code;
    @Column
    private String desce;

    public Integer getId() {
        return id;
    }

    public double getPrix() {
        return prix;
    }

    public String getNom() {
        return nom;
    }

    public String getCode() {
        return code;
    }

    public String getDesce() {
        return desce;
    }
}

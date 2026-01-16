package mg.gestion.cinema.models;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;

@Table(name="type_place_prix")
public class TypePlacePrix extends BaseEntity{
    @PrimaryKey
    private Integer id;
    @Column
    private double prix_place;
    @Column(name="type_place_id")
    private Integer type_place;
    @Column(name="type_personne_id")
    private Integer typePersonne;

    public Integer getId() {
        return id;
    }

    public double getPrix_place() {
        return prix_place;
    }

    public Integer getType_place() {
        return type_place;
    }

    public Integer getTypePersonne() {
        return typePersonne;
    }
}

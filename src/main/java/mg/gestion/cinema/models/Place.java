package mg.gestion.cinema.models;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;

@Table(name = "place")
public class Place extends BaseEntity {
    @PrimaryKey
    private Integer id;
    @Column
    private int rang;
    @Column
    private int col;
    @Column(name = "type_place_id")
    private Integer typePlaceId;
    @Column
    private Integer statut;
    @Column
    private Integer salleId;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public int getRang() {
        return rang;
    }

    public void setRang(int rang) {
        this.rang = rang;
    }

    public int getCol() {
        return col;
    }

    public void setCol(int col) {
        this.col = col;
    }

    public Integer getTypePlaceId() {
        return typePlaceId;
    }

    public void setTypePlaceId(Integer typePlaceId) {
        this.typePlaceId = typePlaceId;
    }

    public Integer getSalleId() {
        return salleId;
    }

    public void setSalleId(Integer salleId) {
        this.salleId = salleId;
    }

    public Integer getStatut() {
        return statut;
    }

    public void setStatut(Integer statut) {
        this.statut = statut;
    }
}

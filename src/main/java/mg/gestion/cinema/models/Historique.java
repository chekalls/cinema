package mg.gestion.cinema.models;

import java.time.LocalDateTime;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;

@Table(name = "historique")
public class Historique extends BaseEntity{
    @PrimaryKey
    private Integer id;
    @Column(name = "table_name")
    private String tableName;
    @Column(name = "cle_primaire")
    private Integer clePrimaire;
    @Column
    private Integer statut;
    @Column(name = "date_modification")
    private LocalDateTime dateModification;
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getStatut() {
        return statut;
    }
    public void setStatut(Integer statut) {
        this.statut = statut;
    }
    public LocalDateTime getDateModification() {
        return dateModification;
    }
    public void setDateModification(LocalDateTime dateModification) {
        this.dateModification = dateModification;
    }
    public Integer getClePrimaire() {
        return clePrimaire;
    }
    public void setClePrimaire(Integer clePrimaire) {
        this.clePrimaire = clePrimaire;
    }
    public String getTableName() {
        return tableName;
    }
    public void setTableName(String tableName) {
        this.tableName = tableName;
    }
}

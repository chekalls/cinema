package mg.gestion.cinema.models;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.Generated;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;

import java.time.LocalDateTime;

@Table(name = "billet")
public class Billet {
    @PrimaryKey
    private Integer id;
    @Column
    private Integer seance_id;
    @Column
    private Double prix_paye;
    @Column
    private String type_tarif;
    @Column
    private String statut;
    @Column
    @Generated
    private LocalDateTime date_vente;

    public Billet(int id, int seance_id, Double prix_paye, String type_tarif, String statut, LocalDateTime date_vente) {
        this.id = id;
        this.seance_id = seance_id;
        this.prix_paye = prix_paye;
        this.type_tarif = type_tarif;
        this.statut = statut;
        this.date_vente = date_vente;
    }

    public int getId() {
        return id;
    }

    public int getSeance_id() {
        return seance_id;
    }

    public Double getPrix_paye() {
        return prix_paye;
    }

    public String getType_tarif() {
        return type_tarif;
    }

    public String getStatut() {
        return statut;
    }

    public LocalDateTime getDate_vente() {
        return date_vente;
    }

}

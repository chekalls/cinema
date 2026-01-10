package mg.gestion.cinema.models;

import java.time.LocalDateTime;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;

@Table(name = "billet")
public class Billet extends BaseEntity{
    @PrimaryKey
    private Integer id;
    @Column(name = "seance_id")
    private Integer seanceId;
    @Column(name="place_id")
    private Integer placeId;
    @Column(name = "tarif_id")
    private Integer tarifId;
    @Column(name = "prix_reel")
    private double prixReel;
    @Column(name = "date_utilisation")
    private LocalDateTime dateUtilisation;
    @Column
    private Integer statut;
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public Integer getSeanceId() {
        return seanceId;
    }
    public void setSeanceId(Integer seanceId) {
        this.seanceId = seanceId;
    }
    public Integer getPlaceId() {
        return placeId;
    }
    public void setPlaceId(Integer placeId) {
        this.placeId = placeId;
    }
    public Integer getTarifId() {
        return tarifId;
    }
    public void setTarifId(Integer tarifId) {
        this.tarifId = tarifId;
    }
    public double getPrixReel() {
        return prixReel;
    }
    public void setPrixReel(double prixReel) {
        this.prixReel = prixReel;
    }
    public LocalDateTime getDateUtilisation() {
        return dateUtilisation;
    }
    public void setDateUtilisation(LocalDateTime dateUtilisation) {
        this.dateUtilisation = dateUtilisation;
    }
    public Integer getStatut() {
        return statut;
    }
    public void setStatut(Integer statut) {
        this.statut = statut;
    }
}

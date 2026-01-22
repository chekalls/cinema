package mg.gestion.cinema.models;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;
import java.time.LocalDateTime;

@Table(name = "prix_billet")
public class PrixBillet extends BaseEntity{
    @PrimaryKey
    private Integer id;
    @Column(name = "type_place_id")
    private Integer typePlaceId;
    @Column(name = "type_personne_id")
    private Integer typePersonneId;
    @Column(name = "prix_base")
    private double prixBase;
    @Column(name = "reduction")
    private double reduction;
    @Column(name = "prix_reel")
    private double prixReel;
    @Column(name = "date_prix")
    private LocalDateTime datePrix;
    @Column(name = "actif")
    private boolean actif;
    
    @Column(ignore = true)
    private TypePlace typePlace;
    @Column(ignore = true)
    private TypePersone typePersone;
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public Integer getTypePlaceId() {
        return typePlaceId;
    }
    public void setTypePlaceId(Integer typePlaceId) {
        this.typePlaceId = typePlaceId;
    }
    public Integer getTypePersonneId() {
        return typePersonneId;
    }
    public void setTypePersonneId(Integer typePersonneId) {
        this.typePersonneId = typePersonneId;
    }
    public double getPrixBase() {
        return prixBase;
    }
    public void setPrixBase(double prixBase) {
        this.prixBase = prixBase;
    }
    public double getReduction() {
        return reduction;
    }
    public void setReduction(double reduction) {
        this.reduction = reduction;
    }
    public double getPrixReel() {
        return prixReel;
    }
    public void setPrixReel(double prixReel) {
        this.prixReel = prixReel;
    }
    public LocalDateTime getDatePrix() {
        return datePrix;
    }
    public void setDatePrix(LocalDateTime datePrix) {
        this.datePrix = datePrix;
    }
    public boolean isActif() {
        return actif;
    }
    public void setActif(boolean actif) {
        this.actif = actif;
    }
    
    public TypePlace getTypePlace() {
        return typePlace;
    }
    public void setTypePlace(TypePlace typePlace) {
        this.typePlace = typePlace;
    }
    public TypePersone getTypePersone() {
        return typePersone;
    }
    public void setTypePersone(TypePersone typePersone) {
        this.typePersone = typePersone;
    }
}

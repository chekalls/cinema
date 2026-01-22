package mg.gestion.cinema.models;

import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.Map;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.Loader;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;
import mg.gestion.cinema.utils.CGenericUtils;

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
    @Column(name = "date_achat")
    private LocalDateTime dateAchat;
    @Column(name = "reservation_id")
    private Integer reservationId;
    @Column
    private Integer statut;

    @Column(ignore = true)
    private Statut statutDetails;

    @Column(ignore = true)
    private Seance seance;

    @Column(ignore = true)
    private Place place;

    @Column(ignore = true)
    private Tarif tarif;

    @Column(ignore = true)
    private TypePersone typePersone;

    @Column(ignore = true)
    private double prixRemise = 0;

    @Column(ignore = true)
    private TypePlace typePlace;

    @Column(name="type_personne_id")
    private Integer type_personne;

    public double getPrixWithReduction(Connection conn){
        Place place1 = CGenericUtils.findOne(conn, Place.class, Map.of("id",this.getPlaceId()),true);
        TypePlacePrix typePlacePrix = CGenericUtils.findOne(conn, TypePlacePrix.class, Map.of("type_place_id",place1.getTypePlaceId(),"type_personne_id",this.getType_personne()));
        if(typePlacePrix.getParentId()!=null){
            TypePlacePrix parentTypePlacePrix = CGenericUtils.findOne(conn, TypePlacePrix.class, Map.of("id",typePlacePrix.getParentId()));
            double reduction = typePlacePrix.getReduction();
            double parentPrix = parentTypePlacePrix.getPrixPlace();
            return parentPrix - (parentPrix * reduction / 100);
        }
        return typePlacePrix.getPrixPlace();
    }

    public double getActualPrixBillet(Connection conn){
        Place place1 = CGenericUtils.findOne(conn, Place.class, Map.of("id",this.getPlaceId()),true);
        TypePlacePrix typePlacePrix = CGenericUtils.findOne(conn, TypePlacePrix.class, Map.of("type_place_id",place1.getTypePlaceId(),"type_personne_id",this.getType_personne()));
        if (typePlacePrix==null){
            return place1.getTypePlace().getPrix();
        }
        return typePlacePrix.getPrixPlace();

    }

    @Loader
    public void loadAttributes(Connection conn){
        if(this.statut != null){
            this.statutDetails = mg.gestion.cinema.utils.CGenericUtils.findOne(conn,Statut.class,Map.of("id",this.statut));
        }
        if(this.seanceId != null){
            this.seance = mg.gestion.cinema.utils.CGenericUtils.findOne(conn,Seance.class,Map.of("id",this.seanceId),true);
        }
        if(this.placeId != null){
            this.place = mg.gestion.cinema.utils.CGenericUtils.findOne(conn,Place.class,Map.of("id",this.placeId));
            this.typePlace = CGenericUtils.findOne(conn, TypePlace.class, Map.of("id",place.getTypePlaceId()),false);
        }
        if(this.tarifId != null){
            this.tarif = mg.gestion.cinema.utils.CGenericUtils.findOne(conn,Tarif.class,Map.of("id",this.tarifId));
        }
        if(this.type_personne != null){
            this.typePersone = CGenericUtils.findOne(conn, TypePersone.class, Map.of("id",this.getType_personne()));
            this.prixRemise = this.getPrixWithReduction(conn);
        }
    }

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
    public LocalDateTime getDateAchat() {
        return dateAchat;
    }
    public void setDateAchat(LocalDateTime dateAchat) {
        this.dateAchat = dateAchat;
    }

   public Integer getReservationId() {
    return reservationId;
   }
   public void setReservationId(Integer reservationId) {
    this.reservationId = reservationId;
   }

   public Statut getStatutDetails() {
    return statutDetails;
   }

   public void setStatutDetails(Statut statutDetails) {
    this.statutDetails = statutDetails;
   }

   public Seance getSeance() {
    return seance;
   }

   public void setSeance(Seance seance) {
    this.seance = seance;
   }

   public Place getPlace(Connection conn){
    if(this.place == null && this.placeId != null){
        this.place = mg.gestion.cinema.utils.CGenericUtils.findOne(conn,Place.class,Map.of("id",this.placeId));
    }
    return place;
   }

   public Place getPlace() {
    return place;
   }

   public void setPlace(Place place) {
    this.place = place;
   }

   public Tarif getTarif() {
    return tarif;
   }

   public void setTarif(Tarif tarif) {
    this.tarif = tarif;
   }

    public Integer getType_personne() {
        return type_personne;
    }

    public void setType_personne(Integer type_personne) {
        this.type_personne = type_personne;
    }

    public TypePersone getTypePersone() {
        return typePersone;
    }

    public void setTypePersone(TypePersone typePersone) {
        this.typePersone = typePersone;
    }

    public double getPrixRemise() {
        return prixRemise;
    }

    public void setPrixRemise(double prixRemise) {
        this.prixRemise = prixRemise;
    }

    public TypePlace getTypePlace() {
        return typePlace;
    }

    public void setTypePlace(TypePlace typePlace) {
        this.typePlace = typePlace;
    }
}


package mg.gestion.cinema.models;

import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.Map;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.Loader;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;
import mg.gestion.cinema.utils.CGenericUtils;

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
    @Column(name = "date_modification")
    private LocalDateTime dateModification;

    @Column(ignore = true)
    private TypePlace typePlace;

    @Column(ignore = true)
    private Statut statutDetails;

    public Statut getStatutByDate(LocalDateTime dateTime, Connection conn) {
        String sql = "SELECT * FROM historique WHERE table_name = 'place' AND date_modification <= ? AND cle_primaire = ? ORDER BY date_modification DESC LIMIT 1";
        Historique historique = CGenericUtils.executeQueryOne(conn, Historique.class, sql, dateTime,this.getId());
        Statut statut = null;
        if (historique != null) {
            statut = CGenericUtils.findOne(conn, Statut.class, Map.of("id", historique.getStatut()));
        }else{
            statut = CGenericUtils.findOne(conn, Statut.class, Map.of("id", this.getStatut()));
        }
        return statut;
    }

    @Loader
    public void loadAttributes(Connection conn) {
        if (this.typePlaceId != null) {
            this.typePlace = mg.gestion.cinema.utils.CGenericUtils.findOne(conn, TypePlace.class,
                    Map.of("id", this.typePlaceId));
        }
        if (this.statut != null) {
            this.statutDetails = mg.gestion.cinema.utils.CGenericUtils.findOne(conn, Statut.class,
                    Map.of("id", this.statut));
        }
    }

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

    public TypePlace getTypePlace() {
        return typePlace;
    }

    public void setTypePlace(TypePlace typePlace) {
        this.typePlace = typePlace;
    }

    public LocalDateTime getDateModification() {
        return dateModification;
    }

    public void setDateModification(LocalDateTime dateModification) {
        this.dateModification = dateModification;
    }

    public Statut getStatutDetails() {
        return statutDetails;
    }

    public void setStatutDetails(Statut statutDetails) {
        this.statutDetails = statutDetails;
    }
}

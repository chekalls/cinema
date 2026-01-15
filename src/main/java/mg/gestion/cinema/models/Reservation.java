package mg.gestion.cinema.models;

import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.Generated;
import mg.gestion.cinema.annotation.Loader;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;

@Table(name = "reservation")
public class Reservation extends BaseEntity{
    @PrimaryKey
    private Integer id;
    @Column
    @Generated
    private String numero;
    @Column(name = "montant_total")
    private double montantTotal;
    @Column(name = "date_creation")
    private LocalDateTime dateCreation;
    @Column(name = "date_expiration")
    private LocalDateTime dateExpiration;
    @Column(name = "client_id")
    private Integer clientId;
    @Column(name = "statut_id")
    private Integer statutId;
    
    @Column(ignore = true)
    private Statut statut;

    @Column(ignore = true)
    private List<Billet> billets;
    
    public Integer getId() {
        return id;
    }

    @Loader
    public void loadAttributes(Connection conn){
        if(this.id != null){
            this.billets = mg.gestion.cinema.utils.CGenericUtils.find(conn,Billet.class,Map.of("reservation_id",this.id),true);
        }
        if(this.statutId != null){
            this.statut = mg.gestion.cinema.utils.CGenericUtils.findOne(conn,Statut.class,Map.of("id",this.statutId));
        }
    }

    public void setId(Integer id) {
        this.id = id;
    }
    public String getNumero() {
        return numero;
    }
    public void setNumero(String numero) {
        this.numero = numero;
    }

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }
    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }
    public LocalDateTime getDateExpiration() {
        return dateExpiration;
    }
    public void setDateExpiration(LocalDateTime dateExpiration) {
        this.dateExpiration = dateExpiration;
    }
    public Integer getClientId() {
        return clientId;
    }
    public void setClientId(Integer clientId) {
        this.clientId = clientId;
    }
    public Integer getStatutId() {
        return statutId;
    }
    public void setStatutId(Integer statutId) {
        this.statutId = statutId;
    }

    public double getMontantTotal() {
        return montantTotal;
    }

    public void setMontantTotal(double montantTotal) {
        this.montantTotal = montantTotal;
    }



    public List<Billet> getBillets() {
        return billets;
    }



    public void setBillets(List<Billet> billets) {
        this.billets = billets;
    }

    public Statut getStatut() {
        return statut;
    }

    public void setStatut(Statut statut) {
        this.statut = statut;
    }
}

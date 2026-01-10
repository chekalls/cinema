package mg.gestion.cinema.models;

import java.time.LocalDateTime;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;

@Table(name = "reservation")
public class Reservation extends BaseEntity{
    @PrimaryKey
    private Integer id;
    @Column
    private String numero;
    @Column(name = "montant_total")
    private String montantTotal;
    @Column(name = "date_creation")
    private LocalDateTime dateCreation;
    @Column(name = "date_expiration")
    private LocalDateTime dateExpiration;
    @Column(name = "client_id")
    private Integer clientId;
    @Column(name = "statut_id")
    private Integer statutId;
    public Integer getId() {
        return id;
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
    public String getMontantTotal() {
        return montantTotal;
    }
    public void setMontantTotal(String montantTotal) {
        this.montantTotal = montantTotal;
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
}

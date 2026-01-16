package mg.gestion.cinema.models;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;
import mg.gestion.cinema.utils.CGenericUtils;

@Table(name = "salle")
public class Salle extends BaseEntity {
    @PrimaryKey
    private Integer id;

    @Column(name = "cinema_id")
    private Integer cinemaId;

    @Column(name = "numero")
    private String numero;

    @Column(name = "designation")
    private String designation;

    @Column(name = "capacite_total")
    private Integer capaciteTotal;

    @Column(name = "nb_rangees")
    private Integer nbRangees;

    @Column(name = "nb_colonnes")
    private Integer nbColonnes;

    public void setAutoNbRangeesAndColonnes(Connection conn) {
        if (this.capaciteTotal == null || this.capaciteTotal <= 0) {
            throw new IllegalArgumentException("La capacité totale doit être un entier positif");
        }

        int tailleRang = (int) Math.sqrt(this.capaciteTotal);
        int tailleCol = (int) Math.ceil((double) this.capaciteTotal / tailleRang);

        this.nbRangees = tailleRang;
        this.nbColonnes = tailleCol;
    }

    public void insererPlace(int tailleCol, int tailleRang, Connection conn) {
        if (this.id == null) {
            throw new IllegalStateException("La salle doit être sauvegardée avant de créer les places");
        }

        Statut statutPlace = CGenericUtils.findOne(conn, Statut.class, Map.of("code","DISPO","categorie","PLACE"));

        for (int rang = 1; rang <= tailleRang; rang++) {
            for (int col = 1; col <= tailleCol; col++) {
                Place place = new Place();
                place.setSalleId(this.id);
                place.setRang(rang);
                place.setCol(col);
                place.setStatut(statutPlace.getId());
                CGenericUtils.save(conn, place);
            }
        }
    }

    /**
     * Insère les places en les répartissant selon les quantités par type de place.
     */
    public void insererPlace(Map<Integer, Integer> typePlaceCounts, Connection conn) {
        if (this.id == null) {
            throw new IllegalStateException("La salle doit être sauvegardée avant de créer les places");
        }
        if (this.nbColonnes == null || this.nbRangees == null) {
            throw new IllegalStateException("Le nombre de rangées et de colonnes doit être défini");
        }

        int capacity = this.nbColonnes * this.nbRangees;
        int totalPlaces = typePlaceCounts.values().stream().mapToInt(Integer::intValue).sum();
        if (totalPlaces > capacity) {
            throw new IllegalArgumentException("La capacité de la salle est inférieure au nombre de places demandé");
        }

        Statut statutPlace = CGenericUtils.findOne(conn, Statut.class, Map.of("code", "DISPO", "categorie", "PLACE"));

        List<Integer> allocation = buildAllocationList(typePlaceCounts);
        int index = 0;

        for (int rang = 1; rang <= this.nbRangees; rang++) {
            for (int col = 1; col <= this.nbColonnes; col++) {
                if (index >= allocation.size()) {
                    return;
                }

                Place place = new Place();
                place.setSalleId(this.id);
                place.setRang(rang);
                place.setCol(col);
                place.setTypePlaceId(allocation.get(index));
                place.setStatut(statutPlace.getId());
                CGenericUtils.save(conn, place);
                index++;
            }
        }
    }

    private List<Integer> buildAllocationList(Map<Integer, Integer> typePlaceCounts) {
        List<Map.Entry<Integer, Integer>> sorted = new ArrayList<>(typePlaceCounts.entrySet());
        Collections.sort(sorted, Comparator.comparing(Map.Entry::getKey));

        List<Integer> allocation = new ArrayList<>();
        for (Map.Entry<Integer, Integer> entry : sorted) {
            Integer typePlaceId = entry.getKey();
            Integer count = entry.getValue();
            if (typePlaceId != null && count != null && count > 0) {
                for (int i = 0; i < count; i++) {
                    allocation.add(typePlaceId);
                }
            }
        }
        return allocation;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getCinemaId() {
        return cinemaId;
    }

    public void setCinemaId(Integer cinemaId) {
        this.cinemaId = cinemaId;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public Integer getCapaciteTotal() {
        return capaciteTotal;
    }

    public void setCapaciteTotal(Integer capaciteTotal) {
        this.capaciteTotal = capaciteTotal;
    }

    public Integer getNbRangees() {
        return nbRangees;
    }

    public void setNbRangees(Integer nbRangees) {
        this.nbRangees = nbRangees;
    }

    public Integer getNbColonnes() {
        return nbColonnes;
    }

    public void setNbColonnes(Integer nbColonnes) {
        this.nbColonnes = nbColonnes;
    }

}

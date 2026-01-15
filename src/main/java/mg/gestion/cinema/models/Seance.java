package mg.gestion.cinema.models;

import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.Loader;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;
import mg.gestion.cinema.utils.CGenericUtils;

@Table(name = "seance")
public class Seance extends BaseEntity {
    @PrimaryKey
    private Integer id;
    @Column(name = "film_id")
    private Integer filmId;
    @Column(name = "salle_id")
    private Integer salleId;
    @Column
    private LocalDateTime debut;
    @Column
    private LocalDateTime fin;
    @Column(name = "format_id")
    private Integer formatId;

    @Column(ignore = true)
    private Film film;

    @Column(ignore = true)
    private Salle salle;

    public List<Billet> getBillets(Connection conn, LocalDateTime date) {
        String sql = "SELECT * FROM billet WHERE seance_id = ? AND date_achat <= ? ORDER BY date_achat ASC";
        List<Billet> billets = CGenericUtils.executeQuery(conn, Billet.class, sql, this.id, date);
        return billets;
    }

    public List<Place> getPlaces(Connection conn, LocalDateTime dateVisualisation) {
        String sql = "SELECT p.id, p.rang, p.col, p.type_place_id, p.salle_id, p.date_modification, " +
                "  CASE " +
                "    WHEN b.id IS NOT NULL AND s.code = 'PAYE' THEN 7 " +
                "    WHEN b.id IS NOT NULL AND s.code = 'UTILISE' THEN 7 " +
                "    WHEN b.id IS NOT NULL AND s.code = 'PANIER' THEN 5 " +
                "    ELSE p.statut " +
                "  END AS statut " +
                "FROM place p " +
                "LEFT JOIN billet b ON b.place_id = p.id AND b.seance_id = ? " +
                "    AND b.date_achat <= ? " +
                "LEFT JOIN statut s ON b.statut = s.id " +
                "WHERE p.salle_id = ? " +
                "ORDER BY p.rang, p.col";

        List<Place> places = CGenericUtils.executeQuery(conn, Place.class, sql,
                this.id,
                dateVisualisation,
                this.salleId);
        for (Place place : places) {
            place.loadAttributes(conn);
        }
        return places;
    }

    public List<Place> getPlacesLibre(Connection conn, LocalDateTime dateAchat) {
        Statut statutPlace = CGenericUtils.findOne(conn, Statut.class, Map.of("code", "DISPO"));

        if (statutPlace == null) {
            return List.of();
        }

        String sql = "SELECT p.* FROM place p " +
                "WHERE p.salle_id = ? " +
                "AND p.statut = ? " +
                "AND NOT EXISTS (" +
                "  SELECT 1 FROM billet b " +
                "  JOIN statut s ON b.statut = s.id " +
                "  WHERE b.place_id = p.id " +
                "  AND b.seance_id = ? " +
                "  AND s.code IN ('PAYE', 'UTILISE')" +
                ") " +
                "ORDER BY p.rang, p.col";

        List<Place> places = CGenericUtils.executeQuery(conn, Place.class, sql,
                this.salleId,
                statutPlace.getId(),
                this.id);
        for (Place place : places) {
            place.loadAttributes(conn);
        }

        return places;
    }

    public static List<Seance> getProchainSeancesFilm(Connection conn, Film film) {
        String sql = "SELECT * FROM seance WHERE debut >= now() AND film_id = ? ORDER BY debut ASC";
        List<Seance> seances = CGenericUtils.executeQuery(conn, Seance.class, sql, film.getId());
        return seances;
    }

    public static List<Seance> getProchainSeances(Connection conn, LocalDate date) {
        String sql = "SELECT * FROM seance WHERE debut >= ? ORDER BY debut ASC";
        List<Seance> seances = CGenericUtils.executeQuery(conn, Seance.class, sql, date);
        return seances;
    }

    @Loader
    private void loadAttributes(Connection conn) {
        if (this.filmId != null) {
            this.film = (Film) new Film().findOne(conn, java.util.Collections.singletonMap("id", this.filmId));
        }
        if (this.salleId != null) {
            this.salle = (Salle) new Salle().findOne(conn, java.util.Collections.singletonMap("id", this.salleId));
        }
    }

    public void setDebutFin(Film film) {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getFilmId() {
        return filmId;
    }

    public void setFilmId(Integer filmId) {
        this.filmId = filmId;
    }

    public Integer getSalleId() {
        return salleId;
    }

    public void setSalleId(Integer salleId) {
        this.salleId = salleId;
    }

    public LocalDateTime getDebut() {
        return debut;
    }

    public void setDebut(LocalDateTime debut) {
        this.debut = debut;
    }

    public LocalDateTime getFin() {
        return fin;
    }

    public void setFin(LocalDateTime fin) {
        this.fin = fin;
    }

    public Integer getFormatId() {
        return formatId;
    }

    public void setFormatId(Integer formatId) {
        this.formatId = formatId;
    }

    public Film getFilm() {
        return film;
    }

    public void setFilm(Film film) {
        this.film = film;
    }

    public Salle getSalle() {
        return salle;
    }

    public void setSalle(Salle salle) {
        this.salle = salle;
    }
}

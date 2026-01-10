package mg.gestion.cinema.models;

import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.cglib.core.Local;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.Loader;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;
import mg.gestion.cinema.utils.CGenericUtils;

@Table(name = "sceance")
public class Sceance extends BaseEntity {
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

    public List<Place> getPlacesLibre(Connection conn, LocalDateTime dateAchat) {
        Statut statutPlace = CGenericUtils.findOne(conn, Statut.class, Map.of("code", "DISPO"));

        if (statutPlace == null) {
            return List.of();
        }

        int dispoOrdre = statutPlace.getOrdre();

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
                                                         dispoOrdre,
                                                         this.id);
        return places;
    }

    public static List<Sceance> getProchainSceancesFilm(Connection conn, Film film) {
        String sql = "SELECT * FROM sceance WHERE debut >= now() AND film_id = ? ORDER BY debut ASC";
        List<Sceance> sceances = CGenericUtils.executeQuery(conn, Sceance.class, sql, film.getId());
        return sceances;
    }

    public static List<Sceance> getProchainSceances(Connection conn,LocalDate date) {
        String sql = "SELECT * FROM sceance WHERE debut >= ? ORDER BY debut ASC";
        List<Sceance> sceances = CGenericUtils.executeQuery(conn, Sceance.class, sql, date);
        return sceances;
    }

    @Loader
    private void loadAttributes(Connection conn) {
        if (this.filmId != null) {
            this.film = (Film) new Film().findOne(conn, java.util.Collections.singletonMap("id", this.filmId));
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
}

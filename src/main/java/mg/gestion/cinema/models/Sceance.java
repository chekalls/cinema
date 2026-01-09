package mg.gestion.cinema.models;

import java.sql.Connection;
import java.time.LocalDateTime;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.Loader;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;

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

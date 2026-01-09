package mg.gestion.cinema.models;

import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.Generated;
import mg.gestion.cinema.annotation.Loader;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;
import mg.gestion.cinema.utils.CGenericUtils;

@Table(name = "film")
public class Film extends BaseEntity {
    @PrimaryKey
    private Integer id;
    @Column
    private String titre;
    @Column
    private String realisateur;
    @Column
    private String acteurs;
    @Column(name = "duree_minutes")
    private Integer dureeMinutes;
    @Column(name = "date_sortie")
    private LocalDate dateSortie;
    @Column
    private String synopsis;
    @Column(name = "url_affiche")
    private String urlAffiche;
    @Column(name = "created_at")
    @Generated
    private LocalDateTime createdAt;

    @Column(ignore = true)
    private List<GenreFilm> genres;

    @Loader
    public void loadAttributes(Connection connection) {
        try {
            List<LGenreFilm> lgenres = new LGenreFilm()
                    .find(connection, Collections.singletonMap("film_id", this.id))
                    .stream()
                    .map(e -> (LGenreFilm) e)
                    .collect(Collectors.toList());

            this.genres = new ArrayList<>();

            for (LGenreFilm lGenreFilm : lgenres) {
                if (CGenericUtils.exist(connection, GenreFilm.class, lGenreFilm.getGenreFilmId())) {
                    GenreFilm genre = (GenreFilm) CGenericUtils.findOne(connection, GenreFilm.class,
                            Collections.singletonMap("id", lGenreFilm.getGenreFilmId()));
                    genres.add(genre);
                }
            }

        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du chargement des genres du film", e);
        }
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getRealisateur() {
        return realisateur;
    }

    public void setRealisateur(String realisateur) {
        this.realisateur = realisateur;
    }

    public String getActeurs() {
        return acteurs;
    }

    public void setActeurs(String acteurs) {
        this.acteurs = acteurs;
    }

    public Integer getDureeMinutes() {
        return dureeMinutes;
    }

    public void setDureeMinutes(Integer dureeMinutes) {
        this.dureeMinutes = dureeMinutes;
    }

    public LocalDate getDateSortie() {
        return dateSortie;
    }

    public void setDateSortie(LocalDate dateSortie) {
        this.dateSortie = dateSortie;
    }

    public String getSynopsis() {
        return synopsis;
    }

    public void setSynopsis(String synopsis) {
        this.synopsis = synopsis;
    }

    public String getUrlAffiche() {
        return urlAffiche;
    }

    public void setUrlAffiche(String urlAffiche) {
        this.urlAffiche = urlAffiche;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public List<GenreFilm> getGenres() {
        return genres;
    }

    public void setGenres(List<GenreFilm> genres) {
        this.genres = genres;
    }
}

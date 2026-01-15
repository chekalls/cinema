package mg.gestion.cinema.models;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;

@Table(name = "l_genre_film")
public class LGenreFilm extends BaseEntity {
    @PrimaryKey(autGenerated = false)
    private Integer filmId;
    @Column(name = "genre_id")
    @PrimaryKey(autGenerated = false)
    private Integer genreFilmId;

    public Integer getFilmId() {
        return filmId;
    }

    public void setFilmId(Integer filmId) {
        this.filmId = filmId;
    }

    public Integer getGenreFilmId() {
        return genreFilmId;
    }

    public void setGenreFilmId(Integer genreFilmId) {
        this.genreFilmId = genreFilmId;
    }
}

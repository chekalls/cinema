package mg.gestion.cinema.models;

import java.sql.Connection;
import java.util.Map;

public class GenreFilm extends Referentiel{
    public GenreFilm() {
        super.setCategorie("GENRE_FILM");
    }

    public GenreFilm findOne(Connection conn,Integer id){
        return (GenreFilm) super.findOne(conn, Map.of("id", id,"categorie",getCategorie()));
    }
}

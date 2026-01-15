<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.gestion.cinema.models.Film" %>
<%@ page import="mg.gestion.cinema.models.GenreFilm" %>
<%@ page import="java.util.List" %>
<%
    String message = (String) request.getAttribute("message");
    String error   = (String) request.getAttribute("error");

    Object filmObj = request.getAttribute("film");
    Film film = (Film) filmObj; 

    List<GenreFilm> genres = (List<GenreFilm>) request.getAttribute("genres");
    boolean modification = film!=null && film.getId()!=null;
%>

<% if (message != null && !message.isEmpty()) { %>
<div class="row">
    <div class="col-md-12">
        <div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            <h5><i class="icon fas fa-check"></i> Succès!</h5>
            <span><%= message %></span>
        </div>
    </div>
</div>
<% } %>

<% if (error != null && !error.isEmpty()) { %>
<div class="row">
    <div class="col-md-12">
        <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            <h5><i class="icon fas fa-ban"></i> Erreur!</h5>
            <span><%= error %></span>
        </div>
    </div>
</div>
<% } %>

<div class="row">
    <div class="col-md-8 offset-md-2">
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <%= (!modification)
                            ? "Ajouter un film"
                            : "Modifier le film" %>
                </h3>
            </div>

            <form action="/films/save" method="post">
                <input type="hidden" name="id"
                       value="<%= modification ? film.getId() : "" %>"/>

                <div class="card-body">
                    <div class="form-group">
                        <label>Titre</label>
                        <input type="text" name="titre" class="form-control"
                               value="<%= modification ? film.getTitre() : "" %>" required/>
                    </div>

                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Réalisateur</label>
                            <input type="text" name="realisateur" class="form-control"
                                   value="<%= modification ? film.getRealisateur() : "" %>"/>
                        </div>

                        <div class="form-group col-md-3">
                            <label>Durée (minutes)</label>
                            <input type="number" name="dureeMinutes" class="form-control" min="1"
                                   value="<%= modification ? film.getDureeMinutes() : "" %>"/>
                        </div>

                        <div class="form-group col-md-3">
                            <label>Date de sortie</label>
                            <input type="date" name="dateSortie" class="form-control"
                                   value="<%= modification ? film.getDateSortie() : "" %>"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Acteurs</label>
                        <input type="text" name="acteurs" class="form-control"
                               value="<%= modification ? film.getActeurs() : "" %>"
                               placeholder="Séparer par des virgules"/>
                    </div>

                    <div class="form-group">
                        <label>Genres</label>
                        <select name="genreIds" class="form-control select2" multiple>
                            <%
                                if (genres != null) {
                                    for (GenreFilm genre : genres) {
                                        boolean selected = false;

                                        if (film != null && film.getGenres() != null) {
                                            for (GenreFilm g : film.getGenres()) {
                                                if (g.getId().equals(genre.getId())) {
                                                    selected = true;
                                                    break;
                                                }
                                            }
                                        }
                            %>
                            <option value="<%= genre.getId() %>"
                                    <%= selected ? "selected" : "" %>>
                                <%= genre.getNom() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <small class="form-text text-muted">
                            Maintenez Ctrl/Cmd pour sélectionner plusieurs genres
                        </small>
                    </div>

                    <div class="form-group">
                        <label>Synopsis</label>
                        <textarea name="synopsis" class="form-control" rows="5"><%= 
                            modification ? film.getSynopsis() : "" 
                        %></textarea>
                    </div>

                    <div class="form-group">
                        <label>URL affiche</label>
                        <input type="text" name="urlAffiche" class="form-control"
                               value="<%= modification ? film.getUrlAffiche() : "" %>"
                               placeholder="https://..."/>
                    </div>
                </div>

                <div class="card-footer text-right">
                    <a href="/films" class="btn btn-default mr-2">Annuler</a>
                    <button type="submit" class="btn btn-primary">Enregistrer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        setTimeout(function () {
            $('.alert').fadeOut('slow');
        }, 5000);
    });
</script>

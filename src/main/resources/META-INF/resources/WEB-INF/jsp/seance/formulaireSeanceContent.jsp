<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.gestion.cinema.models.Film" %>
<%@ page import="mg.gestion.cinema.models.GenreFilm" %>
<%@ page import="mg.gestion.cinema.models.Salle" %>
<%@ page import="mg.gestion.cinema.models.Seance" %>
<%@ page import="java.util.List" %>
<%

    String error = (String) request.getAttribute("error");

    Seance seance = (Seance) request.getAttribute("seance");
    List<Film> films = (List<Film>) request.getAttribute("films");
    List<Salle> salles = (List<Salle>) request.getAttribute("salles");

    boolean isEdit = (seance != null && seance.getId() != null);

    String formAction = isEdit ? "/seances/update" : "/seances/save";
%>

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
    <div class="col-md-12">
        <div class="card card-primary">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-edit mr-2"></i>
                    <%= isEdit ? "Modifier la séance" : "Nouvelle séance" %>
                </h3>
            </div>

            <form action="<%= formAction %>" method="post">
                <div class="card-body">

                    <input type="hidden" name="id"
                           value="<%= isEdit ? seance.getId() : "" %>"/>

                    <!-- Film -->
                    <div class="form-group">
                        <label for="filmId">Film *</label>
                        <select name="filmId" id="filmId" class="form-control" required>
                            <option value="">-- Sélectionner un film --</option>
                            <%
                                if (films != null) {
                                    for (Film film : films) {
                                        boolean selected =
                                                isEdit && film.getId().equals(seance.getFilmId());
                            %>
                            <option value="<%= film.getId() %>"
                                    <%= selected ? "selected" : "" %>>
                                <%= film.getTitre() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <small class="form-text text-muted">Choisissez le film projeté.</small>
                    </div>

                    <!-- Salle -->
                    <div class="form-group">
                        <label for="salleId">Salle *</label>
                        <select name="salleId" id="salleId" class="form-control" required>
                            <option value="">-- Sélectionner une salle --</option>
                            <%
                                if (salles != null) {
                                    for (Salle salle : salles) {
                                        boolean selected =
                                                isEdit && salle.getId().equals(seance.getSalleId());
                            %>
                            <option value="<%= salle.getId() %>"
                                    <%= selected ? "selected" : "" %>>
                                <%= salle.getDesignation() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <small class="form-text text-muted">Choisissez la salle.</small>
                    </div>

                    <!-- Début -->
                    <div class="form-group">
                        <label for="debut">Début *</label>
                        <input type="datetime-local"
                               name="debut"
                               id="debut"
                               class="form-control"
                               value="<%= isEdit && seance.getDebut() != null ? seance.getDebut() : "" %>"/>
                        <small class="form-text text-muted">
                            Format attendu: ISO-8601 (ex: 2025-01-15T19:30).
                        </small>
                    </div>

                    <!-- Fin -->
                    <div class="form-group">
                        <label for="fin">Fin *</label>
                        <input type="datetime-local"
                               name="fin"
                               id="fin"
                               class="form-control"
                               value="<%= isEdit && seance.getFin() != null ? seance.getFin() : "" %>"/>
                        <small class="form-text text-muted">
                            Format attendu: ISO-8601 (ex: 2025-01-15T21:15). laisser vide pour utiliser la fin du film
                        </small>
                    </div>

                </div>

                <div class="card-footer">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save mr-1"></i> Enregistrer
                    </button>
                    <a href="/seances" class="btn btn-default">
                        <i class="fas fa-arrow-left mr-1"></i> Retour
                    </a>
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

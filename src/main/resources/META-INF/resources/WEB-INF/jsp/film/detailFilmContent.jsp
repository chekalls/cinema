<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="mg.gestion.cinema.models.Film" %>
<%@ page import="mg.gestion.cinema.models.GenreFilm" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%
    Film film = (Film) request.getAttribute("film");
    List<GenreFilm> genresfilm = (film!=null) ? film.getGenres() : new ArrayList<>();
%>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <%= film != null ? film.getTitre() : "" %>
                </h3>
                <div class="card-tools">
                    <a href="/films" class="btn btn-default btn-sm">Retour</a>
                </div>
            </div>

            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <%
                            if (film != null && film.getUrlAffiche() != null && !film.getUrlAffiche().isEmpty()) {
                        %>
                            <img src="<%= film.getUrlAffiche() %>"
                                 class="img-fluid" alt="Affiche"/>
                        <%
                            } else {
                        %>
                            <div class="text-muted">Pas d'affiche</div>
                        <%
                            }
                        %>
                    </div>

                    <div class="col-md-8">
                        <dl class="row">

                            <dt class="col-sm-4">Réalisateur</dt>
                            <dd class="col-sm-8">
                                <%= (film != null && film.getRealisateur() != null && !film.getRealisateur().isEmpty())
                                        ? film.getRealisateur()
                                        : "-" %>
                            </dd>

                            <dt class="col-sm-4">Acteurs</dt>
                            <dd class="col-sm-8">
                                <%= (film != null && film.getActeurs() != null && !film.getActeurs().isEmpty())
                                        ? film.getActeurs()
                                        : "-" %>
                            </dd>

                            <dt class="col-sm-4">Durée</dt>
                            <dd class="col-sm-8">
                                <%= (film != null && film.getDureeMinutes() != null)
                                        ? film.getDureeMinutes() + " min"
                                        : "-" %>
                            </dd>

                            <dt class="col-sm-4">Date de sortie</dt>
                            <dd class="col-sm-8">
                                <%= (film != null && film.getDateSortie() != null)
                                        ? film.getDateSortie()
                                        : "-" %>
                            </dd>

                            <dt class="col-sm-4">Synopsis</dt>
                            <dd class="col-sm-8">
                                <%= (film != null && film.getSynopsis() != null && !film.getSynopsis().isEmpty())
                                        ? film.getSynopsis()
                                        : "-" %>
                            </dd>

                            <dt class="col-sm-4">Créé le</dt>
                            <dd class="col-sm-8">
                                <%= (film != null && film.getCreatedAt() != null)
                                        ? film.getCreatedAt()
                                        : "-" %>
                            </dd>
                            <dt class="col-sm-4">genre :</dt>
                            <dd class="col-sm-8"> 
                                <% for(GenreFilm genres : genresfilm ) {%>
                                    <span><%= genres.getNom() %></span>
                                <% } %>
                            </dd>
                        </dl>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
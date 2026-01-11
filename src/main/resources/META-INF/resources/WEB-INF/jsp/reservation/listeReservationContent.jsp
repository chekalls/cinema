<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:if test="${not empty message}">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h5><i class="icon fas fa-check"></i> Succès!</h5>
        ${message}
    </div>
</c:if>

<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h5><i class="icon fas fa-ban"></i> Erreur!</h5>
        ${error}
    </div>
</c:if>

<div class="row">
    <div class="col-12">
        <div class="card card-warning card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-calendar-check mr-2"></i>
                    Liste des réservations
                </h3>
                <div class="card-tools">
                    <a href="/reservations/form" class="btn btn-warning btn-sm">
                        <i class="fas fa-plus mr-1"></i>
                        Nouvelle réservation
                    </a>
                </div>
            </div>

            <!-- Filtres -->
            <div class="card-body border-bottom">
                <form method="get" action="/reservations" class="form-horizontal">
                    <div class="row">
                        <!-- Recherche -->
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Recherche</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                                    </div>
                                    <input type="text" name="search" class="form-control" 
                                           placeholder="Film, séance, place..." 
                                           value="${search}">
                                </div>
                            </div>
                        </div>

                        <!-- Film -->
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Film</label>
                                <select name="filmId" class="form-control">
                                    <option value="">Tous les films</option>
                                    <c:forEach items="${films}" var="film">
                                        <option value="${film.id}" ${filmId == film.id ? 'selected' : ''}>
                                            ${film.titre}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Période -->
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Date de réservation</label>
                                <input type="date" name="dateReservation" class="form-control" 
                                       value="${dateReservation}">
                            </div>
                        </div>

                        <!-- Boutons -->
                        <div class="col-md-2">
                            <div class="form-group">
                                <label>&nbsp;</label>
                                <div>
                                    <button type="submit" class="btn btn-primary btn-block">
                                        <i class="fas fa-filter mr-1"></i>
                                        Filtrer
                                    </button>
                                    <a href="/reservations" class="btn btn-default btn-block mt-1">
                                        <i class="fas fa-redo mr-1"></i>
                                        Réinitialiser
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <div class="card-body table-responsive p-0">
                <c:choose>
                    <c:when test="${empty reservations}">
                        <div class="text-center py-5">
                            <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                            <p class="text-muted">Aucune réservation trouvée</p>
                            <a href="/reservations/form" class="btn btn-warning">
                                <i class="fas fa-plus mr-2"></i>
                                Créer une réservation
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-hover table-head-fixed text-nowrap">
                            <thead>
                                <tr>
                                    <th style="width: 80px;">ID</th>
                                    <th>Numéro</th>
                                    <th>Montant Total</th>
                                    <th>Date Création</th>
                                    <th>Date Expiration</th>
                                    <th>Statut</th>
                                    <th style="width: 150px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${reservations}" var="reservation">
                                    <tr>
                                        <td><span class="badge badge-warning">#${reservation.id}</span></td>
                                        <td><strong>${reservation.numero}</strong></td>
                                        <td><strong>${reservation.montantTotal} €</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${reservation.dateCreation != null}">
                                                    <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(reservation.dateCreation)" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${reservation.dateExpiration != null}">
                                                    <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(reservation.dateExpiration)" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><span class="badge badge-info">${reservation.statut.nom}</span></td>
                                        <td>
                                            <div class="btn-group">
                                                <a href="/reservations/view/${reservation.id}" 
                                                   class="btn btn-sm btn-info" 
                                                   title="Voir">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <button type="button" 
                                                        class="btn btn-sm btn-success" 
                                                        title="Confirmer" 
                                                    onclick="if(confirm('Confirmer cette réservation ?')) window.location.href='/reservations/confirmer/${reservation.id}'">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                                <button type="button" 
                                                        class="btn btn-sm btn-danger" 
                                                        title="Annuler" 
                                                    onclick="if(confirm('Annuler cette réservation ?')) window.location.href='/reservations/annuler/${reservation.id}'">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty reservations}">
                <div class="card-footer clearfix">
                    <div class="float-left">
                        <span class="text-muted">
                            <strong>${reservations.size()}</strong> réservation(s) en attente
                        </span>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
$(document).ready(function(){
    setTimeout(function(){ $('.alert').fadeOut('slow'); }, 5000);
});
</script>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="row">
    <div class="col-12">
        <!-- En-tête -->
        <div class="card card-warning card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-receipt mr-2"></i>
                    Détails de la réservation #${reservation.id} - ${reservation.numero}
                </h3>
                <div class="card-tools">
                    <a href="/reservations" class="btn btn-tool">
                        <i class="fas fa-arrow-left"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <div class="card card-warning">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-receipt mr-2"></i>
                            Informations Réservation
                        </h3>
                    </div>
                    <div class="card-body">
                        <dl class="row">
                            <dt class="col-sm-5">Numéro</dt>
                            <dd class="col-sm-7">
                                <span class="badge badge-warning">${reservation.numero}</span>
                            </dd>

                            <dt class="col-sm-5">Montant Total</dt>
                            <dd class="col-sm-7">
                                <h5 class="text-danger">
                                    <strong>${reservation.montantTotal} €</strong>
                                </h5>
                            </dd>

                            <dt class="col-sm-5">Date Création</dt>
                            <dd class="col-sm-7">
                                <c:if test="${reservation.dateCreation != null}">
                                    <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(reservation.dateCreation)" />
                                </c:if>
                            </dd>

                            <dt class="col-sm-5">Date Expiration</dt>
                            <dd class="col-sm-7">
                                <c:if test="${reservation.dateExpiration != null}">
                                    <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(reservation.dateExpiration)" />
                                </c:if>
                            </dd>

                            <dt class="col-sm-5">Statut</dt>
                            <dd class="col-sm-7">
                                <span class="badge badge-info">${reservation.statut.nom}</span>
                            </dd>
                        </dl>
                    </div>
                </div>
            </div>

            <!-- Résumé Billets -->
            <div class="col-md-6">
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-ticket-alt mr-2"></i>
                            Résumé Billets
                        </h3>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty billets}">
                                <div class="alert alert-info">
                                    <strong>${billets.size()} billet(s)</strong> dans cette réservation
                                </div>
                                <ul class="list-unstyled">
                                    <c:forEach items="${billets}" var="billet" varStatus="status">
                                        <li class="mb-3">
                                            <strong>Billet #${billet.id}</strong>
                                            <c:if test="${billet.seance != null && billet.seance.film != null}">
                                                <br><small class="text-muted">${billet.seance.film.titre}</small>
                                            </c:if>
                                            <c:if test="${billet.place != null}">
                                                <br><small class="text-muted">Place: R${billet.place.rang}-C${billet.place.col}</small>
                                            </c:if>
                                            <br><small class="text-success"><strong>${billet.prixReel} €</strong></small>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-warning">
                                    Aucun billet associé
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${not empty billets}">
            <div class="row">
                <div class="col-12">
                    <div class="card card-primary">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-list mr-2"></i>
                                Détails des Billets
                            </h3>
                        </div>
                        <div class="card-body table-responsive p-0">
                            <table class="table table-hover table-head-fixed">
                                <thead>
                                    <tr>
                                        <th>ID Billet</th>
                                        <th>Film</th>
                                        <th>Séance</th>
                                        <th>Place</th>
                                        <th>Tarif</th>
                                        <th>Prix</th>
                                        <th>Date Achat</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${billets}" var="billet">
                                        <tr>
                                            <td><span class="badge badge-primary">#${billet.id}</span></td>
                                            <td>
                                                <c:if test="${billet.seance != null && billet.seance.film != null}">
                                                    ${billet.seance.film.titre}
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${billet.seance != null}">
                                                    <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(billet.seance.debut)" />
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${billet.place != null}">
                                                    <span class="badge badge-info">R${billet.place.rang}-C${billet.place.col}</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${billet.tarif != null}">
                                                    ${billet.tarif.nom}
                                                </c:if>
                                            </td>
                                            <td>
                                                <strong>${billet.prixReel} €</strong>
                                            </td>
                                            <td>
                                                <c:if test="${billet.dateAchat != null}">
                                                    <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(billet.dateAchat)" />
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Actions -->
        <div class="row">
            <div class="col-12">
                <div class="card card-warning">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-cog mr-2"></i>
                            Actions
                        </h3>
                    </div>
                    <div class="card-body">
                        <button type="button" 
                                class="btn btn-success btn-lg mr-2" 
                                onclick="if(confirm('Confirmer cette réservation ?')) window.location.href='/reservations/payement/${reservation.id}'">
                            <i class="fas fa-check mr-2"></i>
                            effectuer payement
                        </button>
                        <button type="button" 
                                class="btn btn-danger btn-lg" 
                                onclick="if(confirm('Annuler cette réservation ? Cette action est irréversible.')) window.location.href='/reservations/annuler/${reservation.id}'">
                            <i class="fas fa-times mr-2"></i>
                            Annuler la réservation
                        </button>
                        <a href="/reservations" class="btn btn-default btn-lg float-right">
                            <i class="fas fa-arrow-left mr-2"></i>
                            Retour à la liste
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

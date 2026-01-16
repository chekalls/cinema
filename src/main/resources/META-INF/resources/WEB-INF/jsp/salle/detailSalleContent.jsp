<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="row">
    <div class="col-md-8">
        <div class="card card-primary card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-door-open mr-2"></i>
                    Informations de la salle
                </h3>
                <div class="card-tools">
                    <a href="/salles/edit/${salle.id}" class="btn btn-sm btn-info">
                        <i class="fas fa-edit mr-1"></i>
                        Modifier
                    </a>
                </div>
            </div>
            <div class="card-body">
                <dl class="row">
                    <dt class="col-sm-3"><i class="fas fa-hashtag mr-2 text-muted"></i>ID</dt>
                    <dd class="col-sm-9"><span class="badge badge-secondary">${salle.id}</span></dd>

                    <dt class="col-sm-3"><i class="fas fa-door-open mr-2 text-muted"></i>Numéro</dt>
                    <dd class="col-sm-9"><strong>${salle.numero}</strong></dd>

                    <dt class="col-sm-3"><i class="fas fa-tag mr-2 text-muted"></i>Désignation</dt>
                    <dd class="col-sm-9">${salle.designation}</dd>

                    <dt class="col-sm-3"><i class="fas fa-users mr-2 text-muted"></i>Capacité</dt>
                    <dd class="col-sm-9">${salle.capaciteTotal} places</dd>

                    <dt class="col-sm-3"><i class="fas fa-th mr-2 text-muted"></i>Configuration</dt>
                    <dd class="col-sm-9">
                        <span class="badge badge-info">${salle.nbRangees} rangées</span>
                        <span class="badge badge-info">${salle.nbColonnes} colonnes</span>
                    </dd>

                    <dt class="col-sm-3"><i class="fas fa-film mr-2 text-muted"></i>Cinéma</dt>
                    <dd class="col-sm-9">
                        <c:choose>
                            <c:when test="${cinema != null}">${cinema.nom}</c:when>
                            <c:otherwise>Non renseigné</c:otherwise>
                        </c:choose>
                    </dd>
                </dl>
            </div>
        </div>

        <!-- Plan de salle -->
        <div class="card card-success card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-chair mr-2"></i>
                    Plan de la salle
                </h3>
            </div>
            <div class="card-body">
                <!-- Répartition par type de place -->
                <c:if test="${not empty placesByType.counts && placesByType.counts.size() > 0}">
                    <div class="mb-3">
                        <h6><i class="fas fa-list mr-2"></i>Répartition par type de place :</h6>
                        <div class="row">
                            <c:forEach var="entry" items="${placesByType.counts}">
                                <div class="col-md-4 mb-2">
                                    <div class="card card-sm border-left-info">
                                        <div class="card-body p-2">
                                            <c:set var="typePlace" value="${placesByType.types[entry.key]}" />
                                            <strong>${typePlace.nom}</strong>
                                            <div class="text-muted small">(${typePlace.code})</div>
                                            <div class="mt-1">
                                                <span class="badge badge-info">${entry.value} place<c:if test="${entry.value > 1}">s</c:if></span>
                                                <span class="ml-2 text-success font-weight-bold">
                                                    <fmt:formatNumber value="${entry.value * typePlace.prix}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <hr/>
                    </div>
                </c:if>

                <div class="seat-map" style="overflow-x: auto;">
                    <table class="table table-sm table-bordered text-center" style="width: auto; margin: auto;">
                        <thead>
                            <tr>
                                <th style="width: 30px;">Rg</th>
                                <c:forEach begin="1" end="${salle.nbColonnes}" var="col">
                                    <th style="width: 30px;">${col}</th>
                                </c:forEach>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach begin="1" end="${salle.nbRangees}" var="rang">
                                <tr>
                                    <td style="font-weight: bold;">${rang}</td>
                                    <c:forEach begin="1" end="${salle.nbColonnes}" var="col">
                                        <c:set var="place" value="${null}" />
                                        <c:forEach items="${places}" var="p">
                                            <c:if test="${p.rang == rang && p.col == col}">
                                                <c:set var="place" value="${p}" />
                                            </c:if>
                                        </c:forEach>
                                        
                                        <td>
                                            <c:choose>
                                                <c:when test="${place != null}">
                                                    <c:choose>
                                                        <c:when test="${place.statut == 4}">
                                                            <!-- Disponible -->
                                                            <span class="badge badge-success" style="cursor: pointer;" title="Place ${rang}-${col}: Disponible">
                                                                <i class="fas fa-chair"></i>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${place.statut == 5}">
                                                            <!-- En sélection -->
                                                            <span class="badge badge-warning" style="cursor: pointer;" title="Place ${rang}-${col}: En sélection">
                                                                <i class="fas fa-chair"></i>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${place.statut == 6}">
                                                            <!-- Réservée -->
                                                            <span class="badge badge-info" style="cursor: pointer;" title="Place ${rang}-${col}: Réservée">
                                                                <i class="fas fa-chair"></i>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${place.statut == 7}">
                                                            <!-- Vendue -->
                                                            <span class="badge badge-danger" style="cursor: pointer;" title="Place ${rang}-${col}: Vendue">
                                                                <i class="fas fa-chair"></i>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-secondary" style="cursor: pointer;">
                                                                <i class="fas fa-chair"></i>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-light">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <!-- Légende -->
                <div class="mt-3">
                    <h6>Légende :</h6>
                    <div>
                        <span class="badge badge-success mr-2"><i class="fas fa-chair"></i> Disponible</span>
                        <span class="badge badge-warning mr-2"><i class="fas fa-chair"></i> En sélection</span>
                        <span class="badge badge-info mr-2"><i class="fas fa-chair"></i> Réservée</span>
                        <span class="badge badge-danger mr-2"><i class="fas fa-chair"></i> Vendue</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card card-warning card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-cog mr-2"></i>
                    Actions
                </h3>
            </div>
            <div class="card-body">
                <div class="d-grid gap-2">
                    <a href="/salles/edit/${salle.id}" class="btn btn-info btn-block mb-2">
                        <i class="fas fa-edit mr-2"></i>
                        Modifier cette salle
                    </a>

                    <button type="button" class="btn btn-danger btn-block mb-2" data-toggle="modal" data-target="#deleteModal">
                        <i class="fas fa-trash mr-2"></i>
                        Supprimer cette salle
                    </button>

                    <a href="/salles" class="btn btn-default btn-block">
                        <i class="fas fa-arrow-left mr-2"></i>
                        Retour à la liste
                    </a>
                </div>
            </div>
        </div>

        <div class="card card-info card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-info-circle mr-2"></i>
                    Résumé
                </h3>
            </div>
            <div class="card-body">
                <div class="info-box bg-light">
                    <span class="info-box-icon bg-primary">
                        <i class="fas fa-door-open"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Salle</span>
                        <span class="info-box-number">${salle.numero}</span>
                    </div>
                </div>

                <div class="info-box bg-light">
                    <span class="info-box-icon bg-success">
                        <i class="fas fa-users"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Capacité</span>
                        <span class="info-box-number">${salle.capaciteTotal}</span>
                        <span class="progress-description">places au total</span>
                    </div>
                </div>

                <div class="info-box bg-light">
                    <span class="info-box-icon bg-warning">
                        <i class="fas fa-th"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Disposition</span>
                        <span class="info-box-number">${salle.nbRangees}×${salle.nbColonnes}</span>
                        <span class="progress-description">rangées × colonnes</span>
                    </div>
                </div>

                <c:if test="${not empty places}">
                    <div class="info-box bg-light">
                        <span class="info-box-icon bg-info">
                            <i class="fas fa-chair"></i>
                        </span>
                        <div class="info-box-content">
                            <span class="info-box-text">Places crées</span>
                            <span class="info-box-number">${places.size()}</span>
                            <span class="progress-description">places configurées</span>
                        </div>
                    </div>
                </c:if>

                <div class="info-box bg-light">
                    <span class="info-box-icon bg-success">
                        <i class="fas fa-money-bill-wave"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Revenu maximum</span>
                        <span class="info-box-number" style="font-size: 1.5rem;">
                            <fmt:formatNumber value="${revenueMax}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/>
                        </span>
                        <span class="progress-description">si toutes les places sont vendues</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Delete confirmation modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-danger">
                <h5 class="modal-title">
                    <i class="fas fa-exclamation-triangle mr-2"></i>
                    Confirmer la suppression
                </h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir supprimer la salle <strong>${salle.designation}</strong> ?</p>
                <p class="text-danger">
                    <i class="fas fa-exclamation-circle mr-2"></i>
                    Cette action est irréversible !
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    <i class="fas fa-times mr-1"></i>
                    Annuler
                </button>
                <form action="/salles/delete/${salle.id}" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash mr-1"></i>
                        Supprimer définitivement
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

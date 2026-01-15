<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="row">
    <div class="col-md-8">
        <div class="card card-primary card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-film mr-2"></i>
                    Informations du cinéma
                </h3>
                <div class="card-tools">
                    <a href="/cinemas/edit/${cinema.id}" class="btn btn-sm btn-info">
                        <i class="fas fa-edit mr-1"></i>
                        Modifier
                    </a>
                </div>
            </div>
            <div class="card-body">
                <dl class="row">
                    <dt class="col-sm-3"><i class="fas fa-hashtag mr-2 text-muted"></i>ID</dt>
                    <dd class="col-sm-9"><span class="badge badge-secondary">${cinema.id}</span></dd>

                    <dt class="col-sm-3"><i class="fas fa-film mr-2 text-muted"></i>Nom</dt>
                    <dd class="col-sm-9"><strong>${cinema.nom}</strong></dd>

                    <dt class="col-sm-3"><i class="fas fa-map-marker-alt mr-2 text-muted"></i>Adresse</dt>
                    <dd class="col-sm-9">${cinema.adresse}</dd>

                    <dt class="col-sm-3"><i class="fas fa-envelope mr-2 text-muted"></i>Email</dt>
                    <dd class="col-sm-9"><a href="mailto:${cinema.email}">${cinema.email}</a></dd>
                </dl>
            </div>
        </div>

        <div class="card card-secondary card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-clock mr-2"></i>
                    Historique
                </h3>
            </div>
            <div class="card-body">
                <dl class="row mb-0">
                    <dt class="col-sm-4"><i class="fas fa-calendar-plus mr-2 text-success"></i>Date de création</dt>
                    <dd class="col-sm-8">
                        <c:choose>
                            <c:when test="${cinema.createdAt != null}">
                                <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd MMMM yyyy ''à'' HH:mm', T(java.util.Locale).FRENCH).format(cinema.createdAt)" />
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </dd>

                    <dt class="col-sm-4"><i class="fas fa-calendar-check mr-2 text-warning"></i>Dernière modification</dt>
                    <dd class="col-sm-8">
                        <c:choose>
                            <c:when test="${cinema.updatedAt != null}">
                                <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd MMMM yyyy ''à'' HH:mm', T(java.util.Locale).FRENCH).format(cinema.updatedAt)" />
                            </c:when>
                            <c:otherwise>Jamais modifié</c:otherwise>
                        </c:choose>
                    </dd>
                </dl>
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
                    <a href="/cinemas/edit/${cinema.id}" class="btn btn-info btn-block mb-2">
                        <i class="fas fa-edit mr-2"></i>
                        Modifier ce cinéma
                    </a>

                    <button type="button" class="btn btn-danger btn-block mb-2" data-toggle="modal" data-target="#deleteModal">
                        <i class="fas fa-trash mr-2"></i>
                        Supprimer ce cinéma
                    </button>

                    <a href="/cinemas" class="btn btn-default btn-block">
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
                    Informations rapides
                </h3>
            </div>
            <div class="card-body">
                <div class="info-box bg-light">
                    <span class="info-box-icon bg-info">
                        <i class="fas fa-film"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Films disponibles</span>
                        <span class="info-box-number">0</span>
                        <span class="progress-description">À venir</span>
                    </div>
                </div>

                <div class="info-box bg-light">
                    <span class="info-box-icon bg-success">
                        <i class="fas fa-door-open"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Salles</span>
                        <span class="info-box-number">0</span>
                        <span class="progress-description">À venir</span>
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
                <p>Êtes-vous sûr de vouloir supprimer le cinéma <strong>${cinema.nom}</strong> ?</p>
                <p class="text-danger">
                    <i class="fas fa-exclamation-circle mr-2"></i>
                    Cette action est irréversible et supprimera toutes les données associées !
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    <i class="fas fa-times mr-1"></i>
                    Annuler
                </button>
                <form action="/cinemas/delete/${cinema.id}" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash mr-1"></i>
                        Supprimer définitivement
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

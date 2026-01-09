<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="row">
    <div class="col-md-8">
        <div class="card card-primary card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-layer-group mr-2"></i>
                    Informations du genre
                </h3>
                <div class="card-tools">
                    <a href="/films/genres/edit/${genre.id}" class="btn btn-sm btn-info">
                        <i class="fas fa-edit mr-1"></i>
                        Modifier
                    </a>
                </div>
            </div>
            <div class="card-body">
                <dl class="row">
                    <dt class="col-sm-3"><i class="fas fa-hashtag mr-2 text-muted"></i>ID</dt>
                    <dd class="col-sm-9"><span class="badge badge-secondary">${genre.id}</span></dd>

                    <dt class="col-sm-3"><i class="fas fa-layer-group mr-2 text-muted"></i>Nom</dt>
                    <dd class="col-sm-9"><strong>${genre.nom}</strong></dd>

                    <dt class="col-sm-3"><i class="fas fa-barcode mr-2 text-muted"></i>Code</dt>
                    <dd class="col-sm-9"><span class="badge badge-info">${genre.code}</span></dd>

                    <dt class="col-sm-3"><i class="fas fa-align-left mr-2 text-muted"></i>Description</dt>
                    <dd class="col-sm-9">
                        <c:choose>
                            <c:when test="${not empty genre.desce}">${genre.desce}</c:when>
                            <c:otherwise>Pas de description</c:otherwise>
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
                    <a href="/films/genres/edit/${genre.id}" class="btn btn-info btn-block mb-2">
                        <i class="fas fa-edit mr-2"></i>
                        Modifier ce genre
                    </a>

                    <button type="button"
                            class="btn btn-danger btn-block mb-2"
                            data-toggle="modal"
                            data-target="#deleteModal">
                        <i class="fas fa-trash mr-2"></i>
                        Supprimer ce genre
                    </button>

                    <a href="/films/genres" class="btn btn-default btn-block">
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
                    <span class="info-box-icon bg-primary">
                        <i class="fas fa-layer-group"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Nom</span>
                        <span class="info-box-number">${genre.nom}</span>
                    </div>
                </div>

                <div class="info-box bg-light">
                    <span class="info-box-icon bg-success">
                        <i class="fas fa-barcode"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Code</span>
                        <span class="info-box-number">${genre.code}</span>
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
                <p>Êtes-vous sûr de vouloir supprimer le genre <strong>${genre.nom}</strong> ?</p>
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
                <form action="/films/genres/delete/${genre.id}" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash mr-1"></i>
                        Supprimer définitivement
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

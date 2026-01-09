<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!-- Success message -->
<c:if test="${not empty message}">
    <div class="row">
        <div class="col-md-12">
            <div class="alert alert-success alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h5><i class="icon fas fa-check"></i> Succès!</h5>
                <span>${message}</span>
            </div>
        </div>
    </div>
</c:if>

<!-- Error message -->
<c:if test="${not empty error}">
    <div class="row">
        <div class="col-md-12">
            <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h5><i class="icon fas fa-ban"></i> Erreur!</h5>
                <span>${error}</span>
            </div>
        </div>
    </div>
</c:if>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-list mr-2"></i>
                    Liste des salles
                </h3>
                <div class="card-tools">
                    <a href="/salles/form" class="btn btn-primary btn-sm">
                        <i class="fas fa-plus mr-1"></i>
                        Nouvelle salle
                    </a>
                </div>
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <form action="/salles" method="get" class="form-inline">
                            <div class="input-group input-group-sm" style="width: 100%;">
                                <input type="text"
                                       name="search"
                                       class="form-control"
                                       placeholder="Rechercher une salle..."
                                       value="${search}">
                                <div class="input-group-append">
                                    <button type="submit" class="btn btn-default">
                                        <i class="fas fa-search"></i>
                                    </button>
                                    <c:if test="${not empty search}">
                                        <a href="/salles" class="btn btn-default">
                                            <i class="fas fa-times"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-bordered table-striped table-hover">
                        <thead>
                        <tr>
                            <th style="width: 50px">#</th>
                            <th>Numéro</th>
                            <th>Désignation</th>
                            <th>Capacité</th>
                            <th>Cinéma</th>
                            <th style="width: 150px">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty salles}">
                            <tr>
                                <td colspan="6" class="text-center text-muted">
                                    <i class="fas fa-inbox fa-3x mb-3"></i>
                                    <p>Aucune salle trouvée</p>
                                    <a href="/salles/form" class="btn btn-primary btn-sm">
                                        <i class="fas fa-plus mr-1"></i>
                                        Ajouter la première salle
                                    </a>
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="salle" items="${salles}" varStatus="iterStat">
                            <tr>
                                <td>${iterStat.count}</td>
                                <td><strong>${salle.numero}</strong></td>
                                <td>${salle.designation}</td>
                                <td>${salle.capaciteTotal}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cinemasById != null && cinemasById[salle.cinemaId] != null}">${cinemasById[salle.cinemaId].nom}</c:when>
                                        <c:otherwise>Non renseigné</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <a href="/salles/edit/${salle.id}" class="btn btn-info" title="Modifier"><i class="fas fa-edit"></i></a>
                                        <a href="/salles/view/${salle.id}" class="btn btn-primary" title="Voir détails"><i class="fas fa-eye"></i></a>
                                        <button type="button" class="btn btn-danger" data-id="${salle.id}" data-name="${salle.designation}" onclick="confirmDelete(this)" title="Supprimer"><i class="fas fa-trash"></i></button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <c:if test="${not empty salles}">
                <div class="card-footer clearfix">
                    <span class="text-muted">Total : <strong>${fn:length(salles)}</strong> salle(s)</span>
                </div>
            </c:if>
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
                <p>Êtes-vous sûr de vouloir supprimer la salle <strong id="salleName"></strong> ?</p>
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
                <form id="deleteForm" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash mr-1"></i>
                        Supprimer
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmDelete(button) {
        var id = button.dataset.id;
        var name = button.dataset.name;
        $('#salleName').text(name);
        $('#deleteForm').attr('action', '/salles/delete/' + id);
        $('#deleteModal').modal('show');
    }

    $(document).ready(function() {
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);
    });
</script>

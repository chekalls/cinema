<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

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

<!-- Main content -->
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-list mr-2"></i>
                    Liste des cinémas
                </h3>
                <div class="card-tools">
                    <a href="/cinemas/form" class="btn btn-primary btn-sm">
                        <i class="fas fa-plus mr-1"></i>
                        Nouveau cinéma
                    </a>
                </div>
            </div>
            <div class="card-body">
                <!-- Search bar -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <form action="/cinemas" method="get" class="form-inline">
                            <div class="input-group input-group-sm" style="width: 100%;">
                                <input type="text"
                                       name="search"
                                       class="form-control"
                                       placeholder="Rechercher un cinéma..."
                                       value="${search}">
                                <div class="input-group-append">
                                    <button type="submit" class="btn btn-default">
                                        <i class="fas fa-search"></i>
                                    </button>
                                    <c:if test="${not empty search}">
                                        <a href="/cinemas" class="btn btn-default">
                                            <i class="fas fa-times"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Table -->
                <div class="table-responsive">
                    <table class="table table-bordered table-striped table-hover">
                        <thead>
                        <tr>
                            <th style="width: 50px">#</th>
                            <th>Nom</th>
                            <th>Adresse</th>
                            <th>Email</th>
                            <th>Date de création</th>
                            <th style="width: 150px">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty cinemas}">
                            <tr>
                                <td colspan="6" class="text-center text-muted">
                                    <i class="fas fa-inbox fa-3x mb-3"></i>
                                    <p>Aucun cinéma trouvé</p>
                                    <a href="/cinemas/form" class="btn btn-primary btn-sm">
                                        <i class="fas fa-plus mr-1"></i>
                                        Ajouter le premier cinéma
                                    </a>
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="cinema" items="${cinemas}" varStatus="iterStat">
                            <tr>
                                <td>${iterStat.count}</td>
                                <td><strong>${cinema.nom}</strong></td>
                                <td>${cinema.adresse}</td>
                                <td>
                                    <a href="mailto:${cinema.email}">${cinema.email}</a>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cinema.createdAt != null}">
                                            <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(cinema.createdAt)" />
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <a href="/cinemas/edit/${cinema.id}"
                                           class="btn btn-info"
                                           title="Modifier">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="/cinemas/view/${cinema.id}"
                                           class="btn btn-primary"
                                           title="Voir détails">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <button type="button"
                                                class="btn btn-danger"
                                                data-id="${cinema.id}"
                                                data-name="${cinema.nom}"
                                                onclick="confirmDelete(this)"
                                                title="Supprimer">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <c:if test="${not empty cinemas}">
                <div class="card-footer clearfix">
                    <span class="text-muted">
                        Total : <strong>${fn:length(cinemas)}</strong> cinéma(s)
                    </span>
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
                <p>Êtes-vous sûr de vouloir supprimer le cinéma <strong id="cinemaName"></strong> ?</p>
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
        $('#cinemaName').text(name);
        $('#deleteForm').attr('action', '/cinemas/delete/' + id);
        $('#deleteModal').modal('show');
    }

    $(document).ready(function() {
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);
    });
</script>

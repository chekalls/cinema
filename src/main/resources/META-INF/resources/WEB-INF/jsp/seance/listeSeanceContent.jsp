<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

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
                <h3 class="card-title"><i class="fas fa-clock mr-2"></i> Liste des séances</h3>
                <div class="card-tools">
                    <a href="/seances/form" class="btn btn-primary btn-sm"><i class="fas fa-plus mr-1"></i> Nouvelle séance</a>
                </div>
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <form action="/seances" method="get" class="form-inline">
                            <div class="input-group input-group-sm" style="width: 100%;">
                                <input type="text" name="search" class="form-control" placeholder="Rechercher une séance..." value="${search}">
                                <div class="input-group-append">
                                    <button type="submit" class="btn btn-default"><i class="fas fa-search"></i></button>
                                    <c:if test="${not empty search}">
                                        <a href="/seances" class="btn btn-default"><i class="fas fa-times"></i></a>
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
                            <th style="width:50px">#</th>
                            <th>Film</th>
                            <th>Salle</th>
                            <th>Début</th>
                            <th>Fin</th>
                             <th>solde max</th>
                            <th style="width:150px">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty seances}">
                            <tr>
                                <td colspan="6" class="text-center text-muted">
                                    <i class="fas fa-inbox fa-3x mb-3"></i>
                                    <p>Aucune séance trouvée</p>
                                    <a href="/seances/form" class="btn btn-primary btn-sm"><i class="fas fa-plus mr-1"></i> Ajouter une séance</a>
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="seance" items="${seances}" varStatus="iterStat">
                            <tr>
                                <td>${iterStat.count}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${seance.film != null}">${seance.film.titre}</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${seance.salleId}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${seance.debut != null}">
                                            <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(seance.debut)" />
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${seance.fin != null}">
                                            <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(seance.fin)" />
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${seance.getSolde()}</td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <a href="/seances/edit/${seance.id}" class="btn btn-info" title="Modifier"><i class="fas fa-edit"></i></a>
                                        <a href="/seances/view/${seance.id}" class="btn btn-primary" title="Voir détails"><i class="fas fa-eye"></i></a>
                                        <button type="button" class="btn btn-danger" data-id="${seance.id}" data-film="${seance.film != null ? seance.film.titre : 'Séance'}" onclick="confirmDelete(this)" title="Supprimer"><i class="fas fa-trash"></i></button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-footer clearfix">
                <div class="row">
                    <div class="col-md-6">
                        <span class="text-muted">Total : <strong>${total}</strong> séance(s)</span>
                    </div>
                    <div class="col-md-6 text-right">
                        <c:if test="${totalPages > 1}">
                            <nav>
                                <ul class="pagination pagination-sm mb-0 justify-content-end">
                                    <c:url var="prevUrl" value="/seances">
                                        <c:param name="page" value="${page - 1}" />
                                        <c:param name="size" value="${size}" />
                                        <c:param name="search" value="${search}" />
                                    </c:url>
                                    <li class="page-item${page == 1 ? ' disabled' : ''}">
                                        <a class="page-link" href="${prevUrl}">«</a>
                                    </li>

                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <c:url var="pageUrl" value="/seances">
                                            <c:param name="page" value="${i}" />
                                            <c:param name="size" value="${size}" />
                                            <c:param name="search" value="${search}" />
                                        </c:url>
                                        <li class="page-item${i == page ? ' active' : ''}">
                                            <a class="page-link" href="${pageUrl}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <c:url var="nextUrl" value="/seances">
                                        <c:param name="page" value="${page + 1}" />
                                        <c:param name="size" value="${size}" />
                                        <c:param name="search" value="${search}" />
                                    </c:url>
                                    <li class="page-item${page == totalPages ? ' disabled' : ''}">
                                        <a class="page-link" href="${nextUrl}">»</a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Delete modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-danger">
                <h5 class="modal-title"><i class="fas fa-exclamation-triangle mr-2"></i> Confirmer la suppression</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir supprimer la séance <strong id="seanceName"></strong> ?</p>
                <p class="text-danger"><i class="fas fa-exclamation-circle mr-2"></i> Cette action est irréversible !</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><i class="fas fa-times mr-1"></i> Annuler</button>
                <form id="deleteForm" method="post" style="display:inline;"></form>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmDelete(button){
        var id = button.dataset.id;
        var name = button.dataset.film;
        $('#seanceName').text(name);
        $('#deleteForm').attr('action', '/seances/delete/' + id);
        $('#deleteForm').html('<button type="submit" class="btn btn-danger"><i class="fas fa-trash mr-1"></i> Supprimer</button>');
        $('#deleteModal').modal('show');
    }

    $(document).ready(function(){
        setTimeout(function(){ $('.alert').fadeOut('slow'); }, 5000);
    });
</script>

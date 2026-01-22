<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:if test="${not empty success}">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h5><i class="icon fas fa-check"></i> Succès!</h5>
        ${success}
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
        <div class="card card-primary card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-users mr-2"></i>
                    Types de personnes
                </h3>
                <div class="card-tools">
                    <a href="/personnes/types/form" class="btn btn-primary btn-sm">
                        <i class="fas fa-plus mr-1"></i>
                        Nouveau type
                    </a>
                </div>
            </div>

            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty typePersonnes}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th style="width: 10px">#</th>
                                        <th>Nom</th>
                                        <th class="text-center" style="width: 150px">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${typePersonnes}" var="typePersonne" varStatus="status">
                                        <tr>
                                            <td>${typePersonne.id}</td>
                                            <td>
                                                <span class="badge badge-info badge-lg">
                                                    <i class="fas fa-user mr-1"></i>
                                                    ${typePersonne.nom}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <a href="/personnes/types/form?id=${typePersonne.id}" 
                                                   class="btn btn-sm btn-info" 
                                                   title="Modifier">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button type="button" 
                                                        class="btn btn-sm btn-danger" 
                                                        title="Supprimer"
                                                        onclick="confirmerSuppression(${typePersonne.id}, '${typePersonne.nom}')">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="card-body text-center py-5">
                            <i class="fas fa-users fa-3x text-muted mb-3"></i>
                            <p class="text-muted">Aucun type de personne trouvé</p>
                            <a href="/personnes/types/form" class="btn btn-primary">
                                <i class="fas fa-plus mr-1"></i>
                                Créer le premier type
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty typePersonnes}">
                <div class="card-footer clearfix">
                    <div class="float-left">
                        <p class="text-muted mb-0">
                            <i class="fas fa-info-circle mr-1"></i>
                            Total: <strong>${typePersonnes.size()}</strong> type(s) de personne(s)
                        </p>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Info -->
<div class="row">
    <div class="col-12">
        <div class="card card-secondary">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-info-circle mr-2"></i>
                    À propos des types de personnes
                </h3>
            </div>
            <div class="card-body">
                <p class="mb-2">
                    Les types de personnes permettent de définir différentes catégories de clients pour appliquer des tarifs spécifiques.
                </p>
                <h6><strong>Exemples courants :</strong></h6>
                <ul class="mb-0">
                    <li><strong>Adulte :</strong> Tarif standard</li>
                    <li><strong>Enfant :</strong> Tarif réduit (généralement -50%)</li>
                    <li><strong>Étudiant :</strong> Tarif réduit avec justificatif</li>
                    <li><strong>Senior :</strong> Tarif réduit pour les personnes âgées</li>
                    <li><strong>PMR :</strong> Tarif spécifique pour personnes à mobilité réduite</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<!-- Modal de confirmation de suppression -->
<form id="deleteForm" method="post" action="/personnes/types/delete">
    <input type="hidden" name="id" id="deleteId">
</form>

<script>
    function confirmerSuppression(id, nom) {
        if (confirm('Êtes-vous sûr de vouloir supprimer le type de personne "' + nom + '" ?\n\nAttention : Cette action est irréversible et peut affecter les tarifs associés.')) {
            document.getElementById('deleteId').value = id;
            document.getElementById('deleteForm').submit();
        }
    }
</script>

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
        <div class="card card-primary card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-ticket-alt mr-2"></i>
                    Liste des billets
                </h3>
                <div class="card-tools">
                    <a href="/billets/achatForm" class="btn btn-primary btn-sm">
                        <i class="fas fa-plus mr-1"></i>
                        Acheter un billet
                    </a>
                </div>
            </div>

            <!-- Filtres -->
            <div class="card-body border-bottom">
                <form method="get" action="/billets" class="form-horizontal">
                    <div class="row">
                        <!-- Recherche -->
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Recherche</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                                    </div>
                                    <input type="text" name="search" class="form-control" 
                                           placeholder="ID, Film..." 
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

                        <!-- Statut -->
                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Statut</label>
                                <select name="statutId" class="form-control">
                                    <option value="">Tous les statuts</option>
                                    <c:forEach items="${statuts}" var="statut">
                                        <option value="${statut.id}" ${statutId == statut.id ? 'selected' : ''}>
                                            ${statut.nom}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Date d'achat -->
                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Date d'achat</label>
                                <input type="date" name="dateAchat" class="form-control" 
                                       value="${dateAchat}">
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
                                    <a href="/billets" class="btn btn-default btn-block mt-1">
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
                    <c:when test="${empty billets}">
                        <div class="text-center py-5">
                            <i class="fas fa-ticket-alt fa-3x text-muted mb-3"></i>
                            <p class="text-muted">Aucun billet trouvé</p>
                            <a href="/billets/achatForm" class="btn btn-primary">
                                <i class="fas fa-plus mr-2"></i>
                                Acheter un billet
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-hover table-head-fixed text-nowrap">
                            <thead>
                                <tr>
                                    <th style="width: 80px;">ID</th>
                                    <th>Film</th>
                                    <th>Séance</th>
                                    <th>Place</th>
                                    <th>Tarif</th>
                                    <th>Prix</th>
                                    <th>Date achat</th>
                                    <th>Statut</th>
                                    <th style="width: 100px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${billets}" var="billet">
                                    <tr>
                                        <td><span class="badge badge-primary">#${billet.id}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${billet.seance != null && billet.seance.film != null}">
                                                    <strong>${billet.seance.film.titre}</strong>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${billet.seance != null}">
                                                    <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(billet.seance.debut)" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${billet.place != null}">
                                                    <span class="badge badge-info">R${billet.place.rang}-C${billet.place.col}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${billet.tarif != null}">
                                                    ${billet.tarif.nom}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <strong>${billet.prixReel} €</strong>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${billet.dateAchat != null}">
                                                    <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(billet.dateAchat)" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${billet.statutDetails != null}">
                                                <c:choose>
                                                    <c:when test="${billet.statutDetails.code == 'PANIER'}">
                                                        <span class="badge badge-warning">Panier</span>
                                                    </c:when>
                                                    <c:when test="${billet.statutDetails.code == 'VENDUE'}">
                                                        <span class="badge badge-success">Vendu</span>
                                                    </c:when>
                                                    <c:when test="${billet.statutDetails.code == 'PAYE'}">
                                                        <span class="badge badge-info">Payé</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-secondary">${billet.statutDetails.nom}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                        </td>
                                        <td>
                                            <div class="btn-group">
                                                <a href="/billets/view/${billet.id}" 
                                                   class="btn btn-sm btn-info" 
                                                   title="Voir">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty billets}">
                <div class="card-footer clearfix">
                    <div class="float-left">
                        <span class="text-muted">
                            <strong>${billets.size()}</strong> billet(s)
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
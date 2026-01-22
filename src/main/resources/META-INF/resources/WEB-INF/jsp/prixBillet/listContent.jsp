<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="content-wrapper">
    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1>Gestion des prix de billets</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="/">Accueil</a></li>
                        <li class="breadcrumb-item active">Prix de billets</li>
                    </ol>
                </div>
            </div>
        </div>
    </section>

    <section class="content">
        <div class="container-fluid">
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                    <i class="icon fas fa-check"></i> ${success}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                    <i class="icon fas fa-ban"></i> ${error}
                </div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Filtres</h3>
                    <div class="card-tools">
                        <a href="/prix-billets/form" class="btn btn-primary btn-sm">
                            <i class="fas fa-plus"></i> Nouveau prix
                        </a>
                        <a href="/prix-billets/historique" class="btn btn-info btn-sm">
                            <i class="fas fa-history"></i> Historique complet
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <form method="get" action="/prix-billets" class="form-inline">
                        <div class="form-group mr-2 mb-2">
                            <label for="typePlaceId" class="mr-2">Type de place:</label>
                            <select name="typePlaceId" id="typePlaceId" class="form-control">
                                <option value="">Tous</option>
                                <c:forEach items="${typePlaces}" var="tp">
                                    <option value="${tp.id}" ${typePlaceId == tp.id ? 'selected' : ''}>
                                        ${tp.nom}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group mr-2 mb-2">
                            <label for="typePersonneId" class="mr-2">Type de personne:</label>
                            <select name="typePersonneId" id="typePersonneId" class="form-control">
                                <option value="">Tous</option>
                                <c:forEach items="${typePersonnes}" var="tp">
                                    <option value="${tp.id}" ${typePersonneId == tp.id ? 'selected' : ''}>
                                        ${tp.nom}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group mr-2 mb-2">
                            <label for="actif" class="mr-2">Statut:</label>
                            <select name="actif" id="actif" class="form-control">
                                <option value="">Tous</option>
                                <option value="true" ${actif == true ? 'selected' : ''}>Actif</option>
                                <option value="false" ${actif == false ? 'selected' : ''}>Inactif</option>
                            </select>
                        </div>

                        <div class="form-group mr-2 mb-2">
                            <label for="prixMin" class="mr-2">Prix min:</label>
                            <input type="number" name="prixMin" id="prixMin" class="form-control" 
                                   value="${prixMin}" placeholder="0" step="1000">
                        </div>

                        <div class="form-group mr-2 mb-2">
                            <label for="prixMax" class="mr-2">Prix max:</label>
                            <input type="number" name="prixMax" id="prixMax" class="form-control" 
                                   value="${prixMax}" placeholder="100000" step="1000">
                        </div>

                        <button type="submit" class="btn btn-primary mb-2">
                            <i class="fas fa-search"></i> Filtrer
                        </button>
                        <a href="/prix-billets" class="btn btn-secondary ml-2 mb-2">
                            <i class="fas fa-redo"></i> Réinitialiser
                        </a>
                    </form>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-ticket-alt"></i> Liste des prix actuels
                    </h3>
                </div>
                <div class="card-body table-responsive p-0">
                    <table class="table table-hover text-nowrap">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Type de place</th>
                                <th>Type de personne</th>
                                <th>Prix de base</th>
                                <th>Réduction</th>
                                <th>Prix réel</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${prixBillets}" var="prix">
                                <tr>
                                    <td>
                                        <fmt:formatDate value="${prix.datePrix}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty prix.typePlace}">
                                                <span class="badge badge-info">${prix.typePlace.nom}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Non spécifié</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty prix.typePersone}">
                                                ${prix.typePersone.nom}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Tous</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${prix.prixBase}" type="number" groupingUsed="true"/> Ar
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${prix.reduction > 0}">
                                                <span class="badge badge-success">${prix.reduction}%</span>
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <strong><fmt:formatNumber value="${prix.prixReel}" type="number" groupingUsed="true"/> Ar</strong>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${prix.actif}">
                                                <span class="badge badge-success">Actif</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-secondary">Inactif</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <a href="/prix-billets/form?id=${prix.id}" 
                                               class="btn btn-info" 
                                               title="Modifier">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <form action="/prix-billets/toggle-actif/${prix.id}" 
                                                  method="post" 
                                                  style="display:inline;">
                                                <button type="submit" 
                                                        class="btn ${prix.actif ? 'btn-warning' : 'btn-success'}" 
                                                        title="${prix.actif ? 'Désactiver' : 'Activer'}">
                                                    <i class="fas ${prix.actif ? 'fa-toggle-off' : 'fa-toggle-on'}"></i>
                                                </button>
                                            </form>
                                            <a href="/prix-billets/delete/${prix.id}" 
                                               class="btn btn-danger" 
                                               title="Supprimer"
                                               onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce prix ?')">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty prixBillets}">
                                <tr>
                                    <td colspan="8" class="text-center text-muted">
                                        <i class="fas fa-info-circle"></i> Aucun prix trouvé
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                <div class="card-footer">
                    <div class="float-right">
                        Total: <strong>${prixBillets.size()}</strong> prix
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

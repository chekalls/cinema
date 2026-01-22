<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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

<!-- Filtres actifs -->
<c:if test="${not empty search || not empty typePlaceId || not empty typePersonneId || not empty statut || not empty prixMin || not empty prixMax}">
    <div class="alert alert-info alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h5><i class="icon fas fa-filter"></i> Filtres actifs</h5>
        <div class="d-flex flex-wrap">
            <c:if test="${not empty search}">
                <span class="badge badge-primary mr-2 mb-1">ID: ${search}</span>
            </c:if>
            <c:if test="${not empty typePlaceId}">
                <span class="badge badge-primary mr-2 mb-1">
                    Type de place: 
                    <c:forEach items="${typePlaces}" var="tp">
                        <c:if test="${tp.id == typePlaceId}">${tp.nom}</c:if>
                    </c:forEach>
                </span>
            </c:if>
            <c:if test="${not empty typePersonneId}">
                <span class="badge badge-primary mr-2 mb-1">
                    Type de personne: 
                    <c:forEach items="${typePersonnes}" var="tpers">
                        <c:if test="${tpers.id == typePersonneId}">${tpers.nom}</c:if>
                    </c:forEach>
                </span>
            </c:if>
            <c:if test="${not empty statut}">
                <span class="badge badge-primary mr-2 mb-1">
                    Statut: ${statut == 'principal' ? 'Principal' : 'Dérivé'}
                </span>
            </c:if>
            <c:if test="${not empty prixMin}">
                <span class="badge badge-primary mr-2 mb-1">Prix min: ${prixMin} Ar</span>
            </c:if>
            <c:if test="${not empty prixMax}">
                <span class="badge badge-primary mr-2 mb-1">Prix max: ${prixMax} Ar</span>
            </c:if>
        </div>
    </div>
</c:if>

<div class="row">
    <div class="col-12">
        <div class="card card-primary card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-tags mr-2"></i>
                    Liste des tarifs
                </h3>
                <div class="card-tools">
                    <a href="/billets/tarifs/form" class="btn btn-primary btn-sm">
                        <i class="fas fa-plus mr-1"></i>
                        Nouveau tarif
                    </a>
                </div>
            </div>

            <!-- Filtres -->
            <div class="card-body border-bottom">
                <form method="get" action="/billets/tarifs" class="form-horizontal">
                    <div class="row">
                        <!-- Recherche par ID -->
                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Recherche ID</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                                    </div>
                                    <input type="text" name="search" class="form-control" 
                                           placeholder="ID..." 
                                           value="${search}">
                                </div>
                            </div>
                        </div>

                        <!-- Type de place -->
                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Type de place</label>
                                <select name="typePlaceId" class="form-control">
                                    <option value="">Tous</option>
                                    <c:forEach items="${typePlaces}" var="typePlace">
                                        <option value="${typePlace.id}" ${typePlaceId == typePlace.id ? 'selected' : ''}>
                                            ${typePlace.nom}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Type de personne -->
                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Type de personne</label>
                                <select name="typePersonneId" class="form-control">
                                    <option value="">Tous</option>
                                    <c:forEach items="${typePersonnes}" var="typePersonne">
                                        <option value="${typePersonne.id}" ${typePersonneId == typePersonne.id ? 'selected' : ''}>
                                            ${typePersonne.nom}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Statut -->
                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Statut</label>
                                <select name="statut" class="form-control">
                                    <option value="">Tous</option>
                                    <option value="principal" ${statut == 'principal' ? 'selected' : ''}>Principal</option>
                                    <option value="derive" ${statut == 'derive' ? 'selected' : ''}>Dérivé</option>
                                </select>
                            </div>
                        </div>

                        <!-- Prix Min -->
                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Prix min (Ar)</label>
                                <input type="number" step="0.01" name="prixMin" class="form-control" 
                                       placeholder="0.00" 
                                       value="${prixMin}">
                            </div>
                        </div>

                        <!-- Prix Max -->
                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Prix max (Ar)</label>
                                <input type="number" step="0.01" name="prixMax" class="form-control" 
                                       placeholder="999999.99" 
                                       value="${prixMax}">
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-filter mr-1"></i>
                                Filtrer
                            </button>
                            <a href="/billets/tarifs" class="btn btn-default">
                                <i class="fas fa-redo mr-1"></i>
                                Réinitialiser
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty tarifs}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th style="width: 10px">#</th>
                                        <th>Type de place</th>
                                        <th>Type de personne</th>
                                        <th class="text-right">Prix de base</th>
                                        <th class="text-center">Réduction</th>
                                        <th class="text-right">Prix final</th>
                                        <th class="text-center">Statut</th>
                                        <th class="text-center" style="width: 120px">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${tarifs}" var="tarif" varStatus="status">
                                        <tr>
                                            <td>${tarif.id}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty tarif.typePlace}">
                                                        <span class="badge badge-info">
                                                            <i class="fas fa-couch mr-1"></i>
                                                            ${tarif.typePlace.nom}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty tarif.typePersone}">
                                                        <span class="badge badge-secondary">
                                                            <i class="fas fa-user mr-1"></i>
                                                            ${tarif.typePersone.nom}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Tous</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-right">
                                                <strong>
                                                    <fmt:formatNumber value="${tarif.prixPlace}" type="number" 
                                                                    minFractionDigits="2" maxFractionDigits="2"/> Ar
                                                </strong>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${not empty tarif.reduction && tarif.reduction > 0}">
                                                        <span class="badge badge-success">
                                                            <i class="fas fa-percent mr-1"></i>
                                                            <fmt:formatNumber value="${tarif.reduction}" type="number" 
                                                                            minFractionDigits="0" maxFractionDigits="2"/>%
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-right">
                                                <c:choose>
                                                    <c:when test="${not empty tarif.reduction && tarif.reduction > 0}">
                                                        <span class="text-success font-weight-bold">
                                                            <fmt:formatNumber value="${tarif.prixFinal}" type="number" 
                                                                            minFractionDigits="2" maxFractionDigits="2"/> Ar
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="font-weight-bold">
                                                            <fmt:formatNumber value="${tarif.prixPlace}" type="number" 
                                                                            minFractionDigits="2" maxFractionDigits="2"/> Ar
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${not empty tarif.parentId}">
                                                        <span class="badge badge-warning">
                                                            <i class="fas fa-link mr-1"></i>
                                                            Dérivé
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-primary">
                                                            <i class="fas fa-star mr-1"></i>
                                                            Principal
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            <td class="text-center">
                                                <a href="/billets/tarifs/form?id=${tarif.id}" 
                                                   class="btn btn-sm btn-info" 
                                                   title="Modifier">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                            </td>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="card-body text-center py-5">
                            <i class="fas fa-tags fa-3x text-muted mb-3"></i>
                            <p class="text-muted">Aucun tarif trouvé</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty tarifs}">
                <div class="card-footer clearfix">
                    <div class="float-left">
                        <p class="text-muted mb-0">
                            <i class="fas fa-info-circle mr-1"></i>
                            <c:choose>
                                <c:when test="${not empty search || not empty typePlaceId || not empty typePersonneId || not empty statut || not empty prixMin || not empty prixMax}">
                                    <strong>${tarifs.size()}</strong> tarif(s) trouvé(s) (filtres actifs)
                                </c:when>
                                <c:otherwise>
                                    Total: <strong>${tarifs.size()}</strong> tarif(s)
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <c:if test="${not empty search || not empty typePlaceId || not empty typePersonneId || not empty statut || not empty prixMin || not empty prixMax}">
                        <div class="float-right">
                            <a href="/billets/tarifs" class="btn btn-sm btn-default">
                                <i class="fas fa-times mr-1"></i>
                                Supprimer les filtres
                            </a>
                        </div>
                    </c:if>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Légende -->
<div class="row">
    <div class="col-12">
        <div class="card card-secondary">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-info-circle mr-2"></i>
                    Légende
                </h3>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6><strong>Statut des tarifs:</strong></h6>
                        <ul class="list-unstyled">
                            <li><span class="badge badge-primary"><i class="fas fa-star"></i> Principal</span> - Tarif de base</li>
                            <li><span class="badge badge-warning"><i class="fas fa-link"></i> Dérivé</span> - Tarif avec réduction appliquée</li>
                        </ul>
                        <a href="/personnes/types" class="btn btn-sm btn-outline-primary">
                            <i class="fas fa-users mr-1"></i>
                            Gérer les types de personnes
                        </a>
                    </div>
                    <div class="col-md-6">
                        <h6><strong>Calcul du prix final:</strong></h6>
                        <p class="text-muted mb-0">
                            <strong>Tarif principal :</strong> Prix final = Prix de base<br>
                            <strong>Tarif dérivé :</strong> Prix final = Prix parent - (Prix parent × Réduction / 100)<br>
                            <small><em>Le prix du parent est utilisé comme base pour calculer la réduction</em></small>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

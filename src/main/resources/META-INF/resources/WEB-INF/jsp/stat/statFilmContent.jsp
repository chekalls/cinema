<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="row">
    <div class="col-md-12">
        <!-- Formulaire de filtrage -->
        <div class="card card-primary card-outline mb-3">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-filter mr-2"></i>
                    Filtres
                </h3>
            </div>
            <div class="card-body">
                <form action="/stats/films" method="get" class="form-inline">
                    <div class="form-group mr-3 mb-2">
                        <label for="filmId" class="mr-2">Film(s) :</label>
                        <select name="filmId" id="filmId" class="form-control form-control-sm" multiple size="4">
                            <c:forEach items="${films}" var="film">
                                <option value="${film.id}" <c:if test="${not empty filmId and filmId.contains(film.id)}">selected</c:if>>${film.titre}</option>
                            </c:forEach>
                        </select>
                        <small class="form-text text-muted">
                            Maintenez Ctrl/Cmd pour sélectionner plusieurs films.
                            <c:if test="${not empty total}">Affichage limité (page ${page}/${totalPages}). Utilisez la recherche.</c:if>
                        </small>
                    </div>

                    <div class="form-group mr-3 mb-2">
                        <label for="search" class="mr-2">Recherche :</label>
                        <input type="text" name="search" id="search" class="form-control form-control-sm"
                               placeholder="Titre, réalisateur, acteurs..." value="${search}">
                        <input type="hidden" name="page" value="1">
                        <input type="hidden" name="size" value="${empty size ? 50 : size}">
                    </div>

                    <div class="form-group mr-3 mb-2">
                        <label for="dateDebut" class="mr-2">Du :</label>
                        <input type="date" name="dateDebut" id="dateDebut" class="form-control form-control-sm" value="${dateDebut}">
                    </div>

                    <div class="form-group mr-3 mb-2">
                        <label for="dateFin" class="mr-2">Au :</label>
                        <input type="date" name="dateFin" id="dateFin" class="form-control form-control-sm" value="${dateFin}">
                    </div>

                    <button type="submit" class="btn btn-primary btn-sm mb-2">
                        <i class="fas fa-search mr-1"></i>
                        Filtrer
                    </button>
                    <a href="/stats/films" class="btn btn-default btn-sm mb-2 ml-2">
                        <i class="fas fa-times mr-1"></i>
                        Réinitialiser
                    </a>
                </form>
            </div>
        </div>

        <!-- Affichage des statistiques -->
        <c:if test="${not empty warning}">
            <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle mr-2"></i>
                ${warning}
            </div>
        </c:if>

        <c:if test="${not empty filmsComparaison && not empty statsComparaison}">
            <div class="row">
                <c:forEach var="entry" items="${filmsComparaison}">
                    <c:set var="film" value="${entry.value}" />
                    <c:set var="stats" value="${statsComparaison[entry.key]}" />

                    <div class="col-md-6 mb-3">
                        <div class="card card-outline card-info">
                            <div class="card-header">
                                <h3 class="card-title">${film.titre}</h3>
                            </div>

                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="info-box bg-light">
                                            <span class="info-box-icon bg-info">
                                                <i class="fas fa-video"></i>
                                            </span>
                                            <div class="info-box-content">
                                                <span class="info-box-text">Séances</span>
                                                <span class="info-box-number">${stats.totalSeances}</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="info-box bg-light">
                                            <span class="info-box-icon bg-success">
                                                <i class="fas fa-ticket-alt"></i>
                                            </span>
                                            <div class="info-box-content">
                                                <span class="info-box-text">Billets vendus</span>
                                                <span class="info-box-number">${stats.totalBillets}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row mt-2">
                                    <div class="col-md-6">
                                        <div class="info-box bg-light">
                                            <span class="info-box-icon bg-warning">
                                                <i class="fas fa-percentage"></i>
                                            </span>
                                            <div class="info-box-content">
                                                <span class="info-box-text">Occupation moy.</span>
                                                <span class="info-box-number"><fmt:formatNumber value="${stats.avgOccupancy}" type="number" minFractionDigits="1" maxFractionDigits="1"/>%</span>
                                                <span class="progress-description">moyenne des séances</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="info-box bg-light">
                                            <span class="info-box-icon bg-success">
                                                <i class="fas fa-money-bill-wave"></i>
                                            </span>
                                            <div class="info-box-content">
                                                <span class="info-box-text">Chiffre d'affaires</span>
                                                <span class="info-box-number" style="font-size: 1.2rem;">
                                                    <fmt:formatNumber value="${stats.totalRevenue}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row mt-2">
                                    <div class="col-md-12">
                                        <div class="info-box bg-light">
                                            <span class="info-box-icon bg-info">
                                                <i class="fas fa-receipt"></i>
                                            </span>
                                            <div class="info-box-content">
                                                <span class="info-box-text">Panier moyen</span>
                                                <span class="info-box-number">
                                                    <fmt:formatNumber value="${stats.avgTicket}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Répartition par salle -->
                                <div class="mt-3">
                                    <h6><i class="fas fa-door-open mr-2"></i>Par salle :</h6>
                                    <c:if test="${not empty stats.parSalle}">
                                        <div class="table-responsive">
                                            <table class="table table-sm table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Salle</th>
                                                        <th>Billets vendus</th>
                                                        <th>CA</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${stats.parSalle}" var="row">
                                                        <tr>
                                                            <td>${row['designation']} (${row['numero']})</td>
                                                            <td><span class="badge badge-success">${row['billets']}</span></td>
                                                            <td>
                                                                <fmt:formatNumber value="${row['revenue']}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:if>
                                    <c:if test="${empty stats.parSalle}">
                                        <p class="text-muted text-sm">Aucune salle trouvée.</p>
                                    </c:if>
                                </div>

                                <!-- Répartition par statut de billet -->
                                <div class="mt-3">
                                    <h6><i class="fas fa-list mr-2"></i>Par statut :</h6>
                                    <c:if test="${not empty stats.parStatut}">
                                        <div class="table-responsive">
                                            <table class="table table-sm table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Statut</th>
                                                        <th>Nombre</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${stats.parStatut}" var="row">
                                                        <tr>
                                                            <td>${row['nom']}</td>
                                                            <td><span class="badge badge-success">${row['count']}</span></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:if>
                                    <c:if test="${empty stats.parStatut}">
                                        <p class="text-muted text-sm">Aucun billet trouvé.</p>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty filmsComparaison}">
            <div class="alert alert-info">
                <i class="fas fa-info-circle mr-2"></i>
                Sélectionnez un ou plusieurs films ci-dessus pour afficher leurs statistiques.
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle mr-2"></i>
                ${error}
            </div>
        </c:if>
    </div>
</div>

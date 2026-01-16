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
                <form action="/stats/salles" method="get" class="form-inline">
                    <div class="form-group mr-3 mb-2">
                        <label for="salleId" class="mr-2">Salle(s) :</label>
                        <select name="salleId" id="salleId" class="form-control form-control-sm" multiple size="4">
                            <c:forEach items="${salles}" var="salle">
                                <option value="${salle.id}" <c:if test="${not empty salleId and salleId.contains(salle.id)}">selected</c:if>>${salle.designation} (${salle.numero})</option>
                            </c:forEach>
                        </select>
                        <small class="form-text text-muted">Maintenez Ctrl/Cmd pour sélectionner plusieurs salles</small>
                    </div>

                    <div class="form-group mr-3 mb-2">
                        <label for="cinemaId" class="mr-2">Cinéma :</label>
                        <select name="cinemaId" id="cinemaId" class="form-control form-control-sm">
                            <option value="">-- Tous les cinémas --</option>
                            <c:forEach items="${cinemas}" var="cinema">
                                <option value="${cinema.id}" <c:if test="${cinema.id == cinemaId}">selected</c:if>>${cinema.nom}</option>
                            </c:forEach>
                        </select>
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
                    <a href="/stats/salles" class="btn btn-default btn-sm mb-2 ml-2">
                        <i class="fas fa-times mr-1"></i>
                        Réinitialiser
                    </a>
                </form>
            </div>
        </div>

        <!-- Affichage des statistiques -->
        <c:if test="${not empty sallesComparaison && not empty statsComparaison}">
            <div class="row">
                <c:forEach var="entry" items="${sallesComparaison}">
                    <c:set var="salle" value="${entry.value}" />
                    <c:set var="stats" value="${statsComparaison[entry.key]}" />

                    <!-- Statistiques principales -->
                    <div class="col-md-6 mb-3">
                        <div class="card card-outline card-info">
                            <div class="card-header">
                                <h3 class="card-title">${salle.designation} (${salle.numero})</h3>
                            </div>

                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="info-box bg-light">
                                            <span class="info-box-icon bg-success">
                                                <i class="fas fa-ticket-alt"></i>
                                            </span>
                                            <div class="info-box-content">
                                                <span class="info-box-text">Billets vendus</span>
                                                <span class="info-box-number">${stats.totalBillets}</span>
                                                <span class="progress-description">sur ${stats.theoreticalCapacity}</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="info-box bg-light">
                                            <span class="info-box-icon bg-warning">
                                                <i class="fas fa-percentage"></i>
                                            </span>
                                            <div class="info-box-content">
                                                <span class="info-box-text">Taux d'occupation</span>
                                                <span class="info-box-number"><fmt:formatNumber value="${stats.occupationRate}" type="number" minFractionDigits="1" maxFractionDigits="1"/>%</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row mt-2">
                                    <div class="col-md-6">
                                        <div class="info-box bg-light">
                                            <span class="info-box-icon bg-info">
                                                <i class="fas fa-video"></i>
                                            </span>
                                            <div class="info-box-content">
                                                <span class="info-box-text">Séances</span>
                                                <span class="info-box-number">${stats.totalSeances}</span>
                                                <span class="progress-description">période sélectionnée</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="info-box bg-light">
                                            <span class="info-box-icon bg-secondary">
                                                <i class="fas fa-couch"></i>
                                            </span>
                                            <div class="info-box-content">
                                                <span class="info-box-text">Capacité période</span>
                                                <span class="info-box-number">${stats.theoreticalCapacity}</span>
                                                <span class="progress-description">places × séances</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row mt-2">
                                    <div class="col-md-12">
                                        <div class="info-box bg-light">
                                            <span class="info-box-icon bg-success">
                                                <i class="fas fa-money-bill-wave"></i>
                                            </span>
                                            <div class="info-box-content">
                                                <span class="info-box-text">Chiffre d'affaires</span>
                                                <span class="info-box-number"><fmt:formatNumber value="${stats.totalRevenue}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/></span>
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
                                                <span class="info-box-number"><fmt:formatNumber value="${stats.avgTicket}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Répartition par type de place -->
                                <div class="mt-3">
                                    <h6><i class="fas fa-couch mr-2"></i>Par type de place :</h6>
                                    <c:if test="${not empty stats.placeParType}">
                                        <div class="table-responsive">
                                            <table class="table table-sm table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Type</th>
                                                        <th>Nombre</th>
                                                        <th>Prix</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${stats.placeParType}" var="row">
                                                        <tr>
                                                            <td>${row['nom'] != null ? row['nom'] : '-'}</td>
                                                            <td><span class="badge badge-success">${row['count']}</span></td>
                                                            <td>
                                                                <c:if test="${row['prix'] != null}">
                                                                    <fmt:formatNumber value="${row['prix']}" type="currency" currencySymbol="" minFractionDigits="0" maxFractionDigits="0"/>
                                                                </c:if>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Répartition par statut de billet -->
                                <div class="mt-3">
                                    <h6><i class="fas fa-list mr-2"></i>Par statut :</h6>
                                    <c:if test="${not empty stats.billetParStatut}">
                                        <div class="table-responsive">
                                            <table class="table table-sm table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Statut</th>
                                                        <th>Nombre</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${stats.billetParStatut}" var="row">
                                                        <tr>
                                                            <td>${row['nom']}</td>
                                                            <td><span class="badge badge-success">${row['count']}</span></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty sallesComparaison}">
            <div class="alert alert-info">
                <i class="fas fa-info-circle mr-2"></i>
                Sélectionnez une ou plusieurs salles ci-dessus pour afficher leurs statistiques.
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

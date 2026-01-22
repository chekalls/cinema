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
    <!-- Filtre de date -->
    <div class="col-md-12">
        <div class="card card-outline card-secondary collapsed-card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-calendar-alt mr-2"></i>
                    Filtrer par date
                </h3>
                <div class="card-tools">
                    <button type="button" class="btn btn-tool" data-card-widget="collapse">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
            </div>
            <div class="card-body">
                <form action="/seances/view/${seance.id}" method="get" class="form-inline">
                    <div class="form-group mr-3">
                        <label for="dateFilter" class="mr-2">
                            <i class="fas fa-clock mr-1"></i>
                            Date et heure :
                        </label>
                        <input type="datetime-local" 
                               class="form-control" 
                               id="dateFilter" 
                               name="date" 
                               value="${param.date}">
                    </div>
                    <button type="submit" class="btn btn-primary mr-2">
                        <i class="fas fa-search mr-1"></i>
                        Appliquer
                    </button>
                    <a href="/seances/view/${seance.id}" class="btn btn-default">
                        <i class="fas fa-redo mr-1"></i>
                        Réinitialiser
                    </a>
                    <c:if test="${not empty param.date}">
                        <span class="badge badge-info ml-3">
                            <i class="fas fa-filter mr-1"></i>
                            Filtré
                        </span>
                    </c:if>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <!-- Informations principales -->
    <div class="col-md-8">
        <div class="card card-info">
            <div class="card-header">
                <h3 class="card-title"><i class="fas fa-eye mr-2"></i> Détails de la séance</h3>
                <div class="card-tools">
                    <a href="/seances/edit/${seance.id}" class="btn btn-light btn-sm"><i class="fas fa-edit mr-1"></i> Modifier</a>
                    <a href="/seances" class="btn btn-light btn-sm"><i class="fas fa-list mr-1"></i> Liste</a>
                </div>
            </div>

            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-box bg-light">
                            <span class="info-box-icon bg-info"><i class="fas fa-film"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Film</span>
                                <span class="info-box-number">
                                    <c:choose>
                                        <c:when test="${seance.film != null}">${seance.film.titre}</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-box bg-light">
                            <span class="info-box-icon bg-success"><i class="fas fa-door-open"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Salle</span>
                                <span class="info-box-number">
                                    <c:choose>
                                        <c:when test="${seance.salle != null}">${seance.salle.designation}</c:when>
                                        <c:otherwise>${seance.salleId}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="info-box bg-light">
                            <span class="info-box-icon bg-warning"><i class="fas fa-play"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Début</span>
                                <span class="info-box-number">
                                    <c:choose>
                                        <c:when test="${seance.debut != null}">
                                            <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(seance.debut)" />
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-box bg-light">
                            <span class="info-box-icon bg-danger"><i class="fas fa-stop"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Fin</span>
                                <span class="info-box-number">
                                    <c:choose>
                                        <c:when test="${seance.fin != null}">
                                            <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(seance.fin)" />
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card-footer">
                <a href="/seances/edit/${seance.id}" class="btn btn-info"><i class="fas fa-edit mr-1"></i> Modifier</a>
                <a href="/seances" class="btn btn-default"><i class="fas fa-arrow-left mr-1"></i> Retour</a>
            </div>
        </div>

        <!-- Plan de la salle -->
        <c:if test="${seance.salle != null && not empty places}">
        <div class="card card-success card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-chair mr-2"></i>
                    Plan de la salle - ${seance.salle.designation}
                </h3>
            </div>
            <div class="card-body">
                <div class="seat-map" style="overflow-x: auto;">
                    <table class="table table-sm table-bordered text-center" style="width: auto; margin: auto;">
                        <thead>
                            <tr>
                                <th style="width: 30px;">Rg</th>
                                <c:forEach begin="1" end="${seance.salle.nbColonnes}" var="col">
                                    <th style="width: 30px;">${col}</th>
                                </c:forEach>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach begin="1" end="${seance.salle.nbRangees}" var="rang">
                                <tr>
                                    <td style="font-weight: bold;">${rang}</td>
                                    <c:forEach begin="1" end="${seance.salle.nbColonnes}" var="col">
                                        <c:set var="place" value="${null}" />
                                        <c:forEach items="${places}" var="p">
                                            <c:if test="${p.rang == rang && p.col == col}">
                                                <c:set var="place" value="${p}" />
                                            </c:if>
                                        </c:forEach>
                                        
                                        <td>
                                            <c:choose>
                                                <c:when test="${place != null}">
                                                    <c:choose>
                                                        <c:when test="${place.statut == 4}">
                                                            <span class="badge badge-success" style="cursor: pointer;" title="Place ${rang}-${col}: Disponible">
                                                                <i class="fas fa-chair"></i>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${place.statut == 5}">
                                                            <span class="badge badge-warning" style="cursor: pointer;" title="Place ${rang}-${col}: En sélection">
                                                                <i class="fas fa-chair"></i>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${place.statut == 6}">
                                                            <span class="badge badge-info" style="cursor: pointer;" title="Place ${rang}-${col}: Réservée">
                                                                <i class="fas fa-chair"></i>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${place.statut == 7}">
                                                            <span class="badge badge-danger" style="cursor: pointer;" title="Place ${rang}-${col}: Vendue">
                                                                <i class="fas fa-chair"></i>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-secondary" style="cursor: pointer;">
                                                                <i class="fas fa-chair"></i>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-light">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <div class="mt-3">
                    <h6>Légende :</h6>
                    <div>
                        <span class="badge badge-success mr-2"><i class="fas fa-chair"></i> Disponible</span>
                        <span class="badge badge-warning mr-2"><i class="fas fa-chair"></i> En sélection</span>
                        <span class="badge badge-info mr-2"><i class="fas fa-chair"></i> Réservée</span>
                        <span class="badge badge-danger mr-2"><i class="fas fa-chair"></i> Vendue</span>
                    </div>
                </div>
            </div>
        </div>
        </c:if>

        <!-- Statistiques par type de place -->
        <c:if test="${not empty statsByTypePlace}">
        <div class="card card-info card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-couch mr-2"></i>
                    Statistiques par type de place
                </h3>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead class="bg-light">
                            <tr>
                                <th>Type de place</th>
                                <th class="text-center">Nombre vendus</th>
                                <th class="text-center">% du total</th>
                                <th class="text-right">CA généré</th>
                                <th class="text-right">Prix moyen</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${statsByTypePlace}" var="stat">
                                <tr>
                                    <td>
                                        <span class="badge badge-info">
                                            <i class="fas fa-couch mr-1"></i>
                                            ${stat.key}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <strong>${stat.value}</strong>
                                    </td>
                                    <td class="text-center">
                                        <c:set var="pourcentage" value="${(stat.value * 100.0) / billets.size()}" />
                                        <div class="progress" style="height: 20px;">
                                            <div class="progress-bar bg-info" 
                                                 role="progressbar" 
                                                 style="width: ${pourcentage}%"
                                                 aria-valuenow="${pourcentage}" 
                                                 aria-valuemin="0" 
                                                 aria-valuemax="100">
                                                <c:out value="${String.format('%.1f', pourcentage)}" />%
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-right">
                                        <strong><c:out value="${String.format('%.2f', caByTypePlace[stat.key])}" /> Ar</strong>
                                    </td>
                                    <td class="text-right">
                                        <c:set var="prixMoyen" value="${caByTypePlace[stat.key] / stat.value}" />
                                        <c:out value="${String.format('%.2f', prixMoyen)}" /> Ar
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot class="bg-light font-weight-bold">
                            <tr>
                                <td>TOTAL</td>
                                <td class="text-center">${billets.size()}</td>
                                <td class="text-center">100%</td>
                                <td class="text-right">${CaSeance} Ar</td>
                                <td class="text-right">
                                    <c:set var="prixMoyenTotal" value="${CaSeance / billets.size()}" />
                                    <c:out value="${String.format('%.2f', prixMoyenTotal)}" /> Ar
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
        </c:if>

        <!-- Statistiques par type de personne -->
        <c:if test="${not empty statsByTypePersonne}">
        <div class="card card-secondary card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-users mr-2"></i>
                    Statistiques par type de personne
                </h3>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead class="bg-light">
                            <tr>
                                <th>Type de personne</th>
                                <th class="text-center">Nombre vendus</th>
                                <th class="text-center">% du total</th>
                                <th class="text-right">CA généré</th>
                                <th class="text-right">Prix moyen</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${statsByTypePersonne}" var="stat">
                                <tr>
                                    <td>
                                        <span class="badge badge-secondary">
                                            <i class="fas fa-user mr-1"></i>
                                            ${stat.key}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <strong>${stat.value}</strong>
                                    </td>
                                    <td class="text-center">
                                        <c:set var="pourcentage" value="${(stat.value * 100.0) / billets.size()}" />
                                        <div class="progress" style="height: 20px;">
                                            <div class="progress-bar bg-secondary" 
                                                 role="progressbar" 
                                                 style="width: ${pourcentage}%"
                                                 aria-valuenow="${pourcentage}" 
                                                 aria-valuemin="0" 
                                                 aria-valuemax="100">
                                                <c:out value="${String.format('%.1f', pourcentage)}" />%
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-right">
                                        <strong><c:out value="${String.format('%.2f', caByTypePersonne[stat.key])}" /> Ar</strong>
                                    </td>
                                    <td class="text-right">
                                        <c:set var="prixMoyen" value="${caByTypePersonne[stat.key] / stat.value}" />
                                        <c:out value="${String.format('%.2f', prixMoyen)}" /> Ar
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot class="bg-light font-weight-bold">
                            <tr>
                                <td>TOTAL</td>
                                <td class="text-center">${billets.size()}</td>
                                <td class="text-center">100%</td>
                                <td class="text-right">${CaSeance} Ar</td>
                                <td class="text-right">
                                    <c:set var="prixMoyenTotal" value="${CaSeance / billets.size()}" />
                                    <c:out value="${String.format('%.2f', prixMoyenTotal)}" /> Ar
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>        </c:if>

        <c:if test="${not empty billets}">
        <div class="card card-outline card-dark">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-ticket-alt mr-2"></i>
                    Liste des billets achetés
                </h3>
            </div>
            <div class="card-body p-0">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Place</th>
                            <th>type personnes</th>
                            <th>Prix</th>
                            <th>Date d’achat</th>
                            <th>Statut</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${billets}" var="b">
                            <tr>
                                <td>${b.id}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.place != null}">
                                            R${b.place.rang} - C${b.place.col}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.typePersone != null}">
                                            ${b.typePersone.nom}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    ${b.prixRemise} - ${b.typePlace.nom}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.dateAchat != null}">
                                            <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(b.dateAchat)" />
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.statutDetails != null}">
                                            <span class="badge badge-info">${b.statutDetails.nom}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        </c:if>

    </div>

    <div class="col-md-4">
        <div class="card card-primary card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-chart-pie mr-2"></i>
                    Statistiques
                </h3>
            </div>
            <div class="card-body">
                <div class="info-box bg-light">
                    <span class="info-box-icon bg-success">
                        <i class="fas fa-ticket-alt"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Places disponibles</span>
                        <span class="info-box-number">${disponible}</span>
                    </div>
                </div>

                <div class="info-box bg-light">
                    <span class="info-box-icon bg-success">
                        <i class="fas fa-ticket-alt"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Ca seance</span>
                        <span class="info-box-number">${CaSeance}</span>
                    </div>
                </div>

                <div class="info-box bg-light">
                    <span class="info-box-icon bg-danger">
                        <i class="fas fa-shopping-cart"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Billets vendus</span>
                        <span class="info-box-number">${billets.size()}</span>
                    </div>
                </div>

                <c:if test="${seance.salle != null}">
                <div class="info-box bg-light">
                    <span class="info-box-icon bg-info">
                        <i class="fas fa-users"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Capacité totale</span>
                        <span class="info-box-number">${seance.salle.capaciteTotal}</span>
                    </div>
                </div>

                <div class="info-box bg-light">
                    <span class="info-box-icon bg-warning">
                        <i class="fas fa-percentage"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Taux de remplissage</span>
                        <span class="info-box-number">
                            <c:set var="taux" value="${(billets.size() * 100.0) / seance.salle.capaciteTotal}" />
                            <c:out value="${String.format('%.1f', taux)}" />%
                        </span>
                    </div>
                </div>
                </c:if>
            </div>
        </div>

        <!-- Résumé par type de place -->
        <c:if test="${not empty statsByTypePlace}">
        <div class="card card-info card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-couch mr-2"></i>
                    Par type de place
                </h3>
            </div>
            <div class="card-body p-0">
                <ul class="list-group list-group-flush">
                    <c:forEach items="${statsByTypePlace}" var="stat">
                        <li class="list-group-item">
                            <div class="d-flex justify-content-between align-items-center">
                                <span>
                                    <i class="fas fa-couch text-info mr-2"></i>
                                    <strong>${stat.key}</strong>
                                </span>
                                <span class="badge badge-info badge-pill">${stat.value}</span>
                            </div>
                            <small class="text-muted">
                                CA: <c:out value="${String.format('%.2f', caByTypePlace[stat.key])}" /> Ar
                            </small>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
        </c:if>

        <!-- Résumé par type de personne -->
        <c:if test="${not empty statsByTypePersonne}">
        <div class="card card-secondary card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-users mr-2"></i>
                    Par type de personne
                </h3>
            </div>
            <div class="card-body p-0">
                <ul class="list-group list-group-flush">
                    <c:forEach items="${statsByTypePersonne}" var="stat">
                        <li class="list-group-item">
                            <div class="d-flex justify-content-between align-items-center">
                                <span>
                                    <i class="fas fa-user text-secondary mr-2"></i>
                                    <strong>${stat.key}</strong>
                                </span>
                                <span class="badge badge-secondary badge-pill">${stat.value}</span>
                            </div>
                            <small class="text-muted">
                                CA: <c:out value="${String.format('%.2f', caByTypePersonne[stat.key])}" /> Ar
                            </small>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
        </c:if>

        <div class="card card-warning card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-bolt mr-2"></i>
                    Actions rapides
                </h3>
            </div>
            <div class="card-body">
                <a href="/billets/achatForm?seanceId=${seance.id}" class="btn btn-primary btn-block mb-2">
                    <i class="fas fa-ticket-alt mr-2"></i>
                    Acheter un billet
                </a>
                <a href="/seances/edit/${seance.id}" class="btn btn-info btn-block mb-2">
                    <i class="fas fa-edit mr-2"></i>
                    Modifier la séance
                </a>
                <button type="button" class="btn btn-danger btn-block" data-toggle="modal" data-target="#deleteModal">
                    <i class="fas fa-trash mr-2"></i>
                    Supprimer la séance
                </button>
                <a href="/seances/reset/${seance.id}" class="btn btn-info btn-block mb-2">
                    <i class="fas fa-edit mr-2"></i>
                    réinisialiser la séance
                </a>
            </div>
        </div>
    </div>
</div>

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
                <p>Êtes-vous sûr de vouloir supprimer cette séance ?</p>
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
                <form action="/seances/delete/${seance.id}" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash mr-1"></i>
                        Supprimer définitivement
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function(){
        setTimeout(function(){ $('.alert').fadeOut('slow'); }, 5000);
    });
</script>

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
                <form action="/sceances/view/${sceance.id}" method="get" class="form-inline">
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
                    <a href="/sceances/view/${sceance.id}" class="btn btn-default">
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
                    <a href="/sceances/edit/${sceance.id}" class="btn btn-light btn-sm"><i class="fas fa-edit mr-1"></i> Modifier</a>
                    <a href="/sceances" class="btn btn-light btn-sm"><i class="fas fa-list mr-1"></i> Liste</a>
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
                                        <c:when test="${sceance.film != null}">${sceance.film.titre}</c:when>
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
                                        <c:when test="${sceance.salle != null}">${sceance.salle.designation}</c:when>
                                        <c:otherwise>${sceance.salleId}</c:otherwise>
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
                                        <c:when test="${sceance.debut != null}">
                                            <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(sceance.debut)" />
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
                                        <c:when test="${sceance.fin != null}">
                                            <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(sceance.fin)" />
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
                <a href="/sceances/edit/${sceance.id}" class="btn btn-info"><i class="fas fa-edit mr-1"></i> Modifier</a>
                <a href="/sceances" class="btn btn-default"><i class="fas fa-arrow-left mr-1"></i> Retour</a>
            </div>
        </div>

        <!-- Plan de la salle -->
        <c:if test="${sceance.salle != null && not empty places}">
        <div class="card card-success card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-chair mr-2"></i>
                    Plan de la salle - ${sceance.salle.designation}
                </h3>
            </div>
            <div class="card-body">
                <div class="seat-map" style="overflow-x: auto;">
                    <table class="table table-sm table-bordered text-center" style="width: auto; margin: auto;">
                        <thead>
                            <tr>
                                <th style="width: 30px;">Rg</th>
                                <c:forEach begin="1" end="${sceance.salle.nbColonnes}" var="col">
                                    <th style="width: 30px;">${col}</th>
                                </c:forEach>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach begin="1" end="${sceance.salle.nbRangees}" var="rang">
                                <tr>
                                    <td style="font-weight: bold;">${rang}</td>
                                    <c:forEach begin="1" end="${sceance.salle.nbColonnes}" var="col">
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
                                                            <!-- Disponible -->
                                                            <span class="badge badge-success" style="cursor: pointer;" title="Place ${rang}-${col}: Disponible">
                                                                <i class="fas fa-chair"></i>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${place.statut == 5}">
                                                            <!-- En sélection -->
                                                            <span class="badge badge-warning" style="cursor: pointer;" title="Place ${rang}-${col}: En sélection">
                                                                <i class="fas fa-chair"></i>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${place.statut == 6}">
                                                            <!-- Réservée -->
                                                            <span class="badge badge-info" style="cursor: pointer;" title="Place ${rang}-${col}: Réservée">
                                                                <i class="fas fa-chair"></i>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${place.statut == 7}">
                                                            <!-- Vendue -->
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
                
                <!-- Légende -->
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
    </div>

    <!-- Statistiques -->
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
                    <span class="info-box-icon bg-danger">
                        <i class="fas fa-shopping-cart"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Billets vendus</span>
                        <span class="info-box-number">${billets.size()}</span>
                    </div>
                </div>

                <c:if test="${sceance.salle != null}">
                <div class="info-box bg-light">
                    <span class="info-box-icon bg-info">
                        <i class="fas fa-users"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Capacité totale</span>
                        <span class="info-box-number">${sceance.salle.capaciteTotal}</span>
                    </div>
                </div>

                <div class="info-box bg-light">
                    <span class="info-box-icon bg-warning">
                        <i class="fas fa-percentage"></i>
                    </span>
                    <div class="info-box-content">
                        <span class="info-box-text">Taux de remplissage</span>
                        <span class="info-box-number">
                            <c:set var="taux" value="${(billets.size() * 100.0) / sceance.salle.capaciteTotal}" />
                            <c:out value="${String.format('%.1f', taux)}" />%
                        </span>
                    </div>
                </div>
                </c:if>
            </div>
        </div>

        <!-- Actions rapides -->
        <div class="card card-warning card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-bolt mr-2"></i>
                    Actions rapides
                </h3>
            </div>
            <div class="card-body">
                <a href="/billets/achatForm?seanceId=${sceance.id}" class="btn btn-primary btn-block mb-2">
                    <i class="fas fa-ticket-alt mr-2"></i>
                    Acheter un billet
                </a>
                <a href="/sceances/edit/${sceance.id}" class="btn btn-info btn-block mb-2">
                    <i class="fas fa-edit mr-2"></i>
                    Modifier la séance
                </a>
                <button type="button" class="btn btn-danger btn-block" data-toggle="modal" data-target="#deleteModal">
                    <i class="fas fa-trash mr-2"></i>
                    Supprimer la séance
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Modal de suppression -->
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
                <form action="/sceances/delete/${sceance.id}" method="post" style="display: inline;">
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

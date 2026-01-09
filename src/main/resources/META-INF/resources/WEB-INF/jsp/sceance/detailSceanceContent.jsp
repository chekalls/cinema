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
                                <span class="info-box-number">${sceance.salleId}</span>
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
    </div>
</div>

<script>
    $(document).ready(function(){
        setTimeout(function(){ $('.alert').fadeOut('slow'); }, 5000);
    });
</script>

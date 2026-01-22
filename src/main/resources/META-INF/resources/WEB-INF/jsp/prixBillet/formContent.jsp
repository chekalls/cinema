<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="content-wrapper">
    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1>${isEdit ? 'Modifier' : 'Nouveau'} prix de billet</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="/">Accueil</a></li>
                        <li class="breadcrumb-item"><a href="/prix-billets">Prix de billets</a></li>
                        <li class="breadcrumb-item active">${isEdit ? 'Modifier' : 'Nouveau'}</li>
                    </ol>
                </div>
            </div>
        </div>
    </section>

    <section class="content">
        <div class="container-fluid">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                    <i class="icon fas fa-ban"></i> ${error}
                </div>
            </c:if>

            <div class="card card-primary">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-ticket-alt"></i> Informations du prix
                    </h3>
                </div>
                <form action="/prix-billets/save" method="post">
                    <c:if test="${isEdit}">
                        <input type="hidden" name="id" value="${prixBillet.id}"/>
                    </c:if>
                    
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="typePlaceId">Type de place <span class="text-danger">*</span></label>
                                    <select name="typePlaceId" id="typePlaceId" class="form-control" required>
                                        <option value="">-- Sélectionner --</option>
                                        <c:forEach items="${typePlaces}" var="tp">
                                            <option value="${tp.id}" ${prixBillet.typePlaceId == tp.id ? 'selected' : ''}>
                                                ${tp.nom} - ${tp.code}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="typePersonneId">Type de personne</label>
                                    <select name="typePersonneId" id="typePersonneId" class="form-control">
                                        <option value="">-- Tous (par défaut) --</option>
                                        <c:forEach items="${typePersonnes}" var="tp">
                                            <option value="${tp.id}" ${prixBillet.typePersonneId == tp.id ? 'selected' : ''}>
                                                ${tp.nom}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <small class="form-text text-muted">
                                        Laissez vide pour appliquer à tous les types de personnes
                                    </small>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="prixBase">Prix de base (Ar) <span class="text-danger">*</span></label>
                                    <input type="number" 
                                           name="prixBase" 
                                           id="prixBase" 
                                           class="form-control" 
                                           value="${prixBillet.prixBase}" 
                                           min="0" 
                                           step="100" 
                                           required
                                           oninput="calculatePrixReel()">
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="reduction">Réduction (%)</label>
                                    <input type="number" 
                                           name="reduction" 
                                           id="reduction" 
                                           class="form-control" 
                                           value="${prixBillet.reduction}" 
                                           min="0" 
                                           max="100" 
                                           step="1"
                                           oninput="calculatePrixReel()">
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Prix réel (Ar)</label>
                                    <input type="text" 
                                           id="prixReelDisplay" 
                                           class="form-control" 
                                           readonly
                                           style="background-color: #e9ecef; font-weight: bold;">
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="custom-control custom-switch custom-switch-on-success">
                                        <input type="checkbox" 
                                               class="custom-control-input" 
                                               id="actif" 
                                               name="actif" 
                                               value="true"
                                               ${prixBillet.actif || !isEdit ? 'checked' : ''}>
                                        <label class="custom-control-label" for="actif">Prix actif</label>
                                    </div>
                                    <small class="form-text text-muted">
                                        Seuls les prix actifs sont utilisés pour le calcul des billets
                                    </small>
                                </div>
                            </div>
                        </div>

                        <c:if test="${isEdit}">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="alert alert-info">
                                        <i class="icon fas fa-info-circle"></i>
                                        <strong>Date de création:</strong> 
                                        <fmt:formatDate value="${prixBillet.datePrix}" pattern="dd/MM/yyyy à HH:mm"/>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <div class="card-footer">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Enregistrer
                        </button>
                        <a href="/prix-billets" class="btn btn-default">
                            <i class="fas fa-times"></i> Annuler
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </section>
</div>

<script>
function calculatePrixReel() {
    const prixBase = parseFloat(document.getElementById('prixBase').value) || 0;
    const reduction = parseFloat(document.getElementById('reduction').value) || 0;
    
    const prixReel = prixBase - (prixBase * reduction / 100);
    
    document.getElementById('prixReelDisplay').value = prixReel.toLocaleString('fr-FR') + ' Ar';
}

// Calculer au chargement de la page
window.addEventListener('DOMContentLoaded', function() {
    calculatePrixReel();
});
</script>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="row">
    <div class="col-md-8 offset-md-2">
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible mb-3">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h5><i class="icon fas fa-check"></i> Succès!</h5>
                <span>${success}</span>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible mb-3">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h5><i class="icon fas fa-ban"></i> Erreur!</h5>
                <span>${error}</span>
            </div>
        </c:if>

        <div class="card card-primary card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-tags mr-2"></i>
                    <c:choose>
                        <c:when test="${not empty tarif}">Modifier un tarif</c:when>
                        <c:otherwise>Ajouter un nouveau tarif</c:otherwise>
                    </c:choose>
                </h3>
                <div class="card-tools">
                    <a href="/billets/tarifs" class="btn btn-default btn-sm">
                        <i class="fas fa-arrow-left mr-1"></i>
                        Retour à la liste
                    </a>
                </div>
            </div>

            <form method="post" action="/billets/tarifs/save">
                <c:if test="${not empty tarif}">
                    <input type="hidden" name="id" value="${tarif.id}">
                </c:if>

                <div class="card-body">
                    <!-- Type de place -->
                    <div class="form-group">
                        <label for="typePlaceId">Type de place <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-couch"></i></span>
                            </div>
                            <select name="typePlaceId" id="typePlaceId" class="form-control" required>
                                <option value="">-- Sélectionnez un type de place --</option>
                                <c:forEach items="${typePlaces}" var="typePlace">
                                    <option value="${typePlace.id}" 
                                            ${not empty tarif && tarif.typePlaceId == typePlace.id ? 'selected' : ''}>
                                        ${typePlace.nom}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <small class="form-text text-muted">Choisissez le type de place concerné par ce tarif.</small>
                    </div>

                    <!-- Type de personne (optionnel) -->
                    <div class="form-group">
                        <label for="typePersonneId">Type de personne</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                            </div>
                            <select name="typePersonneId" id="typePersonneId" class="form-control">
                                <option value="">-- Tous les types de personnes --</option>
                                <c:forEach items="${typePersonnes}" var="typePersonne">
                                    <option value="${typePersonne.id}" 
                                            ${not empty tarif && tarif.typePersonneId == typePersonne.id ? 'selected' : ''}>
                                        ${typePersonne.nom}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <small class="form-text text-muted">Optionnel : spécifiez un type de personne pour un tarif spécifique.</small>
                    </div>

                    <!-- Prix de base -->
                    <div class="form-group">
                        <label for="prixPlace">Prix de base <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-money-bill-wave"></i></span>
                            </div>
                            <input type="number" step="0.01" min="0" name="prixPlace" id="prixPlace" 
                                   class="form-control" placeholder="Ex: 10000.00"
                                   value="${not empty tarif ? tarif.prixPlace : ''}" required>
                            <div class="input-group-append">
                                <span class="input-group-text">Ar</span>
                            </div>
                        </div>
                        <small class="form-text text-muted">Prix de base de la place (en Ariary).</small>
                    </div>

                    <!-- Tarif parent (optionnel) -->
                    <div class="form-group">
                        <label for="parentId">Tarif parent</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-link"></i></span>
                            </div>
                            <select name="parentId" id="parentId" class="form-control">
                                <option value="">-- Aucun (tarif principal) --</option>
                                <c:forEach items="${tarifsParents}" var="tarifParent">
                                    <c:if test="${empty tarif || tarif.id != tarifParent.id}">
                                        <option value="${tarifParent.id}" 
                                                ${not empty tarif && tarif.parentId == tarifParent.id ? 'selected' : ''}>
                                            ${tarifParent.typePersone.nom}-${tarifParent.typePlace.nom} ( ${tarifParent.prixPlace} Ar)
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                        <small class="form-text text-muted">Optionnel : lier ce tarif à un tarif parent.</small>
                    </div>

                    <!-- Réduction (optionnel) -->
                    <div class="form-group">
                        <label for="reduction">Réduction (%)</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-percent"></i></span>
                            </div>
                            <input type="number" step="0.01" min="0" max="100" name="reduction" id="reduction" 
                                   class="form-control" placeholder="Ex: 20"
                                   value="${not empty tarif && not empty tarif.reduction ? tarif.reduction : ''}">
                            <div class="input-group-append">
                                <span class="input-group-text">%</span>
                            </div>
                        </div>
                        <small class="form-text text-muted">Optionnel : pourcentage de réduction (0 à 100).</small>
                    </div>

                    <!-- Aperçu du prix final -->
                    <div class="alert alert-info" id="prixFinalPreview" style="display: none;">
                        <h5><i class="fas fa-calculator mr-2"></i>Aperçu du prix final</h5>
                        <p class="mb-0">
                            <strong>Prix de base :</strong> <span id="previewPrixBase">0.00</span> Ar<br>
                            <strong>Réduction :</strong> <span id="previewReduction">0</span>%<br>
                            <strong>Prix final :</strong> <span id="previewPrixFinal" class="text-success font-weight-bold">0.00</span> Ar
                        </p>
                    </div>
                </div>

                <div class="card-footer">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save mr-1"></i>
                        <c:choose>
                            <c:when test="${not empty tarif}">Modifier le tarif</c:when>
                            <c:otherwise>Créer le tarif</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="/billets/tarifs" class="btn btn-default">
                        <i class="fas fa-times mr-1"></i>
                        Annuler
                    </a>
                </div>
            </form>
        </div>

        <!-- Aide -->
        <div class="card card-secondary collapsed-card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-question-circle mr-2"></i>
                    Aide
                </h3>
                <div class="card-tools">
                    <button type="button" class="btn btn-tool" data-card-widget="collapse">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
            </div>
            <div class="card-body">
                <h6><strong>Structure des tarifs :</strong></h6>
                <ul>
                    <li><strong>Tarif principal :</strong> Définit un prix de base pour un type de place.</li>
                    <li><strong>Tarif dérivé :</strong> Hérite d'un tarif parent et peut appliquer une réduction.</li>
                    <li><strong>Type de personne :</strong> Permet de créer des tarifs spécifiques (enfant, étudiant, senior, etc.).</li>
                </ul>
                
                <h6><strong>Exemples d'utilisation :</strong></h6>
                <ul>
                    <li>Tarif VIP standard : 15000 Ar</li>
                    <li>Tarif VIP étudiant : 15000 Ar avec 20% de réduction = 12000 Ar</li>
                    <li>Tarif Standard : 8000 Ar</li>
                    <li>Tarif Standard enfant : 8000 Ar avec 50% de réduction = 4000 Ar</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
    // Calcul automatique du prix final
    function updatePrixFinalPreview() {
        const prixBase = parseFloat(document.getElementById('prixPlace').value) || 0;
        const reduction = parseFloat(document.getElementById('reduction').value) || 0;
        
        if (prixBase > 0) {
            const prixFinal = prixBase * (1 - reduction / 100);
            
            document.getElementById('previewPrixBase').textContent = prixBase.toFixed(2);
            document.getElementById('previewReduction').textContent = reduction.toFixed(2);
            document.getElementById('previewPrixFinal').textContent = prixFinal.toFixed(2);
            document.getElementById('prixFinalPreview').style.display = 'block';
        } else {
            document.getElementById('prixFinalPreview').style.display = 'none';
        }
    }
    
    document.getElementById('prixPlace').addEventListener('input', updatePrixFinalPreview);
    document.getElementById('reduction').addEventListener('input', updatePrixFinalPreview);
    
    // Initialiser l'aperçu si on modifie un tarif
    window.addEventListener('DOMContentLoaded', updatePrixFinalPreview);
</script>

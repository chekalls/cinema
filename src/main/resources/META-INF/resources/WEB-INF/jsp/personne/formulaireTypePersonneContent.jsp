<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="row">
    <div class="col-md-6 offset-md-3">
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
                    <i class="fas fa-user mr-2"></i>
                    <c:choose>
                        <c:when test="${not empty typePersonne}">Modifier un type de personne</c:when>
                        <c:otherwise>Ajouter un type de personne</c:otherwise>
                    </c:choose>
                </h3>
                <div class="card-tools">
                    <a href="/personnes/types" class="btn btn-default btn-sm">
                        <i class="fas fa-arrow-left mr-1"></i>
                        Retour à la liste
                    </a>
                </div>
            </div>

            <form method="post" action="/personnes/types/save" id="typePersonneForm">
                <c:if test="${not empty typePersonne}">
                    <input type="hidden" name="id" value="${typePersonne.id}">
                </c:if>

                <div class="card-body">
                    <!-- Nom -->
                    <div class="form-group">
                        <label for="nom">Nom du type <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-tag"></i></span>
                            </div>
                            <input type="text" name="nom" id="nom" 
                                   class="form-control" 
                                   placeholder="Ex: Adulte, Enfant, Étudiant, Senior..."
                                   value="${not empty typePersonne ? typePersonne.nom : ''}" 
                                   required
                                   maxlength="100">
                        </div>
                        <small class="form-text text-muted">
                            Le nom du type de personne (doit être unique et descriptif).
                        </small>
                    </div>

                    <!-- Exemples -->
                    <div class="alert alert-info">
                        <h6><i class="fas fa-lightbulb mr-2"></i>Suggestions de types</h6>
                        <div class="row">
                            <div class="col-6">
                                <ul class="mb-0" style="font-size: 0.9rem;">
                                    <li>Adulte</li>
                                    <li>Enfant (moins de 12 ans)</li>
                                    <li>Étudiant</li>
                                </ul>
                            </div>
                            <div class="col-6">
                                <ul class="mb-0" style="font-size: 0.9rem;">
                                    <li>Senior (plus de 65 ans)</li>
                                    <li>PMR (Mobilité réduite)</li>
                                    <li>Groupe scolaire</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-footer">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save mr-1"></i>
                        <c:choose>
                            <c:when test="${not empty typePersonne}">Modifier</c:when>
                            <c:otherwise>Créer</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="/personnes/types" class="btn btn-default">
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
                <h6><strong>Utilisation des types de personnes :</strong></h6>
                <p>Les types de personnes sont utilisés pour :</p>
                <ul>
                    <li>Définir des tarifs spécifiques dans la section "Tarifs"</li>
                    <li>Appliquer automatiquement des réductions lors de l'achat de billets</li>
                    <li>Générer des statistiques par catégorie de clients</li>
                </ul>
                
                <h6 class="mt-3"><strong>Bonnes pratiques :</strong></h6>
                <ul class="mb-0">
                    <li>Utilisez des noms clairs et explicites</li>
                    <li>Créez les types de base d'abord (Adulte, Enfant)</li>
                    <li>Ajoutez des précisions si nécessaire (âge, conditions)</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
    // Validation du formulaire
    document.getElementById('typePersonneForm').addEventListener('submit', function(e) {
        const nom = document.getElementById('nom').value.trim();
        
        if (nom.length < 2) {
            e.preventDefault();
            alert('Le nom doit contenir au moins 2 caractères.');
            return false;
        }
    });
</script>

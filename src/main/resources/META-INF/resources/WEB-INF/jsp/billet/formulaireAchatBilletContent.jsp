<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ page import = "mg.gestion.cinema.models.Tarif" %>
<%@ page import = "mg.gestion.cinema.models.Film" %>
<%@ page import = "mg.gestion.cinema.models.Sceance" %>
<%@ page import = "java.util.List" %>

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
                    <i class="fas fa-ticket-alt mr-2"></i>
                    Achat de billet
                </h3>
            </div>

            <form method="post" action="/billets/acheter">
                <div class="card-body">
                    <!-- Film -->
                    <div class="form-group">
                        <label for="film">Film <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-film"></i></span>
                            </div>
                            <select name="film" id="film" class="form-control" required>
                                <option value="">-- Sélectionnez un film --</option>
                                <c:forEach items="${films}" var="film">
                                    <option value="${film.id}">${film.titre}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <small class="form-text text-muted">Choisissez le film que vous souhaitez voir.</small>
                    </div>

                    <!-- Séance -->
                    <div class="form-group">
                        <label for="sceance">Séance <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-clock"></i></span>
                            </div>
                            <select name="seanceId" id="sceance" class="form-control" disabled required>
                                <option value="">-- Sélectionnez d'abord un film --</option>
                            </select>
                        </div>
                        <small class="form-text text-muted">Sélectionnez l'horaire souhaité.</small>
                    </div>

                    <!-- Tarif -->
                    <div class="form-group">
                        <label for="tarif">Tarif <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-euro-sign"></i></span>
                            </div>
                            <select name="tarifId" id="tarif" class="form-control" required>
                                <option value="">-- Sélectionnez un tarif --</option>
                                <c:forEach items="${tarifs}" var="tarif">
                                    <option value="${tarif.id}" data-prix="${tarif.prixBase}">${tarif.nom}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <small class="form-text text-muted">Choisissez le type de tarif.</small>
                    </div>

                    <!-- Affichage du prix -->
                    <div id="affichagePrix" style="display: none;" class="alert alert-info">
                        <strong><i class="fas fa-info-circle mr-2"></i>Prix :</strong> <span id="prixValeur">0.00</span> €
                    </div>
                </div>

                <div class="card-footer">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-shopping-cart mr-2"></i>
                        Acheter
                    </button>
                    <a href="/billets" class="btn btn-secondary ml-2">
                        <i class="fas fa-arrow-left mr-2"></i>
                        Annuler
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
document.getElementById('film').addEventListener('change', function() {
    const filmId = this.value;
    const sceanceSelect = document.getElementById('sceance');
    
    // Vérifier que filmId est défini et non vide
    if (!filmId || filmId.trim() === '') {
        sceanceSelect.innerHTML = '<option value="">-- Sélectionnez d\'abord un film --</option>';
        sceanceSelect.disabled = true;
        return;
    }

    // Charger les séances pour ce film
    fetch(`/billets/api/sceances-par-film/`+filmId)
        .then(response => {
            if (!response.ok) {
                throw new Error(`Erreur ${response.status}`);
            }
            return response.json();
        })
        .then(sceances => {
            sceanceSelect.innerHTML = '<option value="">-- Sélectionnez une séance --</option>';
            
            if (sceances.length === 0) {
                sceanceSelect.innerHTML = '<option value="">Aucune séance disponible</option>';
                sceanceSelect.disabled = true;
                return;
            }
            
            sceances.forEach(sceance => {
                const option = document.createElement('option');
                option.value = sceance.id;
                option.textContent = sceance.debut + '/' + sceance.fin + ' - Salle ' + sceance.id;
                sceanceSelect.appendChild(option);
            });
            
            sceanceSelect.disabled = false;
        })
        .catch(error => {
            console.error('Erreur:', error);
            sceanceSelect.innerHTML = '<option value="">Erreur lors du chargement</option>';
            sceanceSelect.disabled = true;
        });
});

// Affichage du prix du tarif
document.getElementById('tarif').addEventListener('change', function() {
    const option = this.options[this.selectedIndex];
    const prix = option.getAttribute('data-prix');
    const affichagePrix = document.getElementById('affichagePrix');
    const prixValeur = document.getElementById('prixValeur');
    
    if (!prix || this.value === '') {
        affichagePrix.style.display = 'none';
        return;
    }
    
    prixValeur.textContent = parseFloat(prix).toFixed(2);
    affichagePrix.style.display = 'block';
});
</script>

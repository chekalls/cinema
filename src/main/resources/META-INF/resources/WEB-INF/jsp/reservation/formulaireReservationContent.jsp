<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ page import = "mg.gestion.cinema.models.Tarif" %>
<%@ page import = "mg.gestion.cinema.models.Film" %>
<%@ page import = "mg.gestion.cinema.models.Seance" %>
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
        <div class="card card-warning card-outline">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-calendar-check mr-2"></i>
                    Réservation de billet
                </h3>
            </div>

            <form method="post" action="/reservations/reserver">
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
                        <label for="seance">Séance <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-clock"></i></span>
                            </div>
                            <select name="seanceId" id="seance" class="form-control" disabled required>
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

                    <!-- Nombre de billets -->
                    <div class="form-group">
                        <label for="nombreBillets">Nombre de billets <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-ticket-alt"></i></span>
                            </div>
                            <input type="number" 
                                   name="nombreBillets" 
                                   id="nombreBillets" 
                                   class="form-control" 
                                   value="1" 
                                   min="1" 
                                   max="10" 
                                   required>
                        </div>
                        <small class="form-text text-muted">Nombre de billets à réserver (1-10).</small>
                    </div>

                    <!-- Date de réservation -->
                    <div class="form-group">
                        <label for="dateReservation">Date de réservation <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-calendar-alt"></i></span>
                            </div>
                            <input type="datetime-local" 
                                   name="dateReservation" 
                                   id="dateReservation" 
                                   class="form-control" 
                                   required>
                        </div>
                        <small class="form-text text-muted">Indiquez la date et l'heure à laquelle la réservation a été effectuée.</small>
                    </div>

                    <!-- Affichage du prix -->
                    <div id="affichagePrix" style="display: none;" class="alert alert-info">
                        <strong><i class="fas fa-info-circle mr-2"></i>Prix :</strong> <span id="prixValeur">0.00</span> € 
                        <span id="prixDetail" style="font-size: 0.9rem;"></span>
                    </div>

                    <!-- Information -->
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle mr-2"></i>
                        <strong>Information :</strong> La réservation sera enregistrée à la date indiquée.
                    </div>
                </div>

                <div class="card-footer">
                    <button type="submit" class="btn btn-warning">
                        <i class="fas fa-calendar-check mr-2"></i>
                        Réserver
                    </button>
                    <a href="/reservations" class="btn btn-secondary ml-2">
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
    const seanceSelect = document.getElementById('seance');
    
    if (!filmId || filmId.trim() === '') {
        seanceSelect.innerHTML = '<option value="">-- Sélectionnez d\'abord un film --</option>';
        seanceSelect.disabled = true;
        return;
    }

    fetch('/billets/api/seances-par-film/'+filmId)
        .then(response => {
            if (!response.ok) {
                throw new Error('Erreur '+response.status);
            }
            return response.json();
        })
        .then(seances => {
            seanceSelect.innerHTML = '<option value="">-- Sélectionnez une séance --</option>';
            
            if (seances.length === 0) {
                seanceSelect.innerHTML = '<option value="">Aucune séance disponible</option>';
                seanceSelect.disabled = true;
                return;
            }
            
            seances.forEach(seance => {
                const option = document.createElement('option');
                option.value = seance.id;
                option.textContent = seance.debut + '/' + seance.fin + ' - Salle ' + seance.salleId;
                seanceSelect.appendChild(option);
            });
            
            seanceSelect.disabled = false;
        })
        .catch(error => {
            console.error('Erreur:', error);
            seanceSelect.innerHTML = '<option value="">Erreur lors du chargement</option>';
            seanceSelect.disabled = true;
        });
});

document.getElementById('tarif').addEventListener('change', function() {
    calculerPrixTotal();
});

document.getElementById('nombreBillets').addEventListener('change', function() {
    calculerPrixTotal();
});

function calculerPrixTotal() {
    const tarifSelect = document.getElementById('tarif');
    const nombreSelect = document.getElementById('nombreBillets');
    const affichagePrix = document.getElementById('affichagePrix');
    const prixValeur = document.getElementById('prixValeur');
    const prixDetail = document.getElementById('prixDetail');
    
    const option = tarifSelect.options[tarifSelect.selectedIndex];
    const prix = option.getAttribute('data-prix');
    const nombre = parseInt(nombreSelect.value) || 1;
    
    if (!prix || tarifSelect.value === '' || nombre < 1) {
        affichagePrix.style.display = 'none';
        return;
    }
    
    const prixUnitaire = parseFloat(prix);
    const prixTotal = prixUnitaire * nombre;
    
    prixValeur.textContent = prixTotal.toFixed(2);
    prixDetail.textContent = '(' + prixUnitaire.toFixed(2) + ' € × ' + nombre + ')';
    affichagePrix.style.display = 'block';
}

// Pré-remplir avec la date actuelle
const dateInput = document.getElementById('dateReservation');
const now = new Date();
const year = now.getFullYear();
const month = String(now.getMonth() + 1).padStart(2, '0');
const day = String(now.getDate()).padStart(2, '0');
const hours = String(now.getHours()).padStart(2, '0');
const minutes = String(now.getMinutes()).padStart(2, '0');
const currentDateTime = year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
dateInput.value = currentDateTime;
</script>
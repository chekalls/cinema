<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!-- Info message -->
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

        <!-- Main form -->
        <div class="row">
            <div class="col-md-12">
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-door-open mr-2"></i>
                            <c:choose>
                                <c:when test="${salle != null && salle.id != null}">Modifier une salle</c:when>
                                <c:otherwise>Ajouter une salle</c:otherwise>
                            </c:choose>
                        </h3>
                    </div>

                    <form action="/salles/save" method="post">
                        <input type="hidden" name="id" value="${salle.id}" />

                        <div class="card-body">
                            <div class="form-group">
                                <label for="cinemaId">Cinéma <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-film"></i></span>
                                    </div>
                                    <select class="form-control" id="cinemaId" name="cinemaId" required>
                                        <option value="" disabled <c:if
                                            test="${salle == null || salle.cinemaId == null}">selected</c:if>>--
                                            Sélectionnez un cinéma --</option>
                                        <c:forEach var="cinema" items="${cinemas}">
                                            <option value="${cinema.id}" <c:if
                                                test="${salle != null && salle.cinemaId != null && cinema.id == salle.cinemaId}">
                                                selected</c:if>>${cinema.nom}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <small class="form-text text-muted">Choisissez le cinéma auquel appartient la
                                    salle.</small>
                            </div>

                            <!-- Numero -->
                            <div class="form-group">
                                <label for="numero">Numéro de salle <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-hashtag"></i></span>
                                    </div>
                                    <input type="text" class="form-control" id="numero" name="numero"
                                        value="${salle.numero}" placeholder="Ex: S01" required>
                                </div>
                                <small class="form-text text-muted">Identifiant interne de la salle (ex: S01,
                                    VIP1).</small>
                            </div>

                            <!-- Designation -->
                            <div class="form-group">
                                <label for="designation">Désignation <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-tag"></i></span>
                                    </div>
                                    <input type="text" class="form-control" id="designation" name="designation"
                                        value="${salle.designation}" placeholder="Ex: Salle IMAX" required>
                                </div>
                                <small class="form-text text-muted">Nom lisible de la salle pour l'affichage
                                    public.</small>
                            </div>

                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label for="capaciteTotal">Capacité totale <span
                                            class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-users"></i></span>
                                        </div>
                                        <input type="number" class="form-control" id="capaciteTotal"
                                            name="capaciteTotal" value="${salle.capaciteTotal}" min="1"
                                            placeholder="Ex: 150" >
                                    </div>
                                </div>

                                <div class="form-group col-md-4">
                                    <label for="nbRangees">Nombre de rangées</label>
                                    <input type="number" class="form-control" id="nbRangees" name="nbRangees"
                                        value="${salle.nbRangees}" min="1" placeholder="Ex: 12">
                                </div>

                                <div class="form-group col-md-4">
                                    <label for="nbColonnes">Places par rangée</label>
                                    <input type="number" class="form-control" id="nbColonnes" name="nbColonnes"
                                        value="${salle.nbColonnes}" min="1" placeholder="Ex: 10">
                                </div>
                            </div>


                            <div class="callout callout-info">
                                <h5><i class="fas fa-info-circle"></i> Information</h5>
                                <p>Les champs marqués d'un <span class="text-danger">*</span> sont obligatoires.</p>
                            </div>
                        </div>

                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save mr-2"></i>
                                <c:choose>
                                    <c:when test="${salle != null && salle.id != null}">Modifier</c:when>
                                    <c:otherwise>Enregistrer</c:otherwise>
                                </c:choose>
                            </button>
                            <a href="/salles" class="btn btn-default">
                                <i class="fas fa-times mr-2"></i>
                                Annuler
                            </a>
                            <button type="reset" class="btn btn-warning float-right">
                                <i class="fas fa-redo mr-2"></i>
                                Réinitialiser
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Instructions card -->
        <div class="row">
            <div class="col-md-12">
                <div class="card card-secondary collapsed-card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-question-circle mr-2"></i>
                            Aide & Instructions
                        </h3>
                        <div class="card-tools">
                            <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <h5>Comment remplir ce formulaire ?</h5>
                        <ul>
                            <li><strong>Cinéma</strong> : sélectionnez le cinéma parent.</li>
                            <li><strong>Numéro</strong> : identifiant court (S01, VIP1...).</li>
                            <li><strong>Désignation</strong> : nom lisible pour les clients.</li>
                            <li><strong>Capacité</strong> : total des sièges disponibles.</li>
                        </ul>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle mr-2"></i>
                            <strong>Attention :</strong> vérifiez les informations avant de soumettre.
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            $(document).ready(function () {
                $('form').on('submit', function (e) {
                    var cinemaId = $('#cinemaId').val();
                    var numero = $('#numero').val().trim();
                    var designation = $('#designation').val().trim();
                    var capacite = parseInt($('#capaciteTotal').val(), 10);

                    if (!cinemaId || numero === '' || designation === '' || isNaN(capacite) || capacite <= 0) {
                        e.preventDefault();
                        alert('Veuillez renseigner tous les champs obligatoires avec des valeurs valides.');
                        return false;
                    }
                });

                setTimeout(function () {
                    $('.alert').fadeOut('slow');
                }, 5000);
            });

        </script>
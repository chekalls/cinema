<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

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

<!-- Error message -->
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
                    <i class="fas fa-film mr-2"></i>
                    <c:choose>
                        <c:when test="${cinema != null && cinema.id != null}">Modifier un cinéma</c:when>
                        <c:otherwise>Ajouter un cinéma</c:otherwise>
                    </c:choose>
                </h3>
            </div>

            <form:form action="/cinemas/save" method="post" modelAttribute="cinema">
                <form:hidden path="id" />

                <div class="card-body">
                    <!-- Nom du cinéma -->
                    <div class="form-group">
                        <label for="nom">Nom du cinéma <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-film"></i></span>
                            </div>
                            <form:input path="nom" cssClass="form-control" id="nom" placeholder="Ex: Cinéma Paradise" required="required" />
                        </div>
                        <small class="form-text text-muted">Le nom commercial du cinéma</small>
                    </div>

                    <!-- Adresse -->
                    <div class="form-group">
                        <label for="adresse">Adresse <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
                            </div>
                            <form:textarea path="adresse" cssClass="form-control" id="adresse" rows="3"
                                           placeholder="Ex: Lot II M 34 Bis Ambohimangakely, Antananarivo" required="required" />
                        </div>
                        <small class="form-text text-muted">L'adresse complète du cinéma</small>
                    </div>

                    <!-- Email -->
                    <div class="form-group">
                        <label for="email">Email <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                            </div>
                            <form:input path="email" type="email" cssClass="form-control" id="email" placeholder="contact@cinema.mg" required="required" />
                        </div>
                        <small class="form-text text-muted">Adresse email de contact du cinéma</small>
                    </div>

                    <!-- Dates (affichées seulement en mode édition) -->
                    <c:if test="${cinema != null && cinema.id != null}">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Date de création</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-calendar-plus"></i></span>
                                        </div>
                                        <input type="text" class="form-control" readonly
                                               value="<spring:eval expression=\"T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(cinema.createdAt)\" />" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Dernière modification</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-calendar-check"></i></span>
                                        </div>
                                        <c:choose>
                                            <c:when test="${cinema.updatedAt != null}">
                                                <input type="text" class="form-control" readonly
                                                       value="<spring:eval expression=\"T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm').format(cinema.updatedAt)\" />" />
                                            </c:when>
                                            <c:otherwise>
                                                <input type="text" class="form-control" readonly value="Non modifié" />
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <div class="callout callout-info">
                        <h5><i class="fas fa-info-circle"></i> Information</h5>
                        <p>
                            Les champs marqués d'un <span class="text-danger">*</span> sont obligatoires.
                            Assurez-vous de remplir tous les champs requis avant de soumettre le formulaire.
                        </p>
                    </div>
                </div>

                <div class="card-footer">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save mr-2"></i>
                        <c:choose>
                            <c:when test="${cinema != null && cinema.id != null}">Modifier</c:when>
                            <c:otherwise>Enregistrer</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="/cinemas" class="btn btn-default">
                        <i class="fas fa-times mr-2"></i>
                        Annuler
                    </a>
                    <button type="reset" class="btn btn-warning float-right">
                        <i class="fas fa-redo mr-2"></i>
                        Réinitialiser
                    </button>
                </div>
            </form:form>
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
                    <li><strong>Nom du cinéma</strong> : Entrez le nom commercial de votre établissement.</li>
                    <li><strong>Adresse</strong> : Indiquez l'adresse complète incluant le quartier, la ville et le code postal si applicable.</li>
                    <li><strong>Email</strong> : Fournissez une adresse email valide pour les communications officielles.</li>
                </ul>
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle mr-2"></i>
                    <strong>Attention :</strong> Vérifiez bien les informations avant de soumettre. Les données incorrectes peuvent affecter la gestion du cinéma.
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $('form').on('submit', function (e) {
            var nom = $('#nom').val().trim();
            var adresse = $('#adresse').val().trim();
            var email = $('#email').val().trim();

            if (nom === '' || adresse === '' || email === '') {
                e.preventDefault();
                alert('Veuillez remplir tous les champs obligatoires.');
                return false;
            }

            var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                e.preventDefault();
                alert('Veuillez entrer une adresse email valide.');
                $('#email').focus();
                return false;
            }
        });

        setTimeout(function () {
            $('.alert').fadeOut('slow');
        }, 5000);
    });
</script>

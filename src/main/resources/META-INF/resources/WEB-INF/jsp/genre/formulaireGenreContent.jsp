<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

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
                    <i class="fas fa-layer-group mr-2"></i>
                    <c:choose>
                        <c:when test="${genre != null && genre.id != null}">Modifier un genre</c:when>
                        <c:otherwise>Ajouter un genre</c:otherwise>
                    </c:choose>
                </h3>
            </div>

            <form:form action="/films/genres/save" method="post" modelAttribute="genre">
                <form:hidden path="id" />

                <div class="card-body">
                    <!-- Nom du genre -->
                    <div class="form-group">
                        <label for="nom">Nom du genre <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-layer-group"></i></span>
                            </div>
                            <form:input path="nom" cssClass="form-control" id="nom"
                                        placeholder="Ex: Action, Comédie, Thriller" required="required" />
                        </div>
                        <small class="form-text text-muted">Le nom du genre de film.</small>
                    </div>

                    <!-- Code -->
                    <div class="form-group">
                        <label for="code">Code <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-barcode"></i></span>
                            </div>
                            <form:input path="code" cssClass="form-control" id="code"
                                        placeholder="Ex: ACT, COM, THR" required="required" />
                        </div>
                        <small class="form-text text-muted">Code court unique pour identifier le genre.</small>
                    </div>

                    <!-- Description -->
                    <div class="form-group">
                        <label for="desce">Description</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-align-left"></i></span>
                            </div>
                            <form:textarea path="desce" cssClass="form-control" id="desce" rows="4"
                                           placeholder="Description détaillée du genre (optionnel)" />
                        </div>
                        <small class="form-text text-muted">Description optionnelle pour caractériser le genre.</small>
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
                            <c:when test="${genre != null && genre.id != null}">Modifier</c:when>
                            <c:otherwise>Enregistrer</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="/films/genres" class="btn btn-default">
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
                    <li><strong>Nom du genre</strong> : Entrez le nom du genre (Action, Drame, etc.).</li>
                    <li><strong>Code</strong> : Code court et unique (ACT, DRA, COM...).</li>
                    <li><strong>Description</strong> : Optionnel, description détaillée du genre.</li>
                </ul>
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle mr-2"></i>
                    <strong>Attention :</strong> Vérifiez que le code est unique avant de soumettre.
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $('form').on('submit', function (e) {
            var nom = $('#nom').val().trim();
            var code = $('#code').val().trim();

            if (nom === '' || code === '') {
                e.preventDefault();
                alert('Veuillez remplir tous les champs obligatoires.');
                return false;
            }
        });

        setTimeout(function () {
            $('.alert').fadeOut('slow');
        }, 5000);
    });
</script>

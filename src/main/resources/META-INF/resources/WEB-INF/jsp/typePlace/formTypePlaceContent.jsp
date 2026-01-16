<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
	<div class="col-md-6 offset-md-3">
		<div class="card card-primary">
			<div class="card-header">
				<h3 class="card-title">
					<i class="fas fa-couch mr-2"></i>
					<c:choose>
						<c:when test="${typePlace != null && typePlace.id != null}">Modifier un type de place</c:when>
						<c:otherwise>Ajouter un type de place</c:otherwise>
					</c:choose>
				</h3>
			</div>

			<form action="/type-place/save" method="post">
				<input type="hidden" name="id" value="${typePlace.id}" />

				<div class="card-body">
					<div class="form-group">
						<label for="nom">Nom <span class="text-danger">*</span></label>
						<input type="text" class="form-control" id="nom" name="nom" value="${typePlace.nom}" placeholder="Ex: Standard, VIP" required>
					</div>

					<div class="form-group">
						<label for="code">Code <span class="text-danger">*</span></label>
						<input type="text" class="form-control" id="code" name="code" value="${typePlace.code}" placeholder="Ex: STD" required>
					</div>

					<div class="form-group">
						<label for="prix">Prix <span class="text-danger">*</span></label>
						<input type="number" class="form-control" id="prix" name="prix" value="${typePlace.prix}" step="0.01" min="0.01" placeholder="Ex: 12000" required>
					</div>
				</div>

				<div class="card-footer d-flex justify-content-between">
					<a href="/type-place" class="btn btn-default">
						<i class="fas fa-times mr-2"></i>
						Annuler
					</a>
					<button type="submit" class="btn btn-primary">
						<i class="fas fa-save mr-2"></i>
						<c:choose>
							<c:when test="${typePlace != null && typePlace.id != null}">Mettre à jour</c:when>
							<c:otherwise>Enregistrer</c:otherwise>
						</c:choose>
					</button>
				</div>
			</form>
		</div>
	</div>
</div>

<script>
	$(document).ready(function () {
		setTimeout(function () {
			$('.alert').fadeOut('slow');
		}, 5000);
	});
</script>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="typePlaceItems"
	   value="${not empty typePlaceList ? typePlaceList : (not empty typePlace ? typePlace : (not empty typePlaces ? typePlaces : null))}" />

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
		<div class="card">
			<div class="card-header">
				<h3 class="card-title"><i class="fas fa-couch mr-2"></i> Liste des types de place</h3>
				<div class="card-tools">
					<a href="/type-place/form" class="btn btn-primary btn-sm" title="Nouveau type de place">
						<i class="fas fa-plus mr-1"></i>
						Nouveau
					</a>
					<a href="/type-place" class="btn btn-default btn-sm ml-1" title="Actualiser">
						<i class="fas fa-sync-alt"></i>
					</a>
				</div>
			</div>
			<div class="card-body">
				<div class="table-responsive">
					<table class="table table-bordered table-striped table-hover">
						<thead>
						<tr>
							<th style="width: 60px">#</th>
							<th>Nom</th>
							<th>Code</th>
							<th>Description</th>
							<th style="width: 140px">Prix</th>
							<th style="width: 110px">Actions</th>
						</tr>
						</thead>
						<tbody>
						<c:if test="${empty typePlaceItems}">
							<tr>
								<td colspan="5" class="text-center text-muted">
									<i class="fas fa-inbox fa-3x mb-3"></i>
									<p>Aucun type de place trouvé</p>
								</td>
							</tr>
						</c:if>

						<c:forEach var="typePlace" items="${typePlaceItems}" varStatus="iterStat">
							<tr>
								<td>${iterStat.count}</td>
								<td><strong>${typePlace.nom}</strong></td>
								<td>${typePlace.code}</td>
								<td>
									<c:choose>
										<c:when test="${not empty typePlace.desce}">${typePlace.desce}</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
								<td class="text-right">
									<fmt:formatNumber value="${typePlace.prix}" type="number" minFractionDigits="0" maxFractionDigits="2" />
								</td>
								<td class="text-center">
									<div class="btn-group btn-group-sm">
										<a class="btn btn-info" href="/type-place/edit/${typePlace.id}" title="Modifier">
											<i class="fas fa-edit"></i>
										</a>
									</div>
								</td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
			<c:if test="${not empty typePlaceItems}">
				<div class="card-footer clearfix">
					<span class="text-muted">Total : <strong>${fn:length(typePlaceItems)}</strong> type(s) de place</span>
				</div>
			</c:if>
		</div>
	</div>
</div>

<script>
	$(document).ready(function() {
		setTimeout(function() {
			$('.alert').fadeOut('slow');
		}, 5000);
	});
</script>

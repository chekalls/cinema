<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Info boxes -->
<div class="row">
    <div class="col-lg-3 col-6">
        <div class="small-box bg-info">
            <div class="inner">
                <h3>150</h3>
                <p>Films</p>
            </div>
            <div class="icon">
                <i class="fas fa-film"></i>
            </div>
            <a href="/films" class="small-box-footer">
                Plus d'infos <i class="fas fa-arrow-circle-right"></i>
            </a>
        </div>
    </div>

    <div class="col-lg-3 col-6">
        <div class="small-box bg-success">
            <div class="inner">
                <h3>53</h3>
                <p>Séances aujourd'hui</p>
            </div>
            <div class="icon">
                <i class="fas fa-calendar-alt"></i>
            </div>
            <a href="/seances" class="small-box-footer">
                Plus d'infos <i class="fas fa-arrow-circle-right"></i>
            </a>
        </div>
    </div>

    <div class="col-lg-3 col-6">
        <div class="small-box bg-warning">
            <div class="inner">
                <h3>44</h3>
                <p>Réservations</p>
            </div>
            <div class="icon">
                <i class="fas fa-ticket-alt"></i>
            </div>
            <a href="/reservations" class="small-box-footer">
                Plus d'infos <i class="fas fa-arrow-circle-right"></i>
            </a>
        </div>
    </div>

    <div class="col-lg-3 col-6">
        <div class="small-box bg-danger">
            <div class="inner">
                <h3>8</h3>
                <p>Salles</p>
            </div>
            <div class="icon">
                <i class="fas fa-door-open"></i>
            </div>
            <a href="/salles" class="small-box-footer">
                Plus d'infos <i class="fas fa-arrow-circle-right"></i>
            </a>
        </div>
    </div>
</div>

<!-- Alert message -->
<div class="row">
    <div class="col-md-12">
        <div class="alert alert-info alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h5><i class="icon fas fa-info"></i> Bienvenue!</h5>
            <span>${message}</span>
        </div>
    </div>
</div>

<!-- Main content -->
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Fonctionnalités principales</h3>
            </div>
            <div class="card-body">
                <ul>
                    <li><i class="fas fa-check text-success"></i> Gestion complète des films (ajout, modification, suppression)</li>
                    <li><i class="fas fa-check text-success"></i> Planification des séances cinéma</li>
                    <li><i class="fas fa-check text-success"></i> Système de réservation de billets</li>
                    <li><i class="fas fa-check text-success"></i> Gestion des salles et de leur capacité</li>
                    <li><i class="fas fa-check text-success"></i> Statistiques et rapports détaillés</li>
                </ul>
            </div>
        </div>
    </div>
</div>

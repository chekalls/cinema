<%@ page contentType="text/html;charset=UTF-8" %>

<!-- Main Sidebar Container -->
<aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <a href="/" class="brand-link">
        <i class="fas fa-film brand-image" style="margin-left: 10px; font-size: 2rem;"></i>
        <span class="brand-text font-weight-light">Gestion Cinéma</span>
    </a>

    <!-- Sidebar -->
    <div class="sidebar">
        <!-- Sidebar user panel -->
        <div class="user-panel mt-3 pb-3 mb-3 d-flex">
            <div class="image">
                <i class="fas fa-user-circle" style="font-size: 2.1rem; color: #c2c7d0;"></i>
            </div>
            <div class="info">
                <a href="#" class="d-block">Administrateur</a>
            </div>
        </div>

        <!-- Sidebar Menu -->
        <nav class="mt-2">
            <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu"
                data-accordion="false">
                <!-- Dashboard -->
                <li class="nav-item">
                    <a href="/" class="nav-link">
                        <i class="nav-icon fas fa-tachometer-alt"></i>
                        <p>Tableau de bord</p>
                    </a>
                </li>

                <!-- Films -->
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="nav-icon fas fa-film"></i>
                        <p>
                            Films
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="/films" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Liste des films</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="/films/form" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Ajouter un film</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="/films/genres" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Genres</p>
                            </a>
                        </li>
                    </ul>
                </li>

                <!-- Séances -->
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="nav-icon fas fa-calendar-alt"></i>
                        <p>
                            Séances
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="/sceances" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Liste des séances</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="/sceances/form" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Ajouter une séance</p>
                            </a>
                        </li>
                    </ul>
                </li>

                <!-- Cinémas -->
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="nav-icon fas fa-building"></i>
                        <p>
                            Cinémas
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="/cinemas" class="nav-link">
                                <i class="nav-icon fas fa-building"></i>
                                <p>liste des cinémas</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="/cinemas/form" class="nav-link">
                                <i class="nav-icon fas fa-plus-circle"></i>
                                <p>Ajouter un cinéma</p>
                            </a>
                        </li>
                    </ul>
                </li>

                <!-- Salles -->
                <li class="nav-item">
                    <a href="/salles" class="nav-link">
                        <i class="nav-icon fas fa-door-open"></i>
                        <p>Salles</p>
                    </a>
                </li>

                <!-- Réservations -->
                <li class="nav-item">
                    <a href="/reservations" class="nav-link">
                        <i class="nav-icon fas fa-ticket-alt"></i>
                        <p>Réservations</p>
                    </a>
                </li>

                <!-- Divider -->
                <li class="nav-header">ADMINISTRATION</li>

                <!-- À propos -->
                <li class="nav-item">
                    <a href="/about" class="nav-link">
                        <i class="nav-icon fas fa-info-circle"></i>
                        <p>À propos</p>
                    </a>
                </li>
            </ul>
        </nav>
    </div>
</aside>

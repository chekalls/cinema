package mg.gestion.cinema.controller;

import java.sql.Connection;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import mg.gestion.cinema.models.Cinema;
import mg.gestion.cinema.models.Film;
import mg.gestion.cinema.models.Salle;
import mg.gestion.cinema.service.ConnexionService;
import mg.gestion.cinema.utils.CGenericUtils;
import mg.gestion.cinema.utils.Page;

@Controller
@RequestMapping("/stats")
public class StatController {

    private static final int MAX_COMPARE_FILMS = 20;
    private static final int MAX_COMPARE_SALLES = 20;
    
    @Autowired
    private ConnexionService connexionService;

    @GetMapping("/salles")
    public String statSalle(
            @RequestParam(required = false) List<Integer> salleId,
            @RequestParam(required = false) Integer cinemaId,
            @RequestParam(required = false) String dateDebut,
            @RequestParam(required = false) String dateFin,
            Model model) {
        try (Connection conn = connexionService.getConnection()) {
            LocalDate dateDebutParsed = null;
            LocalDate dateFinParsed = null;
            try {
                dateDebutParsed = parseDateOrNull(dateDebut);
                dateFinParsed = parseDateOrNull(dateFin);
                if (dateDebutParsed != null && dateFinParsed != null && dateFinParsed.isBefore(dateDebutParsed)) {
                    model.addAttribute("error", "La date de fin doit être postérieure ou égale à la date de début");
                    dateDebutParsed = null;
                    dateFinParsed = null;
                }
            } catch (DateTimeParseException e) {
                model.addAttribute("error", "Format de date invalide (attendu: AAAA-MM-JJ)");
            }

            List<Cinema> cinemas = CGenericUtils.find(conn, Cinema.class, new HashMap<>());
            List<Salle> salles;
            if (cinemaId != null) {
                salles = CGenericUtils.find(conn, Salle.class, Map.of("cinemaId", cinemaId));
            } else {
                salles = CGenericUtils.find(conn, Salle.class, new HashMap<>());
            }

            model.addAttribute("cinemas", cinemas);
            model.addAttribute("salles", salles);

            // Si des salles sont sélectionnées, charger leurs statistiques
            if (salleId != null && !salleId.isEmpty()) {
                Map<Integer, Map<String, Object>> allStats = new HashMap<>();
                Map<Integer, Salle> sallesMap = new HashMap<>();

                for (Integer id : salleId) {
                    Map<String, Object> criteria = new HashMap<>();
                    criteria.put("id", id);
                    Salle salle = CGenericUtils.findOne(conn, Salle.class, criteria);

                    if (salle != null && (cinemaId == null || cinemaId.equals(salle.getCinemaId()))) {
                        sallesMap.put(id, salle);
                        Map<String, Object> salleStats = calculateSalleStats(conn, id, dateDebutParsed, dateFinParsed);
                        allStats.put(id, salleStats);
                    }
                }

                model.addAttribute("sallesComparaison", sallesMap);
                model.addAttribute("statsComparaison", allStats);
            }

            model.addAttribute("salleId", salleId);
            model.addAttribute("cinemaId", cinemaId);
            model.addAttribute("dateDebut", dateDebut);
            model.addAttribute("dateFin", dateFin);

            return "stat/statSalle";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des statistiques : " + e.getMessage());
            return "stat/statSalle";
        }
    }

    @GetMapping("/places")
    public String statPlace(
            @RequestParam(required = false) List<Integer> salleId,
            @RequestParam(required = false) Integer cinemaId,
            Model model) {
        try (Connection conn = connexionService.getConnection()) {
            List<Cinema> cinemas = CGenericUtils.find(conn, Cinema.class, new HashMap<>());
            List<Salle> salles;
            if (cinemaId != null) {
                salles = CGenericUtils.find(conn, Salle.class, Map.of("cinemaId", cinemaId));
            } else {
                salles = CGenericUtils.find(conn, Salle.class, new HashMap<>());
            }

            model.addAttribute("cinemas", cinemas);
            model.addAttribute("salles", salles);

            if (salleId != null && !salleId.isEmpty()) {
                List<Integer> salleIdsEffective = salleId;
                if (salleId.size() > MAX_COMPARE_SALLES) {
                    salleIdsEffective = salleId.subList(0, MAX_COMPARE_SALLES);
                    model.addAttribute("warning", "Comparaison limitée à " + MAX_COMPARE_SALLES + " salles pour des raisons de performance.");
                }

                // Charger les salles sélectionnées en une seule requête
                String inClause = buildInClausePlaceholders(salleIdsEffective.size());
                String selectedSallesSql = "SELECT * FROM salle WHERE id IN (" + inClause + ")";
                List<Salle> selectedSalles = CGenericUtils.executeQuery(conn, Salle.class, selectedSallesSql, salleIdsEffective.toArray());

                Map<Integer, Salle> sallesMap = new HashMap<>();
                for (Salle salle : selectedSalles) {
                    if (salle == null || salle.getId() == null) {
                        continue;
                    }
                    if (cinemaId == null || cinemaId.equals(salle.getCinemaId())) {
                        sallesMap.put(salle.getId(), salle);
                    }
                }

                Map<Integer, Map<String, Object>> stats = calculatePlaceStatsBatch(conn, new ArrayList<>(sallesMap.keySet()));
                model.addAttribute("sallesComparaison", sallesMap);
                model.addAttribute("statsComparaison", stats);
                model.addAttribute("salleId", new ArrayList<>(sallesMap.keySet()));
            } else {
                model.addAttribute("salleId", salleId);
            }

            model.addAttribute("cinemaId", cinemaId);
            return "stat/statPlace";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des statistiques : " + e.getMessage());
            return "stat/statPlace";
        }
    }

    private Map<Integer, Map<String, Object>> calculatePlaceStatsBatch(Connection conn, List<Integer> salleIds) {
        Map<Integer, Map<String, Object>> all = new HashMap<>();
        if (salleIds == null || salleIds.isEmpty()) {
            return all;
        }

        for (Integer salleId : salleIds) {
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalPlaces", 0L);
            stats.put("revenueMax", 0D);
            stats.put("placeParType", List.of());
            all.put(salleId, stats);
        }

        String inClause = buildInClausePlaceholders(salleIds.size());

        // Totaux + revenu max
        {
            String sql = "SELECT p.salle_id, COUNT(p.id) as total_places, COALESCE(SUM(COALESCE(tp.prix, 0)), 0) as revenue_max " +
                    "FROM place p " +
                    "LEFT JOIN type_place tp ON p.type_place_id = tp.id " +
                    "WHERE p.salle_id IN (" + inClause + ") " +
                    "GROUP BY p.salle_id";

            List<Map<String, Object>> rows = Salle.executeRawQuery(conn, sql, salleIds.toArray());
            for (Map<String, Object> row : rows) {
                Integer salleId = row.get("salle_id") == null ? null : Integer.parseInt(row.get("salle_id").toString());
                if (salleId == null || !all.containsKey(salleId)) {
                    continue;
                }
                long totalPlaces = Long.parseLong(row.get("total_places").toString());
                double revenueMax = row.get("revenue_max") == null ? 0 : Double.parseDouble(row.get("revenue_max").toString());
                all.get(salleId).put("totalPlaces", totalPlaces);
                all.get(salleId).put("revenueMax", revenueMax);
            }
        }

        // Répartition par type
        {
            String sql = "SELECT p.salle_id, tp.nom, tp.code, tp.prix, COUNT(p.id) as count, " +
                    "COALESCE(SUM(COALESCE(tp.prix, 0)), 0) as revenue " +
                    "FROM place p " +
                    "LEFT JOIN type_place tp ON p.type_place_id = tp.id " +
                    "WHERE p.salle_id IN (" + inClause + ") " +
                    "GROUP BY p.salle_id, tp.id, tp.nom, tp.code, tp.prix " +
                    "ORDER BY p.salle_id, count DESC";

            List<Map<String, Object>> rows = Salle.executeRawQuery(conn, sql, salleIds.toArray());
            Map<Integer, List<Map<String, Object>>> perSalle = new HashMap<>();
            for (Map<String, Object> row : rows) {
                Integer salleId = row.get("salle_id") == null ? null : Integer.parseInt(row.get("salle_id").toString());
                if (salleId == null || !all.containsKey(salleId)) {
                    continue;
                }
                perSalle.computeIfAbsent(salleId, k -> new ArrayList<>()).add(row);
            }
            for (Map.Entry<Integer, List<Map<String, Object>>> entry : perSalle.entrySet()) {
                all.get(entry.getKey()).put("placeParType", entry.getValue());
            }
        }

        return all;
    }

    private Map<String, Object> calculateSalleStats(Connection conn, Integer salleId, LocalDate dateDebut, LocalDate dateFin) {
        Map<String, Object> stats = new HashMap<>();

        try {
            // Nombre total de places
            String placeCountSql = "SELECT COUNT(*) as total FROM place WHERE salle_id = ?";
            List<Map<String, Object>> placeCountResult = Salle.executeRawQuery(conn, placeCountSql, salleId);
            long totalPlaces = placeCountResult.isEmpty() ? 0 : Long.parseLong(placeCountResult.get(0).get("total").toString());

            // Nombre de séances dans la période (filtre sur la date de début de séance)
            StringBuilder seanceCountSql = new StringBuilder("SELECT COUNT(*) as total FROM seance se WHERE se.salle_id = ?");
            List<Object> seanceParams = new ArrayList<>();
            seanceParams.add(salleId);
            appendDateFiltersOnSeanceDebut(seanceCountSql, seanceParams, dateDebut, dateFin);
            List<Map<String, Object>> seanceCountResult = Salle.executeRawQuery(conn, seanceCountSql.toString(), seanceParams.toArray());
            long totalSeances = seanceCountResult.isEmpty() ? 0 : Long.parseLong(seanceCountResult.get(0).get("total").toString());

            // Billets vendus (PAYE/UTILISE) et CA sur la période (filtre sur la date de séance)
            StringBuilder soldCountSql = new StringBuilder(
                "SELECT COUNT(*) as total " +
                "FROM billet b " +
                "INNER JOIN place p ON b.place_id = p.id " +
                "INNER JOIN seance se ON b.seance_id = se.id " +
                "INNER JOIN statut st ON b.statut = st.id " +
                "WHERE p.salle_id = ? AND st.code IN ('PAYE','UTILISE')"
            );
            List<Object> soldParams = new ArrayList<>();
            soldParams.add(salleId);
            appendDateFiltersOnSeanceDebut(soldCountSql, soldParams, dateDebut, dateFin);
            List<Map<String, Object>> soldCountResult = Salle.executeRawQuery(conn, soldCountSql.toString(), soldParams.toArray());
            long totalBillets = soldCountResult.isEmpty() ? 0 : Long.parseLong(soldCountResult.get(0).get("total").toString());

            StringBuilder revenueSql = new StringBuilder(
                "SELECT COALESCE(SUM(b.prix_reel), 0) as total " +
                "FROM billet b " +
                "INNER JOIN place p ON b.place_id = p.id " +
                "INNER JOIN seance se ON b.seance_id = se.id " +
                "INNER JOIN statut st ON b.statut = st.id " +
                "WHERE p.salle_id = ? AND st.code IN ('PAYE','UTILISE')"
            );
            List<Object> revenueParams = new ArrayList<>();
            revenueParams.add(salleId);
            appendDateFiltersOnSeanceDebut(revenueSql, revenueParams, dateDebut, dateFin);
            List<Map<String, Object>> revenueResult = Salle.executeRawQuery(conn, revenueSql.toString(), revenueParams.toArray());
            double totalRevenue = revenueResult.isEmpty() || revenueResult.get(0).get("total") == null ? 0 :
                Double.parseDouble(revenueResult.get(0).get("total").toString());

            long theoreticalCapacity = totalPlaces * totalSeances;

            // Taux d'occupation
            double occupationRate = theoreticalCapacity > 0 ? (totalBillets * 100.0) / theoreticalCapacity : 0;

            double avgTicket = totalBillets > 0 ? (totalRevenue / totalBillets) : 0;

            // Répartition par statut de billet
            StringBuilder billetStatutSql = new StringBuilder(
                "SELECT st.nom, st.code, COUNT(b.id) as count " +
                "FROM billet b " +
                "INNER JOIN place p ON b.place_id = p.id " +
                "INNER JOIN seance se ON b.seance_id = se.id " +
                "INNER JOIN statut st ON b.statut = st.id " +
                "WHERE p.salle_id = ?"
            );
            List<Object> billetStatutParams = new ArrayList<>();
            billetStatutParams.add(salleId);
            appendDateFiltersOnSeanceDebut(billetStatutSql, billetStatutParams, dateDebut, dateFin);
            billetStatutSql.append(" GROUP BY st.id, st.nom, st.code ORDER BY count DESC");
            List<Map<String, Object>> billetStatutData = Salle.executeRawQuery(conn, billetStatutSql.toString(), billetStatutParams.toArray());

            // Répartition par type de place
            String typePlaceSql = "SELECT tp.nom, tp.code, tp.prix, COUNT(p.id) as count FROM place p " +
                "LEFT JOIN type_place tp ON p.type_place_id = tp.id " +
                "WHERE p.salle_id = ? " +
                "GROUP BY tp.id, tp.nom, tp.code, tp.prix";

            List<Map<String, Object>> typePlaceData = Salle.executeRawQuery(conn, typePlaceSql, salleId);

            stats.put("totalBillets", totalBillets);
            stats.put("totalRevenue", totalRevenue);
            stats.put("totalPlaces", totalPlaces);
            stats.put("totalSeances", totalSeances);
            stats.put("theoreticalCapacity", theoreticalCapacity);
            stats.put("occupationRate", occupationRate);
            stats.put("avgTicket", avgTicket);
            stats.put("billetParStatut", billetStatutData);
            stats.put("placeParType", typePlaceData);

        } catch (Exception e) {
            stats.put("error", e.getMessage());
        }

        return stats;
    }

    @GetMapping("/films")
    public String statFilm(
            @RequestParam(required = false) List<Integer> filmId,
            @RequestParam(required = false) String search,
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam(required = false, defaultValue = "50") int size,
            @RequestParam(required = false) String dateDebut,
            @RequestParam(required = false) String dateFin,
            Model model) {
        try (Connection conn = connexionService.getConnection()) {
            LocalDate dateDebutParsed = null;
            LocalDate dateFinParsed = null;
            try {
                dateDebutParsed = parseDateOrNull(dateDebut);
                dateFinParsed = parseDateOrNull(dateFin);
                if (dateDebutParsed != null && dateFinParsed != null && dateFinParsed.isBefore(dateDebutParsed)) {
                    model.addAttribute("error", "La date de fin doit être postérieure ou égale à la date de début");
                    dateDebutParsed = null;
                    dateFinParsed = null;
                }
            } catch (DateTimeParseException e) {
                model.addAttribute("error", "Format de date invalide (attendu: AAAA-MM-JJ)");
            }

            Page<Film> filmPage = CGenericUtils.searchPaginated(conn, Film.class, search, page, size, false);
            List<Film> filmsPageContent = filmPage.getContent();

            // Si des films sont sélectionnés, charger leurs statistiques (optimisé pour les gros volumes)
            Map<Integer, Film> filmsMap = new HashMap<>();
            if (filmId != null && !filmId.isEmpty()) {
                List<Integer> filmIdsEffective = filmId;
                if (filmId.size() > MAX_COMPARE_FILMS) {
                    filmIdsEffective = filmId.subList(0, MAX_COMPARE_FILMS);
                    model.addAttribute("warning", "Comparaison limitée à " + MAX_COMPARE_FILMS + " films pour des raisons de performance.");
                }

                // Charger les films sélectionnés en une seule requête
                String inClause = buildInClausePlaceholders(filmIdsEffective.size());
                String selectedFilmsSql = "SELECT * FROM film WHERE id IN (" + inClause + ")";
                List<Film> selectedFilms = CGenericUtils.executeQuery(conn, Film.class, selectedFilmsSql, filmIdsEffective.toArray());
                for (Film film : selectedFilms) {
                    if (film != null && film.getId() != null) {
                        filmsMap.put(film.getId(), film);
                    }
                }

                Map<Integer, Map<String, Object>> allStats = calculateFilmStatsBatch(conn, filmIdsEffective, dateDebutParsed, dateFinParsed);
                model.addAttribute("filmsComparaison", filmsMap);
                model.addAttribute("statsComparaison", allStats);
                model.addAttribute("filmId", filmIdsEffective);
            } else {
                model.addAttribute("filmId", filmId);
            }

            // Liste affichée dans le select: films sélectionnés + page courante (sans doublons)
            List<Film> filmsForSelect = new ArrayList<>();
            if (!filmsMap.isEmpty()) {
                filmsForSelect.addAll(filmsMap.values());
            }
            for (Film film : filmsPageContent) {
                if (film == null || film.getId() == null) {
                    continue;
                }
                if (!filmsMap.containsKey(film.getId())) {
                    filmsForSelect.add(film);
                }
            }

            model.addAttribute("films", filmsForSelect);
            model.addAttribute("page", filmPage.getNumber());
            model.addAttribute("size", filmPage.getSize());
            model.addAttribute("total", filmPage.getTotalElements());
            model.addAttribute("totalPages", filmPage.getTotalPages());
            if (search != null && !search.trim().isEmpty()) {
                model.addAttribute("search", search);
            }

            model.addAttribute("dateDebut", dateDebut);
            model.addAttribute("dateFin", dateFin);

            return "stat/statFilm";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des statistiques : " + e.getMessage());
            return "stat/statFilm";
        }
    }

    private Map<Integer, Map<String, Object>> calculateFilmStatsBatch(Connection conn, List<Integer> filmIds, LocalDate dateDebut, LocalDate dateFin) {
        Map<Integer, Map<String, Object>> all = new HashMap<>();
        if (filmIds == null || filmIds.isEmpty()) {
            return all;
        }

        for (Integer filmId : filmIds) {
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalSeances", 0L);
            stats.put("totalBillets", 0L);
            stats.put("totalRevenue", 0D);
            stats.put("avgOccupancy", 0D);
            stats.put("avgTicket", 0D);
            stats.put("parSalle", List.of());
            stats.put("parStatut", List.of());
            all.put(filmId, stats);
        }

        String inClause = buildInClausePlaceholders(filmIds.size());

        // Séances
        {
            StringBuilder sql = new StringBuilder("SELECT se.film_id, COUNT(*) as total FROM seance se WHERE se.film_id IN (")
                .append(inClause).append(")");
            List<Object> params = new ArrayList<>(filmIds);
            appendDateFiltersOnSeanceDebut(sql, params, dateDebut, dateFin);
            sql.append(" GROUP BY se.film_id");
            List<Map<String, Object>> rows = Salle.executeRawQuery(conn, sql.toString(), params.toArray());
            for (Map<String, Object> row : rows) {
                Integer filmId = row.get("film_id") == null ? null : Integer.parseInt(row.get("film_id").toString());
                if (filmId != null && all.containsKey(filmId)) {
                    all.get(filmId).put("totalSeances", Long.parseLong(row.get("total").toString()));
                }
            }
        }

        // Billets vendus + CA
        {
            StringBuilder sql = new StringBuilder(
                "SELECT se.film_id, COUNT(*) as billets, COALESCE(SUM(b.prix_reel), 0) as revenue " +
                "FROM billet b " +
                "INNER JOIN seance se ON b.seance_id = se.id " +
                "INNER JOIN statut st ON b.statut = st.id " +
                "WHERE se.film_id IN (" + inClause + ") AND st.code IN ('PAYE','UTILISE')"
            );
            List<Object> params = new ArrayList<>(filmIds);
            appendDateFiltersOnSeanceDebut(sql, params, dateDebut, dateFin);
            sql.append(" GROUP BY se.film_id");
            List<Map<String, Object>> rows = Salle.executeRawQuery(conn, sql.toString(), params.toArray());
            for (Map<String, Object> row : rows) {
                Integer filmId = row.get("film_id") == null ? null : Integer.parseInt(row.get("film_id").toString());
                if (filmId != null && all.containsKey(filmId)) {
                    long billets = Long.parseLong(row.get("billets").toString());
                    double revenue = row.get("revenue") == null ? 0 : Double.parseDouble(row.get("revenue").toString());
                    all.get(filmId).put("totalBillets", billets);
                    all.get(filmId).put("totalRevenue", revenue);
                    all.get(filmId).put("avgTicket", billets > 0 ? (revenue / billets) : 0D);
                }
            }
        }

        // Occupation moyenne (%)
        {
            StringBuilder sql = new StringBuilder(
                "SELECT film_id, COALESCE(AVG(occ_rate), 0) as avg_occupancy " +
                "FROM (" +
                "  SELECT se.film_id, se.id, " +
                "    CASE WHEN cap.total_places > 0 " +
                "         THEN (COUNT(CASE WHEN st.code IN ('PAYE','UTILISE') THEN b.id END) * 100.0) / cap.total_places " +
                "         ELSE 0 END as occ_rate " +
                "  FROM seance se " +
                "  INNER JOIN (SELECT salle_id, COUNT(*) as total_places FROM place GROUP BY salle_id) cap ON cap.salle_id = se.salle_id " +
                "  LEFT JOIN billet b ON b.seance_id = se.id " +
                "  LEFT JOIN statut st ON st.id = b.statut " +
                "  WHERE se.film_id IN (" + inClause + ")"
            );
            List<Object> params = new ArrayList<>(filmIds);
            appendDateFiltersOnSeanceDebut(sql, params, dateDebut, dateFin);
            sql.append("  GROUP BY se.film_id, se.id, cap.total_places")
               .append(") as per_seance GROUP BY film_id");
            List<Map<String, Object>> rows = Salle.executeRawQuery(conn, sql.toString(), params.toArray());
            for (Map<String, Object> row : rows) {
                Integer filmId = row.get("film_id") == null ? null : Integer.parseInt(row.get("film_id").toString());
                if (filmId != null && all.containsKey(filmId)) {
                    double avg = row.get("avg_occupancy") == null ? 0 : Double.parseDouble(row.get("avg_occupancy").toString());
                    all.get(filmId).put("avgOccupancy", avg);
                }
            }
        }

        // Par salle (billets + CA)
        {
            StringBuilder sql = new StringBuilder(
                "SELECT se.film_id, s.designation, s.numero, " +
                "  COUNT(CASE WHEN st.code IN ('PAYE','UTILISE') THEN b.id END) as billets, " +
                "  COALESCE(SUM(CASE WHEN st.code IN ('PAYE','UTILISE') THEN b.prix_reel ELSE 0 END), 0) as revenue " +
                "FROM seance se " +
                "INNER JOIN salle s ON se.salle_id = s.id " +
                "LEFT JOIN billet b ON b.seance_id = se.id " +
                "LEFT JOIN statut st ON st.id = b.statut " +
                "WHERE se.film_id IN (" + inClause + ")"
            );
            List<Object> params = new ArrayList<>(filmIds);
            appendDateFiltersOnSeanceDebut(sql, params, dateDebut, dateFin);
            sql.append(" GROUP BY se.film_id, s.id, s.designation, s.numero ORDER BY se.film_id, billets DESC");
            List<Map<String, Object>> rows = Salle.executeRawQuery(conn, sql.toString(), params.toArray());

            Map<Integer, List<Map<String, Object>>> perFilm = new HashMap<>();
            for (Map<String, Object> row : rows) {
                Integer filmId = row.get("film_id") == null ? null : Integer.parseInt(row.get("film_id").toString());
                if (filmId == null || !all.containsKey(filmId)) {
                    continue;
                }
                perFilm.computeIfAbsent(filmId, k -> new ArrayList<>()).add(row);
            }
            for (Map.Entry<Integer, List<Map<String, Object>>> entry : perFilm.entrySet()) {
                all.get(entry.getKey()).put("parSalle", entry.getValue());
            }
        }

        // Par statut
        {
            StringBuilder sql = new StringBuilder(
                "SELECT se.film_id, st.nom, st.code, COUNT(b.id) as count " +
                "FROM billet b " +
                "INNER JOIN seance se ON b.seance_id = se.id " +
                "INNER JOIN statut st ON b.statut = st.id " +
                "WHERE se.film_id IN (" + inClause + ")"
            );
            List<Object> params = new ArrayList<>(filmIds);
            appendDateFiltersOnSeanceDebut(sql, params, dateDebut, dateFin);
            sql.append(" GROUP BY se.film_id, st.id, st.nom, st.code ORDER BY se.film_id, count DESC");
            List<Map<String, Object>> rows = Salle.executeRawQuery(conn, sql.toString(), params.toArray());

            Map<Integer, List<Map<String, Object>>> perFilm = new HashMap<>();
            for (Map<String, Object> row : rows) {
                Integer filmId = row.get("film_id") == null ? null : Integer.parseInt(row.get("film_id").toString());
                if (filmId == null || !all.containsKey(filmId)) {
                    continue;
                }
                perFilm.computeIfAbsent(filmId, k -> new ArrayList<>()).add(row);
            }
            for (Map.Entry<Integer, List<Map<String, Object>>> entry : perFilm.entrySet()) {
                all.get(entry.getKey()).put("parStatut", entry.getValue());
            }
        }

        return all;
    }

    private LocalDate parseDateOrNull(String date) {
        if (date == null || date.isBlank()) {
            return null;
        }
        return LocalDate.parse(date);
    }

    private void appendDateFiltersOnSeanceDebut(StringBuilder sql, List<Object> params, LocalDate dateDebut, LocalDate dateFin) {
        if (dateDebut != null) {
            sql.append(" AND se.debut::date >= ?");
            params.add(dateDebut);
        }
        if (dateFin != null) {
            sql.append(" AND se.debut::date <= ?");
            params.add(dateFin);
        }
    }

    private String buildInClausePlaceholders(int count) {
        if (count <= 0) {
            throw new IllegalArgumentException("count must be positive");
        }
        return String.join(", ", java.util.Collections.nCopies(count, "?"));
    }
}

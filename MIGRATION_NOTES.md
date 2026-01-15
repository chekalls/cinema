# Notes de Migration - BaseEntity vers CGenericUtils

## Vue d'ensemble
Les fonctions génériques liées à la base de données ont été migrées de `BaseEntity` vers `CGenericUtils` pour une meilleure séparation des responsabilités.

## Changements effectués

### 1. BaseEntity
- **Avant** : Contenait à la fois les méthodes d'héritage pour les entités ET toute la logique de base de données
- **Après** : Ne contient que des méthodes wrapper qui délèguent à `CGenericUtils`
- **Rôle** : Classe parent pour les entités avec API simplifiée

### 2. CGenericUtils (nouveau)
- **Localisation** : `mg.gestion.cinema.utils.CGenericUtils`
- **Rôle** : Contient toute la logique générique de base de données
- **Signatures** : Toutes les méthodes prennent un paramètre `Class<? extends BaseEntity>` supplémentaire

## API de CGenericUtils

### Méthodes de recherche
```java
// Recherche par texte (ILIKE sur tous les champs String)
List<T> search(Connection conn, Class<T> clazz, String search)

// Recherche par critères avec LIKE sur les String
List<T> search(Connection conn, Class<T> clazz, Map<String, Object> searchCriteria)

// Recherche par critères exacts
List<T> find(Connection connection, Class<T> clazz, Map<String, Object> criteria)
List<T> find(Connection connection, Class<T> clazz, Map<String, Object> criteria, boolean loadAttributes)

// Recherche d'une seule entité
T findOne(Connection connection, Class<T> clazz, Map<String, Object> criteria)
T findOne(Connection connection, Class<T> clazz, Map<String, Object> criteria, boolean loadAttributes)
```

### Méthodes CRUD
```java
// Sauvegarde (INSERT ou UPDATE)
T save(Connection connection, T entity)

// Suppression
void delete(Connection connection, BaseEntity entity)
```

### Requêtes personnalisées
```java
// Requête avec mapping vers entité
List<T> executeQuery(Connection connection, Class<T> clazz, String sql, Object... parameters)
List<T> executeQuery(Connection connection, Class<T> clazz, String sql, boolean loadAttributes, Object... parameters)

T executeQueryOne(Connection connection, Class<T> clazz, String sql, Object... parameters)
T executeQueryOne(Connection connection, Class<T> clazz, String sql, boolean loadAttributes, Object... parameters)

// Requête retournant des Map
List<Map<String, Object>> executeRawQuery(Connection connection, String sql, Object... parameters)
Map<String, Object> executeRawQueryOne(Connection connection, String sql, Object... parameters)

// Requêtes de modification
int executeUpdate(Connection connection, String sql, Object... parameters)

// Requête scalaire
Object executeScalar(Connection connection, String sql, Object... parameters)
```

### Méthodes utilitaires
```java
// Comptage
long count(Connection connection, Class<T> clazz, Map<String, Object> criteria)

// Vérification d'existence
boolean exist(Connection connection, Class<T> clazz, Object id)
boolean exist(Connection connection, Class<T> clazz, Map<String, Object> criteria)

// Chargement des attributs avec @Loader
void loadAttributes(BaseEntity entity, Connection connection)
```

## Utilisation

### Depuis une entité (API inchangée)
```java
Film film = new Film();
List<BaseEntity> films = film.find(connection, criteria);
film.save(connection);
```

### Directement avec CGenericUtils (nouvelle API)
```java
// Plus explicite et type-safe
List<Film> films = CGenericUtils.find(connection, Film.class, criteria);
Film film = CGenericUtils.findOne(connection, Film.class, Map.of("id", 1));
CGenericUtils.save(connection, film);
```

## Avantages de la migration

1. **Séparation des responsabilités**
   - `BaseEntity` : Classe parent pour les entités
   - `CGenericUtils` : Logique de base de données générique

2. **Type-safety amélioré**
   - Les méthodes de `CGenericUtils` retournent le type exact (`List<Film>` au lieu de `List<BaseEntity>`)
   - Moins de cast nécessaires

3. **Réutilisabilité**
   - Les fonctions peuvent être appelées sans avoir besoin d'une instance
   - Utile pour les opérations statiques

4. **Maintenabilité**
   - Code de base de données centralisé
   - Plus facile à tester et modifier

## Compatibilité

✅ **100% rétrocompatible** : Tout le code existant continue de fonctionner sans modification.

Les méthodes de `BaseEntity` délèguent simplement à `CGenericUtils`, donc l'ancienne API reste valide.

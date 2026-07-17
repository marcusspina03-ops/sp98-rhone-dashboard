-- =============================================================================
-- Exploration des données carburant (BigQuery)
-- Prix du SP98 dans le Rhône (69)
-- =============================================================================

-- 1. Afficher toute la table
SELECT * FROM fr_carburant.fr_carburant;


-- 2. Afficher seulement quelques colonnes de la table
SELECT
  adresse,
  prix_sp98,
  latitude,
  longitude,
  ville,
  code_departement
FROM fr_carburant.fr_carburant;


-- 3. Trouver le prix min/max du SP98 et renommer les colonnes
SELECT
  MIN(prix_sp98) AS min_prix_sp98,
  MAX(prix_sp98) AS max_prix_sp98
FROM fr_carburant.fr_carburant;


-- 4. Afficher les stations essence du département 69
SELECT
  adresse,
  prix_sp98,
  latitude,
  longitude,
  ville,
  code_departement
FROM fr_carburant.fr_carburant
WHERE code_departement = "69";


-- 5. Compter les stations essence du département 69
SELECT
  COUNT(id) AS nb_station_69
FROM fr_carburant.fr_carburant
WHERE code_departement = "69";


-- 6. Afficher les stations essence du département 69 qui ont du SP98
SELECT
  adresse,
  prix_sp98,
  latitude,
  longitude,
  ville,
  code_departement
FROM fr_carburant.fr_carburant
WHERE code_departement = "69"
  AND prix_sp98 IS NOT NULL;


-- 7. Trouver les stations essence les moins chères du département 69
SELECT
  adresse,
  prix_sp98,
  latitude,
  longitude,
  ville,
  code_departement
FROM fr_carburant.fr_carburant
WHERE code_departement = "69"
  AND prix_sp98 IS NOT NULL
ORDER BY prix_sp98 ASC;


-- 8. Préparation des colonnes nécessaires au dashboard :
--    adresse complète + ville, prix du SP98 arrondi, distance à mon adresse
-- (point de référence : Place Bellecour, Lyon — voir 02_vue_dashboard.sql
--  pour la version finale utilisée par le dashboard)
SELECT
  CONCAT(adresse, ' ', code_postal, ' ', ville) AS adresse_complete,
  id,
  ville,
  ROUND(prix_sp98, 2) AS prix_sp98,
  ROUND(
    ST_DISTANCE(
      ST_GEOGPOINT(4.8320, 45.7578),
      ST_GEOGPOINT(longitude, latitude)
    ) / 1000, 1
  ) AS distance_km
FROM fr_carburant.fr_carburant
WHERE code_departement = '69'
  AND prix_sp98 IS NOT NULL;
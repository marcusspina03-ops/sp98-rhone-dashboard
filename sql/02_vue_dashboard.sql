-- =============================================================================
-- Vue finale : préparation des données pour le dashboard Power BI
-- Prix du SP98 dans le Rhône (69)
--
-- Colonnes exposées :
--   - adresse complète des stations + ville
--   - prix du SP98 (arrondi au centime près)
--   - distance entre un point de référence et chaque station (en km)
-- =============================================================================

CREATE OR REPLACE VIEW
`carburant-502608.fr_carburant.vue_station_69` AS

SELECT
    id,
    CONCAT(adresse, ' ', code_postal, ' ', ville, ' ') AS adresse_complete,
    adresse,
    ville,
    latitude,
    longitude,
    ROUND(prix_sp98, 2) AS prix_sp98,
    ROUND(
        ST_DISTANCE(
            ST_GEOGPOINT(4.8320, 45.7578),  -- point de référence (Place Bellecour, Lyon)
            ST_GEOGPOINT(longitude, latitude)
        ) / 1000,
        1
    ) AS distance_km
FROM `carburant-502608.fr_carburant.fr_carburant`
WHERE code_departement = '69'
  AND prix_sp98 IS NOT NULL;
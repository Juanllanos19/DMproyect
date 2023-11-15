WITH FechasRan AS (
  SELECT MIN(EXTRACT(YEAR FROM date)) as start_year, MAX(EXTRACT(YEAR FROM date)) end_year
  FROM `indigo-night-397214.earthquakeproject.terremotos`
),
variables AS (
  SELECT
    start_year,
    end_year,
    -4.21 AS latitude_1,
    -79.53 AS longitude_1,
    12.66 AS latitude_2,
    -66.80 AS longitude_2,
    100 AS AreasSqr
    FROM FechasRan
),
years as(
  SELECT
  year
    FROM
  UNNEST(GENERATE_ARRAY((SELECT start_year FROM variables), (SELECT end_year FROM variables))) AS year
),
latitudes AS(
  SELECT
  latitude_1,
  latitude_2
  FROM 
  (SELECT variables.latitude_1+ABS(variables.latitude_1-variables.latitude_2)*particiones/AreasSqr as latitude_1,
  variables.latitude_1+ABS(variables.latitude_1-variables.latitude_2)*(particiones+1)/AreasSqr as latitude_2
  FROM UNNEST(GENERATE_ARRAY(0, (SELECT AreasSqr FROM variables)-1)) as particiones, variables)
),
longitudes AS(
  SELECT
  longitude_1,
  longitude_2
  FROM 
  (SELECT variables.longitude_1+ABS(variables.longitude_1-variables.longitude_2)*particiones/AreasSqr as longitude_1,
  variables.longitude_1+ABS(variables.longitude_1-variables.longitude_2)*(particiones+1)/AreasSqr as longitude_2
  FROM UNNEST(GENERATE_ARRAY(0, (SELECT AreasSqr FROM variables)-1)) as particiones, variables)
),
plantilla AS(
  SELECT latitude_1, longitude_1,
  latitude_2,longitude_2, 0 as num, 0 as sum, year
  FROM latitudes, longitudes, years
)
SELECT  year, latitude_1, longitude_1,
  latitude_2,longitude_2, COUNT(*) as num, SUM(COALESCE(T.magnitudo, 0)) as sum
from plantilla LEFT JOIN `indigo-night-397214.earthquakeproject.terremotos` as T
ON T.latitude>plantilla.latitude_1 AND T.latitude<plantilla.latitude_2 AND T.longitude>plantilla.longitude_1 AND T.longitude<plantilla.longitude_2 
AND year= EXTRACT(YEAR FROM T.date)
group by year, latitude_1, longitude_1, latitude_2, longitude_2

SELECT
    year, latitude_1, longitude_1,
  latitude_2,longitude_2,
  suma
      FROM
        `indigo-night-397214.earthquakeproject.DepuradoTerremotos`
      WHERE
      year>((SELECT MAX(year) as maxyr
  FROM `indigo-night-397214.earthquakeproject.DepuradoTerremotos`)-((SELECT MAX(year) as maxyr
  FROM `indigo-night-397214.earthquakeproject.DepuradoTerremotos`)-(SELECT MIN(year) as minyr
  FROM `indigo-night-397214.earthquakeproject.DepuradoTerremotos`))*0.3)
SELECT
  original_column,
  CASE
    WHEN original_column < 1 THEN 'Very Low Risk'
    WHEN original_column >= 1 AND original_column < 3 THEN 'Low Risk'
    WHEN original_column >= 3 AND original_column < 6 THEN 'Moderate Risk'
    WHEN original_column >= 6 AND original_column < 9 THEN 'Moderate Risk'
    ELSE 'Very High Risk'
  END AS risk_category
FROM
  `indigo-night-397214.earthquakeproject.DepuradoTerremotos`;
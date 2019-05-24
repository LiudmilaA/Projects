SELECT DISTINCT City
FROM Station
WHERE SUBSTR(LOWER(City), 1, 1) IN ('a', 'e', 'i', 'o', 'u');
-- Projet de session
-- «Trouver les facteurs qui ont une influence sur l’utilisation du service BIXI»
-- Code de traitement

-------------------------
-- Chargement des données
-------------------------
-- 1) Tableau avec l’information sur les jours de la semaine 
CREATE TABLE days_of_week 
 	     (data STRING, 
 	      day_index STRING)
 ROW FORMAT DELIMITED
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n'
 STORED AS TEXTFILE
 LOCATION '/user/cloudera/ProjetBIXI/years/';

-- 2) Tableau avec l’information sur chaque cas d’utilisation de service BIXI
CREATE TABLE use_station
 	(id INT,
 	start_date STRING,
	start_station_code INT,
	end_date STRING,
	end_station_code INT,
	duration INT,
	is_member INT)
 ROW FORMAT DELIMITED
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n'
 STORED AS TEXTFILE
 LOCATION '/user/cloudera/ProjetBIXI/general/';

-- 3) Tableau avec l’information météo
 CREATE TABLE weather_conditions
 	(date STRING,
 	year INT,
 	month INT,
 	day INT,
	max_temp DOUBLE,
	min_temp DOUBLE,
	mean_temp DOUBLE,
	rein DOUBLE)
 ROW FORMAT DELIMITED
 FIELDS TERMINATED BY '\t'
 LINES TERMINATED BY '\n'
 STORED AS TEXTFILE
 LOCATION '/user/cloudera/ProjetBIXI/weather/';

-- 4) Tableau avec l’information de géolocalisation des stations
 CREATE TABLE stations
 	(station_code INT,
 	name STRING,
	station_latitude DOUBLE,
	station_longitude DOUBLE)
 ROW FORMAT DELIMITED
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n'
 STORED AS TEXTFILE
 LOCATION '/user/cloudera/ProjetBIXI/stations/';

--------------------------------
-- Création des tables générales
--------------------------------
-- Pour réduire le temps de traitement et quantité de jointure dans chaque requête entre les tables avec les données de sources;
-- Ajouter les colonnes supplémentaires:
--   catégories des températures (diviser les températures possibles en groupes (moins de 15, 15-20, 20-25, 25-30, plus de 30);
--   catégories des parties de la journée (matin, midi, soir, nuit…);
--   ajouter l’indice de pluie (1 - si il y a le pluie, 0 - si il n’y a pas);

CREATE TABLE DW_VELO_RAW AS
SELECT us.start_date AS start_date, 
       us.end_date AS end_date, 
 dow.day_index AS day_index, 
 wc.month AS month, 
 wc.year AS year,
 CASE  WHEN wc.mean_temp < 15 THEN '<15'
       WHEN (wc.mean_temp >= 15 AND wc.mean_temp < 20) THEN '15-20'
       WHEN (wc.mean_temp >= 20 AND wc.mean_temp < 25) THEN '20-25'
       WHEN (wc.mean_temp >= 25 AND wc.mean_temp < 30) THEN '25-30'
       WHEN wc.mean_temp >= 30 THEN '30+'
 END AS temperature_index,
       CASE  WHEN wc.rein = 0 THEN 0
             WHEN wc.rein > 0 THEN 1
       END AS rein_index,
       CASE WHEN SUBSTR(us.start_date, 12, 2) IN ('00', '01', '02', '03', '04', '05', '22', '23') THEN 'night'
            WHEN SUBSTR(us.start_date, 12, 2) = '06' THEN 'early morning'
            WHEN SUBSTR(us.start_date, 12, 2) IN ('07', '08') THEN 'morning'
            WHEN SUBSTR(us.start_date, 12, 2) IN ('09', '10') THEN 'late morning'
            WHEN SUBSTR(us.start_date, 12, 2) IN ('11', '12', '13', '14') THEN 'midday'
            WHEN SUBSTR(us.start_date, 12, 2) = '15' THEN 'early evening'
            WHEN SUBSTR(us.start_date, 12, 2) IN ('16', '17', '18') THEN 'evening'
            WHEN SUBSTR(us.start_date, 12, 2) IN ('19', '20', '21') THEN 'late evening'
        END AS part_of_day,
        us.start_station_code AS start_station_code, 
        st.station_latitude AS start_station_latitude,
        st.station_longitude AS start_station_longitude,
        us.end_station_code AS end_station_code, 
        ss.station_latitude AS end_station_latitude, 
        ss.station_longitude AS end_station_longitude
FROM use_station us
  JOIN days_of_week dow      ON (SUBSTR(us.start_date, 0, 10) = dow.data)
  JOIN weather_conditions wc ON (SUBSTR(us.start_date, 0, 10) = wc.date)
  JOIN stations st           ON (us.start_station_code = st.station_code)
  JOIN stations ss           ON (us.end_station_code = ss.station_code)
WHERE start_station_code is not null;

----------------------------
-- Vérification des facteurs
----------------------------
-- 1) Différence d’utilisation de service entre les mois de chaque année;

CREATE TABLE proportion_month_year AS
WITH use_by_year AS (SELECT year, count(*) AS year_use
                     FROM dw_velo_raw
                     GROUP BY year)
SELECT m.month, m.year, 
       count(*) AS month_use, 
       y.year_use,
       count(*)/y.year_use AS proportion
FROM dw_velo_raw m
   JOIN use_by_year y ON m.year = y.year
GROUP BY m.month, m.year, y.year_use
ORDER BY m.year, m.month;

SELECT month, year, proportion FROM proportion_month_year;
 
-- 2) Différence d’utilisation de service entre les jours de la semaine (fête, jour régulier, fin de la semaine);     

CREATE TABLE dw_velo_count AS
SELECT count(*) AS nbr_by_day, 
       day_index, 
       substr(start_date, 9, 2) as days, 
       month, 
       year,
       temperature_index,
       rein_index,
       part_of_day
FROM dw_velo_raw
GROUP BY day_index, year, month, substr(start_date, 9, 2), 
         temperature_index, rein_index, part_of_day;

WITH aid AS (SELECT sum(nbr_by_day) AS sum_day, year
             FROM dw_velo_count
             GROUP BY year)
SELECT d.day_index, d.year, avg(d.nbr_by_day)/s.sum_day
FROM dw_velo_count d
       JOIN aid s ON d.year = s.year
GROUP BY d.day_index, d.year, s.sum_day;

-- Parc qu’il n’y a pas de grand différence entre les proportions de la quantité de vélo utilisé chaque mois dans la quantité totale annuel (le même chose pour le jour diffèrent), pour diminuer la taille de tableau et le temps d’exécutions des requêtes, on peut faire l’agrégation et utiliser la quantité moyenne pour toutes 4 années

-- 3) Vérification d’influence des conditions météos :
             
SELECT day_index, 
       temperature_index,
       rein_index,
       avg(nbr_by_day)/3830149
FROM dw_velo_count
WHERE temperature_index IS NOT NULL AND rein_index IS NOT NULL
GROUP BY day_index, temperature_index, rein_index;

-- 4)	Vérification d’influence de partie de la journée :

SELECT day_index, 
       part_of_day,
       avg(nbr_by_day)/3830149
FROM dw_velo_count
GROUP BY day_index, part_of_day;

---------------------
-- Exemple de rapport 
---------------------
-- Pour chaque station et la combinaison de facteurs déterminés, telle que  
--      mois: aout;
--      température moyenne de journée: entre 15 et 20 dégrée;
--      heur d’utilisation: 8 heures du matin;
--      pas de pluie
-- on crée une exemple de rapport montrant la quantité moyenne des vélos ( qui sortent et qui retournent);
-- Pour faciliter cette tache on crée les tableaux supplémentaires;

-- 1)	Ajouter 2 colonnes avec l’heur de début et l’heur de fin d’utilisation des vélos :

CREATE TABLE dw_velo_raw_with_time AS
SELECT start_date, 
       CASE   WHEN SUBSTR(start_date, 12, 2) = '00' THEN '00'
              WHEN SUBSTR(start_date, 12, 2) = '01' THEN '01'
              WHEN SUBSTR(start_date, 12, 2) = '02' THEN '02'
              WHEN SUBSTR(start_date, 12, 2) = '03' THEN '03'
              WHEN SUBSTR(start_date, 12, 2) = '04' THEN '04'
              WHEN SUBSTR(start_date, 12, 2) = '05' THEN '05'
              WHEN SUBSTR(start_date, 12, 2) = '06' THEN '06'
              WHEN SUBSTR(start_date, 12, 2) = '07' THEN '07'
              WHEN SUBSTR(start_date, 12, 2) = '08' THEN '08'
              WHEN SUBSTR(start_date, 12, 2) = '09' THEN '09'
              WHEN SUBSTR(start_date, 12, 2) = '10' THEN '10'
              WHEN SUBSTR(start_date, 12, 2) = '11' THEN '11'
              WHEN SUBSTR(start_date, 12, 2) = '12' THEN '12'
              WHEN SUBSTR(start_date, 12, 2) = '13' THEN '13'
              WHEN SUBSTR(start_date, 12, 2) = '14' THEN '14'
              WHEN SUBSTR(start_date, 12, 2) = '15' THEN '15'
              WHEN SUBSTR(start_date, 12, 2) = '16' THEN '16'
              WHEN SUBSTR(start_date, 12, 2) = '17' THEN '17'
              WHEN SUBSTR(start_date, 12, 2) = '18' THEN '18'
              WHEN SUBSTR(start_date, 12, 2) = '19' THEN '19'
              WHEN SUBSTR(start_date, 12, 2) = '20' THEN '20'
              WHEN SUBSTR(start_date, 12, 2) = '21' THEN '21'
              WHEN SUBSTR(start_date, 12, 2) = '22' THEN '22'
              WHEN SUBSTR(start_date, 12, 2) = '23' THEN '23'
       END AS start_hour,
       end_date,
       CASE   WHEN SUBSTR(end_date, 12, 2) = '00' THEN '00'
              WHEN SUBSTR(end_date, 12, 2) = '01' THEN '01'
              WHEN SUBSTR(end_date, 12, 2) = '02' THEN '02'
              WHEN SUBSTR(end_date, 12, 2) = '03' THEN '03'
              WHEN SUBSTR(end_date, 12, 2) = '04' THEN '04'
              WHEN SUBSTR(end_date, 12, 2) = '05' THEN '05'
              WHEN SUBSTR(end_date, 12, 2) = '06' THEN '06'
              WHEN SUBSTR(end_date, 12, 2) = '07' THEN '07'
              WHEN SUBSTR(end_date, 12, 2) = '08' THEN '08'
              WHEN SUBSTR(end_date, 12, 2) = '09' THEN '09'
              WHEN SUBSTR(end_date, 12, 2) = '10' THEN '10'
              WHEN SUBSTR(end_date, 12, 2) = '11' THEN '11'
              WHEN SUBSTR(end_date, 12, 2) = '12' THEN '12'
              WHEN SUBSTR(end_date, 12, 2) = '13' THEN '13'
              WHEN SUBSTR(end_date, 12, 2) = '14' THEN '14'
              WHEN SUBSTR(end_date, 12, 2) = '15' THEN '15'
              WHEN SUBSTR(end_date, 12, 2) = '16' THEN '16'
              WHEN SUBSTR(end_date, 12, 2) = '17' THEN '17'
              WHEN SUBSTR(end_date, 12, 2) = '18' THEN '18'
              WHEN SUBSTR(end_date, 12, 2) = '19' THEN '19'
              WHEN SUBSTR(end_date, 12, 2) = '20' THEN '20'
              WHEN SUBSTR(end_date, 12, 2) = '21' THEN '21'
              WHEN SUBSTR(end_date, 12, 2) = '22' THEN '22'
              WHEN SUBSTR(end_date, 12, 2) = '23' THEN '23'
       END AS end_hour,
       day_index,
       month,
       year,
       temperature_index,
       rein_index,
       part_of_day,
       start_station_code,
       start_station_latitude,
       start_station_longitude,
       end_station_code,
       end_station_latitude,
       end_station_longitude
FROM dw_velo_raw;

-- 2)	Compter la quantité totale des vélos prises chaque heure de chaque jour

CREATE TABLE count_velo_take AS
SELECT start_station_code,
       start_station_latitude,
       start_station_longitude,
       count(start_date) AS nmbr_velo_takes,
       start_hour,
       part_of_day,
       temperature_index,
       rein_index,
       day_index,
       month,
       year,
       SUBSTR(start_date, 9, 2) AS day,
       SUBSTR(start_date, 1, 13) AS time_index
FROM dw_velo_raw_with_time
GROUP BY start_station_code, start_station_latitude, day_index,
         start_station_longitude, part_of_day, rein_index,
         temperature_index, month, year, start_hour, 
         SUBSTR(start_date, 9, 2),
         SUBSTR(start_date, 1, 13);

-- 3)	Compter la quantité totale des vélos retournés à chaque heure de chaque jour 

CREATE TABLE count_velo_put AS
SELECT end_station_code,
       end_station_latitude,
       end_station_longitude,
       count(end_date) AS nmbr_velo_put,
       end_hour,
       part_of_day,
       temperature_index,
       rein_index,
       day_index,
       month,
       year,
       SUBSTR(end_date, 9, 2) AS day,
       SUBSTR(end_date, 1, 13) AS time_index
FROM dw_velo_raw_with_time
GROUP BY end_station_code, end_station_latitude, day_index,
         end_station_longitude, part_of_day, rein_index,
         temperature_index, month, year, end_hour, SUBSTR(end_date, 9, 2),
         SUBSTR(end_date, 1, 13);

-- 4)	Compter la quantité moyenne des vélos prises et des vélos retournés, ajouter le colonne avec la combinaison des facteurs possibles (pour faire ensuit la jointure entre l’information sur les vélos qui sortent er qui retournent)
       
CREATE TABLE count_velo_take_avg AS
SELECT start_station_code,
       start_station_latitude,
       start_station_longitude,
       AVG(nmbr_velo_takes) AS avg_nbr_velo_take,
       month,
       day_index,
       start_hour,
       temperature_index,
       rein_index,
       CONCAT(month, CONCAT(day_index, CONCAT(start_hour, CONCAT(temperature_index, CONCAT(rein_index, ''))))) AS conditions
FROM count_velo_take
GROUP BY start_station_code, start_station_latitude,
         start_station_longitude, month, day_index,
         start_hour, temperature_index, rein_index,
         CONCAT(month, CONCAT(day_index, CONCAT(start_hour, CONCAT(temperature_index, CONCAT(rein_index, '')))));
         
CREATE TABLE count_velo_put_avg AS
SELECT end_station_code,
       end_station_latitude,
       end_station_longitude,
       AVG(nmbr_velo_put) AS avg_nbr_velo_put,
       month,
       day_index,
       end_hour,
       temperature_index,
       rein_index,
       CONCAT(month, CONCAT(day_index, CONCAT(end_hour, CONCAT(temperature_index, CONCAT(rein_index, ''))))) AS conditions
FROM count_velo_put
GROUP BY end_station_code, end_station_latitude,
         end_station_longitude, month, day_index,
         end_hour, temperature_index, rein_index,
         CONCAT(month, CONCAT(day_index, CONCAT(end_hour, CONCAT(temperature_index, CONCAT(rein_index, '')))));

-- 5)	Création de rapport final
      
SELECT distinct take.start_station_code,
       take.start_station_latitude,
       take.start_station_longitude,
       take.avg_nbr_velo_take,
       put.avg_nbr_velo_put
FROM count_velo_put_avg put JOIN count_velo_take_avg take 
      ON put.conditions = take.conditions
      AND put.end_station_code = take.start_station_code
WHERE take.month = 8 AND take.day_index = 'week' AND
      take.start_hour = '08' AND take.temperature_index = '15-20' AND
      take.rein_index = 0;

 

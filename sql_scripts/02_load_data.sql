USE env_health;

-- 1. Desactivar claves foráneas para evitar errores de integridad durante la carga masiva
SET FOREIGN_KEY_CHECKS = 0;

-- 2. Cargar water_disease_chemicals
LOAD DATA LOCAL INFILE 'C:/Users/fotos/Desktop/Ironhack/Final_project/Final_project/data/cleam/df_water_disease_chemicals.csv'
INTO TABLE water_disease_chemicals
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(countryname, reportingyear, eprtr_sectorname, facilityname, city, longitude, latitude, targetrelease, pollutant, releases, nuts_id, cntr_code, nuts_name, iso3_code);

-- 3. Cargar respiratory_emissions
LOAD DATA LOCAL INFILE 'C:/Users/fotos/Desktop/Ironhack/Final_project/Final_project/data/cleam/df_respiratory_emissions_clean.csv'
INTO TABLE respiratory_emissions
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(countryname, reportingyear, eprtr_sectorname, facilityname, city, longitude, latitude, targetrelease, pollutant, releases, nuts_id, cntr_code, nuts_name, iso3_code);

-- 4. Cargar water_nuts
LOAD DATA LOCAL INFILE 'C:/Users/fotos/Desktop/Ironhack/Final_project/Final_project/data/cleam/water_nuts_clean.csv'
INTO TABLE water_nuts
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(countryname, reportingyear, eprtr_sectorname, facilityname, city, longitude, latitude, targetrelease, pollutant, releases, nuts_id, cntr_code, nuts_name, iso3_code);

-- 5. Cargar air_nuts
LOAD DATA LOCAL INFILE 'C:/Users/fotos/Desktop/Ironhack/Final_project/Final_project/data/cleam/air_nuts_clean.csv'
INTO TABLE air_nuts
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(countryname, reportingyear, eprtr_sectorname, facilityname, city, longitude, latitude, targetrelease, pollutant, releases, nuts_id, cntr_code, nuts_name, iso3_code);

-- 6. Cargar life_expectancy
LOAD DATA LOCAL INFILE 'C:/Users/fotos/Desktop/Ironhack/Final_project/Final_project/data/cleam/df_life_exp_nuts2_long_clean.csv'
INTO TABLE life_expectancy
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(freq, unit, sex, age, geo_time_period, year, life_expectancy);

-- 7. Cargar mortality
LOAD DATA LOCAL INFILE 'C:/Users/fotos/Desktop/Ironhack/Final_project/Final_project/data/cleam/df_mortality_nuts2_long.csv'
INTO TABLE mortality
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(freq, unit, sex, age, icd10, geo_time_period, year, mortality_rate);

-- 8. Poblar la tabla puente (nuts_regions)
INSERT IGNORE INTO nuts_regions (nuts_id, nuts_name, cntr_code, iso3_code, country_name)
SELECT DISTINCT nuts_id, nuts_name, cntr_code, iso3_code, countryname
FROM (
    SELECT nuts_id, nuts_name, cntr_code, iso3_code, countryname FROM water_disease_chemicals WHERE nuts_id IS NOT NULL
    UNION
    SELECT nuts_id, nuts_name, cntr_code, iso3_code, countryname FROM respiratory_emissions WHERE nuts_id IS NOT NULL
    UNION
    SELECT nuts_id, nuts_name, cntr_code, iso3_code, countryname FROM water_nuts WHERE nuts_id IS NOT NULL
    UNION
    SELECT nuts_id, nuts_name, cntr_code, iso3_code, countryname FROM air_nuts WHERE nuts_id IS NOT NULL
) AS combined;

-- 9. Volver a activar las claves foráneas
SET FOREIGN_KEY_CHECKS = 1;
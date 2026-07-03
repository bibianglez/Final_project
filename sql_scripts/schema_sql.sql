-- ============================================================
-- Schema for environmental & health data (EU NUTS2-level)
-- Corrected & Optimized Version
-- ============================================================

CREATE DATABASE IF NOT EXISTS env_health
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE env_health;

-- ------------------------------------------------------------
-- 1. water_disease_chemicals
-- ------------------------------------------------------------
DROP TABLE IF EXISTS water_disease_chemicals;
CREATE TABLE water_disease_chemicals (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    countryname       VARCHAR(100)    NOT NULL,
    reportingyear     SMALLINT        NOT NULL,
    eprtr_sectorname  VARCHAR(150)    NOT NULL,
    facilityname      VARCHAR(255)    NOT NULL,
    city              VARCHAR(255)    NOT NULL,
    longitude         DOUBLE          NULL,
    latitude          DOUBLE          NULL,
    targetrelease     VARCHAR(10)     NOT NULL,
    pollutant         VARCHAR(150)    NOT NULL,
    releases          BIGINT          NOT NULL,
    nuts_id           VARCHAR(10)     NULL,
    cntr_code         VARCHAR(5)      NULL,
    nuts_name         VARCHAR(150)    NULL,
    iso3_code         VARCHAR(5)      NULL,
    INDEX idx_wdc_nuts (nuts_id),
    INDEX idx_wdc_year (reportingyear),
    INDEX idx_wdc_pollutant (pollutant),
    INDEX idx_wdc_country (countryname)
) ENGINE=InnoDB CHARACTER SET utf8mb4;

-- ------------------------------------------------------------
-- 2. respiratory_emissions
-- ------------------------------------------------------------
DROP TABLE IF EXISTS respiratory_emissions;
CREATE TABLE respiratory_emissions (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    countryname       VARCHAR(100)    NOT NULL,
    reportingyear     SMALLINT        NOT NULL,
    eprtr_sectorname  VARCHAR(150)    NOT NULL,
    facilityname      VARCHAR(255)    NOT NULL,
    city              VARCHAR(255)    NOT NULL,
    longitude         DOUBLE          NULL,
    latitude          DOUBLE          NULL,
    targetrelease     VARCHAR(10)     NOT NULL,
    pollutant         VARCHAR(150)    NOT NULL,
    releases          BIGINT          NOT NULL,
    nuts_id           VARCHAR(10)     NULL,
    cntr_code         VARCHAR(5)      NULL,
    nuts_name         VARCHAR(150)    NULL,
    iso3_code         VARCHAR(5)      NULL,
    INDEX idx_re_nuts (nuts_id),
    INDEX idx_re_year (reportingyear),
    INDEX idx_re_pollutant (pollutant),
    INDEX idx_re_country (countryname)
) ENGINE=InnoDB CHARACTER SET utf8mb4;

-- ------------------------------------------------------------
-- 3. water_nuts
-- ------------------------------------------------------------
DROP TABLE IF EXISTS water_nuts;
CREATE TABLE water_nuts (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    countryname       VARCHAR(100)    NOT NULL,
    reportingyear     SMALLINT        NOT NULL,
    eprtr_sectorname  VARCHAR(150)    NOT NULL,
    facilityname      VARCHAR(255)    NOT NULL,
    city              VARCHAR(255)    NOT NULL,
    longitude         DOUBLE          NULL,
    latitude          DOUBLE          NULL,
    targetrelease     VARCHAR(10)     NOT NULL,
    pollutant         VARCHAR(150)    NOT NULL,
    releases          BIGINT          NOT NULL,
    nuts_id           VARCHAR(10)     NULL,
    cntr_code         VARCHAR(5)      NULL,
    nuts_name         VARCHAR(150)    NULL,
    iso3_code         VARCHAR(5)      NULL,
    INDEX idx_wn_nuts (nuts_id),
    INDEX idx_wn_year (reportingyear),
    INDEX idx_wn_pollutant (pollutant),
    INDEX idx_wn_country (countryname)
) ENGINE=InnoDB CHARACTER SET utf8mb4;

-- ------------------------------------------------------------
-- 4. air_nuts
-- ------------------------------------------------------------
DROP TABLE IF EXISTS air_nuts;
CREATE TABLE air_nuts (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    countryname       VARCHAR(100)    NOT NULL,
    reportingyear     SMALLINT        NOT NULL,
    eprtr_sectorname  VARCHAR(150)    NOT NULL,
    facilityname      VARCHAR(255)    NOT NULL,
    city              VARCHAR(255)    NOT NULL,
    longitude         DOUBLE          NULL,
    latitude          DOUBLE          NULL,
    targetrelease     VARCHAR(10)     NOT NULL,
    pollutant         VARCHAR(150)    NOT NULL,
    releases          BIGINT          NOT NULL,
    nuts_id           VARCHAR(10)     NULL,
    cntr_code         VARCHAR(5)      NULL,
    nuts_name         VARCHAR(150)    NULL,
    iso3_code         VARCHAR(5)      NULL,
    INDEX idx_an_nuts (nuts_id),
    INDEX idx_an_year (reportingyear),
    INDEX idx_an_pollutant (pollutant),
    INDEX idx_an_country (countryname)
) ENGINE=InnoDB CHARACTER SET utf8mb4;

-- ------------------------------------------------------------
-- 5. life_expectancy
-- ------------------------------------------------------------
DROP TABLE IF EXISTS life_expectancy;
CREATE TABLE life_expectancy (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    freq              CHAR(1)         NOT NULL,
    unit              VARCHAR(5)      NOT NULL,
    sex               CHAR(1)         NOT NULL,
    age               VARCHAR(10)     NOT NULL,
    geo_time_period   VARCHAR(10)     NOT NULL,
    year              SMALLINT        NOT NULL,
    life_expectancy   DECIMAL(4,1)    NULL,
    INDEX idx_le_geo (geo_time_period),
    INDEX idx_le_year (year),
    INDEX idx_le_sex_age (sex, age)
) ENGINE=InnoDB CHARACTER SET utf8mb4;

-- ------------------------------------------------------------
-- 6. mortality
-- ------------------------------------------------------------
DROP TABLE IF EXISTS mortality;
CREATE TABLE mortality (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    freq              CHAR(1)         NOT NULL,
    unit              VARCHAR(5)      NOT NULL,
    sex               CHAR(1)         NOT NULL,
    age               VARCHAR(10)     NOT NULL,
    icd10             VARCHAR(20)     NOT NULL,
    geo_time_period   VARCHAR(10)     NOT NULL,
    year              SMALLINT        NOT NULL,
    mortality_rate    DECIMAL(8,2)    NULL,
    INDEX idx_mo_geo (geo_time_period),
    INDEX idx_mo_year (year),
    INDEX idx_mo_icd10 (icd10),
    INDEX idx_mo_sex_age (sex, age)
) ENGINE=InnoDB CHARACTER SET utf8mb4;

-- ------------------------------------------------------------
-- 7. Bridge Table: nuts_regions
-- ------------------------------------------------------------
DROP TABLE IF EXISTS nuts_regions;
CREATE TABLE nuts_regions (
    nuts_id      VARCHAR(10) PRIMARY KEY,
    nuts_name    VARCHAR(150),
    cntr_code    VARCHAR(5),
    iso3_code    VARCHAR(5),
    country_name VARCHAR(100)
) ENGINE=InnoDB CHARACTER SET utf8mb4;

-- CORREGIDO: Mapeo correcto de 'countryname' (origen) a 'country_name' (destino)
-- CORREGIDO: Se añade WHERE nuts_id IS NOT NULL para evitar violar la PK de nuts_regions
INSERT INTO nuts_regions (nuts_id, nuts_name, cntr_code, iso3_code, country_name)
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

-- ------------------------------------------------------------
-- 8. Relations (Foreign Keys)
-- Nota: Asegúrate de poblar las tablas base ANTES de ejecutar los ALTER si decides usarlas físicamente.
-- ------------------------------------------------------------
ALTER TABLE water_disease_chemicals
    ADD CONSTRAINT fk_wdc_region FOREIGN KEY (nuts_id) REFERENCES nuts_regions(nuts_id);

ALTER TABLE respiratory_emissions
    ADD CONSTRAINT fk_resp_region FOREIGN KEY (nuts_id) REFERENCES nuts_regions(nuts_id);

ALTER TABLE water_nuts
    ADD CONSTRAINT fk_waternuts_region FOREIGN KEY (nuts_id) REFERENCES nuts_regions(nuts_id);

ALTER TABLE air_nuts
    ADD CONSTRAINT fk_airnuts_region FOREIGN KEY (nuts_id) REFERENCES nuts_regions(nuts_id);

ALTER TABLE mortality
    ADD CONSTRAINT fk_mortality_region FOREIGN KEY (geo_time_period) REFERENCES nuts_regions(nuts_id);

ALTER TABLE life_expectancy
    ADD CONSTRAINT fk_life_exp_region FOREIGN KEY (geo_time_period) REFERENCES nuts_regions(nuts_id);
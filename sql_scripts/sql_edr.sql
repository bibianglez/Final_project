-- 1. Estructura del Sitio de Producción
CREATE TABLE ProductionSite (
    site_id VARCHAR(50) PRIMARY KEY,
    site_inspire_id VARCHAR(100) UNIQUE,
    production_site_threshold_scheme VARCHAR(100),
    point_geometry VARCHAR(100),
    name_of_feature VARCHAR(255)
);

-- 2. Complejo / Instalación Principal
CREATE TABLE ProductionFacility (
    facility_id VARCHAR(50) PRIMARY KEY,
    facility_inspire_id VARCHAR(100) UNIQUE,
    parent_site_id VARCHAR(50),
    facility_name VARCHAR(255),
    street_name VARCHAR(255),
    building_number VARCHAR(50),
    city VARCHAR(100),
    postal_code VARCHAR(50),
    country_code VARCHAR(10),
    main_activity_code VARCHAR(50),
    FOREIGN KEY (parent_site_id) REFERENCES ProductionSite(site_id)
);

-- Detalles Anuales de la Instalación
CREATE TABLE ProductionFacilityDetails (
    facility_detail_id VARCHAR(50) PRIMARY KEY,
    facility_id VARCHAR(50),
    reporting_year INT,
    status VARCHAR(50),
    remarks TEXT,
    number_of_operating_hours INT,
    number_of_employees INT,
    FOREIGN KEY (facility_id) REFERENCES ProductionFacility(facility_id)
);

-- Autoridad Competente de Control (E-PRTR)
CREATE TABLE CompetentAuthorityEPRTR (
    authority_id VARCHAR(50) PRIMARY KEY,
    facility_id VARCHAR(50),
    organisation_name VARCHAR(255),
    street_name VARCHAR(255),
    building_number VARCHAR(50),
    city VARCHAR(100),
    postal_code VARCHAR(50),
    country_code VARCHAR(10),
    FOREIGN KEY (facility_id) REFERENCES ProductionFacility(facility_id)
);

-- 3. Emisiones y Transferencias (Pollutants & Waste)
CREATE TABLE PollutantRelease (
    pollutant_release_id VARCHAR(50) PRIMARY KEY,
    facility_id VARCHAR(50),
    reporting_year INT,
    pollutant_code VARCHAR(50),
    medium VARCHAR(50), -- Air, Water, Land
    total_pollutant_quantity DECIMAL(18,4),
    accidental_pollutant_quantity DECIMAL(18,4),
    FOREIGN KEY (facility_id) REFERENCES ProductionFacility(facility_id)
);

CREATE TABLE PollutantRelease_MethodClassification (
    method_id VARCHAR(50) PRIMARY KEY,
    pollutant_release_id VARCHAR(50),
    method_classification_code VARCHAR(50),
    method_basis_code VARCHAR(50),
    further_details TEXT,
    FOREIGN KEY (pollutant_release_id) REFERENCES PollutantRelease(pollutant_release_id)
);

CREATE TABLE OffsitePollutantTransfer (
    transfer_id VARCHAR(50) PRIMARY KEY,
    facility_id VARCHAR(50),
    reporting_year INT,
    pollutant_code VARCHAR(50),
    total_pollutant_quantity DECIMAL(18,4),
    FOREIGN KEY (facility_id) REFERENCES ProductionFacility(facility_id)
);

CREATE TABLE OffsitePollutantTransfer_MethodClassification (
    method_id VARCHAR(50) PRIMARY KEY,
    transfer_id VARCHAR(50),
    method_classification_code VARCHAR(50),
    method_basis_code VARCHAR(50),
    further_details TEXT,
    FOREIGN KEY (transfer_id) REFERENCES OffsitePollutantTransfer(transfer_id)
);

CREATE TABLE OffsiteWasteTransfer (
    waste_transfer_id VARCHAR(50) PRIMARY KEY,
    facility_id VARCHAR(50),
    reporting_year INT,
    waste_classification_code VARCHAR(50),
    waste_quantity DECIMAL(18,4),
    waste_treatment_code VARCHAR(50),
    FOREIGN KEY (facility_id) REFERENCES ProductionFacility(facility_id)
);

CREATE TABLE OffsiteWasteTransfer_MethodClassification (
    method_id VARCHAR(50) PRIMARY KEY,
    waste_transfer_id VARCHAR(50),
    method_classification_code VARCHAR(50),
    method_basis_code VARCHAR(50),
    further_details TEXT,
    FOREIGN KEY (waste_transfer_id) REFERENCES OffsiteWasteTransfer(waste_transfer_id)
);

-- 4. Sub-Instalaciones Específicas e Informes Técnicos (BAT, ETS)
CREATE TABLE ProductionInstallation (
    installation_id VARCHAR(50) PRIMARY KEY,
    installation_inspire_id VARCHAR(100) UNIQUE,
    parent_facility_id VARCHAR(50),
    installation_name VARCHAR(255),
    status VARCHAR(50),
    FOREIGN KEY (parent_facility_id) REFERENCES ProductionFacility(facility_id)
);

CREATE TABLE ProductionInstallationDetails (
    installation_detail_id VARCHAR(50) PRIMARY KEY,
    installation_id VARCHAR(50),
    reporting_year INT,
    status VARCHAR(50),
    remarks TEXT,
    FOREIGN KEY (installation_id) REFERENCES ProductionInstallation(installation_id)
);

CREATE TABLE PermitDetails (
    permit_id VARCHAR(50) PRIMARY KEY,
    installation_id VARCHAR(50),
    reporting_year INT,
    permit_granted_date DATE,
    permit_last_updated_date DATE,
    FOREIGN KEY (installation_id) REFERENCES ProductionInstallation(installation_id)
);

CREATE TABLE BATDerogations (
    derogation_id VARCHAR(50) PRIMARY KEY,
    installation_id VARCHAR(50),
    reporting_year INT,
    bat_conclusion_id VARCHAR(50),
    justification TEXT,
    FOREIGN KEY (installation_id) REFERENCES ProductionInstallation(installation_id)
);

CREATE TABLE ETSInformation (
    ets_id VARCHAR(50) PRIMARY KEY,
    installation_id VARCHAR(50),
    reporting_year INT,
    ets_identifier VARCHAR(100),
    FOREIGN KEY (installation_id) REFERENCES ProductionInstallation(installation_id)
);

-- 5. Partes de la Instalación (Nivel inferior del esquema)
CREATE TABLE ProductionInstallationPart (
    part_id VARCHAR(50) PRIMARY KEY,
    part_inspire_id VARCHAR(100) UNIQUE,
    parent_installation_id VARCHAR(50),
    part_name VARCHAR(255),
    status VARCHAR(50),
    FOREIGN KEY (parent_installation_id) REFERENCES ProductionInstallation(installation_id)
);

CREATE TABLE ProductionInstallationPartDetails (
    part_detail_id VARCHAR(50) PRIMARY KEY,
    part_id VARCHAR(50),
    reporting_year INT,
    status VARCHAR(50),
    FOREIGN KEY (part_id) REFERENCES ProductionInstallationPart(part_id)
);

CREATE TABLE EmissionsToAir (
    emission_id VARCHAR(50) PRIMARY KEY,
    part_id VARCHAR(50),
    reporting_year INT,
    pollutant_code VARCHAR(50),
    total_quantity DECIMAL(18,4),
    FOREIGN KEY (part_id) REFERENCES ProductionInstallationPart(part_id)
);
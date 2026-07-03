# Industrial Pollution and Regional Health in Europe

## Overview

This project looks at whether there is a relationship between industrial pollution and public health across Europe. Facility-, sector- and national-level air and water pollutant release data reported to the **European Environment Agency (EEA)** is cleaned, standardised and geocoded to **NUTS 2** statistical regions, so that it can eventually be compared against **Eurostat's** regional life expectancy and cause-of-death statistics.

The analysis draws on 32 European countries (the EU Member States plus EEA/EFTA and candidate countries such as the UK, Switzerland, Norway and Serbia) and spans reporting years from 2007 to 2024, depending on the table.

## Data sources

| Theme | Provider | Dataset | Link |
|---|---|---|---|
| Industrial air & water pollutant releases (facility, sector and national level) | European Environment Agency (EEA) | Industrial Reporting under the Industrial Emissions Directive 2010/75/EU and the E-PRTR Regulation (EC) No 166/2006 | https://www.eea.europa.eu/en/datahub/datahubitem-view/9405f714-8015-4b5b-a63c-280b82861b3d |
| NUTS 2 region boundaries (used for the spatial join) | Eurostat / GISCO | NUTS 2024, 1:10 million | https://gisco-services.ec.europa.eu/distribution/v2/nuts/geojson/NUTS_RG_10M_2024_4326.geojson |
| Life expectancy | Eurostat | Life expectancy by age, sex and NUTS 2 region — `demo_r_mlifexp` | https://ec.europa.eu/eurostat/databrowser/product/view/demo_r_mlifexp |
| Mortality / causes of death | Eurostat | Causes of death — standardised death rate by NUTS 2 region of residence — `hlth_cd_asdr2` | https://ec.europa.eu/eurostat/databrowser/product/view/hlth_cd_asdr2 |

The two Eurostat tables are pulled directly through the `eurostat` Python package (`eurostat.get_data_df()`) rather than downloaded by hand, so they can be refreshed at any point by simply re-running the notebook.

## What is NUTS?

**NUTS** (*Nomenclature of Territorial Units for Statistics*) is the EU's official system for dividing the territory of Member States — plus candidate and EFTA countries — into regions for statistical and socio-economic comparison. It has three main levels:

- **NUTS 1** – broad socio-economic regions
- **NUTS 2** – "basic regions" used for most EU regional policy and statistics (typically 800,000–3,000,000 inhabitants)
- **NUTS 3** – small, more local regions

This project standardises everything to **NUTS 2**, since that is the level at which Eurostat already publishes its regional health statistics. The EEA pollution data, which only comes with facility coordinates, is geocoded to the correct NUTS 2 region using a coordinate-based spatial join.

## Notebook workflow

The notebooks reflect how the project actually evolved, each one building on the last:

**1. `Final_project_work.ipynb` — first exploration**
The starting point. Every raw EEA file that looked potentially useful was opened here — air and water releases at facility, national and sector level, IED installations, large combustion plant emissions, waste transfers, and a large industrial-sites geodataframe (854,730 records) — mainly to check shapes, column types and country coverage, and to decide which tables were actually worth carrying forward. In the end, only the air/water release tables (facility, national and sector) went on to the next stage.

**2. `cleaning_and_combining_testing.ipynb` — first cleaning pass**
The first real attempt at cleaning: dropping the `PublicationDate` column, standardising column names to `snake_case`, and testing `dropna()` on each table. This is very much a "testing" notebook — see the note below about one cleaning step that didn't quite work as intended here.

**3. `cleaning_combining_NUTS.ipynb` — cleaner pipeline + NUTS 2 classification**
A more careful rebuild of the cleaning above (see *Key insights* for what changed), plus the addition of the NUTS 2 layer: facility coordinates are converted to points and spatially joined against the official NUTS 2 boundaries, giving every facility a `nuts_id`, region name and country code so it can later be linked to regional health data.

**4. `Life_expectancy.ipynb` and `sickness_notebook.ipynb` — Eurostat health data**
Rather than being derived from the EEA files, these two are pulled straight from Eurostat: life expectancy by age, sex and region, and standardised mortality by cause of death (ICD-10), sex and region. Both are filtered down to NUTS 2-level rows only and cleaned so they line up with the pollution tables above.

**5. `Final_project_final_version` — bringing it all together** 
The final stage combines the cleaned, NUTS 2-tagged pollution tables with the life expectancy and mortality tables and sets out the project's conclusions. As this notebook wasn't among the files shared, the description here is based on your summary rather than a review of the code — Graphical analysis included.

## Key insights

A few things stood out while going through the notebooks:

- **Notebook 1 did its job as a filter.** Of the seven-plus raw EEA tables opened in `Final_project_work.ipynb` (including IED installations, LCP emissions and waste transfers), only the six air/water release tables were actually taken into the cleaning pipeline — confirming its role as a scoping exercise rather than a cleaning step.
- **The cleaning approach was genuinely improved between notebooks 2 and 3.** In `cleaning_and_combining_testing.ipynb`, `dropna()` is run while the near-empty `addressConfidentialityReason` and `confidentialityReason` columns are still in the table (over 99% missing), which wipes the air- and water-facilities tables to **0 rows**. `cleaning_combining_NUTS.ipynb` fixes this by dropping those columns first, keeping **366,206** of 372,206 air-facility rows and **251,384** water-facility rows with zero missing values afterwards.
- **The NUTS 2 join worked for the large majority of facilities.** Of the 366,206 cleaned air-release facilities, **321,861 (~88%)** matched a NUTS 2 region; the remaining ~44,300 didn't match, likely due to coordinates falling outside mapped NUTS boundaries or coordinate errors — worth a closer look before final analysis.
- **Facility-level detail comes at the cost of completeness**, while the national/sector summaries are the opposite: the national and sector air/water tables (13,639 and 32,227 rows respectively) had no missing values at all once cleaned, whereas the facility-level tables needed real cleaning work to get there — a classic granularity-vs-completeness trade-off.
- **Regional mortality data is noticeably patchier than regional life expectancy data.** After filtering to NUTS 2-level rows, the mortality table dropped from 276,177 to 172,335 rows (about 38% lost to missing values) — likely small-number suppression for rarer causes of death in smaller regions — while the life expectancy table's main data loss came from deliberately excluding pre-2010 years, not from missingness.
- **Pollutants roll up into a handful of families** (Greenhouse gases, Heavy metals, Inorganic substances, Chlorinated organic substances, Other organic substances, Other gases), which could be a cleaner way to compare pollution "types" against health outcomes than working with the 90-odd individual E-PRTR substances directly.
- **Most registered industrial sites report no measurable pollutant releases.** In the broader 854,730-facility layer explored in notebook 1, only 242,066 (28%) had any pollutant listed — a reminder that "no release recorded" usually means "below the E-PRTR reporting threshold," not "no pollution."


# 🎯 Relevant Codes for Air & Water Pollution

## Pollutants

# 🌍 Environmental Pollutants & Health Impacts Summary

## 🌬️ Air Pollutants (Respiratory Impacts)
These chemicals are directly linked to respiratory diseases (ICD-10: J40-J47) such as asthma and COPD, as well as lung cancer (ICD-10: C33-C34).

### 🚨 Level 1: The Major Culprits (Criteria Pollutants)
The primary drivers of widespread respiratory illnesses and lung inflammation.
* **Fine particulate matter (PM2.5):** Deeply penetrates lungs and enters the bloodstream.
* **Particulate matter (PM10):** Irritates airways, exacerbating asthma and bronchitis.
* **Nitrogen oxides (NOX):** Severely inflames airways and reduces lung function.
* **Sulphur oxides (SOX):** Causes bronchoconstriction; highly irritating for asthmatics.

### ☠️ Level 2: Pulmonary Toxics & Carcinogens
Continuous inhalation is directly linked to lung cancer and pulmonary fibrosis.
* **Asbestos:** Direct cause of asbestosis and mesothelioma.
* **Heavy Metals (Inhaled):** `Cadmium (Cd)`, `Chromium (Cr)` (especially hexavalent), `Nickel (Ni)`, and `Arsenic (As)` are potent pulmonary carcinogens.
* **Combustion Byproducts:** `Polycyclic aromatic hydrocarbons (PAHs)`, `Benzo(g,h,i)perylene`, `Fluoranthene`, and `Anthracene`. 

### 🧪 Level 3: Severe Respiratory Irritants (Gases & Acids)
Cause acute chemical burns, severe cough, and pulmonary edema if inhaled.
* **Corrosive Gases:** `Ammonia (NH3)`, `Chlorine (HCl)`, `Fluorine (HF)`, and `Ethylene oxide`.

### ⛽ Level 4: Volatile Organic Compounds (VOCs)
Evaporate at room temperature, irritating the throat/lungs and contributing to harmful tropospheric ozone.
* **General VOCs:** `Non-methane volatile organic compounds (NMVOC)`.
* **Specific Irritants/Carcinogens:** `Benzene` (leukemia risk), `Toluene`, `Xylenes`, `Ethyl benzene`, and `Vinyl chloride`.

---

## 💧 Water Pollutants (Cancer, Organ & Systemic Impacts)
Exposure through contaminated drinking water or bioaccumulation (e.g., eating fish). Strongly linked to liver diseases (ICD-10: K), kidney failure (ICD-10: N), nervous system damage, and various cancers (ICD-10: C).

### ☠️ Level 1: Heavy Metals (Highly Carcinogenic & Nephrotoxic)
Accumulate in the body over years, aggressively destroying kidneys and the liver.
* **Arsenic (As):** Major cause of skin, bladder, and lung cancer via groundwater.
* **Mercury (Hg):** Severe neurotoxin that bioaccumulates in aquatic life.
* **Lead (Pb):** Causes acute renal damage and irreversible neurological harm.
* **Cadmium (Cd), Chromium (Cr), Nickel (Ni):** Highly toxic to kidneys and confirmed systemic carcinogens.

### ☣️ Level 2: Persistent Organic Pollutants (POPs) & Dioxins
"Forever chemicals" that accumulate in human fat tissue, causing cancer and immune failure.
* **The Most Toxic:** `PCDD + PCDF (dioxins + furans) (as Teq)`.
* **Industrial & Combustion:** `Polychlorinated biphenyls (PCBs)`, `Polycyclic aromatic hydrocarbons (PAHs)`.
* **Fungicides/Flame Retardants:** `Hexachlorobenzene (HCB)`, `Pentachlorophenol (PCP)`, `Brominated diphenylethers (PBDE)`.

### 🌾 Level 3: Severe Pesticides, Insecticides & Herbicides
Agricultural runoff chemicals acting as potent endocrine disruptors and neurotoxins.
* **Banned/Legacy Organochlorines:** `DDT`, `Lindane`, `Aldrin`, `Dieldrin`, `Endrin`, `Chlordane`, `Heptachlor`, `Toxaphene`, `Mirex`, `Chlordecone`, `Isodrin`.
* **Modern but Toxic:** `Chlorpyrifos`, `Atrazine`, `Alachlor`, `Simazine`, `Diuron`.

### 🏭 Level 4: Industrial Compounds, Solvents & Plastics
Direct factory discharges linked to leukemia, fertility issues, and organ damage.
* **Carcinogens:** `Benzene`, `Vinyl chloride`.
* **Endocrine Disruptors (Plastics/Surfactants):** `Di-(2-ethyl hexyl) phthalate (DEHP)`, `Nonylphenol and Nonylphenol ethoxylates`.
* **Lethal Toxins:** `Cyanides (as total CN)`, `Hydrogen cyanide (HCN)`.
* **Industrial Solvents:** `Trichloroethylene (TRI)`, `Tetrachloroethylene`, `Dichloromethane (DCM)`.


### 🌬️ Air Pollution Related Codes
These codes are highly linked to particulate matter ($PM_{2.5}$, $PM_{10}$), nitrogen dioxide ($NO_2$), ozone ($O_3$), and industrial emissions.

* **`C33_C34`**: Malignant neoplasms of trachea, bronchus, and lung (Lung cancer strongly tied to air quality).
* **`I`**: Diseases of the circulatory system (Broad category; air pollution is a major driver of cardiovascular mortality).
    * **`I20-I25`** / **`I20_I23-I25`**: Ischemic heart diseases.
    * **`I21_I22`**: Acute myocardial infarction (Heart attacks triggered by acute pollution spikes).
    * **`I60-I69`**: Cerebrovascular diseases (Stroke risks increase with heavy air pollution).
* **`J`**: Diseases of the respiratory system (The most directly impacted system).
    * **`J40-Y44_J47`** / **`J40-Subject_47`**: Chronic lower respiratory diseases (COPD, emphysema).
    * **`J45_J46`**: Asthma and status asthmaticus (Exacerbated heavily by poor air quality).

---

### 💧 Water Pollution & Environmental Toxins Related
These codes relate to waterborne pathogens, heavy metals (lead, arsenic, cadmium), chemical runoff, or direct accidental ingestion of toxins.

* **`A_B`**: Certain infectious and parasitic diseases (Includes waterborne diarrheal diseases, cholera, and gastrointestinal infections).
* **`B15-B19_B942`**: Viral hepatitis (Hepatitis A and E are primarily transmitted through contaminated water).
* **`N00-N29`**: Diseases of the genitourinary system / Renal failure (Kidneys are highly sensitive to heavy metals like lead, cadmium, and mercury found in polluted water).
* **`TOXIC`**: Toxicological effects / Poisoning.
* **`X40-X49`**: Accidental poisoning by and exposure to noxious substances (Includes pesticide runoff or chemical spills in water resources).


## Tech stack

- `pandas`, `numpy` — data cleaning and reshaping
- `geopandas`, `shapely` — spatial join to NUTS 2 boundaries
- `eurostat` — pulling Eurostat tables directly via their API
- `PyYAML` — reading local file paths from `config.yaml`


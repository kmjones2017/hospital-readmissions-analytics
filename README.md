# Hospital Readmissions & Social Vulnerability Analytics

## Project Overview

This project analyzes hospital readmission performance alongside county-level social vulnerability indicators using public CMS HRRP, CMS Hospital General Information, CDC/ATSDR SVI, and FIPS reference data.

The goal is to explore how community-level social vulnerability indicators relate to hospital readmission outcomes and to identify patterns across hospitals, conditions, and geographic regions. 

### Business Questions

- How do poverty, insurance coverage, and community vulnerability relate to readmission performance?
- Which hospitals consistently perform better or worse than expected?
- Which conditions exhibit the greatest variation in readmission outcomes?
- Do hospitals in more socially vulnerable communities show different readmission patterns?

## Key Features

- End-to-end analytics engineering workflow using Databricks, dbt, and Power BI
- Multi-source healthcare and social vulnerability data integration
- Dimensional warehouse modeling with fact and dimension tables
- Automated dbt testing and documentation
- Custom Python-based source-data validation framework
- Dashboard-ready analytical marts
- Reproducible, version-controlled development workflow

---

## Data Warehouse Architecture

![Hospital Readmissions Star Schema](assets/architecture/hospital_readmissions_erd.png)


The model separates the core analytical warehouse from dashboard-ready reporting models.

The core warehouse follows a star schema pattern with:

- `dim_hospital`
- `dim_measure`
- `fct_hospital_readmissions`
- `fct_hospital_social_risk`

Dashboard-ready marts include:

- `mart_hospital_performance_summary`
- `mart_hospital_equity_analysis`

---

## Transformation Pipeline

Raw public datasets were validated, loaded into Databricks, and transformed using dbt:

`raw → staging → intermediate → marts`

### Raw Layer

Source-aligned tables loaded into Databricks with minimal transformation.

### Staging Layer

Staging models clean and standardize individual sources. This includes:

- Renaming columns into analytics-friendly names
- Casting data types
- Standardizing boolean values
- Creating normalized county join keys
- Preserving raw and numeric versions of CMS fields where appropriate
- Preparing FIPS and readmission measure reference data for joins

### Intermediate Layer

Intermediate models apply reusable business logic and joins, including:

- Enriching hospitals with FIPS geography
- Joining hospitals to county-level SVI data
- Mapping HRRP measure IDs to readable condition names
- Calculating readmission performance indicators
- Creating reusable hospital-level and measure-level analytical datasets

### Marts Layer

Marts provide dashboard-ready tables for Power BI, including:

- A hospital-level performance summary
- A wide equity analysis model combining hospital, readmission, geographic, and SVI context

---

## Key Analytical Notes

All CMS HRRP records in this dataset cover the reporting period **July 1, 2021 through June 30, 2024**. Results should therefore be interpreted as a **cross-sectional analytical snapshot** rather than a longitudinal trend analysis.

A threshold of **500 discharges** was selected as a simple analytical segmentation variable and does **not** represent an official CMS classification.

This project uses static public datasets. It is intended for analytical modeling, dashboarding, and portfolio demonstration rather than operational healthcare decision-making.

Results should be interpreted as exploratory analytics rather than causal conclusions.

The analysis uses public aggregate datasets and does not include patient-level data.

---

## Dashboard Exposures

The three Power BI dashboards are documented in dbt as exposures, linking dashboard assets back to the marts that support them:

- Hospital Performance Overview
- Hospital Equity & Social Risk Analysis
- Hospital Performance Detail

> **Dashboard availability:** The Power BI report was developed locally using static, public datasets. Because this project was completed without an organizational Power BI/Fabric workspace, the dashboards are presented through screenshots and GIF walkthroughs rather than a live hosted report.


---

## Dashboards & Insights

### Hospital Performance Overview
![Hospital Performance Overview](assets/dashboards/hospital_performance_overview.png)

### Interactive Demonstration
![Hospital Performance Overview Demo](assets/dashboards/dashboard_performance_overview.gif)

The overview dashboard summarizes national hospital readmission performance, including:

- Total hospitals analyzed
- Average readmission gap
- Average social vulnerability percentile
- Percentage of hospitals worse than expected
- Percentage of hospitals in high-vulnerability communities

It also includes geographic and facility-level views to identify hospitals with elevated readmission ratios.

Key finding(s):
- Approximately half of hospitals performed worse than expected, suggesting that readmission challenges remain widespread across the dataset.
- Community vulnerability and readmission outcomes display only a modest relationship.
- Performance variation exists across states and hospital ownership types.

---

### Hospital Equity & Social Risk Analysis
![Hospital Equity & Social Risk Analysis](assets/dashboards/hospital_equity_social_risk_analysis.png)

### Interactive Demonstration
![Hospital Equity & Social Risk Analysis Demo](assets/dashboards/dashboard_equity_analysis.gif)

The equity dashboard explores relationships between hospital readmission outcomes and community-level social risk indicators, including:

- Poverty rate
- Uninsured rate
- Overall social vulnerability percentile
- Readmission ratio by condition and vulnerability category

This dashboard helps identify whether hospitals serving more vulnerable communities show different readmission patterns.

Key finding(s):
- Higher poverty and vulnerability levels appear to coincide with modest increases in readmission ratios in the dashboard views.
- Certain clinical conditions exhibit stronger vulnerability-related performance differences than others.

---

### Hospital Performance Detail
![Hospital Performance Detail](assets/dashboards/hospital_performance_detail.png)




### Interactive Demonstration
![Hospital Performance Detail Demo](assets/dashboards/dashboard_performance_detail.gif)

The detail dashboard provides a facility-level view of:

- Readmission performance
- Condition-specific readmission ratios
- Community vulnerability percentile
- Poverty and uninsured rates
- Hospital profile attributes

This page supports drilldown-style analysis for individual hospitals.

Key finding(s):
- Readmission outcomes vary substantially by condition.

---

## Data Sources

- Centers for Medicare & Medicaid Services (CMS). (2026, January 26). *Hospital Readmissions Reduction Program*. Provider Data Catalog. Retrieved May 11, 2026, from https://data.cms.gov/provider-data/dataset/9n3s-kdb3

- Centers for Medicare & Medicaid Services (CMS). (2026, April 28). *Hospital General Information*. Provider Data Catalog. Retrieved May 11, 2026, from https://data.cms.gov/provider-data/dataset/xubh-q36u

- Centers for Disease Control and Prevention / Agency for Toxic Substances and Disease Registry / Geospatial Research, Analysis, and Services Program. (2022). *CDC/ATSDR Social Vulnerability Index 2022 Database U.S.* Retrieved May 11, 2026, from https://www.atsdr.cdc.gov/placeandhealth/svi/data_documentation_download.html

- U.S. Department of Transportation. *State, County, and City FIPS Reference Table*. data.transportation.gov. Retrieved May 11, 2026, from https://data.transportation.gov/Railroads/State-County-and-City-FIPS-Reference-Table/eek5-pv8d/about_data

---

## Technology Stack

- **Databricks** for data storage, SQL development, and Delta table management
- **dbt** for transformation, testing, documentation, and lineage
- **Python (Pandas, pathlib, PyYAML)** for source-data validation and automation
- **Power BI** for dashboard development
- **GitHub** for version control and project documentation

---

## dbt Project Structure

```text
assets/
  architecture/
  dashboards/
  validation/

macros/
  generate_schema_name.sql
  normalize_county_name.sql
  parse_numeric_or_null.sql
  standardize_boolean.sql

models/
  staging/
    atsdr/
    cms/
    reference/
  intermediate/
  marts/

seeds/
  fips_lookup.csv
  county_name_overrides.csv
  readmission_measures.csv

data/
  raw/
    FY_2026_Hospital_Readmissions_Reduction_Program_Hospital.csv
    Hospital_General_Information.csv
    SVI_2022_US_county.csv

scripts/
  validate_csv_inputs.py
  validation_config.yaml

validation_reports/
```

---

## Important Macros

| Macro                   | Purpose                                                                                                                                          |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `generate_schema_name`  | Overrides dbt’s default schema naming so custom model schemas map directly to Databricks schemas such as `staging`, `intermediate`, and `marts`. |
| `normalize_county_name` | Creates standardized county join keys for geographic matching CMS hospital counties to FIPS reference data.                                      |
| `parse_numeric_or_null` | Converts CMS numeric text fields and `N/A` values into usable numeric columns.                                                                   |
| `standardize_boolean`   | Converts source yes/no-style values into consistent boolean fields.                                                                              |

---

## Data Quality and Testing

The dbt project includes tests for:

- Primary key uniqueness
- Required non-null fields
- Accepted categorical values
- Relationship integrity between fact and dimension models
- Composite uniqueness where model grain requires multiple fields

Examples include:

- `facility_id` uniqueness in `dim_hospital`
- `measure_id` uniqueness in `dim_measure`
- Relationship tests from fact tables to dimensions
- Composite uniqueness for readmission fact grain: facility, measure, and reporting period

---

## Source Data Validation

Prior to loading data into Databricks and executing dbt transformations, source files were validated using a custom Python-based validation utility.

The validation framework was created to simulate a lightweight ingestion quality-control process and to identify common data quality issues before they could propagate into downstream models, tests, and dashboards.

Validation rules are defined in a YAML configuration file, allowing checks to be maintained separately from application logic and extended to additional datasets with minimal code changes.

### Validation Checks

The validation utility performs the following checks:

- Required column verification
- Configurable non-null column validation
- Primary key duplicate detection
- Accepted value validation for categorical fields
- Empty-file detection
- Multi-file validation across both source and reference datasets

The utility generates a timestamped validation report summarizing pass/fail status and any detected issues.

### Example Validation Workflow

```
CSV Files
    ↓
Validation Utility
    ↓
Validation Report
    ↓
Databricks Ingestion
    ↓
dbt Transformations
```

### Configuration-Driven Design

Validation rules are maintained in a YAML configuration file rather than hardcoded in Python.

Example configuration concepts include:

```
required_columns:
non_null_columns:
primary_keys:
accepted_values:
```

This approach separates business rules from validation logic and makes it easier to add new datasets without modifying the underlying validation framework.

### Data Source Considerations

Several public source datasets required preprocessing before ingestion:

- Source column names were standardized to support Databricks and dbt naming conventions.
- Reference datasets contained territory-level records (such as Puerto Rico) that required different validation treatment than county-level records.
- Certain reference datasets contained duplicate geographic records at finer levels of granularity and were intentionally aggregated during transformation to support county-level analytical joins.

### Validation Example

Terminal Summary:

Generated Report:

### Technical Highlights

The validation utility demonstrates:

- Python scripting
- Pandas-based data quality checks
- Configuration-driven validation design
- File-system automation using pathlib
- Reusable validation functions
- Automated report generation

The utility is located in `scripts/` and serves as a supplemental quality-control layer alongside dbt tests implemented within the warehouse.

---

## Model Grain

|Model|Grain|
|---|---|
|`dim_hospital`|One row per hospital|
|`dim_measure`|One row per readmission measure|
|`fct_hospital_readmissions`|One row per hospital, measure, and reporting period|
|`fct_hospital_social_risk`|One row per hospital|
|`mart_hospital_performance_summary`|One row per hospital|
|`mart_hospital_equity_analysis`|One row per hospital, measure, and reporting period|

---

## Repository Status

This project is complete as a portfolio analytics engineering project, with room for future enhancements such as:

- Additional reporting years for longitudinal analysis
- More granular geographic matching
- Geographic clustering analysis
- Additional CMS quality metrics
- Automated dashboard deployment
- Published Power BI Service dashboard links

---

## Author

Kayla Jones

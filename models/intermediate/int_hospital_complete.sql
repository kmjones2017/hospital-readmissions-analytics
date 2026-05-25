with hospital_svi as (

    select * from {{ ref('int_hospital_svi') }}

),

readmission_performance as (

    select * from {{ ref('int_hospital_readmission_performance') }}

),

final as (

    select

        readmission_performance.facility_id,
        hospital_svi.facility_name,
        hospital_svi.facility_address,
        hospital_svi.city_or_town_name,
        hospital_svi.zip_code,

        hospital_svi.county_fips,
        hospital_svi.county_or_parish_name,
        hospital_svi.state_fips,
        hospital_svi.state_abbreviation,
        hospital_svi.state_name,

        hospital_svi.is_county_fips_mapped,
        hospital_svi.is_svi_mapped,

        hospital_svi.hospital_type,
        hospital_svi.hospital_ownership,
        hospital_svi.has_emergency_services,
        hospital_svi.is_birthing_friendly,

        readmission_performance.measure_id,
        readmission_performance.measure_name,
        readmission_performance.condition_group,
        readmission_performance.measure_category,
        readmission_performance.measure_description,
        readmission_performance.is_measure_mapped,

        readmission_performance.number_of_discharges_raw,
        readmission_performance.number_of_discharges_numeric,

        readmission_performance.number_of_readmissions_raw,
        readmission_performance.number_of_readmissions_numeric,

        readmission_performance.excess_readmission_ratio_raw,
        readmission_performance.excess_readmission_ratio_numeric,

        readmission_performance.predicted_readmission_rate_raw,
        readmission_performance.predicted_readmission_rate_numeric,

        readmission_performance.expected_readmission_rate_raw,
        readmission_performance.expected_readmission_rate_numeric,

        readmission_performance.readmission_rate_difference,
        readmission_performance.has_excess_readmissions,
        readmission_performance.readmission_performance_status,
        readmission_performance.is_high_discharge_volume,

        hospital_svi.total_population,
        hospital_svi.housing_units,
        hospital_svi.households,

        hospital_svi.below_150_percent_poverty_population_percentage,
        hospital_svi.unemployment_rate,
        hospital_svi.uninsured_population_percentage,
        hospital_svi.disabled_population_percentage,
        hospital_svi.overall_vulnerability_percentile_rank,

        readmission_performance.start_date,
        readmission_performance.end_date,
        readmission_performance.reporting_period

    from readmission_performance

    left join hospital_svi
        on readmission_performance.facility_id = hospital_svi.facility_id

)

select * from final
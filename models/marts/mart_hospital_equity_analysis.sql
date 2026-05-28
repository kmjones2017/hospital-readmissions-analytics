with hospital_complete as (

    select * from {{ ref('int_hospital_complete') }}

),

intermediary as (

    select
        facility_id,
        facility_name,
        facility_address,
        city_or_town_name,
        zip_code,

        county_fips,
        county_or_parish_name,
        state_fips,
        state_abbreviation,
        state_name,

        hospital_type,
        hospital_ownership,
        has_emergency_services,
        is_birthing_friendly,

        is_county_fips_mapped,
        is_svi_mapped,
        is_measure_mapped,

        measure_id,
        measure_name,
        condition_group,
        measure_category,

        number_of_discharges_numeric,
        number_of_readmissions_numeric,
        excess_readmission_ratio_numeric,
        predicted_readmission_rate_numeric,
        expected_readmission_rate_numeric,
        readmission_rate_difference,
        has_excess_readmissions,
        readmission_performance_status,
        is_high_discharge_volume,

        total_population,
        housing_units,
        households,
        below_150_percent_poverty_population_percentage,
        unemployment_rate,
        uninsured_population_percentage,
        disabled_population_percentage,
        overall_vulnerability_percentile_rank,

        case
            when overall_vulnerability_percentile_rank >= 0.90 then 'Very High'
            when overall_vulnerability_percentile_rank >= 0.75 then 'High'
            when overall_vulnerability_percentile_rank >= 0.50 then 'Moderate'
            when overall_vulnerability_percentile_rank is not null then 'Low'
            else 'Not Mapped'
        end as vulnerability_category,

        start_date,
        end_date,
        reporting_period

    from hospital_complete
    where overall_vulnerability_percentile_rank is not null

),

final as (

    select 

        *,

        case
            when vulnerability_category = 'Low' then 1
            when vulnerability_category = 'Moderate' then 2
            when vulnerability_category = 'High' then 3
            when vulnerability_category = 'Very High' then 4
            else 99
        end as vulnerability_category_sort

    from intermediary
)

select * from final
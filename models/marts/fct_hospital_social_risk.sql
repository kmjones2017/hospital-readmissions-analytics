with source as (

    select * from {{ ref('int_hospital_complete') }}

),

final as (

    select distinct

        facility_id,
        county_fips,
        is_county_fips_mapped,
        is_svi_mapped,

        total_population,
        housing_units,
        households,

        below_150_percent_poverty_population_percentage,
        unemployment_rate,
        uninsured_population_percentage,
        disabled_population_percentage,
        overall_vulnerability_percentile_rank

    from source

)

select * from final
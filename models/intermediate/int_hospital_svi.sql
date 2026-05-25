with hospitals as (

    select * from {{ ref('int_hospitals_enriched') }}

),

svi as (

    select * from {{ ref('stg_atsdr__svi_county') }}

),

final as (

    select
        hospitals.facility_id,
        hospitals.facility_name,
        hospitals.facility_address,
        hospitals.city_or_town_name,
        hospitals.zip_code,

        hospitals.county_fips,
        hospitals.county_or_parish_name,
        hospitals.state_fips,
        hospitals.state_abbreviation,
        hospitals.state_name,
        hospitals.is_county_fips_mapped,

        case
            when svi.state_county_fips_code is not null then true
            else false
        end as is_svi_mapped,

        hospitals.hospital_type,
        hospitals.hospital_ownership,
        hospitals.has_emergency_services,
        hospitals.is_birthing_friendly,

        svi.total_population,
        svi.housing_units,
        svi.households,

        svi.below_150_percent_poverty_population_percentage,
        svi.unemployment_rate,
        svi.uninsured_population_percentage,
        svi.disabled_population_percentage,
        svi.overall_vulnerability_percentile_rank

    from hospitals

    left join svi
        on hospitals.county_fips = svi.state_county_fips_code

)

select * from final
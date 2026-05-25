with hcomp as (

    select * from {{ ref('int_hospital_complete') }}

),

final as (

    select distinct
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
        is_svi_mapped

    from hcomp

)

select * from final
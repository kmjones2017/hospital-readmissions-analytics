with gen_info as (

    select * from {{ ref('stg_cms__hospital_general_information') }}

),

fips_lookup as (

    select * from {{ ref('stg_reference__fips_lookup') }}

),

intermediary as (

    select 

        gen_info.facility_id as facility_id,
        gen_info.facility_name as facility_name,
        gen_info.facility_address as facility_address,

        gen_info.city_town as city_or_town_name,
        gen_info.zip_code as zip_code,
        fips_lookup.county_fips_code as county_fips,
        initcap(gen_info.county_parish) as county_or_parish_name,
        fips_lookup.state_fips_code as state_fips,
        gen_info.state_abbreviation as state_abbreviation,
        fips_lookup.state_name as state_name,
        
        gen_info.hospital_type as hospital_type,
        gen_info.hospital_ownership as hospital_ownership,
        gen_info.has_emergency_services as has_emergency_services,
        gen_info.is_birthing_friendly as is_birthing_friendly

    from gen_info
    left join fips_lookup on gen_info.county_join_key = fips_lookup.county_join_key AND gen_info.state_abbreviation = fips_lookup.state_abbreviation
    where county_fips_code is null -- remove this line before building

),

final as (

    select * from intermediary

)

select * from final
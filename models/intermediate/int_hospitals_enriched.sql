with gen_info as (

    select * from {{ ref('stg_cms__hospital_general_information') }}

),

fips_lookup as (

    select * from {{ ref('stg_reference__fips_lookup') }}

),

county_name_overrides as (

    select * from {{ ref('stg_reference__county_name_overrides') }}

),

intermediary as (

    select 

        gen_info.facility_id,
        gen_info.facility_name,
        
        gen_info.facility_address,
        gen_info.city_town as city_or_town_name,
        gen_info.zip_code,
        
        fips_lookup.county_fips_code as county_fips,
        upper(gen_info.county_parish) as county_or_parish_name,
        
        fips_lookup.state_fips_code as state_fips,
        gen_info.state_abbreviation,
        fips_lookup.state_name,
        
        gen_info.hospital_type,
        gen_info.hospital_ownership,
        gen_info.has_emergency_services,
        gen_info.is_birthing_friendly,

        gen_info.county_join_key as original_county_join_key,
        county_name_overrides.standardized_county_join_key,
        coalesce(
            county_name_overrides.standardized_county_join_key,
            gen_info.county_join_key
        ) as resolved_county_join_key,

        case
            when fips_lookup.county_fips_code is not null then true
            else false
        end as is_county_fips_mapped

    from gen_info
    left join county_name_overrides 
        on gen_info.county_join_key = county_name_overrides.source_county_join_key 
        and gen_info.state_abbreviation = county_name_overrides.state_abbreviation

    left join fips_lookup 
        on coalesce(
            county_name_overrides.standardized_county_join_key,
            gen_info.county_join_key
        ) = fips_lookup.county_join_key
        and gen_info.state_abbreviation = fips_lookup.state_abbreviation

),

final as (

    select * from intermediary

)

select * from final
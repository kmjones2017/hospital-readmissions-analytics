with source as (

    select * from {{ source('reference', 'county_name_overrides') }}

),

cleaned as (

    select  
    
        trim(upper(state_abbreviation)) as state_abbreviation,
        trim(source_county_name) as source_county_name,
        trim(standardized_county_name) as standardized_county_name,
        regexp_replace({{ normalize_county_name('source_county_name') }}, '\\s+', '') as source_county_join_key,
        regexp_replace({{ normalize_county_name('standardized_county_name') }}, '\\s+', '') as standardized_county_join_key
            
    from source

),

final as (

    select * from cleaned

)

select * from final
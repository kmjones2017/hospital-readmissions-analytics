with source as (

    select * from {{ source('reference', 'fips_lookup') }}

),

cleaned as (

    select distinct 
    
        trim(county_fips_code) as county_fips_code,
        trim(initcap(county_name)) as county_name,
        trim(upper(state_code)) as state_abbreviation,
        trim(initcap(state_name)) as state_name,
        trim(state_fips_code) as state_fips_code
            
    from source
    where county_fips_code is not null
      and county_name is not null

),

final as (

    select * from cleaned

)

select * from final
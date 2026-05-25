with source as (

    select * from {{ source('reference', 'fips_lookup') }}

),

cleaned as (

    select
        max(trim(county_fips_code)) as county_fips_code,

        max(trim(initcap(county_name))) as county_name,

        regexp_replace(
            {{ normalize_county_name('county_name') }},
            '\\s+',
            ''
        ) as county_join_key,

        trim(upper(state_code)) as state_abbreviation,

        max(trim(initcap(state_name))) as state_name,

        max(trim(state_fips_code)) as state_fips_code

    from source

    where county_fips_code is not null
      and county_name is not null

    group by
        regexp_replace(
            {{ normalize_county_name('county_name') }},
            '\\s+',
            ''
        ),
        trim(upper(state_code))

),

final as (

    select * from cleaned

)

select * from final
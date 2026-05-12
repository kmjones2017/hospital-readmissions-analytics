with source as (
    
    select * from {{ source('atsdr', 'svi_2022_county_raw') }}

),

cleaned as (

    select

        trim(stcnty) as stcnty_clean,
        initcap(trim(state)) as state_clean, 
        upper(trim(st_abbr)) as st_abbr_clean,
        trim(initcap(county)) as county_clean,
        
        cast(area_sqmi as decimal(10,2)) as area_in_sq_mi,

        cast(e_totpop as int) as population,
        cast(e_hu as int) as housing_units,
        cast(e_hh as int) as households,

        cast(ep_pov150 as decimal(5,2)) as below_150_percent_poverty_population_percentage,
        cast(ep_unemp as decimal(5,2)) as unemployment_rate,
        cast(ep_nohsdp as decimal(5,2)) as population_age_25_plus_no_high_school_diploma_percentage,
        cast(ep_uninsur as decimal(5,2)) as uninsured_population_percentage,

        cast(ep_age65 as decimal(5,2)) as population_age_65_and_over_percentage,
        cast(ep_age17 as decimal(5,2)) as population_under_18_percentage,
        cast(ep_disabl as decimal(5,2)) as disabled_population_percentage,
        cast(ep_limeng as decimal(5,2)) as limited_english_proficiency_population_percentage,

        cast(ep_minrty as decimal(5,2)) as minority_population_percentage,
        cast(ep_munit as decimal(5,2)) as ten_plus_unit_housing_structure_percentage,
        cast(ep_mobile as decimal(5,2)) as mobile_home_percentage,
        cast(ep_crowd as decimal(5,2)) as overcrowded_housing_unit_percentage,
        cast(ep_noveh as decimal(5,2)) as no_vehicle_household_percentage,

        cast(rpl_theme1 as decimal(5,4)) as socioeconomic_status_percentile_rank,
        cast(rpl_theme2 as decimal(5,4)) as household_characteristics_percentile_rank,
        cast(rpl_theme3 as decimal(5,4)) as racial_and_ethnic_minority_status_percentile_rank,
        cast(rpl_theme4 as decimal(5,4)) as housing_type_and_transport_percentile_rank,
        cast(rpl_themes as decimal(5,4)) as overall_vulnerability_percentile_rank

    from source

),

final as (
    
    select
        
        stcnty_clean as state_county_fips_code,
        state_clean as state,
        st_abbr_clean as state_abbreviation,

        case
            when county_clean like '% planning region' 
                then replace(county_clean, ' planning region', '')
            else replace(county_clean, ' county', '')
        end as county_or_planning_region,

        area_in_sq_mi,

        population as total_population,
        housing_units,
        households,

        below_150_percent_poverty_population_percentage,
        unemployment_rate,
        population_age_25_plus_no_high_school_diploma_percentage,
        uninsured_population_percentage,

        population_age_65_and_over_percentage,
        population_under_18_percentage,
        disabled_population_percentage,
        limited_english_proficiency_population_percentage,

        minority_population_percentage,
        ten_plus_unit_housing_structure_percentage,
        mobile_home_percentage,
        overcrowded_housing_unit_percentage,
        no_vehicle_household_percentage,

        socioeconomic_status_percentile_rank,
        household_characteristics_percentile_rank,
        racial_and_ethnic_minority_status_percentile_rank,
        housing_type_and_transport_percentile_rank,
        overall_vulnerability_percentile_rank

    from cleaned

)

select * from final


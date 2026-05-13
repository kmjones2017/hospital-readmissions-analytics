with source as (

    select * from {{ source('cms', 'hospital_general_information_raw') }}

),

cleaned as (

    select 

        cast(trim(facility_id) as string) as facility_id,
        trim(facility_name) as facility_name,
        trim(address) as facility_address,
        trim(city_town) as city_town,
        trim(upper(state)) as state_abbreviation,
        
        cast(trim(zip_code) as string) as facility_zip_code,
        trim(county_parish) as county_parish,
        cast(trim(telephone_number) as string) as telephone_number,

        trim(initcap(hospital_type)) as hospital_type,
        trim(hospital_ownership) as hospital_ownership,

        standardize_boolean(emergency_services) as emergency_services_available,
        standardize_boolean(meets_criteria_for_birthing_friendly_designation) as birthing_friendly_designation,

        trim(cast(hospital_overall_rating as string)) as hospital_overall_rating,

        cast(mort_group_measure_count as string) as mortality_measure_group_count,
        cast(count_of_mort_measures_better as string) as mortality_measures_better_than_national_value_raw,
        **macro for column listed above**mortality_measures_better_than_national_value_numeric,
        **macro for column listed above**has_mortality_measures_better_than_national_value_flag,

        cast(count_of_mort_measures_no_different as string) as mortality_measures_matching_national_value_raw,
        **macro for column listed above**mortality_measures_matching_national_value_numeric,
        **macro for column listed above**mortality_measures_matching_national_value_flag,

        cast(count_of_mort_measures_worse as string) as mortality_measures_worse_than_national_value_raw,
        **macro for column listed above**mortality_measures_worse_than_national_value_numeric,
        **macro for column listed above**mortality_measures_worse_than_national_value_flag,

        safety_group_measure_count as safety_of_care_measure_group_measure_count,
        count_of_safety_measures_better as safety_of_care_measures_better_than_national_value_raw,
        **macro for column listed above**safety_of_care_measures_better_than_national_value_numeric,
        **macro for column listed above**safety_of_care_measures_better_than_national_value_flag,

        count_of_safety_measures_no_different as safety_of_care_measures_matching_national_value_raw,
        **macro for column listed above**safety_of_care_measures_matching_national_value_numeric,
        **macro for column listed above**safety_of_care_measures_matching_national_value_flag,

        count_of_safety_measures_worse as safety_of_care_measures_worse_than_national_value_raw,
        **macro for column listed above**safety_of_care_measures_worse_than_national_value_rawnumeric,
        **macro for column listed above**safety_of_care_measures_worse_than_national_value_flag,

        readm_group_measure_count as included_measures_in_readmissions_measure_group,
        count_of_readm_measures_better as readmissions_measure_group_than_national_value_raw,
        count_of_readm_measures_no_different as readmissions measures_matching_national_value_raw,
        count_of_readm_measures_worse as readmissions_measure_group_worse_than_national_value_raw

    from source

),

final (

    select 

        facility_id,
        facility_name,
        facility_address,
        city_town,
        state_abbreviation,

        facility_zip_code,
        county_parish,
        telephone_number,

        case
            when hospital_type like '% Hospital%' 
                then replace(hospital_type, ' Hospital%', '')
            else hospital_type
        end as hospital_type,

        hospital_ownership

    from cleaned

)

select * from final
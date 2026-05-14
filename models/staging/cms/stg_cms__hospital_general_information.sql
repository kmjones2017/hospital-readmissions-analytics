with source as (

    select * from {{ source('cms', 'hospital_general_information_raw') }}

),

cleaned as (

    select 

        cast(trim(facility_id) as string) as facility_id,
        trim(facility_name) as facility_name,

        trim(address) as facility_address,
        trim(city_town) as city_town,
        cast(trim(zip_code) as string) as zip_code,
        trim(county_parish) as county_parish,
        trim(upper(state)) as state_abbreviation,
        
        cast(trim(telephone_number) as string) as telephone_number,

        trim(initcap(hospital_type)) as hospital_type,
        trim(hospital_ownership) as hospital_ownership,

        standardize_boolean(emergency_services) as has_emergency_services,
        standardize_boolean(meets_criteria_for_birthing_friendly_designation) as is_birthing_friendly,

        trim(cast(hospital_overall_rating as string)) as hospital_overall_rating_raw,
        cast({{ parse_numeric_or_null('hospital_overall_rating') }} as int) as hospital_overall_rating_numeric,

        cast(mort_group_measure_count as string) as mortality_measure_group_included_measure_count_raw,
        cast({{ parse_numeric_or_null('mort_group_measure_count') }} as int) as mortality_measure_group_included_measure_count_numeric,

        cast(count_of_mort_measures_better as string) as mortality_measures_better_than_national_value_raw,
        cast({{ parse_numeric_or_null('count_of_mort_measures_better') }} as int) as mortality_measures_better_than_national_value_numeric,

        cast(count_of_mort_measures_no_different as string) as mortality_measures_matching_national_value_raw,
        cast({{ parse_numeric_or_null('count_of_mort_measures_no_different') }} as int) as mortality_measures_matching_national_value_numeric,

        cast(count_of_mort_measures_worse as string) as mortality_measures_worse_than_national_value_raw,
        cast({{ parse_numeric_or_null('count_of_mort_measures_worse') }} as int) as mortality_measures_worse_than_national_value_numeric,

        cast(safety_group_measure_count as string) as safety_of_care_measure_group_included_measure_count_raw,
        cast({{ parse_numeric_or_null('safety_group_measure_count') }} as int) as safety_of_care_measure_group_included_measure_count_numeric,
        
        cast(count_of_safety_measures_better as string) as safety_of_care_measures_better_than_national_value_raw,
        cast({{ parse_numeric_or_null('count_of_safety_measures_better') }} as int) as safety_of_care_measures_better_than_national_value_numeric,

        cast(count_of_safety_measures_no_different as string) as safety_of_care_measures_matching_national_value_raw,
        cast({{ parse_numeric_or_null('count_of_safety_measures_no_different') }} as int) as safety_of_care_measures_matching_national_value_numeric,

        cast(count_of_safety_measures_worse as string) as safety_of_care_measures_worse_than_national_value_raw,
        cast({{ parse_numeric_or_null('count_of_safety_measures_worse') }} as int) as safety_of_care_measures_worse_than_national_value_numeric,

        cast(readm_group_measure_count as string) as readmission_measure_group_included_measure_count_raw,
        cast({{ parse_numeric_or_null('readm_group_measure_count') }} as int) as readmission_measure_group_included_measure_count_numeric,

        cast(count_of_readm_measures_better as string) as readmission_measures_better_than_national_value_raw,
        cast({{ parse_numeric_or_null('count_of_readm_measures_better') }} as int) as readmission_measures_better_than_national_value_numeric,

        cast(count_of_readm_measures_no_different as string) as readmission_measures_matching_national_value_raw,
        cast({{ parse_numeric_or_null('count_of_readm_measures_no_different') }} as int) as readmission_measures_matching_national_value_numeric,

        cast(count_of_readm_measures_worse as string) as readmission_measures_worse_than_national_value_raw,
        cast({{ parse_numeric_or_null('count_of_readm_measures_worse') }} as int) as readmission_measures_worse_than_national_value_numeric

    from source

),

final as (

    select 

        facility_id,
        facility_name,
        facility_address,
        city_town,
        zip_code,
        county_parish,
        state_abbreviation,
        telephone_number,

        hospital_type,
        hospital_ownership,

        has_emergency_services,
        is_birthing_friendly,

        hospital_overall_rating_raw,
        hospital_overall_rating_numeric,

        mortality_measure_group_included_measure_count_raw,
        mortality_measure_group_included_measure_count_numeric,

        mortality_measures_better_than_national_value_raw,
        mortality_measures_better_than_national_value_numeric,

        mortality_measures_matching_national_value_raw,
        mortality_measures_matching_national_value_numeric,

        mortality_measures_worse_than_national_value_raw,
        mortality_measures_worse_than_national_value_numeric,

        safety_of_care_measure_group_included_measure_count_raw,
        safety_of_care_measure_group_included_measure_count_numeric,

        safety_of_care_measures_better_than_national_value_raw,
        safety_of_care_measures_better_than_national_value_numeric,

        safety_of_care_measures_matching_national_value_raw,
        safety_of_care_measures_matching_national_value_numeric,

        safety_of_care_measures_worse_than_national_value_raw,
        safety_of_care_measures_worse_than_national_value_numeric,

        readmission_measure_group_included_measure_count_raw,
        readmission_measure_group_included_measure_count_numeric,

        readmission_measures_better_than_national_value_raw,
        readmission_measures_better_than_national_value_numeric,

        readmission_measures_matching_national_value_raw,
        readmission_measures_matching_national_value_numeric,

        readmission_measures_worse_than_national_value_raw,
        readmission_measures_worse_than_national_value_numeric

    from cleaned

)

select * from final
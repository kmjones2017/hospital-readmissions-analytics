with source as (

    select * from {{ source('cms', 'hospital_readmissions_raw') }}

),

cleaned as (

    select  
    
        trim(cast(facility_id as string)) as facility_id,
        trim(facility_name) as facility_name,
        trim(upper(state)) as state_abbreviation,
        
        trim(measure_name) as measure_id,
        trim(cast(number_of_discharges as string)) as number_of_discharges_raw,
        cast({{ parse_numeric_or_null('number_of_discharges') }} as int) as number_of_discharges_numeric,
        
        trim(cast(number_of_readmissions as string)) as number_of_readmissions_raw,
        cast({{ parse_numeric_or_null('number_of_readmissions') }} as int) as number_of_readmissions_numeric,
        
        trim(cast(excess_readmission_ratio as string)) as excess_readmission_ratio_raw,
        {{ parse_numeric_or_null('excess_readmission_ratio', '5,4') }} as excess_readmission_ratio_numeric,

        trim(cast(predicted_readmission_rate as string)) as predicted_readmission_rate_raw,
        {{ parse_numeric_or_null('predicted_readmission_rate', '6,4') }} as predicted_readmission_rate_numeric,

        trim(cast(expected_readmission_rate as string)) as expected_readmission_rate_raw,
        {{ parse_numeric_or_null('expected_readmission_rate', '6,4') }} as expected_readmission_rate_numeric,

        to_date(trim(start_date),'MM/dd/yyyy') as start_date_cleaned,
        to_date(trim(end_date),'MM/dd/yyyy') as end_date_cleaned
    
    from source

),

final as (

    select

        facility_id,
        facility_name,
        state_abbreviation,

        measure_id,
        number_of_discharges_raw,
        number_of_discharges_numeric,

        number_of_readmissions_raw,
        number_of_readmissions_numeric,

        excess_readmission_ratio_raw,
        excess_readmission_ratio_numeric,

        predicted_readmission_rate_raw,
        predicted_readmission_rate_numeric,

        expected_readmission_rate_raw,
        expected_readmission_rate_numeric,

        start_date_cleaned as start_date,
        end_date_cleaned as end_date,
        concat(start_date_cleaned, '_to_', end_date_cleaned) as reporting_period

    from cleaned

)

select * from final
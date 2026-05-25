with source as (

    select * from {{ ref('int_hospital_readmission_performance') }}

),

final as (

    select 

        facility_id,
        is_measure_mapped,
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

        readmission_rate_difference,
        has_excess_readmissions,
        readmission_performance_status,
        is_high_discharge_volume,

        start_date,
        end_date,
        reporting_period

    from source 

)

select * from final
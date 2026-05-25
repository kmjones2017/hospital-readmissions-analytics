with readmissions as (

    select * from {{ ref('int_readmission_measure_enriched') }}

),

final as (

    select

        facility_id,
        facility_name,
        state_abbreviation,

        measure_id,
        measure_name,
        condition_group,
        measure_category,
        measure_description,
        is_measure_mapped,

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

        predicted_readmission_rate_numeric - expected_readmission_rate_numeric
            as readmission_rate_difference,

        case
            when excess_readmission_ratio_numeric > 1 then true
            when excess_readmission_ratio_numeric <= 1 then false
            else null
        end as has_excess_readmissions,

        case
            when excess_readmission_ratio_numeric > 1 then 'worse_than_expected'
            when excess_readmission_ratio_numeric = 1 then 'as_expected'
            when excess_readmission_ratio_numeric < 1 then 'better_than_expected'
            else 'not_available'
        end as readmission_performance_status,

        case
            when number_of_discharges_numeric >= 500 then true
            when number_of_discharges_numeric < 500 then false
            else null
        end as is_high_discharge_volume,

        start_date,
        end_date,
        reporting_period

    from readmissions

)

select * from final
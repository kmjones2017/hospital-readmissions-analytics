with hrrp as (

    select * from {{ ref('stg_cms__hrrp_hospital') }}

),

readm as (

    select * from {{ ref('stg_reference__readmission_measures') }}

),

final as (

    select

        hrrp.facility_id,
        hrrp.facility_name,
        hrrp.state_abbreviation,

        case
            when readm.measure_id is not null then true
            else false
        end as is_measure_mapped,
        
        hrrp.measure_id,
        readm.measure_name,
        readm.condition_group, 
        readm.measure_category,
        readm.measure_description,

        hrrp.number_of_discharges_raw,
        hrrp.number_of_discharges_numeric,

        hrrp.number_of_readmissions_raw,
        hrrp.number_of_readmissions_numeric,

        hrrp.excess_readmission_ratio_raw,
        hrrp.excess_readmission_ratio_numeric,

        hrrp.predicted_readmission_rate_raw,
        hrrp.predicted_readmission_rate_numeric,

        hrrp.expected_readmission_rate_raw,
        hrrp.expected_readmission_rate_numeric,

        hrrp.start_date,
        hrrp.end_date,
        hrrp.reporting_period


    from hrrp 

    left join readm on hrrp.measure_id = readm.measure_id
)

select * from final
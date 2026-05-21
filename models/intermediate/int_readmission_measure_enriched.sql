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

    hrrp.measure_id,
    readm.measure_name,
    readm.condition_group, 
    readm.measure_category,
    readm.measure_description


    from hrrp 

    left join readm on 
)

select * from final
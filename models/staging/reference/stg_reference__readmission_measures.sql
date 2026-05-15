with source as (

    select * from {{ source('reference', 'readmission_measures') }}

),

final as (

    select 
    
        trim(measure_id) as measure_id,
        trim(measure_name) as measure_name,
        trim(condition_group) as condition_group,
        trim(measure_category) as measure_category,
        trim(measure_description) as measure_description
    
    from source
    
)

select * from final
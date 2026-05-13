with source as (

    select * from {{ source('cms', 'hospital_readmissions_raw') }}

),

final as (

    select * from source

)

select * from final
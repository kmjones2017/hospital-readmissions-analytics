with readm_measure as (

    select * from {{ ref('int_readmission_measure_enriched') }}

),

final as (

    select distinct
        measure_id,
        measure_name,
        condition_group,
        measure_category,
        measure_description

    from readm_measure

)

select * from final
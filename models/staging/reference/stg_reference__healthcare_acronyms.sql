with source as (

    select * from {{ source('reference', 'healthcare_acronyms') }}

),

final as (

    select 
    
        trim(acronym) as acronym,
        trim(meaning) as meaning
    
    from source
    
)

select * from final
with source as (

    select * from {{ source('reference', 'cms_footnotes') }}

),

final as (

    select 
        
        trim(cast(footnote_code as string)) as footnote_code,
        trim(footnote_category) as footnote_category,
        trim(footnote_text) as footnote_text,
        trim(footnote_definition) as footnote_definition

    from source
    
)

select * from final
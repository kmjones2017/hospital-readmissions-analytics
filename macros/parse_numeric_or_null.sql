{% macro parse_numeric_or_null(column_name, decimal_places='10,2') %}

case

    when trim(cast({{ column_name }} as string))
        rlike '^[0-9]+(\\.[0-9]+)?$'

    then cast(
        trim(cast({{ column_name }} as string))
        as decimal({{ decimal_places }})
    )

    else null

end

{% endmacro %}
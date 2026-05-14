{% macro parse_numeric_or_null(column_name) %}

    case

        when trim(cast({{ column_name }} as string))
            rlike '^[0-9]+(\\.[0-9]+)?$'

        then cast(trim(cast({{ column_name }} as string)) as decimal(10,2))

        else null

    end

{% endmacro %}
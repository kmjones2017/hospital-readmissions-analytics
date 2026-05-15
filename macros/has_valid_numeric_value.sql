{% macro has_valid_numeric_value(column_name) %}

    case

        when trim({{ column_name }}) rlike '^[0-9]+$'
            then true

        else false

    end

{% endmacro %}
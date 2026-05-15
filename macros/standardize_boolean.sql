{% macro standardize_boolean(column_name) %}

    case

        when lower(trim({{ column_name }})) in ('1', 'true', 'yes', 'y')
            then true

        when lower(trim({{ column_name }})) in ('0', 'false', 'no', 'n')
            then false

        else null

    end

{% endmacro %}
{% macro standardize_boolean(column) %}
    
    case

        when lower({{ column }}) in ('1', 'true', 'yes', 'y') then true
        when lower({{ column }}) in ('0', 'false', 'no', 'n') then false
        else null

    end

{% endmacro %}
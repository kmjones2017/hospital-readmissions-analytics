{% macro data_availability_flag(column_name) %}

    case
        when {{ column_name }} is not null
            then true
        else false
    end
    
{% endmacro %}
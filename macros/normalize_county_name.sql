{% macro normalize_county_name(column_name) %}
    
    trim(
        regexp_replace(
            regexp_replace(
                regexp_replace(
                    upper({{ column_name }}),
                    '[.]',
                    ''
                ),
                ' \\(CITY\\)$| CITY$',
                ''
            ),
            ' COUNTY$| PARISH$| BOROUGH$| MUNICIPALITY$| CENSUS AREA$| PLANNING REGION$',
            ''
        )
    )

{% endmacro %}
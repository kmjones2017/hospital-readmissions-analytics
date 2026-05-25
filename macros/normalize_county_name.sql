{% macro normalize_county_name(column_name) %}

    regexp_replace(
        regexp_replace(
            regexp_replace(
                regexp_replace(
                    regexp_replace(
                        regexp_replace(
                            regexp_replace(
                                regexp_replace(
                                    upper(trim({{ column_name }})),
                                    '[^A-Z0-9 ]',
                                    ' '
                                ),
                                '\\s+',
                                ' '
                            ),
                            '^ST ',
                            'SAINT '
                        ),
                        '^E ',
                        'EAST '
                    ),
                    '^W ',
                    'WEST '
                ),
                '^N ',
                'NORTH '
            ),
            '^S ',
            'SOUTH '
        ),
        ' COUNTY$| PARISH$| BOROUGH$| ISLAND$| MUNICIPALITY$| CENSUS AREA$| PLANNING REGION$| CITY AND BOROUGH$| CITY$| ISLAND$| THE ',
        ''
    )

{% endmacro %}
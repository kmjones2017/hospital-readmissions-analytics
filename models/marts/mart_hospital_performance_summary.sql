with hospital_complete as (

    select * from {{ ref('int_hospital_complete') }}

),

aggregated as (

    select
        facility_id,
        max(facility_name) as facility_name,
        max(city_or_town_name) as city_or_town_name,
        max(county_or_parish_name) as county_or_parish_name,
        max(state_abbreviation) as state_abbreviation,
        max(state_name) as state_name,

        max(hospital_type) as hospital_type,
        max(hospital_ownership) as hospital_ownership,
        max(has_emergency_services) as has_emergency_services,
        max(is_birthing_friendly) as is_birthing_friendly,

        max(is_county_fips_mapped) as is_county_fips_mapped,
        max(is_svi_mapped) as is_svi_mapped,

        avg(excess_readmission_ratio_numeric) as average_excess_readmission_ratio,

        sum(
            case
                when readmission_performance_status = 'Better Than Expected' then 1
                else 0
            end
        ) as measures_better_than_expected_count,

        sum(
            case
                when readmission_performance_status = 'As Expected' then 1
                else 0
            end
        ) as measures_as_expected_count,

        sum(
            case
                when readmission_performance_status = 'Worse Than Expected' then 1
                else 0
            end
        ) as measures_worse_than_expected_count,

        count(measure_id) as readmission_measure_count,

        max(overall_vulnerability_percentile_rank) as overall_vulnerability_percentile_rank

    from hospital_complete

    group by facility_id

),

intermediary as (

    select
        *,

        case
            when average_excess_readmission_ratio > 1 then 'Worse Than Expected'
            when average_excess_readmission_ratio = 1 then 'As Expected'
            when average_excess_readmission_ratio < 1 then 'Better Than Expected'
            else 'Not Available'
        end as overall_readmission_performance_status,

        case
            when overall_vulnerability_percentile_rank >= 0.90 then 'Very High'
            when overall_vulnerability_percentile_rank >= 0.75 then 'High'
            when overall_vulnerability_percentile_rank >= 0.50 then 'Moderate'
            when overall_vulnerability_percentile_rank is not null then 'Low'
            else 'Not Mapped'
        end as vulnerability_category

    from aggregated
    where average_excess_readmission_ratio is not null and overall_vulnerability_percentile_rank is not null

),

final as (

    select

        *,

        case
            when vulnerability_category = 'Low' then 1
            when vulnerability_category = 'Moderate' then 2
            when vulnerability_category = 'High' then 3
            when vulnerability_category = 'Very High' then 4
            else 99
        end as vulnerability_category_sort
        
    from intermediary
)

select * from final
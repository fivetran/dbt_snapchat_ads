{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with ad_day_source as (

    select 
        ad_id, 
        cast(date_hour as date) as date_day_source
    from {{ ref('stg_snapchat_ads__ad_hourly_report') }}
    {{ dbt_utils.group_by(2) }}
), 

ad_day_end as (

    select 
        ad_id, 
        date_day as date_day_end
    from {{ ref('snapchat_ads__ad_report') }}

    {{ dbt_utils.group_by(2) }}
),

final as (
    -- test will fail if any rows from source not found in end
    (select * from ad_day_source
    except distinct
    select * from ad_day_end)

    union all -- union since we only care if rows are produced

    -- test will fail if any rows from end are not found in source
    (select * from ad_day_end
    except distinct
    select * from ad_day_source)
    )

select *
from final
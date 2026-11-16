{{ config(enabled=var('ad_reporting__snapchat_ads_enabled', true) and var('snapchat_ads__using_campaign_demographic_report', false)) }}

with base as (

    select *
    from {{ ref('stg_snapchat_ads__campaign_demographic_daily_report_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_snapchat_ads__campaign_demographic_daily_report_tmp')),
                staging_columns=get_campaign_demographic_daily_report_columns()
            )
        }}

        {{ fivetran_utils.apply_source_relation(package_name='snapchat_ads') }}

    from base
),

final as (

    select
        source_relation,
        campaign_id,
        age_bucket,
        -- Snapchat age buckets follow the <min>-<max> format, and the oldest bucket is open-ended, such as 35+, which gets a max_age of 100. Other values return null.
        case
            when age_bucket like '%-%' then cast(nullif({{ dbt.split_part('age_bucket', "'-'", 1) }}, '') as {{ dbt.type_int() }})
            when age_bucket like '%+' then cast(nullif({{ dbt.replace('age_bucket', "'+'", "''") }}, '') as {{ dbt.type_int() }})
        end as min_age,
        case
            when age_bucket like '%-%' then cast(nullif({{ dbt.split_part('age_bucket', "'-'", 2) }}, '') as {{ dbt.type_int() }})
            when age_bucket like '%+' then 100
        end as max_age,
        gender,
        cast(date as {{ dbt.type_timestamp() }}) as date_day,
        attachment_quartile_1,
        attachment_quartile_2,
        attachment_quartile_3,
        (attachment_total_view_time_millis / 1000000.0) as attachment_total_view_time,
        attachment_view_completion,
        quartile_1,
        quartile_2,
        quartile_3,
        saves,
        shares,
        (screen_time_millis / 1000000.0) as screen_time,
        video_views,
        view_completion,
        (view_time_millis / 1000000.0) as view_time,
        impressions,
        (spend / 1000000.0) as spend,
        swipes,
        coalesce(cast(conversion_purchases_value as {{ dbt.type_float() }}), 0) / 1000000.0 as conversion_purchases_value

        {% for conversion in var('snapchat_ads__conversion_fields', []) %}
            , coalesce(cast({{ conversion }} as {{ dbt.type_bigint() }}), 0) as {{ conversion }}
        {% endfor %}

        {{ snapchat_ads_fill_pass_through_columns(pass_through_fields=var('snapchat_ads__campaign_daily_demographic_report_passthrough_metrics')) }}

    from fields
)

select *
from final

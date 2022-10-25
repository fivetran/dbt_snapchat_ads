{{ config(enabled=var('ad_reporting__snapchat_ads_enabled', true)) }}
with base as (

    select *
    from {{ var('creative_history') }}
    where is_most_recent_record = true

), url_tags as (

    select *
    from {{ var('creative_url_tag_history') }}
    where is_most_recent_record = true

), url_tags_pivoted as (

    select 
        creative_id,
        min(case when param_key = 'utm_source' then param_value end) as utm_source,
        min(case when param_key = 'utm_medium' then param_value end) as utm_medium,
        min(case when param_key = 'utm_campaign' then param_value end) as utm_campaign,
        min(case when param_key = 'utm_content' then param_value end) as utm_content,
        min(case when param_key = 'utm_term' then param_value end) as utm_term
    from url_tags
    group by 1

), fields as (

    select
        base.creative_id,
        base.ad_account_id,
        base.creative_name,
        base.url,
        {{ dbt.split_part('base.url', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('base.url') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('base.url') }} as url_path,
        coalesce(url_tags_pivoted.utm_source, {{ dbt_utils.get_url_parameter('base.url', 'utm_source') }}) as utm_source,
        coalesce(url_tags_pivoted.utm_medium, {{ dbt_utils.get_url_parameter('base.url', 'utm_medium') }}) as utm_medium,
        coalesce(url_tags_pivoted.utm_campaign, {{ dbt_utils.get_url_parameter('base.url', 'utm_campaign') }}) as utm_campaign,
        coalesce(url_tags_pivoted.utm_content, {{ dbt_utils.get_url_parameter('base.url', 'utm_content') }}) as utm_content,
        coalesce(url_tags_pivoted.utm_term, {{ dbt_utils.get_url_parameter('base.url', 'utm_term') }}) as utm_term
    from base
    left join url_tags_pivoted
        on base.creative_id = url_tags_pivoted.creative_id

)

select *
from fields
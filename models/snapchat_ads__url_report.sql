{{ config(enabled=var('ad_reporting__snapchat_ads_enabled', true)) }}

with ad_hourly as (

    select *
    from {{ var('ad_hourly_report') }}

), creatives as (

    select *
    from {{ ref('snapchat_ads__creative_history_prep') }}

), account as (

    select *
    from {{ var('ad_account_history') }}
    where is_most_recent_record = true

), ads as (

    select *
    from {{ var('ad_history') }}
    where is_most_recent_record = true

), ad_squads as (

    select *
    from {{ var('ad_squad_history') }}
    where is_most_recent_record = true

), campaigns as (

    select *
    from {{ var('campaign_history') }}
    where is_most_recent_record = true


), aggregated as (

    select
        cast(ad_hourly.date_hour as date) as date_day,
        account.ad_account_id,
        account.ad_account_name,
        ad_hourly.ad_id,
        ads.ad_name,
        ad_squads.ad_squad_id,
        ad_squads.ad_squad_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        account.currency,
        creatives.base_url,
        creatives.url_host,
        creatives.url_path,
        creatives.utm_source,
        creatives.utm_medium,
        creatives.utm_campaign,
        creatives.utm_content,
        creatives.utm_term,
        sum(ad_hourly.swipes) as swipes,
        sum(ad_hourly.impressions) as impressions,
        round(sum(ad_hourly.spend),2) as spend
        
        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='snapchat_ads__ad_hourly_passthrough_metrics', transform = 'sum') }}
    
    from ad_hourly
    left join ads 
        on ad_hourly.ad_id = ads.ad_id
    left join creatives
        on ads.creative_id = creatives.creative_id
    left join ad_squads
        on ads.ad_squad_id = ad_squads.ad_squad_id
    left join campaigns
        on ad_squads.campaign_id = campaigns.campaign_id
    left join account
        on creatives.ad_account_id = account.ad_account_id

    {% if var('ad_reporting__url_report__using_null_filter', True) %}
        -- We only want utm ads to populate this report. Therefore, we filter where url ads are populated.
        where creatives.url is not null
    {% endif %}

    {{ dbt_utils.group_by(18) }}

)

select *
from aggregated

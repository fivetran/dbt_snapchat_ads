{{ config(enabled=var('ad_reporting__snapchat_ads_enabled', true)) }}

with ad_hourly as (

    select *,
        {% if var('snapchat_ads__conversion_fields', none) %}
            {{ var('snapchat_ads__conversion_fields') | join(' + ') }} as total_conversions
        {% else %}
            0 as total_conversions
        {% endif %}
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
        ad_hourly.source_relation,
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
        sum(ad_hourly.swipes) as swipes,
        sum(ad_hourly.impressions) as impressions,
        round(sum(ad_hourly.spend),2) as spend,
        sum(ad_hourly.total_conversions) as total_conversions,
        round(cast(sum(ad_hourly.conversion_purchases_value) as {{ dbt.type_numeric() }}), 2) as conversion_purchases_value

        {{ snapchat_ads_persist_pass_through_columns(pass_through_variable='snapchat_ads__conversion_fields', transform='sum', coalesce_with=0, except_variable='snapchat_ads__ad_hourly_passthrough_metrics', exclude_fields=['conversion_purchases_value']) }}

        {{ snapchat_ads_persist_pass_through_columns(pass_through_variable='snapchat_ads__ad_hourly_passthrough_metrics', transform='sum', exclude_fields=['conversion_purchases_value']) }}

    from ad_hourly
    left join ads 
        on ad_hourly.ad_id = ads.ad_id
        and ad_hourly.source_relation = ads.source_relation
    left join creatives
        on ads.creative_id = creatives.creative_id
        and ads.source_relation = creatives.source_relation
    left join account
        on creatives.ad_account_id = account.ad_account_id
        and creatives.source_relation = account.source_relation
    left join ad_squads
        on ads.ad_squad_id = ad_squads.ad_squad_id
        and ads.source_relation = ad_squads.source_relation
    left join campaigns
        on ad_squads.campaign_id = campaigns.campaign_id
        and ad_squads.source_relation = campaigns.source_relation
    
    {{ dbt_utils.group_by(11) }}

)

select *
from aggregated
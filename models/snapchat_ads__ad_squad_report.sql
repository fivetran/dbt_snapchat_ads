{{ config(enabled=var('ad_reporting__snapchat_ads_enabled', true)) }}

with ad_squad_hourly as (

    select *
    from {{ var('ad_squad_hourly_report') }}

), account as (

    select *
    from {{ var('ad_account_history') }}
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
        cast(ad_squad_hourly.date_hour as date) as date_day,
        account.ad_account_id,
        account.ad_account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_squad_hourly.ad_squad_id,
        ad_squads.ad_squad_name,
        account.currency,
        sum(ad_squad_hourly.swipes) as swipes,
        sum(ad_squad_hourly.impressions) as impressions,
        round(sum(ad_squad_hourly.spend),2) as spend
        
        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='snapchat_ads__ad_squad_hourly_passthrough_metrics', transform = 'sum') }}
    
    from ad_squad_hourly
    left join ad_squads
        on ad_squad_hourly.ad_squad_id = ad_squads.ad_squad_id
    left join campaigns
        on ad_squads.campaign_id = campaigns.campaign_id
    left join account
        on campaigns.ad_account_id = account.ad_account_id
    
    {{ dbt_utils.group_by(8) }}

)

select *
from aggregated
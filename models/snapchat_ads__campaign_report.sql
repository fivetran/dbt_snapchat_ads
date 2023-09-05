{{ config(enabled=var('ad_reporting__snapchat_ads_enabled', true)) }}

with campaign_hourly as (

    select *
    from {{ var('campaign_hourly_report') }}

), account as (

    select *
    from {{ var('ad_account_history') }}
    where is_most_recent_record = true

), campaigns as (

    select *
    from {{ var('campaign_history') }}
    where is_most_recent_record = true


), aggregated as (

    select
        campaign_hourly.source_relation,
        cast(campaign_hourly.date_hour as date) as date_day,
        account.ad_account_id,
        account.ad_account_name,
        campaign_hourly.campaign_id,
        campaigns.campaign_name,
        account.currency,
        sum(campaign_hourly.swipes) as swipes,
        sum(campaign_hourly.impressions) as impressions,
        round(sum(campaign_hourly.spend),2) as spend
        
        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='snapchat_ads__campaign_hourly_report_passthrough_metrics', transform = 'sum') }}
    
    from campaign_hourly
    left join campaigns
        on campaign_hourly.campaign_id = campaigns.campaign_id
        and campaign_hourly.source_relation = campaigns.source_relation
    left join account
        on campaigns.ad_account_id = account.ad_account_id
        and campaigns.source_relation = account.source_relation
    
    {{ dbt_utils.group_by(7) }}

)

select *
from aggregated
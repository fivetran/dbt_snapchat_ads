{{ config(enabled=var('ad_reporting__snapchat_ads_enabled', true) and var('snapchat_ads__using_campaign_region_report', false)) }}

with campaign_daily as (

    select *,
        {% if var('snapchat_ads__conversion_fields', none) %}
            {{ var('snapchat_ads__conversion_fields') | join(' + ') }} as total_conversions
        {% else %}
            0 as total_conversions
        {% endif %}
    from {{ var('campaign_region_daily_report') }}

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
        campaign_daily.source_relation,
        campaign_daily.date_day,
        campaign_daily.campaign_id,
        campaigns.campaign_name,
        campaign_daily.region,
        account.ad_account_id,
        account.ad_account_name,
        campaigns.created_at,
        campaigns.daily_budget,
        campaigns.start_time,
        campaigns.end_time,
        campaigns.status,
        campaigns.objective,
        campaigns.lifetime_spend_cap,
        account.currency,
        sum(campaign_daily.swipes) as swipes,
        sum(campaign_daily.impressions) as impressions,
        round(sum(campaign_daily.spend),2) as spend,
        sum(campaign_daily.shares) as shares,
        sum(campaign_daily.saves) as saves,
        sum(campaign_daily.total_conversions) as total_conversions,
        round(cast(sum(campaign_daily.conversion_purchases_value) as {{ dbt.type_numeric() }}), 2) as conversion_purchases_value

        {{ snapchat_ads_persist_pass_through_columns(pass_through_variable='snapchat_ads__conversion_fields', transform='sum', coalesce_with=0, except_variable='snapchat_ads__campaign_daily_region_report_passthrough_metrics', exclude_fields=['conversion_purchases_value']) }}
        
        {{ snapchat_ads_persist_pass_through_columns(pass_through_variable='snapchat_ads__campaign_daily_region_report_passthrough_metrics', transform='sum', exclude_fields=['conversion_purchases_value']) }}
    
    from campaign_daily
    left join campaigns
        on campaign_daily.campaign_id = campaigns.campaign_id
        and campaign_daily.source_relation = campaigns.source_relation
    left join account
        on campaigns.ad_account_id = account.ad_account_id
        and campaigns.source_relation = account.source_relation
    
    {{ dbt_utils.group_by(15) }}

)

select *
from aggregated
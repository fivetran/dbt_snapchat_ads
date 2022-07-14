with campaign_hourly as (

    select *
    from {{ var('campaign_hourly_report') }}

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
        cast(campaign_hourly.date_hour as date) as date_day,
        account.ad_account_id,
        account.ad_account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        account.currency,
        sum(campaign_hourly.swipes) as swipes,
        sum(campaign_hourly.impressions) as impressions,
        round(sum(campaign_hourly.spend)) as spend
    
    from campaign_hourly
    left join campaigns
        on campaign_hourly.campaign_id = campaigns.campaign_id
    left join ad_squads
        on campaigns.campaign_id = ad_squads.campaign_id
    left join account
        on campaigns.ad_account_id = account.ad_account_id
    
    {{ dbt_utils.group_by(6) }}

)

select *
from aggregated
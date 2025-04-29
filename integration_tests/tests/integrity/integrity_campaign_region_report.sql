{{ config(
        tags="fivetran_validations",
        enabled=var('fivetran_validation_tests_enabled', false) and
        var('snapchat_ads__using_campaign_country_report', false)
) }}

with source as (

    select 
        campaign_id,
        region,
        sum(spend) as spend,
        sum(swipes) as swipes,
        sum(impressions) as impressions,
        sum(shares) as shares,
        sum(saves) as saves,
        sum(conversion_purchases_value) as conversion_purchases_value
    from {{ ref('stg_snapchat_ads__campaign_geo_region_daily_report')}}
    group by 1,2
),

model as (

    select 
        campaign_id,
        region,
        sum(spend) as spend,
        sum(swipes) as swipes,
        sum(impressions) as impressions,
        sum(shares) as shares,
        sum(saves) as saves,
        sum(conversion_purchases_value) as conversion_purchases_value
    from {{ ref('snapchat_ads__campaign_region_report') }}
    group by 1,2
),

final as (
    select 
        source.campaign_id,
        source.region,
        source.spend as source_spend,
        model.spend as model_spend,
        source.swipes as source_swipes,
        model.swipes as model_swipes,
        source.impressions as source_impressions,
        model.impressions as model_impressions,
        source.shares as source_shares,
        model.shares as model_shares,
        source.saves as source_saves,
        model.saves as model_saves,
        source.conversion_purchases_value as source_conversion_purchases_value,
        model.conversion_purchases_value as model_conversion_purchases_value
    from source 
    full outer join model
        on source.campaign_id = model.campaign_id
        and source.region = model.region
)

select * 
from final
where 
    abs(source_spend - model_spend) > .01
    or abs(source_swipes - model_swipes) > .01
    or abs(source_impressions - model_impressions) > .01
    or abs(source_shares - model_shares) > .01
    or abs(source_saves - model_saves) > .01
    or abs(source_conversion_purchases_value - model_conversion_purchases_value) > .01
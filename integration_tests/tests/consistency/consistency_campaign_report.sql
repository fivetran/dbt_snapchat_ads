{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        campaign_id,
        sum(swipes) as swipes, 
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(total_conversions) as total_conversions,
        sum(conversion_purchases_value) as conversion_purchases_value
    from {{ target.schema }}_snapchat_ads_prod.snapchat_ads__campaign_report
    group by 1
),

dev as (
    select
        campaign_id,
        sum(swipes) as swipes, 
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(total_conversions) as total_conversions,
        sum(conversion_purchases_value) as conversion_purchases_value
    from {{ target.schema }}_snapchat_ads_dev.snapchat_ads__campaign_report
    group by 1
),

final as (
    select 
        prod.campaign_id,
        prod.swipes as prod_swipes,
        dev.swipes as dev_swipes,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend,
        prod.total_conversions as prod_total_conversions,
        dev.total_conversions as dev_total_conversions,
        prod.conversion_purchases_value as prod_conversion_purchases_value,
        dev.conversion_purchases_value as dev_conversion_purchases_value
    from prod
    full outer join dev 
        on dev.campaign_id = prod.campaign_id
)

select *
from final
where
    abs(prod_swipes - dev_swipes) >= .01
    or abs(prod_impressions - dev_impressions) >= .01
    or abs(prod_spend - dev_spend) >= .01
    or abs(prod_total_conversions - dev_total_conversions) >= .01
    or abs(prod_conversion_purchases_value - dev_conversion_purchases_value) >= .01
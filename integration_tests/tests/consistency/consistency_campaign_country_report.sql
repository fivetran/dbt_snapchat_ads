{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        campaign_id,
        country,
        sum(swipes) as swipes, 
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(shares) as shares,
        sum(saves) as saves,
        sum(total_conversions) as total_conversions,
        sum(conversion_purchases_value) as conversion_purchases_value
    from {{ target.schema }}_snapchat_ads_prod.snapchat_ads__campaign_country_report
    group by 1,2
),

dev as (
    select
        campaign_id,
        country,
        sum(swipes) as swipes, 
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(shares) as shares,
        sum(saves) as saves,
        sum(total_conversions) as total_conversions,
        sum(conversion_purchases_value) as conversion_purchases_value
    from {{ target.schema }}_snapchat_ads_dev.snapchat_ads__campaign_country_report
    group by 1,2
),

final as (
    select 
        prod.campaign_id,
        prod.country,
        prod.swipes as prod_swipes,
        dev.swipes as dev_swipes,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend,
        prod.shares as prod_shares,
        dev.shares as dev_shares,
        prod.saves as prod_saves,
        dev.saves as dev_saves,
        prod.total_conversions as prod_total_conversions,
        dev.total_conversions as dev_total_conversions,
        prod.conversion_purchases_value as prod_conversion_purchases_value,
        dev.conversion_purchases_value as dev_conversion_purchases_value
    from prod
    full outer join dev 
        on dev.campaign_id = prod.campaign_id
        and dev.country = prod.country
)

select *
from final
where
    abs(prod_swipes - dev_swipes) >= .01
    or abs(prod_impressions - dev_impressions) >= .01
    or abs(prod_spend - dev_spend) >= .01
    or abs(prod_shares - dev_shares) >= .01
    or abs(prod_saves - dev_saves) >= .01
    or abs(prod_total_conversions - dev_total_conversions) >= .01
    or abs(prod_conversion_purchases_value - dev_conversion_purchases_value) >= .01
{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        ad_squad_id,
        sum(swipes) as swipes, 
        sum(impressions) as impressions,
        sum(spend) as spend
    from {{ target.schema }}_snapchat_ads_prod.snapchat_ads__ad_squad_report
    group by 1
),

dev as (
    select
        ad_squad_id,
        sum(swipes) as swipes, 
        sum(impressions) as impressions,
        sum(spend) as spend
    from {{ target.schema }}_snapchat_ads_dev.snapchat_ads__ad_squad_report
    group by 1
),

final as (
    select 
        prod.ad_squad_id,
        prod.swipes as prod_swipes,
        dev.swipes as dev_swipes,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend
    from prod
    full outer join dev 
        on dev.ad_squad_id = prod.ad_squad_id
)

select *
from final
where
    abs(prod_swipes - dev_swipes) >= .01
    or abs(prod_impressions - dev_impressions) >= .01
    or abs(prod_spend - dev_spend) >= .01
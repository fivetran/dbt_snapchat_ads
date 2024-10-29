{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with ad_report as (

    select 
        sum(conversion_purchases_value) as total_value,
        sum(total_conversions) as total_conversions
    from {{ ref('snapchat_ads__ad_report') }}
),

account_report as (

    select 
        sum(conversion_purchases_value) as total_value,
        sum(total_conversions) as total_conversions
    from {{ ref('snapchat_ads__account_report') }}
),

ad_squad_report as (

    select 
        sum(conversion_purchases_value) as total_value,
        sum(total_conversions) as total_conversions
    from {{ ref('snapchat_ads__ad_squad_report') }}
),

campaign_report as (

    select 
        sum(conversion_purchases_value) as total_value,
        sum(total_conversions) as total_conversions
    from {{ ref('snapchat_ads__campaign_report') }}
),

url_report as (

    select 
        sum(conversion_purchases_value) as total_value,
        sum(total_conversions) as total_conversions
    from {{ ref('snapchat_ads__url_report') }}
)

select 
    'ad vs account' as comparison,
    ad_report.*
from ad_report
join account_report on true
where ad_report.total_value != account_report.total_value
or ad_report.total_conversions != account_report.total_conversions

union all 

select 
    'ad vs ad squad' as comparison,
    ad_report.*
from ad_report
join ad_squad_report on true
where ad_report.total_value != ad_squad_report.total_value
or ad_report.total_conversions != ad_squad_report.total_conversions

union all 

select 
    'ad vs campaign' as comparison,
    ad_report.*
from ad_report
join campaign_report on true
where ad_report.total_value != campaign_report.total_value
or ad_report.total_conversions != campaign_report.total_conversions

union all 

select 
    'ad vs url' as comparison,
    ad_report.*
from ad_report
join url_report on true
where ad_report.total_value != url_report.total_value
or ad_report.total_conversions != url_report.total_conversions
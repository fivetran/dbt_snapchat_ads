{{ config(enabled=var('ad_reporting__snapchat_ads_enabled', true) and var('snapchat_ads__using_campaign_country_report', false)) }}


{{
    fivetran_utils.union_data(
        table_identifier='campaign_geo_country_daily_report', 
        database_variable='snapchat_ads_database', 
        schema_variable='snapchat_ads_schema', 
        default_database=target.database,
        default_schema='snapchat_ads',
        default_variable='campaign_geo_country_daily_report',
        union_schema_variable='snapchat_ads_union_schemas',
        union_database_variable='snapchat_ads_union_databases'
    )
}}
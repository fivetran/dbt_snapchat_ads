{{ config(enabled=var('ad_reporting__snapchat_ads_enabled', true)) }}

{{
    fivetran_utils.union_data(
        table_identifier='ad_squad_history', 
        database_variable='snapchat_ads_database', 
        schema_variable='snapchat_ads_schema', 
        default_database=target.database,
        default_schema='snapchat_ads',
        default_variable='ad_squad_history',
        union_schema_variable='snapchat_ads_union_schemas',
        union_database_variable='snapchat_ads_union_databases'
    )
}}
{{ config(enabled=var('ad_reporting__snapchat_ads_enabled', true)) }}

with base as (

    select * 
    from {{ ref('stg_snapchat_ads__creative_history_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_snapchat_ads__creative_history_tmp')),
                staging_columns=get_creative_history_columns()
            )
        }}
    
        {{ fivetran_utils.apply_source_relation(package_name='snapchat_ads') }}

    from base
),

final as (

    select
        source_relation, 
        id as creative_id,
        cast (created_at as {{ dbt.type_timestamp() }}) as created_at,
        ad_account_id,
        name as creative_name,
        web_view_url as url,
        cast (_fivetran_synced as {{ dbt.type_timestamp() }}) as _fivetran_synced,
        cast (updated_at as {{ dbt.type_timestamp() }}) as updated_at,
        row_number() over (partition by id {{ fivetran_utils.partition_by_source_relation(package_name='snapchat_ads') }} order by _fivetran_synced desc) =1 as is_most_recent_record
    from fields
)

select * 
from final
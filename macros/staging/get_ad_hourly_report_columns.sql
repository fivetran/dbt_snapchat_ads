{% macro get_ad_hourly_report_columns() %}

{% set columns = [
    {"name": "ad_id", "datatype": dbt.type_string()},
    {"name": "attachment_quartile_1", "datatype": dbt.type_numeric()},
    {"name": "attachment_quartile_2", "datatype": dbt.type_numeric()},
    {"name": "attachment_quartile_3", "datatype": dbt.type_numeric()},
    {"name": "attachment_total_view_time_millis", "datatype": dbt.type_numeric()},
    {"name": "attachment_view_completion", "datatype": dbt.type_numeric()},
    {"name": "date", "datatype": dbt.type_timestamp()},
    {"name": "impressions", "datatype": dbt.type_numeric()},
    {"name": "quartile_1", "datatype": dbt.type_numeric()},
    {"name": "quartile_2", "datatype": dbt.type_numeric()},
    {"name": "quartile_3", "datatype": dbt.type_numeric()},
    {"name": "saves", "datatype": dbt.type_numeric()},
    {"name": "screen_time_millis", "datatype": dbt.type_numeric()},
    {"name": "shares", "datatype": dbt.type_numeric()},
    {"name": "spend", "datatype": dbt.type_numeric()},
    {"name": "swipes", "datatype": dbt.type_numeric()},
    {"name": "video_views", "datatype": dbt.type_numeric()},
    {"name": "view_completion", "datatype": dbt.type_numeric()},
    {"name": "view_time_millis", "datatype": dbt.type_numeric()},
    {"name": "conversion_purchases_value", "datatype": dbt.type_int()}
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('snapchat_ads__conversion_fields')) }}

{# Doing it this way in case users were bringing in conversion metrics via passthrough columns prior to us adding them by default #}
{{ snapchat_ads_add_pass_through_columns(base_columns=columns, pass_through_fields=var('snapchat_ads__ad_hourly_passthrough_metrics'), except_fields=(var('snapchat_ads__conversion_fields') + ['conversion_purchases_value'])) }}

{{ return(columns) }}

{% endmacro %}

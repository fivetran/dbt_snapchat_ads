{% macro get_campaign_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "ad_account_id", "datatype": dbt.type_string()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "id", "datatype": dbt.type_string()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()},
    {"name": "daily_budget_micro", "datatype": dbt.type_int()},
    {"name": "start_time", "datatype": dbt.type_timestamp()},
    {"name": "end_time", "datatype": dbt.type_timestamp()},
    {"name": "lifetime_spend_cap_micro", "datatype": dbt.type_int()},
    {"name": "status", "datatype": dbt.type_string()},
    {"name": "objective", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

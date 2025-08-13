{% macro get_ad_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "ad_squad_id", "datatype": dbt.type_string()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "creative_id", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_string()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}

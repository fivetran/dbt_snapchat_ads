{% macro get_creative_url_tag_history_columns() %}

{% set columns = [
    {"name": "creative_id", "datatype": dbt.type_string()},
    {"name": "key", "datatype": dbt.type_string()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()},
    {"name": "value", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

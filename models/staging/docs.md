{% docs _fivetran_synced -%} When the record was last synced by Fivetran. {%- enddocs %}

{% docs is_most_recent_record %} Boolean representing whether a record is the most recent version of that record. {% enddocs %}

{% docs source_relation %}
The source of the record if the unioning functionality is being used. If not this field will be empty.
{% enddocs %}
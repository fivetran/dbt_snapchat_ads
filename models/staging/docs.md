{% docs _fivetran_synced -%} When the record was last synced by Fivetran. {%- enddocs %}

{% docs is_most_recent_record %} Boolean representing whether a record is the most recent version of that record. {% enddocs %}

{% docs source_relation %}
The source of the record if the unioning functionality is being used. If not this field will be empty.
{% enddocs %}

{% docs age_bucket %}
Audience age range, such as `13-17`, `18-20`, `21-24`, `25-34`, or `35+`.
{% enddocs %}

{% docs min_age %}
Lower bound of the audience age range, parsed from `age_bucket`. For example, `18-20` and `35+` return 18 and 35. Null when the age range isn't in a `<min>-<max>` or `<min>+` format.
{% enddocs %}

{% docs max_age %}
Upper bound of the audience age range, parsed from `age_bucket`. For example, `18-20` returns 20. An open-ended range such as `35+` returns 100. Null when the age range isn't in a `<min>-<max>` or `<min>+` format.
{% enddocs %}

{% docs gender %}
Audience gender, such as `female` or `male`.
{% enddocs %}

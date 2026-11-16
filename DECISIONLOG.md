# Snapchat Ads Decision Log
## Ads Associated with Multiple Ad Groups and Multiple Campaigns
An ad can be associated with multiple ad squads and therefore multiple campaigns on any given day. Therefore, `snapchat_ads__ad_report` doesn't contain ad_squad or campaign fields since it reports on an ad level. Similarly, `snapchat_ads__campaign_report` and `snapchat_ads__ad_squad_report` do not contain ad fields. This prevents overattributing performance to just one ad.

## UTM Filtering
This package contains a `snapchat_ads__url_report` which provides daily metrics for your utm compatible ads. It is important to note that not all Ads leverage utm parameters. Therefore, this package takes an opinionated approach to filter out any records that do not contain utm parameters or leverage a url within the ad.

If you would like to leverage a report that contains all ads and their daily metrics, I would suggest you leverage the `snapchat_ads__ad_report` which does not apply any filtering.

## Ad Account Report Metrics Associated with Deleted Entities
Similar to some other Ad Platforms, Snapchat Ads will hard-delete entities (i.e. ads, ad squads, campaigns, accounts) from their `*_history` tables but retain associated records in their respective `*_hourly_report` tables. This typically does not pose an issue for our `not_null` tests on our end models, as most entities have their own `<entity>_hourly_report` source tables that come with the appropriate entity-level ID. However, `snapchat_ads__account_report` draws from the `ad_hourly_report` table, rolls it up to the account level, and joins in the `ad_account_id` using history tables. Thus, if any ad report record is associated with a deleted ad, campaign, ad squad, or account, the `ad_account_id` will be `null`.

We have opted to keep these records in `snapchat_ads__account_report`, as it may be valuable to know that non-zero ad metrics are associated with deleted entities (though null-account records will be grouped together). However, we have changed the severity of the `not_null` test on `ad_account_id` to be `warn` instead of `error`.

If you would like to disable this `not_null` test completely to avoid warnings, add the following to your root project `dbt_project.yml`:
```yml
tests:
  snapchat_ads:
    not_null_snapchat_ads__account_report_ad_account_id:
      +enabled: false
```

And if you are using the downstream [Ad Reporting](https://github.com/fivetran/dbt_ad_reporting/) data models, you'd also want to apply the same change to `ad_reporting__account_report`:
```yml
tests:
  ad_reporting:
    not_null_ad_reporting__account_report_account_id:
      +enabled: false
```

## Filtering for the most recent record 
We filter for `is_most_recent_record` using `_fivetran_synced` rather than `updated_at` due to cases where the `updated_at` field is null, in which the partition wouldn't be able to work. The exception is for the `stg_snapchat_ads__creative_url_tag_history` model where `_fivetran_synced` is not an existing field.

## Selecting which columns to include from the source tables
Snapchat passes many fields; in order to eliminate clutter we made a judgement call on which fields to include in our models. For fields that you wish to use that aren't included by default, refer to the [passthrough column feature](https://github.com/fivetran/dbt_snapchat_ads/blob/feature/v2_updates/README.md#passing-through-additional-metrics). 

## Age and gender reports
`snapchat_ads__campaign_age_report` and `snapchat_ads__campaign_gender_report` both come from the `campaign_demographic_daily_report` source table. Each source row covers one campaign, day, age range, and gender. The age report sums across genders, and the gender report sums across age ranges.

Snapchat reports audience age as a range string, such as `18-20`. The oldest range is open-ended, such as `35+`. We keep the raw `age_bucket` value and parse it into `min_age` and `max_age` integer columns:
- A range such as `18-20` maps to `min_age = 18` and `max_age = 20`.
- An open-ended range such as `35+` maps to `min_age = 35` and `max_age = 100`. We use 100 as the upper bound so you can filter and bucket ages with `between min_age and max_age`.
- Any other value gets `null` for both.

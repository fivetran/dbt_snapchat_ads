# dbt_snapchat_ads v0.7.0
[PR #28](https://github.com/fivetran/dbt_snapchat_ads/pull/28) includes the following **BREAKING CHANGE** updates:

## Feature Updates: Conversion Support
We have added more robust support for conversions in our data models by doing the following:

- Added a `conversion_purchases_value` field to each `_report` end model, representing the value of conversions that occurred on each day for each account,  ad, ad squad, campaign and url in your Ad Account's currency.
- Introduced the `snapchat_ads_conversion_fields` variable to configure which conversion fields (reflecting the total number of conversions) to include in each end model.
  - By default, `snapchat_ads_conversion_fields` will include the most commonly used conversion field, `conversion_purchases`. See [README](https://github.com/fivetran/dbt_snapchat_ads/tree/main?tab=readme-ov-file#configuring-conversion-fields) for details on how to configure this variable to include other conversion events.
  - The individual conversion fields specified by `snapchat_ads_conversion_fields` are summed together into a `total_conversions` field in each end model as well.
> **IMPORTANT**: The above new field additions are **breaking changes** for users who were not already bringing in conversion fields via passthrough columns.

## Documentation Update 
- Documented how to use the new `snapchat_ads__conversion_fields` variable [here](https://github.com/fivetran/dbt_snapchat_ads/tree/main?tab=readme-ov-file#configuring-conversion-fields).
- Documented new default conversion fields in yml.

## Under the Hood
- Added a new [version](https://github.com/fivetran/dbt_snapchat_ads/blob/main/macros/snapchat_ads_persist_pass_through_columns.sql) of the `persist_pass_through_columns()` [macro](https://github.com/fivetran/dbt_fivetran_utils/blob/v0.4.10/macros/persist_pass_through_columns.sql) in which we can include `coalesces` and properly check between conversion field values and the existing passthrough column.
- Added data validation tests to verify this release.

## Contributors
- [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation)

# dbt_snapchat_ads v0.6.2
## Bug Fixes
- Adjust the severity of the `ad_account_id` test in `snapchat_ads__account_report` to `warn`. This is required since Snapchat can hard-delete records from the history tables, but not from the reporting tables. This ensures that accurate statistics are being reported and production pipelines aren't failing. ([PR #20](https://github.com/fivetran/dbt_snapchat_ads/pull/20))
  - Documents the above decision in the [DECISIONLOG.md](https://github.com/fivetran/dbt_snapchat_ads/blob/main/DECISIONLOG.md).

## Under the Hood
- Updated the repo-maintainer PR template to our most up-to-date format ([PR #24](https://github.com/fivetran/dbt_snapchat_ads/pull/24)).

## Contributors
- [@bthomson22](https://github.com/bthomson22) ([PR #20](https://github.com/fivetran/dbt_snapchat_ads/pull/20))

# dbt_snapchat_ads v0.6.1
[PR #22](https://github.com/fivetran/dbt_snapchat_ads/pull/22) includes the following updates:
## Bug Fixes
- This package now leverages the new `snapchat_ads_extract_url_parameter()` macro for use in parsing out url parameters. This was added to create special logic for Databricks instances not supported by `dbt_utils.get_url_parameter()`.
  - This macro will be replaced with the `fivetran_utils.extract_url_parameter()` macro in the next breaking change of this package.
## Under the Hood
- Included auto-releaser GitHub Actions workflow to automate future releases.

# dbt_snapchat_ads v0.6.0
[PR #19](https://github.com/fivetran/dbt_snapchat_ads/pull/19) includes the following updates:
## Feature update 🎉
- Unioning capability! This adds the ability to union source data from multiple snapchat_ads connectors. Refer to the [Union Multiple Connectors README section](https://github.com/fivetran/dbt_snapchat_ads/blob/main/README.md#union-multiple-connectors) for more details.

## Under the hood 🚘
- In the source package, updated tmp models to union source data using the `fivetran_utils.union_data` macro. 
- To distinguish which source each field comes from, added `source_relation` column in each staging and downstream model and applied the `fivetran_utils.source_relation` macro.
  - The `source_relation` column is included in all joins in the transform package. 
- Updated tests to account for the new `source_relation` column.

[PR #15](https://github.com/fivetran/dbt_snapchat_ads/pull/15) includes the following updates:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request [templates](/.github). 

# dbt_snapchat_ads v0.5.1
## Bug Fixes
- Add missing columns ad_squad_id, ad_squad_name, campaign_id and campaign_name to `url_report` that were previously available in the <0.3.1 version of this package. ([#14](https://github.com/fivetran/dbt_snapchat_ads/pull/14))

## Contributors
- [@dumkydewilde](https://github.com/dumkydewilde) ([#14](https://github.com/fivetran/dbt_snapchat_ads/pull/14))
# dbt_snapchat_ads v0.5.0

## 🚨 Breaking Changes 🚨:
[PR #12](https://github.com/fivetran/dbt_snapchat_ads/pull/12) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

## 🎉 Features 🎉
- For use in the [dbt_ad_reporting package](https://github.com/fivetran/dbt_ad_reporting), users can now allow records having nulls in url fields to be included in the `ad_reporting__url_report` model. See the [dbt_ad_reporting README](https://github.com/fivetran/dbt_ad_reporting) for more details [#13](https://github.com/fivetran/dbt_snapchat_ads/pull/13).

## 🚘 Under the Hood 🚘
- Disabled the `not_null` test for `snapchat_ads__url_report` when null urls are allowed [#13](https://github.com/fivetran/dbt_snapchat_ads/pull/13).

# dbt_snapchat_ads v0.4.0
PR [#11](https://github.com/fivetran/dbt_snapchat_ads/pull/11) applies the Ad Reporting V2 updates:

## 🚨 Breaking Changes 🚨
- Changes `snapchat_schema` and `snapchat_database` variable names to `snapchat_ads_schema` and `snapchat_ads_database` 
- Updates model names to prefix with `snapchat_ads` and removes the `ad_adapter` model and dependencies on it
## 🎉 Feature Enhancements 🎉

- Addition of the following new end models. These models were added to provide further flexibility and ensure greater accuracy of your Snapchat Ads reporting. Additionally, these new end models will be leveraged in the respective downstream [dbt_ad_reporting](https://github.com/fivetran/dbt_ad_reporting) models.
  - `snapchat_ads__ads_report`
    - Each record in this table represents the daily performance at the ads level.
  - `snapchat_ads__creative_report`
    - Each record in this table represents the daily performance at the campaign level.
  - `snapchat_ads__url_report`
    - Each record in this table represents the daily performance at the url level.

- Applies README standardization updates
- Introduces the identifier variable for all source models
- Casts all timestamp fields using dbt_utils.type_timestamp() and rounds all monetary fields
- Inclusion of passthrough metrics:
  - `snapchat_ads__ad_hourly_passthrough_metrics`
  - `snapchat_ads__ad_squad_hourly_passthrough_metrics`
  - `snapchat_ads__campaign_hourly_report_passthrough_metrics`
> This applies to all passthrough columns within the `dbt_snapchat_ads_source` package and not just the `snapchat_ads__ad_hourly_passthrough_metrics` example.
```yml
vars:
  snapchat_ads__ad_hourly_passthrough_metrics:
    - name: "my_field_to_include" # Required: Name of the field within the source.
      alias: "field_alias" # Optional: If you wish to alias the field within the staging model.
```
- Add enable configs for this specific ad platform, for use in the Ad Reporting rollup package 

# dbt_snapchat_ads v0.3.1
🎉 Fix creative_id bug [issue]](https://github.com/fivetran/dbt_snapchat_ads/issues/8) 🎉

- Removed `creative_id` from the ad adapter model. Previously we brought in `creative_id` into the ad adapter model, but snapchat metrics only deliver at the `ad_id` level and ads may have more than one creative. Therefore this potentially over-attributed metrics to a creative and caused duplicates for metrics like spend and impression. 

# dbt_snapchat_ads v0.3.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_snapchat_ads_source`. Additionally, the latest `dbt_snapchat_ads_source` package has a dependency on the latest `dbt_fivetran_utils`. Further, the latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_snapchat_ads v0.1.0 -> v0.2.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!

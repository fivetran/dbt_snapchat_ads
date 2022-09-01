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

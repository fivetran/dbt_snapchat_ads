# Snapchat Ads Transformation dbt Package ([Docs](https://fivetran.github.io/dbt_snapchat_ads/))
<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_snapchat_ads/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

## What does this dbt package do?
- Produces modeled tables that leverage Snapchat Ads data from [Fivetran's connector](https://fivetran.com/docs/connectors/applications/snapchat-ads) in the format described by [this ERD](https://fivetran.com/docs/connectors/applications/snapchat-ads#schemainformation) and builds off the output of our [Snapchat Ads source package](https://github.com/fivetran/dbt_snapchat_ads_source).
- Generates a comprehensive data dictionary of your source and modeled Snapchat Ads data through the [dbt docs site](https://fivetran.github.io/dbt_snapchat_ads/).
- Enables you to better understand your marketing performance based on different levels of granularity:

<!--section=“snapchat_ads_transformation_model"-->

The following table provides a detailed list of all tables materialized within this package by default.
> TIP: See more details about these tables in the package's [dbt docs site](https://fivetran.github.io/dbt_snapchat_ads/#!/overview?g_v=1&g_e=seeds).

| **Table**                    | **Description**                                                                                                        |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| [snapchat_ads__account_report](https://fivetran.github.io/dbt_snapchat_ads/#!/model/model.snapchat_ads.snapchat_ads__account_report)     | Each record represents the daily ad performance of each account.                                                       |
| [snapchat_ads__campaign_report](https://fivetran.github.io/dbt_snapchat_ads/#!/model/model.snapchat_ads.snapchat_ads__campaign_report)    | Each record represents the daily ad performance of each campaign.                                                      |
| [snapchat_ads__ad_report](https://fivetran.github.io/dbt_snapchat_ads/#!/model/model.snapchat_ads.snapchat_ads__ad_report)          | Each record represents the daily ad performance of each ad.                                                            |
| [snapchat_ads__url_report](https://fivetran.github.io/dbt_snapchat_ads/#!/model/model.snapchat_ads.snapchat_ads__url_report)         | Each record represents the daily ad performance of each ad url.                                                           |
| [snapchat_ads__ad_squad_report](https://fivetran.github.io/dbt_snapchat_ads/#!/model/model.snapchat_ads.snapchat_ads__ad_squad_report)    | Each record represents the daily ad performance of each ad squad. |
| [snapchat_ads__campaign_country_report](https://fivetran.github.io/dbt_snapchat_ads/#!/model/model.snapchat_ads.snapchat_ads__campaign_country_report)    | Each record represents the daily ad performance of each campaign per country.                                                      |
| [snapchat_ads__campaign_region_report](https://fivetran.github.io/dbt_snapchat_ads/#!/model/model.snapchat_ads.snapchat_ads__campaign_region_report)    | Each record represents the daily ad performance of each campaign per region.                                                      |

### Materialized Models
Each Quickstart transformation job run materializes 29 models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.
<!--section-end-->

## How do I use the dbt package?

### Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Snapchat Ads connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **Databricks**, or **PostgreSQL** destination.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 2: Install the package  (skip if also using the `ad_reporting` combination package)
If you are not using the [Ad Reporting](https://github.com/fivetran/dbt_ad_reporting) combination package, include the following Snapchat Ads package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yml
packages:
  - package: fivetran/snapchat_ads
    version: [">=0.9.0", "<0.10.0"] # we recommend using ranges to capture non-breaking changes automatically
```

Do NOT include the `snapchat_ads_source` package in this file. The transformation package itself has a dependency on it and will install the source package as well.

### Step 3: Configure your variables

#### Define database and schema variables
By default, this package runs using your destination and the `snapchat_ads_source` schema. If this is not where your Snapchat Ads data is (for example, if your Snapchat Ads schema is named `snapchat_ads_fivetran`), you would add the following configuration to your root `dbt_project.yml` file with your custom database and schema names:

```yml
vars:
    snapchat_ads_database: your_destination_name
    snapchat_ads_schema: your_schema_name 
```

### (Optional) Step 4: Additional configurations
<details open><summary>Expand/Collapse details</summary>

#### Enabling models that are disabled by default
For certain models, we have disabled them by default because of a smaller percentages of accounts syncing the underlying tables. To enable them, add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    snapchat_ads__using_campaign_country_report: true # false by default. Requires the campaign_geo_country_daily_report
    snapchat_ads__using_campaign_region_report: true # false by default. Requires the campaign_geo_region_daily_report
```

#### Union multiple connections
If you have multiple snapchat_ads connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `snapchat_ads_union_schemas` OR `snapchat_ads_union_databases` variables (cannot do both) in your root `dbt_project.yml` file:

```yml
vars:
    snapchat_ads_union_schemas: ['snapchat_ads_usa','snapchat_ads_canada'] # use this if the data is in different schemas/datasets of the same database/project
    snapchat_ads_union_databases: ['snapchat_ads_usa','snapchat_ads_canada'] # use this if the data is in different databases/projects but uses the same schema name
```
> NOTE: The native `source.yml` connection set up in the package will not function when the union schema/database feature is utilized. Although the data will be correctly combined, you will not observe the sources linked to the package models in the Directed Acyclic Graph (DAG). This happens because the package includes only one defined `source.yml`.

To connect your multiple schema/database sources to the package models, follow the steps outlined in the [Union Data Defined Sources Configuration](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#union_data-source) section of the Fivetran Utils documentation for the union_data macro. This will ensure a proper configuration and correct visualization of connections in the DAG.

#### Passing Through Additional Metrics
By default, this package will select `swipes`, `impressions`, `spend`, `conversion_purchases_value`, and `total_conversions` (as well as fields set via `snapchat_ads__conversion_fields` in the next section) from the source reporting tables to store into the staging models. If you would like to pass through additional metrics to the staging models, add the below configurations to your `dbt_project.yml` file. These variables allow for the pass-through fields to be aliased (`alias`) if desired, but not required. Use the below format for declaring the respective pass-through variables:

```yml
vars:
    snapchat_ads__ad_hourly_passthrough_metrics: 
      - name: "new_custom_field"
        alias: "custom_field_alias"
        transform_sql: "coalesce(custom_field_alias, 0)" # reference the `alias` here if you are using one
      - name: "unique_int_field"
        alias: "field_id"
      - name: "another_one"
        transform_sql: "coalesce(another_one, 0)" # reference the `name` here if you're not using an alias
    snapchat_ads__ad_squad_hourly_passthrough_metrics:
      - name: "this_field"
    snapchat_ads__campaign_hourly_report_passthrough_metrics:
      - name: "unique_string_field"
        alias: "field_id"
    snapchat_ads__campaign_daily_country_report_passthrough_metrics:
      - name: "new_measure_country_report"
    snapchat_ads__campaign_daily_region_report_passthrough_metrics:
      - name: "new_measure_region_report"
```

>**Note**: Make sure to exercise due diligence when adding metrics to these models. The metrics added by default (swipes, impressions, spend, and conversions) have been vetted by the Fivetran team, maintaining this package for accuracy. There are metrics included within the source reports, such as metric averages, which may be inaccurately represented at the grain for reports created in this package. You must ensure that whichever metrics you pass through are appropriate to aggregate at the respective reporting levels in this package.

**Important**: You do NOT need to add conversions in this way. See the following section for an alternative implementation.

#### Configuring Conversion Fields
Separate from the above passthrough metrics, the package will also include conversion metrics based on the `snapchat_ads__conversion_fields` variable, in addition to the `conversion_purchases_value` field.

By default, the data models consider `conversion_purchases` to be conversions. These should cover most use cases, but, say, if you would like to consider adding payment info, adding to wishlist, adding to the cart, etc. to also be conversions, you would apply the following configuration with the **original** source names of the conversion fields (not aliases you provided in the section above):

```yml
# dbt_project.yml
vars:
    snapchat_ads__conversion_fields: ['conversion_purchases', 'conversion_add_billing', 'conversion_save', 'conversion_add_cart']
```

> We introduced support for conversion fields in our `*_report` data models in the [v0.7.0 release](https://github.com/fivetran/dbt_snapchat_ads_source/releases/tag/v0.7.0) of the package, but customers might have been bringing in these conversion fields earlier using the passthrough fields variables. The data models will avoid "duplicate column" errors automatically if this is the case.

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable. This is not available when running the package on multiple unioned connections.

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_snapchat_ads_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
vars:
    snapchat_ads_<default_source_table_name>_identifier: your_table_name 
```
    
#### Change the build schema
By default, this package builds the Snapchat Ads staging models (9 views, 9 tables) within a schema titled (`<target_schema>` + `_stg_snapchat_ads`) and your Snapchat Ads modeling models (5 tables) within a schema titled (`<target_schema>` + `_snapchat_ads`) in your destination. If this is not where you would like your Snapchat Ads data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    snapchat_ads_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
    snapchat_ads:
      +schema: my_new_schema_name # leave blank for just the target_schema
```

</details>

### (Optional) Step 5: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for more details</summary>
<br>
    
Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/snapchat_ads_source
      version: [">=0.8.0", "<0.9.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```
## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/snapchat_ads/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_snapchat_ads/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Opinionated Decisions
In creating this package, which is meant for a wide range of use cases, we had to take opinionated stances on a few different questions we came across during development. We've consolidated significant choices we made in the [DECISIONLOG.md](https://github.com/fivetran/dbt_snapchat_ads/blob/main/DECISIONLOG.md), and will continue to update as the package evolves. We are always open to and encourage feedback on these choices, and the package in general.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

#### Contributors
We thank [everyone](https://github.com/fivetran/dbt_snapchat_ads/graphs/contributors) who has taken the time to contribute. Each PR, bug report, and feature request has made this package better and is truly appreciated.

A special thank you to [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation), who we closely collaborated with to introduce native conversion support to our Ad packages.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_snapchat_ads/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).

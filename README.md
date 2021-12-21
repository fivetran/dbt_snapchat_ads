[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 
# Snapchat Ads 

This package models Snapchat Ads data from [Fivetran's connector](https://fivetran.com/docs/applications/snapchat-ads). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/snapchat-ads#schemainformation).

The main focus of the package is to transform the core ad object tables into analytics-ready models, including an 'ad adapter' model that can be easily unioned in to other ad platform packages to get a single view.  This is especially easy using our [Ad Reporting package](https://github.com/fivetran/dbt_ad_reporting).

## Models

This package contains transformation models, designed to work simultaneously with our [Snapchat Ads source package](https://github.com/fivetran/dbt_snapchat_ads_source) and our [multi-platform Ad Reporting package](https://github.com/fivetran/dbt_ad_reporting). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below.

| **model**                    | **description**                                                                                                        |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| snapchat__ad_adapter         | Each record represents the daily ad performance of each creative, including information about the used UTM parameters. |
| snapchat__account_report     | Each record represents the daily ad performance of each account.                                                       |
| snapchat__campaign_report    | Each record represents the daily ad performance of each campaign.                                                      |
| snapchat__ad_squad_report    | Each record represents the daily ad performance of each ad squad.                                                        |

## Installation Instructions

Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/snapchat_ads
    version: [">=0.3.0", "<0.4.0"]
```

## Configuration

By default, this package will look for your Snapchat Ads data in the `snapchat_ads` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Snapchat Ads data is, please add the following configuration to your 
`dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    snapchat_schema: your_schema_name
    snapchat_database: your_database_name 
```

For additional configurations for the source models, visit the [Snapchat Ads source package](https://github.com/fivetran/dbt_snapchat_ads_source).

### Changing the Build Schema

By default, this package will build the Snapchat Ads staging models within a schema titled (`<target_schema>` + `_stg_snapchat_ads`) and the final Snapchat Ads models within a schema titled (`<target_schema>` + `_snapchat_ads`) in your target database. If this is not where you would like your modeled Snapchat data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
    snapchat_ads:
        +schema: my_new_schema_name # leave blank for just the target_schema
    snapchat_ads_source:
        +schema: my_new_schema_name # leave blank for just the target_schema
```

## Contributions

Don't see a model or specific metric you would have liked to be included? Notice any bugs when installing and running the package? If so, we highly encourage and welcome contributions to this package! 
Please create issues or open PRs against `master`. See [the Discourse post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) for information on how to contribute to a package.

## Database Support

This package has been tested on BigQuery, Snowflake, Redshift, Postgres, and Databricks.

### Databricks Dispatch Configuration
dbt `v0.20.0` introduced a new project-level dispatch configuration that enables an "override" setting for all dispatched macros. If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
# dbt_project.yml

dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions, feedback, or need help? Book a time during our office hours [using Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate [dbt transformations with Fivetran](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

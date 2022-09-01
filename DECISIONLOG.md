# Snapchat Ads Decision Log
## Ads Associated with Multiple Ad Groups and Multiple Campaigns
An ad can be associated with multiple ad squads and therefore multiple campaigns on any given day. Therefore, `snapchat_ads__ad_report` doesn't contain ad_squad or campaign fields since it reports on an ad level. Similarly, `snapchat_ads__campaign_report` and `snapchat_ads__ad_squad_report` do not contain ad fields. This prevents overattributing performance to just one ad.

## UTM Filtering
This package contains a `snapchat_ads__url_report` which provides daily metrics for your utm compatible ads. It is important to note that not all Ads leverage utm parameters. Therefore, this package takes an opinionated approach to filter out any records that do not contain utm parameters or leverage a url within the ad.

If you would like to leverage a report that contains all ads and their daily metrics, I would suggest you leverage the snpapchat_ads__ad_report which does not apply any filtering.
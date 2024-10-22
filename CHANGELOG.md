## v1.0.0 [2024-10-22]

This mod now requires [Powerpipe](https://powerpipe.io). [Steampipe](https://steampipe.io) users should check the [migration guide](https://powerpipe.io/blog/migrating-from-steampipe).

## v0.13 [2024-03-06]

_Powerpipe_

[Powerpipe](https://powerpipe.io) is now the preferred way to run this mod!  [Migrating from Steampipe →](https://powerpipe.io/blog/migrating-from-steampipe)

All v0.x versions of this mod will work in both Steampipe and Powerpipe, but v1.0.0 onwards will be in Powerpipe format only.

_Enhancements_

- Focus documentation on Powerpipe commands.
- Show how to combine Powerpipe mods with Steampipe plugins.

## v0.12 [2024-01-22]

_What's new?_

- Added the `kubernetes_cluster_no_cluster_level_node_pool` control to the `Kubernetes` benchmark. ([#53](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/53))

## v0.11 [2023-11-30]

_What's new?_

- Added the following controls across the benchmarks: ([#49](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/49))
  - `bigquery_table_deletion_protection_enabled`
  - `bigtable_instance_deletion_protection_enabled`
  - `spanner_database_deletion_protection_enabled`
  - `spanner_database_drop_protection_enabled`

## v0.10 [2023-11-03]

_Breaking changes_

- Updated the plugin dependency section of the mod to use `min_version` instead of `version`. ([#45](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/45))

## v0.9 [2023-10-03]

_Enhancements_

- Updated the queries to use the `attributes_std` and `address` columns from the `terraform_resource` table instead of `arguments`, `type` and `name` columns for better support of terraform state files. ([#42](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/42))

_Dependencies_

- Terraform plugin `v0.10.0` or higher is now required. ([#42](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/42))

## v0.8 [2023-09-13]

_Enhancements_

- Added the `iam_workload_identity_restricted` control to the `IAM` benchmark: ([#38](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/38))

## v0.7 [2023-08-31]

_What's new?_

- Added 74 new controls across the benchmarks for the following services: ([#34](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/34))
  - `Artifact Registry Repository`
  - `BigQuery`
  - `Cloud Build`
  - `Cloud Function`
  - `Cloud Run`
  - `Compute`
  - `Dataflow`
  - `Data Fusion`
  - `Dataproc`
  - `DNS`
  - `IAM`
  - `KMS`
  - `Kubernetes`
  - `Logging`
  - `PubSub`
  - `Redis`
  - `Spanner`
  - `SQL`
  - `Storage`
  - `Vertex AI`

_Bug fixes_

- Fixed dashboard localhost URLs in README and index doc. ([#28](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/28))

  ## v0.6 [2023-06-15]

_What's new?_

- Added `connection_name` in the common dimensions to group and filter findings. (see [var.common_dimensions](https://hub.steampipe.io/mods/turbot/terraform_gcp_compliance/variables)) ([#25](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/25))
- Added `tags` as dimensions to group and filter findings. (see [var.tag_dimensions](https://hub.steampipe.io/mods/turbot/terraform_gcp_compliance/variables)) ([#25](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/25))

## v0.5 [2022-05-09]

_Enhancements_

- Updated docs/index.md and README with new dashboard screenshots and latest format. ([#20](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/20))

## v0.4 [2022-05-02]

_Enhancements_

- Added `category`, `service`, and `type` tags to benchmarks and controls. ([#15](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/15))

_Bug fixes_

- Fixed the `kubernetes_cluster_private_cluster_config_enabled` query to correctly identify public GKE clusters. ([#16](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/16))

## v0.3 [2022-03-17]

_Enhancements_

- Paths in control outputs now also include the starting line number for the resource

## v0.2 [2022-02-10]

_Enhancements_

- Updated `README.md` and `docs/index.md` with more detailed usage instructions

## v0.1 [2022-02-02]

_What's new?_

- Added 9 benchmarks and 55 controls to check Terraform GCP resources against security best practices. Controls for the following services have been added:
  - BigQuery
  - Cloud DNS
  - Cloud Logging
  - Cloud SQL
  - Cloud Storage
  - Compute Engine
  - IAM
  - KMS
  - Kubernetes Engine

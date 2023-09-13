## v0.8 [2023-09-13]

Added the `iam_workload_identity_restricted` control to the `IAM` benchmark: ([#38](https://github.com/turbot/steampipe-mod-terraform-gcp-compliance/pull/38))

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

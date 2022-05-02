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

locals {
  cloudrun_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/CloudRun"
  })
}

benchmark "cloudrun" {
  title       = "Cloud Run"
  description = "This benchmark provides a set of controls that detect Terraform GCP Cloud Run services deviating from security best practices."

  children = [
    control.cloudrun_not_publicly_accessible
  ]

  tags = merge(local.cloudrun_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "cloudrun_not_publicly_accessible" {
  title       = "Cloud Run services should not be publicly accessible"
  description = "This control checks whether Cloud Run services are not publicly accessible."
  query       = query.cloudrun_not_publicly_accessible

  tags = local.cloudrun_compliance_common_tags
}
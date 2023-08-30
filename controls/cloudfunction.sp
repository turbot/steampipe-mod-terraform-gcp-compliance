locals {
  cloudfunction_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/CloudFunction"
  })
}

benchmark "cloudfunction" {
  title       = "Cloud Function"
  description = "This benchmark provides a set of controls that detect Terraform GCP Cloud Function resources deviating from security best practices."

  children = [
    control.cloudfunction_not_publicly_accessible
  ]

  tags = merge(local.cloudfunction_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "cloudfunction_not_publicly_accessible" {
  title       = "Cloud Function should not be publicly accessible"
  description = "This control checks whether Cloud Function is publicly accessible."
  query       = query.cloudfunction_not_publicly_accessible

  tags = local.cloudfunction_compliance_common_tags
}
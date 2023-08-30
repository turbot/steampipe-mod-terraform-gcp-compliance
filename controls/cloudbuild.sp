locals {
  cloudbuild_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/CloudBuild"
  })
}

benchmark "cloudbuild" {
  title       = "Cloud Build"
  description = "This benchmark provides a set of controls that detect Terraform GCP Cloud build resources deviating from security best practices."

  children = [
    control.cloudbuild_workers_use_private_ip
  ]

  tags = merge(local.cloudbuild_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "cloudbuild_workers_use_private_ip" {
  title       = "Cloud Build workers should use private IP addresses"
  description = "This control checks whether Cloud Build workers are configured to use private IP addresses."
  query       = query.cloudbuild_workers_use_private_ip

  tags = local.cloudbuild_compliance_common_tags
}
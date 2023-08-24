locals {
  datafusioninstance_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/DataFusionInstance"
  })
}

benchmark "datafusioninstance" {
  title       = "DataFusionInstance"
  description = "This benchmark provides a set of controls that detect Terraform GCP Data Fusion instance resources deviating from security best practices."

  children = [
    control.datafusioninstance_not_publicly_accessible,
    control.datafusioninstance_stackdriver_logging_enabled,
    control.datafusioninstance_stackdriver_monitoring_enabled
  ]

  tags = merge(local.datafusioninstance_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "datafusioninstance_not_publicly_accessible" {
  title       = "Data Fusion Instance should not be publicly accessible"
  description = "This control checks whether Data Fusion Instance is not public."
  query       = query.datafusioninstance_not_publicly_accessible

  tags = local.datafusioninstance_compliance_common_tags
}

control "datafusioninstance_stackdriver_logging_enabled" {
  title       = "Data Fusion Instance should have Stackdriver Logging enabled"
  description = "This control checks whether Data Fusion Instance has Stackdriver Logging enabled."
  query       = query.datafusioninstance_stackdriver_logging_enabled

  tags = local.datafusioninstance_compliance_common_tags
}

control "datafusioninstance_stackdriver_monitoring_enabled" {
  title       = "Data Fusion Instance should have Stackdriver Monitoring enabled"
  description = "This control checks whether Data Fusion Instance has Stackdriver Monitoring enabled."
  query       = query.datafusioninstance_stackdriver_monitoring_enabled

  tags = local.datafusioninstance_compliance_common_tags
}
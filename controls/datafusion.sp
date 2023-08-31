locals {
  datafusion_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/DataFusion"
  })
}

benchmark "datafusion" {
  title       = "Data Fusion"
  description = "This benchmark provides a set of controls that detect Terraform GCP Data Fusion resources deviating from security best practices."

  children = [
    control.datafusion_instance_not_publicly_accessible,
    control.datafusion_instance_stackdriver_logging_enabled,
    control.datafusion_instance_stackdriver_monitoring_enabled
  ]

  tags = merge(local.datafusion_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "datafusion_instance_not_publicly_accessible" {
  title       = "Data Fusion instance should not be publicly accessible"
  description = "This control checks whether Data Fusion instance is not public."
  query       = query.datafusion_instance_not_publicly_accessible

  tags = local.datafusion_compliance_common_tags
}

control "datafusion_instance_stackdriver_logging_enabled" {
  title       = "Data Fusion instance should have Stackdriver Logging enabled"
  description = "This control checks whether Data Fusion instance has Stackdriver Logging enabled."
  query       = query.datafusion_instance_stackdriver_logging_enabled

  tags = local.datafusion_compliance_common_tags
}

control "datafusion_instance_stackdriver_monitoring_enabled" {
  title       = "Data Fusion instance should have Stackdriver Monitoring enabled"
  description = "This control checks whether Data Fusion instance has Stackdriver Monitoring enabled."
  query       = query.datafusion_instance_stackdriver_monitoring_enabled

  tags = local.datafusion_compliance_common_tags
}

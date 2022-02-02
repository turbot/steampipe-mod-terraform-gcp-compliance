locals {
  kubernetes_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "kubernetes"
  })
}

benchmark "kubernetes" {
  title       = "Kubernetes Engine"
  description = "This benchmark provides a set of controls that detect Terraform GCP Kubernetes Engine(GKE) resources deviating from security best practices."

  children = [
    control.kubernetes_cluster_auto_repair_enabled,
    control.kubernetes_cluster_auto_upgrade_enabled,
    control.kubernetes_cluster_legacy_abac_enabled,
    control.kubernetes_cluster_legacy_endpoints_disabled,
    control.kubernetes_cluster_network_policy_installed,
    control.kubernetes_cluster_node_config_image_cos_containerd,
    control.kubernetes_cluster_private_cluster_config_enabled
  ]

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_private_cluster_config_enabled" {
  title         = "Verify all GKE clusters are Private Clusters"
  description   = ""
  sql           = query.kubernetes_cluster_private_cluster_config_enabled.sql

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1   = "true"
  })
}

control "kubernetes_cluster_legacy_abac_enabled" {
  title         = "Ensure Legacy Authorization is set to Disabled on Kubernetes Engine Clusters"
  sql           = query.kubernetes_cluster_legacy_abac_enabled.sql

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1   = "true"
  })
}

control "kubernetes_cluster_legacy_endpoints_disabled" {
  title         = "Check that legacy metadata endpoints are disabled on Kubernetes clusters(disabled by default since GKE 1.12+)"
  sql           = query.kubernetes_cluster_legacy_endpoints_disabled.sql

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1   = "true"
  })
}

control "kubernetes_cluster_auto_repair_enabled" {
  title         = "Ensure automatic node repair is enabled on all node pools in a GKE cluster"
  sql           = query.kubernetes_cluster_auto_repair_enabled.sql

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1   = "true"
  })
}

control "kubernetes_cluster_auto_upgrade_enabled" {
  title         = "Ensure Automatic node upgrades is enabled on Kubernetes Engine Clusters nodes"
  sql           = query.kubernetes_cluster_auto_upgrade_enabled.sql

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1   = "true"
  })
}

control "kubernetes_cluster_node_config_image_cos_containerd" {
  title         = "Ensure Container-Optimized OS (cos) is used for Kubernetes engine clusters"
  sql           = query.kubernetes_cluster_node_config_image_cos_containerd.sql

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1   = "true"
  })
}

control "kubernetes_cluster_network_policy_installed" {
  title         = "Check that GKE clusters have a Network Policy installed"
  sql           = query.kubernetes_cluster_network_policy_installed.sql

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1   = "true"
  })
}
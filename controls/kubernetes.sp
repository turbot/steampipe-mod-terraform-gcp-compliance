locals {
  kubernetes_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/Kubernetes"
  })
}

benchmark "kubernetes" {
  title       = "Kubernetes"
  description = "This benchmark provides a set of controls that detect Terraform GCP Kubernetes Engine(GKE) resources deviating from security best practices."

  children = [
    control.kubernetes_cluster_auto_repair_enabled,
    control.kubernetes_cluster_auto_upgrade_enabled,
    control.kubernetes_cluster_legacy_abac_enabled,
    control.kubernetes_cluster_legacy_endpoints_disabled,
    control.kubernetes_cluster_network_policy_installed,
    control.kubernetes_cluster_node_config_image_cos_containerd,
    control.kubernetes_cluster_private_cluster_config_enabled,
    control.kubernetes_cluster_shielded_nodes_enabled,
    control.kubernetes_cluster_stackdriver_logging_enabled,
    control.kubernetes_cluster_stackdriver_monitoring_enabled,
    control.kubernetes_cluster_metadata_server_enabled,
    control.kubernetes_cluster_master_authorized_network_enabled,
    control.kubernetes_cluster_authenticator_group_configured,
    control.kubernetes_cluster_resource_label_configured,
    control.kubernetes_cluster_client_certificate_authentication_disabled,
    control.kubernetes_cluster_binary_auth_enabled,
    control.kubernetes_cluster_release_channel_configured,
    control.kubernetes_cluster_alias_ip_range_enabled,
    control.kubernetes_cluster_intranode_visibility_enabled,
    control.kubernetes_cluster_control_plane_restrict_public_access,
    control.kubernetes_cluster_shielded_node_secure_boot_enabled,
    control.kubernetes_cluster_shielded_node_integrity_monitoring_enabled,
    control.kubernetes_cluster_cos_node_image
  ]

  tags = merge(local.kubernetes_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "kubernetes_cluster_private_cluster_config_enabled" {
  title = "Verify all GKE clusters are Private Clusters"
  query = query.kubernetes_cluster_private_cluster_config_enabled

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1 = "true"
  })
}

control "kubernetes_cluster_legacy_abac_enabled" {
  title = "Ensure Legacy Authorization is set to Disabled on Kubernetes Engine Clusters"
  query = query.kubernetes_cluster_legacy_abac_enabled

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1 = "true"
  })
}

control "kubernetes_cluster_legacy_endpoints_disabled" {
  title = "Check that legacy metadata endpoints are disabled on Kubernetes clusters(disabled by default since GKE 1.12+)"
  query = query.kubernetes_cluster_legacy_endpoints_disabled

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1 = "true"
  })
}

control "kubernetes_cluster_auto_repair_enabled" {
  title = "Ensure automatic node repair is enabled on all node pools in a GKE cluster"
  query = query.kubernetes_cluster_auto_repair_enabled

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1 = "true"
  })
}

control "kubernetes_cluster_auto_upgrade_enabled" {
  title = "Ensure Automatic node upgrades is enabled on Kubernetes Engine Clusters nodes"
  query = query.kubernetes_cluster_auto_upgrade_enabled

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1 = "true"
  })
}

control "kubernetes_cluster_node_config_image_cos_containerd" {
  title = "Ensure Container-Optimized OS (cos) is used for Kubernetes engine clusters"
  query = query.kubernetes_cluster_node_config_image_cos_containerd

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1 = "true"
  })
}

control "kubernetes_cluster_network_policy_installed" {
  title = "Check that GKE clusters have a Network Policy installed"
  query = query.kubernetes_cluster_network_policy_installed

  tags = merge(local.kubernetes_compliance_common_tags, {
    cft_scorecard_v1 = "true"
  })
}

control "kubernetes_cluster_stackdriver_logging_enabled" {
  title = "GKE clusters stackdriver logging should be enabled"
  query = query.kubernetes_cluster_stackdriver_logging_enabled

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_shielded_nodes_enabled" {
  title = "GKE clusters shielded nodes should be enabled"
  query = query.kubernetes_cluster_shielded_nodes_enabled

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_stackdriver_monitoring_enabled" {
  title = "GKE clusters stackdriver monitoring should be enabled"
  query = query.kubernetes_cluster_stackdriver_monitoring_enabled

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_metadata_server_enabled" {
  title = "GKE clusters GKE metadata server should be enabled"
  query = query.kubernetes_cluster_metadata_server_enabled

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_master_authorized_network_enabled" {
  title = "GKE clusters master authorized networks should be enabled"
  query = query.kubernetes_cluster_master_authorized_network_enabled

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_authenticator_group_configured" {
  title = "GKE clusters authenticator group should be configured to manage RBAC users"
  query = query.kubernetes_cluster_authenticator_group_configured

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_resource_label_configured" {
  title = "GKE clusters resource labels should be configured"
  query = query.kubernetes_cluster_resource_label_configured

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_client_certificate_authentication_disabled" {
  title = "GKE clusters client certificate authentication should be disabled"
  query = query.kubernetes_cluster_client_certificate_authentication_disabled

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_binary_auth_enabled" {
  title = "GKE clusters client binary authorizationn should be enabled"
  query = query.kubernetes_cluster_binary_auth_enabled

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_release_channel_configured" {
  title = "GKE clusters release channel should be configured"
  query = query.kubernetes_cluster_release_channel_configured

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_alias_ip_range_enabled" {
  title = "GKE clusters alias IP ranges should be enabled"
  query = query.kubernetes_cluster_alias_ip_range_enabled

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_intranode_visibility_enabled" {
  title = "GKE clusters intranode visibilits should be enabled"
  query = query.kubernetes_cluster_intranode_visibility_enabled

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_control_plane_restrict_public_access" {
  title = "GKE clusters control plane should restrict public access"
  query = query.kubernetes_cluster_control_plane_restrict_public_access

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_shielded_node_secure_boot_enabled" {
  title = "GKE clusters secure boot should be enabled for shielded nodes"
  query = query.kubernetes_cluster_shielded_node_secure_boot_enabled

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_shielded_node_integrity_monitoring_enabled" {
  title = "GKE clusters integrity monitoring should be enabled for shielded nodes"
  query = query.kubernetes_cluster_shielded_node_integrity_monitoring_enabled

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_cos_node_image" {
  title = "GKE clusters should use Container-Optimized OS(cos) node image"
  query = query.kubernetes_cluster_cos_node_image

  tags = local.kubernetes_compliance_common_tags
}


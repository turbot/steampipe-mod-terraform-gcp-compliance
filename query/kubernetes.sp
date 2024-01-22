query "kubernetes_cluster_auto_upgrade_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'management' ->> 'auto_upgrade')::boolean then 'ok' else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'management') is null then ' ''management'' is not defined'
        when (attributes_std -> 'management' ->> 'auto_upgrade') is null then ' ''management.auto_upgrade'' is not defined'
        when (attributes_std -> 'management' ->> 'auto_upgrade')::boolean then ' node pool auto upgrade enabled'
        else ' node pool auto upgrade disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_node_pool';
  EOQ
}

query "kubernetes_cluster_legacy_abac_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'enable_legacy_abac')::boolean then 'ok' else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'enable_legacy_abac') is null then ' ''enable_legacy_abac'' is not defined'
        when (attributes_std ->> 'enable_legacy_abac')::boolean then ' legacy authorization enabled'
        else ' legacy authorization disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_legacy_endpoints_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'node_config' -> 'metadata' ->> 'disable-legacy-endpoints') = 'true' then 'ok' else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'node_config') is null then ' ''node_config'' is not defined'
        when (attributes_std -> 'node_config' -> 'metadata') is null then ' ''node_config.metadata'' is not defined'
        when coalesce(trim((attributes_std -> 'node_config' -> 'metadata' ->> 'disable-legacy-endpoints')), '') = ''
        then ' ''node_config.metadata.disable-legacy-endpoints'' is not defined'
        when (attributes_std -> 'node_config' -> 'metadata' ->> 'disable-legacy-endpoints') = 'true' then ' legacy endpoints disabled'
        else ' legacy endpoints enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_node_config_image_cos_containerd" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'node_config' ->> 'image_type') = 'COS_CONTAINERD' then 'ok' else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'node_config') is null then ' ''node_config'' is not defined'
        when coalesce(trim((attributes_std -> 'node_config' ->> 'image_type')), '') = '' then ' ''node_config.image_type'' is not defined'
        when (attributes_std -> 'node_config' ->> 'image_type') = 'COS_CONTAINERD' then ' Container-Optimized OS(COS) is used'
        else ' Container-Optimized OS(COS) not used'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_network_policy_installed" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'network_policy') is not null then 'ok' else 'alarm'
      end as status,
      name || case
        when (attributes_std -> 'network_policy') is not null then ' network policy defined'
        else ' network policy not defined'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_auto_repair_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'management' ->> 'auto_repair')::boolean then 'ok' else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'management') is null then ' ''management'' is not defined'
        when (attributes_std -> 'management' ->> 'auto_repair') is null then ' ''management.auto_repair'' is not defined'
        when (attributes_std -> 'management' ->> 'auto_repair')::boolean then ' node pool auto repair enabled'
        else ' node pool auto repair disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_node_pool';
  EOQ
}

query "kubernetes_cluster_private_cluster_config_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'private_cluster_config') is null then 'alarm'
        when (attributes_std -> 'private_cluster_config' -> 'enable_private_nodes') is null then 'alarm'
        when (attributes_std -> 'private_cluster_config' -> 'enable_private_nodes')::bool then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'private_cluster_config') is null then ' private cluster config disabled'
        when (attributes_std -> 'private_cluster_config' -> 'enable_private_nodes') is null then ' ''enable_private_nodes'' not defined'
        when (attributes_std -> 'private_cluster_config' -> 'enable_private_nodes')::bool then ' private cluster config enabled'
        else ' private cluster config disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_stackdriver_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'logging_service') = 'none' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'logging_service') = 'none' then ' stackdriver logging disabled'
        else ' stackdriver logging enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_shielded_nodes_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'enable_shielded_nodes') = 'false' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'enable_shielded_nodes') = 'false' then ' shielded nodes disabled'
        else ' shielded nodes enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_stackdriver_monitoring_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'monitoring_service') = 'none' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'monitoring_service') = 'none' then ' stackdriver monitoring disabled'
        else ' stackdriver monitoring enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_metadata_server_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'node_config') is null then 'alarm'
        when (attributes_std -> 'node_config' -> 'workload_metadata_config') is null then 'alarm'
        when (attributes_std -> 'node_config' -> 'workload_metadata_config' ->> 'mode') = 'GKE_METADATA' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'node_config') is null then ' node config not defined'
        when (attributes_std -> 'node_config' -> 'workload_metadata_config') is null then ' workload metadata config not defined'
        when (attributes_std -> 'node_config' -> 'workload_metadata_config' ->> 'mode') = 'GKE_METADATA'  then ' GKE metadata server enabled'
        else ' GKE metadata server disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_container_node_pool', 'google_container_cluster');
  EOQ
}

query "kubernetes_cluster_master_authorized_network_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'master_authorized_networks_config') = '{}' then 'alarm'
        when (attributes_std -> 'master_authorized_networks_config') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'master_authorized_networks_config') = '{}' then ' master authorized network not defined'
        when (attributes_std -> 'master_authorized_networks_config') is not null then ' master authorized network enabled'
        else ' master authorized network disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_authenticator_group_configured" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'authenticator_groups_config' -> 'security_group') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'authenticator_groups_config' -> 'security_group') is not null then ' authenticator group configured'
        else ' authenticator group not configured'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_resource_label_configured" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'resource_labels' -> 'key') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'resource_labels' -> 'key') is not null then ' labels configured'
        else ' labels not configured'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_client_certificate_authentication_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'master_auth' -> 'client_certificate_config' -> 'issue_client_certificate') is null then 'alarm'
        when (attributes_std -> 'master_auth' -> 'client_certificate_config' ->> 'issue_client_certificate') = 'false' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'master_auth' -> 'client_certificate_config' -> 'issue_client_certificate') is null then ' client certificate authentication not defined'
        when (attributes_std -> 'master_auth' -> 'client_certificate_config' ->> 'issue_client_certificate') = 'false' then ' client certificate authentication disabled'
        else ' client certificate authentication enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_binary_auth_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std -> 'enable_binary_authorization') is null) and ((attributes_std -> 'binary_authorization') is null) then 'alarm'
        when (attributes_std ->> 'enable_binary_authorization') = 'true' then 'ok'
        when (attributes_std -> 'binary_authorization' ->> 'evaluation_mode') = 'PROJECT_SINGLETON_POLICY_ENFORCE' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'enable_binary_authorization') is null and (attributes_std -> 'binary_authorization') is null then ' binary authorization not defined'
        when (attributes_std ->> 'enable_binary_authorization') = 'true' then ' binary authorization enabled'
        when (attributes_std -> 'binary_authorization' ->> 'evaluation_mode') = 'PROJECT_SINGLETON_POLICY_ENFORCE' then ' binary authorization enabled'
        else ' binary authorization disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_release_channel_configured" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'release_channel') is null then 'alarm'
        when (attributes_std -> 'release_channel' ->> 'channel') = 'UNSPECIFIED' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'release_channel') is null then ' release channel not defined'
        when (attributes_std -> 'release_channel' ->> 'channel') = 'UNSPECIFIED' then ' release channel not set'
        else ' release channel set'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_alias_ip_range_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std -> 'ip_allocation_policy') is not null) and ((attributes_std ->> 'ip_allocation_policy') <> '{}') then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'ip_allocation_policy') is not null and ((attributes_std ->> 'ip_allocation_policy') <> '{}') then ' alias IP range enabled'
        else ' alias IP range disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_intranodal_visibility_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'enable_intranode_visibility') = 'true' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'enable_intranode_visibility') = 'true' then ' intranodal visibility enabled'
        else ' intranodal visibility disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_control_plane_restrict_public_access" {
  sql = <<-EOQ
    with public_control_plane as (
      select
        distinct address
      from
        terraform_resource,
        jsonb_array_elements(
          case
            jsonb_typeof(attributes_std -> 'master_authorized_networks_config' -> 'cidr_blocks')
            when 'array' then (attributes_std -> 'master_authorized_networks_config' -> 'cidr_blocks')
            when 'object' then jsonb_build_array(attributes_std -> 'master_authorized_networks_config' -> 'cidr_blocks')
            else null
          end
        ) as s
      where
        type = 'google_container_cluster'
        and s ->> 'cidr_block' = '0.0.0.0/0'
    )
    select
      r.address as resource,
      case
        when p.address is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when p.address is null then ' control plane not publicly accessible'
        else ' control plane publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join public_control_plane as p on p.address = r.address
    where
      type = 'google_container_cluster';
  EOQ
}

query "kubernetes_cluster_shielded_node_secure_boot_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'node_config' -> 'shielded_instance_config' ->> 'enable_secure_boot') = 'true' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'node_config' -> 'shielded_instance_config' ->> 'enable_secure_boot') = 'true' then ' secure boot enabled for shielded nodes'
        else ' secure boot disabled for shielded nodes'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_container_node_pool', 'google_container_cluster');
  EOQ
}

query "kubernetes_cluster_shielded_node_integrity_monitoring_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'node_config' -> 'shielded_instance_config' ->> 'enable_integrity_monitoring') = 'false' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'node_config' -> 'shielded_instance_config' ->> 'enable_integrity_monitoring') = 'false' then ' integrity monitoring disabled for shielded nodes'
        else ' integrity monitoring enabled for shielded nodes'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_container_node_pool', 'google_container_cluster');
  EOQ
}

query "kubernetes_cluster_cos_node_image" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'node_config' -> 'image_type') is null then 'alarm'
        when (attributes_std -> 'node_config' ->> 'image_type') ilike 'COS_%' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'node_config' -> 'image_type') is null then ' node image type not defined'
        when (attributes_std -> 'node_config' ->> 'image_type') ilike 'COS_%' then ' COS node image type used'
        else ' COS node image type not used'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_container_node_pool', 'google_container_cluster');
  EOQ
}

query "kubernetes_cluster_no_cluster_level_node_pool" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'node_pool') is not null then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'node_pool') is not null then ' node pool defined in cluster configuration'
        else ' node pool not defined in cluster configuration'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_container_cluster';
  EOQ
}
query "kubernetes_cluster_auto_upgrade_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'management' ->> 'auto_upgrade')::boolean then 'ok' else 'alarm'
      end as status,
      name || case
        when (arguments -> 'management') is null then ' ''management'' is not defined'
        when (arguments -> 'management' ->> 'auto_upgrade') is null then ' ''management.auto_upgrade'' is not defined'
        when (arguments -> 'management' ->> 'auto_upgrade')::boolean then ' node pool auto upgrade enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'enable_legacy_abac')::boolean then 'ok' else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'enable_legacy_abac') is null then ' ''enable_legacy_abac'' is not defined'
        when (arguments ->> 'enable_legacy_abac')::boolean then ' legacy authorization enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'node_config' -> 'metadata' ->> 'disable-legacy-endpoints') = 'true' then 'ok' else 'alarm'
      end as status,
      name || case
        when (arguments -> 'node_config') is null then ' ''node_config'' is not defined'
        when (arguments -> 'node_config' -> 'metadata') is null then ' ''node_config.metadata'' is not defined'
        when coalesce(trim((arguments -> 'node_config' -> 'metadata' ->> 'disable-legacy-endpoints')), '') = ''
        then ' ''node_config.metadata.disable-legacy-endpoints'' is not defined'
        when (arguments -> 'node_config' -> 'metadata' ->> 'disable-legacy-endpoints') = 'true' then ' legacy endpoints disabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'node_config' ->> 'image_type') = 'COS_CONTAINERD' then 'ok' else 'alarm'
      end as status,
      name || case
        when (arguments -> 'node_config') is null then ' ''node_config'' is not defined'
        when coalesce(trim((arguments -> 'node_config' ->> 'image_type')), '') = '' then ' ''node_config.image_type'' is not defined'
        when (arguments -> 'node_config' ->> 'image_type') = 'COS_CONTAINERD' then ' Container-Optimized OS(COS) is used'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'network_policy') is not null then 'ok' else 'alarm'
      end as status,
      name || case
        when (arguments -> 'network_policy') is not null then ' network policy defined'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'management' ->> 'auto_repair')::boolean then 'ok' else 'alarm'
      end as status,
      name || case
        when (arguments -> 'management') is null then ' ''management'' is not defined'
        when (arguments -> 'management' ->> 'auto_repair') is null then ' ''management.auto_repair'' is not defined'
        when (arguments -> 'management' ->> 'auto_repair')::boolean then ' node pool auto repair enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'private_cluster_config') is null then 'alarm' 
        when (arguments -> 'private_cluster_config' -> 'enable_private_nodes') is null then 'alarm'
        when (arguments -> 'private_cluster_config' -> 'enable_private_nodes')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'private_cluster_config') is null then ' private cluster config disabled'
        when (arguments -> 'private_cluster_config' -> 'enable_private_nodes') is null then ' ''enable_private_nodes'' not defined'
        when (arguments -> 'private_cluster_config' -> 'enable_private_nodes')::bool then ' private cluster config enabled'
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

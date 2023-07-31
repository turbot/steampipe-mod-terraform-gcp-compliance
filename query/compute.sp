query "compute_instance_oslogin_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'metadata') is null then 'alarm'
        when (arguments -> 'metadata' -> 'enable-oslogin') is null then 'alarm'
        when (arguments -> 'metadata' ->> 'enable-oslogin') = 'true' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'metadata') is null then ' ''metadata'' property is not defined'
        when (arguments -> 'metadata' -> 'enable-oslogin') is null then ' ''enable-oslogin'' property is not defined'
        when (arguments -> 'metadata' ->> 'enable-oslogin') = 'true' then ' has OS login enabled'
        else ' has OS login disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_instance';
  EOQ
}

query "compute_instance_with_no_default_service_account" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'service_account') is null then 'alarm'
        when (arguments -> 'service_account' ->> 'email') like '%-compute@developer.gserviceaccount.com' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'service_account') is null then ' not configured with default service account'
        when (arguments -> 'service_account' ->> 'email') like '%-compute@developer.gserviceaccount.com' then ' configured to use default service account'
        else ' not configured with default service account'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_instance';
  EOQ
}

query "compute_instance_with_no_default_service_account_with_full_access" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'service_account') is null then 'alarm'
        when (arguments -> 'service_account' ->> 'email') not like '%-compute@developer.gserviceaccount.com' then 'alarm'
        when (arguments -> 'service_account' ->> 'email') like '%-compute@developer.gserviceaccount.com' and (arguments -> 'service_account' ->> 'scopes') like '%cloud-platform%' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'service_account') is null then ' not configured with default service account'
        when (arguments -> 'service_account' ->> 'email') not like '%-compute@developer.gserviceaccount.com' then ' not configured with default service account'
        when (arguments -> 'service_account' ->> 'email') like '%-compute@developer.gserviceaccount.com' and (arguments -> 'service_account' ->> 'scopes') like '%cloud-platform%' then ' configured to use default service account with full access'
        else ' not configured with default service account with full access'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_instance';
  EOQ
}

query "compute_network_contains_no_default_network" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when name not ilike 'default' then 'ok'
        else 'alarm'
      end status,
      name || case
        when name not ilike 'default' and (arguments ->> 'project') is not null then ' ' || (arguments ->> 'project') || ' is not using default network'
        when name not ilike 'default' and (arguments ->> 'project') is null then ' provider project is not using default network'
        when name ilike 'default' and (arguments ->> 'project') is null then ' provider project is using default network'
        when name ilike 'default' and (arguments ->> 'project') is not null then ' ' || (arguments ->> 'project') || ' is using default network'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_network';
  EOQ
}

query "compute_disk_encrypted_with_csk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'disk_encryption_key') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'disk_encryption_key') is null then 'not encrypted with Customer Supplied Key'
        else ' encrypted with Customer Supplied Key'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_disk';
  EOQ
}

query "compute_network_contains_no_legacy_network" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'auto_create_subnetworks') is null then 'ok'
        when (arguments -> 'auto_create_subnetworks')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'auto_create_subnetworks') is null then ' is not a legacy network'
        when (arguments -> 'auto_create_subnetworks')::bool then ' is not a legacy network'
        else ' is a legacy network'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_network';
  EOQ
}

query "compute_subnetwork_flow_log_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'log_config') is not null then 'ok' else 'alarm'
      end as status,
      name || case
        when (arguments -> 'log_config') is not null then ' flow logging enabled'
        else ' flow logging disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_subnetwork';
  EOQ
}

query "compute_instance_confidential_computing_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'confidential_instance_config') is null then 'alarm'
        when (arguments -> 'confidential_instance_config' -> 'enable_confidential_compute')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'confidential_instance_config') is null then ' confidential computing disabled'
        when (arguments -> 'confidential_instance_config' -> 'enable_confidential_compute')::bool then ' confidential computing enabled'
        else ' confidential computing disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_instance';
  EOQ
}

query "compute_subnetwork_private_ip_google_access" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'private_ip_google_access')::boolean then 'ok' else 'alarm'
      end as status,
      name || case
        when (arguments -> 'private_ip_google_access') is null then ' ''private_ip_google_access'' is not defined'
        when (arguments ->> 'private_ip_google_access')::boolean then ' private Google Access is enabled'
        else ' private Google Access is disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_subnetwork';
  EOQ
}

query "compute_instance_serial_port_connection_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'metadata') is null then 'alarm'
        when (arguments -> 'metadata' -> 'serial-port-enable') is null then 'alarm'
        when (arguments -> 'metadata' ->> 'serial-port-enable') = 'true' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'metadata') is null then ' ''metadata'' property is not defined'
        when (arguments -> 'metadata' -> 'serial-port-enable') is null then ' ''serial-port-enable'' property is not defined'
        when (arguments -> 'metadata' ->> 'serial-port-enable') = 'true' then ' has serial port connections enabled'
        else ' has serial port connections disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_instance';
  EOQ
}

query "compute_instance_shielded_vm_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'shielded_instance_config') is null then 'alarm'
        when (arguments -> 'shielded_instance_config' -> 'enable_integrity_monitoring')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'shielded_instance_config') is null then ' shielded VM disabled'
        when (arguments -> 'shielded_instance_config' -> 'enable_integrity_monitoring')::bool then ' shielded VM enabled'
        else ' shielded VM disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_instance';
  EOQ
}

query "compute_instance_block_project_wide_ssh_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'metadata') is null then 'alarm'
        when (arguments -> 'metadata' -> 'block-project-ssh-keys') is null then 'alarm'
        when (arguments -> 'metadata' ->> 'block-project-ssh-keys') = 'true' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'metadata') is null then ' ''metadata'' property is not defined'
        when (arguments -> 'metadata' -> 'block-project-ssh-keys') is null then ' ''block-project-ssh-keys'' property is not defined'
        when (arguments -> 'metadata' ->> 'block-project-ssh-keys') = 'true' then ' has Block Project-wide SSH keys enabled'
        else ' has Block Project-wide SSH keys disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_instance';
  EOQ
}

query "compute_instance_ip_forwarding_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'can_ip_forward') is null then 'alarm'
        when (arguments -> 'can_ip_forward')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'can_ip_forward') is null then ' IP forwarding disabled'
        when (arguments -> 'can_ip_forward')::bool then ' IP forwarding enabled'
        else ' IP forwarding disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_instance';
  EOQ
}

query "compute_instance_with_no_public_ip_addresses" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'network_interface' -> 'access_config') is null or (arguments -> 'network_interface' ->> 'access_config') like '{}' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'network_interface' -> 'access_config') is null or (arguments -> 'network_interface' ->> 'access_config') like '{}' then ' not associated with public IP addresses'
        else ' associated with public IP addresses'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_instance';
  EOQ
}
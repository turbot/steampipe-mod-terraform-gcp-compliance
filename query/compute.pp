query "compute_instance_oslogin_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'metadata') is null then 'alarm'
        when (attributes_std -> 'metadata' -> 'enable-oslogin') is null then 'alarm'
        when (attributes_std -> 'metadata' ->> 'enable-oslogin') = 'true' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'metadata') is null then ' ''metadata'' property is not defined'
        when (attributes_std -> 'metadata' -> 'enable-oslogin') is null then ' ''enable-oslogin'' property is not defined'
        when (attributes_std -> 'metadata' ->> 'enable-oslogin') = 'true' then ' has OS login enabled'
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
      address as resource,
      case
        when (attributes_std -> 'service_account') is null and (attributes_std -> 'source_instance_template') is null then 'skip'
        when (attributes_std -> 'service_account') is null and (attributes_std -> 'source_instance_template') is not null then 'skip'
        when (attributes_std -> 'service_account') is not null and (attributes_std -> 'service_account' ->> 'email') is null then 'alarm'
        when (attributes_std ->> 'name') like 'gke-%' and (attributes_std -> 'service_account' ->> 'email') like '%-compute@developer.gserviceaccount.com' then 'ok'
        when (attributes_std -> 'service_account' ->> 'email') not like '%-compute@developer.gserviceaccount.com' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'service_account') is null and (attributes_std -> 'source_instance_template') is null then ' no service account configured'
        when (attributes_std -> 'service_account') is null and (attributes_std -> 'source_instance_template') is not null then ' has no service account in the instance template'
        when (attributes_std -> 'service_account') is not null and (attributes_std -> 'service_account' ->> 'email') is null then ' does not have email configured in service account'
        when (attributes_std ->> 'name') like 'gke-%' then ' configured to use default service account'
        when (attributes_std -> 'service_account' ->> 'email') not like '%-compute@developer.gserviceaccount.com' then ' not use default service account'
        else ' use default service account'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_compute_instance', 'google_compute_instance_from_template', 'google_compute_instance_template');
  EOQ
}

query "compute_instance_with_no_default_service_account_with_full_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'service_account') is null then 'alarm'
        when (attributes_std -> 'service_account' ->> 'email') not like '%-compute@developer.gserviceaccount.com' then 'alarm'
        when (attributes_std -> 'service_account' ->> 'email') like '%-compute@developer.gserviceaccount.com' and (attributes_std -> 'service_account' ->> 'scopes') like '%cloud-platform%' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'service_account') is null then ' not configured with default service account'
        when (attributes_std -> 'service_account' ->> 'email') not like '%-compute@developer.gserviceaccount.com' then ' not configured with default service account'
        when (attributes_std -> 'service_account' ->> 'email') like '%-compute@developer.gserviceaccount.com' and (attributes_std -> 'service_account' ->> 'scopes') like '%cloud-platform%' then ' configured to use default service account with full access'
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
      address as resource,
      case
        when name not ilike 'default' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when name not ilike 'default' and (attributes_std ->> 'project') is not null then ' ' || (attributes_std ->> 'project') || ' is not using default network'
        when name not ilike 'default' and (attributes_std ->> 'project') is null then ' provider project is not using default network'
        when name ilike 'default' and (attributes_std ->> 'project') is null then ' provider project is using default network'
        when name ilike 'default' and (attributes_std ->> 'project') is not null then ' ' || (attributes_std ->> 'project') || ' is using default network'
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
      address as resource,
      case
        when (attributes_std -> 'disk_encryption_key') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'disk_encryption_key') is null then 'not encrypted with Customer Supplied Key'
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
      address as resource,
      case
        when (attributes_std -> 'auto_create_subnetworks') is null then 'ok'
        when (attributes_std -> 'auto_create_subnetworks')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'auto_create_subnetworks') is null then ' is not a legacy network'
        when (attributes_std -> 'auto_create_subnetworks')::bool then ' is not a legacy network'
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
      address as resource,
      case
        when (attributes_std ->> 'purpose') in ('REGIONAL_MANAGED_PROXY', 'GLOBAL_MANAGED_PROXY') then 'skip'
        when (attributes_std -> 'log_config') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'purpose') in ('REGIONAL_MANAGED_PROXY', 'GLOBAL_MANAGED_PROXY') then ' flow logging not supported'
        when (attributes_std -> 'log_config') is not null then ' flow logging enabled'
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
      address as resource,
      case
        when (attributes_std -> 'confidential_instance_config') is null then 'alarm'
        when (attributes_std -> 'confidential_instance_config' -> 'enable_confidential_compute')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'confidential_instance_config') is null then ' confidential computing disabled'
        when (attributes_std -> 'confidential_instance_config' -> 'enable_confidential_compute')::bool then ' confidential computing enabled'
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
      address as resource,
      case
        when (attributes_std ->> 'private_ip_google_access')::boolean then 'ok' else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'private_ip_google_access') is null then ' ''private_ip_google_access'' is not defined'
        when (attributes_std ->> 'private_ip_google_access')::boolean then ' private Google Access is enabled'
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
      address as resource,
      case
        when (attributes_std -> 'metadata') is null then 'alarm'
        when (attributes_std -> 'metadata' -> 'serial-port-enable') is null then 'alarm'
        when (attributes_std -> 'metadata' ->> 'serial-port-enable') = 'true' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'metadata') is null then ' ''metadata'' property is not defined'
        when (attributes_std -> 'metadata' -> 'serial-port-enable') is null then ' ''serial-port-enable'' property is not defined'
        when (attributes_std -> 'metadata' ->> 'serial-port-enable') = 'true' then ' has serial port connections enabled'
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
      address as resource,
      case
        when (attributes_std -> 'shielded_instance_config') is null then 'alarm'
        when (attributes_std -> 'shielded_instance_config' -> 'enable_integrity_monitoring')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'shielded_instance_config') is null then ' shielded VM disabled'
        when (attributes_std -> 'shielded_instance_config' -> 'enable_integrity_monitoring')::bool then ' shielded VM enabled'
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

query "compute_instance_ip_forwarding_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'can_ip_forward') is null then 'alarm'
        when (attributes_std -> 'can_ip_forward')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'can_ip_forward') is null then ' IP forwarding disabled'
        when (attributes_std -> 'can_ip_forward')::bool then ' IP forwarding enabled'
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
      address as resource,
      case
        when (attributes_std -> 'network_interface' -> 'access_config') is null or (attributes_std -> 'network_interface' ->> 'access_config') like '{}' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'network_interface' -> 'access_config') is null or (attributes_std -> 'network_interface' ->> 'access_config') like '{}' then ' not associated with public IP addresses'
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

query "compute_instance_boot_disk_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'boot_disk' -> 'disk_encryption_key_raw') is not null or (attributes_std -> 'boot_disk' -> 'kms_key_self_link') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'boot_disk' -> 'disk_encryption_key_raw') is not null or (attributes_std -> 'boot_disk' -> 'kms_key_self_link') is not null then ' boot disk encryption enabled'
        else ' boot disk encryption disabled'
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
      address as resource,
      case
        when ((attributes_std ->> 'source_instance_template') is not null and (attributes_std ->> 'metadata') is null) then 'skip'
        when ((attributes_std ->> 'source_instance_template') is not null and (attributes_std -> 'metadata' ->> 'block-project-ssh-keys') is null) then 'skip'
        when ((attributes_std ->> 'source_instance_template') is null and (attributes_std ->> 'metadata') is null) then 'skip'
        when ((attributes_std ->> 'source_instance_template') is null and (attributes_std -> 'metadata' ->> 'block-project-ssh-keys') is null) then 'skip'
        when (attributes_std -> 'metadata' ->> 'block-project-ssh-keys')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when ((attributes_std ->> 'source_instance_template') is not null and (attributes_std ->> 'metadata') is null) then ' underlying source template is unknown'
        when ((attributes_std ->> 'source_instance_template') is not null and (attributes_std -> 'metadata' ->> 'block-project-ssh-keys') is null) then ' underlying source template is unknown'
        when ((attributes_std ->> 'source_instance_template') is null and (attributes_std ->> 'metadata') is null) then ' block project-wide SSH keys not set'
        when ((attributes_std ->> 'source_instance_template') is null and (attributes_std -> 'metadata' ->> 'block-project-ssh-keys') is null) then ' block project-wide SSH keys not set'
        when (attributes_std -> 'metadata' ->> 'block-project-ssh-keys')::bool then ' block project-wide SSH keys enabled'
        else ' block project-wide SSH keys disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_compute_instance', 'google_compute_instance_template', 'google_compute_instance_from_template');
  EOQ
}

query "compute_security_policy_prevent_message_lookup" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when jsonb_typeof(attributes_std -> 'rule') = 'object' and ((attributes_std -> 'rule' -> 'match' -> 'expr' ->> 'expression' <> 'evaluatePreconfiguredExpr(''cve-canary'')') or (attributes_std -> 'rule' ->> 'action' = 'allow') or (attributes_std -> 'rule' ->> 'preview' = 'true')) then 'alarm'
        when jsonb_typeof(attributes_std -> 'rule') = 'array' and exists(select 1 from jsonb_array_elements(attributes_std -> 'rule') as rules where ((rules -> 'match' -> 'expr' ->> 'expression' <> 'evaluatePreconfiguredExpr(''cve-canary'')') or (rules ->> 'action' = 'allow') or (rules ->> 'preview' = 'true'))) then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when jsonb_typeof(attributes_std -> 'rule') = 'object' and ((attributes_std -> 'rule' -> 'match' -> 'expr' ->> 'expression' <> 'evaluatePreconfiguredExpr(''cve-canary'')') or (attributes_std -> 'rule' ->> 'action' = 'allow') or (attributes_std -> 'rule' ->> 'preview' = 'true')) then ' does not prevent message lookup'
        when jsonb_typeof(attributes_std -> 'rule') = 'array' and exists(select 1 from jsonb_array_elements(attributes_std -> 'rule') as rules where ((rules -> 'match' -> 'expr' ->> 'expression' <> 'evaluatePreconfiguredExpr(''cve-canary'')') or (rules ->> 'action' = 'allow') or (rules ->> 'preview' = 'true'))) then ' does not prevent message lookup'
        else ' prevents message lookup'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_security_policy';
  EOQ
}

query "compute_subnetwork_private_ipv6_google_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'private_ipv6_google_access') in ('ENABLE_OUTBOUND_VM_ACCESS_TO_GOOGLE', 'ENABLE_BIDIRECTIONAL_ACCESS_TO_GOOGLE') then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'private_ipv6_google_access') in ('ENABLE_OUTBOUND_VM_ACCESS_TO_GOOGLE', 'ENABLE_BIDIRECTIONAL_ACCESS_TO_GOOGLE') then ' private IPv6 Google Access is enabled'
        else ' private IPv6 Google Access is disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_compute_subnetwork';
  EOQ
}

query "compute_firewall_allow_http_port_80_ingress" {
  sql = <<-EOQ
    with rules as (
      select
        distinct address
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'allow')
            when 'array' then (attributes_std -> 'allow')
            when 'object' then jsonb_build_array(attributes_std -> 'allow')
            else null end
          ) allow,
        jsonb_array_elements_text(
          case
            when ((allow -> 'ports') != 'null') and jsonb_array_length(allow -> 'ports') > 0 then (allow -> 'ports')
            else jsonb_build_array(allow -> 'ports')
          end) as port,
        jsonb_array_elements_text(
          case
            when ((attributes_std -> 'source_ranges') != 'null') and jsonb_array_length(attributes_std -> 'source_ranges') > 0 then (attributes_std -> 'source_ranges')
            else jsonb_build_array(attributes_std -> 'source_ranges')
          end) as sip
      where
        type = 'google_compute_firewall'
        and (attributes_std ->> 'direction' is null or lower(attributes_std ->> 'direction') = 'ingress')
        and lower(sip) in ('*', '0.0.0.0', '0.0.0.0/0', 'internet', 'any', '<nw>/0', '/0')
        and (
          port in ('80', '*')
          or (
            port like '%-%'
            and split_part(port, '-', 1) :: integer <= 80
            and split_part(port, '-', 2) :: integer >= 80
          )
        )
    )
    select
      r.address as resource,
      case
        when g.address is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when g.address is null then ' restricts HTTP access from internet through port 80'
        else ' allows HTTP access from internet through port 80'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.address = r.address
    where
      type = 'google_compute_firewall';
  EOQ
}

query "compute_firewall_allow_ftp_port_20_ingress" {
  sql = <<-EOQ
    with rules as (
      select
        distinct address
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'allow')
            when 'array' then (attributes_std -> 'allow')
            when 'object' then jsonb_build_array(attributes_std -> 'allow')
            else null end
          ) allow,
        jsonb_array_elements_text(
          case
            when ((allow -> 'ports') != 'null') and jsonb_array_length(allow -> 'ports') > 0 then (allow -> 'ports')
            else jsonb_build_array(allow -> 'ports')
          end) as port,
        jsonb_array_elements_text(
          case
            when ((attributes_std -> 'source_ranges') != 'null') and jsonb_array_length(attributes_std -> 'source_ranges') > 0 then (attributes_std -> 'source_ranges')
            else jsonb_build_array(attributes_std -> 'source_ranges')
          end) as sip
      where
        type = 'google_compute_firewall'
        and (attributes_std ->> 'direction' is null or lower(attributes_std ->> 'direction') = 'ingress')
        and lower(sip) in ('*', '0.0.0.0', '0.0.0.0/0', 'internet', 'any', '<nw>/0', '/0')
        and (
          port in ('20', '*')
          or (
            port like '%-%'
            and split_part(port, '-', 1) :: integer <= 20
            and split_part(port, '-', 2) :: integer >= 20
          )
        )
    )
    select
      r.address as resource,
      case
        when g.address is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when g.address is null then ' restricts FTP access from internet through port 20'
        else ' allows FTP access from internet through port 20'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.address = r.address
    where
      type = 'google_compute_firewall';
  EOQ
}

query "compute_firewall_allow_ftp_port_21_ingress" {
  sql = <<-EOQ
    with rules as (
      select
        distinct address
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'allow')
            when 'array' then (attributes_std -> 'allow')
            when 'object' then jsonb_build_array(attributes_std -> 'allow')
            else null end
          ) allow,
        jsonb_array_elements_text(
          case
            when ((allow -> 'ports') != 'null') and jsonb_array_length(allow -> 'ports') > 0 then (allow -> 'ports')
            else jsonb_build_array(allow -> 'ports')
          end) as port,
        jsonb_array_elements_text(
          case
            when ((attributes_std -> 'source_ranges') != 'null') and jsonb_array_length(attributes_std -> 'source_ranges') > 0 then (attributes_std -> 'source_ranges')
            else jsonb_build_array(attributes_std -> 'source_ranges')
          end) as sip
      where
        type = 'google_compute_firewall'
        and (attributes_std ->> 'direction' is null or lower(attributes_std ->> 'direction') = 'ingress')
        and lower(sip) in ('*', '0.0.0.0', '0.0.0.0/0', 'internet', 'any', '<nw>/0', '/0')
        and (
          port in ('21', '*')
          or (
            port like '%-%'
            and split_part(port, '-', 1) :: integer <= 21
            and split_part(port, '-', 2) :: integer >= 21
          )
        )
    )
    select
      r.address as resource,
      case
        when g.address is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when g.address is null then ' restricts FTP access from internet through port 21'
        else ' allows FTP access from internet through port 21'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.address = r.address
    where
      type = 'google_compute_firewall';
  EOQ
}

query "compute_firewall_allow_ssh_port_22_ingress" {
  sql = <<-EOQ
    with rules as (
      select
        distinct address
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'allow')
            when 'array' then (attributes_std -> 'allow')
            when 'object' then jsonb_build_array(attributes_std -> 'allow')
            else null end
          ) allow,
        jsonb_array_elements_text(
          case
            when ((allow -> 'ports') != 'null') and jsonb_array_length(allow -> 'ports') > 0 then (allow -> 'ports')
            else jsonb_build_array(allow -> 'ports')
          end) as port,
        jsonb_array_elements_text(
          case
            when ((attributes_std -> 'source_ranges') != 'null') and jsonb_array_length(attributes_std -> 'source_ranges') > 0 then (attributes_std -> 'source_ranges')
            else jsonb_build_array(attributes_std -> 'source_ranges')
          end) as sip
      where
        type = 'google_compute_firewall'
        and (attributes_std ->> 'direction' is null or lower(attributes_std ->> 'direction') = 'ingress')
        and lower(sip) in ('*', '0.0.0.0', '0.0.0.0/0', 'internet', 'any', '<nw>/0', '/0')
        and (
          port in ('22', '*')
          or (
            port like '%-%'
            and split_part(port, '-', 1) :: integer <= 22
            and split_part(port, '-', 2) :: integer >= 22
          )
        )
    )
    select
      r.address as resource,
      case
        when g.address is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when g.address is null then ' restricts FTP access from internet through port 22'
        else ' allows FTP access from internet through port 22'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.address = r.address
    where
      type = 'google_compute_firewall';
  EOQ
}

query "compute_firewall_allow_rdp_port_3389_ingress" {
  sql = <<-EOQ
    with rules as (
      select
        distinct address
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'allow')
            when 'array' then (attributes_std -> 'allow')
            when 'object' then jsonb_build_array(attributes_std -> 'allow')
            else null end
          ) allow,
        jsonb_array_elements_text(
          case
            when ((allow -> 'ports') != 'null') and jsonb_array_length(allow -> 'ports') > 0 then (allow -> 'ports')
            else jsonb_build_array(allow -> 'ports')
          end) as port,
        jsonb_array_elements_text(
          case
            when ((attributes_std -> 'source_ranges') != 'null') and jsonb_array_length(attributes_std -> 'source_ranges') > 0 then (attributes_std -> 'source_ranges')
            else jsonb_build_array(attributes_std -> 'source_ranges')
          end) as sip
      where
        type = 'google_compute_firewall'
        and (attributes_std ->> 'direction' is null or lower(attributes_std ->> 'direction') = 'ingress')
        and lower(sip) in ('*', '0.0.0.0', '0.0.0.0/0', 'internet', 'any', '<nw>/0', '/0')
        and (
          port in ('3389', '*')
          or (
            port like '%-%'
            and split_part(port, '-', 1) :: integer <= 3389
            and split_part(port, '-', 2) :: integer >= 3389
          )
        )
    )
    select
      r.address as resource,
      case
        when g.address is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when g.address is null then ' restricts RDP access from internet through port 3389'
        else ' allows RDP access from internet through port 3389'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.address = r.address
    where
      type = 'google_compute_firewall';
  EOQ
}

query "compute_firewall_allow_mysql_port_3306_ingress" {
  sql = <<-EOQ
    with rules as (
      select
        distinct address
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'allow')
            when 'array' then (attributes_std -> 'allow')
            when 'object' then jsonb_build_array(attributes_std -> 'allow')
            else null end
          ) allow,
        jsonb_array_elements_text(
          case
            when ((allow -> 'ports') != 'null') and jsonb_array_length(allow -> 'ports') > 0 then (allow -> 'ports')
            else jsonb_build_array(allow -> 'ports')
          end) as port,
        jsonb_array_elements_text(
          case
            when ((attributes_std -> 'source_ranges') != 'null') and jsonb_array_length(attributes_std -> 'source_ranges') > 0 then (attributes_std -> 'source_ranges')
            else jsonb_build_array(attributes_std -> 'source_ranges')
          end) as sip
      where
        type = 'google_compute_firewall'
        and (attributes_std ->> 'direction' is null or lower(attributes_std ->> 'direction') = 'ingress')
        and lower(sip) in ('*', '0.0.0.0', '0.0.0.0/0', 'internet', 'any', '<nw>/0', '/0')
        and (
          port in ('3306', '*')
          or (
            port like '%-%'
            and split_part(port, '-', 1) :: integer <= 3306
            and split_part(port, '-', 2) :: integer >= 3306
          )
        )
    )
    select
      r.address as resource,
      case
        when g.address is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when g.address is null then ' restricts MySQL access from internet through port 3306'
        else ' allows MySQL access from internet through port 3306'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.address = r.address
    where
      type = 'google_compute_firewall';
  EOQ
}

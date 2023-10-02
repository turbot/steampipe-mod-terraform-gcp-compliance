query "dns_managed_zone_zone_signing_not_using_rsasha1" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'visibility') = 'private' then 'skip'
        when (attributes_std -> 'dnssec_config') is null or coalesce((attributes_std -> 'dnssec_config' ->> 'state'), '') in ('', 'off')
        then 'alarm'
        when (attributes_std -> 'dnssec_config' -> 'default_key_specs' ->> 'algorithm') = 'rsasha1' and
          (attributes_std -> 'dnssec_config' -> 'default_key_specs' ->> 'key_type') = 'zoneSigning'
        then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'dnssec_config') is null then ' ''dnssec_config'' is not defined'
        when coalesce((attributes_std -> 'dnssec_config' ->> 'state'), '') = ''
        then ' ''dnssec_config.state'' is not defined'
        when (attributes_std ->> 'visibility') = 'private'
        then ' is private'
        when coalesce((attributes_std -> 'dnssec_config' ->> 'state'), '') = 'off' then ' DNSSEC not enabled'
        when (attributes_std -> 'dnssec_config' -> 'default_key_specs' ->> 'algorithm') = 'rsasha1' and
          (attributes_std -> 'dnssec_config' -> 'default_key_specs' ->> 'key_type') = 'zoneSigning'
        then ' using RSASHA1 algorithm for zone-signing'
        else ' not using RSASHA1 algorithm for zone-signing'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_dns_managed_zone';
  EOQ
}

query "dns_managed_zone_dnssec_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'visibility') = 'private' then 'skip'
        when coalesce((attributes_std ->> 'visibility'), '') in ('', 'public') and 
          ((attributes_std -> 'dnssec_config') is null or coalesce((attributes_std -> 'dnssec_config' ->> 'state'), '') in ('', 'off'))
        then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'dnssec_config') is null then ' ''dnssec_config'' is not defined'
        when coalesce((attributes_std -> 'dnssec_config' ->> 'state'), '') = '' then ' ''dnssec_config.state'' is not defined'
        when (attributes_std ->> 'visibility') = 'private'
          then ' is private.'
        when coalesce((attributes_std ->> 'visibility'), '') in ('', 'public') and 
          ((attributes_std -> 'dnssec_config') is null or (attributes_std -> 'dnssec_config' ->> 'state') = 'off')
        then ' DNSSEC not enabled'
        else ' DNSSEC enabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_dns_managed_zone';
  EOQ
}

query "dns_managed_zone_key_signing_not_using_rsasha1" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'visibility') = 'private' then 'skip'
        when (attributes_std -> 'dnssec_config') is null or coalesce((attributes_std -> 'dnssec_config' ->> 'state'), '') in ('', 'off')
        then 'alarm'
        when (attributes_std -> 'dnssec_config' -> 'default_key_specs' ->> 'algorithm') = 'rsasha1' and
          (attributes_std -> 'dnssec_config' -> 'default_key_specs' ->> 'key_type') = 'keySigning'
        then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'dnssec_config') is null then ' ''dnssec_config'' is not defined'
        when coalesce((attributes_std -> 'dnssec_config' ->> 'state'), '') = ''
        then ' ''dnssec_config.state'' is not defined'
        when (attributes_std ->> 'visibility') = 'private'
        then ' is private'
        when coalesce((attributes_std -> 'dnssec_config' ->> 'state'), '') = 'off' then ' DNSSEC not enabled'
        when (attributes_std -> 'dnssec_config' -> 'default_key_specs' ->> 'algorithm') = 'rsasha1' and
          (attributes_std -> 'dnssec_config' -> 'default_key_specs' ->> 'key_type') = 'keySigning'
        then ' using RSASHA1 algorithm for key-signing'
        else ' not using RSASHA1 algorithm for key-signing'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_dns_managed_zone';
  EOQ
}

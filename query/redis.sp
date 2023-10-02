query "redis_instance_auth_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'auth_enabled') = 'true' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'auth_enabled') = 'true' then ' Auth enabled'
        else ' Auth disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_redis_instance';
  EOQ
}

query "redis_instance_encryption_in_transit_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'transit_encryption_mode') = 'SERVER_AUTHENTICATION' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'transit_encryption_mode') = 'SERVER_AUTHENTICATION' then ' encryption in transit enabled'
        else ' encryption in transit disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_redis_instance';
  EOQ
}
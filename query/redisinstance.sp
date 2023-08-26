query "redis_instance_auth_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'auth_enabled') = 'true' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'auth_enabled') = 'true' then ' auth enabled'
        else ' auth disabled'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'transit_encryption_mode') = 'SERVER_AUTHENTICATION' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'transit_encryption_mode') = 'SERVER_AUTHENTICATION' then ' encryption in transit enabled'
        else ' encryption in transit disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_redis_instance';
  EOQ
}
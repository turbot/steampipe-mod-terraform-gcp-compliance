query "storage_bucket_not_publicly_accessible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'entity')), '') like any (array ['', '%allAuthenticatedUsers%','%allUsers%'])
        then 'alarm'
        else 'ok'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'entity')), '') = '' then ' ''entity'' is not defined'
        when (arguments ->> 'entity') like any (array ['%allAuthenticatedUsers%','%allUsers%']) then ' publicly accessible'
        else ' not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_storage_bucket_access_control';
  EOQ
}

query "storage_bucket_uniform_access_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'uniform_bucket_level_access')::boolean then 'ok' else 'alarm'
      end as status,
      name || case
        when (arguments -> 'uniform_bucket_level_access') is null then ' ''uniform_bucket_level_access'' is not defined'
        when (arguments ->> 'uniform_bucket_level_access')::boolean then ' uniform bucket-level access enabled'
        else ' uniform bucket-level access not enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_storage_bucket';
  EOQ
}

query "storage_bucket_public_access_prevention_enforced" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'public_access_prevention') = 'enforced' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'public_access_prevention') = 'enforced' then ' public access prevention enforced'
        else ' public access prevention not enforced'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_storage_bucket';
  EOQ
}
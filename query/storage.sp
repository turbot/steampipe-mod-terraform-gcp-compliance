query "storage_bucket_not_publicly_accessible" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when coalesce(trim((attributes_std ->> 'entity')), '') like any (array ['', '%allAuthenticatedUsers%','%allUsers%'])
        then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when coalesce(trim((attributes_std ->> 'entity')), '') = '' then ' ''entity'' is not defined'
        when (attributes_std ->> 'entity') like any (array ['%allAuthenticatedUsers%','%allUsers%']) then ' publicly accessible'
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
      address as resource,
      case
        when (attributes_std ->> 'uniform_bucket_level_access')::boolean then 'ok' else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'uniform_bucket_level_access') is null then ' ''uniform_bucket_level_access'' is not defined'
        when (attributes_std ->> 'uniform_bucket_level_access')::boolean then ' uniform bucket-level access enabled'
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
      address as resource,
      case
        when (attributes_std ->> 'public_access_prevention') = 'enforced' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_access_prevention') = 'enforced' then ' public access prevention enforced'
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

query "storage_bucket_versioning_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'versioning' ->> 'enabled') = 'true' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'versioning' ->> 'enabled') = 'true' then ' versioning enabled'
        else ' versioning disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_storage_bucket';
  EOQ
}

query "storage_bucket_self_logging_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'logging') is null then 'skip'
        when (attributes_std -> 'logging' ->> 'log_bucket') = (attributes_std ->> 'name') then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'logging') is null then ' logging is undefined'
        when (attributes_std -> 'logging' ->> 'log_bucket') = (attributes_std ->> 'name') then ' self logging enabled'
        else ' self logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_storage_bucket';
  EOQ
}

query "storage_bucket_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'logging' ->> 'log_bucket') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'logging' ->> 'log_bucket') is not null then ' logging enabled'
        else ' logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_storage_bucket';
  EOQ
}
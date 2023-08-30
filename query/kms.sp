query "kms_key_rotated_within_100_day" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce((arguments ->> 'rotation_period'), '') = '' then 'alarm'
        when split_part((arguments ->> 'rotation_period'), 's', 1) :: int <= 8640000 then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce((arguments ->> 'rotation_period'), '') = '' then ' requires manual rotation'
        else ' rotation period set for ' || (split_part((arguments ->> 'rotation_period'), 's', 1) :: int)/86400 || ' day(s)'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_kms_crypto_key';
  EOQ
}

query "kms_key_rotated_within_90_day" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce((arguments ->> 'rotation_period'), '') = '' then 'alarm'
        when split_part(coalesce((arguments ->> 'rotation_period'), ''), 's', 1) :: int <= 7776000 then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce((arguments ->> 'rotation_period'), '') = '' then ' requires manual rotation'
        else ' rotation period set for ' || (split_part((arguments ->> 'rotation_period'), 's', 1) :: int)/86400 || ' day(s)'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_kms_crypto_key';
  EOQ
}

query "kms_key_prevent_destroy_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (lifecycle ->> 'prevent_destroy')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (lifecycle ->> 'prevent_destroy')::bool then ' prevent destroy enabled'
        else ' prevent destroy disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_kms_crypto_key';
  EOQ
}

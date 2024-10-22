query "kms_key_rotated_within_100_day" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when coalesce((attributes_std ->> 'rotation_period'), '') = '' then 'alarm'
        when split_part((attributes_std ->> 'rotation_period'), 's', 1) :: int <= 8640000 then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when coalesce((attributes_std ->> 'rotation_period'), '') = '' then ' requires manual rotation'
        else ' rotation period set for ' || (split_part((attributes_std ->> 'rotation_period'), 's', 1) :: int)/86400 || ' day(s)'
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
      address as resource,
      case
        when coalesce((attributes_std ->> 'rotation_period'), '') = '' then 'alarm'
        when split_part(coalesce((attributes_std ->> 'rotation_period'), ''), 's', 1) :: int <= 7776000 then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when coalesce((attributes_std ->> 'rotation_period'), '') = '' then ' requires manual rotation'
        else ' rotation period set for ' || (split_part((attributes_std ->> 'rotation_period'), 's', 1) :: int)/86400 || ' day(s)'
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
      address as resource,
      case
        when (lifecycle ->> 'prevent_destroy')::bool then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
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

query "kms_key_not_publicly_accessible" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'member') in ('allUsers','allAuthenticatedUsers') or (attributes_std -> 'members') @> '["allUsers"]' or (attributes_std -> 'members') @> '["allAuthenticatedUsers"]' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'member') in ('allUsers','allAuthenticatedUsers') or (attributes_std -> 'members') @> '["allUsers"]' or (attributes_std -> 'members') @> '["allAuthenticatedUsers"]' then ' is publicly accessible'
        else ' is not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_kms_crypto_key_iam_policy', 'google_kms_crypto_key_iam_binding', 'google_kms_crypto_key_iam_member');
  EOQ
}
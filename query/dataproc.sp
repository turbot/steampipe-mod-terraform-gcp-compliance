query "dataproc_cluster_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'cluster_config' -> 'encryption_config' ->> 'kms_key_name') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'cluster_config' -> 'encryption_config' ->> 'kms_key_name') is not null then ' is encrypted with KMS CMK'
        else ' is not encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_dataproc_cluster';
  EOQ
}

query "dataproc_cluster_public_ip_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'cluster_config' -> 'gce_cluster_config' ->> 'internal_ip_only') = 'true' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'cluster_config' -> 'gce_cluster_config' ->> 'internal_ip_only') = 'true' then ' is not accessible from the public internet'
        else ' is accessible from the public internet'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_dataproc_cluster';
  EOQ
}

query "dataproc_cluster_not_publicly_accessible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'member') in ('allUsers','allAuthenticatedUsers') or (arguments -> 'members') @> '["allUsers"]' or (arguments -> 'members') @> '["allAuthenticatedUsers"]' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments ->> 'member') in ('allUsers','allAuthenticatedUsers') or (arguments -> 'members') @> '["allUsers"]' or (arguments -> 'members') @> '["allAuthenticatedUsers"]' then ' is publicly accessible'
        else ' is not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_dataproc_cluster_iam_binding', 'google_dataproc_cluster_iam_member');
  EOQ
}
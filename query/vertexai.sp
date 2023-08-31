query "vertex_ai_dataset_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_spec' -> 'kms_key_name') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'encryption_spec' -> 'kms_key_name') is not null then ' encrypted with KMS CMK'
        else ' not encrypted with KMS CMK'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_vertex_ai_dataset';
  EOQ
}

query "vertex_ai_notebook_instance_restrict_public_access" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'no_public_ip') = 'true' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'no_public_ip') = 'true' then ' not publicly accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_notebooks_instance';
  EOQ
}


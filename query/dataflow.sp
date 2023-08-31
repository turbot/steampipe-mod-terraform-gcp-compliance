query "dataflow_job_not_publicly_accessible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'ip_configuration') = 'WORKER_IP_PRIVATE' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'ip_configuration') = 'WORKER_IP_PRIVATE' then ' is private'
        else ' is public'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_dataflow_job';
  EOQ
}

query "dataflow_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'kms_key_name') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'kms_key_name') is not null then ' encrypted with KMS CMK'
        else ' not encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_dataflow_job';
  EOQ
}
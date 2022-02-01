select
  type || ' ' || name as resource,
  case
    when (arguments -> 'confidential_instance_config') is null then 'alarm'
    when (arguments -> 'confidential_instance_config' -> 'enable_confidential_compute')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'confidential_instance_config') is null then ' confidential computing disabled'
    when (arguments -> 'confidential_instance_config' -> 'enable_confidential_compute')::bool then ' confidential computing enabled'
    else ' confidential computing disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_compute_instance';
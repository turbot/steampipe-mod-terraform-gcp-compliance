select
  type || ' ' || name as resource,
  case
    when (arguments -> 'shielded_instance_config') is null then 'alarm'
    when (arguments -> 'shielded_instance_config' -> 'enable_integrity_monitoring')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'shielded_instance_config') is null then ' shielded VM disabled'
    when (arguments -> 'shielded_instance_config' -> 'enable_integrity_monitoring')::bool then ' shielded VM enabled'
    else ' shielded VM disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_compute_instance';
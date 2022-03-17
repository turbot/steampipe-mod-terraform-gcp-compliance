select
  type || ' ' || name as resource,
  case
    when (arguments -> 'network_interface' -> 'access_config') is null or (arguments -> 'network_interface' ->> 'access_config') like '{}' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'network_interface' -> 'access_config') is null or (arguments -> 'network_interface' ->> 'access_config') like '{}' then ' not associated with public IP addresses'
    else ' associated with public IP addresses'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_compute_instance';
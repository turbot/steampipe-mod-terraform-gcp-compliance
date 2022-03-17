select
  type || ' ' || name as resource,
  case
    when (arguments -> 'can_ip_forward') is null then 'alarm'
    when (arguments -> 'can_ip_forward')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'can_ip_forward') is null then ' IP forwarding disabled'
    when (arguments -> 'can_ip_forward')::bool then ' IP forwarding enabled'
    else ' IP forwarding disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_compute_instance';
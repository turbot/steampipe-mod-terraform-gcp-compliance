select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'private_ip_google_access')::boolean then 'ok' else 'alarm'
  end as status,
  name || case
    when (arguments -> 'private_ip_google_access') is null then ' ''private_ip_google_access'' is not defined'
    when (arguments ->> 'private_ip_google_access')::boolean then ' private Google Access is enabled'
    else ' private Google Access is disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_compute_subnetwork';
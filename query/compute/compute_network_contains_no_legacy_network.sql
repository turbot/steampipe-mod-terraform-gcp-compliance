select
  type || ' ' || name as resource,
  case
    when (arguments -> 'auto_create_subnetworks') is null then 'ok'
    when (arguments -> 'auto_create_subnetworks')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'auto_create_subnetworks') is null then ' is not a legacy network'
    when (arguments -> 'auto_create_subnetworks')::bool then ' is not a legacy network'
    else ' is a legacy network'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_compute_network';
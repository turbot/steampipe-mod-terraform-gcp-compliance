select
  type || ' ' || name as resource,
  case
    when (arguments -> 'log_config') is not null then 'ok' else 'alarm'
  end as status,
  name || case
    when (arguments -> 'log_config') is not null then ' flow logging enabled'
    else ' flow logging disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_compute_subnetwork';
select
  type || ' ' || name as resource,
  case
    when (arguments -> 'network_policy') is not null then 'ok' else 'alarm'
  end as status,
  name || case
    when (arguments -> 'network_policy') is not null then ' network policy defined'
    else ' network policy not defined'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_container_cluster';
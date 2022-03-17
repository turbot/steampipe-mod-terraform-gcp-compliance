select
  type || ' ' || name as resource,
  case
    when (arguments -> 'private_cluster_config') is not null then 'alarm' else 'ok'
  end as status,
  name || case
    when (arguments -> 'private_cluster_config') is not null then ' private cluster config enabled'
    else ' private cluster config disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_container_cluster';
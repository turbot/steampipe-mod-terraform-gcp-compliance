select
  type || ' ' || name as resource,
  case
    when (arguments -> 'private_cluster_config') is null then 'alarm' 
    when (arguments -> 'private_cluster_config' -> 'enable_private_nodes') is null then 'alarm'
    when (arguments -> 'private_cluster_config' -> 'enable_private_nodes')::bool then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'private_cluster_config') is null then ' private cluster config disabled'
    when (arguments -> 'private_cluster_config' -> 'enable_private_nodes') is null then ' ''enable_private_nodes'' not defined'
    when (arguments -> 'private_cluster_config' -> 'enable_private_nodes')::bool then ' private cluster config enabled'
    else ' private cluster config disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_container_cluster';
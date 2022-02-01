select
  type || ' ' || name as resource,
  case
    when (arguments -> 'management' ->> 'auto_repair')::boolean then 'ok' else 'alarm'
  end as status,
  name || case
    when (arguments -> 'management') is null then ' ''management'' is not defined'
    when (arguments -> 'management' ->> 'auto_repair') is null then ' ''management.auto_repair'' is not defined'
    when (arguments -> 'management' ->> 'auto_repair')::boolean then ' node pool auto repair enabled'
    else ' node pool auto repair disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_container_node_pool';
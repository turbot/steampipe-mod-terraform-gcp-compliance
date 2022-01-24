select
  type || ' ' || name as resource,
  case
    when arguments -> 'node_config' ->> 'image_type' = 'COS_CONTAINERD' then 'ok' else 'alarm'
  end as status,
  name || case
    when arguments -> 'node_config' is null then ' ''node_config'' is not defined'
    when coalesce(trim(arguments -> 'node_config' ->> 'image_type'), '') = '' then ' ''node_config.image_type'' is not defined'
    when arguments -> 'node_config' ->> 'image_type' = 'COS_CONTAINERD'  then ' Container-Optimized OS(COS) is used'
    else ' Container-Optimized OS(COS) not used'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_container_cluster';
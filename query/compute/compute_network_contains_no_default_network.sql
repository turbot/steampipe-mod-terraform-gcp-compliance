select
  type || ' ' || name as resource,
  case
    when name not ilike 'default' then 'ok'
    else 'alarm'
  end status,
  name || case
    when name not ilike 'default' and (arguments ->> 'project') is not null then ' ' || (arguments ->> 'project') || ' is not using default network'
    when name not ilike 'default' and (arguments ->> 'project') is null then ' provider project is not using default network'
    when name ilike 'default' and (arguments ->> 'project') is null then ' provider project is using default network'
    when name ilike 'default' and (arguments ->> 'project') is not null then ' ' || (arguments ->> 'project') || ' is using default network'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_compute_network';
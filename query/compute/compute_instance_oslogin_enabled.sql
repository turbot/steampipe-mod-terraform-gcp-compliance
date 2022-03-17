select
  type || ' ' || name as resource,
  case
    when (arguments -> 'metadata') is null then 'alarm'
     when (arguments -> 'metadata' -> 'enable-oslogin') is null then 'alarm'
    when (arguments -> 'metadata' ->> 'enable-oslogin') = 'true' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'metadata') is null then ' ''metadata'' property is not defined'
    when (arguments -> 'metadata' -> 'enable-oslogin') is null then ' ''enable-oslogin'' property is not defined'
    when (arguments -> 'metadata' ->> 'enable-oslogin') = 'true' then ' has OS login enabled'
    else ' has OS login disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_compute_instance';
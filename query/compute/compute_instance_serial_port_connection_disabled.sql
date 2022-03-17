select
  type || ' ' || name as resource,
  case
    when (arguments -> 'metadata') is null then 'alarm'
     when (arguments -> 'metadata' -> 'serial-port-enable') is null then 'alarm'
    when (arguments -> 'metadata' ->> 'serial-port-enable') = 'true' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'metadata') is null then ' ''metadata'' property is not defined'
    when (arguments -> 'metadata' -> 'serial-port-enable') is null then ' ''serial-port-enable'' property is not defined'
    when (arguments -> 'metadata' ->> 'serial-port-enable') = 'true' then ' has serial port connections enabled'
    else ' has serial port connections disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_compute_instance';
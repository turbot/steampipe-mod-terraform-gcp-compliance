select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'visibility') = 'private' then 'skip'
    when coalesce((arguments ->> 'visibility'), '')  in ('', 'public') and 
      ((arguments -> 'dnssec_config') is null or coalesce((arguments -> 'dnssec_config' ->> 'state'), '')  in ('', 'off'))
    then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'dnssec_config') is null then ' ''dnssec_config'' is not defined'
    when coalesce((arguments -> 'dnssec_config' ->> 'state'), '') = '' then ' ''dnssec_config.state'' is not defined'
    when (arguments ->> 'visibility') = 'private'
      then ' is private.'
    when coalesce((arguments ->> 'visibility'), '')  in ('', 'public') and 
      ((arguments -> 'dnssec_config') is null or (arguments -> 'dnssec_config' ->> 'state') = 'off')
    then ' DNSSEC not enabled'
    else ' DNSSEC enabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_dns_managed_zone';
-- TODO: Revalidate this query
select
  type || ' ' || name as resource,
  case
    when (select (arguments ->> 'networks') from terraform_resource where type = 'google_dns_policy' and (arguments -> 'enable_logging')::bool) like name::text then 'ok'
    else 'alarm'
  end status,
  name || case
    when (select (arguments ->> 'networks') from terraform_resource where type = 'google_dns_policy' and (arguments -> 'enable_logging')::bool) like name::text then ' DNS logging enabled'
    else ' DNS logging disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_compute_network';

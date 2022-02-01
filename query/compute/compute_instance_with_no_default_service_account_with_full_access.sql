select
  type || ' ' || name as resource,
  case
    when (arguments -> 'service_account') is null then 'alarm'
    when (arguments -> 'service_account' ->> 'email') not like '%-compute@developer.gserviceaccount.com' then 'alarm'
    when (arguments -> 'service_account' ->> 'email') like '%-compute@developer.gserviceaccount.com' and (arguments -> 'service_account' ->> 'scopes') like '%cloud-platform%' then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'service_account') is null then ' not configured with default service account'
    when (arguments -> 'service_account' ->> 'email') not like '%-compute@developer.gserviceaccount.com' then ' not configured with default service account'
    when (arguments -> 'service_account' ->> 'email') like '%-compute@developer.gserviceaccount.com' and (arguments -> 'service_account' ->> 'scopes') like '%cloud-platform%' then ' configured to use default service account with full access'
    else ' not configured with default service account with full access'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_compute_instance';
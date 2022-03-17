select
  type || ' ' || name as resource,
  case
    when name in (select split_part((arguments ->> 'service_account_id'), '.', 2) from terraform_resource where type = 'google_service_account_key') then 'alarm'
    else 'ok'
  end status,
  name || case
    when name in (select split_part((arguments ->> 'service_account_id'), '.', 2) from terraform_resource where type = 'google_service_account_key') then ' has user-managed keys'
    else ' does not have user-managed keys'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_service_account';
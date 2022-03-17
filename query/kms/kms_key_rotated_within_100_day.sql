select
  type || ' ' || name as resource,
  case
    when coalesce((arguments ->> 'rotation_period'), '') = '' then 'alarm'
    when split_part((arguments ->> 'rotation_period'), 's', 1) :: int <= 8640000 then 'ok'
    else 'alarm'
  end as status,
  name || case
    when coalesce((arguments ->> 'rotation_period'), '') = '' then ' requires manual rotation'
    else ' rotation period set for ' || (split_part((arguments ->> 'rotation_period'), 's', 1) :: int)/86400 || ' day(s)'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_kms_crypto_key';
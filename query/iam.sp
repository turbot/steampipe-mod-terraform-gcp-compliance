query "iam_service_account_gcp_managed_key" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when name in (select split_part((arguments ->> 'service_account_id'), '.', 2) from terraform_resource where type = 'google_service_account_key') then 'alarm'
        else 'ok'
      end status,
      name || case
        when name in (select split_part((arguments ->> 'service_account_id'), '.', 2) from terraform_resource where type = 'google_service_account_key') then ' has user-managed keys'
        else ' does not have user-managed keys'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_service_account';
  EOQ
}

query "iam_project_use_basic_role" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'role') like any (array ['roles/owner', 'roles/editor', 'roles/viewer']) then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'role') like any (array ['roles/owner', 'roles/editor', 'roles/viewer']) then ' uses basic role'
        else ' does not use basic role'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_project_iam_member', 'google_project_iam_binding');
  EOQ
}

query "iam_organization_use_basic_role" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'role') like any (array ['roles/owner', 'roles/editor', 'roles/viewer']) then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'role') like any (array ['roles/owner', 'roles/editor', 'roles/viewer']) then ' uses basic role'
        else ' does not use basic role'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_organization_iam_member', 'google_organization_iam_binding');
  EOQ
}

query "iam_service_account_no_admin_priviledge" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'member') like '%.iam.gserviceaccount.com$' and (arguments ->> 'role') like any (array ['roles/Admin', 'roles/admin', 'roles/owner', 'roles/editor']) then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'member') like '%.iam.gserviceaccount.com$' and (arguments ->> 'role') like any (array ['roles/Admin', 'roles/admin', 'roles/owner', 'roles/editor']) then ' has admin privileges'
        else ' does not have admin privileges'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_project_iam_member';
  EOQ
}

query "iam_project_impersonation_role" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'role') like any (array ['roles/owner', 'roles/editor', 'roles/iam.securityAdmin', 'roles/iam.serviceAccountAdmin', 'roles/iam.serviceAccountKeyAdmin', 'roles/iam.serviceAccountUser', 'roles/iam.serviceAccountTokenCreator', 'roles/iam.workloadIdentityUser', 'roles/dataproc.editor', 'roles/dataproc.admin', 'roles/dataflow.developer', 'roles/resourcemanager.folderAdmin', 'roles/resourcemanager.folderIamAdmin', 'roles/resourcemanager.projectIamAdmin', 'roles/resourcemanager.organizationAdmin', 'roles/serverless.serviceAgent', 'roles/dataproc.serviceAgent']) then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'role') like any (array ['roles/owner', 'roles/editor', 'roles/iam.securityAdmin', 'roles/iam.serviceAccountAdmin', 'roles/iam.serviceAccountKeyAdmin', 'roles/iam.serviceAccountUser', 'roles/iam.serviceAccountTokenCreator', 'roles/iam.workloadIdentityUser', 'roles/dataproc.editor', 'roles/dataproc.admin', 'roles/dataflow.developer', 'roles/resourcemanager.folderAdmin', 'roles/resourcemanager.folderIamAdmin', 'roles/resourcemanager.projectIamAdmin', 'roles/resourcemanager.organizationAdmin', 'roles/serverless.serviceAgent', 'roles/dataproc.serviceAgent']) then ' impersonates or manages Service Accounts'
        else ' does not impersonate or manage Service Accounts'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_project_iam_member', 'google_project_iam_binding');
  EOQ
}

query "iam_organization_impersonation_role" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'role') like any (array ['roles/owner', 'roles/editor', 'roles/iam.securityAdmin', 'roles/iam.serviceAccountAdmin', 'roles/iam.serviceAccountKeyAdmin', 'roles/iam.serviceAccountUser', 'roles/iam.serviceAccountTokenCreator', 'roles/iam.workloadIdentityUser', 'roles/dataproc.editor', 'roles/dataproc.admin', 'roles/dataflow.developer', 'roles/resourcemanager.folderAdmin', 'roles/resourcemanager.folderIamAdmin', 'roles/resourcemanager.projectIamAdmin', 'roles/resourcemanager.organizationAdmin', 'roles/serverless.serviceAgent', 'roles/dataproc.serviceAgent']) then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'role') like any (array ['roles/owner', 'roles/editor', 'roles/iam.securityAdmin', 'roles/iam.serviceAccountAdmin', 'roles/iam.serviceAccountKeyAdmin', 'roles/iam.serviceAccountUser', 'roles/iam.serviceAccountTokenCreator', 'roles/iam.workloadIdentityUser', 'roles/dataproc.editor', 'roles/dataproc.admin', 'roles/dataflow.developer', 'roles/resourcemanager.folderAdmin', 'roles/resourcemanager.folderIamAdmin', 'roles/resourcemanager.projectIamAdmin', 'roles/resourcemanager.organizationAdmin', 'roles/serverless.serviceAgent', 'roles/dataproc.serviceAgent']) then ' impersonates or manages Service Accounts'
        else ' does not impersonate or manage Service Accounts'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_organization_iam_member', 'google_organization_iam_binding');
  EOQ
}

query "iam_project_no_service_account_token_creator_role" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'role') like any (array ['roles/iam.serviceAccountUser', 'roles/iam.serviceAccountTokenCreator']) then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'role') like any (array ['roles/iam.serviceAccountUser', 'roles/iam.serviceAccountTokenCreator']) then ' service account roles assigned'
        else ' no service account roles assigned'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_project_iam_member', 'google_project_iam_binding');
  EOQ
}

query "iam_project_use_default_service_role" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when ((arguments ->> 'members') like any (array ['%@developer.gserviceaccount.com', '%@appspot.gserviceaccount.com']) or (arguments ->> 'member') like '%@developer.gserviceaccount.com' or (arguments ->> 'member') like '%@appspot.gserviceaccount.com') then 'alarm'
        else 'ok'
      end status,
      name || case
        when ((arguments ->> 'members') like any (array ['%@developer.gserviceaccount.com', '%@appspot.gserviceaccount.com']) or (arguments ->> 'member') like '%@developer.gserviceaccount.com' or (arguments ->> 'member') like '%@appspot.gserviceaccount.com') then ' uses default service account role'
        else ' does not use default service account role'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_project_iam_member', 'google_project_iam_binding');
  EOQ
}

query "iam_organization_use_default_service_role" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when ((arguments ->> 'members') like any (array ['%@developer.gserviceaccount.com', '%@appspot.gserviceaccount.com']) or (arguments ->> 'member') like '%@developer.gserviceaccount.com' or (arguments ->> 'member') like '%@appspot.gserviceaccount.com') then 'alarm'
        else 'ok'
      end status,
      name || case
        when ((arguments ->> 'members') like any (array ['%@developer.gserviceaccount.com', '%@appspot.gserviceaccount.com']) or (arguments ->> 'member') like '%@developer.gserviceaccount.com' or (arguments ->> 'member') like '%@appspot.gserviceaccount.com') then ' uses default service account role'
        else ' does not use default service account role'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_organization_iam_member', 'google_organization_iam_binding');
  EOQ
}

query "iam_folder_use_basic_role" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'role') like any (array ['roles/owner', 'roles/editor', 'roles/viewer']) then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'role') like any (array ['roles/owner', 'roles/editor', 'roles/viewer']) then ' uses basic role'
        else ' does not use basic role'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_folder_iam_member', 'google_folder_iam_binding');
  EOQ
}

query "iam_folder_impersonation_role" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'role') like any (array ['roles/owner', 'roles/editor', 'roles/iam.securityAdmin', 'roles/iam.serviceAccountAdmin', 'roles/iam.serviceAccountKeyAdmin', 'roles/iam.serviceAccountUser', 'roles/iam.serviceAccountTokenCreator', 'roles/iam.workloadIdentityUser', 'roles/dataproc.editor', 'roles/dataproc.admin', 'roles/dataflow.developer', 'roles/resourcemanager.folderAdmin', 'roles/resourcemanager.folderIamAdmin', 'roles/resourcemanager.projectIamAdmin', 'roles/resourcemanager.organizationAdmin', 'roles/serverless.serviceAgent', 'roles/dataproc.serviceAgent']) then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'role') like any (array ['roles/owner', 'roles/editor', 'roles/iam.securityAdmin', 'roles/iam.serviceAccountAdmin', 'roles/iam.serviceAccountKeyAdmin', 'roles/iam.serviceAccountUser', 'roles/iam.serviceAccountTokenCreator', 'roles/iam.workloadIdentityUser', 'roles/dataproc.editor', 'roles/dataproc.admin', 'roles/dataflow.developer', 'roles/resourcemanager.folderAdmin', 'roles/resourcemanager.folderIamAdmin', 'roles/resourcemanager.projectIamAdmin', 'roles/resourcemanager.organizationAdmin', 'roles/serverless.serviceAgent', 'roles/dataproc.serviceAgent']) then ' impersonates or manages Service Accounts'
        else ' does not impersonate or manage Service Accounts'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_folder_iam_member', 'google_folder_iam_binding');
  EOQ
}

query "iam_folder_use_default_service_role" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when ((arguments ->> 'members') like any (array ['%@developer.gserviceaccount.com', '%@appspot.gserviceaccount.com']) or (arguments ->> 'member') like '%@developer.gserviceaccount.com' or (arguments ->> 'member') like '%@appspot.gserviceaccount.com') then 'alarm'
        else 'ok'
      end status,
      name || case
        when ((arguments ->> 'members') like any (array ['%@developer.gserviceaccount.com', '%@appspot.gserviceaccount.com']) or (arguments ->> 'member') like '%@developer.gserviceaccount.com' or (arguments ->> 'member') like '%@appspot.gserviceaccount.com') then ' uses default service account role'
        else ' does not use default service account role'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_folder_iam_member', 'google_folder_iam_binding');
  EOQ
}
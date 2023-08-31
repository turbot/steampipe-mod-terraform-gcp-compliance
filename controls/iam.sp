locals {
  iam_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/IAM"
  })
}

benchmark "iam" {
  title       = "IAM"
  description = "This benchmark provides a set of controls that detect Terraform GCP Identity and Access Management(IAM) resources deviating from security best practices."

  children = [
    control.iam_folder_impersonation_role,
    control.iam_folder_use_basic_role,
    control.iam_folder_use_default_service_role,
    control.iam_organization_impersonation_role,
    control.iam_organization_use_basic_role,
    control.iam_organization_use_default_service_role,
    control.iam_project_impersonation_role,
    control.iam_project_no_service_account_token_creator_role,
    control.iam_project_use_basic_role,
    control.iam_project_use_default_service_role,
    control.iam_service_account_gcp_managed_key,
    control.iam_service_account_no_admin_priviledge
  ]

  tags = merge(local.iam_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "iam_service_account_gcp_managed_key" {
  title       = "Ensure that there are only GCP-managed service account keys for each service account"
  description = "User managed service accounts should not have user-managed keys. It is recommended that only GCP-managed service account keys are used for each service account."
  query       = query.iam_service_account_gcp_managed_key

  tags = merge(local.iam_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "1.4"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "iam_project_use_basic_role" {
  title       = "Ensure basic roles are not used at project level"
  description = "This control checks that basic roles are not used at project level."
  query       = query.iam_project_use_basic_role

  tags = local.iam_compliance_common_tags
}

control "iam_organization_use_basic_role" {
  title       = "Ensure basic roles are not used at organization level"
  description = "This control checks that basic roles are not used at organization level."
  query       = query.iam_organization_use_basic_role

  tags = local.iam_compliance_common_tags
}

control "iam_service_account_no_admin_priviledge" {
  title       = "Ensure that Service Account has no admin privileges"
  description = "This control checks that Service Account has no admin privileges."
  query       = query.iam_service_account_no_admin_priviledge

  tags = local.iam_compliance_common_tags
}

control "iam_project_impersonation_role" {
  title       = "Ensure roles do not impersonate or manage Service Accounts used at project level"
  description = "This control checks roles do not impersonate or manage Service Accounts used at project level."
  query       = query.iam_project_impersonation_role

  tags = local.iam_compliance_common_tags
}

control "iam_organization_impersonation_role" {
  title       = "Ensure roles do not impersonate or manage Service Accounts used at organization level"
  description = "This control checks that roles do not impersonate or manage Service Accounts used at organization level."
  query       = query.iam_organization_impersonation_role

  tags = local.iam_compliance_common_tags
}

control "iam_project_no_service_account_token_creator_role" {
  title       = "Ensure that users are not assigned the Service Account User or Service Account Token Creator roles at project level"
  description = "This control checks that users are not assigned the Service Account User or Service Account Token Creator roles at project level."
  query       = query.iam_project_no_service_account_token_creator_role

  tags = local.iam_compliance_common_tags
}

control "iam_project_use_default_service_role" {
  title       = "Ensure Default Service account is not used at a project level"
  description = "This control checks that Default Service account is not used at a project level."
  query       = query.iam_project_use_default_service_role

  tags = local.iam_compliance_common_tags
}

control "iam_organization_use_default_service_role" {
  title       = "Ensure Default Service account is not used at a organization level"
  description = "This control checks that Default Service account is not used at a organization level."
  query       = query.iam_organization_use_default_service_role

  tags = local.iam_compliance_common_tags
}

control "iam_folder_use_basic_role" {
  title       = "Ensure basic roles are not used at folder level"
  description = "This control checks that basic roles are not used at folder level."
  query       = query.iam_folder_use_basic_role

  tags = local.iam_compliance_common_tags
}

control "iam_folder_impersonation_role" {
  title       = "Ensure roles do not impersonate or manage Service Accounts used at folder level"
  description = "This control checks that roles do not impersonate or manage Service Accounts used at folder level."
  query       = query.iam_folder_impersonation_role

  tags = local.iam_compliance_common_tags
}

control "iam_folder_use_default_service_role" {
  title       = "Ensure Default Service account is not used at a folder level"
  description = "This control checks that Default Service account is not used at a folder level."
  query       = query.iam_folder_use_default_service_role

  tags = local.iam_compliance_common_tags
}

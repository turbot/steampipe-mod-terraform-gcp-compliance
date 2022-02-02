locals {
  bigquery_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "bigquery"
  })
}

benchmark "bigquery" {
  title       = "BigQuery"
  description = "This benchmark provides a set of controls that detect Terraform GCP BigQuery resources deviating from security best practices."

  children = [
    control.bigquery_dataset_encrypted_with_cmk,
    control.bigquery_dataset_not_publicly_accessible,
    control.bigquery_table_encrypted_with_cmk
  ]

  tags = local.bigquery_compliance_common_tags
}

control "bigquery_dataset_not_publicly_accessible" {
  title         = "Ensure that BigQuery datasets are not anonymously or publicly accessible"
  description   = "It is recommended that the IAM policy on BigQuery datasets does not allow anonymous and/or public access."
  sql           = query.bigquery_dataset_not_publicly_accessible.sql

  tags = merge(local.bigquery_compliance_common_tags, {
    cft_scorecard_v1        = "true"
    cis                     = "true"
    cis_item_id             = "7.1"
    cis_level               = "1"
    cis_type                = "automated"
    forseti_security_v226   = "true"
  })
}

control "bigquery_dataset_encrypted_with_cmk" {
  title         = "Ensure that a Default Customer-managed encryption key (CMEK) is specified for all BigQuery Data Sets"
  description   = "BigQuery by default encrypts the data as rest by employing Envelope Encryption using Google managed cryptographic keys. The data is encrypted using the data encryption keys and data encryption keys themselves are further encrypted using key encryption keys. This is seamless and do not require any additional input from the user. However, if you want to have greater control, Customer-managed encryption keys (CMEK) can be used as encryption key management solution for BigQuery Data Sets."
  sql           = query.bigquery_dataset_encrypted_with_cmk.sql

  tags = merge(local.bigquery_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "7.3"
    cis_type    = "automated"
    cis_level   = "2"
  })
}

control "bigquery_table_encrypted_with_cmk" {
  title         = "Ensure that all BigQuery Tables are encrypted with Customer-managed encryption key (CMEK)"
  description   = "BigQuery by default encrypts the data as rest by employing Envelope Encryption using Google managed cryptographic keys. The data is encrypted using the data encryption keys and data encryption keys themselves are further encrypted using key encryption keys. This is seamless and does not require any additional input from the user. However, if you want to have greater control, Customer-managed encryption keys (CMEK) can be used as encryption key management solution for BigQuery tables. If CMEK is used, the CMEK is used to encrypt the data encryption keys instead of using google-managed encryption keys."
  sql           = query.bigquery_table_encrypted_with_cmk.sql

  tags = merge(local.bigquery_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "7.2"
    cis_type    = "automated"
    cis_level   = "2"
  })
}
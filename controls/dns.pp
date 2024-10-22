locals {
  dns_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/DNS"
  })
}

benchmark "dns" {
  title       = "DNS"
  description = "This benchmark provides a set of controls that detect Terraform GCP DNS resources deviating from security best practices."

  children = [
    control.dns_managed_zone_dnssec_enabled,
    control.dnssec_prevent_rsasha1_ksk,
    control.dnssec_prevent_rsasha1_zsk
  ]

  tags = merge(local.dns_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "dns_managed_zone_dnssec_enabled" {
  title       = "Ensure that DNSSEC is enabled for Cloud DNS"
  description = "Cloud Domain Name System (DNS) is a fast, reliable and cost-effective domain name system that powers millions of domains on the internet. Domain Name System Security Extensions (DNSSEC) in Cloud DNS enables domain owners to take easy steps to protect their domains against DNS hijacking and man-in-the-middle and other attacks."
  query       = query.dns_managed_zone_key_signing_not_using_rsasha1

  tags = merge(local.dns_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "3.3"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "dnssec_prevent_rsasha1_ksk" {
  title = "Ensure that RSASHA1 is not used for key-signing key in Cloud DNS"
  query = query.dns_managed_zone_key_signing_not_using_rsasha1

  tags = merge(local.dns_compliance_common_tags, {
    cft_scorecard_v1 = "true"
  })
}

control "dnssec_prevent_rsasha1_zsk" {
  title = "Ensure that RSASHA1 is not used for zone-signing key in Cloud DNS"
  query = query.dns_managed_zone_zone_signing_not_using_rsasha1

  tags = merge(local.dns_compliance_common_tags, {
    cft_scorecard_v1 = "true"
  })
}

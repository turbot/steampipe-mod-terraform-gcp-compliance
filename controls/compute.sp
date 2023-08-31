locals {
  compute_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/Compute"
  })
}

benchmark "compute" {
  title       = "Compute"
  description = "This benchmark provides a set of controls that detect Terraform GCP Compute Engine resources deviating from security best practices."

  children = [
    control.compute_disk_encrypted_with_csk,
    control.compute_firewall_allow_ftp_port_20_ingress,
    control.compute_firewall_allow_ftp_port_21_ingress,
    control.compute_firewall_allow_http_port_80_ingress,
    control.compute_firewall_allow_mysql_port_3306_ingress,
    control.compute_firewall_allow_rdp_port_3389_ingress,
    control.compute_firewall_allow_ssh_port_22_ingress,
    control.compute_instance_block_project_wide_ssh_enabled,
    control.compute_instance_boot_disk_encryption_enabled,
    control.compute_instance_confidential_computing_enabled,
    control.compute_instance_ip_forwarding_disabled,
    control.compute_instance_oslogin_enabled,
    control.compute_instance_serial_port_connection_disabled,
    control.compute_instance_shielded_vm_enabled,
    control.compute_instance_with_no_default_service_account,
    control.compute_instance_with_no_default_service_account_with_full_access,
    control.compute_instance_with_no_public_ip_addresses,
    control.compute_network_contains_no_default_network,
    control.compute_network_contains_no_legacy_network,
    control.compute_security_policy_prevent_message_lookup,
    control.compute_subnetwork_flow_log_enabled,
    control.compute_subnetwork_private_ip_google_access,
    control.compute_subnetwork_private_ipv6_google_access
  ]

  tags = merge(local.compute_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "compute_disk_encrypted_with_csk" {
  title       = "Ensure VM disks for critical VMs are encrypted with Customer-Supplied Encryption Keys (CSEK)"
  description = "Customer-Supplied Encryption Keys (CSEK) are a feature in Google Cloud Storage and Google Compute Engine. If you supply your own encryption keys, Google uses your key to protect the Google-generated keys used to encrypt and decrypt your data. By default, Google Compute Engine encrypts all data at rest. Compute Engine handles and manages this encryption for you without any additional actions on your part. However, if you wanted to control and manage this encryption yourself, you can provide your own encryption keys."
  query       = query.compute_disk_encrypted_with_csk

  tags = merge(local.compute_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.7"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "compute_instance_block_project_wide_ssh_enabled" {
  title       = "Ensure 'Block Project-wide SSH keys' is enabled for VM instances"
  description = "It is recommended to use instance specific SSH key(s) instead of using common/shared project-wide SSH key(s) to access instances."
  query       = query.compute_instance_block_project_wide_ssh_enabled

  tags = merge(local.compute_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.3"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "compute_instance_confidential_computing_enabled" {
  title       = "Ensure that Compute instances have Confidential Computing enabled"
  description = "Google Cloud encrypts data at-rest and in-transit, but customer data must be decrypted for processing. Confidential Computing is a breakthrough technology which encrypts data in-use while it is being processed. Confidential Computing environments keep data encrypted in memory and elsewhere outside the central processing unit (CPU)."
  query       = query.compute_instance_confidential_computing_enabled

  tags = merge(local.compute_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.11"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "compute_instance_ip_forwarding_disabled" {
  title       = "Ensure that IP forwarding is not enabled on Instances"
  description = "Compute Engine instance cannot forward a packet unless the source IP address of the packet matches the IP address of the instance. Similarly, GCP won't deliver a packet whose destination IP address is different than the IP address of the instance receiving the packet. However, both capabilities are required if you want to use instances to help route packets."
  query       = query.compute_instance_ip_forwarding_disabled

  tags = merge(local.compute_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.6"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "compute_instance_oslogin_enabled" {
  title       = "Ensure OS login is enabled for a project"
  description = "Enabling OS login binds SSH certificates to IAM users and facilitates effective SSH certificate management."
  query       = query.compute_instance_oslogin_enabled

  tags = merge(local.compute_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.4"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "compute_instance_serial_port_connection_disabled" {
  title       = "Ensure 'Enable connecting to serial ports' is not enabled for VM Instance"
  description = "Interacting with a serial port is often referred to as the serial console, which is similar to using a terminal window, in that input and output is entirely in text mode and there is no graphical interface or mouse support."
  query       = query.compute_instance_serial_port_connection_disabled

  tags = merge(local.compute_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.5"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "compute_instance_shielded_vm_enabled" {
  title       = "Ensure Compute instances are launched with Shielded VM enabled"
  description = "To defend against advanced threats and to ensure that the boot loader and firmware on your VMs are signed and untampered, it is recommended that Compute instances are launched with Shielded VM enabled."
  query       = query.compute_instance_shielded_vm_enabled

  tags = merge(local.compute_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.8"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "compute_instance_with_no_default_service_account_with_full_access" {
  title       = "Ensure that instances are not configured to use the default service account with full access to all Cloud APIs"
  description = "To support principle of least privileges and prevent potential privilege escalation it is recommended that instances are not assigned to default service account Compute Engine default service account with Scope Allow full access to all Cloud APIs."
  query       = query.compute_instance_with_no_default_service_account_with_full_access

  tags = merge(local.compute_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.2"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "compute_instance_with_no_default_service_account" {
  title       = "Ensure that instances are not configured to use the default service account"
  description = "It is recommended to configure your instance to not use the default Compute Engine service account because it has the Editor role on the project."
  query       = query.compute_instance_with_no_default_service_account

  tags = merge(local.compute_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.1"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "compute_instance_with_no_public_ip_addresses" {
  title       = "Ensure that Compute instances do not have public IP addresses"
  description = "Compute instances should not be configured to have external IP addresses."
  query       = query.compute_instance_with_no_public_ip_addresses

  tags = merge(local.compute_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.9"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "compute_network_contains_no_default_network" {
  title       = "Ensure that the default network does not exist in a project"
  description = "The default network is an auto mode network, which means that its subnets use the same predefined range of IP addresses, and as a result, it is not possible to use Cloud VPN or VPC Network Peering with the default network. The organization should create a new network based on the requirement and delete the default network."
  query       = query.compute_network_contains_no_default_network

  tags = merge(local.compute_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "3.1"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "compute_network_contains_no_legacy_network" {
  title       = "Ensure legacy networks do not exist for a project"
  description = "Legacy networks have a single network IPv4 prefix range and a single gateway IP address for the whole network. The network is global in scope and spans all cloud regions. Subnetworks cannot be created in a legacy network and are unable to switch from legacy to auto or custom subnet networks. Legacy networks can have an impact for high network traffic projects and are subjected to a single point of contention or failure."
  query       = query.compute_network_contains_no_legacy_network

  tags = merge(local.compute_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "3.2"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "compute_subnetwork_flow_log_enabled" {
  title = "Ensure VPC Flow logs is enabled for every subnet in VPC Network"
  query = query.compute_subnetwork_flow_log_enabled

  tags = merge(local.compute_compliance_common_tags, {
    cft_scorecard_v1 = "true"
  })
}

control "compute_subnetwork_private_ip_google_access" {
  title = "Ensure Private Google Access is enabled for all subnetworks in VPC"
  query = query.compute_subnetwork_private_ip_google_access

  tags = merge(local.compute_compliance_common_tags, {
    cft_scorecard_v1 = "true"
  })
}

control "compute_instance_boot_disk_encryption_enabled" {
  title       = "Compute instance boot disk encryption should be enabled"
  description = "This control checks whether Compute instance boot disk encryption is enabled."
  query       = query.compute_instance_boot_disk_encryption_enabled

  tags = local.compute_compliance_common_tags
}

control "compute_security_policy_prevent_message_lookup" {
  title       = "Cloud Armor prevents message lookup in Log4j2"
  description = "This control checks if Cloud Armor is configured to prevent message lookup in Log4j2. See CVE-2021-44228 aka log4jshell."
  query       = query.compute_security_policy_prevent_message_lookup

  tags = local.compute_compliance_common_tags
}

control "compute_subnetwork_private_ipv6_google_access" {
  title       = "Compute Subnetworks should have Private IPv6 Google Access enabled"
  description = "This control checks if Compute Subnetworks have Private IPv6 Google Access enabled."
  query       = query.compute_subnetwork_private_ipv6_google_access

  tags = local.compute_compliance_common_tags
}

control "compute_firewall_allow_http_port_80_ingress" {
  title       = "Google compute firewall ingress does not allow unrestricted HTTP port 80 access"
  description = "This control checks if Google compute firewall ingress does not allow unrestricted HTTP port 80 access."
  query       = query.compute_firewall_allow_http_port_80_ingress

  tags = local.compute_compliance_common_tags
}

control "compute_firewall_allow_ftp_port_20_ingress" {
  title       = "Google compute firewall ingress does not allow unrestricted FTP port 20 access"
  description = "This control checks if Google compute firewall ingress does not allow unrestricted FTP port 20 access."
  query       = query.compute_firewall_allow_ftp_port_20_ingress

  tags = local.compute_compliance_common_tags
}

control "compute_firewall_allow_ftp_port_21_ingress" {
  title       = "Google compute firewall ingress does not allow unrestricted FTP port 21 access"
  description = "This control checks if Google compute firewall ingress does not allow unrestricted FTP port 21 access."
  query       = query.compute_firewall_allow_ftp_port_21_ingress

  tags = local.compute_compliance_common_tags
}

control "compute_firewall_allow_ssh_port_22_ingress" {
  title       = "Google compute firewall ingress does not allow unrestricted SSH port 22 access"
  description = "This control checks if Google compute firewall ingress does not allow unrestricted SSH port 22 access."
  query       = query.compute_firewall_allow_ssh_port_22_ingress

  tags = local.compute_compliance_common_tags
}

control "compute_firewall_allow_rdp_port_3389_ingress" {
  title       = "Google compute firewall ingress does not allow unrestricted RDP port 3389 access"
  description = "This control checks if Google compute firewall ingress does not allow unrestricted RDP port 3389 access."
  query       = query.compute_firewall_allow_rdp_port_3389_ingress

  tags = local.compute_compliance_common_tags
}

control "compute_firewall_allow_mysql_port_3306_ingress" {
  title       = "Google compute firewall ingress does not allow unrestricted MySQL port 3306 access"
  description = "This control checks if Google compute firewall ingress does not allow unrestricted MySQL port 3306 access."
  query       = query.compute_firewall_allow_mysql_port_3306_ingress

  tags = local.compute_compliance_common_tags
}

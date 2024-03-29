mod "terraform_gcp_compliance" {
  # Hub metadata
  title         = "Terraform GCP Compliance"
  description   = "Run compliance and security controls to detect Terraform GCP resources deviating from security best practices prior to deployment in your GCP projects using Powerpipe and Steampipe."
  color         = "#844FBA"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/terraform-gcp-compliance.svg"
  categories    = ["gcp", "compliance", "iac", "security", "terraform"]

  opengraph {
    title       = "Powerpipe Mod to Analyze Terraform"
    description = "Run compliance and security controls to detect Terraform GCP resources deviating from security best practices prior to deployment in your GCP projects using Powerpipe and Steampipe."
    image       = "/images/mods/turbot/terraform-gcp-compliance-social-graphic.png"
  }

  requires {
    plugin "terraform" {
      min_version = "0.10.0"
    }
  }
}

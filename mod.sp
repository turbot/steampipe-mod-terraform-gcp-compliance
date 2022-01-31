mod "terraform_gcp_compliance" {
  # Hub metadata
  title         = "Terraform GCP Compliance"
  description   = "Run compliance and security controls to detect Terraform GCP resources deviating from security best practices prior to deployment in your GCP projects."
  color         = "#844FBA"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/terraform-gcp-compliance.svg"
  categories    = ["gcp", "compliance", "iaas", "security", "terraform"]

  opengraph {
    title       = "Steampipe Mod to Analyze Terraform"
    description = "Run compliance and security controls to detect Terraform GCP resources deviating from security best practices prior to deployment in your GCP projects."
    image       = "/images/mods/turbot/terraform-gcp-compliance-social-graphic.png"
  }

  requires {
    plugin "terraform" {
      version = "0.0.1"
    }
  }
}

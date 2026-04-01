locals {
  common_tags = {
    Project     = var.project_name
    Team        = var.team_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Terraform   = "true"
  }
}
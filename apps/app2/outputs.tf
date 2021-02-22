# Outputs

# These outputs should be deleted. They are just here for testing purposes
output "app2_region" {
  value       = var.region
  description = "the region input variable"
}

output "app2_s3_cors_rule" {
  value       = var.s3_cors_rule
  description = "The structured variable extracted with new Python script"
}
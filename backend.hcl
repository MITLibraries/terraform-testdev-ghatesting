# This is the backend file for storing remote state in AWS for the Test/Dev environment
# This must be kept in sync with the version in the terraform-testdev-bootstrap repository
bucket          = "mittest-tfstate-states"
region          = "us-east-1"
dynamodb_table  = "mittest-tfstate-locks"
encrypt         = true

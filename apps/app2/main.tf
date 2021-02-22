#===================================================================================
# AWS Test/Dev using remote state stored in AWS
#===================================================================================

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

# IMPORTANT: the key MUST be changed to match the name of this app
# IMPORTANT: the -backend-file=backend.hcl option MUST be used when running terraform plan
#   and terraform apply
terraform {
  backend "s3" {
    key = "ghatest/apps/app2.tfstate"
  }
}

# The snippet below is used in the stage/prod environment to pull in shared data. It won't work
#   in the test/dev environment because of the specific calls to the bucket, workspaces, and locks
#   that only exist in the stage/prod environment. We will need to build a separate module, specific
#   to the test/dev environment that does the same thing.
#
# This line will trigger a new tf-plan-dev.yml GHA run.
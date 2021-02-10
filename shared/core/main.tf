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
    key = "ghatest/shared/core.tfstate"
  }
}

# The snippet below is used in the stage/prod environment to pull in shared data. It won't work
#   in the test/dev environment because of the specific calls to the bucket, workspaces, and locks
#   that only exist in the stage/prod environment. We will need to build a separate module, specific
#   to the test/dev environment that does the same thing.
#
# This is an edit in shared/app that should trigger the conditional validate.
#
# This will pull in the custom module that is stored locally in this template


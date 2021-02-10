#
# This module provides a layer of abstraction to accessing shared resources. It does 
# not itself create any resources or maintain any state, it simply reads the state 
# files of various shared resources. The goal is to hide some of the uglier, repetitive 
# config blocks behind a clean interface.
# 
# When you add a new shared resource, you will also need to update this module with 
# whatever outputs you want to provide access to.
#

locals {
  environment = var.workspace != "" ? lower(var.workspace) : lower(terraform.workspace)

  # The following local variables are specific to the Test/Dev environment
  bucket         = "mittest-tfstate-states"
  region         = "us-east-1"
  dynamodb_table = "mittest-tfstate-locks"
  encrypt        = true
}

# This is the data from the separate bootstrap repository
data "terraform_remote_state" "init" {
  backend = "s3"

  config = {
    bucket         = local.bucket
    region         = local.region
    dynamodb_table = local.dynamodb_table
    key            = "terraforminit.tfstate"
    encrypt        = local.encrypt
  }
}

# Data from the ./shared/core terraform remote state
data "terraform_remote_state" "core" {
  backend   = "s3"
  workspace = local.environment

  config = {
    region         = local.region
    bucket         = local.bucket
    dynamodb_table = local.dynamodb_table
    key            = "shared/core.tfstate"
    encrypt        = local.encrypt
  }
}

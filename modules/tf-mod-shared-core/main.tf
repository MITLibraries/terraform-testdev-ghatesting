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

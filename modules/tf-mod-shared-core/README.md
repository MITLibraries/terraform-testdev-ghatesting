# Module tf_mod_shared_core

This module provides a layer of abstraction to accessing shared resources. It does not itself create any resources or maintain any state, it simply reads the state files of various shared resources. The goal is to hide some of the uglier, repetitive config blocks behind a clean interface.

When you add a new shared resource, you will also need to update this module with whatever outputs you want to provide access to.

Run `terraform-docs markdown table . --no-providers --no-requirements >> README.md` to append the updated Input and Output tables to this document

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| workspace | TF workspace | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| admin\_accounts | Names of the administrator accounts |
| deploy\_bucket | Shared Deploy Bucket name |
| deploy\_bucket\_rw\_arn | Shared Deploy Bucket Read/write policy ARN |
| s3\_state\_bucket | Name of the S3 bucket that holds remote state files |
| user\_accounts | Names of the user accounts |

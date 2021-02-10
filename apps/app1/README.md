# Apps / App1

This is dummy Terraform code for GitHub Actions testing.

## What's created?

* Nothing.

## Additional Info

As part of the `terraform plan` testing, we'll need to setup variables in the AWS SSM Parameter Store in the proper path for easy consumption by the AWS CLI. Everything will have to be organized properly so that a generic python script can move the data from AWS to a .tfvars file to be consumed by the GitHub Action.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| db\_password | The password for the database | `string` | n/a | yes |
| region | The default region for our Test/Dev environment. | `string` | `"us-east-1"` | no |
| server\_port | The port the server will use for HTTP requests | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| app1\_server\_port | the server port variable value |
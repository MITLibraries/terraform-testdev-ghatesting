# Apps / App1

This is dummy Terraform code for GitHub Actions testing.
**[added text to trigger a tf-validate run]**

## What's created?

* Nothing. All the variables are now stored in the correct path.

## Additional Info

No additional info.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | The default region for our Test/Dev environment. | `string` | `"us-east-1"` | no |
| users | A list of IAM accounts to create (usernames) | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| core\_users | The list of users |
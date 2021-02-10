# GitHub Workflow Testing Template

This is a Terraform monorepo used for testing GitHub Actions workflows. For more detailed documentation, see this private KB article.

## Workflows

### Terraform validate (tf-validate.yml)

Much of this was based on information found here <https://github.community/t/check-pushed-file-changes-with-git-diff-tree-in-github-actions/17220/10> and here <https://stackoverflow.com/a/62953566/11948346>. The workflow process is pretty straightforward.

1. The first job uses `git diff` to capture the subfolders that have changes and creates a matrix.
2. The second job uses the matrix output to kick off `terraform validate` for each subfolder with terraform changes.

The `terraform validate` is run with `-backend=false` and doesn't need any variables.

### Terraform plan (tf-plan-dev.yml and tf-plan-global.yml)

This is based on the same structure as **tf-validate.yml**: capture folders with changes and create a matrix for the next set of jobs. This time, there are additional steps to be completed.

1. The first job uses `git diff` to capture the subfolders that have changes and creates a matrix. (There are two different workflows for this right now because I couldn't get the logic to work correctly within just one workflow. One workflow for changes to /shared/core which requires the "global" workspace and one workflow for changes to /shared/network and /apps/** which uses the "dev" workspace.)
2. The second job uses the matrix output to kick off `terraform plan` for each subfolder with terraform changes.
3. The actual commands in the second job will do the following
    * read SSM Parameters via Python/boto3 to generate a **terraform.tfvars** file
    * run `terraform plan` and write the output as a comment on the PR (it's critical to use the `-no-color` option so that the code written to the PR is properly formatted)

### Terraform apply (tf-apply-dev.yml)

This is almost the same as **tf-plan-dev.yml** except the final step is to run `terraform apply -auto-approve` in the **dev** workspace. This will be triggered when a PR is closed and successfully merged to the `main` branch.

### Deploy/Promote to test

We will have a separate **tf-promote.yml** that can only be run manually from the Actions page in GitHub that will run `terraform apply -auto-approve` in the **test** and/or **global** workspace.

## What's created?

* Nothing other than YAML files in .github/workflows.

## Additional Info

## Other information not covered above

This is just for testing GitHub Actions workflows for Terraform in monorepos.

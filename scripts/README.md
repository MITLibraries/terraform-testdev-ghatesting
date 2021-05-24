# Scripts

## Python for processing variables

There are two scripts in this folder for handling the synchronization of terraform variables between the local developer environment and the central variable storage in AWS Parameter Store. The first script, `parameter_update.py`, is used manually by the developer to push the data from local `.tfvars` files to Parameter Store before a PR to ensure that the "Terraform Plan" GitHub Action will run correctly. The second script, `parameter_export.py` is used by the GitHub Action to establish variable values for the automated "Terraform Plan" run **AND** it is used by the developer to update the local `.tfvars` files to match the most recent data in Parameter Store.

Variable values in Parameter Store are organized by paths (analogous to folders). The general path construction looks like

```bash
/tfvars/<workspace>/<repo_name>/<branch_name>/<folder>/<subfolder>/variable_name
```

Thinking of this as a folder hierarchy, it would look like

## Layout

```bash
/tfvars
    dev/
       |- terraform-testdev-core/
          |- main/
             |- shared/
                |- network/
                   |- variable_one
                   |- variable_two
                   |- ...
                |- bastion
                   |- variable_ten
                   |- variable_eleven
          |- new_feature/
             |- shared/
                |- network/
                   |- variable_three
                   |- variable_four
                   |- ...
    test/
       |- terraform-testdev-core
          |- main/
             |- shared/
                |- network/
                   |- variable_one
                   |- variable_two
                   |- ...
          |- new_feature/
             |- shared/
                |- network/
                   |- variable_three
                   |- variable_four
                   |- ...
    global/
       |- terraform-testdev-core
          |- main/
             |- shared/
                |- core/
                   |- variable_five
                   |- variable_six
          |- new_feature
             |- shared/
                |- core/
                   |- variable_five
                   |- variable_six
```

Before running either of these scripts, dependencies must be installed. Either using `pip`:

```bash
cd scripts
python3 -m pip install -r requirements.txt`
```

or using `pipenv`:

```bash
cd scripts
pipenv install
```

### Script to push variables to Parameter Store

The `parameter_update.py` Python script will read variables from a local `<workspace>.tfvars` file and write those values into parameters in AWS Parameter Store. This must be done **before** creating a PR so that the "Terraform Plan" (`tf-plan-dev.yml`) GitHub Action workflow will run correctly. (That workflow pulls variables from Parameter Store using the script described in the next section.) The following block of code assumes that you are starting at the top of the repo. If you are already in the sub-folder where the `.tfvars` file exists, skip the `cd`. You must also ensure that `AWS_PROFILE` is set (e.g., `export AWS_PROFILE=<profile_name>`).

```bash
cd <folder>/<subfolder>
python3 ../../scripts/parameter_update.py -f <dev|test|global>.tfvars
```

This will write the variable values found in `<workspace>.tfvars` to `/tfvars/<workspace>/terraform-testdev-core/<active_git_branch>/<folder>/<subfolder>/<variable_name>`.

### Script to gather variables from Parameter Store

The `parameter_export.py` Python script will read variables from AWS Parameter Store and generate an `terraform.tfvars` file. The following block of code assumes that you are starting at the top of the repo. If you are already in the sub-folder where the `.tfvars` file exists, skip the `cd`. You must also ensure that `AWS_PROFILE` is set (e.g., `export AWS_PROFILE=<profile_name>`) and that `TF_WORKSPACE` is set (e.g., `export TF_WORKSPACE=dev`).

```bash
cd <folder>/<subfolder>
export AWS_PROFILE=<profile_name>
export TF_WORKSPACE=<dev|test|global>
python3 ../../scripts/parameter_export.py -p <folder>/<subfolder>`
```

This will pull all of the variables (and their values) from `/tfvars/<workspace>/terraform-testdev-core/<active_git_branch>/<folder>/<subfolder>` and store them in a file named `terraform.tfvars`. It is up to the developer to move this file to the correctly named `.tfvars` folder for the workspace (e.g., `dev.tfvars`).

### Cleanup pipenv

It is good practice to clean up the temporary `pipenv` environment when you are done. This can be done with

```bash
cd scripts
pipenv --rm
rm -rf Pipfile.lock
```

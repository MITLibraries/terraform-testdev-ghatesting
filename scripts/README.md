# Scripts

## Python for processing variables

The `aws_parse.py` Python script will read variables from AWS Parameter Store and generate an `terraform.tfvars` file.

Before running the script, dependencies do need to be installed with the following command:
    `python3 -m pip install -r requirements.txt`
 
After installing the dependencies, run the script with 
    `python3 aws_parse.py -p /global/budgets/ -r testdev_tf_cli_user`

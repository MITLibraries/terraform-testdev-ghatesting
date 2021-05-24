import json
import os

import boto3
from botocore.exceptions import ClientError
import click
from git import Repo
import hcl2


@click.command()
@click.option("-f", "--file_name", prompt="Enter the file name",
              help="The tfvars file name.")
def main(file_name):
    session = boto3.Session(profile_name=os.environ.get("AWS_PROFILE"))
    client = session.client("ssm")
    file_path = os.path.normpath(os.getcwd()).split(os.sep)
    dir_name = f"{file_path[-2]}/{file_path[-1]}"
    fname_no_ext = os.path.splitext(os.path.basename(file_name))[0]
    repo = Repo(os.path.abspath(os.path.join(__file__, "../..")))
    repo_name = repo.remotes.origin.url.split(".git")[0].split("/")[-1]
    branch_name = f"{repo_name}/{repo.active_branch.name}"
    tags = [{"Key": "terraform", "Value": "false"},
            {"Key": "appname", "Value": file_path[-1]},
            {"Key": "environment", "Value": fname_no_ext}]
    with open(file_name, "r") as f:
        params = hcl2.load(f)
        for param_name, param_value in params.items():
            full_param_name = (
                f"/tfvars/{fname_no_ext}/{branch_name}/{dir_name}/{param_name}"
            )
            try:
                output = client.get_parameter(Name=full_param_name)
                if output["Parameter"]["Value"] != json.dumps(param_value[0]):
                    client.put_parameter(Name=full_param_name,
                                         Value=json.dumps(param_value[0]),
                                         Overwrite=True)
                    print(full_param_name, "Found and updated")
                else:
                    print(full_param_name, "Found and matched")
            except ClientError:
                with open("variables.tf", "r") as file:
                    vars = hcl2.load(file)
                    for var in [v for v in vars["variable"]
                                if param_name in v]:
                        var_desc = var[param_name]["description"][0]
                client.put_parameter(Name=full_param_name,
                                     Value=json.dumps(param_value[0]),
                                     Description=var_desc, Type="String",
                                     Tags=tags)
                print(full_param_name, "Not found and created")


if __name__ == "__main__":
    main()

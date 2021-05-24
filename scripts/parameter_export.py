import os

import boto3
import click
from git import Repo


@click.command()
@click.option("-p", "--path", prompt="Enter the path",
              help="The path to the desired parameters.")
@click.option("-b", "--branch_name", default=None,
              help="The branch name to be updated.")
def main(path):
    repo = Repo(os.path.abspath(os.path.join(__file__, "../..")))
    repo_name = repo.remotes.origin.url.split(".git")[0].split("/")[-1]
    if branch_name is None:
        branch_name = repo.head.ref
    tf_ws = os.environ.get("TF_WORKSPACE")
    full_path = f"/tfvars/{tf_ws}/{repo_name}/{repo.head.ref}/{path}"
    session = boto3.Session(profile_name=os.environ.get("AWS_PROFILE"))
    client = session.client("ssm")
    with open("terraform.tfvars", "w") as f:
        output = client.get_parameters_by_path(Path=full_path)
        for param in output["Parameters"]:
            param_name = param["Name"][param["Name"].rfind("/") + 1:]
            param_value = param["Value"]
            f.write(f"{param_name} = {param_value}\n")


if __name__ == "__main__":
    main()

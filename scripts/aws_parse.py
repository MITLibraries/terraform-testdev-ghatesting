import boto3
import click

s3_client = boto3.client('s3')


@click.command()
@click.option('-p', '--path', prompt='Enter the path',
              help='The path to the desired parameters.')
def main(path):
    session = boto3.Session()
    client = session.client('ssm')
    with open('terraform.tfvars', 'w') as f:
        output = client.get_parameters_by_path(Path=path)
        for param in output['Parameters']:
            param_name = param['Name'][param['Name'].rfind('/') + 1:]
            param_value = param['Value']
            if param_value[0] in ['{', '['] :
                f.write(f'{param_name} = {param_value}\n')
            else:
                f.write(f'{param_name} = "{param_value}"\n')


if __name__ == '__main__':
    main()

# Terraform AWS Lambda Function with EventBridge Trigger

This Terraform repository contains configurations to deploy an AWS Lambda function triggered by a cron job (EventBridge rule) that runs every 5 minutes. The Lambda function (simple Hello-World function) is implemented using a Python script stored in the `app` folder.
## Folder Structure

1. ├── App
1. │   ├── Hello-World.py
1. │   └── Hello-World.zip
1. ├── LICENSE
1. ├── README.md
1. ├── backend.tf
1. ├── dev.tfvars
1. ├── locals.tf
1. ├── main.tf
1. ├── outputs.tf
1. ├── providers.tf
1. └── variables.tf

## Files Included

- **`main.tf`**: Defines the resources, including the Lambda function, EventBridge rule, IAM roles, archive_file (to zip the python code) and necessary permissions. NOTE: archive_file block is commented since the pyhton function is uploaded from S3. If you don't have your python function in S3, you can put .py file into app folder, uncomment archive_file, choose filename argument in aws_lambda_function resource.

- **`backend.tf`**: Configures the Terraform backend for state storage. S3 backend type is chosen as the backend type. A DynamoDB table
is used to lock the state file while running the deployment. 

- **`providers.tf`**: Specifies the AWS provider configuration. Ensure you have configured your AWS credentials via the AWS CLI or environment variables. If you want, you can store credentials locally in ~/.aws/credentials and use the shared_credentials_file attribute in the provider block.

- **`variables.tf`**: Declares input variables used in the Terraform configuration. Customize these variables based on your deployment requirements.

- **`outputs.tf`**: Defines output values that can be useful after deploying the infrastructure, such as Lambda function ARN and EventBridge rule ARN.

- **`dev.tfvars`**: Example Terraform variable file (`terraform.tfvars`) specific to the `dev` environment. Update this file with any environment-specific configuration values. More tfvars file can be added for other environments.

- **`app/Hello-World.py`**: Contains the Python code for the AWS Lambda function. Modify this file to implement the desired functionality for your Lambda function.

- **`.gitignore`**: It specifies intentionally untracked files that Git should ignore when tracking changes in a repository.
It helps exclude files and directories from being committed to the version control system (Git), preventing unnecessary clutter and ensuring that sensitive or generated files (e.g., log files, build artifacts, temporary files) are not included in the repository.

- **`LICENSE`**: It contains the legal terms and conditions under which the code in the repository is distributed and used. I have chosen GNU GENERAL PUBLIC LICENSE Version 3 for this repo.

## Configuration

Before running Terraform commands, ensure you have:

1. Installed Terraform CLI on your local machine.
2. Configured AWS credentials either via AWS CLI (`aws configure`) or environment variables (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`).
3. Updated the `dev.tfvars` file with appropriate values for your AWS account and environment.
4. Created the S3 bucket specified in the backend block.
5. Created DynamoDB table specified in the backend block.


## Deployment Instructions

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/mtahran/LambdawithCron.git
   cd LambdawithCron
   ```

2. Update the `dev.tfvars` file with any required variables.

3. Pass your credentials through CLI:
   ```bash
   export AWS_ACCESS_KEY_ID="<Your-Access-Key>"
   export AWS_SECRET_ACCESS_KEY="<Your-Secret-Key>"
   ```
4. Initialize Terraform and download providers:
   ```bash
   terraform init
   ```
5. Check if your configuration files have a consistent syntax.
   ```bash
   terraform validate
   ```
6. Format Terraform configuration files according to a consistent style defined by Terraform:
   ```bash
   terraform fmt
   ```
7. Preview the Terraform execution plan:
   ```bash
   terraform plan -var-file=dev.tfvars
   ```

8. Apply the Terraform configuration to create resources:
   ```bash
   terraform apply -var-file=dev.tfvars
   ```

9. After deployment, verify the resources created in your AWS account, including the Lambda function and EventBridge rule.

## Clean Up

To destroy the deployed infrastructure and resources:

```bash
terraform destroy -var-file=dev.tfvars
```

Confirm by entering `yes` when prompted.



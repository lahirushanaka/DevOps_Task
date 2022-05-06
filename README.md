# DevOps Tasks

URL Status check application run on On demand AWS Infrastructure through the Terraform

## Management machine Preparation 

Use the terraform installation guide [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install terraform.

Use the aws credentials guide [aws config](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) to install terraform.
if you using AWS EC2 as management machine, You can add IAM policies that required for provisioning. then execute below command to create default credentials. replace the region accordingly.
 


```bash
echo "[default]\nregion=ap-southeast-1\noutput=json" > ~/.aws/config
```
## Terraform 
All terraform code will available in terraform directory.
It will create one EC2 and security group to deploy this application. Also it will execute the user data script to configure EC2 instance to run that Python application.
### Terraform init
Here terraform code maintain its state file in remote location (S3)
More information on creating backend will be available in terraform [site](https://www.terraform.io/language/settings/backends/s3)
Command example as below, Replace the "test-s3-state-lahiru", "Project1/tfstate", 
```
terraform init -backend-config="bucket=test-s3-state-lahiru" -backend-config="key=Project1/tfstate" -backend-config="region=ap-southeast-1"  -backend-config="dynamodb_table=Terraform_State"
```
### Terraform Plan
var.tfvar is contain all variable that you want to change according to your aws account and environment. So update it before use, Once you updated you can run dry-run to test all configuration as applying properly.

```bash
terraform plan -var-file=var.tfvar
```
### Terraform Apply
This command will deploy above infrastructure in aws, 
```
terraform apply -auto-approve -var-file=var.tfvar
```


# File Structure -
```
app -
|   |__ requirements.txt - Python module that need to run the application
|   |__ urlcheck.py - Python Application
|   |__ url.csv - sample CSV file
|   |__ 
|
terraform - 
    |__ backend.tf - Terraform Stater file configuration
    |__ data.tf - Data source defined files
    |__ ec2.tf - AWS EC2 configuration 
    |__ main.tf - AWS plugins and provider configuration
    |__ output.tf - Output value configuration, This will print the IP and Port that you can access the URL status result.
    |__ sg.tf - security Group Creation
    |__ userdata.sh - User data file which allow to install and configure the application
    |__ variable.tf - contain terraform variables
    |__ var.tf - variable file
```

Default Port - 10000
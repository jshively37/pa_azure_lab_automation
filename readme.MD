# PA Azure Lab Automation

## Overview

This project is a work in progress. Currently, the goal is an MVP that will deploy a Palo Alto VM firewall, required Azure networking components, a Windows and Ubuntu jump box, and a Panorama instance. The Panorama instance is based on a specific variable, `create_panorama`, being passed.

GitHub issues are used to track issues and additions to this project. Contributions are welcome. I will work on contribution guidelines, but for now, reach out directly to me, and we can coordinate.

## Running this project.

#### Dependancies

This project is dependent on the Azure CLI and Terraform tools.

Project development used the following versions:

| Package   | Version |
|-----------|---------|
| terraform | 1.9.2   |
| az-cli    | 2.62.0  |
|           |         |

**Note**: This project has yet to be tested on OpenTofu.

To install Azure CLI tools, use the following link: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli.

To install Terraform, use the following link: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli.

#### Required files

* Change directory to `terraform\environments\dev`
* Create a file called `terraform.tfvars`
  * `terraform.tfvars.example` is an example of the expected outputs.
* Modify the file and save.

#### Executing the code
* Login to Azure using the following command: `az login --use-device-code`
* Change directory to `terraform\environments\dev`
* After logging in and run `terraform plan`.
  * If you are creating this without Panorama you should see 20 to add.
  * If you are creating this with Panorama you should see 22 to add.
* If you are happy with the output run `terraform apply`.
  * This will take approximately 10 minutes to run.
  * After completing it will take 5 minutes for the firewall to boot up and accept logins.

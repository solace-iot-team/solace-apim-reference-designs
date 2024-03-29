# Single-Node Setup

Scripts to install and deploy an Async-API management platform single-node setup in AWS.

- 1 AWS VPC
- 1 Public IP-Address assigned to EC2 
- AWS EC2 (1 EC2 instance)
- Docker-Host installed on EC2 machine
  - Async-API Platform API as Docker Container
  - Async-API Web Portal as Docker Container   
 


## Setup and Bootstrap

### Preconditions

#### 3rd Party Dependencies

Single-Node setup must connect to a MongoDB as persistence layer. MongoDB must be accessible and a user / password pair must be in place.

- MongoDB connection URL (e.g. `mongodb+srv://<username>:<password>@<server>/<server-path>?retryWrites=true&w=majority`)
- MongoDB Atlas might require adding Platform-API IP-Address to its allow-list
  - `ansible/register_ip_mongodbcloud.yml` automates this task already
    - Deployment host executing `ansible/register_ip_mongodbcloud.yml` must by itself
      - have access to MongoDB by utilizing an API Key 
      - be enlisted in IP-allow-list [cloud.MongoDB.com](https://cloud.mongodb.com) 
        - Access Manager -> API Keys -> Edit API Key -> Private Key & Access List 

#### Deployment Host

Linux based deployment host (tested on Mac OS) 
- Terraform must be installed  ( get it from [HashiCorp](https://www.terraform.io/))
- Ansible must be installed  (get it from the Project [Ansible](https://github.com/ansible) )
- AWS CLI and AWS Credentials should be installed (see [Terraform Prerequisites](https://learn.hashicorp.com/tutorials/terraform/aws-build))
  

### Adjust Defaults

Invoke script `prepare_automation_configuration.sh` once:
- `sensitive_ansible_vars.yml` will get created based on `template_sensitive_ansible_vars.yml`
- `terraform.tfvars.json` will get created based on `template_terraform.tfvars.json`

#### AWS Defaults
Adjust AWS infrastructure defaults in `vars/terraform.tfvars.json`

| Point of variation | default | purpose |
|-------------------|----------|---------|
| aws_region | eu-central-1 | AWS regsion
| ssh_key_filename | `../shared/keys/aws_key_box.pub`|points to aws-key for EC2. Get generated by Ansible during bootstrapping or can get provided up-front |
| ssh_key_name | `my_key_name`| ssh_key in ssh_key_file will get uploaded to AWS key-manager and referenced as `ssh_key_name` |
| ami_box_1 | `ami-0e0102e3ff768559b`|  AWS-AMI name, depending on aws_region. Must be Ubuntu 18.04 LTS based |
| isntance_type_box_1 |`t2.small` | AWS instance type |
| ebs_volume_box_1_size | `10`| Size in GB of mounted EBS volume of EC2 instance. MongoDB will store its data on this volume |  
| allowed_inbound_cidr_blocks | `["0.0.0.0.0/0"]` | List of CIDR blocks allowed to access setup |
| name_prefix | `async-api-selfcontained` | Prefix for AWS resources names (EC2, ....)  |
| tag_name_prefix | `async-api-selfcontained` | Prefix for TAGS of AWS resources  |
| tag_owner | `theOwner` | TAG `owner` of AWS resources  |
| tag_project | `async-api-selfcontained` | TAG `project` of AWS resources  |


Out of the box the EC2 instance is accessible from any IP-Address with ports opened

- 22 (SSH)
- 80 (Unencryted HTTP Traffic to Async-API Web Portal)
- 3000 (Unencrypted HTTP REST API of Async-API Platform API)

Close ports if not needed in (`terraform/main.tf #resource "aws_security_group" "sg_dmz"`)

#### Ansible Defaults

Adjust Ansible defaults in `vars/sensitive_ansible_vars.yml` 

:warning: It is strongly advised to change all default usernames and passwords 
| Point of variation | default | purpose / sample |
|--------------------|---------|---------|
| platform-api version | latest | Version TAG of Platform-API |
| portal_version | `latest` | Version TAG of Platform-API Portal Docker Container |
| sammode | `prod`| enable / disable authentication of Platform-API-Portal |
| solace_spa_user | `admin1` | Plaform-API username |
| solace_spa_password | `secret1` | Plaform-API secret1 |
| solace_spa_adminuser | `admin2` | Admin of Platform-API username| 
| solace_spa_adminpassword | `secret2` | Password of Admin Platform-API user| 
| solace_portal_login_user | `portal`| Username to access web portal |
| solace_portal_login_password | `secret3` | Password to access web portal |
| mongodb_cloud_api_url | placeholder | `https://cloud.mongodb.com/api/atlas/v1.0/groups/.../accessList` |
| mongodb_cloud_api_user | placeholder | `abcdefg` see preconditions |
| mongodb_cloud_api_password | placeholder | abc-efg-hij see preconditions |
| mongodb_url | placeholder | `mongodb+srv://<username>:<password>@<prefix>.mongodb.net/<some path>?retryWrites=true&w=majority`


### Bootstrap

Bootstrapping can get triggered by calling `create_infrastructure.sh`. 

After successfully bootstrapping EC2 instance IP and DNS-name can get found in `generated/boxes.json`

- Async-API Web Portal can get accessed at `http://<ec2-server-name | ec2-server-ip>`
- Async-API Platform API Swagger / OpenAPI specification can get accesses at: `http://http:<ec2-server-name | ec2-server-ip>:3000/api-explorer` 



### Destroy 

The entire infrastructure can get removed by calling `destroy_infrastructure.sh`
- it also removes IP-Address from MongoDB allow-list

### Change existing infrastructure

After bootstrapping the AWS infrastructure can get adjusted by tailoring terraform scripts and configuration files in `terraform/` and invoking `terraform apply` in folder `terraform/`. 

Ansible can get utilized to adjust and tailor the deployment and configuration of Platform-API and Platform-API Web Portal by adjusting Ansible files and invoking an Ansible playbook accordingly.

---



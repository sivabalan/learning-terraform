##################################################################################################################
# WHAT IS TERRAFORM ?
##################################################################################################################
    - Terraform is an Infrastructure as Code (IaC) tool 
    - Allows you to define and manage your infrastructure using a declarative - configuration language
    - Traditionally, without IaC, the cloud infrastructure was managed manually
    - This was not the most efficient way and was prone to manual errors
    - Consistency was a challenge, especially when many servers and clusters were to be managed

################################################################################################################## 
# TERRAFORM INSTALLATION
##################################################################################################################
# Method-1:
    $ brew tap hashicorp/tap
    $ brew install hashicorp/tap/terraform

# Method-2:
    $ wget https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_darwin_arm64.zip
    $ unzip terraform_1.8.5_darwin_arm64.zip
    $ mv terraform_1.8.5_darwin_arm64 terraform
    $ cp terraform/terraform /usr/local/bin
    $ export PATH=$PATH:/usr/local/bin/terraform
    $ terraform --version


##################################################################################################################
# AWS CLI
##################################################################################################################
    $ aws configure
    - AccessKey:          xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    - SecretAccessKey:    yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
    - region:             us-east-2
    - output:             json

##################################################################################################################
# PROVIDERS
##################################################################################################################
- Providers are responsible for managing the lifecycle of a resource
- Each provider is associated with one or more resource types

Ex:
  provider "aws" {
    region = "us-west-2"
  }

##################################################################################################################
# RESOURCES
##################################################################################################################
- Resources describe infrastructure objects
- A resource might be a physical server, a virtual machine, a DNS record, etc.

Ex:
  resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

##################################################################################################################
# RESOURCES
##################################################################################################################
Variables allow you to parameterize your Terraform configurations.

Ex:
  variable "instance_type" {
    description = "Type of the instance"
    default     = "t2.micro"
  }

  resource "aws_instance" "example" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = var.instance_type
  }

##################################################################################################################
# OUTPUTS
##################################################################################################################
- Outputs are used to extract information from your Terraform configurations.

Ex:
  output "instance_ip" {
    value = aws_instance.example.public_ip
  }

##################################################################################################################
# STATE
##################################################################################################################
- Terraform keeps track of the infrastructure it manages in a state file. 
- This file maps real-world resources to your configuration and helps with creating, updating, and deleting resources.


##################################################################################################################
# BACKEND
##################################################################################################################
- Terraform keeps track of the infrastructure it manages in a state file. 
- This file maps real-world resources to your configuration and helps with creating, updating, and deleting resources.

Ex:
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "global/s3/terraform.tfstate"
    region = "us-west-2"
  }
}

##################################################################################################################
# INTERPOLATION
##################################################################################################################
- Interpolation in Terraform allows you to reference variables, resource attributes, or other values within your configuration
- The syntax for interpolation is `${...}`.

  Ex:
  variable "instance_type" {
  default = "t2.micro"
  }

  resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "${var.instance_type}"
  }

##################################################################################################################
# MAPPING
##################################################################################################################
- Terraform Mapping are used for selecting choices based on input given

Ex:  
   resource "aws_launch_template" "main_launch_template" {
    name_prefix            = "main_launch_template"
    image_id               = var.ami_map[var.env]
    instance_type          = var.instance_type
    key_name               = var.key_name
    vpc_security_group_ids = [aws_security_group.main_sg.id]
    #user_data              = filebase64("./apache.sh")
    }

    variable "ami_map" {
    description = "Mapping of AMI based on Env"
    type        = map(string)
    default = {
        "dev"  = "ami-033fabdd332044f06" # For Dev Env, include Amazon Linux AMI
        "prod" = "ami-0f30a9c3a48f3fa79" # For Prod Env, include UBUNTU AMI
    }
    }

    variable "env" {
    description = "Selection for available Env"
    default     = "dev"
    }


##################################################################################################################
# CONDITIONALS
##################################################################################################################
- Terraform Condition are used for Choices ex: instance_types for AWS EC2

Syntax: 
 - condition ? <Value_when_true> : <Value_when_not_true>


dev: instance_type: t2.micro

prod: instance_type: m5.large


##################################################################################################################
# FOR EACH LOOP
##################################################################################################################
- Usage: Dynamically define the resources based on elements of map

Syntax: 
for_each = var.instances

ex:
variable "instances" {
  default = {
    "web-server1" = "ami-033fabdd332044f06"
    "web-server2" = "ami-0f30a9c3a48f3fa79"
  }
}

resource "aws_instance" "main_instances" {
  for_each      = var.instances
  ami           = each.value
  instance_type = var.env == "prod" ? "m5.large" : "t3.micro"
  key_name      = var.key_name
}


##################################################################################################################
# LOOPS
##################################################################################################################


##################################################################################################################
# LOCALS
##################################################################################################################
- Locals are variables that are to be called and availble for the block of code in which is written

ex:
  locals {
    instance_type="a1.large"
  }


  resource "aws_instance" "main_instances2" {
    for_each      = var.instances
    ami           = each.value
    instance_type = local.instance_type
    key_name      = var.key_name
  }


##################################################################################################################
# LOOKUP
##################################################################################################################
  - Look Up does search for outputs bases on inputs offered (Dyanmic Search)

  ex:

    # Using Lookup Function
  variable "ami_map" {
    description = "Mapping of AMI based on Env"
    type        = map(string)
    default = {
      "us-east-2" = "ami-09040d770ffe2224f" # For Ohio Region
      "us-west-2" = "ami-0cf2b4e024cdb6960" # For Oregon Region
    }
  }

  locals {
    image_id = lookup(var.ami_map, var.region)
  }


  resource "aws_launch_template" "main_launch_template" {
    name_prefix = "main_launch_template"
    #image_id              = var.ami_map[var.env]
    image_id               = local.image_id
    instance_type          = var.env == "prod" ? "m5.large" : "t3.micro"
    key_name               = var.key_name
    vpc_security_group_ids = [aws_security_group.main_sg.id]
    #user_data              = filebase64("./apache.sh")
  }


##################################################################################################################
# DATA SOURCES
##################################################################################################################
 - Data sources allow Terraform to use information defined outside of Terraform, or defined by another separate Terraform configuration.

Ex:
  data "aws_ami" "latest" {
    most_recent = true
    owners      = ["amazon"]

    filter {
      name   = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
  }

  resource "aws_instance" "example" {
    ami           = data.aws_ami.latest.id
    instance_type = "t2.micro"
  }


##################################################################################################################
# WORKSPACES
##################################################################################################################
Terraform workspaces allow you to manage multiple environments (such as development, staging, and production) using the same Terraform configuration. Here’s a detailed guide:

### Prerequisites
- Install Terraform: You need to have Terraform installed on your machine.
- Set up a cloud provider account (e.g., AWS, Azure, GCP) and have appropriate credentials.

### Step 1: Setting Up Terraform Directory
Create a new directory for your Terraform project.

```sh
mkdir terraform-workspace-example
cd terraform-workspace-example
```

### Step 2: Write Terraform Configuration
Create a `main.tf` file with the Terraform configuration. For this example, we'll deploy a simple AWS S3 bucket.

```hcl
provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "${var.environment}-example-bucket"
  acl    = "private"

  tags = {
    Name        = "${var.environment}-example-bucket"
    Environment = var.environment
  }
}

variable "environment" {
  description = "The environment to deploy the infrastructure (e.g., dev, staging, prod)"
  type        = string
}
```

### Step 3: Initialize Terraform
Initialize the Terraform configuration.

```sh
terraform init
```

### Step 4: Create Workspaces
Create workspaces for each environment. Terraform has a default workspace named "default". We will create additional workspaces for development and production.

```sh
terraform workspace new dev
terraform workspace new prod
```

### Step 5: Switch Between Workspaces
To switch between workspaces, use the `terraform workspace select` command.

```sh
terraform workspace select dev
```

### Step 6: Apply Configuration for Each Workspace
Before applying the configuration, set the `environment` variable to the appropriate value for each workspace. This can be done by creating a `terraform.tfvars` file for each environment.

Create a `dev.tfvars` file:

```hcl
environment = "dev"
```

Create a `prod.tfvars` file:

```hcl
environment = "prod"
```

Now, apply the configuration for each workspace:

#### For Development Environment

```sh
terraform workspace select dev
terraform apply -var-file="dev.tfvars"
```

#### For Production Environment

```sh
terraform workspace select prod
terraform apply -var-file="prod.tfvars"
```

### Step 7: Verify the Infrastructure
Check your cloud provider's console to verify that the infrastructure was created correctly for each environment. You should see separate S3 buckets for the development and production environments.

### Step 8: Modify Configuration
You can now modify the `main.tf` file as needed. For example, let's add a new tag to the S3 bucket.

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "${var.environment}-example-bucket"
  acl    = "private"

  tags = {
    Name        = "${var.environment}-example-bucket"
    Environment = var.environment
    Owner       = "terraform-admin"
  }
}
```

Reapply the configuration for each workspace to update the infrastructure:

#### For Development Environment

```sh
terraform workspace select dev
terraform apply -var-file="dev.tfvars"
```

#### For Production Environment

```sh
terraform workspace select prod
terraform apply -var-file="prod.tfvars"
```

### Step 9: Destroy Infrastructure (Optional)
If you need to destroy the infrastructure, run the `terraform destroy` command for each workspace.

#### For Development Environment

```sh
terraform workspace select dev
terraform destroy -var-file="dev.tfvars"
```

#### For Production Environment

```sh
terraform workspace select prod
terraform destroy -var-file="prod.tfvars"
```


##################################################################################################################
# MODULES
##################################################################################################################
Terraform modules are a powerful way to organize and reuse infrastructure code. A module is a container for multiple resources that are used together. They are similar to functions in programming: they allow you to group a set of resources and reuse this group in multiple places, avoiding code duplication.

Here’s an end-to-end example using Terraform modules.

### Prerequisites
- Terraform installed on your machine.
- Set up a cloud provider account (e.g., AWS, Azure, GCP) and have appropriate credentials.

### Step 1: Create Project Directory
Create a directory structure for your Terraform project.

```sh
mkdir terraform-modules-example
cd terraform-modules-example

mkdir modules
mkdir environments
mkdir -p environments/dev
mkdir -p environments/prod
```

### Step 2: Create a Module
Create a reusable module for your infrastructure. In this example, we'll create a module for an S3 bucket.

#### Create the S3 Module
Create a directory for your S3 bucket module inside the `modules` directory.

```sh
mkdir -p modules/s3_bucket
```

Create a `main.tf` file inside the `modules/s3_bucket` directory:

```hcl
# modules/s3_bucket/main.tf
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "The environment to deploy the infrastructure (e.g., dev, prod)"
  type        = string
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}
```

Create `outputs.tf` to output the bucket name:

```hcl
# modules/s3_bucket/outputs.tf
output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.example.bucket
}
```

### Step 3: Use the Module in Environments
Now, create configurations for different environments using this module.

#### Development Environment
Create a `main.tf` file inside the `environments/dev` directory:

```sh
# environments/dev/main.tf
module "s3_bucket" {
  source      = "../../modules/s3_bucket"
  bucket_name = "dev-example-bucket"
  environment = "dev"
}
```

Create a `terraform.tfvars` file inside the `environments/dev` directory:

```hcl
# environments/dev/terraform.tfvars
bucket_name = "dev-example-bucket"
environment = "dev"
```

#### Production Environment
Create a `main.tf` file inside the `environments/prod` directory:

```sh
# environments/prod/main.tf
module "s3_bucket" {
  source      = "../../modules/s3_bucket"
  bucket_name = "prod-example-bucket"
  environment = "prod"
}
```

Create a `terraform.tfvars` file inside the `environments/prod` directory:

```hcl
# environments/prod/terraform.tfvars
bucket_name = "prod-example-bucket"
environment = "prod"
```

### Step 4: Initialize and Apply Configuration
Initialize and apply the configuration for each environment.

#### For Development Environment
```sh
cd environments/dev
terraform init
terraform apply -var-file="terraform.tfvars"
```

#### For Production Environment
```sh
cd ../prod
terraform init
terraform apply -var-file="terraform.tfvars"
```

### Step 5: Verify the Infrastructure
Check your cloud provider's console to verify that the infrastructure was created correctly for each environment. You should see separate S3 buckets for the development and production environments.

### Step 6: Modify the Module
If you need to modify the infrastructure, update the module code in `modules/s3_bucket`. For example, let's add a versioning configuration to the S3 bucket.

```hcl
# modules/s3_bucket/main.tf
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "The environment to deploy the infrastructure (e.g., dev, prod)"
  type        = string
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}
```

Reapply the configuration for each environment to update the infrastructure:

#### For Development Environment
```sh
cd environments/dev
terraform apply -var-file="terraform.tfvars"
```

#### For Production Environment
```sh
cd ../prod
terraform apply -var-file="terraform.tfvars"
```

### Step 7: Destroy Infrastructure (Optional)
If you need to destroy the infrastructure, run the `terraform destroy` command for each environment.

#### For Development Environment
```sh
cd environments/dev
terraform destroy -var-file="terraform.tfvars"
```

#### For Production Environment
```sh
cd ../prod
terraform destroy -var-file="terraform.tfvars"
```

### Conclusion
This end-to-end example demonstrates how to use Terraform modules to manage reusable infrastructure components across multiple environments. By organizing your code into modules, you can maintain a clean and DRY (Don't Repeat Yourself) codebase, making it easier to manage and scale your infrastructure. Modules enhance the reusability, maintainability, and readability of your Terraform code.

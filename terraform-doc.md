##################################################################################################################
# WHAT IS TERRAFORM ?
##################################################################################################################
    - Terraform is an Infrastructure as Code (IaC) tool 
    - Allows you to define and manage your infrastructure using a declarative - configuration language
    - Traditionally, without IaC, the cloud infrastructure was managed manually
    - This was not the most efficient way and was prone to manual errors
    - Consistency was a challenge, especially when many servers and clusters were to be managed

############################################################################# 
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

locals {
  instance_type = "a1.large"
}

# For_each Loop Instance based on ENV Selection
resource "aws_instance" "main_instances1" {
  for_each      = var.instances
  ami           = each.value
  instance_type = var.env == "prod" ? "m5.large" : "t3.micro"
  key_name      = var.key_name
}

# For_each Loop Instance based on Locals
resource "aws_instance" "main_instances2" {
  for_each      = var.instances
  ami           = each.value
  instance_type = local.instance_type
  key_name      = var.key_name
}


# For Workspace instances, based on Env based using dev.tfvars and prod.tfvars
resource "aws_instance" "workspace_instances" {
  ami           = var.ami_map[var.env]
  instance_type = var.env == "prod" ? "m5.large" : "t3.micro"
  key_name      = var.key_name

  tags = {
    Name = "{var.environment}-workspace-instance"
  }
}

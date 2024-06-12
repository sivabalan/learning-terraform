locals {
  instance_type="a1.large"
}

resource "aws_instance" "main_instances1" {
  for_each      = var.instances
  ami           = each.value
  instance_type = var.env == "prod" ? "m5.large" : "t3.micro"
  key_name      = var.key_name
}

resource "aws_instance" "main_instances2" {
  for_each      = var.instances
  ami           = each.value
  instance_type = local.instance_type
  key_name      = var.key_name
}
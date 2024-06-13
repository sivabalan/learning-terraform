locals {
  instance_type = "a1.large"
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


resource "aws_instance" "workspace_instances" {
  ami           = var.ami_map[var.env]
  instance_type = var.env == "prod" ? "m5.large" : "t3.micro"
  key_name      = var.key_name

  tags = {
    Name = "{var.environment}-workspace-instance"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}


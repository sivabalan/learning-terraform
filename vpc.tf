resource "aws_vpc" "main_vpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main_vpc"
  }
}
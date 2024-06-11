variable "region" {
 description = "RegionReference"
  default = "us-east-2"
}


variable "vpc_full_cidr_block" {
  description = "VPC Full CIDR block"
  default = "192.168.0.0/16"
}

variable "zonea_public_subnet_cidr_block" {
  description = "Primary Zone A Public Subnet"
  default = "192.168.1.0/24"
}

variable "zonea_private_subnet_cidr_block" {
  description = "Primary Zone A Private Subnet"
  default = "192.168.2.0/24"
}

variable "zoneb_public_subnet_cidr_block" {
  description = "Secondary Zone B Public Subnet"
  default = "192.168.3.0/24"
}

variable "zoneb_private_subnet_cidr_block" {
  description = "Secondary Zone B Private Subnet"
  default = "192.168.4.0/24"
}
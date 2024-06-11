# Primary Zone with Public and Private Subnets

# Primary ZoneA with Public Subnet
resource "aws_subnet" "zonea_public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = "us-east-2a"
  cidr_block        = var.zonea_public_subnet_cidr_block
  tags = {
    Name = "zonea_public_subnet"
  }
}

# Primary ZoneA with Private Subnet
resource "aws_subnet" "zonea_private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = "us-east-2a"
  cidr_block        = var.zonea_private_subnet_cidr_block

  tags = {
    Name = "zonea_private_subnet"
  }
}


# Secondary Zone with Public and Private Subnets

# Secondary ZoneB with Public Subnet
resource "aws_subnet" "zoneb_public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = "us-east-2b"
  cidr_block        = var.zoneb_public_subnet_cidr_block
  tags = {
    Name = "zoneb_public_subnet"
  }
}

# Secondary ZoneB with Private Subnet
resource "aws_subnet" "zoneb_private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = "us-east-2b"
  cidr_block        = var.zoneb_private_subnet_cidr_block
  tags = {
    Name = "zoneb_private_subnet"
  }
}

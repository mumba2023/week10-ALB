# vpc
resource "aws_vpc" "vpc1" {
  cidr_block = "172.120.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "terraform-vpc"
    Env = "dev"
  }
}

resource "aws_eip" "ei" {
  
}
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.ei.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw1]
}

# internet gateway
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "IGW"
  }
}

# route table
resource "aws_route_table" "rtl1" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }
}

# public subnet
resource "aws_subnet" "public_subnet1" {
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "172.120.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "subnet-public-vpc"
    Env = "dev"
  }
}

resource "aws_subnet" "public_subnet2" {
  availability_zone = "us-east-1b"
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "172.120.2.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "subnet-public-vpc"
    Env = "dev"
  }
}
# private subnet
resource "aws_subnet" "private_subnet1" {
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "172.120.3.0/24"
  tags = {
    Name = "subnet-private-vpc"
    Env = "dev"
  }
}

resource "aws_subnet" "private_subnet2" {
  availability_zone = "us-east-1b"
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "172.120.4.0/24"
  tags = {
    Name = "subnet-private-vpc"
    Env = "dev"
  }
}

# route association

resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.rtl1.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.rtl1.id
}



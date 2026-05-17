resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

}

resource "aws_subnet" "web_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false

}

resource "aws_subnet" "web_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = false

}

resource "aws_subnet" "database_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false

}

resource "aws_subnet" "database_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.13.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = false

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "rt_aza" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_az_a.id
  }


}

resource "aws_route_table_association" "web_aza" {
  subnet_id      = aws_subnet.web_1.id
  route_table_id = aws_route_table.rt_aza.id
}

resource "aws_route_table_association" "web_azb" {
  subnet_id      = aws_subnet.web_2.id
  route_table_id = aws_route_table.rt_aza.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_nat_gateway" "nat_az_a" {
  subnet_id     = aws_subnet.public_1.id
  allocation_id = aws_eip.nat_a.id
}

resource "aws_eip" "nat_a" {
  domain = "vpc"
}

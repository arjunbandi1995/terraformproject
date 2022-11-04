terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.37.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "myvpc"
  }
}
resource "aws_subnet" "pub1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.0.0/17"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "pubsub-1"
  }
}
resource "aws_subnet" "pub2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.128.0/18"
  availability_zone = "us-east-1b"

  map_public_ip_on_launch = "true"

  tags = {
    Name = "pubsub-2"
  }
}
resource "aws_subnet" "dmz1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.192.0/19"
  availability_zone = "us-east-1a"
  tags = {
    Name = "dmzsub-1"
  }
}
resource "aws_subnet" "dmz2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.224.0/20"
  availability_zone = "us-east-1b"
  tags = {
    Name = "dmzsub-2"
  }
}
resource "aws_subnet" "priv1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.240.0/21"
  availability_zone = "us-east-1a"
  tags = {
    Name = "privsub-1"
  }
}
resource "aws_subnet" "priv2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.248.0/22"
  availability_zone = "us-east-1b"
  tags = {
    Name = "privsub-2"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "myigw"
  }
}
resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  } 
    tags = {
    name = "pubrt"
    }  
  }
  resource "aws_route_table" "dmzrt" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  } 
    tags = {
    name = "dmzrt"
    }  
  }
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.pubrt.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.pubrt.id
}
resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.dmz1.id
  route_table_id = aws_route_table.dmzrt.id
}
resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.dmz2.id
  route_table_id = aws_route_table.dmzrt.id
}

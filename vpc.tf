# VPC 구간
resource "aws_vpc" "project-vpc" {
  cidr_block           = "10.60.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "project-vpc"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "project-igw" {
  vpc_id = aws_vpc.project-vpc.id
  tags = {
    Name = "project-igw"
  }
}

resource "aws_eip" "nat" {
  vpc      = true
}

# Subnet 구간
resource "aws_subnet" "project-bastion" {
  vpc_id                  = aws_vpc.project-vpc.id
  cidr_block              = "10.60.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "project-bastion"
  }
}

resource "aws_subnet" "project-pri-1" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = "10.60.10.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "project-pri-1"
  }
}

resource "aws_subnet" "project-pri-2" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = "10.60.20.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "project-pri-2"
  }
}

resource "aws_subnet" "project-pri-3" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = "10.60.30.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "project-pri-3"
  }
}

# public 라우팅 테이블 생성
resource "aws_route_table" "project-bastion-rt" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-igw.id
  }
  tags = {
    Name = "project-bastion-rt"
  }
}

resource "aws_route_table_association" "project-bastion-rt" {
  subnet_id      = aws_subnet.project-bastion.id
  route_table_id = aws_route_table.project-bastion-rt.id
}

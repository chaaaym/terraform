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

# 탄력적 IP 생성
resource "aws_eip" "nat" {
  vpc      = true
}

# Subnet 구간
resource "aws_subnet" "project-bastion" {
  vpc_id                  = aws_vpc.project-vpc.id
  cidr_block              = "10.60.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true ## 퍼블릭 IPv4 주소 자동으로 할당하도록 하는 설정을 걸어 주어야 함
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

# Public Security Group 생성
resource "aws_security_group" "project-vpc-pub-sg" {
  vpc_id = aws_vpc.project-vpc.id
  name = "project-vpc-pub-sg"
  description = "project-vpc-pub-sg"
  tags = {
    Name = "public SG"
  }
}

## Public Security Group inbound rule
resource "aws_security_group_rule" "HTTP80" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "TCP"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.project-vpc-pub-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "SSH" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "TCP"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.project-vpc-pub-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "HTTP8080" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "TCP"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.project-vpc-pub-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

# Private Security Group
resource "aws_security_group" "project-vpc-pri-sg" {
  vpc_id = aws_vpc.project-vpc.id
  name = "project-vpc-pri-sg"
  description = "project-vpc-pri-sg"
  tags = {
    Name = "private SG"
  }
}

## Private Security Group inbound rules
resource "aws_security_group_rule" "DB" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "TCP"
  security_group_id = aws_security_group.project-vpc-pri-sg.id
  source_security_group_id = aws_security_group.project-vpc-pri-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

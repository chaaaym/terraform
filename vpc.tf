# VPC 생성
resource "aws_vpc" "project-vpc" {
  cidr_block           = "10.60.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "project-vpc"
  }
}

# DHCP 옵션 설정
resource "aws_vpc_dhcp_options" "dhcp" {
    domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "dhcp" {
  vpc_id          = aws_vpc.project-vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
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
  tags = {
    Name = "project-nat"
  }
}

# NAT 게이트웨이 생성
resource "aws_nat_gateway" "project-nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.project-pub-web.id

  tags = {
    Name = "project-nat"
  }

  depends_on = [aws_internet_gateway.project-igw]
}

# Subnet 생성
resource "aws_subnet" "project-pub-web" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = "10.60.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "project-pub-web"
  }
}

resource "aws_subnet" "project-pri-was-1" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = "10.60.2.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "project-pri-was-1"
  }
}

resource "aws_subnet" "project-pri-was-2" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = "10.60.20.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "project-pri-was-2
    "
  }
}

resource "aws_subnet" "project-pri-db-1" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = "10.60.3.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "project-pri-db-1"
  }
}

resource "aws_subnet" "project-pri-db-2" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = "10.60.30.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "project-pri-db-2"
  }
}

# public 라우팅 테이블 생성
resource "aws_route_table" "project-pub-rt" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-igw.id
  }
  tags = {
    Name = "project-pub-rt"
  }
}

resource "aws_route_table_association" "project-pub-rt-association" {
  subnet_id      = aws_subnet.project-pub-web.id
  route_table_id = aws_route_table.project-pub-rt.id
}

# Private 라우팅 테이블 생성
resource "aws_route_table" "project-pri-rt" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.project-nat.id
  }
  tags = {
    Name = "project-pri-rt"
  }
}

resource "aws_route_table_association" "project-pri-was-1-rt-association" {
  subnet_id      = aws_subnet.project-pri-was-1.id
  route_table_id = aws_route_table.project-pri-rt.id
}

resource "aws_route_table_association" "project-pri-was-2-rt-association" {
  subnet_id      = aws_subnet.project-pri-was-2.id
  route_table_id = aws_route_table.project-pri-rt.id
}

resource "aws_route_table_association" "project-pri-db-1-rt-association" {
  subnet_id      = aws_subnet.project-pri-db-1.id
  route_table_id = aws_route_table.project-pri-rt.id
}

resource "aws_route_table_association" "project-pri-db-2-rt-association" {
  subnet_id      = aws_subnet.project-pri-db-2.id
  route_table_id = aws_route_table.project-pri-rt.id
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

## Public Security Group inbound rule 연결
resource "aws_security_group_rule" "SSHpubin" {
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

resource "aws_security_group_rule" "HTTPpubin" {
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

resource "aws_security_group_rule" "ICMPpubin" {
  type = "ingress"
  from_port = -1
  to_port = -1
  protocol = "ICMP"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.project-vpc-pub-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "AllTCPpubout" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.project-vpc-pub-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

# Private Security Group 생성
# was
resource "aws_security_group" "project-vpc-was-sg" {
  vpc_id = aws_vpc.project-vpc.id
  name = "project-vpc-was-sg"
  description = "project-vpc-was-sg"
  tags = {
    Name = "private was SG"
  }
}

# db
resource "aws_security_group" "project-vpc-db-sg" {
  vpc_id = aws_vpc.project-vpc.id
  name = "project-vpc-db-sg"
  description = "project-vpc-db-sg"
  tags = {
    Name = "private db SG"
  }
}

## Private Security Group inbound rules
## was rule
resource "aws_security_group_rule" "SSHpriwasin" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "TCP"
  cidr_blocks = [ "10.60.0.0/16" ]
  security_group_id = aws_security_group.project-vpc-was-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "HTTPpriwasin" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "TCP"
  cidr_blocks = [ "10.60.0.0/16" ]
  security_group_id = aws_security_group.project-vpc-was-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ICMPpriwasin" {
  type = "ingress"
  from_port = -1
  to_port = -1
  protocol = "ICMP"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.project-vpc-was-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "AllTCPpriwasout" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.project-vpc-was-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

## db rule
resource "aws_security_group_rule" "dbSSHin" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "TCP"
  cidr_blocks = [ "10.60.0.0/16" ]
  security_group_id = aws_security_group.project-vpc-db-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "DBrulein" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "TCP"
  cidr_blocks = [ "10.60.0.0/16" ]
  security_group_id = aws_security_group.project-vpc-db-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ICMPpridbin" {
  type = "ingress"
  from_port = -1
  to_port = -1
  protocol = "ICMP"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.project-vpc-db-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "AllTCPpridbout" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.project-vpc-db-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

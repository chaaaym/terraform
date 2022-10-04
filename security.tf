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
resource "aws_security_group_rule" "project-SSH" {
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

# Private Security Group
resource "aws_security_group" "project-vpc-web-sg" {
  vpc_id = aws_vpc.project-vpc.id
  name = "project-vpc-web-sg"
  description = "project-vpc-web-sg"
  tags = {
    Name = "web SG"
  }
}

resource "aws_security_group" "project-vpc-was-sg" {
  vpc_id = aws_vpc.project-vpc.id
  name = "project-vpc-was-sg"
  description = "project-vpc-was-sg"
  tags = {
    Name = "was SG"
  }
}

resource "aws_security_group" "project-vpc-db-sg" {
  vpc_id = aws_vpc.project-vpc.id
  name = "project-vpc-db-sg"
  description = "project-vpc-db-sg"
  tags = {
    Name = "db SG"
  }
}

## Private Security Group inbound rules
resource "aws_security_group_rule" "project-web" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "TCP"
  security_group_id = aws_security_group.project-vpc-web-sg.id
  source_security_group_id = aws_security_group.project-vpc-web-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "project-was" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "TCP"
  security_group_id = aws_security_group.project-vpc-was-sg.id
  source_security_group_id = aws_security_group.project-vpc-was-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "project-db" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "TCP"
  security_group_id = aws_security_group.project-vpc-db-sg.id
  source_security_group_id = aws_security_group.project-vpc-db-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

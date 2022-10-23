#db subnet group 생성
resource "aws_db_subnet_group" "db_group"{
  name = "db_group"
  subnet_ids = [aws_subnet.project-pri-db-1.id,aws_subnet.project-pri-db-2.id]
  tags = {
    Name = "db subnet group"
  }
}

#db 생성
resource "aws_db_instance" "project-db"{
  allocated_storage = 8
  db_name = "projectdb"
  engine = "mariadb"
  engine_version = "10.6.8"
  instance_class = "db.t3.micro"
  username = "admin"
  password = "12341234"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.db_group.id
  vpc_security_group_ids      = ["${aws_security_group.project-vpc-db-sg.id}"]
  allow_major_version_upgrade = true
}
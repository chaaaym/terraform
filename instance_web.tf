# web 인스턴스 생성
resource "aws_instance" "web-instance" {
  ami                         = "ami-0d59ddf55cdda6e21"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.web-key.key_name}"
  subnet_id                   = "${aws_subnet.project-pub-web.id}"
  vpc_security_group_ids      = ["${aws_security_group.project-vpc-pub-sg.id}"]
  tags = {
    Name = "web-instance"
  }
}

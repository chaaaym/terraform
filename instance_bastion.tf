# 키 페어 생성
resource "aws_key_pair" "project-key" {
key_name   = "project-key"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC83fj5vR2xfuyZKXBt5GMdxOtjf01wRo4DqZB28gfghFyL3ucfzSZv8RgFrcUc+ZWt6Uxj85LC/0FyWmAW2vf23NTGuYmrMW2w4uwqWL9HjH7hKVNDy5fTho98FZhzGi7+WQLivdIEZXJK1xNdq/Lx/WTw+U+VJBMK/tgQHKSt//4qCX6hVN2b1+H8sEsVNV06QcgtOTV/lz/UIS/By8jz8f1RjmGjM3UcN4n+GLOeqD0XtukX9bJU7D+1PaxWCnZXFJQ0REdo82lXtXXoDWnk0tEIAi5T+dYdgwyBMO7iMf0hngY7GyEnoDVmhQla7j1hnkJf/OUvBAaJBYFUDENT root@project"
}

# bastion 인스턴스 생성
resource "aws_instance" "bastion-instance" {
  ami                         = "ami-0d59ddf55cdda6e21"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.project-key.key_name}"
  subnet_id                   = "${aws_subnet.project-bastion.id}"
  vpc_security_group_ids      = ["${aws_security_group.project-vpc-pub-sg.id}"]
  tags = {
    Name = "bastion-instance"
  }
}

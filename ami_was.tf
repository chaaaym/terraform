resource "aws_ami_from_instance" "project-was-ami" {
  name               = "project-was-ami"
  source_instance_id = "i-098ba1752ad81fe8a"
}
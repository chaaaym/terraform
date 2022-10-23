resource "aws_launch_template" "project-was-tem" {
  name = "project-was-tem"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
    }
  }

  iam_instance_profile {
    name = "project_role_profile"
  }

  image_id = "ami-0fd8281c97f36e208"

  instance_type = "t2.micro"

  key_name = "was-key"

  vpc_security_group_ids = ["${aws_security_group.project-vpc-was-sg.id}"]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "project-was"
    }
  }
}
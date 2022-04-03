resource "aws_launch_template" "this" {
  name                                 = "ec2-launch-template"
  image_id                             = data.aws_ami.packer_ami.id
  instance_type                        = var.instance_type
  instance_initiated_shutdown_behavior = "terminate"
  description                          = "Launch configuration for EC2 instances."
  vpc_security_group_ids = [
    aws_security_group.ec2_instances_launch_template.id
  ]

  block_device_mappings {
    device_name = "/dev/xvdb"
    ebs {
      delete_on_termination = "true"
      encrypted             = "false"
      volume_size           = 8
      volume_type           = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Env       = var.environment
      Terraform = true
    }
  }
}

resource "aws_security_group" "ec2_instances_launch_template" {
  name        = "ec2_instances_${var.environment}_launch_template"
  description = "EC2 instances security group."
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Enable http access."
  }

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "Enable ssh access."
  }

  tags = {
    Name      = "ec2_instances_launch_template"
    Env       = var.environment
    Terraform = true
  }
}
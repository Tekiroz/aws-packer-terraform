resource "aws_autoscaling_group" "app_servers" {
  name                  = "app_servers_asg"
  desired_capacity      = 3
  max_size              = 4
  min_size              = 1
  termination_policies  = ["AllocationStrategy","OldestLaunchTemplate","OldestInstance"]
  vpc_zone_identifier   = [ for subnet in data.aws_subnet.public_subnet : subnet.id  ]

  # Integration between the ASG and the ALB
  target_group_arns     = [aws_lb_target_group.app_servers_alb.arn]

  # Default health_check_type is EC2, which is a minimal health
  # check that considers an Instance unhealthy only if the AWS
  # hypervisor says the VM is completely down or unreachable.
  health_check_type     = "ELB"

  launch_template {
    id = aws_launch_template.app_servers.id
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "app-server-${var.environment}"
  }

  tag {
    key                 = "env"
    propagate_at_launch = true
    value               = var.environment
  }
}

resource "aws_launch_template" "app_servers" {
  name                                 = "ec2-launch-template"
  image_id                             = data.aws_ami.packer_ami.id
  instance_type                        = var.instance_type
  instance_initiated_shutdown_behavior = "terminate"
  description                          = "Launch configuration for EC2 instances."
  vpc_security_group_ids = [
    aws_security_group.app_servers.id
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

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "app_servers" {
  name        = "web_servers_${var.environment}"
  description = "EC2 web servers instances security group."
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
    Name      = "app_servers_launch_template"
    Env       = var.environment
    Terraform = true
  }
}
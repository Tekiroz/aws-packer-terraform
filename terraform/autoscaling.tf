resource "aws_autoscaling_group" "packer-servers" {
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  desired_capacity   = 3
  max_size           = 3
  min_size           = 3

  launch_template {
    id = aws_launch_template.this.id
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "packer-server"
  }

  tag {
    key                 = "env"
    propagate_at_launch = true
    value               = var.environment
  }
}
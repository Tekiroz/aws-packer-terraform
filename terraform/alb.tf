resource "aws_lb" "autoscaling" {
  name                        = "alb-${var.environment}"
  internal                    = false
  load_balancer_type          = "application"
  subnets                     = [for subnet in data.aws_subnet.public_subnet : subnet.id]
  enable_deletion_protection  = false
  security_groups             = [aws_security_group.autoscaling_alb.id]

  tags = {
    Name      = "alb-${var.environment}"
    Env       = var.environment
    Terraform = true
  }
}

resource "aws_security_group" "autoscaling_alb" {
  name = "alb-${var.environment}"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Enable http access from all."
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow to connect to http port."
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
  }
}

resource "aws_lb_target_group" "autoscaling-alb" {
  name      = "packer-server-ALB-${var.environment}"
  port      = 80
  vpc_id    = data.aws_vpc.default.id
  protocol  = "HTTP"

  health_check {
    enabled   = true
    matcher   = "200"
    path      = "/"
    port      = "80"
    protocol  = "HTTP"
  }

  tags = {
    Name      = "Autoscaling ALB for Packer Server."
    Env       = var.environment
    Terraform = true
  }
}

resource  "aws_lb_listener" "autoscaling-alb" {
  load_balancer_arn = aws_lb.autoscaling.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.autoscaling-alb.arn
  }
}
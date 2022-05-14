resource "aws_lb" "app_alb" {
  name                        = "app-servers-alb-${var.environment}"
  internal                    = false
  load_balancer_type          = "application"
  subnets                     = [for subnet in data.aws_subnet.public_subnet : subnet.id]
  enable_deletion_protection  = false
  security_groups             = [aws_security_group.app_servers_alb.id]

  tags = {
    Name      = "app-server-alb-${var.environment}"
    Env       = var.environment
    Terraform = true
  }
}

# Listen on a specific port and protocol.
resource  "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  # Default response for requests that don't match any listener rules.
  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.app_servers_alb.arn
  }
}

# One or more servers that receive requests from the load balancer. Only sends requests
# to healthy nodes.
resource "aws_lb_target_group" "app_servers_alb" {
  name      = "AppServerTargetGroup-${var.environment}"
  port      = 80
  vpc_id    = data.aws_vpc.default.id
  protocol  = "HTTP"

  health_check {
    enabled             = true
    matcher             = "200"
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 3
    interval            = 20
    healthy_threshold   = 2
    unhealthy_threshold = 2

  }

  tags = {
    Name      = "Target group for App Servers."
    Env       = var.environment
    Terraform = true
  }
}

resource "aws_security_group" "app_servers_alb" {
  name = "app-server-alb-${var.environment}"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all inbound http request."
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound http request."
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
  }
}

# Add a listener rule that send requests that match any path
# to the target group that contains the ASG
resource "aws_lb_listener_rule" "app_server_asg" {
  listener_arn = aws_lb_listener.app_listener.arn
  priority    = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_servers_alb.arn
  }
}
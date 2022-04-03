##########################################
# Application Load Balancer;
# NLBs only operate over protocol = "TCP"
##########################################
resource "aws_lb" "this" {
  name                        = "alb-${var.environment}"
  internal                    = false
  load_balancer_type          = "application"
  subnets                     = [for subnet in data.aws_subnet.public_subnet : subnet.id]
  enable_deletion_protection  = false
  security_groups             = [aws_security_group.alb.id]

  tags = {
    Name      = "alb-${var.environment}"
    Env       = var.environment
    Terraform = true
  }
}

##########################################
# ALB Security Group
##########################################
resource "aws_security_group" "alb" {
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

###########################################
# EC2 Instances Target Group
###########################################
resource "aws_lb_target_group" "ec2_instances" {
  name      = "ec2-instances-${var.environment}"
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
    Name      = "ec2_instances-${var.environment}"
    Env       = var.environment
    Terraform = true
  }
}

###############################################
# Attach each EC2 Instance to the Target Group
##############################################
resource "aws_lb_target_group_attachment" "ec2_instance_1" {
  target_group_arn = aws_lb_target_group.ec2_instances.arn
  target_id        = aws_instance.ec2_instance_1.id
  port             = "80"
}

resource "aws_lb_target_group_attachment" "ec2_instance_2" {
  target_group_arn = aws_lb_target_group.ec2_instances.arn
  target_id        = aws_instance.ec2_instance_2.id
  port             = "80"
}

resource "aws_lb_target_group_attachment" "ec2_instance_3" {
  target_group_arn = aws_lb_target_group.ec2_instances.arn
  target_id        = aws_instance.ec2_instance_3.id
  port             = "80"
}

###########################################
## ALB Listener
###########################################
resource  "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ec2_instances.arn
  }
}
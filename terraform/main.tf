provider "aws" {
  region  = var.region
  profile = var.profile
}

##########################################
# EC2 Instances
# edit ec2_instance variable to add/remove
# instances
##########################################
module "ec2-nodes" {
  source = "./modules/ec2_instances"

  environment   = var.environment
  vpc_id        = data.aws_vpc.default.id
  instance_type = var.instance_type
  ami           = data.aws_ami.packer_ami.id
  ec2_instances = var.ec2_instances
}

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
# ALB EC2 Instances Target Group
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
resource "aws_lb_target_group_attachment" "ec2-instances" {
  count = length(module.ec2-nodes.instance_id)

  target_group_arn = aws_lb_target_group.ec2_instances.arn
  target_id        = element(module.ec2-nodes.instance_id, count.index )
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
    type              = "forward"
    target_group_arn  = aws_lb_target_group.ec2_instances.arn
  }
}
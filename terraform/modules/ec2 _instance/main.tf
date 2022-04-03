############################################
# EC2 Instances
############################################
resource "aws_instance" "this" {
  for_each = var.ec2_instances

  instance_type           = var.instance_type
  ami                     = var.ami
  vpc_security_group_ids  = [aws_security_group.this.id]
  availability_zone       = "${var.region}${each.value.az}"

  tags = {
    Name      = each.value.name
    Env       = var.environment
    Terraform = true
  }
}

##########################################
# EC2 Instances Security Group
##########################################
resource "aws_security_group" "this" {
  name        = "ec2_instances_${var.environment}"
  description = "EC2 Instances security group."
  vpc_id      = var.vpc_id

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
    Name      = "ec2_instances"
    Env       = var.environment
    Terraform = true
  }
}
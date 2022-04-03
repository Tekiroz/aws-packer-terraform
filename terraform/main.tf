provider "aws" {
  region  = var.region
  profile = var.profile
}

##########################################
# EC2 Instance 1
##########################################
resource "aws_instance" "ec2_instance_1" {
  instance_type           = var.instance_type
  ami                     = data.aws_ami.packer_ami.id
  vpc_security_group_ids  = [aws_security_group.ec2_instances.id]
  availability_zone       = "${var.region}${var.ec2_instances.instance-1.az}"

  tags = {
    Name      = var.ec2_instances.instance-1.name
    Env       = var.environment
    Terraform = true
  }
}

##########################################
# EC2 Instance 2
##########################################
resource "aws_instance" "ec2_instance_2" {
  instance_type           = var.instance_type
  ami                     = data.aws_ami.packer_ami.id
  vpc_security_group_ids  = [aws_security_group.ec2_instances.id]
  availability_zone       = "${var.region}${var.ec2_instances.instance-2.az}"

  tags = {
    Name      = var.ec2_instances.instance-2.name
    Env       = var.environment
    Terraform = true
  }
}

##########################################
# EC2 Instance 3
##########################################
resource "aws_instance" "ec2_instance_3" {
  instance_type           = var.instance_type
  ami                     = data.aws_ami.packer_ami.id
  vpc_security_group_ids  = [aws_security_group.ec2_instances.id]
  availability_zone       = "${var.region}${var.ec2_instances.instance-3.az}"

  tags = {
    Name      = var.ec2_instances.instance-3.name
    Env       = var.environment
    Terraform = true
  }
}

##########################################
# EC2 Instances Security Group
##########################################
resource "aws_security_group" "ec2_instances" {
  name        = "ec2_instances_${var.environment}"
  description = "${var.ec2_instances.instance-2.name} security group."
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
    Name      = "ec2_instances"
    Env       = var.environment
    Terraform = true
  }
}
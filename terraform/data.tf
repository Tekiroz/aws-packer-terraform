# Default VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "public_subnet" {
  for_each  = var.ec2_instances
  availability_zone = "${var.region}${each.value.az}"
}

# AMI created with Packer
data "aws_ami" "packer_ami" {
  owners      = ["self"]
  name_regex  = "^nginx-mysql-*"
  most_recent = true

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  tags = {
    mysql-volume  = "no"
    env           = "learn-packer"
  }
}
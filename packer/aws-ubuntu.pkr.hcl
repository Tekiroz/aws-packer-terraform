packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_cloud" {
  type    = map(string)
  default =  {
    profile         = "tekiroz"
    region          = "eu-west-3"
    instance_type   = "t2.micro"
    source_ami      = "ami-0c6ebbd55ab05f070"  //Free Tier Ubuntu focal x86 
    ami_prefix      = "aws-ami"
    ami_user        = "ubuntu"
    ami_description = "AMI building to practice with Packer." 
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  ami_name  = "${var.aws_cloud.ami_prefix}-focal-${local.timestamp}"

}

source "amazon-ebs" "ubuntu-focal-ebs" {
  profile       = var.aws_cloud.profile
  region        = var.aws_cloud.region
  instance_type = var.aws_cloud.instance_type

  ami_name        = local.ami_name
  source_ami      = var.aws_cloud.source_ami
  ssh_username    = var.aws_cloud.ami_user
  ami_description = var.aws_cloud.ami_description

  launch_block_device_mappings {
    device_name           = "/dev/sdb"
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    os_version    = "Ubuntu-focal"
    base_ami_id   = "{{ .SourceAMI }}"
    base_ami_name = "{{ .SourceAMIName }}"
    env           = "learn-packer"
  }
}

build {
  name = "learn-packer"

  sources = [
    "source.amazon-ebs.ubuntu-focal-ebs"
  ]

  provisioner "ansible" {
    playbook_file     = "../ansible/playbooks/ami-provisioning.yaml"
    user              = var.aws_cloud.ami_user
    extra_arguments   = [
      "--extra-vars",
      "percona_ebs_volume=/dev/xvdb percona_ebs_volume_label=mysql-data percona_ebs_volume_directory=/mysql"

    ]  
  }
}
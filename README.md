# aws-packer-terraform

This repository contains a laboratory to learn how we can use Packer to create a custom AMI in AWS. The Packer template
used Ansible as provisioner. Once the new AMI is created, you can use terraform scripts to launch EC2 instances with
this new AMI. Feel free to collaborate if you want to learn/improve this lab! :-)

### Requirements
- **Packer** - To create identical machine images for multiple platforms from a template. [Download Packer](https://www.packer.io/downloads) 
- **Ansible** - For Packer and Vagrant provisioning tasks. [Ansible instalation link](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- **Terraform** -  [Terraform installation](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- **Vagrant** - To check and test Ansible roles on your local machine. [Vagrant instalation guide](https://www.vagrantup.com/docs/installation)
- **KVM-libvirt** - Local VM will be provisioner using KVM-libvirt. You will need to install [Vagrant libvirt plugin](https://www.vagrantup.com/docs/installation) too.
- **AWS account and AWS CLI installed** - We will use Amazon Web Service as public cloud provider. 
Use this guide to [install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and 
this one to know how to create a [AWS Free Tier](https://aws.amazon.com/free/?trk=6cf3ecbe-43bd-4e2c-a6bb-b6677c6a95d6&sc_channel=ps&sc_campaign=acquisition&sc_medium=ACQ-P|PS-GO|Brand|Desktop|SU|Core-Main|Core|IBERIA|EN|Text|PH&s_kwcid=AL!4422!3!508800279529!p!!g!!aws&ef_id=CjwKCAjwi6WSBhA-EiwA6Niok-7HiLEi68FkpijMkEvavLN7cPaX8kWZooHOAqsOFjASBsT_K_mAGRoCRAoQAvD_BwE:G:s&s_kwcid=AL!4422!3!508800279529!p!!g!!aws&all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all) 
account.
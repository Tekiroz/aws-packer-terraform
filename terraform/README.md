## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2-nodes"></a> [ec2-nodes](#module\_ec2-nodes) | ./modules/ec2_instances | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.ec2_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.ec2-instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.packer_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ec2_instances"></a> [ec2\_instances](#input\_ec2\_instances) | Map of EC2 instances to create. | <pre>map(object({<br>    name  = string,<br>    az    = string,<br>  }))</pre> | <pre>{<br>  "instance-1": {<br>    "az": "a",<br>    "name": "ubuntu-focal-1"<br>  },<br>  "instance-2": {<br>    "az": "b",<br>    "name": "ubuntu-focal-2"<br>  },<br>  "instance-3": {<br>    "az": "c",<br>    "name": "ubuntu-focal-3"<br>  }<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | To select the environment. | `string` | `"testing"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use for the instance (restricted to t2.micro). | `string` | `"t2.micro"` | no |
| <a name="input_profile"></a> [profile](#input\_profile) | The AWS CLI profile for API operations. | `string` | `"default"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where AWS operations will take place. | `string` | `"eu-west-3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | Application Load Balancer url. |
| <a name="output_instances_id"></a> [instances\_id](#output\_instances\_id) | The ID of all instances created. |
| <a name="output_instances_ip"></a> [instances\_ip](#output\_instances\_ip) | The IPv4 of all instances created. |

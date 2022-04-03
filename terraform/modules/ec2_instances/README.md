## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | AMI to use for the instance. | `string` | n/a | yes |
| <a name="input_ec2_instances"></a> [ec2\_instances](#input\_ec2\_instances) | EC2 instances information (instance name and availability zone). | <pre>map(object({<br>    name  = string<br>    az    = string<br>  }))</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | To select the environment. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use for the instance (restricted to t2.micro). | `string` | `"t2.micro"` | no |
| <a name="input_profile"></a> [profile](#input\_profile) | The AWS CLI profile for API operations. | `string` | `"default"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where AWS operations will take place. | `string` | `"eu-west-3"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID (Change this value will force a new resource.) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | Instances ID. |
| <a name="output_instance_ip"></a> [instance\_ip](#output\_instance\_ip) | Instances IP. |

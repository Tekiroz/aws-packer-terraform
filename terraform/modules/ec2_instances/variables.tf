variable "region" {
  type        = string
  default     = "eu-west-3"
  description = "The region where AWS operations will take place."
}

variable "profile" {
  type        = string
  default     = "default"
  description = "The AWS CLI profile for API operations."
}

variable "environment" {
  type        = string
  description = "To select the environment."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID (Change this value will force a new resource.)"
}

##################################
# EC2 instances variables.
##################################
variable  "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The instance type to use for the instance (restricted to t2.micro)."

  validation {
    condition = contains(["t2.micro"], var.instance_type)
    error_message = "Var `instance_type` restricted to \"t2.micro\" (for Free Tier)."
  }
}

variable  "ami" {
  type        = string
  description = "AMI to use for the instance."
}

variable  "ec2_instances" {
  type    = map(object({
    name  = string
    az    = string
  }))
  description = "EC2 instances information (instance name and availability zone)."
}
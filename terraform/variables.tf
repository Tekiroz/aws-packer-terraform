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
  default     = "testing"
  description = "To select the environment."
}

##################################
# EC2 instances variables
##################################
variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The instance type to use for the instance (restricted to t2.micro)."

  validation {
    condition     = contains(["t2.micro"], var.instance_type)
    error_message = "Var `instance_type` restricted to \"t2.micro\" (for Free Tier)."
  }
}

variable "ec2_instances" {
  type = map(object({
    name = string,
    az   = string,
  }))
  default = {
    "instance-1" = { name = "ubuntu-focal-1", az = "a" },
    "instance-2" = { name = "ubuntu-focal-2", az = "b" },
    "instance-3" = { name = "ubuntu-focal-3", az = "c" }
  }
  description = "Map of EC2 instances to create."
}
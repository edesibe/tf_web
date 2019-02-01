variable "region" {
  description = "The AWS region"
}

variable "environment" {
  description = "The name of our environment, i.e. development"
}

variable "key_name" {
  description = "The AWS key pair to use for resources"
}

variable "public_subnet_ids" {
  default    = []
  desription = "The list of public subnets to populate"
}

variable "private_subnet_ids" {
  default    = []
  desription = "The list of private subnets to populate"
}

variable "ami" {
  default = {
    "eu-central-1" = "ami-0bdf93799014acdc4"
  }

  description = "The AMIs to use for web and api instances"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "The instance type to launch "
}

variable "web_instance_count" {
  default     = 1
  description = "The number of Web instances to create"
}

variable "app_instance_count" {
  default     = 1
  description = "The number of App instances to create"
}

variable "vpc_id" {
  description = "The VPC ID to launch in"
}

variable "domain" {
  description = "The domain to use for the web service"
}

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
  default     = []
  description = "The list of public subnets to populate"
}

variable "private_subnet_ids" {
  default     = []
  description = "The list of private subnets to populate"
}

variable "ami" {
  description = "The AMIs (amazon linux) to use for WEB instances"
  default = {
    "eu-central-1" = "ami-0cfbf4f6db41068ac"
    "us-east-1" = "ami-0080e4c5bc078760e"
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

variable "vpc_id" {
  description = "The VPC ID to launch in"
}

variable "domain" {
  description = "The domain to use for the web service"
}

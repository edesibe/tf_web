# AWS Web service module for Terraform

A lightweight Web service module.

## Usage

```hcl
variable "domain" {
  default     = "edesibe.com"
  description = "The domain of our web service."
}

variable "web_instance_count" {
  default = 1
  description = "The number of Web instances to create"
}



module "web" {
  source             = "git@github.com:edesibe/tf_web"
  environment        = "${var.environment}"
  vpc_id             = "${module.vpc.vpc_id}"
  public_subnet_ids  = "${module.vpc.public_subnet_ids}"
  private_subnet_ids = "${module.vpc.private_subnet_ids}"
  web_instance_counts = ${var.web_instance_counts}"
  domain             = "${var.domain}"
  region             = "${var.region}"
  key_name           = "${var.key_name}"
}

output "web_elb_address" {
  value = "${module.web.web_elb_address}"
}

output "web_host_addresses" {
  value = ["${module.web.web_host_addresses}"]
}

```

Assumes you're building your Web service inside a VPC created from [this
module](https://github.com/edesibe/tf_vpc).

See `interface.tf` for additional configurable variables.

## License

MIT


output "web_elb_address" {
  value = "${aws_elb.web.dns_name}"
}

output "web_host_addresses" {
  value = "${aws_instance.web.*.private_ip}"
}


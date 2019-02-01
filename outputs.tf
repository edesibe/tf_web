output "web_alb_addres" {
  value = "${aws_elb.web.dns_name}"
}

output "web_host_address" {
  value = "${aws_instance.web.*.private_ip}"
}

output "app_host_address" {
  value = "${aws_instance.app.*.private_ip}"
}

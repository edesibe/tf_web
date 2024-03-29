# getting records from data provider aws_vpc
data "aws_vpc" "environment" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}"]
  }

  id = "${var.vpc_id}"
}

data "template_file" "this_file" {
  template = "${file("${path.module}/files/web_bootstrap.sh")}"
  count = "${var.web_instance_count}"

  vars {
    hostname = "web-${format("%03d", count.index + 1)}"
  }
}


# getting records from date provider aws_route53_zone
data "aws_route53_zone" "environment" {
  name = "${var.domain}."
}

resource "aws_instance" "web" {
  ami           = "${lookup(var.ami, var.region)}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  subnet_id     = "${element(var.public_subnet_ids, count.index)}"
  user_data     = "${element(data.template_file.this_file.*.rendered, count.index)}"

  vpc_security_group_ids = [
    "${aws_security_group.web_host_sg.id}",
  ]

  tags {
    Name = "${var.environment}-web-${count.index}"
    ENV = "${var.environment}"
  }

  count = "${var.web_instance_count}"
}

resource "aws_elb" "web" {
  name            = "${var.environment}-web-elb"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.web_inbound_sg.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:80"
    interval            = 30
  }

  instances = ["${aws_instance.web.*.id}"]
}

resource "aws_route53_record" "web" {
  zone_id = "${data.aws_route53_zone.environment.zone_id}"
  name    = "${var.environment}.${var.domain}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_elb.web.dns_name}"]
}

resource "aws_route53_record" "web_alias" {
  zone_id = "${data.aws_route53_zone.environment.zone_id}"
  name    = "${var.environment}-alias.${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_elb.web.dns_name}"
    zone_id                = "${aws_elb.web.zone_id}"
    evaluate_target_health = true
  }
}


resource "aws_security_group" "web_inbound_sg" {
  name        = "${var.environment}-web-inbound"
  description = "Allow HTTP from Anywhere"
  vpc_id      = "${data.aws_vpc.environment.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}-web-inbound-sg"
  }
}

resource "aws_security_group" "web_host_sg" {
  name        = "${var.environment}-web-host"
  description = "Allow SSH and HTTP to web hosts"
  vpc_id      = "${data.aws_vpc.environment.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.environment.cidr_block}"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.environment.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}-web-host-sg"
  }
}


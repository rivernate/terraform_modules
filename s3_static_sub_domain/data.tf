data "aws_route53_zone" "zone" {
  name = "${var.root_domain_name}"
}

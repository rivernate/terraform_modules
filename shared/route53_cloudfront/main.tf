data "aws_route53_zone" "zone" {
  name = "${var.root_domain_name}"
}

// This Route53 record will point at our CloudFront distribution.
resource "aws_route53_record" "sub_domain" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.domain_name}"
  type    = "A"

  alias = {
    name                   = "${var.cloudfront_ditribution_domain}"
    zone_id                = "${var.cloudfront_distribution_hosted_zone_id}"
    evaluate_target_health = false
  }
}
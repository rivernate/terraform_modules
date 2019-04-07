resource "aws_route53_zone" "zone" {
  name = "${var.root_domain_name}"
}

resource "aws_acm_certificate" "certificate" {
  domain_name       = "${var.root_domain_name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "validation" {
  zone_id = "${aws_route53_zone.zone.id}"
  type    = "${aws_acm_certificate.certificate.domain_validation_options.0.resource_record_type}"
  name    = "${aws_acm_certificate.certificate.domain_validation_options.0.resource_record_name}"
  records = ["${aws_acm_certificate.certificate.domain_validation_options.0.resource_record_value}"]
  ttl     = "300"
}

module s3_website {
  source      = "../shared/s3_website"
  domain_name = "${var.root_domain_name}"
}

module s3_cloudfront_distribution {
  source              = "../shared/s3_cloudfront_distribution"
  acm_certificate_arn = "${aws_acm_certificate.certificate.arn}"
  domain_name         = "${var.root_domain_name}"
  s3_website_endpoint = "${module.s3_website.website_endpoint}"
}

module route53_cloudfront {
  source                                 = "../shared/route53_cloudfront"
  cloudfront_distribution_hosted_zone_id = "${module.s3_cloudfront_distribution.hosted_zone_id}"
  cloudfront_ditribution_domain          = "${module.s3_cloudfront_distribution.domain_name}"
  domain_name                            = "${var.root_domain_name}"
  root_domain_name                       = "${var.root_domain_name}"
}

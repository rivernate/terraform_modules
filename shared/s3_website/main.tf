resource "aws_s3_bucket" "site_bucket" {
  bucket = "${var.domain_name}"
  acl    = "public-read"
  policy = "${data.aws_iam_policy_document.bucket_policy.json}"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

data aws_iam_policy_document "bucket_policy" {
  version = "2012-10-17"
  statement {
    sid = "AddPerm"
    effect = "Allow"
    actions = ["s3:GetObject"]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    resources = ["arn:aws:s3:::${var.domain_name}/*"]
  }
}

output "website_endpoint" {
  value = "${aws_s3_bucket.site_bucket.website_endpoint}"
}
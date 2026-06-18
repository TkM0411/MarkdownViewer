resource "aws_cloudfront_origin_access_control" "s3_bucket_oac" {
  name                              = "${local.infraprefix}-s3bucket-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "website_cloudfront_distribution" {
  origin {
    domain_name              = aws_s3_bucket.frontend_content_bucket.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.frontend_content_bucket.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_bucket_oac.id
  }

  aliases = [
    "*.${var.custom_domain_name}",
    "${local.infraprefix}.${var.custom_domain_name}"
  ]
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for ${var.project} Static Website"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-${aws_s3_bucket.frontend_content_bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.custom_domain_ssl_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project} Static Website"
  })
}
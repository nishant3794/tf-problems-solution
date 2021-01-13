variable "bucket_name" { }
variable "acm_certificate_arn" { }
variable "zone_id" { }
variable "domain_name" { }
variable "aliases" { }

resource "aws_s3_bucket" "website" {
    bucket = var.bucket_name
    acl = "public-read"
    website {
      index_document = "index.html"
    }
    /*server_side_encryption_configuration {
      rule {
          apply_server_side_encryption_by_default{
              sse_algorithm = "AES256"
          }
      }
    }*/
  
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "PolicyForWebsiteEndpointsPublicContent",
  "Statement": [
    {
      "Sid": "PublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "${aws_s3_bucket.website.arn}/*",
        "${aws_s3_bucket.website.arn}"
      ]
    }
  ]
}
POLICY
}


resource "aws_cloudfront_distribution" "website" {
    enabled = true
    origin {
      origin_id = "origin-${aws_s3_bucket.website.id}"
      domain_name = aws_s3_bucket.website.website_endpoint
      custom_origin_config {
        origin_protocol_policy = "http-only"
        http_port = "80"
        https_port = "443"
        origin_ssl_protocols = ["TLSv1.2", "TLSv1.1", "TLSv1"]
    }
    }
    
    default_root_object = "index.html"
    default_cache_behavior {
      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods = ["GET", "HEAD", "OPTIONS"]
      target_origin_id = "origin-${aws_s3_bucket.website.id}"
      min_ttl = "0"
      max_ttl = "1200"
      default_ttl = "300"
      viewer_protocol_policy = "redirect-to-https"
      compress = true
       forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
     }
     viewer_certificate {
       acm_certificate_arn = var.acm_certificate_arn
       ssl_support_method = "sni-only"
     }
     restrictions {
       geo_restriction {
           restriction_type = "none"
       }
     }
     aliases =  var.aliases
}

resource "aws_route53_record" "website" {
    zone_id = var.zone_id
    name = var.domain_name
    type = "A"
    alias {
      name = aws_cloudfront_distribution.website.domain_name
      zone_id = aws_cloudfront_distribution.website.hosted_zone_id
      evaluate_target_health = false
    }
  
}
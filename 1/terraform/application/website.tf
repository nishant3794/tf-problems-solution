module "static_website" {
    source = "../modules/s3_static_website"
    bucket_name = "nishant-coda.assessments.coda.run"
    acm_certificate_arn = data.aws_acm_certificate.cert.arn
    zone_id = data.aws_route53_zone.zone.zone_id
    domain_name = "nishant-coda.assessments.coda.run"
}
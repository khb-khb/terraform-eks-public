data "aws_route53_zone" "main" {
  provider     = aws.oregon
  name         = var.domain_name
  private_zone = false
}

# ALB용 인증서 요청
resource "aws_acm_certificate" "main" {
  provider = aws.oregon

  domain_name = var.domain_name
  # 기본 도메인 + www 도메인 둘 다 처리, *.${var.domain_name} 도 가능하지만 정확한 도메인 관리를 위해 필요시마다 추가
  # san 방식으로 한 인증서에 여러 도메인을 넣는 방식
  subject_alternative_names = var.san_domain_name
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# ALB용 ACM 인증서 DNS 검증 CNAME 레코드 생성
resource "aws_route53_record" "cert_validation" {
  provider = aws.oregon

  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]

  allow_overwrite = true
}

# ALB용 ACM 인증서 검증 완료 대기
resource "aws_acm_certificate_validation" "main" {
  provider = aws.oregon

  certificate_arn = aws_acm_certificate.main.arn
  validation_record_fqdns = [
    for record in aws_route53_record.cert_validation : record.fqdn
  ]
}

resource "aws_route53_record" "db" {
  zone_id = var.r53_zone_id
  name    = "db"
  type    = "A"

  alias {
    name                   = aws_db_instance.db.address
    zone_id                = aws_db_instance.db.hosted_zone_id
    evaluate_target_health = true
  }
}

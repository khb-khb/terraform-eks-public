resource "aws_sns_topic" "cloudwatch_alarm" {
  name = var.sns_name
}

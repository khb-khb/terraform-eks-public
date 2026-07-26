resource "aws_chatbot_slack_channel_configuration" "alarm" {
  configuration_name = var.configuration_name

  slack_team_id    = var.slack_team_id
  slack_channel_id = var.slack_channel_id

  iam_role_arn = var.chatbot_role_arn

  sns_topic_arns = [
    var.sns_topic_arns
  ]
}

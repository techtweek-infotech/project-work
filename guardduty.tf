#sns 

resource "aws_sns_topic" "guardduty_sns_topic" {
  name            = var.sns_topic_name
  delivery_policy = file("${path.module}/../../../template/sns_delivery_policy.json")
    
  tags = {
   Name = var.sns_topic_name
}
}

resource "aws_sns_topic_subscription" "guardguty_notifications" {
  topic_arn = aws_sns_topic.guardduty_sns_topic.arn
  protocol  = var.guardduty_subscription_protocol
  endpoint  = var.guardduty_notification_endpoint
}

#cloudwatch

resource "aws_cloudwatch_event_rule" "guardduty-finding-events" {
  name          = "guardduty-finding-events"
  description   = "Capture AWS GuardDuty event findings"
  event_pattern = file("${path.module}/../../../template/guardduty-event-pattern.json")

   tags = {
   Name = "guardduty-finding-events"
}
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.guardduty-finding-events.name
  target_id = "send-to-sns"
  arn       = aws_sns_topic.guardduty_sns_topic.arn

  input_transformer {
    input_paths = {
      title = "$.detail.title"
    }

    input_template = "\"GuardDuty finding: <title>\""
  }
}

#guardduty

resource "aws_guardduty_detector" "guardduty" {
  enable = var.guardduty_enabled
}

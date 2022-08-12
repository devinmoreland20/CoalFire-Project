

resource "aws_autoscaling_notification" "launch_notifications" {
  group_names   = [var.asg_group_names]
  notifications = [var.notifications]
  topic_arn     = aws_sns_topic.anonymous.arn
}
resource "aws_sns_topic" "anonymous" {
  name       = var.sns_topic_name
  fifo_topic = var.fifo_topic
}
resource "aws_sns_topic_subscription" "anonymous" {
  topic_arn = aws_sns_topic.anonymous.arn
  protocol  = var.sub_protocol
  endpoint  = var.sub_endpoint
}

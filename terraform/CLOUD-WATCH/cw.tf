resource "aws_cloudwatch_metric_alarm" "flask_alarm" {
  alarm_name          = "cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "default"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors Flask app cpu utilization "
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  insufficient_data_actions = []
}

# SNS topic to send emails with the Alerts
resource "aws_sns_topic" "alarm" {
  name              = "my-alarm-topic"
  kms_master_key_id = aws_kms_key.sns_encryption_key.id
  delivery_policy   = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
  ## This local exec, suscribes your email to the topic 
  provisioner "local-exec" {
      // Update EMAIL and REGION
    command = "aws sns subscribe --topic-arn aws_sns_topic.alarm.arn --protocol email --notification-endpoint xxxx@rewind.io --region us-east-1"
  }
}


## KMS Key to encrypt the SNS topic (security best practises)
resource "aws_kms_key" "sns_encryption_key" {
  description             = "alarms sns topic encryption key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

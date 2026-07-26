resource "aws_cloudwatch_metric_alarm" "eks_node_cpu_high" {
  alarm_name          = "${var.cluster_name}-node-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "node_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "EKS node CPU utilization is high"

  dimensions = {
    ClusterName = var.cluster_name
  }

  alarm_actions = var.alarm_actions
}

resource "aws_cloudwatch_metric_alarm" "eks_node_memory_high" {
  alarm_name          = "${var.cluster_name}-node-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "node_memory_utilization"
  namespace           = "ContainerInsights"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "EKS node memory utilization is high"

  dimensions = {
    ClusterName = var.cluster_name
  }

  alarm_actions = var.alarm_actions
}

resource "aws_cloudwatch_metric_alarm" "eks_node_count_high" {
  alarm_name          = "${var.cluster_name}-node-count-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1

  namespace   = "ContainerInsights"
  metric_name = "cluster_node_count"
  period      = 300
  statistic   = "Average"
  threshold   = 1

  dimensions = {
    ClusterName = var.cluster_name
  }

  alarm_description = "EKS node count increased"
  alarm_actions     = var.alarm_actions
}

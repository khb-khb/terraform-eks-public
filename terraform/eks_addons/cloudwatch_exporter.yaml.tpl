aws:
  region: ${region}

serviceAccount:
  create: true
  name: cloudwatch-exporter
  annotations:
    eks.amazonaws.com/role-arn: ${role_arn}

service:
  type: ClusterIP
  port: 9106

config: |-
  region: ${region}
  metrics:
    - aws_namespace: AWS/ApplicationELB
      aws_metric_name: RequestCountPerTarget
      aws_dimensions:
        - LoadBalancer
        - TargetGroup
      aws_statistics:
        - Sum
      period_seconds: 60
      range_seconds: 300
      delay_seconds: 120
    
    - aws_namespace: AWS/ApplicationELB
      aws_metric_name: HealthyHostCount
      aws_dimensions:
        - TargetGroup
        - LoadBalancer
      aws_statistics:
        - Average
      period_seconds: 60
      range_seconds: 300
      delay_seconds: 120

    - aws_namespace: AWS/ApplicationELB
      aws_metric_name: HTTPCode_Target_5XX_Count
      aws_dimensions:
        - TargetGroup
        - LoadBalancer
      aws_statistics:
        - Sum
      period_seconds: 60
      range_seconds: 900
      delay_seconds: 180

    - aws_namespace: AWS/ApplicationELB
      aws_metric_name: HTTPCode_Target_5XX_Count
      aws_dimensions:
        - LoadBalancer
      aws_statistics:
        - Sum
      period_seconds: 60
      range_seconds: 900
      delay_seconds: 180
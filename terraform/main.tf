module "vpc" {
  source = "./vpc"

  vpc_cidr_block     = var.vpc_cidr_block
  subnets            = var.subnets
  nat_gw_subnet_name = "public_subnet_2a"
}

module "ecr" {
  source = "./ecr"

  ecr_repos = {
    web   = "web"
    admin = "admin"
    api   = "admin-api"
    keda  = "keda"
  }

}

module "eks" {
  source = "./eks"

  eks_cluster = {
    managed = {
      cluster_name       = "Cluster_Name"
      cluster_role_arn   = module.iam_role.eks_cluster_role_arn
      version            = "1.35"
      cluster_subnet_ids = module.vpc.private_subnet_ids
    }
  }

  eks_node_group = {
    managed_node = {
      cluster_key      = "managed"
      node_group_name  = "Node_Group_Name"
      node_role_arn    = module.iam_role.eks_node_role_arn
      node_subnet_ids  = module.vpc.private_subnet_ids
      instance_types   = ["t3.large"]
      capacity_type    = "ON_DEMAND"
      nodegroup_labels = "managed"

      desired_size = 2
      min_size     = 1
      max_size     = 3
    }
  }
  cluster_name = "Cluster_Name"

  eks_access_entries = {
    admin = {
      principal_arn = "arn:aws:iam::Account_ID:user/terraform"
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      access_scope  = "cluster"
    }

    github_actions = {
      principal_arn = "arn:aws:iam::Account_ID:role/github-actions-eks-deploy-role"
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      access_scope  = "cluster"
    }
  }
  karpenter_node_role_arn = module.iam_role.karpenter_node_role_arn
}

module "iam_role" {
  source = "./iam_role"

  eks_cluster_role_name        = "eks_cluster_role"
  eks_node_role_name           = "eks_node_role"
  monitoring_chatbot_role_name = "cloudwatch_chatbot_role"

  oidc_provider_arn = module.eks.oidc_provider_arn["managed"]
  oidc_provider_url = module.eks.oidc_provider_url_https_del["managed"]

  cluster_name                         = module.eks.cluster_name["managed"]
  region                               = "us-west-2"
  account_id                           = "Account_ID"
  karpenter_controller_policy_name     = "karpenter_controller_policy"
  karpenter_node_instance_profile_name = "karpenter_node_instance_profile"
  karpenter_node_role_name             = "karpenter_node_role"
  karpenter_controller_role_name       = module.irsa.karpenter_controller_role_name
}

module "eks_addons" {
  source = "./eks_addons"

  cluster_name        = module.eks.cluster_name["managed"]
  aws_region          = "us-west-2"
  vpc_id              = module.vpc.vpc_id
  acm_certificate_arn = module.acm.certificate_arn
  my_ip_cidr          = "My_IP"

  alb_controller_role_arn = module.irsa.alb_controller_role_arn
  eso_role_arn            = module.irsa.external_secrets_role_arn
  external_dns_role_arn   = module.irsa.external_dns_role_arn

  # karpenter 로 대체
  #cluster_autoscaler_role_arn = module.iam_role.cluster_autoscaler_role_arn

  domain_name = "kim-test.shop"

  argocd_repo_name = "repo-terraform-eks"

  # github app
  repo_url                    = "Git Repo URL"
  github_app_id               = "Git App ID"
  github_app_installation_id  = "Git installation ID"
  github_app_private_key_name = module.secrets_manager.github_app_private_key_name


  cluster_endpoint              = module.eks.cluster_endpoint["managed"]
  karpenter_controller_role_arn = module.irsa.karpenter_controller_role_arn
  karpenter_node_role_name      = module.iam_role.karpenter_node_role_name

  api_namespace    = "admin-api"
  default_name     = "default"
  default_workload = "default"
  pii_name         = "pii"
  pii_workload     = "pii"

  loki_storage_size = "10Gi"
  loki_replicas     = 1
  loki_url          = "http://loki:3100/loki/api/v1/push"
  loki_s3_name      = module.s3.bucket_name["loki"]
  loki_role_arn     = module.irsa.loki_s3_role_arn

  keda_irsa_role_arn = module.irsa.keda_role_arn

  cloudwatch_exporter_arn = module.irsa.cloudwatch_exporter_arn

  depends_on = [
    module.eks,
    module.namespace
  ]

}

module "cloudwatch_alarm" {
  source = "./cloudwatch_alarm"

  cluster_name = module.eks.cluster_name["managed"]
  alarm_actions = [
    module.sns.cloudwatch_alarm_topic_arn
  ]
}

module "sns" {
  source = "./sns"

  sns_name = "eks-cloudwatch-alarm-topic"
}

module "chatbot" {
  source = "./chatbot"

  configuration_name = "eks-alarm"
  slack_team_id      = "Slack Team ID"
  slack_channel_id   = "Slack Channel ID"
  chatbot_role_arn   = module.iam_role.monitoring_chatbot_role_arn
  sns_topic_arns     = module.sns.cloudwatch_alarm_topic_arn
}

module "acm" {
  source = "./acm"

  providers = {
    aws.oregon   = aws.oregon
    aws.virginia = aws.virginia
  }

  domain_name = "Domain_Name"
  san_domain_name = [
    "*.Domain_Name"
  ]
}

module "namespace" {
  source = "./namespace"

  namespaces = {
    web = {
      app         = "web"
      environment = "prod"
    }

    admin = {
      app         = "admin"
      environment = "prod"
    }

    admin-api = {
      app         = "admin"
      environment = "prod"
    }
  }

  limit_ranges = {
    web = {
      default_cpu    = "20m"
      default_memory = "32Mi"
      request_cpu    = "10m"
      request_memory = "32Mi"
    }
    admin = {
      default_cpu    = "20m"
      default_memory = "32Mi"
      request_cpu    = "10m"
      request_memory = "32Mi"
    }
    admin-api = {
      default_cpu    = "20m"
      default_memory = "32Mi"
      request_cpu    = "10m"
      request_memory = "32Mi"
    }
  }

  depends_on = [
    module.eks
  ]
}

module "secrets_manager" {
  source = "./secrets_manager"

}

module "irsa" {
  source = "./irsa"

  oidc_provider_arn = module.eks.oidc_provider_arn["managed"]
  oidc_provider_url = module.eks.oidc_provider_url_https_del["managed"]
  cluster_name      = module.eks.cluster_name["managed"]

  alb_controller_policy_name = "alb_controller_policy"
  alb_controller_role_name   = "alb_controller_role"

  external_dns_policy_name = "external_dns_policy"
  external_dns_role_name   = "external_dns_role"

  eso_policy_name                           = "eso_policy"
  eso_role_name                             = "eso_role"
  secretsmanager_github_app_private_key_arn = module.secrets_manager.github_app_private_key_arn

  secretsmanager_grafana_admin_arn = module.secrets_manager.grafana_admin_arn
  secretsmanager_admin_db_arn      = module.secrets_manager.admin_db_arn

  loki_s3_arn = module.s3.bucket_arns["loki"]

  sqs_keda_queue_arn = module.sqs.queue_arn
  keda_role_name     = "keda_role"
  keda_policy_name   = "keda_policy"

  cloudwatch_exporter_role_name   = "cloudwatch_exporter_role"
  cloudwatch_exporter_policy_name = "cloudwatch_exporter_policy"
}

module "rds" {
  source = "./rds"

  db_subnet_groups = {
    service-db-subnet = {
      name       = "service-db-subnet"
      subnet_ids = module.vpc.private_subnet_ids
    }
  }

  db_clusters = {
    service = {
      cluster_identifier      = "service-db"
      engine                  = "aurora-mysql"
      engine_version          = "8.0.mysql_aurora.3.10.3"
      database_name           = "service_db"
      master_username         = "admin"
      db_subnet_group_key     = "service-db-subnet"
      vpc_security_group_ids  = [module.security_group.security_group_ids["service-db-sg"]]
      port                    = 3306
      backup_retention_period = 7
      skip_final_snapshot     = true
    }
  }

  db_instances = {
    service = {
      instance_class = "db.t3.medium"
      cluster_key    = "service"
    }
  }
}

module "security_group" {
  source = "./security_group"

  vpc_id = module.vpc.vpc_id

  security_groups = {
    service-db-sg = {
      tags = {
        Name = "service-db"
      }
    }
    default_node_sg = {
      tags = {
        workload = "default"
      }
    }

    pii_node_sg = {
      tags = {
        workload = "pii"
      }
    }
  }

  security_group_ingress_rules = {
    service-db-ingress-pii-node = {
      type       = "ingress"
      from_port  = 3306
      to_port    = 3306
      protocol   = "tcp"
      sg_id_key  = "service-db-sg"
      src_sg_key = "pii_node_sg"
    }
    service-db-ingress-default-node = {
      type       = "ingress"
      from_port  = 3306
      to_port    = 3306
      protocol   = "tcp"
      sg_id_key  = "service-db-sg"
      src_sg_key = "default_node_sg"
    }
  }

  security_group_egress_rules = {
    service-db-egress = {
      type       = "egress"
      from_port  = 0
      to_port    = 0
      protocol   = -1
      sg_id_key  = "service-db-sg"
      cidr_block = ["0.0.0.0/0"]
    }

    default-node-egress = {
      type       = "egress"
      from_port  = 0
      to_port    = 0
      protocol   = -1
      sg_id_key  = "default_node_sg"
      cidr_block = ["0.0.0.0/0"]
    }

    pii-node-egress = {
      type       = "egress"
      from_port  = 0
      to_port    = 0
      protocol   = -1
      sg_id_key  = "pii_node_sg"
      cidr_block = ["0.0.0.0/0"]
    }
  }
}

module "s3" {
  source = "./s3"

  buckets = {
    loki = "kim-test-loki-logs"
  }
}

module "sqs" {
  source = "./sqs"

  queue_name = "keda-queue"
  dlq_name   = "keda-dlq"

  visibility_timeout_seconds    = 30
  message_retention_seconds     = 345600
  dlq_message_retention_seconds = 1209600
  max_receive_count             = 5

  tags = {
    Name = "keda-queue"
  }
}

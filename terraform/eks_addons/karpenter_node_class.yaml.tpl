apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: ${name}

spec:
  amiFamily: AL2023

  amiSelectorTerms:
    - alias: al2023@latest

  role: ${karpenter_node_role_name}

  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: ${cluster_name}

  securityGroupSelectorTerms:
    - tags:
        workload: ${workload}
    - tags:
        karpenter.sh/discovery: kim-eks-cluster
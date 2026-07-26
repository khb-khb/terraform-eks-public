apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: ${name}

spec:
  template:
    metadata:
      labels:
        workload: ${workload}

    spec:
      expireAfter: 720h

      taints:
        - key: workload
          value: ${workload}
          effect: NoSchedule
      requirements:
        - key: workload
          operator: In
          values:
            - pii

      nodeClassRef:
        group: karpenter.k8s.aws
        kind: EC2NodeClass
        name: ${name}

      requirements:
        - key: kubernetes.io/arch
          operator: In
          values:
            - amd64

        - key: kubernetes.io/os
          operator: In
          values:
            - linux

        - key: karpenter.sh/capacity-type
          operator: In
          values:
            - on-demand

        - key: karpenter.k8s.aws/instance-generation
          operator: Gt
          values:
            - "2"

        - key: node.kubernetes.io/instance-type
          operator: In
          values:
%{ for instance_type in instance_types ~}
            - ${instance_type}
%{ endfor ~}

  limits:
    cpu: "${cpu_limit}"

  disruption:
    consolidationPolicy: WhenEmptyOrUnderutilized
    consolidateAfter: 1m
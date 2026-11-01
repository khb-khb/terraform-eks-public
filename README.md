AWS EKS 기반 GitOps 플랫폼 구축 및 검증
Terraform, GitHub Actions, Argo CD를 기반으로 EKS 플랫폼을 구성하고 Kubernetes의 배포·스케줄링·오토스케일링·관측 기능을 직접 구현하고 검증한 개인 프로젝트입니다.

프로젝트 개요
Infrastructure as Code(IaC)와 GitOps를 활용해 AWS EKS 환경을 구성하고, 애플리케이션 배포부터 Secret 관리, 노드·Pod 확장, 장애 감지 및 로그 조회까지 실습했습니다. 운영 환경을 가정한 기능 검증 프로젝트이며 실제 기업 서비스 운영 사례는 아닙니다.

핵심 구성
영역	기술	구현 및 검증 내용
인프라	AWS EKS, Terraform	EKS 인프라 코드화 및 구축
CI/CD	GitHub Actions, ECR, Argo CD	이미지 빌드·Push, 매니페스트 갱신, GitOps 자동 동기화
Secret	IRSA, External Secrets Operator, AWS Secrets Manager	Secret 자동 동기화 및 애플리케이션 DB 연결 확인
워크로드	Kubernetes	스케줄링, Probe, Rolling Update, PDB 동작 검증
노드 확장	Karpenter	Pending Pod에 따른 노드 생성, Drift 교체, Consolidation 확인
Pod 확장	KEDA	SQS, Cron, Prometheus 기반 자동 확장·축소
모니터링	Prometheus, Grafana	클러스터·애플리케이션 메트릭 시각화 및 Slack 알림
로그	Promtail, Loki, S3	컨테이너 로그 수집, 조회 및 S3 보관

아키텍처
Terraform으로 구성한 EKS 클러스터에 애플리케이션과 운영용 구성 요소를 배포했습니다. CI 단계에서는 GitHub Actions가 이미지를 빌드해 ECR에 Push하고 Git의 Kubernetes 매니페스트 이미지 태그를 갱신합니다. Argo CD는 변경 사항을 감지해 클러스터에 반영합니다.
<img width="759" height="543" alt="image" src="https://github.com/user-attachments/assets/1733cafe-7632-4f39-92ab-ad19e54d62cc" />

주요 구현 및 검증
1. GitOps CI/CD
- 소스 코드 변경을 트리거로 GitHub Actions 빌드 실행
- 컨테이너 이미지 생성 및 ECR Push
- 새 이미지 태그를 Kubernetes 매니페스트에 반영하고 Git에 Commit & Push
- Argo CD 자동 Sync 및 변경된 웹 서비스 화면 확인
검증 결과: GitHub Actions 실행 성공, Argo CD Healthy/Sync 상태 및 신규 이미지 태그 반영 확인.
2. Secret 관리
- IRSA와 External Secrets Operator를 연계해 AWS Secrets Manager의 값을 Kubernetes Secret으로 동기화
- ClusterSecretStore, ExternalSecret, Kubernetes Secret 상태 확인
- Secrets Manager 값 변경 후 Secret 동기화 및 Admin API의 DB 연결 확인
3. Kubernetes 워크로드와 가용성
- nodeSelector와 Taint/Toleration으로 특정 노드에 대한 스케줄링 허용·차단 테스트
- PodAntiAffinity로 Web Pod를 서로 다른 노드에 분산 배치
- Readiness Probe 실패 시 Service Endpoint에서 제외되고 복구 후 재등록되는 동작 확인
- Liveness Probe 실패 시 컨테이너 재시작 및 애플리케이션 복구 확인
- Rolling Update의 maxSurge: 1, maxUnavailable: 0 설정으로 신규 Pod 준비 후 기존 Pod 종료 확인
- PDB minAvailable: 5를 적용한 6개 Web Pod 환경에서 Node Drain 중 Eviction 제한 확인
4. Karpenter 노드 자동화
- CPU 리소스 부족으로 Pending Pod 발생 시 NodeClaim 및 EC2 노드 자동 생성 확인
- 새 노드 Ready 이후 Pod 스케줄링 확인
- NodePool의 expireAfter 변경으로 Drift를 유도하고 신규 노드 생성·Pod 재배치·기존 노드 제거 흐름 확인
- Consolidation 동작 및 관련 이벤트 확인
5. KEDA 이벤트 기반 오토스케일링
트리거	검증 내용
SQS	메시지 없을 때 Pod 0개 → 메시지 유입 후 5개 → 처리 완료 후 0개
Cron	설정 시간대에 Pod 3개 확장, 시간 종료 후 0개 축소
Prometheus	ALB 요청 지표 증가 시 Pod 5개, 감소 시 1개로 조정


테스트 설정에는 minReplicaCount: 0, maxReplicaCount: 5, pollingInterval: 10s, cooldownPeriod: 60s를 사용했습니다(트리거별 동작은 개별 검증).
6. 모니터링·알림·로그
- Prometheus와 Grafana로 Node CPU/Memory, Running/Pending Pod, Replica 및 ALB 지표 확인
- ALB Target 5XX, CrashLoopBackOff, Pending Pod, Node CPU/Memory 관련 Alert Rule 구성 및 Slack 알림 검증
- Promtail(DaemonSet) → Loki → S3 경로로 컨테이너 stdout/stderr 로그 수집 및 보관
- Grafana Explore에서 Web 로그, Admin API DB 조회 및 오류 로그 확인
검증 결과 요약
- 배포 자동화: 소스 수정부터 이미지 빌드·ECR Push·GitOps 배포까지 연결 확인
- 스케줄링/가용성: Pod 분산 배치, Probe, Rolling Update, PDB의 동작 확인
- 탄력적 확장: Karpenter 노드 생성·교체와 KEDA의 SQS/Cron/메트릭 기반 Pod 확장·축소 확인
- 관측 가능성: 메트릭 대시보드, Slack 알림, Loki 로그 조회 구현

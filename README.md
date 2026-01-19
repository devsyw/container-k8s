
# Kubernetes 리소스 관리

이 디렉토리는 Container Platform의 모든 K8s 리소스를 관리합니다.

## 클러스터 정보

| 노드 | IP | 역할 |
|------|-----|------|
| master | 192.168.2.2 | control-plane |
| node1 | 192.168.2.3 | worker |
| node2 | 192.168.2.4 | worker |

## 설치 순서

### 1. Namespace 생성
```bash
kubectl apply -f namespaces/
```

### 2. Private Registry 설치
```bash
kubectl apply -f registry/
```

### 3. Ingress Controller 설치
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
  -n ingress-nginx \
  --create-namespace \
  -f ingress/values.yaml
```

### 4. Container Platform Helm Chart 설치
```bash
chmod +x k8s/install.sh
helm install container-platform ./apps/container-platform \
  -n user-containers
```

## 삭제 순서 (역순)
```bash
chmod +x k8s/uninstall.sh
helm uninstall container-platform -n user-containers
helm uninstall ingress-nginx -n ingress-nginx
kubectl delete -f registry/
kubectl delete -f namespaces/
```

## Registry 접근

- URL: http://192.168.2.2:32000
- 이미지 목록 확인: `curl http://192.168.2.2:32000/v2/_catalog`

## 설치된 이미지

| 이미지 | 용도 |
|--------|------|
| 192.168.2.2:32000/python-base:3.11-offline | Python 개발환경 |
| 192.168.2.2:32000/code-server:latest | VS Code 웹 |
| 192.168.2.2:32000/jupyter:latest | Jupyter Notebook |

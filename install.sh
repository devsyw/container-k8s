#!/bin/bash
# ===========================================
# Container Platform 설치 스크립트
# ===========================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Container Platform 설치 시작 ==="

# 1. Namespace 생성
echo "[1/4] Namespace 생성..."
kubectl apply -f ${SCRIPT_DIR}/namespaces/

# 2. Registry 설치
echo "[2/4] Private Registry 설치..."
kubectl apply -f ${SCRIPT_DIR}/registry/
echo "Registry Pod 대기 중..."
kubectl wait --for=condition=ready pod -l app=registry -n registry --timeout=120s

# 3. Ingress Controller 설치
echo "[3/4] Ingress Controller 설치..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx 2>/dev/null || true
helm repo update
if ! helm status ingress-nginx -n ingress-nginx >/dev/null 2>&1; then
  helm install ingress-nginx ingress-nginx/ingress-nginx \
    -n ingress-nginx \
    --create-namespace \
    -f ${SCRIPT_DIR}/ingress/values.yaml
fi
echo "Ingress Controller Pod 대기 중..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/component=controller -n ingress-nginx --timeout=120s

# 4. Container Platform Helm Chart 설치
echo "[4/4] Container Platform 설치..."
if ! helm status container-platform -n user-containers >/dev/null 2>&1; then
  helm install container-platform ${SCRIPT_DIR}/apps/container-platform \
    -n user-containers
fi

echo ""
echo "=== 설치 완료 ==="
echo ""
echo "Registry: http://192.168.2.2:32000"
echo "code-server: http://code-server.192.168.2.2.nip.io:30080"
echo "Jupyter: http://jupyter.192.168.2.2.nip.io:30080"
echo ""
echo "확인 명령어:"
echo "  kubectl get pods -n user-containers"
echo "  kubectl get ingress -n user-containers"
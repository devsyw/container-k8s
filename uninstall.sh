#!/bin/bash
# ===========================================
# Container Platform 삭제 스크립트
# ===========================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Container Platform 삭제 시작 ==="

# 역순으로 삭제
echo "[1/4] Container Platform 삭제..."
helm uninstall container-platform -n user-containers 2>/dev/null || true

echo "[2/4] Ingress Controller 삭제..."
helm uninstall ingress-nginx -n ingress-nginx 2>/dev/null || true

echo "[3/4] Registry 삭제..."
kubectl delete -f ${SCRIPT_DIR}/registry/ 2>/dev/null || true

echo "[4/4] Namespace 삭제..."
kubectl delete -f ${SCRIPT_DIR}/namespaces/ 2>/dev/null || true

echo ""
echo "=== 삭제 완료 ==="




├── README.md                    # 설치 가이드
├── install.sh                   # 설치 스크립트
├── uninstall.sh                 # 삭제 스크립트
├── namespaces/
│   └── namespaces.yaml          # Namespace 정의
├── registry/
│   └── registry.yaml            # Private Registry
├── ingress/
│   └── values.yaml              # Ingress Controller 설정
└── apps/
    └── container-platform/      # Helm Chart
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
            ├── _helpers.tpl
            ├── code-server.yaml
            └── jupyter.yaml
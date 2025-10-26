#!/bin/bash

# 클러스터 이름 정의 (create-cka.sh와 동일해야 함)
CLUSTER_NAME="cka-practice"

echo "🔥 ${CLUSTER_NAME} 클러스터를 삭제합니다..."
kind delete cluster --name ${CLUSTER_NAME}

# 설정 파일도 함께 삭제 (선택 사항)
if [ -f "kind-cka-config.yaml" ]; then
    rm "kind-cka-config.yaml"
    echo "🗑️ 설정 파일(kind-cka-config.yaml) 삭제 완료."
fi

echo "✅ 클러스터가 깨끗하게 삭제되었습니다."

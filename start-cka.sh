#!/bin/bash

# 클러스터 이름 정의
CLUSTER_NAME="cka-practice"

echo "▶️ ${CLUSTER_NAME} 클러스터의 모든 컨테이너를 다시 시작합니다..."

# 정지된 컨테이너(-a) 중에서 kind 클러스터 레이블이 있는 것을 찾아 시작합니다.
CONTAINERS=$(docker ps -a -q --filter label=io.x-k8s.kind.cluster=${CLUSTER_NAME})

if [ -z "$CONTAINERS" ]; then
    echo "⚠️ ${CLUSTER_NAME} 관련 컨테이너를 찾을 수 없습니다. (먼저 create-cka.sh로 생성하세요)"
else
    docker start $CONTAINERS
    echo "✅ 모든 노드 컨테이너가 시작되었습니다."
    echo "⏳ API 서버가 준비될 때까지 잠시 기다려주세요..."
    
    # API 서버 준비 대기 (간단한 체크)
    kubectl cluster-info --context kind-${CLUSTER_NAME}
fi

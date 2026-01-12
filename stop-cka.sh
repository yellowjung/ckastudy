#!/bin/bash

# 클러스터 이름 정의
CLUSTER_NAME="cka-practice"

echo "🛑 ${CLUSTER_NAME} 클러스터의 모든 컨테이너를 중지합니다..."

# 'kind' 레이블을 사용하여 해당 클러스터의 모든 컨테이너 ID를 가져와서 중지합니다.
# docker ps -q: 컨테이너 ID만 출력
# --filter label=io.x-k8s.kind.cluster=${CLUSTER_NAME}: 특정 kind 클러스터에 속한 컨테이너만 필터링
CONTAINERS=$(docker ps -q --filter label=io.x-k8s.kind.cluster=${CLUSTER_NAME})

if [ -z "$CONTAINERS" ]; then
    echo "⚠️ 실행 중인 ${CLUSTER_NAME} 관련 컨테이너를 찾을 수 없습니다."
else
    docker stop $CONTAINERS
    echo "✅ 모든 노드 컨테이너가 중지되었습니다. (재시작 방지됨)"
    echo "▶️ 다시 시작하려면 ./start-cka.sh 를 실행하세요."
fi

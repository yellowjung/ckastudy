#!/bin/bash

# --- 스크립트 설정 ---
CLUSTER_NAME="cka-practice"
CONFIG_FILE="kind-cka-config.yaml"
OPTION=$1 # 첫 번째 인수를 OPTION 변수에 저장

# --- 사용법 안내 함수 ---
usage() {
    echo "사용법: $0 [옵션]"
    echo ""
    echo "이미지 이름을 입력하여 이미지를 kind에 직접 주입합니다."
    echo ""
    echo "  ./insert-docker-image.sh {이미지 이름} "
    echo ""
    exit 1
}

# --- 인수가 없으면 사용법 표시 ---
if [ -z "$OPTION" ]; then
    usage
fi

kind load docker-image $OPTION --name cka-practice

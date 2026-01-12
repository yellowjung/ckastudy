#!/bin/bash

# --- 스크립트 설정 ---
CLUSTER_NAME="cka-practice"
CONFIG_FILE="kind-cka-config.yaml"
OPTION=$1 # 첫 번째 인수를 OPTION 변수에 저장

# --- 사용법 안내 함수 ---
usage() {
    echo "사용법: $0 [옵션]"
    echo ""
    echo "옵션을 선택하여 CKA 연습용 kind 클러스터를 생성합니다."
    echo ""
    echo "  1 : [기본] Kind 클러스터 (기본 CNI, 포트/마운트 없음)"
    echo "  2 : [추천] NodePort 맵핑 클러스터 (localhost 접속 가능)"
    echo "  3 : [고급] CNI 미설치 클러스터 (수동 CNI 설치 연습용)"
    echo "  4 : [NEW] NodePort + 로컬 디스크 마운트 (로그 수집/DB용)"
    echo ""
    exit 1
}

# --- 인수가 없으면 사용법 표시 ---
if [ -z "$OPTION" ]; then
    usage
fi

# --- 기존 설정 파일 삭제 ---
if [ -f "${CONFIG_FILE}" ]; then
    rm "${CONFIG_FILE}"
fi

# --- 옵션에 따라 YAML 설정 파일 동적 생성 ---
case $OPTION in
  1)
    echo "➡️ 옵션 1: [기본] 클러스터를 생성합니다."
    cat <<EOF > ${CONFIG_FILE}
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: ${CLUSTER_NAME}
nodes:
- role: control-plane
- role: worker
- role: worker
EOF
    ;;
  
  2)
    echo "✅ 옵션 2: [NodePort 맵핑] 클러스터를 생성합니다."
    cat <<EOF > ${CONFIG_FILE}
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: ${CLUSTER_NAME}
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30000
    hostPort: 30000
  - containerPort: 30001
    hostPort: 30001
  - containerPort: 30002
    hostPort: 30002
  - containerPort: 30003
    hostPort: 30003
  - containerPort: 30004
    hostPort: 30004
  - containerPort: 30005
    hostPort: 30005
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
EOF
    ;;

  3)
    echo "⚠️ 옵션 3: [CNI 미설치] 클러스터를 생성합니다."
    cat <<EOF > ${CONFIG_FILE}
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: ${CLUSTER_NAME}
nodes:
- role: control-plane
- role: worker
- role: worker
networking:
  disableDefaultCNI: true
  podSubnet: 192.168.0.0/16
EOF
    ;;

  4)
    echo "💾 옵션 4: [NodePort + 디스크 마운트] 클러스터를 생성합니다."
    echo ""
    
    # --- 경로 입력 받기 (옵션 4에서만 실행) ---
    echo "📂 [설정] 로그 및 데이터를 저장할 로컬 경로를 입력하세요."
    echo "   (엔터를 누르면 현재 폴더의 './cka-logs'를 사용합니다)"
    read -p "   입력 > " INPUT_PATH

    # 기본값 설정
    if [ -z "$INPUT_PATH" ]; then
        INPUT_PATH="./cka-logs"
    fi

    # 절대 경로 변환 및 디렉토리 생성
    mkdir -p "$INPUT_PATH"
    chmod -R 777 "$INPUT_PATH" # 권한 부여
    HOST_DIR=$(cd "$INPUT_PATH" && pwd)

    echo "   ✅ 로컬 경로: $HOST_DIR <---> Kind 내부: /var/log/k8s-data"
    
    # 마운트 설정 변수
    MOUNT_CONFIG="  extraMounts:
  - hostPath: ${HOST_DIR}
    containerPath: /var/log/k8s-data"

    # 설정 파일 생성 (Port Mapping + Mount 모두 포함)
    cat <<EOF > ${CONFIG_FILE}
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: ${CLUSTER_NAME}
nodes:
- role: control-plane
${MOUNT_CONFIG}
  extraPortMappings:
  - containerPort: 30000
    hostPort: 30000
  - containerPort: 30001
    hostPort: 30001
  - containerPort: 30002
    hostPort: 30002
  - containerPort: 30003
    hostPort: 30003
  - containerPort: 30004
    hostPort: 30004
  - containerPort: 30005
    hostPort: 30005
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
${MOUNT_CONFIG}
- role: worker
${MOUNT_CONFIG}
EOF
    ;;

  *)
    echo "잘못된 옵션입니다: ${OPTION}"
    usage
    ;;
esac

# --- Kind 클러스터 생성 실행 ---
echo ""
echo "✅ ${CONFIG_FILE} 생성 완료."
echo "🚀 ${CLUSTER_NAME} 클러스터 생성을 시작합니다... (약 1~2분 소요)"
kind create cluster --config ${CONFIG_FILE}

echo ""
echo "🎉 ${CLUSTER_NAME} 클러스터가 준비되었습니다!"
echo "---"
echo "kubectl 클러스터 정보:"
kubectl cluster-info --context kind-${CLUSTER_NAME}
echo "---"

# --- 옵션별 후속 안내 ---
if [ "$OPTION" == "2" ]; then
    echo "💡 [팁] NodePort 사용 가능: localhost:30000~30005"
fi
if [ "$OPTION" == "3" ]; then
    echo "🚨 [중요] CNI를 수동으로 설치하세요."
fi
if [ "$OPTION" == "4" ]; then
    echo "💡 [팁] NodePort: 30000~30005 / Log Path: $HOST_DIR"
    echo "        PV 생성 시 'hostPath: /var/log/k8s-data/...' 를 사용하세요."
fi
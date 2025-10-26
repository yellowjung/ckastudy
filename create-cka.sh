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
    echo "  1 : [기본] Kind 클러스터 (기본 CNI 'kindnetd' 설치, 포트 맵핑 없음)"
    echo "  2 : [추천] NodePort 맵핑 클러스터 (localhost로 curl 테스트 가능)"
    echo "  3 : [고급] CNI 미설치 클러스터 (Calico 등 수동 CNI 설치 연습용)"
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
    echo "➡️ 옵션 1: [기본] 클러스터를 생성합니다. (kindnetd CNI, 포트 맵핑 없음)"
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
    echo "   (localhost:30000 ~ 30005 포트로 Mac에서 직접 curl 가능)"
    
    # CKA 연습용으로 6개(30000~30005) 포트를 미리 맵핑합니다.
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
- role: worker
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
- role: worker
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
EOF
    ;;

  3)
    echo "⚠️ 옵션 3: [CNI 미설치] 클러스터를 생성합니다."
    echo "   (Calico 등 수동 CNI 설치 연습용)"
    
    cat <<EOF > ${CONFIG_FILE}
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: ${CLUSTER_NAME}
nodes:
- role: control-plane
- role: worker
- role: worker
networking:
  disableDefaultCNI: true # 기본 CNI(kindnetd) 비활성화
  podSubnet: "10.244.0.0/16" # Calico/Flannel 기본값
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
echo "kubectl 노드 목록:"
kubectl get nodes
echo "---"

# --- 옵션별 후속 안내 ---
if [ "$OPTION" == "2" ]; then
    echo "💡 [팁] 옵션 2로 생성했습니다. Service YAML 작성 시 nodePort를 30000 ~ 30005 사이로 고정하고, Mac 터미널에서 'curl localhost:3000x'로 테스트하세요."
fi

if [ "$OPTION" == "3" ]; then
    echo "🚨 [중요] 옵션 3로 생성했습니다. CNI가 없어 노드(Node)가 'NotReady' 상태입니다."
    echo "   지금 바로 Calico나 Flannel 같은 CNI를 수동으로 설치해야 합니다."
    echo "   예: kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml"
fi

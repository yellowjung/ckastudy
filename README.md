# CKA 연습용 Kind 클러스터 스크립트

이 저장소는 [Kind(Kubernetes in Docker)](https://kind.sigs.k8s.io/)를 사용하여 CKA(Certified Kubernetes Administrator) 자격증 시험을 연습하기 위한 클러스터를 쉽게 생성하고 관리하는 스크립트를 제공합니다.

## 주요 스크립트 안내

### 1. `create-cka.sh` - 연습용 클러스터 생성

CKA 시험 연습에 필요한 다양한 시나리오를 지원하는 Kind 클러스터를 생성합니다. 스크립트 실행 시 원하는 옵션을 선택하여 클러스터를 맞춤 설정할 수 있습니다.

**사용법:**

```bash
./create-cka.sh [옵션]
```

**옵션:**

*   **`1` - 기본 클러스터 (기본값)**
    *   Kind의 기본 CNI인 `kindnetd`가 설치된 표준 클러스터를 생성합니다.
    *   `./create-cka.sh 1`

*   **`2` - NodePort 맵핑 클러스터 (추천)**
    *   Control Plane 노드의 `30000-30005` 포트와 `443` 포트를 로컬 머신(localhost)에 맵핑합니다.
    *   `NodePort` 타입의 서비스를 배포하고 `curl localhost:<NodePort>` 명령으로 쉽게 테스트할 수 있어 편리합니다.
    *   `./create-cka.sh 2`

*   **`3` - CNI 미설치 클러스터**
    *   기본 CNI를 설치하지 않은 상태로 클러스터를 생성합니다.
    *   Calico, Flannel, Weave 등 다양한 CNI 플러그인을 직접 설치하는 연습을 할 때 유용합니다.
    *   `./create-cka.sh 3`

---

### 2. `delete-cka.sh` - 클러스터 삭제

`create-cka.sh`로 생성한 `cka-practice` 클러스터를 깨끗하게 삭제합니다.

**사용법:**

```bash
./delete-cka.sh
```

---

### 3. `insert-docker-image.sh` - 도커 이미지 주입

로컬 머신에 있는 도커 이미지를 Kind 클러스터 노드에 직접 로드합니다. 이를 통해 별도의 이미지 레지스트리 없이 프라이빗 이미지를 파드에서 바로 사용할 수 있습니다.

**사용법:**

```bash
./insert-docker-image.sh [이미지이름]:[태그]
```

**예시:**

```bash
# 로컬의 my-app:1.0 이미지를 클러스터에 주입
./insert-docker-image.sh my-app:1.0
```
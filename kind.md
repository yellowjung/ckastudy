# Kind (Kubernetes IN Docker) 맞춤형 가이드

## 1. 들어가며: 왜 Kind인가? (개발자 & CKA 준비를 위하여)

쿠버네티스(Kubernetes)를 책이나 강의로 배웠지만, 막상 내 PC에서 직접 실습하려면 막막할 때가 많습니다. 어떤 도구를 써야 할지, 설정이 너무 복잡하지는 않을지 걱정부터 앞섭니다.

### 1-1. 로컬 쿠버네티스 환경, 왜 필요한가?

* **개발자에게:** 내가 작성한 코드가 실제 쿠버네티스 환경에서 잘 동작하는지, 배포 YAML 파일은 올바른지 마음껏 테스트해 볼 **'안전한 놀이터'** 가 필요합니다.
 
* **CKA 준비생에게:** 노드를 추가하거나, 컨트롤 플레인을 업그레이드하고, 네트워크 장애를 테스트하는 등 실제 시험 환경과 유사한 클러스터를 자유롭게 만들고 부술 수 있는 **'일회용 실습실'** 이 필요합니다.

### 1-2. Kind (Kubernetes IN Docker)란 무엇인가?

Kind는 **K**ubernetes **IN** **D**ocker의 약자입니다.

이름 그대로, **여러분의 PC에 설치된 Docker 컨테이너를 쿠버네티스 '노드(Node)'처럼 사용하는 방식**입니다. 가상 머신(VM)을 부팅하는 대신, 가벼운 도커 컨테이너 몇 개를 띄워 순식간에 완전한 쿠버네티스 클러스터를 만듭니다.

### 1-3. [핵심] Minikube 대신 Kind를 선택하는 이유

과거에는 `Minikube`가 로컬 환경의 표준처럼 쓰였습니다. 하지만 Kind는 Minikube의 여러 한계를 극복하며 CKA 준비생과 개발자들에게 큰 인기를 얻고 있습니다.

> **[Editor's Note]**
> Minikube도 최근에는 Docker 드라이버를 지원하지만, Kind는 태생부터 'Docker를 노드로 사용'하는 것을 목표로 설계되어 멀티 노드 구성과 속도 면에서 더 큰 강점을 가집니다.

핵심 차이점을 표로 비교해 보았습니다.

| 비교 항목 | **Kind (Kubernetes IN Docker)** | **Minikube (전통적인 VM 방식)** |
| :--- | :--- | :--- |
| **핵심 원리** | Docker 컨테이너를 '노드'로 사용 | 가상 머신(VM)을 '노드'로 사용 |
| **클러스터 속도** | **매우 빠름 (수십 초 내외)** | 상대적으로 느림 (VM 부팅 시간 소요) |
| **리소스 점유** | **낮음** (컨테이너 오버헤드만) | 높음 (VM에 할당된 RAM/CPU 고정 점유) |
| **멀티 노드** | **매우 쉬움 (YAML 설정 파일로 간단히 정의)** | 복잡하거나 제한적임 (e.g., `minikube node add`) |
| **추천 대상** | **CKA 준비생**, 빠른 테스트/삭제 반복 | 단일 노드 환경, VM 환경이 필수일 때 |

결론: **빠른 속도**와 **가벼운 리소스**, 그리고 CKA 실습에 필수적인 **멀티 노드 구성**의 용이성 때문에 Kind를 강력히 추천합니다.

---

## 2. 설치 및 기본 클러스터 생성

Kind를 시작하는 것은 매우 간단합니다.

### 2-1. 사전 요구 사항

* **Docker 설치 및 실행:** Kind는 Docker에 의존합니다. PC에 Docker Desktop (Mac/Windows) 또는 Docker Engine(Linux)이 설치되고 **실행 중**이어야 합니다.

* **kubectl 설치 및 실행:** Kind는 kubectl이 설치 되지 않습니다. Kind가 클러스터를 만들어도, 명령을 내리려면 kubectl이 설치되고 **실행 중**이어야 합니다.

### 2-2. Kind 설치

* **macOS (Homebrew 사용 시)**
    ```bash
    # For Intel Macs
    [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-darwin-amd64
    # For M1 / ARM Macs
    [ $(uname -m) = arm64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-darwin-arm64
    chmod +x ./kind
    mv ./kind /some-dir-in-your-PATH/kind
    ```

* **Windows (두 가지 방법)**
    Windows 사용자는 Chocolatey를 사용하는 방법과, `.exe` 바이너리 파일을 직접 다운로드하는 방법 중 편한 것을 선택하세요.

    **방법 1: Chocolatey 사용**
    > 패키지 매니저를 사용할 수 있다면 이 방법이 가장 간단하며, 향후 버전 관리에도 용이합니다.
    ```bash
    choco install kind
    ```

    **방법 2: 수동 설치 (일반적인 바이너리 다운로드)**
    > Chocolatey를 사용하지 못하는 환경에서는 이 방법을 사용합니다.
    1.  PowerShell을 열고 아래 명령어를 실행하여, Kind 실행 파일(`kind.exe`)을 다운로드합니다.
        (아래는 `v0.30.0` 기준이며, [Kind 공식 릴리스 페이지](https://github.com/kubernetes-sigs/kind/releases)에서 최신 버전을 확인하셔도 좋습니다.)
        ```powershell
        curl.exe -Lo kind-windows-amd64.exe https://kind.sigs.k8s.io/dl/v0.30.0/kind-windows-amd64
        Move-Item .\kind-windows-amd64.exe c:\some-dir-in-your-PATH\kind.exe
        ```
    2.  다운로드한 `kind.exe` 파일을 **PATH가 설정된 폴더**로 이동시킵니다.
        * *PATH가 무엇인지 잘 모르겠다면?* 가장 간단한 방법은 `C:\Windows\System32` 폴더로 `kind.exe` 파일을 옮기는 것입니다. (관리자 권한 필요)
        * (권장) 또는 `C:\bin` 같은 별도의 폴더를 만들고, 이 폴더를 '환경 변수'의 `Path`에 추가한 뒤, `kind.exe`를 그곳으로 옮겨 관리할 수 있습니다.
    3.  새로운 터미널(PowerShell 또는 CMD) 창을 열고, 아래 명령어를 입력하여 설치가 잘 되었는지 확인합니다.
        ```bash
        kind --version
        ```
        (출력 예시) `kind version 0.30.0`

* **Linux (Binary 설치)**
    ```bash
    # For AMD64 / x86_64
    [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64
    # For ARM64
    [ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-arm64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
    ```

### 2-3. Kubectl 설치

각 OS에 맞는 URL을 클릭하여 문서를 참고해 설치를 진행합니다.
 - macOS : https://kubernetes.io/ko/docs/tasks/tools/install-kubectl-macos/
 - Linux : https://kubernetes.io/ko/docs/tasks/tools/install-kubectl-linux/
 - Windows :  https://kubernetes.io/ko/docs/tasks/tools/install-kubectl-windows/


### 2-4. 기본 (단일 노드) 클러스터 생성

이제 가장 간단한 단일 노드(컨트롤 플레인 역할만 하는) 클러스터를 만들어 보겠습니다.

```bash
# 'kind'라는 이름의 기본 클러스터를 생성합니다.
kind create cluster
```
이 명령을 실행하면, Kind는 필요한 컨테이너 이미지를 다운로드하고, 노드(컨테이너)를 실행한 뒤, 자동으로 여러분의 kubectl이 이  새 클러스터를 바라보도록 kubeconfig 파일을 업데이트 합니다.

* **클러스터 상태 확인**
 
  ``` bash
  kubectl cluster-info
  ```
  (출력 예시) kubernetes control plane is running at https://127.0.0.1:XXX
  
  ``` bash
  kubectl get nodes
  ```
  (출력 예시) kind-control-plane Ready maseter ...


## 3. CKA 연습을 위한 핵심 활용법

### 3-1. 클러스터 관리의 기본

 * **클러스터 목록 확인**
   ``` bash
   kind get clusters
   ```

 * **빠른 환경 리셋 (클러스터 삭제)**
   
   CKA 연습 시 가장 많이 쓰게 될 명령어입니다. 실습이 끝나면 부담 없이 삭제하세요.
   ``` bash
   # 기본 'kind' 이름의 클러스터 삭제
   kind delete cluster

   # 특정 이름의 클러스터 삭제 (뒤에서 설명)
   kind delete cluster --name cka-practice
   ``` 

### 3-2. [핵심] 멀티 노드 클러스터 구성하기 (CKA 필수)

CKA 시험은 여러 개의 노드(컨트롤 플레인, 워커)를 전제로 합니다. Kind는 YAML 설정 파일 하나로 이를 완벽하게 흉내 낼 수 있습니다.

1. kind-multi-node.yaml 이름으로 아래와 같이 파일을 작성합니다.
    
    (1개의 컨트롤 플레인, 2개의 워커 노드를 정의)
    ``` yaml
    # kind-multi-node.yaml
    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    nodes:
    - role: control-plane # 컨트롤 플레인 노드
    - role: worker        # 워커 노드 1
    - role: worker        # 워커 노드 2
    ```
2. 이 설정 파일을 사용하여 클러스터를 생성합니다.

    --name 플래그로 클러스터 이름을 지정해 주는 것이 좋습니다.
    ``` bash
    kind create cluster --config kind-multi-node.yaml --name cka-practice
    ```

3. 생성 완료 후 노드 목록을 확인합니다.
   
   ``` bash
   kubectl get nodes -o wide
   ```

   (출력예시)
   ```
   NAME                             STATUS    ROLES             AGE     VERSION
   cka-practice-control-plane       Ready     control-plane     ...
   cka-practice-worker              Ready     <none>            ...
   cka-practice-worker2             Ready     <none>            ...
   ```

   이제 3개의 노드로 구성된 완벽한 미니 쿠버네티스 환경이 준비되었습니다.

### 3-3. (Tip) 로컬 이미지를 Kind 클러스터에서 사용하기

로컬에서 docker build -t my-app:v1 명령어로 이미지를 빌드했을 때, 이 이미지를 Kind 클러스터에서 바로 사용할 수 없습니다. (Kind 노드는 호스트 PC의 도커 데몬을 공유하지 않기 때문입니다.)

이때는 아래 명령어로 로컬 이미지를 Kind 클러스터 '내부'로 로드 해야합니다.

``` bash
# [내 이미지]를 [사용할 클러스터]에 로드합니다.
kind load docker-image my-app:v1 --name cka-practice
```

이제 Deployment YAML 파일에서 image:my-app:v1을 사용하면 정상적으로 이미지를 PULL 할 수 있습니다.

## 4. 맺음말 및 참고 자료

Kind는 CKA 준비 할 때 노드 장애, 업그레이드 등을 마음껏 실습할 수 있는 **'실습실'** 이며, 개발자에게는 내 코드를 쿠버네티스 환경에 배포해 보는 가장 빠르고 가벼운 **'놀이터'** 입니다.

무거운 VM 대신 가벼운 Docker 컨테이너를 활용하는 Kind로 빠르고 즐겁게 쿠버네티스를 정복해 보시기 바랍니다.

쉽게 Kind를 구축 하실 수 있게 제 Github(https://github.com/yellowjung/ckastudy)에 Script들을 생성해놓았습니다.
CKA 문제들도 같이 동봉되어있으니 관심있으시면 확인 부탁드리겠습니다!


* 참고자료
  * Kind 공식 홈페이지 : https://kind.sigs.k8s.io/
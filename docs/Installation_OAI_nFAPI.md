# Installation with CU-CP and OAI nFAPI emulator
This document covers how to install ONOS RIC services with CU-CP and OAI nFAPI emulator.
With this option, RiaB will deploy ONOS RIC services including ONOS-KPIMON (KPM 2.0 supported) together with CU-CP, OAI DU (nFAPI), and OAI UE (nFAPI).

## Clone this repository
To begin with, clone this repository:
```bash
$ git clone https://github.com/onosproject/sdran-in-a-box
```
**NOTE: If we want to use a specific release, we can change the branch with `git checkout [args]` command:**
```bash
$ cd /path/to/sdran-in-a-box
$ git checkout v1.0.0 # for release 1.0
$ git checkout v1.1.0 # for release 1.1
$ git checkout v1.1.1 # for release 1.1.1
$ git checkout v1.2.0 # for release 1.2
$ git checkout master # for master
```

## Deploy RiaB with OAI nFAPI emulator

### Command options
To deploy RiaB with OAI nFAPI emulator, we should go to `sdran-in-a-box` directory and command below:
```bash
$ cd /path/to/sdran-in-a-box
# type one of below commands
# for "master-stable" version
$ make riab OPT=oai VER=stable # or just make riab OPT=oai
# for "latest" version
$ make riab OPT=oai VER=latest
# for a specific version
$ make riab OPT=oai VER=v1.0.0 # for release SD-RAN 1.0
$ make riab OPT=oai VER=v1.1.0 # for release SD-RAN 1.1
$ make riab OPT=oai VER=v1.1.1 # for release SD-RAN 1.1.1
$ make riab OPT=oai VER=v1.2.0 # for release SD-RAN 1.2
# for a "dev" version
$ make riab OPT=oai VER=dev # for release SD-RAN 1.1
```

Once we push one of above commands, the deployment procedure starts.

### Credentials
In the deployment procedure, we should type some credentials on the prompt:
* OpenCORD username and HTTPS key
* GitHub username and password
* Aether/SD-RAN Helm chart repository credentials

```bash
aether-helm-chart repo is not in /users/wkim/helm-charts directory. Start to clone - it requires HTTPS key
Cloning into '/users/wkim/helm-charts/aether-helm-charts'...
Username for 'https://gerrit.opencord.org': <OPENCORD_GERRIT_ID>
Password for 'https://<OPENCORD_GERRIT_ID>@gerrit.opencord.org': <OPENCORD_GERRIT_HTTPS_KEY>
remote: Total 1103 (delta 0), reused 1103 (delta 0)
Receiving objects: 100% (1103/1103), 526.14 KiB | 5.31 MiB/s, done.
Resolving deltas: 100% (604/604), done.
sdran-helm-chart repo is not in /users/wkim/helm-charts directory. Start to clone - it requires Github credential
Cloning into '/users/wkim/helm-charts/sdran-helm-charts'...
Username for 'https://github.com': <ONOSPROJECT_GITHUB_ID>
Password for 'https://<ONOSPROJECT_GITHUB_ID>@github.com': <ONOSPROJECT_GITHUB_PASSWORD>
remote: Enumerating objects: 19, done.
remote: Counting objects: 100% (19/19), done.
remote: Compressing objects: 100% (17/17), done.
remote: Total 2259 (delta 7), reused 3 (delta 2), pack-reused 2240
Receiving objects: 100% (2259/2259), 559.35 KiB | 2.60 MiB/s, done.
Resolving deltas: 100% (1558/1558), done.

.....

helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
"incubator" has been added to your repositories
helm repo add cord https://charts.opencord.org
"cord" has been added to your repositories
Username for ONF SDRAN private chart: <SDRAN_PRIVATE_CHART_REPO_ID>
Password for ONF SDRAN private chart: <SDRAN_PRIVATE_CHART_REPO_PASSWORD>
"sdran" has been added to your repositories
touch /tmp/build/milestones/helm-ready
```

If we don't see any error or failure messages, everything is deployed.
```bash
$ kubectl get po --all-namespaces
NAMESPACE     NAME                                                READY   STATUS    RESTARTS   AGE
default       router                                              1/1     Running   0          42h
kube-system   atomix-controller-7785674d5d-wnn8v                  1/1     Running   0          42h
kube-system   atomix-memory-storage-controller-66644577fb-qfs48   1/1     Running   0          42h
kube-system   atomix-raft-storage-controller-687d8497d4-wbfx5     1/1     Running   0          42h
kube-system   calico-kube-controllers-db474b467-jwbjj             1/1     Running   0          8d
kube-system   calico-node-8jzz4                                   1/1     Running   0          8d
kube-system   coredns-dff8fc7d-cvx65                              1/1     Running   0          8d
kube-system   dns-autoscaler-5d74bb9b8f-99ktb                     1/1     Running   0          8d
kube-system   kube-apiserver-node1                                1/1     Running   0          8d
kube-system   kube-controller-manager-node1                       1/1     Running   0          8d
kube-system   kube-multus-ds-amd64-5gvnf                          1/1     Running   0          8d
kube-system   kube-proxy-xmtkj                                    1/1     Running   0          8d
kube-system   kube-scheduler-node1                                1/1     Running   0          8d
kube-system   kubernetes-dashboard-667c4c65f8-v2lvk               1/1     Running   0          8d
kube-system   kubernetes-metrics-scraper-54fbb4d595-bd2w9         1/1     Running   0          8d
kube-system   nodelocaldns-ppljr                                  1/1     Running   0          8d
kube-system   onos-operator-config-9896789b8-bngw2                1/1     Running   0          42h
kube-system   onos-operator-topo-6b44c56d8d-d5bwz                 1/1     Running   0          42h
riab          cassandra-0                                         1/1     Running   0          42h
riab          hss-0                                               1/1     Running   0          42h
riab          mme-0                                               4/4     Running   0          42h
riab          oai-enb-cu-0                                        1/1     Running   0          8m31s
riab          oai-enb-du-0                                        1/1     Running   0          7m20s
riab          oai-ue-0                                            1/1     Running   0          6m9s
riab          onos-cli-8584c45c84-wdrrq                           1/1     Running   0          9m37s
riab          onos-config-798b8c8579-cr6pq                        4/4     Running   0          9m37s
riab          onos-consensus-db-1-0                               1/1     Running   0          9m37s
riab          onos-consensus-store-1-0                            1/1     Running   0          9m37s
riab          onos-e2t-5c55869d6f-wpwdj                           3/3     Running   0          9m37s
riab          onos-kpimon-68549c5bb9-9fpnn                        1/1     Running   0          9m37s
riab          onos-topo-858d7999d-gdzkt                           3/3     Running   0          9m37s
riab          onos-uenib-55c568b444-5kvrg                         3/3     Running   0          9m37s
riab          pcrf-0                                              1/1     Running   0          42h
riab          spgwc-0                                             2/2     Running   0          42h
riab          upf-0                                               4/4     Running   0          42h
```

NOTE: If we see any issue when deploying RiaB, please check [Troubleshooting](./troubleshooting.md)

## End-to-End (E2E) tests for verification
In order to check whether everything is running, we should conduct some E2E tests and check their results.
Since CU-CP supports the SD-RAN control plane and OAI nFAPI services the LTE user plane, we can do E2E tests on the user plane and SD-RAN control plane.

### The E2E test on the user plane
We can type `make test-user-plane` on the prompt for the user plane verification.

```bash
$ make test-user-plane
*** T1: Internal network test: ping 192.168.250.1 (Internal router IP) ***
PING 192.168.250.1 (192.168.250.1) from 172.250.255.254 oaitun_ue1: 56(84) bytes of data.
64 bytes from 192.168.250.1: icmp_seq=1 ttl=64 time=20.4 ms
64 bytes from 192.168.250.1: icmp_seq=2 ttl=64 time=19.9 ms
64 bytes from 192.168.250.1: icmp_seq=3 ttl=64 time=18.6 ms

--- 192.168.250.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 18.664/19.686/20.479/0.758 ms
*** T2: Internet connectivity test: ping to 8.8.8.8 ***
PING 8.8.8.8 (8.8.8.8) from 172.250.255.254 oaitun_ue1: 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=113 time=57.8 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=113 time=56.4 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=113 time=55.0 ms

--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 55.004/56.441/57.878/1.189 ms
*** T3: DNS test: ping to google.com ***
PING google.com (172.217.9.142) from 172.250.255.254 oaitun_ue1: 56(84) bytes of data.
64 bytes from dfw25s26-in-f14.1e100.net (172.217.9.142): icmp_seq=1 ttl=112 time=54.7 ms
64 bytes from dfw25s26-in-f14.1e100.net (172.217.9.142): icmp_seq=2 ttl=112 time=53.6 ms
64 bytes from dfw25s26-in-f14.1e100.net (172.217.9.142): icmp_seq=3 ttl=112 time=51.9 ms

--- google.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 51.990/53.452/54.712/1.136 ms
```

If we can see that ping is working without any loss, the user plane is working well.

### The E2E test on SD-RAN control plane
In order to verify the SD-RAN control plane, we should command below for each version.
* `make test-kpimon`: to see the number of active UEs
```bash
$ make test-kpimon
...
*** Get KPIMON result through CLI ***
Node ID          Cell Object ID       Cell Global ID            Time    RRC.ConnEstabAtt.sum    RRC.ConnEstabSucc.sum    RRC.ConnMax    RRC.ConnMean    RRC.ConnReEstabAtt.sum
e00                           1                e0000      22:39:24.0                       1                        1              1               0                         0
```

* `make test-e2-connection` and `make test-e2-subscription`: to see e2 connection and subscription
```bash
$ make test-e2-connection
...
*** Get E2 connections through CLI ***
Connection ID                          PLMN ID   Node ID   Node Type   IP Addr        Port    Status
3cc2a76c-10d8-47c2-a85a-18014234e02d   10f802    e00       E_NB        192.168.69.1   50671   8m52.352s

$ make test-e2-subscription
...
*** Get E2 subscriptions through CLI ***
Subscription ID                        Revision   Service Model ID   E2 NodeID   Encoding   Phase               State
9a8f85fa67a6ef913ef4c0fa8f8fdee4:e00   4          oran-e2sm-kpm:v2   e00         ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
```

* `make test-rnib` and `make test-uenib`: to check information in R-NIB and UE-NIB
```bash
$ make test-rnib
...
*** Get R-NIB result through CLI ***
ID: e00
Kind ID: e2node
Labels: <None>
Aspects:
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"O-CU-UP Measurement Container for the EPC connected deployment","type":6,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.sum"},{"id":"value:4","name":"RRC.ConnMean"},{"id":"value:5","name":"RRC.ConnMax"}]}]}]}}}

ID: e0000
Kind ID: e2cell
Labels: <None>
Aspects:
- onos.topo.E2Cell={"cellObjectId":"1","cellGlobalId":{"value":"e0000","type":"ECGI"}}

wkim@k8s-1:~/sdran-in-a-box$ make test-uenib
...
*** Get UE-NIB result through CLI ***
ID: e00:1
Aspects:
- RRC.ConnReEstabAtt.sum=0
- RRC.ConnMean=1
- RRC.ConnMax=1
- RRC.ConnEstabAtt.sum=1
- RRC.ConnEstabSucc.sum=1
```

## Other commands
### Reset and delete RiaB environment
If we want to reset our RiaB environment or delete RiaB compoents, we can use below commands:
* `make reset-test`: It deletes ONOS RIC services, CU-CP, and OAI nFAPI emulator but Kubernetes is still running
* `make clean`: It just deletes Kubernets environment; Eventually, all ONOS RIC services, CU-CP, and OAI nFAPI emulator are terminated; The Helm chart directory is not deleted
* `make clean-all`: It deletes all including Kubernetes environment, all componentes/PODs which RiaB deployed, and even the Helm chart directory

### Deploy or reset a chart/service
If we want to only deploy or reset a chart/service, we can use below command:
* `make omec`: It deploys OMEC chart
* `make reset-omec`: It deletes OMEC chart
* `make atomix`: It deploys Atomix controllers
* `make reset-atomix`: It deletes Atomix controllers
* `make ric`: It deploys ONOS RIC services
* `make reset-ric`: It deletes ONOS RIC services
* `make oai`: It deploys CU-CP and OAI nFAPI emulator
* `make reset-oai`: It deletes CU-CP and OAI nFAPI emulator

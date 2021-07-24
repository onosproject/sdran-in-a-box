# Installation with RAN-Simulator and ONOS PCI xAPP
This document covers how to install ONOS RIC services with RAN-Simulator.
With this option, RiaB will deploy ONOS RIC services including ONOS-KPIMON (KPM 2.0 supported) and ONOS-PCI xAPPs together with RAN-Simulator

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

## Deploy RiaB with RAN-Simulator
### Command options
To deploy RiaB with RAN-Simulator, we should go to `sdran-in-a-box` directory and command below:
```bash
$ cd /path/to/sdran-in-a-box
# type one of below commands
# for "master-stable" version
$ make riab OPT=ransim VER=stable # or just make riab OPT=ransim
# for "latest" version
$ make riab OPT=ransim VER=latest
# for a specific version
$ make riab OPT=ransim VER=v1.0.0 # for release SD-RAN 1.0
$ make riab OPT=ransim VER=v1.1.0 # for release SD-RAN 1.1
$ make riab OPT=ransim VER=v1.1.1 # for release SD-RAN 1.1
$ make riab OPT=ransim VER=v1.2.0 # for release SD-RAN 1.2
# for a "dev" version
$ make riab OPT=ransim VER=dev # for release SD-RAN 1.2
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
riab          onos-cli-8584c45c84-68pdb                           1/1     Running   0          106m
riab          onos-config-798b8c8579-ngpbh                        4/4     Running   0          106m
riab          onos-consensus-db-1-0                               1/1     Running   0          106m
riab          onos-consensus-store-1-0                            1/1     Running   0          106m
riab          onos-e2t-5c55869d6f-slqg5                           3/3     Running   0          106m
riab          onos-kpimon-68549c5bb9-4wf9x                        1/1     Running   0          106m
riab          onos-pci-7479d597c5-s4pxx                           1/1     Running   0          106m
riab          onos-topo-858d7999d-mdl8v                           3/3     Running   0          106m
riab          onos-uenib-55c568b444-4h6f8                         3/3     Running   0          106m
riab          ran-simulator-5d48f6bc59-jjb7f                      1/1     Running   0          106m
```

NOTE: If we see any issue when deploying RiaB, please check [Troubleshooting](./troubleshooting.md)

## End-to-End (E2E) tests for verification
In order to check whether everything is running, we should conduct some E2E tests and check their results.
Since RAN-Sim does only generate SD-RAN control messages, we can run E2E tests on the SD-RAN control plane.

### The E2E test on SD-RAN control plane
First, we can check E2 connections and subscriptions with `make test-e2-connection` and `make test-e2-subscription` commands:
```bash
$ make test-e2-connection
...
*** Get E2 connections through CLI ***
Connection ID                          PLMN ID   Node ID   Node Type   IP Addr          Port    Status
9a2e2719-f01c-4dad-b0f3-c41e6d980f27   138426    5153      G_NB        192.168.84.130   54476   1h47m25.556s
02599518-4932-4c9e-91dc-5f1ed2af3718   138426    5154      G_NB        192.168.84.130   53547   1h47m25.289s
$ make test-e2-subscription
...
*** Get E2 subscriptions through CLI ***
Subscription ID                         Revision   Service Model ID      E2 NodeID   Encoding   Phase               State
6eb185a4fc905039fd46a9af89c65030:5153   4          oran-e2sm-rc-pre:v2   5153        ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
fc5e2d6967fd1923e6853e796571c946:5153   6          oran-e2sm-kpm:v2      5153        ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
6eb185a4fc905039fd46a9af89c65030:5154   8          oran-e2sm-rc-pre:v2   5154        ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
c0007daeef88f0702cce3e1b47f62420:5154   10         oran-e2sm-kpm:v2      5154        ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
```

Next, we can check KPIMON xApp CLI and PCI xApp CLI.
In order to check KPIMON xAPP CLI, we should type `make test-kpimon`
```bash
$ make test-kpimon
...
*** Get KPIMON result through CLI ***
Node ID          Cell Object ID       Cell Global ID            Time    RRC.Conn.Avg    RRC.Conn.Max    RRC.ConnEstabAtt.Sum    RRC.ConnEstabSucc.Sum    RRC.ConnReEstabAtt.HOFail    RRC.ConnReEstabAtt.Other    RRC.ConnReEstabAtt.Sum    RRC.ConnReEstabAtt.reconfigFail
5153            13842601454c001             1454c001      22:12:45.0               1               4                       0                        0                            0                           0                         0                                  0
5153            13842601454c002             1454c002      22:12:44.0               1               3                       0                        0                            0                           0                         0                                  0
5153            13842601454c003             1454c003      22:12:44.0               4               5                       0                        0                            0                           0                         0                                  0
5154            138426014550001             14550001      22:12:45.0               0               1                       0                        0                            0                           0                         0                                  0
5154            138426014550002             14550002      22:12:45.0               4               4                       0                        0                            0                           0                         0                                  0
5154            138426014550003             14550003      22:12:45.0               0               1                       0                        0                            0                           0                         0                                  0
```

*Note: It shows the current number of active UEs and the maximum number of active UEs. All other values should be 0.*

Similarly, we should type `make test-pci` to check PCI xAPP CLI.
```bash
$ make test-pci
...
*** Get PCI result through CLI ***
ID                Total Resolved Conflicts   Most Recent Resolution
13842601454c001   1                          148=>72
138426014550001   1                          115=>374
```

*Note: The `Most Recent Resolution` results can be changed. It assigns random value.*

Also, there are two more test Makefile targets `make test-rnib` and `make test-uenib` to check R-NIB and UE-NIB, which have cell and UE related monitoring information.
```bash
$ make test-rnib
HEAD is now at 6b3a267 update incubator chart url in aether helm charts
Helm values.yaml file: /users/wkim/sdran-in-a-box//sdran-in-a-box-values-master-stable.yaml
HEAD is now at cfa3805 Release 1.1.100 sdran umbrella chart (#750)
*** Get R-NIB result through CLI ***
ID: 5153
Kind ID: e2node
Labels: <None>
Aspects:
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.101":{"oid":"1.3.6.1.4.1.53148.1.1.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}]},"1.3.6.1.4.1.53148.1.1.2.2":{"oid":"1.3.6.1.4.1.53148.1.1.2.2"},"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}]}}}

ID: 1454c001
Kind ID: e2cell
Labels: <None>
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c001","cellGlobalId":{"value":"1454c001"},"pci":72}

ID: 14550002
Kind ID: e2cell
Labels: <None>
Aspects:
- onos.topo.E2Cell={"cellObjectId":"138426014550002","cellGlobalId":{"value":"14550002"},"pci":115}

ID: 1454c002
Kind ID: e2cell
Labels: <None>
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c002","cellGlobalId":{"value":"1454c002"},"pci":218}

ID: 5154
Kind ID: e2node
Labels: <None>
Aspects:
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.101":{"oid":"1.3.6.1.4.1.53148.1.1.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}]},"1.3.6.1.4.1.53148.1.1.2.2":{"oid":"1.3.6.1.4.1.53148.1.1.2.2"},"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}]}}}

ID: 14550001
Kind ID: e2cell
Labels: <None>
Aspects:
- onos.topo.E2Cell={"cellObjectId":"138426014550001","cellGlobalId":{"value":"14550001"},"pci":374}

ID: 14550003
Kind ID: e2cell
Labels: <None>
Aspects:
- onos.topo.E2Cell={"cellObjectId":"138426014550003","cellGlobalId":{"value":"14550003"},"pci":480}

ID: 1454c003
Kind ID: e2cell
Labels: <None>
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c003","cellGlobalId":{"value":"1454c003"},"pci":148}

$ make test-uenib
HEAD is now at 6b3a267 update incubator chart url in aether helm charts
Helm values.yaml file: /users/wkim/sdran-in-a-box//sdran-in-a-box-values-master-stable.yaml
HEAD is now at cfa3805 Release 1.1.100 sdran umbrella chart (#750)
*** Get UE-NIB result through CLI ***
ID: 5154:138426014550003
Aspects:
- RRC.Conn.Max=1
- RRC.ConnEstabSucc.Sum=0
- RRC.ConnReEstabAtt.Other=0
- RRC.ConnEstabAtt.Sum=0
- RRC.Conn.Avg=0
- RRC.ConnReEstabAtt.HOFail=0
- RRC.ConnReEstabAtt.reconfigFail=0
- RRC.ConnReEstabAtt.Sum=0
ID: 5153:13842601454c002
Aspects:
- RRC.ConnEstabSucc.Sum=0
- RRC.Conn.Max=3
- RRC.ConnReEstabAtt.Other=0
- RRC.ConnReEstabAtt.HOFail=0
- RRC.ConnReEstabAtt.Sum=0
- RRC.Conn.Avg=1
- RRC.ConnReEstabAtt.reconfigFail=0
- RRC.ConnEstabAtt.Sum=0
ID: 5153:138426:1454c001:CGITypeNRCGI
Aspects:
- neighbors=138426:1454c002:CGITypeNRCGI,138426:1454c003:CGITypeNRCGI,138426:14550001:CGITypeNRCGI
ID: 5154:138426:14550002:CGITypeNRCGI
Aspects:
- neighbors=138426:14550003:CGITypeNRCGI,138426:1454c002:CGITypeNRCGI,138426:14550001:CGITypeNRCGI
ID: 5154:138426:14550001:CGITypeNRCGI
Aspects:
- neighbors=138426:14550002:CGITypeNRCGI,138426:14550003:CGITypeNRCGI,138426:1454c001:CGITypeNRCGI
ID: 5153:13842601454c003
Aspects:
- RRC.Conn.Max=5
- RRC.ConnEstabSucc.Sum=0
- RRC.ConnEstabAtt.Sum=0
- RRC.ConnReEstabAtt.Sum=0
- RRC.ConnReEstabAtt.reconfigFail=0
- RRC.ConnReEstabAtt.HOFail=0
- RRC.Conn.Avg=4
- RRC.ConnReEstabAtt.Other=0
ID: 5153:13842601454c001
Aspects:
- RRC.Conn.Max=4
- RRC.ConnReEstabAtt.reconfigFail=0
- RRC.ConnReEstabAtt.HOFail=0
- RRC.ConnReEstabAtt.Other=0
- RRC.Conn.Avg=1
- RRC.ConnReEstabAtt.Sum=0
- RRC.ConnEstabAtt.Sum=0
- RRC.ConnEstabSucc.Sum=0
ID: 5154:138426014550001
Aspects:
- RRC.Conn.Avg=0
- RRC.ConnReEstabAtt.HOFail=0
- RRC.ConnReEstabAtt.Other=0
- RRC.ConnReEstabAtt.Sum=0
- RRC.Conn.Max=1
- RRC.ConnReEstabAtt.reconfigFail=0
- RRC.ConnEstabAtt.Sum=0
- RRC.ConnEstabSucc.Sum=0
ID: 5154:138426014550002
Aspects:
- RRC.ConnReEstabAtt.reconfigFail=0
- RRC.ConnReEstabAtt.HOFail=0
- RRC.Conn.Avg=4
- RRC.ConnReEstabAtt.Other=0
- RRC.ConnEstabAtt.Sum=0
- RRC.Conn.Max=4
- RRC.ConnEstabSucc.Sum=0
- RRC.ConnReEstabAtt.Sum=0
ID: 5154:138426:14550003:CGITypeNRCGI
Aspects:
- neighbors=138426:1454c003:CGITypeNRCGI,138426:14550001:CGITypeNRCGI,138426:14550002:CGITypeNRCGI
ID: 5153:138426:1454c002:CGITypeNRCGI
Aspects:
- neighbors=138426:1454c003:CGITypeNRCGI,138426:14550002:CGITypeNRCGI,138426:1454c001:CGITypeNRCGI
ID: 5153:138426:1454c003:CGITypeNRCGI
Aspects:
- neighbors=138426:14550003:CGITypeNRCGI,138426:1454c001:CGITypeNRCGI,138426:1454c002:CGITypeNRCGI
```

## Other commands
### Reset and delete RiaB environment
If we want to reset our RiaB environment or delete RiaB compoents, we can use below commands:
* `make reset-test`: It deletes ONOS RIC services and RAN-Simulator but Kubernetes is still running
* `make clean`: It just deletes Kubernets environment; Eventually, all ONOS RIC and RAN-Simulator are terminated; The Helm chart directory is not deleted
* `make clean-all`: It deletes all including Kubernetes environment, all componentes/PODs which RiaB deployed, and even the Helm chart directory

### Deploy or reset a chart/service
If we want to only deploy or reset a chart/service, we can use below command:
* `make atomix`: It deploys Atomix controllers
* `make reset-atomix`: It deletes Atomix controllers
* `make ric`: It deploys ONOS RIC services
* `make reset-ric`: It deletes ONOS RIC services
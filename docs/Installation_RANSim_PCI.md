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
$ git checkout v1.3.0 # for release 1.3
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
$ make riab OPT=ransim VER=v1.1.1 # for release SD-RAN 1.1.1
$ make riab OPT=ransim VER=v1.2.0 # for release SD-RAN 1.2
$ make riab OPT=ransim VER=v1.3.0 # for release SD-RAN 1.3
# for a "dev" version
$ make riab OPT=ransim VER=dev # for dev version
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
NAMESPACE     NAME                                                     READY   STATUS    RESTARTS   AGE
kube-system   atomix-controller-6b6d96775-fnjm2                        1/1     Running   0          38m
kube-system   atomix-raft-storage-controller-77bd965f8d-97wql          1/1     Running   0          37m
kube-system   calico-kube-controllers-6759976d49-zkvjt                 1/1     Running   0          3d7h
kube-system   calico-node-n22vw                                        1/1     Running   0          3d7h
kube-system   coredns-dff8fc7d-b8lvl                                   1/1     Running   0          3d7h
kube-system   dns-autoscaler-5d74bb9b8f-5948j                          1/1     Running   0          3d7h
kube-system   kube-apiserver-node1                                     1/1     Running   0          3d7h
kube-system   kube-controller-manager-node1                            1/1     Running   0          3d7h
kube-system   kube-multus-ds-amd64-wg99f                               1/1     Running   0          3d7h
kube-system   kube-proxy-cvxz2                                         1/1     Running   1          3d7h
kube-system   kube-scheduler-node1                                     1/1     Running   0          3d7h
kube-system   kubernetes-dashboard-667c4c65f8-5kdcp                    1/1     Running   0          3d7h
kube-system   kubernetes-metrics-scraper-54fbb4d595-slnlv              1/1     Running   0          3d7h
kube-system   nodelocaldns-55nr9                                       1/1     Running   0          3d7h
kube-system   onos-operator-app-d56cb6f55-n25qc                        1/1     Running   0          37m
kube-system   onos-operator-config-7986b568b-hr8qk                     1/1     Running   0          37m
kube-system   onos-operator-topo-76fdf46db5-rlkth                      1/1     Running   0          37m
riab          onos-cli-9f75bc57c-b74fm                                 1/1     Running   0          50s
riab          onos-config-5d7cd9dd8c-ms9h7                             3/4     Running   0          50s
riab          onos-consensus-store-0                                   1/1     Running   0          50s
riab          onos-e2t-ff696bc5d-lwhmh                                 3/3     Running   0          50s
riab          onos-kpimon-6bdff5875c-cprqh                             2/2     Running   0          50s
riab          onos-pci-7c45d8bdc-jf4cd                                 2/2     Running   0          50s
riab          onos-topo-775f5f946f-kfxht                               3/3     Running   0          50s
riab          onos-uenib-5b6445d58f-mxtlm                              3/3     Running   0          50s
riab          ran-simulator-66c897df5c-p2sjk                           1/1     Running   0          50s
```

NOTE: If we see any issue when deploying RiaB, please check [Troubleshooting](./troubleshooting.md)

## End-to-End (E2E) tests for verification
In order to check whether everything is running, we should conduct some E2E tests and check their results.
Since RAN-Sim does only generate SD-RAN control messages, we can run E2E tests on the SD-RAN control plane.

### The E2E test on SD-RAN control plane
First, we can check E2 connections and subscriptions with `make test-e2-subscription` commands:
```bash
$ make test-e2-subscription
...
*** Get E2 subscriptions through CLI ***
Subscription ID                              Revision   Service Model ID      E2 NodeID   Encoding   Phase               State
6eb185a4fc905039fd46a9af89c65030:e2:1/5154   70         oran-e2sm-rc-pre:v2   e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
6eb185a4fc905039fd46a9af89c65030:e2:1/5153   72         oran-e2sm-rc-pre:v2   e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
c0007daeef88f0702cce3e1b47f62420:e2:1/5154   107        oran-e2sm-kpm:v2      e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
fc5e2d6967fd1923e6853e796571c946:e2:1/5153   111        oran-e2sm-kpm:v2      e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
```

Next, we can check KPIMON xApp CLI and PCI xApp CLI.
In order to check KPIMON xAPP CLI, we should type `make test-kpimon`
```bash
$ make test-kpimon
...
*** Get KPIMON result through CLI ***
Node ID          Cell Object ID       Cell Global ID            Time    RRC.Conn.Avg    RRC.Conn.Max    RRC.ConnEstabAtt.Sum    RRC.ConnEstabSucc.Sum    RRC.ConnReEstabAtt.HOFail    RRC.ConnReEstabAtt.Other    RRC.ConnReEstabAtt.Sum    RRC.ConnReEstabAtt.reconfigFail
e2:1/5153       13842601454c001             1454c001      03:01:36.0               1               2                       0                        0                            0                           0                         0                                  0
e2:1/5153       13842601454c002             1454c002      03:01:36.0               1               4                       0                        0                            0                           0                         0                                  0
e2:1/5153       13842601454c003             1454c003      03:01:36.0               1               1                       0                        0                            0                           0                         0                                  0
e2:1/5154       138426014550001             14550001      03:01:36.0               2               3                       0                        0                            0                           0                         0                                  0
e2:1/5154       138426014550002             14550002      03:01:36.0               3               3                       0                        0                            0                           0                         0                                  0
e2:1/5154       138426014550003             14550003      03:01:36.0               2               2                       0                        0                            0                           0                         0                                  0
```

*Note: It shows the current number of active UEs and the maximum number of active UEs. All other values should be 0.*

Similarly, we should type `make test-pci` to check PCI xAPP CLI.
```bash
$ make test-pci
...
*** Get PCI result through CLI ***
ID                Total Resolved Conflicts   Most Recent Resolution
13842601454c002   1                          148=>178
13842601454c003   2                          480=>168
```

*Note: The `Most Recent Resolution` results can be changed. It assigns random value.*

Also, there are two more test Makefile targets `make test-rnib` to check R-NIB, which have cell related monitoring information.
```bash
$ make test-rnib
...
*** Get R-NIB result through CLI ***
ID: e2:1/5154/14550001
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:03c782b8-d993-62d3-5ada-8cde9bcc8d64
Aspects:
- onos.topo.E2Cell={"cellObjectId":"138426014550001","cellGlobalId":{"value":"14550001"},"pci":115,"kpiReports":{"RRC.Conn.Avg":2,"RRC.Conn.Max":3,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"14550003"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c001"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550002"},"plmnId":"138426"}]}

ID: e2:1/5153/1454c003
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:efe476d6-a6e4-7483-4c55-97c2ca884e73
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c003","cellGlobalId":{"value":"1454c003"},"pci":168,"kpiReports":{"RRC.Conn.Avg":1,"RRC.Conn.Max":1,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c001"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c002"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550003"},"plmnId":"138426"}]}

ID: e2:1/5154
Kind ID: e2node
Labels: <None>
Source Id's: uuid:03c782b8-d993-62d3-5ada-8cde9bcc8d64, uuid:273c7b45-e7f3-ff52-43bd-891e86ff219d, uuid:826ab183-a742-79c2-aa83-a288ed68fa34
Target Id's: uuid:1b33b8af-8551-46de-84c0-9870a004b3a7
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:1b33b8af-8551-46de-84c0-9870a004b3a7"}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.101":{"oid":"1.3.6.1.4.1.53148.1.1.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.1.2.102":{"oid":"1.3.6.1.4.1.53148.1.1.2.102"},"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}

ID: e2:1/5153/1454c002
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:74c84ff1-74c2-388b-107e-8f62180b8aed
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c002","cellGlobalId":{"value":"1454c002"},"pci":178,"kpiReports":{"RRC.Conn.Avg":1,"RRC.Conn.Max":4,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c001"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c003"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550002"},"plmnId":"138426"}]}

ID: e2:1/5154/14550002
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:273c7b45-e7f3-ff52-43bd-891e86ff219d
Aspects:
- onos.topo.E2Cell={"cellObjectId":"138426014550002","cellGlobalId":{"value":"14550002"},"pci":480,"kpiReports":{"RRC.Conn.Avg":3,"RRC.Conn.Max":3,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c002"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550001"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550003"},"plmnId":"138426"}]}

ID: e2:onos-e2t-ff696bc5d-lwhmh
Kind ID: e2t
Labels: <None>
Source Id's: uuid:6890d815-61e3-4e94-b196-4027283b9edc, uuid:1b33b8af-8551-46de-84c0-9870a004b3a7
Target Id's:
Aspects:
- onos.topo.Lease={"expiration":"2021-10-30T03:02:35.600823920Z"}
- onos.topo.E2TInfo={"interfaces":[{"type":"INTERFACE_E2AP200","ip":"192.168.84.124","port":36421},{"type":"INTERFACE_E2T","ip":"192.168.84.124","port":5150}]}

ID: e2:1/5153
Kind ID: e2node
Labels: <None>
Source Id's: uuid:e8d1924d-8a87-3840-ada0-0cacbef26cc5, uuid:74c84ff1-74c2-388b-107e-8f62180b8aed, uuid:efe476d6-a6e4-7483-4c55-97c2ca884e73
Target Id's: uuid:6890d815-61e3-4e94-b196-4027283b9edc
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:6890d815-61e3-4e94-b196-4027283b9edc"}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.101":{"oid":"1.3.6.1.4.1.53148.1.1.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.1.2.102":{"oid":"1.3.6.1.4.1.53148.1.1.2.102"},"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}

ID: e2:1/5153/1454c001
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:e8d1924d-8a87-3840-ada0-0cacbef26cc5
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c001","cellGlobalId":{"value":"1454c001"},"pci":218,"kpiReports":{"RRC.Conn.Avg":1,"RRC.Conn.Max":2,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c002"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c003"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550001"},"plmnId":"138426"}]}

ID: e2:1/5154/14550003
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:826ab183-a742-79c2-aa83-a288ed68fa34
Aspects:
- onos.topo.E2Cell={"cellObjectId":"138426014550003","cellGlobalId":{"value":"14550003"},"pci":148,"kpiReports":{"RRC.Conn.Avg":2,"RRC.Conn.Max":2,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c003"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550001"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550002"},"plmnId":"138426"}]}
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
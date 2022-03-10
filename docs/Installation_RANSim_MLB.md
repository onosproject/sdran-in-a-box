<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Installation with RAN-Simulator and ONOS MLB xAPP
This document covers how to install ONOS RIC services with RAN-Simulator.
With this option, RiaB will deploy ONOS RIC services including ONOS-KPIMON (KPM 2.0 supported), ONOS-PCI, and ONOS-MLB xAPPs together with RAN-Simulator

## Clone this repository
To begin with, clone this repository:
```bash
$ git clone https://github.com/onosproject/sdran-in-a-box
```
**NOTE: If we want to use a specific release, we can change the branch with `git checkout [args]` command:**
```bash
$ cd /path/to/sdran-in-a-box
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
$ make riab OPT=mlb VER=stable # or just make riab OPT=mlb
# for "latest" version
$ make riab OPT=mlb VER=latest
# for a specific version
$ make riab OPT=mlb VER=v1.2.0 # for release SD-RAN 1.2
$ make riab OPT=mlb VER=v1.3.0 # for release SD-RAN 1.3
# for a "dev" version
$ make riab OPT=mlb VER=dev # for dev version
```

Once we push one of above commands, the deployment procedure starts.

If we don't see any error or failure messages, everything is deployed.
```bash
$ kubectl get po --all-namespaces
NAMESPACE     NAME                                                     READY   STATUS    RESTARTS   AGE
kube-system   atomix-controller-6b6d96775-fnjm2                        1/1     Running   0          43m
kube-system   atomix-raft-storage-controller-77bd965f8d-97wql          1/1     Running   0          43m
kube-system   calico-kube-controllers-6759976d49-zkvjt                 1/1     Running   0          3d7h
kube-system   calico-node-n22vw                                        1/1     Running   0          3d7h
kube-system   coredns-dff8fc7d-b8lvl                                   1/1     Running   0          3d7h
kube-system   dns-autoscaler-5d74bb9b8f-5948j                          1/1     Running   0          3d7h
kube-system   kube-apiserver-node1                                     1/1     Running   0          3d8h
kube-system   kube-controller-manager-node1                            1/1     Running   0          3d8h
kube-system   kube-multus-ds-amd64-wg99f                               1/1     Running   0          3d7h
kube-system   kube-proxy-cvxz2                                         1/1     Running   1          3d8h
kube-system   kube-scheduler-node1                                     1/1     Running   0          3d8h
kube-system   kubernetes-dashboard-667c4c65f8-5kdcp                    1/1     Running   0          3d7h
kube-system   kubernetes-metrics-scraper-54fbb4d595-slnlv              1/1     Running   0          3d7h
kube-system   nodelocaldns-55nr9                                       1/1     Running   0          3d7h
kube-system   onos-operator-app-d56cb6f55-n25qc                        1/1     Running   0          43m
kube-system   onos-operator-config-7986b568b-hr8qk                     1/1     Running   0          43m
kube-system   onos-operator-topo-76fdf46db5-rlkth                      1/1     Running   0          43m
riab          onos-cli-9f75bc57c-ljrc6                                 1/1     Running   0          52s
riab          onos-config-5d7cd9dd8c-bkzb6                             3/4     Running   0          52s
riab          onos-consensus-store-0                                   1/1     Running   0          52s
riab          onos-e2t-ff696bc5d-gls9x                                 3/3     Running   0          52s
riab          onos-kpimon-6bdff5875c-slg8q                             2/2     Running   0          52s
riab          onos-mlb-84fd74bfd8-4x78p                                2/2     Running   0          52s
riab          onos-pci-7c45d8bdc-qhbts                                 2/2     Running   0          52s
riab          onos-topo-775f5f946f-tg976                               3/3     Running   0          52s
riab          onos-uenib-5b6445d58f-nxjh8                              3/3     Running   0          52s
riab          ran-simulator-5c756cdfdf-9vz5p                           1/1     Running   0          52s
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
e2bc512b4c17accfe2b59877444e2bbd:e2:1/5155   93         oran-e2sm-kpm:v2      e2:1/5155   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
30627c2029157eec36fdafaa0f2618a0:e2:1/5154   58         oran-e2sm-kpm:v2      e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
6eb185a4fc905039fd46a9af89c65030:e2:1/5153   62         oran-e2sm-rc-pre:v2   e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
84ce5613b27ac3b1e357879244014095:e2:1/5153   76         oran-e2sm-kpm:v2      e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
6eb185a4fc905039fd46a9af89c65030:e2:1/5155   83         oran-e2sm-rc-pre:v2   e2:1/5155   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
6eb185a4fc905039fd46a9af89c65030:e2:1/5154   85         oran-e2sm-rc-pre:v2   e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
```

Next, we can check KPIMON xAPP CLI, PCI xAPP CLI, and MLB xAPP CLI.
In order to check KPIMON xAPP CLI, we should type `make test-kpimon`
```bash
$ make test-kpimon
...
*** Get KPIMON result through CLI ***
Node ID          Cell Object ID       Cell Global ID            Time    RRC.Conn.Avg    RRC.Conn.Max    RRC.ConnEstabAtt.Sum    RRC.ConnEstabSucc.Sum    RRC.ConnReEstabAtt.HOFail    RRC.ConnReEstabAtt.Other    RRC.ConnReEstabAtt.Sum    RRC.ConnReEstabAtt.reconfigFail
e2:1/5153       13842601454c001             1454c001      03:06:37.0               2               5                       0                        0                            0                           0                         0                                  0
e2:1/5154       13842601454c002             1454c002      03:06:37.0               6               6                       0                        0                            0                           0                         0                                  0
e2:1/5155       13842601454c003             1454c003      03:06:37.0               2               3                       0                        0                            0                           0                         0                                  0
```

*Note: It shows the current number of active UEs and the maximum number of active UEs. All other values should be 0.*

Similarly, we should type `make test-pci` to check PCI xAPP CLI.
```bash
$ make test-pci
...
*** Get PCI result through CLI ***
ID                Total Resolved Conflicts   Most Recent Resolution
13842601454c001   1                          148=>308
```

*Note: The `Most Recent Resolution` results can be changed. It assigns random value.*

Also, we should type `make test-mlb` to check MLB xAPP CLI.
```bash
$ make test-mlb
...
*** Get MLB result through CLI ***
sCell node ID   sCell PLMN ID   sCell cell ID   sCell object ID   nCell PLMN ID   nCell cell ID   Ocn [dB]
e2:1/5153       138426          1454c001        13842601454c001   138426          1454c002        0
e2:1/5153       138426          1454c001        13842601454c001   138426          1454c003        0
e2:1/5154       138426          1454c002        13842601454c002   138426          1454c001        0
e2:1/5154       138426          1454c002        13842601454c002   138426          1454c003        0
e2:1/5155       138426          1454c003        13842601454c003   138426          1454c001        0
e2:1/5155       138426          1454c003        13842601454c003   138426          1454c002        0
```

*Note: The `Ocn` value should be changed in time. It depends on the number of active UEs per cell.*

Also, there are two more test Makefile targets `make test-rnib` to check R-NIB, which have cell related monitoring information.
```bash
$ make test-rnib
...
*** Get R-NIB result through CLI ***
ID: e2:1/5154
Kind ID: e2node
Labels: <None>
Source Id's: uuid:ac8a3f12-9016-38a1-58a2-4f0cd38ad9ff
Target Id's: uuid:a2b1c47b-a2ea-4774-9345-8b550ab614fc
Aspects:
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.101":{"oid":"1.3.6.1.4.1.53148.1.1.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.1.2.102":{"oid":"1.3.6.1.4.1.53148.1.1.2.102"},"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:a2b1c47b-a2ea-4774-9345-8b550ab614fc"}

ID: e2:1/5155
Kind ID: e2node
Labels: <None>
Source Id's: uuid:da68d065-efe0-b19c-12be-f74d184e622d
Target Id's: uuid:a40563c2-98a6-42bf-b088-51e3ed4acac9
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:a40563c2-98a6-42bf-b088-51e3ed4acac9"}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.101":{"oid":"1.3.6.1.4.1.53148.1.1.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.1.2.102":{"oid":"1.3.6.1.4.1.53148.1.1.2.102"},"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}

ID: e2:1/5154/1454c002
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:ac8a3f12-9016-38a1-58a2-4f0cd38ad9ff
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c002","cellGlobalId":{"value":"1454c002"},"pci":218,"kpiReports":{"RRC.Conn.Avg":5,"RRC.Conn.Max":6,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c001"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c003"},"plmnId":"138426"}]}

ID: e2:1/5153/1454c001
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:e8d1924d-8a87-3840-ada0-0cacbef26cc5
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c001","cellGlobalId":{"value":"1454c001"},"pci":308,"kpiReports":{"RRC.Conn.Avg":2,"RRC.Conn.Max":5,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c003"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c002"},"plmnId":"138426"}]}

ID: e2:1/5155/1454c003
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:da68d065-efe0-b19c-12be-f74d184e622d
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c003","cellGlobalId":{"value":"1454c003"},"pci":148,"kpiReports":{"RRC.Conn.Avg":3,"RRC.Conn.Max":3,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c001"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c002"},"plmnId":"138426"}]}

ID: e2:onos-e2t-ff696bc5d-gls9x
Kind ID: e2t
Labels: <None>
Source Id's: uuid:a2b1c47b-a2ea-4774-9345-8b550ab614fc, uuid:0caa26b2-a5e2-4006-9a19-6bcb2a9f256c, uuid:a40563c2-98a6-42bf-b088-51e3ed4acac9
Target Id's:
Aspects:
- onos.topo.Lease={"expiration":"2021-10-30T03:08:19.461641423Z"}
- onos.topo.E2TInfo={"interfaces":[{"type":"INTERFACE_E2AP200","ip":"192.168.84.139","port":36421},{"type":"INTERFACE_E2T","ip":"192.168.84.139","port":5150}]}

ID: e2:1/5153
Kind ID: e2node
Labels: <None>
Source Id's: uuid:e8d1924d-8a87-3840-ada0-0cacbef26cc5
Target Id's: uuid:0caa26b2-a5e2-4006-9a19-6bcb2a9f256c
Aspects:
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.101":{"oid":"1.3.6.1.4.1.53148.1.1.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.1.2.102":{"oid":"1.3.6.1.4.1.53148.1.1.2.102"},"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:0caa26b2-a5e2-4006-9a19-6bcb2a9f256c"}
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
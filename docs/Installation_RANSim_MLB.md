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
$ git checkout v1.4.0 # for release 1.4
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
$ make riab OPT=mlb VER=v1.4.0 # for release SD-RAN 1.4
# for a "dev" version
$ make riab OPT=mlb VER=dev # for dev version
```

Once we push one of above commands, the deployment procedure starts.

If we don't see any error or failure messages, everything is deployed.
```bash
$ kubectl get po --all-namespaces
NAMESPACE     NAME                                              READY   STATUS    RESTARTS   AGE
kube-system   atomix-controller-99f978c7d-fscn4                 1/1     Running   0          148m
kube-system   atomix-raft-storage-controller-75979cfff8-kjs9k   1/1     Running   0          148m
kube-system   calico-kube-controllers-584ddbb8fb-nxb7l          1/1     Running   0          3h59m
kube-system   calico-node-s5czk                                 1/1     Running   1          3h59m
kube-system   coredns-dff8fc7d-nznzf                            1/1     Running   0          3h58m
kube-system   dns-autoscaler-5d74bb9b8f-cfwvp                   1/1     Running   0          3h58m
kube-system   kube-apiserver-node1                              1/1     Running   0          4h
kube-system   kube-controller-manager-node1                     1/1     Running   0          4h
kube-system   kube-multus-ds-amd64-r42zf                        1/1     Running   0          3h59m
kube-system   kube-proxy-vp7k7                                  1/1     Running   1          4h
kube-system   kube-scheduler-node1                              1/1     Running   0          4h
kube-system   kubernetes-dashboard-667c4c65f8-cr6q5             1/1     Running   0          3h58m
kube-system   kubernetes-metrics-scraper-54fbb4d595-t8rgz       1/1     Running   0          3h58m
kube-system   nodelocaldns-rc6w7                                1/1     Running   0          3h58m
kube-system   onos-operator-app-d56cb6f55-mhjsj                 1/1     Running   0          147m
kube-system   onos-operator-config-7986b568b-rgb72              1/1     Running   0          147m
kube-system   onos-operator-topo-76fdf46db5-5ttxx               1/1     Running   0          147m
riab          onos-a1t-84db77df99-8sgrd                         2/2     Running   0          99s
riab          onos-cli-6b746874c8-wmj2s                         1/1     Running   0          99s
riab          onos-config-7bd4b6f7f6-4h7sd                      4/4     Running   0          99s
riab          onos-consensus-store-0                            1/1     Running   0          99s
riab          onos-e2t-58b4cd867-jkpvx                          3/3     Running   0          99s
riab          onos-kpimon-966bdf77f-vwnmt                       2/2     Running   0          99s
riab          onos-mlb-8478c544f6-gjm5v                         2/2     Running   0          99s
riab          onos-pci-896557979-8wzpt                          2/2     Running   0          99s
riab          onos-topo-7cc9d754d7-glmrp                        3/3     Running   0          99s
riab          onos-uenib-779cb5dbd6-gfllx                       3/3     Running   0          99s
riab          ran-simulator-6976db498c-mqf74                    1/1     Running   0          99s
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
30627c2029157eec36fdafaa0f2618a0:e2:1/5154   54         oran-e2sm-kpm:v2      e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
e2bc512b4c17accfe2b59877444e2bbd:e2:1/5155   59         oran-e2sm-kpm:v2      e2:1/5155   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
6eb185a4fc905039fd46a9af89c65030:e2:1/5155   64         oran-e2sm-rc-pre:v2   e2:1/5155   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
6eb185a4fc905039fd46a9af89c65030:e2:1/5153   76         oran-e2sm-rc-pre:v2   e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
84ce5613b27ac3b1e357879244014095:e2:1/5153   85         oran-e2sm-kpm:v2      e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
6eb185a4fc905039fd46a9af89c65030:e2:1/5154   90         oran-e2sm-rc-pre:v2   e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
```

Next, we can check KPIMON xAPP CLI, PCI xAPP CLI, and MLB xAPP CLI.
In order to check KPIMON xAPP CLI, we should type `make test-kpimon`
```bash
$ make test-kpimon
...
*** Get KPIMON result through CLI ***
Node ID          Cell Object ID       Cell Global ID            Time    RRC.Conn.Avg    RRC.Conn.Max    RRC.ConnEstabAtt.Sum    RRC.ConnEstabSucc.Sum    RRC.ConnReEstabAtt.HOFail    RRC.ConnReEstabAtt.Other    RRC.ConnReEstabAtt.Sum    RRC.ConnReEstabAtt.reconfigFail
e2:1/5153       13842601454c001             1454c001      02:30:32.0               2               3                       0                        0                            0                           0                         0                                  0
e2:1/5154       13842601454c002             1454c002      02:30:33.0               7               7                       0                        0                            0                           0                         0                                  0
e2:1/5155       13842601454c003             1454c003      02:30:33.0               1               4                       0                        0                            0                           0                         0                                  0
```

*Note: It shows the current number of active UEs and the maximum number of active UEs. All other values should be 0.*

Similarly, we should type `make test-pci` to check PCI xAPP CLI.
```bash
$ make test-pci
...
*** Get PCI result through CLI ***
ID                Total Resolved Conflicts   Most Recent Resolution
13842601454c003   1                          148=>172
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
ID: e2:1/5153/1454c001
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:e8d1924d-8a87-3840-ada0-0cacbef26cc5
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c001","cellGlobalId":{"value":"1454c001"},"cellType":"CELL_SIZE_MACRO","pci":148,"kpiReports":{"RRC.Conn.Avg":2,"RRC.Conn.Max":3,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c003"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c002"},"plmnId":"138426"}]}

ID: gnmi:onos-config-7bd4b6f7f6-4h7sd
Kind ID: onos-config
Labels: <None>
Source Id's:
Target Id's:
Aspects:
- onos.topo.Lease={"expiration":"2022-03-11T02:31:47.462971305Z"}

ID: e2:1/5153
Kind ID: e2node
Labels: <None>
Source Id's: uuid:e8d1924d-8a87-3840-ada0-0cacbef26cc5
Target Id's: uuid:ea0e83f2-25cf-4890-90c7-53f737adb7de
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:ea0e83f2-25cf-4890-90c7-53f737adb7de"}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.101":{"oid":"1.3.6.1.4.1.53148.1.2.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}

ID: e2:1/5155
Kind ID: e2node
Labels: <None>
Source Id's: uuid:da68d065-efe0-b19c-12be-f74d184e622d
Target Id's: uuid:34c44d72-d509-4cbe-b089-e64551d918f0
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:34c44d72-d509-4cbe-b089-e64551d918f0"}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.101":{"oid":"1.3.6.1.4.1.53148.1.2.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}

ID: e2:1/5154/1454c002
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:ac8a3f12-9016-38a1-58a2-4f0cd38ad9ff
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c002","cellGlobalId":{"value":"1454c002"},"cellType":"CELL_SIZE_FEMTO","pci":218,"kpiReports":{"RRC.Conn.Avg":6,"RRC.Conn.Max":7,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c001"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c003"},"plmnId":"138426"}]}

ID: e2:1/5155/1454c003
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:da68d065-efe0-b19c-12be-f74d184e622d
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c003","cellGlobalId":{"value":"1454c003"},"cellType":"CELL_SIZE_OUTDOOR_SMALL","pci":172,"kpiReports":{"RRC.Conn.Avg":2,"RRC.Conn.Max":4,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c001"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c002"},"plmnId":"138426"}]}

ID: e2:onos-e2t-58b4cd867-jkpvx
Kind ID: e2t
Labels: <None>
Source Id's: uuid:ea0e83f2-25cf-4890-90c7-53f737adb7de, uuid:c5c9ab24-a97e-47c0-aa2e-67bae33a89eb, uuid:34c44d72-d509-4cbe-b089-e64551d918f0
Target Id's:
Aspects:
- onos.topo.Lease={"expiration":"2022-03-11T02:31:50.942961091Z"}
- onos.topo.E2TInfo={"interfaces":[{"type":"INTERFACE_E2AP200","ip":"192.168.84.62","port":36421},{"type":"INTERFACE_E2T","ip":"192.168.84.62","port":5150}]}

ID: e2:1/5154
Kind ID: e2node
Labels: <None>
Source Id's: uuid:ac8a3f12-9016-38a1-58a2-4f0cd38ad9ff
Target Id's: uuid:c5c9ab24-a97e-47c0-aa2e-67bae33a89eb
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:c5c9ab24-a97e-47c0-aa2e-67bae33a89eb"}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.101":{"oid":"1.3.6.1.4.1.53148.1.2.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}

ID: a1:onos-a1t-84db77df99-8sgrd
Kind ID: a1t
Labels: <None>
Source Id's:
Target Id's:
Aspects:
- onos.topo.A1TInfo={"interfaces":[{"type":"INTERFACE_A1AP","ip":"192.168.84.64","port":9639}]}
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
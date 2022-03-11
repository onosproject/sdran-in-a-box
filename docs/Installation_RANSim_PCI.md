<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

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
$ make riab OPT=ransim VER=stable # or just make riab OPT=ransim
# for "latest" version
$ make riab OPT=ransim VER=latest
# for a specific version
$ make riab OPT=ransim VER=v1.0.0 # for release SD-RAN 1.0
$ make riab OPT=ransim VER=v1.1.0 # for release SD-RAN 1.1
$ make riab OPT=ransim VER=v1.1.1 # for release SD-RAN 1.1.1
$ make riab OPT=ransim VER=v1.2.0 # for release SD-RAN 1.2
$ make riab OPT=ransim VER=v1.3.0 # for release SD-RAN 1.3
$ make riab OPT=ransim VER=v1.4.0 # for release SD-RAN 1.4
# for a "dev" version
$ make riab OPT=ransim VER=dev # for dev version
```

Once we push one of above commands, the deployment procedure starts.

If we don't see any error or failure messages, everything is deployed.
```bash
NAMESPACE     NAME                                              READY   STATUS    RESTARTS   AGE
kube-system   atomix-controller-99f978c7d-fscn4                 1/1     Running   0          3m5s
kube-system   atomix-raft-storage-controller-75979cfff8-kjs9k   1/1     Running   0          2m51s
kube-system   calico-kube-controllers-584ddbb8fb-nxb7l          1/1     Running   0          93m
kube-system   calico-node-s5czk                                 1/1     Running   1          94m
kube-system   coredns-dff8fc7d-nznzf                            1/1     Running   0          93m
kube-system   dns-autoscaler-5d74bb9b8f-cfwvp                   1/1     Running   0          93m
kube-system   kube-apiserver-node1                              1/1     Running   0          95m
kube-system   kube-controller-manager-node1                     1/1     Running   0          95m
kube-system   kube-multus-ds-amd64-r42zf                        1/1     Running   0          93m
kube-system   kube-proxy-vp7k7                                  1/1     Running   1          94m
kube-system   kube-scheduler-node1                              1/1     Running   0          95m
kube-system   kubernetes-dashboard-667c4c65f8-cr6q5             1/1     Running   0          93m
kube-system   kubernetes-metrics-scraper-54fbb4d595-t8rgz       1/1     Running   0          93m
kube-system   nodelocaldns-rc6w7                                1/1     Running   0          93m
kube-system   onos-operator-app-d56cb6f55-mhjsj                 1/1     Running   0          2m31s
kube-system   onos-operator-config-7986b568b-rgb72              1/1     Running   0          2m32s
kube-system   onos-operator-topo-76fdf46db5-5ttxx               1/1     Running   0          2m31s
riab          onos-a1t-84db77df99-qrnrl                         2/2     Running   0          114s
riab          onos-cli-6b746874c8-92577                         1/1     Running   0          114s
riab          onos-config-7bd4b6f7f6-pcstn                      4/4     Running   0          114s
riab          onos-consensus-store-0                            1/1     Running   0          113s
riab          onos-e2t-58b4cd867-5x5jc                          3/3     Running   0          114s
riab          onos-kpimon-966bdf77f-zk8cj                       2/2     Running   0          114s
riab          onos-pci-896557979-cgt9x                          2/2     Running   0          114s
riab          onos-topo-7cc9d754d7-sb9bh                        3/3     Running   0          114s
riab          onos-uenib-779cb5dbd6-lvmbb                       3/3     Running   0          114s
riab          ran-simulator-85b945db79-jhzrr                    1/1     Running   0          114s
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
fc5e2d6967fd1923e6853e796571c946:e2:1/5153   64         oran-e2sm-kpm:v2      e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
6eb185a4fc905039fd46a9af89c65030:e2:1/5154   72         oran-e2sm-rc-pre:v2   e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
c0007daeef88f0702cce3e1b47f62420:e2:1/5154   84         oran-e2sm-kpm:v2      e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
6eb185a4fc905039fd46a9af89c65030:e2:1/5153   88         oran-e2sm-rc-pre:v2   e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
```

Next, we can check KPIMON xAPP CLI and PCI xAPP CLI.
In order to check KPIMON xAPP CLI, we should type `make test-kpimon`
```bash
$ make test-kpimon
...
*** Get KPIMON result through CLI ***
Node ID          Cell Object ID       Cell Global ID            Time    RRC.Conn.Avg    RRC.Conn.Max    RRC.ConnEstabAtt.Sum    RRC.ConnEstabSucc.Sum    RRC.ConnReEstabAtt.HOFail    RRC.ConnReEstabAtt.Other    RRC.ConnReEstabAtt.Sum    RRC.ConnReEstabAtt.reconfigFail
e2:1/5153       13842601454c001             1454c001      00:05:12.0               3               3                       0                        0                            0                           0                         0                                  0
e2:1/5153       13842601454c002             1454c002      00:05:12.0               3               5                       0                        0                            0                           0                         0                                  0
e2:1/5153       13842601454c003             1454c003      00:05:12.0               1               1                       0                        0                            0                           0                         0                                  0
e2:1/5154       138426014550001             14550001      00:05:12.0               1               1                       0                        0                            0                           0                         0                                  0
e2:1/5154       138426014550002             14550002      00:05:12.0               1               1                       0                        0                            0                           0                         0                                  0
e2:1/5154       138426014550003             14550003      00:05:12.0               2               4                       0                        0                            0                           0                         0                                  0
```

*Note: It shows the current number of active UEs and the maximum number of active UEs. All other values should be 0.*

Similarly, we should type `make test-pci` to check PCI xAPP CLI.
```bash
$ make test-pci
...
*** Get PCI result through CLI ***
ID                Total Resolved Conflicts   Most Recent Resolution
138426014550002   1                          480=>412
138426014550003   1                          148=>91
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
- onos.topo.E2Cell={"cellObjectId":"138426014550001","cellGlobalId":{"value":"14550001"},"cellType":"CELL_SIZE_OUTDOOR_SMALL","pci":115,"kpiReports":{"RRC.Conn.Avg":1,"RRC.Conn.Max":2,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"14550003"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c001"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550002"},"plmnId":"138426"}]}

ID: a1:onos-a1t-84db77df99-qrnrl
Kind ID: a1t
Labels: <None>
Source Id's:
Target Id's:
Aspects:
- onos.topo.A1TInfo={"interfaces":[{"type":"INTERFACE_A1AP","ip":"192.168.84.57","port":9639}]}

ID: e2:1/5154/14550003
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:826ab183-a742-79c2-aa83-a288ed68fa34
Aspects:
- onos.topo.E2Cell={"cellObjectId":"138426014550003","cellGlobalId":{"value":"14550003"},"cellType":"CELL_SIZE_FEMTO","pci":91,"kpiReports":{"RRC.Conn.Avg":1,"RRC.Conn.Max":4,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c003"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550001"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550002"},"plmnId":"138426"}]}

ID: e2:1/5153/1454c003
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:efe476d6-a6e4-7483-4c55-97c2ca884e73
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c003","cellGlobalId":{"value":"1454c003"},"cellType":"CELL_SIZE_MACRO","pci":480,"kpiReports":{"RRC.Conn.Avg":1,"RRC.Conn.Max":1,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c001"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c002"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550003"},"plmnId":"138426"}]}

ID: e2:1/5153
Kind ID: e2node
Labels: <None>
Source Id's: uuid:e8d1924d-8a87-3840-ada0-0cacbef26cc5, uuid:74c84ff1-74c2-388b-107e-8f62180b8aed, uuid:efe476d6-a6e4-7483-4c55-97c2ca884e73
Target Id's: uuid:ff76b287-e903-4362-afd7-6cdfaf8d1411
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:ff76b287-e903-4362-afd7-6cdfaf8d1411"}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.101":{"oid":"1.3.6.1.4.1.53148.1.2.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}

ID: e2:1/5153/1454c002
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:74c84ff1-74c2-388b-107e-8f62180b8aed
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c002","cellGlobalId":{"value":"1454c002"},"cellType":"CELL_SIZE_OUTDOOR_SMALL","pci":148,"kpiReports":{"RRC.Conn.Avg":3,"RRC.Conn.Max":5,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c001"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c003"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550002"},"plmnId":"138426"}]}

ID: e2:onos-e2t-58b4cd867-5x5jc
Kind ID: e2t
Labels: <None>
Source Id's: uuid:03c825a3-c71c-40d5-aa14-f051d4c8af76, uuid:ff76b287-e903-4362-afd7-6cdfaf8d1411
Target Id's:
Aspects:
- onos.topo.E2TInfo={"interfaces":[{"type":"INTERFACE_E2AP200","ip":"192.168.84.60","port":36421},{"type":"INTERFACE_E2T","ip":"192.168.84.60","port":5150}]}
- onos.topo.Lease={"expiration":"2022-03-11T00:06:20.370713981Z"}

ID: gnmi:onos-config-7bd4b6f7f6-pcstn
Kind ID: onos-config
Labels: <None>
Source Id's:
Target Id's:
Aspects:
- onos.topo.Lease={"expiration":"2022-03-11T00:06:22.723391817Z"}

ID: e2:1/5153/1454c001
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:e8d1924d-8a87-3840-ada0-0cacbef26cc5
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c001","cellGlobalId":{"value":"1454c001"},"cellType":"CELL_SIZE_OUTDOOR_SMALL","pci":218,"kpiReports":{"RRC.Conn.Avg":4,"RRC.Conn.Max":4,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c002"},"plmnId":"138426"},{"cellGlobalId":{"value":"1454c003"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550001"},"plmnId":"138426"}]}

ID: e2:1/5154/14550002
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:273c7b45-e7f3-ff52-43bd-891e86ff219d
Aspects:
- onos.topo.E2Cell={"cellObjectId":"138426014550002","cellGlobalId":{"value":"14550002"},"cellType":"CELL_SIZE_MACRO","pci":412,"kpiReports":{"RRC.Conn.Avg":0,"RRC.Conn.Max":1,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0},"neighborCellIds":[{"cellGlobalId":{"value":"1454c002"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550001"},"plmnId":"138426"},{"cellGlobalId":{"value":"14550003"},"plmnId":"138426"}]}

ID: e2:1/5154
Kind ID: e2node
Labels: <None>
Source Id's: uuid:03c782b8-d993-62d3-5ada-8cde9bcc8d64, uuid:273c7b45-e7f3-ff52-43bd-891e86ff219d, uuid:826ab183-a742-79c2-aa83-a288ed68fa34
Target Id's: uuid:03c825a3-c71c-40d5-aa14-f051d4c8af76
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:03c825a3-c71c-40d5-aa14-f051d4c8af76"}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.101":{"oid":"1.3.6.1.4.1.53148.1.2.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}
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
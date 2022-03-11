<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Installation with RAN-Simulator and ONOS MHO xAPP
This document covers how to install ONOS RIC services with RAN-Simulator.
With this option, RiaB will deploy ONOS RIC services including ONOS-KPIMON (KPM 2.0 supported), and ONOS-MHO xAPPs together with RAN-Simulator

## Clone this repository
To begin with, clone this repository:
```bash
$ git clone https://github.com/onosproject/sdran-in-a-box
```
**NOTE: If we want to use a specific release, we can change the branch with `git checkout [args]` command:**
```bash
$ cd /path/to/sdran-in-a-box
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
$ make riab OPT=mho VER=stable # or just make riab OPT=mho
# for "latest" version
$ make riab OPT=mho VER=latest
# for a specific version
$ make riab OPT=mho VER=v1.3.0 # for release SD-RAN 1.3
$ make riab OPT=mho VER=v1.4.0 # for release SD-RAN 1.4
# for a "dev" version
$ make riab OPT=mho VER=dev # for dev version
```

Once we push one of above commands, the deployment procedure starts.

If we don't see any error or failure messages, everything is deployed.
```bash
$ kubectl get po --all-namespaces
NAMESPACE     NAME                                              READY   STATUS    RESTARTS   AGE
kube-system   atomix-controller-99f978c7d-t6p79                 1/1     Running   0          3m13s
kube-system   atomix-raft-storage-controller-75979cfff8-vdqc6   1/1     Running   0          2m52s
kube-system   calico-kube-controllers-584ddbb8fb-nxb7l          1/1     Running   0          4h6m
kube-system   calico-node-s5czk                                 1/1     Running   1          4h6m
kube-system   coredns-dff8fc7d-nznzf                            1/1     Running   0          4h6m
kube-system   dns-autoscaler-5d74bb9b8f-cfwvp                   1/1     Running   0          4h6m
kube-system   kube-apiserver-node1                              1/1     Running   0          4h7m
kube-system   kube-controller-manager-node1                     1/1     Running   0          4h7m
kube-system   kube-multus-ds-amd64-r42zf                        1/1     Running   0          4h6m
kube-system   kube-proxy-vp7k7                                  1/1     Running   1          4h7m
kube-system   kube-scheduler-node1                              1/1     Running   0          4h7m
kube-system   kubernetes-dashboard-667c4c65f8-cr6q5             1/1     Running   0          4h6m
kube-system   kubernetes-metrics-scraper-54fbb4d595-t8rgz       1/1     Running   0          4h6m
kube-system   nodelocaldns-rc6w7                                1/1     Running   0          4h6m
kube-system   onos-operator-app-d56cb6f55-f5zp6                 1/1     Running   0          2m37s
kube-system   onos-operator-config-7986b568b-lmt8n              1/1     Running   0          2m37s
kube-system   onos-operator-topo-76fdf46db5-2k67g               1/1     Running   0          2m39s
riab          onos-a1t-84db77df99-gjqcx                         2/2     Running   0          2m5s
riab          onos-cli-6b746874c8-6qn27                         1/1     Running   0          2m5s
riab          onos-config-7bd4b6f7f6-brd68                      4/4     Running   0          2m5s
riab          onos-consensus-store-0                            1/1     Running   0          2m4s
riab          onos-e2t-58b4cd867-hskmq                          3/3     Running   0          2m5s
riab          onos-kpimon-966bdf77f-q4q5l                       2/2     Running   0          2m5s
riab          onos-mho-7859ffdd68-m85vf                         2/2     Running   0          2m5s
riab          onos-topo-7cc9d754d7-t7mqs                        3/3     Running   0          2m5s
riab          onos-uenib-779cb5dbd6-bvg8f                       3/3     Running   0          2m5s
riab          ran-simulator-5449b4c8f9-jqhm7                    1/1     Running   0          2m5s
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
76d79858affefc5ecef79683581f1561:e2:1/5153   116        oran-e2sm-mho:v2   e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
bab81642e0e6d82c57a54060feeabe6f:e2:1/5153   127        oran-e2sm-mho:v2   e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
1ef6855642744782186c9ba6626393a6:e2:1/5154   54         oran-e2sm-kpm:v2   e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
84ce5613b27ac3b1e357879244014095:e2:1/5153   59         oran-e2sm-kpm:v2   e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
14d96d88f13bba8ba7889bdf532c059d:e2:1/5153   71         oran-e2sm-mho:v2   e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
bab81642e0e6d82c57a54060feeabe6f:e2:1/5154   78         oran-e2sm-mho:v2   e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
76d79858affefc5ecef79683581f1561:e2:1/5154   102        oran-e2sm-mho:v2   e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
14d96d88f13bba8ba7889bdf532c059d:e2:1/5154   111        oran-e2sm-mho:v2   e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
```

Next, we can check KPIMON xAPP CLI and MHO xAPP CLI.
In order to check KPIMON xAPP CLI, we should type `make test-kpimon`
```bash
$ make test-kpimon
...
*** Get KPIMON result through CLI ***
Node ID          Cell Object ID       Cell Global ID            Time    RRC.Conn.Avg    RRC.Conn.Max    RRC.ConnEstabAtt.Sum    RRC.ConnEstabSucc.Sum    RRC.ConnReEstabAtt.HOFail    RRC.ConnReEstabAtt.Other    RRC.ConnReEstabAtt.Sum    RRC.ConnReEstabAtt.reconfigFail
e2:1/5153       13842601454c001             1454c001      02:37:49.0               0               1                       0                        0                            0                           0                         0                                  0
e2:1/5154       138426014550001             14550001      02:37:49.0               1               1                       0                        0                            0                           0                         0                                  0
```

*Note: It shows the current number of active UEs and the maximum number of active UEs. All other values should be 0.*

Also, we should type `make test-mho` to check MHO xAPP CLI.
```bash
$ make test-mho
...
*** Get MHO result through CLI - Cells ***
CGI              Num UEs          Handovers-in     Handovers-out
13842601c054140  1                3                3
138426010055140  0                3                3
*** Get MHO result through CLI - UEs ***
UeID     CellGlobalID     RrcState
2a54d6   13842601c054140  CONNECTED
```

*Note: The `Handovers-in/out` values should be changed in time.*

Also, there are two more test Makefile targets `make test-rnib` and `make test-uenib` to check R-NIB and UE-NIB, which have cell and UE related monitoring information.
```bash
$ make test-rnib
...
*** Get R-NIB result through CLI ***
ID: gnmi:onos-config-7bd4b6f7f6-brd68
Kind ID: onos-config
Labels: <None>
Source Id's:
Target Id's:
Aspects:
- onos.topo.Lease={"expiration":"2022-03-11T02:38:49.785658001Z"}

ID: e2:1/5154
Kind ID: e2node
Labels: <None>
Source Id's: uuid:03c782b8-d993-62d3-5ada-8cde9bcc8d64
Target Id's: uuid:8b340ee9-1aa0-492f-bd8c-2ffefeef8185
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:8b340ee9-1aa0-492f-bd8c-2ffefeef8185"}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.101":{"oid":"1.3.6.1.4.1.53148.1.2.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}

ID: e2:1/5153/1454c001
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:e8d1924d-8a87-3840-ada0-0cacbef26cc5
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c001","cellGlobalId":{"value":"1454c001"},"kpiReports":{"RRC.Conn.Avg":0,"RRC.Conn.Max":1,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0}}

ID: e2:1/5154/14550001
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:03c782b8-d993-62d3-5ada-8cde9bcc8d64
Aspects:
- onos.topo.E2Cell={"cellObjectId":"138426014550001","cellGlobalId":{"value":"14550001"},"kpiReports":{"RRC.Conn.Avg":1,"RRC.Conn.Max":1,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0}}

ID: e2:1/5153
Kind ID: e2node
Labels: <None>
Source Id's: uuid:e8d1924d-8a87-3840-ada0-0cacbef26cc5
Target Id's: uuid:7c05ca75-a88d-433b-bf2c-997292cd60e8
Aspects:
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.101":{"oid":"1.3.6.1.4.1.53148.1.2.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:7c05ca75-a88d-433b-bf2c-997292cd60e8"}

ID: e2:onos-e2t-58b4cd867-hskmq
Kind ID: e2t
Labels: <None>
Source Id's: uuid:7c05ca75-a88d-433b-bf2c-997292cd60e8, uuid:8b340ee9-1aa0-492f-bd8c-2ffefeef8185
Target Id's:
Aspects:
- onos.topo.E2TInfo={"interfaces":[{"type":"INTERFACE_E2AP200","ip":"192.168.84.87","port":36421},{"type":"INTERFACE_E2T","ip":"192.168.84.87","port":5150}]}
- onos.topo.Lease={"expiration":"2022-03-11T02:38:54.250647685Z"}

ID: a1:onos-a1t-84db77df99-gjqcx
Kind ID: a1t
Labels: <None>
Source Id's:
Target Id's:
Aspects:
- onos.topo.A1TInfo={"interfaces":[{"type":"INTERFACE_A1AP","ip":"192.168.84.79","port":9639}]}

$ make test-uenib
*** Get UE-NIB result through CLI ***
ID: 2774230
Aspects:
- RSRP-Neighbors=138426010055140:-117
- 5QI=166
- RSRP-Serving=-100
- RRCState=RRCSTATUS_CONNECTED
- CGI=13842601c054140
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
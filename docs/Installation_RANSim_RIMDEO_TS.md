<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Installation with RAN-Simulator and RIMEDO Labs Traffic Steering xAPP (rimedo-ts xApp)
This document covers how to install ONOS RIC services with RAN-Simulator.
With this option, RiaB will deploy ONOS RIC services including ONOS-KPIMON (KPM 2.0 supported), and RIMDEO-TS xAPPs together with RAN-Simulator

## Clone this repository
To begin with, clone this repository:
```bash
$ git clone https://github.com/onosproject/sdran-in-a-box
```
**NOTE: If we want to use a specific release, we can change the branch with `git checkout [args]` command:**
```bash
$ cd /path/to/sdran-in-a-box
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
$ make riab OPT=rimedots VER=stable # or just make riab OPT=rimedots
# for "latest" version
$ make riab OPT=rimedots VER=latest
# for a specific version
$ make riab OPT=rimedots VER=v1.4.0 # for release SD-RAN 1.4
# for a "dev" version
$ make riab OPT=rimedots VER=dev # for dev version
```

Once we push one of above commands, the deployment procedure starts.

If we don't see any error or failure messages, everything is deployed.
```bash
$ kubectl get po --all-namespaces
NAMESPACE     NAME                                              READY   STATUS    RESTARTS   AGE
kube-system   atomix-controller-99f978c7d-vhphs                 1/1     Running   0          35m
kube-system   atomix-raft-storage-controller-75979cfff8-p2mb4   1/1     Running   0          34m
kube-system   calico-kube-controllers-584ddbb8fb-tn4wh          1/1     Running   0          3h7m
kube-system   calico-node-g4zj8                                 1/1     Running   1          3h8m
kube-system   coredns-dff8fc7d-b7gcl                            1/1     Running   0          3h7m
kube-system   dns-autoscaler-5d74bb9b8f-scxgf                   1/1     Running   0          3h7m
kube-system   kube-apiserver-node1                              1/1     Running   0          3h8m
kube-system   kube-controller-manager-node1                     1/1     Running   0          3h8m
kube-system   kube-multus-ds-amd64-g4mfr                        1/1     Running   0          3h7m
kube-system   kube-proxy-rflq8                                  1/1     Running   0          3h8m
kube-system   kube-scheduler-node1                              1/1     Running   0          3h8m
kube-system   kubernetes-dashboard-667c4c65f8-gqpx4             1/1     Running   0          3h7m
kube-system   kubernetes-metrics-scraper-54fbb4d595-7nlsp       1/1     Running   0          3h7m
kube-system   nodelocaldns-8ktdr                                1/1     Running   0          3h7m
kube-system   onos-operator-app-588d479876-zdc4f                1/1     Running   0          34m
kube-system   onos-operator-topo-5f8cd6ff7c-q4pc5               1/1     Running   0          34m
riab          onos-a1t-84db77df99-shtxx                         2/2     Running   0          69s
riab          onos-cli-6b746874c8-zkcxg                         1/1     Running   0          69s
riab          onos-config-7bd4b6f7f6-zwxkb                      4/4     Running   0          69s
riab          onos-consensus-store-0                            1/1     Running   0          69s
riab          onos-e2t-58b4cd867-s25bf                          3/3     Running   0          69s
riab          onos-kpimon-966bdf77f-xjxn4                       2/2     Running   0          69s
riab          onos-topo-7cc9d754d7-xnngw                        3/3     Running   0          69s
riab          onos-uenib-779cb5dbd6-8jn6h                       3/3     Running   0          69s
riab          ran-simulator-5449b4c8f9-cqbwt                    1/1     Running   0          69s
riab          sd-ran-rimedo-ts-7fb74c65c-mbc9k                  2/2     Running   0          69s
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
Subscription ID                              Revision   Service Model ID   E2 NodeID   Encoding   Phase               State
76d79858affefc5ecef79683581f1561:e2:1/5153   89         oran-e2sm-mho:v2   e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
14d96d88f13bba8ba7889bdf532c059d:e2:1/5153   96         oran-e2sm-mho:v2   e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
76d79858affefc5ecef79683581f1561:e2:1/5154   103        oran-e2sm-mho:v2   e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
bab81642e0e6d82c57a54060feeabe6f:e2:1/5153   112        oran-e2sm-mho:v2   e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
1ef6855642744782186c9ba6626393a6:e2:1/5154   55         oran-e2sm-kpm:v2   e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
84ce5613b27ac3b1e357879244014095:e2:1/5153   62         oran-e2sm-kpm:v2   e2:1/5153   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
bab81642e0e6d82c57a54060feeabe6f:e2:1/5154   71         oran-e2sm-mho:v2   e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
14d96d88f13bba8ba7889bdf532c059d:e2:1/5154   79         oran-e2sm-mho:v2   e2:1/5154   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
```

Next, we can check KPIMON xAPP CLI and RIMDEO-TS xAPP CLI.
In order to check KPIMON xAPP CLI, we should type `make test-kpimon`
```bash
$ make test-kpimon
...
*** Get KPIMON result through CLI ***
Node ID          Cell Object ID       Cell Global ID            Time    RRC.Conn.Avg    RRC.Conn.Max    RRC.ConnEstabAtt.Sum    RRC.ConnEstabSucc.Sum    RRC.ConnReEstabAtt.HOFail    RRC.ConnReEstabAtt.Other    RRC.ConnReEstabAtt.Sum    RRC.ConnReEstabAtt.reconfigFail
e2:1/5153       13842601454c001             1454c001      12:54:46.0               1               1                       0                        0                            0                           0                         0                                  0
e2:1/5154       138426014550001             14550001      12:54:46.0               0               1                       0                        0                            0                           0                         0                                  0
```

*Note: It shows the current number of active UEs and the maximum number of active UEs. All other values should be 0.*

Also, we should type `make a1t` to check A1 policies installed in RIMEDO-TS xApp.
```bash
$ make test-a1t
...
*** Get A1T subscriptions through CLI ***
xApp ID                                              xApp A1 Interface                A1 Service                       A1 Service Type ID
a1:sd-ran-rimedo-ts-7fb74c65c-mbc9k                  192.168.84.249:5150              PolicyManagement                 ORAN_TrafficSteeringPreference_2.0.0
a1:sd-ran-rimedo-ts-7fb74c65c-mbc9k                  192.168.84.249:5150              EnrichmentInformation
*** Get A1T policy type through CLI ***
PolicyTypeID                                         List(PolicyObjectID)
ORAN_TrafficSteeringPreference_2.0.0                 []
*** Get A1T policy objects through CLI ***
PolicyTypeID                                         PolicyObjectID
*** Get A1T policy status through CLI ***
PolicyTypeID                                         PolicyObjectID                   Status
```

*Note: there should be two A1 services {`PolicyManagement`, `EnrichmentInformation`}, one PolicyTypeID `ORAN_TrafficSteeringPreference_2.0.0` and empty object list and status result at this moment*

Also, there are two more test Makefile targets `make test-rnib` to check R-NIB, which have cell related information.
```bash
$ make test-rnib
...
*** Get R-NIB result through CLI ***
ID: e2:onos-e2t-58b4cd867-s25bf
Kind ID: e2t
Labels: <None>
Source Id's: uuid:f7e7fb07-42f5-43d9-a6d1-f4329deb59be, uuid:865b465c-df7a-4c35-a478-bfedf73009ac
Target Id's:
Aspects:
- onos.topo.E2TInfo={"interfaces":[{"type":"INTERFACE_E2AP200","ip":"192.168.84.248","port":36421},{"type":"INTERFACE_E2T","ip":"192.168.84.248","port":5150}]}
- onos.topo.Lease={"expiration":"2022-03-11T12:56:04.666612200Z"}

ID: e2:1/5154
Kind ID: e2node
Labels: <None>
Source Id's: uuid:03c782b8-d993-62d3-5ada-8cde9bcc8d64
Target Id's: uuid:865b465c-df7a-4c35-a478-bfedf73009ac
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:865b465c-df7a-4c35-a478-bfedf73009ac"}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.101":{"oid":"1.3.6.1.4.1.53148.1.2.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}

ID: e2:1/5154/14550001
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:03c782b8-d993-62d3-5ada-8cde9bcc8d64
Aspects:
- onos.topo.E2Cell={"cellObjectId":"138426014550001","cellGlobalId":{"value":"14550001"},"kpiReports":{"RRC.Conn.Avg":0,"RRC.Conn.Max":1,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0}}

ID: gnmi:onos-config-7bd4b6f7f6-zwxkb
Kind ID: onos-config
Labels: <None>
Source Id's:
Target Id's:
Aspects:
- onos.topo.Lease={"expiration":"2022-03-11T12:56:08.895301044Z"}

ID: a1:onos-a1t-84db77df99-shtxx
Kind ID: a1t
Labels: <None>
Source Id's: uuid:039b05b5-5b33-72bf-4d93-bbc7178e4afc
Target Id's:
Aspects:
- onos.topo.A1TInfo={"interfaces":[{"type":"INTERFACE_A1AP","ip":"192.168.84.247","port":9639}]}

ID: e2:1/5153
Kind ID: e2node
Labels: <None>
Source Id's: uuid:e8d1924d-8a87-3840-ada0-0cacbef26cc5
Target Id's: uuid:f7e7fb07-42f5-43d9-a6d1-f4329deb59be
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:f7e7fb07-42f5-43d9-a6d1-f4329deb59be"}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.2.2.100":{"oid":"1.3.6.1.4.1.53148.1.2.2.100","name":"ORAN-E2SM-RC-PRE","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RCRanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[3]},"1.3.6.1.4.1.53148.1.2.2.101":{"oid":"1.3.6.1.4.1.53148.1.2.2.101","name":"ORAN-E2SM-MHO","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.MHORanFunction","reportStyles":[{"name":"PCI and NRT update for eNB","type":1}]}],"ranFunctionIDs":[5]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"Periodic Report","type":1,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.Sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.Sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.Sum"},{"id":"value:4","name":"RRC.ConnReEstabAtt.reconfigFail"},{"id":"value:5","name":"RRC.ConnReEstabAtt.HOFail"},{"id":"value:6","name":"RRC.ConnReEstabAtt.Other"},{"id":"value:7","name":"RRC.Conn.Avg"},{"id":"value:8","name":"RRC.Conn.Max"}]}]}],"ranFunctionIDs":[4]}}}

ID: e2:1/5153/1454c001
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:e8d1924d-8a87-3840-ada0-0cacbef26cc5
Aspects:
- onos.topo.E2Cell={"cellObjectId":"13842601454c001","cellGlobalId":{"value":"1454c001"},"kpiReports":{"RRC.Conn.Avg":1,"RRC.Conn.Max":1,"RRC.ConnEstabAtt.Sum":0,"RRC.ConnEstabSucc.Sum":0,"RRC.ConnReEstabAtt.HOFail":0,"RRC.ConnReEstabAtt.Other":0,"RRC.ConnReEstabAtt.Sum":0,"RRC.ConnReEstabAtt.reconfigFail":0}}

ID: a1:sd-ran-rimedo-ts-7fb74c65c-mbc9k
Kind ID: xapp
Labels: <None>
Source Id's:
Target Id's: uuid:039b05b5-5b33-72bf-4d93-bbc7178e4afc
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:039b05b5-5b33-72bf-4d93-bbc7178e4afc"}
- onos.topo.XAppInfo={"interfaces":[{"type":"INTERFACE_A1_XAPP","ip":"192.168.84.249","port":5150}],"a1PolicyTypes":[{"id":"ORAN_TrafficSteeringPreference_2.0.0","name":"ORAN_TrafficSteeringPreference","version":"2.0.0","description":"O-RAN traffic steering"}]}
```

Then, we can put the A1 policy JSON to the RIMEDO-TS xApp through onos-a1t.
In the `resources` directory, there is a `rimedots-sample-a1p.json` file which is a sample A1 policy file.
To use this file, we initially update the `IMSI` in this file.
We can check the IMSI with below command:

```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos ransim get ues
IMSI             Serving Cell     CRNTI      Admitted   RRC
9295552          13842601454c001  90125      false      RRCSTATUS_CONNECTED
```

In this example, IMSI is `9295552` but it is random value, which means that everytime the IMSI number is changed.
Once we get the IMSI, we should update IMSI to `rimedots-sample-a1p.json` file.
Note that the IMSI should have 16-digit value, so we should add 0 pads to the left side.
For example, if IMSI is `9295552`, the IMSI in json field should be `0000000009295552`:
```json
{
    "scope":{
       "ueId":"0000000009295552"
    },
    "tspResources":[
       {
          "cellIdList":[
             {
                "plmnId":{
                   "mcc":"138",
                   "mnc":"426"
                },
                "cId":{
                   "ncI":470106432
                }
             }
          ],
          "preference":"FORBID"
       }
    ]
 }
```

After that, we should push the JSON file to A1T with below command:
```bash
$ curl -X PUT -H "Content-Type: application/json" 128.105.144.101:31963/policytypes/ORAN_TrafficSteeringPreference_2.0.0/policies/1 -d @resources/rimedots-sample-a1p.json
{
  "scope": {
    "ueId": "0000000009295552"
  },
  "tspResources": [
    {
      "cellIdList": [
        {
          "cId": {
            "ncI": 470106432
          },
          "plmnId": {
            "mcc": "138",
            "mnc": "426"
          }
        }
      ],
      "preference": "FORBID"
    }
  ]
}
```

After pushing this json file, `make test-a1t` should show the policy object and status:
```bash
$ make test-a1t
...
*** Get A1T subscriptions through CLI ***
xApp ID                                              xApp A1 Interface                A1 Service                       A1 Service Type ID
a1:sd-ran-rimedo-ts-7fb74c65c-mbc9k                  192.168.84.249:5150              PolicyManagement                 ORAN_TrafficSteeringPreference_2.0.0
a1:sd-ran-rimedo-ts-7fb74c65c-mbc9k                  192.168.84.249:5150              EnrichmentInformation
*** Get A1T policy type through CLI ***
PolicyTypeID                                         List(PolicyObjectID)
ORAN_TrafficSteeringPreference_2.0.0                 [1]
*** Get A1T policy objects through CLI ***
PolicyTypeID                                         PolicyObjectID
ORAN_TrafficSteeringPreference_2.0.0                 1
*** Get A1T policy status through CLI ***
PolicyTypeID                                         PolicyObjectID                   Status
ORAN_TrafficSteeringPreference_2.0.0                 1                                {"enforceStatus":"ENFORCED"}
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
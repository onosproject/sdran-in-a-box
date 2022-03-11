<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Installation with CU-CP and OAI nFAPI emulator for KPIMON & RSM
This document covers how to install ONOS RIC services with CU-CP and OAI nFAPI emulator for KPIMON and RSM use-cases.
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
$ git checkout v1.3.0 # for release 1.3
$ git checkout v1.4.0 # for release 1.4
$ git checkout master # for master
```

## Deploy RiaB with OAI nFAPI emulator

### Command options
To deploy RiaB with OAI nFAPI emulator, we should go to `sdran-in-a-box` directory and command below:
```bash
$ cd /path/to/sdran-in-a-box
# type one of below commands
# for "master-stable" version (KPIMON and RSM)
$ make riab OPT=oai VER=stable # or just make riab OPT=oai
# for "latest" version (KPIMON and RSM)
$ make riab OPT=oai VER=latest #
# for a specific version
$ make riab OPT=oai VER=v1.0.0 # for release SD-RAN 1.0 (KPIMON only)
$ make riab OPT=oai VER=v1.1.0 # for release SD-RAN 1.1 (KPIMON only)
$ make riab OPT=oai VER=v1.1.1 # for release SD-RAN 1.1.1 (KPIMON only)
$ make riab OPT=oai VER=v1.2.0 # for release SD-RAN 1.2 (KPIMON only)
$ make riab OPT=oai VER=v1.3.0 # for release SD-RAN 1.3 (KPIMON and RSM)
$ make riab OPT=oai VER=v1.4.0 # for release SD-RAN 1.4 (KPIMON and RSM)
# for a "dev" version
$ make riab OPT=oai VER=dev # for dev (KPIMON and RSM)
```

Once we push one of above commands, the deployment procedure starts.

If we don't see any error or failure messages, everything is deployed.
```bash
$ kubectl get po --all-namespaces
NAMESPACE     NAME                                              READY   STATUS    RESTARTS   AGE
default       router                                            1/1     Running   0          9m25s
kube-system   atomix-controller-99f978c7d-jv8vv                 1/1     Running   0          8m35s
kube-system   atomix-raft-storage-controller-75979cfff8-npkw4   1/1     Running   0          8m10s
kube-system   calico-kube-controllers-584ddbb8fb-nxb7l          1/1     Running   0          5h8m
kube-system   calico-node-s5czk                                 1/1     Running   1          5h8m
kube-system   coredns-dff8fc7d-nznzf                            1/1     Running   0          5h7m
kube-system   dns-autoscaler-5d74bb9b8f-cfwvp                   1/1     Running   0          5h7m
kube-system   kube-apiserver-node1                              1/1     Running   0          5h9m
kube-system   kube-controller-manager-node1                     1/1     Running   0          5h9m
kube-system   kube-multus-ds-amd64-r42zf                        1/1     Running   0          5h8m
kube-system   kube-proxy-vp7k7                                  1/1     Running   1          5h9m
kube-system   kube-scheduler-node1                              1/1     Running   0          5h9m
kube-system   kubernetes-dashboard-667c4c65f8-cr6q5             1/1     Running   0          5h7m
kube-system   kubernetes-metrics-scraper-54fbb4d595-t8rgz       1/1     Running   0          5h7m
kube-system   nodelocaldns-rc6w7                                1/1     Running   0          5h7m
kube-system   onos-operator-app-d56cb6f55-9jbkt                 1/1     Running   0          7m53s
kube-system   onos-operator-config-7986b568b-9dznx              1/1     Running   0          7m53s
kube-system   onos-operator-topo-76fdf46db5-sbblb               1/1     Running   0          7m53s
riab          cassandra-0                                       1/1     Running   0          7m28s
riab          hss-0                                             1/1     Running   0          7m28s
riab          mme-0                                             4/4     Running   0          7m28s
riab          oai-enb-cu-0                                      1/1     Running   0          4m52s
riab          oai-enb-du-0                                      1/1     Running   0          3m41s
riab          oai-ue-0                                          1/1     Running   0          2m30s
riab          onos-a1t-84db77df99-mswp6                         2/2     Running   0          6m
riab          onos-cli-6b746874c8-96zxc                         1/1     Running   0          6m
riab          onos-config-7bd4b6f7f6-njdsj                      4/4     Running   0          6m
riab          onos-consensus-store-0                            1/1     Running   0          6m
riab          onos-e2t-58b4cd867-tkgcd                          3/3     Running   0          6m
riab          onos-kpimon-966bdf77f-5nn6t                       2/2     Running   0          6m
riab          onos-rsm-86df4894bd-clcsp                         2/2     Running   0          6m
riab          onos-topo-7cc9d754d7-2qjng                        3/3     Running   0          6m
riab          onos-uenib-779cb5dbd6-lprns                       3/3     Running   0          6m
riab          pcrf-0                                            1/1     Running   0          7m28s
riab          spgwc-0                                           2/2     Running   0          7m28s
riab          upf-0                                             4/4     Running   0          6m24s
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
Helm values.yaml file: /users/wkim/sdran-in-a-box//sdran-in-a-box-values-master-stable.yaml
HEAD is now at 9f79ab8 Fix the default SRIOV resource name for UPF user plane interfaces
HEAD is now at be1b9dd Fixing SM versions for E2T (#994)
*** Get KPIMON result through CLI ***
Node ID          Cell Object ID       Cell Global ID            Time    RRC.ConnEstabAtt.sum    RRC.ConnEstabSucc.sum    RRC.ConnMax    RRC.ConnMean    RRC.ConnReEstabAtt.sum
e2:4/e00/2/64                    1                e0000      03:39:24.0                       1                        1              1               1                         0
```

* `make test-e2-subscription`: to see e2 connection and subscription
```bash
$ make test-e2-subscription
Helm values.yaml file: /users/wkim/sdran-in-a-box//sdran-in-a-box-values-master-stable.yaml
HEAD is now at 9f79ab8 Fix the default SRIOV resource name for UPF user plane interfaces
HEAD is now at be1b9dd Fixing SM versions for E2T (#994)
*** Get E2 subscriptions through CLI ***
Subscription ID                                  Revision   Service Model ID   E2 NodeID       Encoding   Phase               State
43aa0af7ce9a05142e5235c7a8efbd9b:e2:4/e00/2/64   57         oran-e2sm-rsm:v1   e2:4/e00/2/64   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
9a8f85fa67a6ef913ef4c0fa8f8fdee4:e2:4/e00/2/64   62         oran-e2sm-kpm:v2   e2:4/e00/2/64   ASN1_PER   SUBSCRIPTION_OPEN   SUBSCRIPTION_COMPLETE
```

* `make test-rnib` and `make test-uenib`: to check information in R-NIB and UE-NIB
```bash
$ make test-rnib
...
*** Get R-NIB result through CLI ***
ID: e2:4/e00/3/c8
Kind ID: e2node
Labels: <None>
Source Id's:
Target Id's: uuid:2c192472-c952-462e-b33d-4b9d5b46ff3b
Aspects:
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.102":{"oid":"1.3.6.1.4.1.53148.1.1.2.102","name":"ORAN-E2SM-RSM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RSMRanFunction","ricSlicingNodeCapabilityList":[{"maxNumberOfSlicesDl":4,"maxNumberOfSlicesUl":4,"maxNumberOfUesPerSlice":4,"supportedConfig":[{},{"slicingConfigType":"E2_SM_RSM_COMMAND_SLICE_UPDATE"},{"slicingConfigType":"E2_SM_RSM_COMMAND_SLICE_DELETE"},{"slicingConfigType":"E2_SM_RSM_COMMAND_UE_ASSOCIATE"}]}]}],"ranFunctionIDs":[1]}}}
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:2c192472-c952-462e-b33d-4b9d5b46ff3b"}

ID: e2:4/e00/2/64/e0000
Kind ID: e2cell
Labels: <None>
Source Id's:
Target Id's: uuid:74c614b5-8666-67e9-d1a5-97d95ae83dcd
Aspects:
- onos.topo.E2Cell={"cellObjectId":"1","cellGlobalId":{"value":"e0000","type":"ECGI"},"kpiReports":{"RRC.ConnEstabAtt.sum":1,"RRC.ConnEstabSucc.sum":1,"RRC.ConnMax":1,"RRC.ConnMean":1,"RRC.ConnReEstabAtt.sum":0}}

ID: e2:onos-e2t-58b4cd867-tkgcd
Kind ID: e2t
Labels: <None>
Source Id's: uuid:ff39c175-c492-4831-b626-2ace5105a1c3, uuid:2c192472-c952-462e-b33d-4b9d5b46ff3b
Target Id's:
Aspects:
- onos.topo.E2TInfo={"interfaces":[{"type":"INTERFACE_E2AP200","ip":"192.168.84.169","port":36421},{"type":"INTERFACE_E2T","ip":"192.168.84.169","port":5150}]}
- onos.topo.Lease={"expiration":"2022-03-11T03:40:21.092928231Z"}

ID: a1:onos-a1t-84db77df99-mswp6
Kind ID: a1t
Labels: <None>
Source Id's:
Target Id's:
Aspects:
- onos.topo.A1TInfo={"interfaces":[{"type":"INTERFACE_A1AP","ip":"192.168.84.162","port":9639}]}

ID: gnmi:onos-config-7bd4b6f7f6-njdsj
Kind ID: onos-config
Labels: <None>
Source Id's:
Target Id's:
Aspects:
- onos.topo.Lease={"expiration":"2022-03-11T03:40:22.243649952Z"}

ID: e2:4/e00/2/64
Kind ID: e2node
Labels: <None>
Source Id's: uuid:74c614b5-8666-67e9-d1a5-97d95ae83dcd
Target Id's: uuid:ff39c175-c492-4831-b626-2ace5105a1c3
Aspects:
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.102":{"oid":"1.3.6.1.4.1.53148.1.1.2.102","name":"ORAN-E2SM-RSM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RSMRanFunction","ricSlicingNodeCapabilityList":[{"maxNumberOfSlicesDl":4,"maxNumberOfSlicesUl":4,"maxNumberOfUesPerSlice":4,"supportedConfig":[{"slicingConfigType":"E2_SM_RSM_COMMAND_EVENT_TRIGGERS"}]}]}],"ranFunctionIDs":[2]},"1.3.6.1.4.1.53148.1.2.2.2":{"oid":"1.3.6.1.4.1.53148.1.2.2.2","name":"ORAN-E2SM-KPM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.KPMRanFunction","reportStyles":[{"name":"O-CU-UP Measurement Container for the EPC connected deployment","type":6,"measurements":[{"id":"value:1","name":"RRC.ConnEstabAtt.sum"},{"id":"value:2","name":"RRC.ConnEstabSucc.sum"},{"id":"value:3","name":"RRC.ConnReEstabAtt.sum"},{"id":"value:4","name":"RRC.ConnMean"},{"id":"value:5","name":"RRC.ConnMax"}]}]}],"ranFunctionIDs":[1]}}}
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:ff39c175-c492-4831-b626-2ace5105a1c3"}
```

* Run `make test-kpimon` before and after phone detached: to check the number of active UEs changed
```bash
$ make test-kpimon
Helm values.yaml file: /users/wkim/sdran-in-a-box//sdran-in-a-box-values-master-stable.yaml
HEAD is now at 9f79ab8 Fix the default SRIOV resource name for UPF user plane interfaces
HEAD is now at be1b9dd Fixing SM versions for E2T (#994)
*** Get KPIMON result through CLI ***
Node ID          Cell Object ID       Cell Global ID            Time    RRC.ConnEstabAtt.sum    RRC.ConnEstabSucc.sum    RRC.ConnMax    RRC.ConnMean    RRC.ConnReEstabAtt.sum
e2:4/e00/2/64                    1                e0000      23:52:01.0                       1                        1              1               1                         0

$ make detach-ue
Helm values.yaml file: /users/wkim/sdran-in-a-box//sdran-in-a-box-values-master-stable.yaml
HEAD is now at 9f79ab8 Fix the default SRIOV resource name for UPF user plane interfaces
HEAD is now at be1b9dd Fixing SM versions for E2T (#994)
echo -en "AT+CPIN=0000\r" | nc -u -w 1 localhost 10000

OK
echo -en "AT+CGATT=0\r" | nc -u -w 1 localhost 10000

OK

$ make test-kpimon
Helm values.yaml file: /users/wkim/sdran-in-a-box//sdran-in-a-box-values-master-stable.yaml
HEAD is now at 9f79ab8 Fix the default SRIOV resource name for UPF user plane interfaces
HEAD is now at be1b9dd Fixing SM versions for E2T (#994)
*** Get KPIMON result through CLI ***
Node ID          Cell Object ID       Cell Global ID            Time    RRC.ConnEstabAtt.sum    RRC.ConnEstabSucc.sum    RRC.ConnMax    RRC.ConnMean    RRC.ConnReEstabAtt.sum
e2:4/e00/2/64                    1                e0000      23:52:13.0                       1                        1              1               0                         0
```

As we can see, `RRC.ConnMean` which shows the number of active UEs changed from 1 to 0, since a emulated UE is detached.

### The RSM E2E tests
If the following steps are all passed, RSM use-case is working fine.

* Step 1. Check the default slice performance
```bash
$ make test-rsm-dataplane
Helm values.yaml file: /users/wkim/sdran-in-a-box//sdran-in-a-box-values-master-stable.yaml
HEAD is now at 9f79ab8 Fix the default SRIOV resource name for UPF user plane interfaces
Previous HEAD position was e61a87a Update e2ap101 umbrella chart for release 1.3
HEAD is now at 0a2716d Releasing onos-rsm v0.1.9 (#992)
*** Test downlink traffic (UDP) ***
sudo apt install -y iperf3
Reading package lists... Done
Building dependency tree
Reading state information... Done
iperf3 is already the newest version (3.1.3-1).
The following package was automatically installed and is no longer required:
  ssl-cert
Use 'sudo apt autoremove' to remove it.
0 upgraded, 0 newly installed, 0 to remove and 173 not upgraded.
kubectl exec -it router -- apt install -y iperf3
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following extra packages will be installed:
  libiperf0
The following NEW packages will be installed:
  iperf3 libiperf0
0 upgraded, 2 newly installed, 0 to remove and 80 not upgraded.
Need to get 56.7 kB of archives.
After this operation, 236 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu/ trusty-backports/universe libiperf0 amd64 3.0.7-1~ubuntu14.04.1 [48.7 kB]
Get:2 http://archive.ubuntu.com/ubuntu/ trusty-backports/universe iperf3 amd64 3.0.7-1~ubuntu14.04.1 [7966 B]
Fetched 56.7 kB in 0s (114 kB/s)
Selecting previously unselected package libiperf0.
(Reading database ... 17318 files and directories currently installed.)
Preparing to unpack .../libiperf0_3.0.7-1~ubuntu14.04.1_amd64.deb ...
Unpacking libiperf0 (3.0.7-1~ubuntu14.04.1) ...
Selecting previously unselected package iperf3.
Preparing to unpack .../iperf3_3.0.7-1~ubuntu14.04.1_amd64.deb ...
Unpacking iperf3 (3.0.7-1~ubuntu14.04.1) ...
Setting up libiperf0 (3.0.7-1~ubuntu14.04.1) ...
Setting up iperf3 (3.0.7-1~ubuntu14.04.1) ...
Processing triggers for libc-bin (2.19-0ubuntu6.13) ...
iperf3 -s -B $(ip a show oaitun_ue1 | grep inet | grep -v inet6 | awk '{print $2}' | awk -F '/' '{print $1}') -p 5001 > /dev/null &
kubectl exec -it router -- iperf3 -u -c $(ip a show oaitun_ue1 | grep inet | grep -v inet6 | awk '{print $2}' | awk -F '/' '{print $1}') -p 5001 -b 20M -l 1450 -O 2 -t 12 --get-server-output
Connecting to host 172.250.255.254, port 5001
[  4] local 192.168.250.1 port 38444 connected to 172.250.255.254 port 5001
[ ID] Interval           Transfer     Bandwidth       Total Datagrams
[  4]   0.00-1.00   sec  2.15 MBytes  18.1 Mbits/sec  1557  (omitted)
[  4]   1.00-2.00   sec  2.38 MBytes  20.0 Mbits/sec  1722  (omitted)
[  4]   0.00-1.00   sec  2.17 MBytes  18.2 Mbits/sec  1567
[  4]   1.00-2.00   sec  2.38 MBytes  20.0 Mbits/sec  1721
[  4]   2.00-3.00   sec  2.37 MBytes  19.9 Mbits/sec  1715
[  4]   3.00-4.00   sec  2.39 MBytes  20.0 Mbits/sec  1725
[  4]   4.00-5.00   sec  2.39 MBytes  20.0 Mbits/sec  1726
[  4]   5.00-6.00   sec  2.38 MBytes  20.0 Mbits/sec  1721
[  4]   6.00-7.00   sec  2.39 MBytes  20.0 Mbits/sec  1728
[  4]   7.00-8.00   sec  2.39 MBytes  20.1 Mbits/sec  1729
[  4]   8.00-9.00   sec  2.38 MBytes  19.9 Mbits/sec  1718
[  4]   9.00-10.00  sec  2.38 MBytes  20.0 Mbits/sec  1722
[  4]  10.00-11.00  sec  2.39 MBytes  20.0 Mbits/sec  1728
[  4]  11.00-12.00  sec  2.38 MBytes  19.9 Mbits/sec  1719
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  4]   0.00-12.00  sec  28.4 MBytes  19.8 Mbits/sec  0.645 ms  2145/20507 (10%)
[  4] Sent 20507 datagrams

Server output:
Accepted connection from 192.168.250.1, port 53510
[  5] local 172.250.255.254 port 5001 connected to 192.168.250.1 port 38444
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-1.00   sec  1.76 MBytes  14.8 Mbits/sec  0.704 ms  7/1282 (0.55%)  (omitted)
[  5]   1.00-1.00   sec  2.10 MBytes  8.82 Mbits/sec  4.988 ms  0/3042 (0%)
[  5]   1.00-2.00   sec  2.10 MBytes  17.7 Mbits/sec  0.630 ms  18/1540 (1.2%)
[  5]   2.00-3.00   sec  2.10 MBytes  17.6 Mbits/sec  1.311 ms  242/1763 (14%)
[  5]   3.00-4.00   sec  2.10 MBytes  17.6 Mbits/sec  2.584 ms  187/1708 (11%)
[  5]   4.00-5.00   sec  2.10 MBytes  17.6 Mbits/sec  4.508 ms  192/1713 (11%)
[  5]   5.00-6.00   sec  2.10 MBytes  17.7 Mbits/sec  0.621 ms  189/1711 (11%)
[  5]   6.00-7.00   sec  2.10 MBytes  17.6 Mbits/sec  2.409 ms  228/1749 (13%)
[  5]   7.00-8.00   sec  2.10 MBytes  17.6 Mbits/sec  2.778 ms  202/1723 (12%)
[  5]   8.00-9.00   sec  2.10 MBytes  17.6 Mbits/sec  0.648 ms  181/1702 (11%)
[  5]   9.00-10.00  sec  2.10 MBytes  17.6 Mbits/sec  1.325 ms  245/1766 (14%)
[  5]  10.00-11.00  sec  2.10 MBytes  17.6 Mbits/sec  2.683 ms  183/1704 (11%)
[  5]  11.00-12.00  sec  2.10 MBytes  17.7 Mbits/sec  4.491 ms  192/1714 (11%)
[  5]  12.00-12.39  sec   835 KBytes  17.6 Mbits/sec  0.645 ms  79/669 (12%)
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-12.39  sec  0.00 Bytes  0.00 bits/sec  0.645 ms  2138/20983 (10%)


iperf Done.
pkill -9 -ef iperf3
iperf3 killed (pid 1707)
```
In this result, the performance is around 17.7 Mbps.

**NOTE: depending on the iPerf3 version, the last result line in ther server output is mostly 0. We should check the performance in each step.**

* Step 2. Create a slice
```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos rsm create slice --e2NodeID e2:4/e00/3/c8 --scheduler RR --sliceID 1 --weight 30 --sliceType DL
```

If there is no error message, we should check `onos-topo` result.
```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos topo get entity e2:4/e00/3/c8 -v

ID: e2:4/e00/3/c8
Kind ID: e2node
Labels: <None>
Source Id's:
Target Id's: uuid:6065c5aa-4351-446d-82b4-7702b991c365
Aspects:
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.102":{"oid":"1.3.6.1.4.1.53148.1.1.2.102","name":"ORAN-E2SM-RSM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RSMRanFunction","ricSlicingNodeCapabilityList":[{"maxNumberOfSlicesDl":4,"maxNumberOfSlicesUl":4,"maxNumberOfUesPerSlice":4,"supportedConfig":[{},{"slicingConfigType":"E2_SM_RSM_COMMAND_SLICE_UPDATE"},{"slicingConfigType":"E2_SM_RSM_COMMAND_SLICE_DELETE"},{"slicingConfigType":"E2_SM_RSM_COMMAND_UE_ASSOCIATE"}]}]}]}}}
- onos.topo.RSMSliceItemList={"rsmSliceList":[{"id":"1","sliceDesc":"Slice created by onos-RSM xAPP","sliceParameters":{"weight":30},"ueIdList":[]}]}
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:6065c5aa-4351-446d-82b4-7702b991c365"}
```

`RSMSliceItemList` should not be empty and have the correct values.

* Step 3. Associate a UE with the created slice
Before we run it, we should check the `DU-UE-F1AP-ID` in `onos-uenib` (in the below example, the ID is 49871).
```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos uenib get ues -v
ID: 455f5d5e-0f8e-4b8d-a857-c56e9bd455cb
Aspects:
- onos.uenib.RsmUeInfo={"globalUeId":"455f5d5e-0f8e-4b8d-a857-c56e9bd455cb","ueIdList":{"duUeF1apId":{"value":"49781"},"cuUeF1apId":{"value":"49781"},"ranUeNgapId":{},"enbUeS1apId":{"value":14951620},"amfUeNgapId":{}},"bearerIdList":[{"drbID":{"fourGDrbID":{"value":5,"qci":{"value":9}}}}],"cellGlobalId":"e_utra_cgi:{p_lmnidentity:{value:\"\\x02\\xf8\\x10\"} e_utracell_identity:{value:{value:\"\\x00\\xe0\\x00\\x00\" len:28}}}","cuE2NodeId":"e2:4/e00/2/64","duE2NodeId":"e2:4/e00/3/c8","sliceList":[]}

$ kubectl exec -it deployment/onos-cli -n riab -- onos rsm set association --dlSliceID 1 --e2NodeID e2:4/e00/3/c8 --drbID 5 --DuUeF1apID 49871
```

After association, we should check `onos-uenib` and `onos-topo`:
```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos topo get entity e2:4/e00/3/c8 -v

ID: e2:4/e00/3/c8
Kind ID: e2node
Labels: <None>
Source Id's:
Target Id's: uuid:6065c5aa-4351-446d-82b4-7702b991c365
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:6065c5aa-4351-446d-82b4-7702b991c365"}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.102":{"oid":"1.3.6.1.4.1.53148.1.1.2.102","name":"ORAN-E2SM-RSM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RSMRanFunction","ricSlicingNodeCapabilityList":[{"maxNumberOfSlicesDl":4,"maxNumberOfSlicesUl":4,"maxNumberOfUesPerSlice":4,"supportedConfig":[{},{"slicingConfigType":"E2_SM_RSM_COMMAND_SLICE_UPDATE"},{"slicingConfigType":"E2_SM_RSM_COMMAND_SLICE_DELETE"},{"slicingConfigType":"E2_SM_RSM_COMMAND_UE_ASSOCIATE"}]}]}]}}}
- onos.topo.RSMSliceItemList={"rsmSliceList":[{"id":"1","sliceDesc":"Slice created by onos-RSM xAPP","sliceParameters":{"weight":30},"ueIdList":[{"duUeF1apId":{"value":"49781"},"cuUeF1apId":{},"ranUeNgapId":{},"enbUeS1apId":{},"amfUeNgapId":{},"drbId":{"fourGDrbID":{"value":5,"qci":{"value":9}}}}]}]}

$ kubectl exec -it deployment/onos-cli -n riab -- onos uenib get ues -v
ID: 455f5d5e-0f8e-4b8d-a857-c56e9bd455cb
Aspects:
- onos.uenib.RsmUeInfo={"globalUeId":"455f5d5e-0f8e-4b8d-a857-c56e9bd455cb","ueIdList":{"duUeF1apId":{"value":"49781"},"cuUeF1apId":{"value":"49781"},"ranUeNgapId":{},"enbUeS1apId":{"value":14951620},"amfUeNgapId":{}},"bearerIdList":[{"drbID":{"fourGDrbID":{"value":5,"qci":{"value":9}}}}],"cellGlobalId":"e_utra_cgi:{p_lmnidentity:{value:\"\\x02\\xf8\\x10\"} e_utracell_identity:{value:{value:\"\\x00\\xe0\\x00\\x00\" len:28}}}","cuE2NodeId":"e2:4/e00/2/64","duE2NodeId":"e2:4/e00/3/c8","sliceList":[{"duE2NodeId":"e2:4/e00/3/c8","cuE2NodeId":"e2:4/e00/2/64","id":"1","sliceParameters":{"weight":30},"drbId":{"fourGDrbID":{"value":5,"qci":{"value":9}}}}]}
```

`ueIdList` in `onos-topo` and `sliceList` in `onos-uenib` should not be empty and have the correct values.

Then, check the created slice's performance:
```bash
$ make test-rsm-dataplane
Helm values.yaml file: /users/wkim/sdran-in-a-box//sdran-in-a-box-values-master-stable.yaml
HEAD is now at 9f79ab8 Fix the default SRIOV resource name for UPF user plane interfaces
HEAD is now at 0a2716d Releasing onos-rsm v0.1.9 (#992)
*** Test downlink traffic (UDP) ***
sudo apt install -y iperf3
Reading package lists... Done
Building dependency tree
Reading state information... Done
iperf3 is already the newest version (3.1.3-1).
The following package was automatically installed and is no longer required:
  ssl-cert
Use 'sudo apt autoremove' to remove it.
0 upgraded, 0 newly installed, 0 to remove and 173 not upgraded.
kubectl exec -it router -- apt install -y iperf3
Reading package lists... Done
Building dependency tree
Reading state information... Done
iperf3 is already the newest version.
0 upgraded, 0 newly installed, 0 to remove and 80 not upgraded.
iperf3 -s -B $(ip a show oaitun_ue1 | grep inet | grep -v inet6 | awk '{print $2}' | awk -F '/' '{print $1}') -p 5001 > /dev/null &
kubectl exec -it router -- iperf3 -u -c $(ip a show oaitun_ue1 | grep inet | grep -v inet6 | awk '{print $2}' | awk -F '/' '{print $1}') -p 5001 -b 20M -l 1450 -O 2 -t 12 --get-server-output
Connecting to host 172.250.255.254, port 5001
[  4] local 192.168.250.1 port 43898 connected to 172.250.255.254 port 5001
[ ID] Interval           Transfer     Bandwidth       Total Datagrams
[  4]   0.00-1.00   sec  2.15 MBytes  18.0 Mbits/sec  1554  (omitted)
[  4]   1.00-2.00   sec  2.39 MBytes  20.0 Mbits/sec  1725  (omitted)
[  4]   0.00-1.00   sec  2.15 MBytes  18.0 Mbits/sec  1556
[  4]   1.00-2.00   sec  2.38 MBytes  20.0 Mbits/sec  1722
[  4]   2.00-3.00   sec  2.38 MBytes  20.0 Mbits/sec  1724
[  4]   3.00-4.00   sec  2.39 MBytes  20.0 Mbits/sec  1725
[  4]   4.00-5.00   sec  2.39 MBytes  20.0 Mbits/sec  1725
[  4]   5.00-6.00   sec  2.39 MBytes  20.0 Mbits/sec  1726
[  4]   6.00-7.00   sec  2.38 MBytes  20.0 Mbits/sec  1721
[  4]   7.00-8.00   sec  2.39 MBytes  20.0 Mbits/sec  1728
[  4]   8.00-9.00   sec  2.38 MBytes  20.0 Mbits/sec  1720
[  4]   9.00-10.00  sec  2.38 MBytes  20.0 Mbits/sec  1724
[  4]  10.00-11.00  sec  2.39 MBytes  20.1 Mbits/sec  1729
[  4]  11.00-12.00  sec  2.38 MBytes  20.0 Mbits/sec  1720
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  4]   0.00-12.00  sec  28.4 MBytes  19.8 Mbits/sec  2.662 ms  16625/20395 (82%)
[  4] Sent 20395 datagrams

Server output:
Accepted connection from 192.168.250.1, port 35320
[  5] local 172.250.255.254 port 5001 connected to 192.168.250.1 port 43898
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-1.00   sec   556 KBytes  4.56 Mbits/sec  2.382 ms  0/393 (0%)  (omitted)
[  5]   1.00-2.00   sec   656 KBytes  5.37 Mbits/sec  6.754 ms  14/477 (2.9%)  (omitted)
[  5]   0.00-1.00   sec   656 KBytes  5.37 Mbits/sec  2.369 ms  1132/1595 (71%)
[  5]   1.00-2.00   sec   656 KBytes  5.37 Mbits/sec  4.023 ms  1232/1695 (73%)
[  5]   2.00-3.00   sec   656 KBytes  5.37 Mbits/sec  5.281 ms  1257/1720 (73%)
[  5]   3.00-4.00   sec   656 KBytes  5.37 Mbits/sec  7.395 ms  1253/1716 (73%)
[  5]   4.00-5.00   sec   656 KBytes  5.37 Mbits/sec  2.378 ms  1137/1600 (71%)
[  5]   5.00-6.00   sec   656 KBytes  5.37 Mbits/sec  4.079 ms  1398/1861 (75%)
[  5]   6.00-7.00   sec   656 KBytes  5.37 Mbits/sec  4.805 ms  1260/1723 (73%)
[  5]   7.00-8.00   sec   656 KBytes  5.37 Mbits/sec  7.416 ms  1250/1713 (73%)
[  5]   8.00-9.00   sec   656 KBytes  5.37 Mbits/sec  2.357 ms  1133/1596 (71%)
[  5]   9.00-10.00  sec   653 KBytes  5.34 Mbits/sec  5.348 ms  1401/1862 (75%)
[  5]  10.00-11.00  sec   658 KBytes  5.40 Mbits/sec  4.816 ms  1259/1724 (73%)
[  5]  11.00-12.00  sec   656 KBytes  5.37 Mbits/sec  7.384 ms  1251/1714 (73%)
[  5]  12.00-13.00  sec   656 KBytes  5.37 Mbits/sec  2.379 ms  1134/1597 (71%)
[  5]  13.00-13.38  sec   246 KBytes  5.33 Mbits/sec  2.662 ms  514/688 (75%)
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-13.38  sec  0.00 Bytes  0.00 bits/sec  2.662 ms  16611/22804 (73%)


iperf Done.
pkill -9 -ef iperf3
iperf3 killed (pid 9709)
```

The measured bandwidth is around 5.3 Mbps which is around 30% performance of the default slice.
Since we created the slice to have 30% weight, this performance is correct.

* Step 4. Update the UE's slice
Next, update the slice to have 50% weight:
```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos rsm update slice --e2NodeID e2:4/e00/3/c8 --scheduler RR --sliceID 1 --weight 50 --sliceType DL
```

After that, check `onos-topo` and `onos-uenib`:
```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos topo get entity e2:4/e00/3/c8 -v

ID: e2:4/e00/3/c8
Kind ID: e2node
Labels: <None>
Source Id's:
Target Id's: uuid:6065c5aa-4351-446d-82b4-7702b991c365
Aspects:
- onos.topo.RSMSliceItemList={"rsmSliceList":[{"id":"1","sliceDesc":"Slice created by onos-RSM xAPP","sliceParameters":{"weight":50},"ueIdList":[{"duUeF1apId":{"value":"49781"},"cuUeF1apId":{},"ranUeNgapId":{},"enbUeS1apId":{},"amfUeNgapId":{},"drbId":{"fourGDrbID":{"value":5,"qci":{"value":9}}}}]}]}
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:6065c5aa-4351-446d-82b4-7702b991c365"}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.102":{"oid":"1.3.6.1.4.1.53148.1.1.2.102","name":"ORAN-E2SM-RSM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RSMRanFunction","ricSlicingNodeCapabilityList":[{"maxNumberOfSlicesDl":4,"maxNumberOfSlicesUl":4,"maxNumberOfUesPerSlice":4,"supportedConfig":[{},{"slicingConfigType":"E2_SM_RSM_COMMAND_SLICE_UPDATE"},{"slicingConfigType":"E2_SM_RSM_COMMAND_SLICE_DELETE"},{"slicingConfigType":"E2_SM_RSM_COMMAND_UE_ASSOCIATE"}]}]}]}}}

$ kubectl exec -it deployment/onos-cli -n riab -- onos uenib get ues -v
ID: 455f5d5e-0f8e-4b8d-a857-c56e9bd455cb
Aspects:
- onos.uenib.RsmUeInfo={"globalUeId":"455f5d5e-0f8e-4b8d-a857-c56e9bd455cb","ueIdList":{"duUeF1apId":{"value":"49781"},"cuUeF1apId":{"value":"49781"},"ranUeNgapId":{},"enbUeS1apId":{"value":14951620},"amfUeNgapId":{}},"bearerIdList":[{"drbID":{"fourGDrbID":{"value":5,"qci":{"value":9}}}}],"cellGlobalId":"e_utra_cgi:{p_lmnidentity:{value:\"\\x02\\xf8\\x10\"} e_utracell_identity:{value:{value:\"\\x00\\xe0\\x00\\x00\" len:28}}}","cuE2NodeId":"e2:4/e00/2/64","duE2NodeId":"e2:4/e00/3/c8","sliceList":[{"duE2NodeId":"e2:4/e00/3/c8","cuE2NodeId":"e2:4/e00/2/64","id":"1","sliceParameters":{"weight":50},"drbId":{"fourGDrbID":{"value":5,"qci":{"value":9}}}}]}
```

`ueIdList` in `onos-topo` and `sliceList` in `onos-uenib` should have weight `50%`.

Then, check the updated slice's performance:
```bash
$ make test-rsm-dataplane
Helm values.yaml file: /users/wkim/sdran-in-a-box//sdran-in-a-box-values-master-stable.yaml
HEAD is now at 9f79ab8 Fix the default SRIOV resource name for UPF user plane interfaces
HEAD is now at 0a2716d Releasing onos-rsm v0.1.9 (#992)
*** Test downlink traffic (UDP) ***
sudo apt install -y iperf3
Reading package lists... Done
Building dependency tree
Reading state information... Done
iperf3 is already the newest version (3.1.3-1).
The following package was automatically installed and is no longer required:
  ssl-cert
Use 'sudo apt autoremove' to remove it.
0 upgraded, 0 newly installed, 0 to remove and 173 not upgraded.
kubectl exec -it router -- apt install -y iperf3
Reading package lists... Done
Building dependency tree
Reading state information... Done
iperf3 is already the newest version.
0 upgraded, 0 newly installed, 0 to remove and 80 not upgraded.
iperf3 -s -B $(ip a show oaitun_ue1 | grep inet | grep -v inet6 | awk '{print $2}' | awk -F '/' '{print $1}') -p 5001 > /dev/null &
kubectl exec -it router -- iperf3 -u -c $(ip a show oaitun_ue1 | grep inet | grep -v inet6 | awk '{print $2}' | awk -F '/' '{print $1}') -p 5001 -b 20M -l 1450 -O 2 -t 12 --get-server-output
Connecting to host 172.250.255.254, port 5001
[  4] local 192.168.250.1 port 48644 connected to 172.250.255.254 port 5001
[ ID] Interval           Transfer     Bandwidth       Total Datagrams
[  4]   0.00-1.00   sec  2.17 MBytes  18.2 Mbits/sec  1571  (omitted)
[  4]   1.00-2.00   sec  2.39 MBytes  20.0 Mbits/sec  1725  (omitted)
[  4]   0.00-1.00   sec  2.16 MBytes  18.1 Mbits/sec  1562  
[  4]   1.00-2.00   sec  2.38 MBytes  20.0 Mbits/sec  1721  
[  4]   2.00-3.00   sec  2.38 MBytes  20.0 Mbits/sec  1723  
[  4]   3.00-4.00   sec  2.39 MBytes  20.0 Mbits/sec  1727  
[  4]   4.00-5.00   sec  2.38 MBytes  20.0 Mbits/sec  1722  
[  4]   5.00-6.00   sec  2.41 MBytes  20.2 Mbits/sec  1740  
[  4]   6.00-7.00   sec  2.39 MBytes  20.0 Mbits/sec  1725  
[  4]   7.00-8.00   sec  2.37 MBytes  19.8 Mbits/sec  1711  
[  4]   8.00-9.00   sec  2.39 MBytes  20.0 Mbits/sec  1727  
[  4]   9.00-10.00  sec  2.38 MBytes  20.0 Mbits/sec  1720  
[  4]  10.00-11.00  sec  2.40 MBytes  20.1 Mbits/sec  1736  
[  4]  11.00-12.00  sec  2.37 MBytes  19.9 Mbits/sec  1717  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  4]   0.00-12.00  sec  28.4 MBytes  19.8 Mbits/sec  1.299 ms  12476/20503 (61%)  
[  4] Sent 20503 datagrams

Server output:
Accepted connection from 192.168.250.1, port 53640
[  5] local 172.250.255.254 port 5001 connected to 192.168.250.1 port 48644
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-1.00   sec   913 KBytes  7.48 Mbits/sec  1.459 ms  0/645 (0%)  (omitted)
[  5]   1.00-2.00   sec  1.07 MBytes  8.96 Mbits/sec  1.554 ms  390/1162 (34%)  (omitted)
[  5]   0.00-1.00   sec  1.07 MBytes  8.95 Mbits/sec  1.315 ms  840/1612 (52%)  
[  5]   1.00-2.00   sec  1.07 MBytes  8.95 Mbits/sec  1.406 ms  901/1673 (54%)  
[  5]   2.00-3.00   sec  1.07 MBytes  8.94 Mbits/sec  1.347 ms  963/1734 (56%)  
[  5]   3.00-4.00   sec  1.07 MBytes  8.94 Mbits/sec  1.771 ms  925/1696 (55%)  
[  5]   4.00-5.00   sec  1.07 MBytes  8.96 Mbits/sec  1.540 ms  963/1735 (56%)  
[  5]   5.00-6.00   sec  1.07 MBytes  8.96 Mbits/sec  1.536 ms  952/1724 (55%)  
[  5]   6.00-7.00   sec  1.07 MBytes  8.96 Mbits/sec  1.772 ms  951/1723 (55%)  
[  5]   7.00-8.00   sec  1.05 MBytes  8.83 Mbits/sec  1.607 ms  961/1722 (56%)  
[  5]   8.00-9.00   sec  1.08 MBytes  9.04 Mbits/sec  1.416 ms  972/1751 (56%)  
[  5]   9.00-10.00  sec  1.07 MBytes  8.96 Mbits/sec  1.548 ms  941/1713 (55%)  
[  5]  10.00-11.00  sec  1.07 MBytes  8.94 Mbits/sec  1.475 ms  958/1729 (55%)  
[  5]  11.00-12.00  sec  1.07 MBytes  8.96 Mbits/sec  1.396 ms  954/1726 (55%)  
[  5]  12.00-12.84  sec   919 KBytes  8.96 Mbits/sec  1.299 ms  805/1454 (55%)  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-12.84  sec  0.00 Bytes  0.00 bits/sec  1.299 ms  12086/21992 (55%) 

iperf Done.
pkill -9 -ef iperf3
iperf3 killed (pid 9709)
```

The measured bandwidth is around 8.96 Mbps which is around 50% performance of the default slice.
Since we updated the slice to have 50% weight, this performance is correct.

* Step 5. Switch the UE's slice
To switch the slice, we should create one more slice.
```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos rsm create slice --e2NodeID e2:4/e00/3/c8 --scheduler RR --sliceID 2 --weight 10 --sliceType DL
```

After that, check `onos-topo`:
```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos topo get entity e2:4/e00/3/c8 -v

ID: e2:4/e00/3/c8
Kind ID: e2node
Labels: <None>
Source Id's:
Target Id's: uuid:6065c5aa-4351-446d-82b4-7702b991c365
Aspects:
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:6065c5aa-4351-446d-82b4-7702b991c365"}
- onos.topo.RSMSliceItemList={"rsmSliceList":[{"id":"1","sliceDesc":"Slice created by onos-RSM xAPP","sliceParameters":{"weight":50},"ueIdList":[]},{"id":"2","sliceDesc":"Slice created by onos-RSM xAPP","sliceParameters":{"weight":10},"ueIdList":[{"duUeF1apId":{"value":"49781"},"cuUeF1apId":{},"ranUeNgapId":{},"enbUeS1apId":{},"amfUeNgapId":{},"drbId":{"fourGDrbID":{"value":5,"qci":{"value":9}}}}]}]}
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.102":{"oid":"1.3.6.1.4.1.53148.1.1.2.102","name":"ORAN-E2SM-RSM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RSMRanFunction","ricSlicingNodeCapabilityList":[{"maxNumberOfSlicesDl":4,"maxNumberOfSlicesUl":4,"maxNumberOfUesPerSlice":4,"supportedConfig":[{},{"slicingConfigType":"E2_SM_RSM_COMMAND_SLICE_UPDATE"},{"slicingConfigType":"E2_SM_RSM_COMMAND_SLICE_DELETE"},{"slicingConfigType":"E2_SM_RSM_COMMAND_UE_ASSOCIATE"}]}]}]}}}
```

`RSMSliceItemList` should have two slices - one has 50% weight and the other one has 10% weight.

Then, switch the slice from slice ID 1 to slice ID 2. (Before doing that, please double check the DU-UE-F1AP ID):
```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos rsm set association --dlSliceID 2 --e2NodeID e2:4/e00/3/c8 --drbID 5 --DuUeF1apID 49781
```

After that, check `onos-uenib`:
```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos uenib get ues -v
ID: 455f5d5e-0f8e-4b8d-a857-c56e9bd455cb
Aspects:
- onos.uenib.RsmUeInfo={"globalUeId":"455f5d5e-0f8e-4b8d-a857-c56e9bd455cb","ueIdList":{"duUeF1apId":{"value":"49781"},"cuUeF1apId":{"value":"49781"},"ranUeNgapId":{},"enbUeS1apId":{"value":14951620},"amfUeNgapId":{}},"bearerIdList":[{"drbID":{"fourGDrbID":{"value":5,"qci":{"value":9}}}}],"cellGlobalId":"e_utra_cgi:{p_lmnidentity:{value:\"\\x02\\xf8\\x10\"} e_utracell_identity:{value:{value:\"\\x00\\xe0\\x00\\x00\" len:28}}}","cuE2NodeId":"e2:4/e00/2/64","duE2NodeId":"e2:4/e00/3/c8","sliceList":[{"duE2NodeId":"e2:4/e00/3/c8","cuE2NodeId":"e2:4/e00/2/64","id":"2","sliceParameters":{"weight":10},"drbId":{"fourGDrbID":{"value":5,"qci":{"value":9}}}}]}
```

The slice ID should be `2` and weight should be `10`.

Then, check the updated slice's performance:
```bash
$ make test-rsm-dataplane
Helm values.yaml file: /users/wkim/sdran-in-a-box//sdran-in-a-box-values-master-stable.yaml
HEAD is now at 9f79ab8 Fix the default SRIOV resource name for UPF user plane interfaces
HEAD is now at 0a2716d Releasing onos-rsm v0.1.9 (#992)
*** Test downlink traffic (UDP) ***
sudo apt install -y iperf3
Reading package lists... Done
Building dependency tree
Reading state information... Done
iperf3 is already the newest version (3.1.3-1).
The following package was automatically installed and is no longer required:
  ssl-cert
Use 'sudo apt autoremove' to remove it.
0 upgraded, 0 newly installed, 0 to remove and 173 not upgraded.
kubectl exec -it router -- apt install -y iperf3
Reading package lists... Done
Building dependency tree
Reading state information... Done
iperf3 is already the newest version.
0 upgraded, 0 newly installed, 0 to remove and 80 not upgraded.
iperf3 -s -B $(ip a show oaitun_ue1 | grep inet | grep -v inet6 | awk '{print $2}' | awk -F '/' '{print $1}') -p 5001 > /dev/null &
kubectl exec -it router -- iperf3 -u -c $(ip a show oaitun_ue1 | grep inet | grep -v inet6 | awk '{print $2}' | awk -F '/' '{print $1}') -p 5001 -b 20M -l 1450 -O 2 -t 12 --get-server-output
Connecting to host 172.250.255.254, port 5001
[  4] local 192.168.250.1 port 60165 connected to 172.250.255.254 port 5001
[ ID] Interval           Transfer     Bandwidth       Total Datagrams
[  4]   0.00-1.00   sec  2.15 MBytes  18.0 Mbits/sec  1554  (omitted)
[  4]   1.00-2.00   sec  2.38 MBytes  20.0 Mbits/sec  1724  (omitted)
[  4]   0.00-1.00   sec  2.15 MBytes  18.0 Mbits/sec  1554
[  4]   1.00-2.00   sec  2.38 MBytes  20.0 Mbits/sec  1724
[  4]   2.00-3.00   sec  2.40 MBytes  20.1 Mbits/sec  1733
[  4]   3.00-4.00   sec  2.37 MBytes  19.9 Mbits/sec  1716
[  4]   4.00-5.00   sec  2.40 MBytes  20.1 Mbits/sec  1734
[  4]   5.00-6.00   sec  2.37 MBytes  19.9 Mbits/sec  1715
[  4]   6.00-7.00   sec  2.38 MBytes  20.0 Mbits/sec  1723
[  4]   7.00-8.00   sec  2.39 MBytes  20.0 Mbits/sec  1725
[  4]   8.00-9.00   sec  2.38 MBytes  20.0 Mbits/sec  1723
[  4]   9.00-10.00  sec  2.38 MBytes  20.0 Mbits/sec  1724
[  4]  10.00-11.00  sec  2.39 MBytes  20.0 Mbits/sec  1725
[  4]  11.00-12.00  sec  2.38 MBytes  20.0 Mbits/sec  1724
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  4]   0.00-12.00  sec  28.4 MBytes  19.8 Mbits/sec  8.400 ms  20849/20372 (1e+02%)
[  4] Sent 20372 datagrams

Server output:
Accepted connection from 192.168.250.1, port 55520
[  5] local 172.250.255.254 port 5001 connected to 192.168.250.1 port 60165
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-1.00   sec   188 KBytes  1.54 Mbits/sec  6.480 ms  0/133 (0%)  (omitted)
[  5]   1.00-1.00   sec   218 KBytes   893 Kbits/sec  6.346 ms  0/309 (0%)
[  5]   1.00-2.00   sec   218 KBytes  1.79 Mbits/sec  6.541 ms  0/154 (0%)
[  5]   2.00-3.00   sec   219 KBytes  1.80 Mbits/sec  7.384 ms  139/294 (47%)
[  5]   3.00-4.00   sec   218 KBytes  1.79 Mbits/sec  16.664 ms  1900/2054 (93%)
[  5]   4.00-5.00   sec   218 KBytes  1.79 Mbits/sec  10.540 ms  1229/1383 (89%)
[  5]   5.00-6.00   sec   219 KBytes  1.80 Mbits/sec  11.020 ms  1575/1730 (91%)
[  5]   6.00-7.00   sec   218 KBytes  1.79 Mbits/sec  8.349 ms  1404/1558 (90%)
[  5]   7.00-8.00   sec   218 KBytes  1.79 Mbits/sec  18.142 ms  1896/2050 (92%)
[  5]   8.00-9.00   sec   219 KBytes  1.80 Mbits/sec  10.674 ms  1403/1558 (90%)
[  5]   9.00-10.00  sec   218 KBytes  1.79 Mbits/sec  10.690 ms  1577/1731 (91%)
[  5]  10.00-11.00  sec   218 KBytes  1.79 Mbits/sec  8.359 ms  1403/1557 (90%)
[  5]  11.00-12.00  sec   219 KBytes  1.80 Mbits/sec  16.308 ms  1896/2051 (92%)
[  5]  12.00-13.00  sec   218 KBytes  1.79 Mbits/sec  10.457 ms  1404/1558 (90%)
[  5]  13.00-14.00  sec   218 KBytes  1.79 Mbits/sec  10.937 ms  1576/1730 (91%)
[  5]  14.00-15.00  sec   219 KBytes  1.80 Mbits/sec  8.334 ms  1403/1558 (90%)
[  5]  15.00-16.00  sec   218 KBytes  1.79 Mbits/sec  16.737 ms  1897/2051 (92%)
[  5]  16.00-16.29  sec  62.3 KBytes  1.76 Mbits/sec  8.400 ms  147/191 (77%)
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-16.29  sec  0.00 Bytes  0.00 bits/sec  8.400 ms  20849/23362 (89%)


iperf Done.
pkill -9 -ef iperf3
iperf3 killed (pid 3530)
```

The measured bandwidth is around 1.76 Mbps which is around 10% performance of the default slice.
Since we switched the slice to have 10% weight, this performance is correct.

* Step 6. Delete the UE's slice
Then, delete the slice 2 that is associated with the UE in order to check if the UE's slice is switched from the slice 2 to the default slice.
```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos rsm delete slice --e2NodeID e2:4/e00/3/c8 --sliceID 2 --sliceType DL
```

After that, check `onos-topo` and `onos-uenib`:
```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos topo get entity e2:4/e00/3/c8 -v

ID: e2:4/e00/3/c8
Kind ID: e2node
Labels: <None>
Source Id's:
Target Id's: uuid:6065c5aa-4351-446d-82b4-7702b991c365
Aspects:
- onos.topo.E2Node={"serviceModels":{"1.3.6.1.4.1.53148.1.1.2.102":{"oid":"1.3.6.1.4.1.53148.1.1.2.102","name":"ORAN-E2SM-RSM","ranFunctions":[{"@type":"type.googleapis.com/onos.topo.RSMRanFunction","ricSlicingNodeCapabilityList":[{"maxNumberOfSlicesDl":4,"maxNumberOfSlicesUl":4,"maxNumberOfUesPerSlice":4,"supportedConfig":[{},{"slicingConfigType":"E2_SM_RSM_COMMAND_SLICE_UPDATE"},{"slicingConfigType":"E2_SM_RSM_COMMAND_SLICE_DELETE"},{"slicingConfigType":"E2_SM_RSM_COMMAND_UE_ASSOCIATE"}]}]}]}}}
- onos.topo.RSMSliceItemList={"rsmSliceList":[{"id":"1","sliceDesc":"Slice created by onos-RSM xAPP","sliceParameters":{"weight":50},"ueIdList":[]}]}
- onos.topo.MastershipState={"term":"1","nodeId":"uuid:6065c5aa-4351-446d-82b4-7702b991c365"}

$ kubectl exec -it deployment/onos-cli -n riab -- onos uenib get ues -v
ID: 455f5d5e-0f8e-4b8d-a857-c56e9bd455cb
Aspects:
- onos.uenib.RsmUeInfo={"globalUeId":"455f5d5e-0f8e-4b8d-a857-c56e9bd455cb","ueIdList":{"duUeF1apId":{"value":"49781"},"cuUeF1apId":{"value":"49781"},"ranUeNgapId":{},"enbUeS1apId":{"value":14951620},"amfUeNgapId":{}},"bearerIdList":[{"drbID":{"fourGDrbID":{"value":5,"qci":{"value":9}}}}],"cellGlobalId":"e_utra_cgi:{p_lmnidentity:{value:\"\\x02\\xf8\\x10\"} e_utracell_identity:{value:{value:\"\\x00\\xe0\\x00\\x00\" len:28}}}","cuE2NodeId":"e2:4/e00/2/64","duE2NodeId":"e2:4/e00/3/c8","sliceList":[]}
```

`RSMSliceItemList` in `onos-topo` should have one slice item and `sliceList` in `onos-uenib` should be empty.

Then, check the UE's performance:
```bash
$ make test-rsm-dataplane
Helm values.yaml file: /users/wkim/sdran-in-a-box//sdran-in-a-box-values-master-stable.yaml
HEAD is now at 9f79ab8 Fix the default SRIOV resource name for UPF user plane interfaces
HEAD is now at 0a2716d Releasing onos-rsm v0.1.9 (#992)
*** Test downlink traffic (UDP) ***
sudo apt install -y iperf3
Reading package lists... Done
Building dependency tree
Reading state information... Done
iperf3 is already the newest version (3.1.3-1).
The following package was automatically installed and is no longer required:
  ssl-cert
Use 'sudo apt autoremove' to remove it.
0 upgraded, 0 newly installed, 0 to remove and 173 not upgraded.
kubectl exec -it router -- apt install -y iperf3
Reading package lists... Done
Building dependency tree
Reading state information... Done
iperf3 is already the newest version.
0 upgraded, 0 newly installed, 0 to remove and 80 not upgraded.
iperf3 -s -B $(ip a show oaitun_ue1 | grep inet | grep -v inet6 | awk '{print $2}' | awk -F '/' '{print $1}') -p 5001 > /dev/null &
kubectl exec -it router -- iperf3 -u -c $(ip a show oaitun_ue1 | grep inet | grep -v inet6 | awk '{print $2}' | awk -F '/' '{print $1}') -p 5001 -b 20M -l 1450 -O 2 -t 12 --get-server-output
Connecting to host 172.250.255.254, port 5001
[  4] local 192.168.250.1 port 41372 connected to 172.250.255.254 port 5001
[ ID] Interval           Transfer     Bandwidth       Total Datagrams
[  4]   0.00-1.00   sec  2.15 MBytes  18.0 Mbits/sec  1554  (omitted)
[  4]   1.00-2.00   sec  2.39 MBytes  20.0 Mbits/sec  1725  (omitted)
[  4]   0.00-1.00   sec  2.16 MBytes  18.1 Mbits/sec  1560
[  4]   1.00-2.00   sec  2.38 MBytes  20.0 Mbits/sec  1721
[  4]   2.00-3.00   sec  2.39 MBytes  20.0 Mbits/sec  1726
[  4]   3.00-4.00   sec  2.38 MBytes  20.0 Mbits/sec  1721
[  4]   4.00-5.00   sec  2.38 MBytes  20.0 Mbits/sec  1723
[  4]   5.00-6.00   sec  2.38 MBytes  20.0 Mbits/sec  1724
[  4]   6.00-7.00   sec  2.39 MBytes  20.0 Mbits/sec  1727
[  4]   7.00-8.00   sec  2.38 MBytes  20.0 Mbits/sec  1723
[  4]   8.00-9.00   sec  2.38 MBytes  20.0 Mbits/sec  1722
[  4]   9.00-10.00  sec  2.39 MBytes  20.0 Mbits/sec  1726
[  4]  10.00-11.00  sec  2.38 MBytes  20.0 Mbits/sec  1724
[  4]  11.00-12.00  sec  2.39 MBytes  20.0 Mbits/sec  1727
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  4]   0.00-12.00  sec  28.4 MBytes  19.8 Mbits/sec  0.669 ms  2135/20489 (10%)
[  4] Sent 20489 datagrams

Server output:
Accepted connection from 192.168.250.1, port 35326
[  5] local 172.250.255.254 port 5001 connected to 192.168.250.1 port 41372
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-1.00   sec  1.75 MBytes  14.7 Mbits/sec  0.810 ms  0/1265 (0%)  (omitted)
[  5]   1.00-2.00   sec  2.10 MBytes  17.6 Mbits/sec  2.008 ms  0/1521 (0%)  (omitted)
[  5]   0.00-1.00   sec  2.10 MBytes  17.6 Mbits/sec  0.641 ms  0/1521 (0%)
[  5]   1.00-2.00   sec  2.10 MBytes  17.6 Mbits/sec  0.657 ms  5/1526 (0.33%)
[  5]   2.00-3.00   sec  2.10 MBytes  17.6 Mbits/sec  0.656 ms  222/1743 (13%)
[  5]   3.00-4.00   sec  2.10 MBytes  17.7 Mbits/sec  2.946 ms  237/1759 (13%)
[  5]   4.00-5.00   sec  2.10 MBytes  17.6 Mbits/sec  3.615 ms  196/1717 (11%)
[  5]   5.00-6.00   sec  2.10 MBytes  17.6 Mbits/sec  6.710 ms  192/1713 (11%)
[  5]   6.00-7.00   sec  2.10 MBytes  17.6 Mbits/sec  0.656 ms  185/1706 (11%)
[  5]   7.00-8.00   sec  2.10 MBytes  17.7 Mbits/sec  3.232 ms  235/1757 (13%)
[  5]   8.00-9.00   sec  2.10 MBytes  17.6 Mbits/sec  6.728 ms  192/1713 (11%)
[  5]   9.00-10.00  sec  2.10 MBytes  17.6 Mbits/sec  0.650 ms  183/1704 (11%)
[  5]  10.00-11.00  sec  2.10 MBytes  17.6 Mbits/sec  3.110 ms  234/1755 (13%)
[  5]  11.00-12.00  sec  2.10 MBytes  17.7 Mbits/sec  3.484 ms  200/1722 (12%)
[  5]  12.00-12.39  sec   838 KBytes  17.6 Mbits/sec  0.669 ms  54/646 (8.4%)
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-12.39  sec  0.00 Bytes  0.00 bits/sec  0.669 ms  2135/20982 (10%)


iperf Done.
pkill -9 -ef iperf3
iperf3 killed (pid 19333)
```

The measured bandwidth is around 17.6 Mbps which is the same as the default slice performance measured at step 1.
Since the UE was switched from the slice 2 to the default slice due to the slice deletion, the performance is correct.

*Note: if we want to create UL slice, we should change `--dlSliceID` to `--ulSliceID` and `--sliceType DL` to `--sliceType UL`. All other commands are the same.*

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

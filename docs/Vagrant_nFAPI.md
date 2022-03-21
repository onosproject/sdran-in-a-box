<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Installation with CU-CP and OAI nFAPI emulator for KPIMON & RSM over Vagrant environment
This document covers how to install ONOS RIC services with CU-CP and OAI nFAPI emulator for KPIMON and RSM use-cases over the Vagrant environment. 
With this option, RiaB will deploy ONOS RIC services including ONOS-KPIMON (KPM 2.0 supported) and ONOS-RSM, together with CU-CP, OAI DU (nFAPI), and OAI UE (nFAPI).
Note that the Vagrant environment consists of three VMs on Linux Ubuntu 18.04 OS.

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

## Deploy RiaB with OAI nFAPI emulator over the Vagrant environment

### Set up the Vagrant environment
To set up the Vagrant environment, we should go to `sdran-in-a-box/vagrant` directory and command below:
```bash
Host $ cd /path/to/sdran-in-a-box/vagrant
Host $ ./setup.sh
```

Once we push the above command, the Vagrant setup procedure starts.
If we don't see any error or failure messages, all VMs are deployed.
The below command is for the verification:
```bash
$ sudo virsh list --all
 Id    Name                           State
----------------------------------------------------
 1     ran_ran                        running
 2     ric_ric                        running
 3     omec_omec                      running
```

### Config and run RIC VM
In order to config and run RIC VM, we should access the RIC VM.
After that, in the RIC VM, we should clone this repository.
```bash
Host $ cd /path/to/sdran-in-a-box/vagrant
Host $ ./vcmd.sh ric ssh
RIC $ git clone https://github.com/onosproject/sdran-in-a-box
```

Next, we should update `sdran-in-a-box/MakefileVar.mk` file.
```
...
S1MME_CU_INTERFACE      := eth1
...
ENB_SUBNET              := 192.168.11.8/29
ENB_GATEWAY             := 192.168.11.9/29
ACCESS_SUBNET           := 192.168.11.16/29
UPF_ACCESS_NET_IP       := 192.168.11.19/29
ACCESS_GATEWAY          := 192.168.11.17/29
CORE_SUBNET             := 192.168.11.0/29
UPF_CORE_NET_IP         := 192.168.11.3/29
CORE_GATEWAY            := 192.168.11.1/29
OAI_ENB_NET_IP          := 192.168.11.10/29
OAI_MACHINE_IP          := 192.168.13.21/16
OAI_ENB_NET_INTERFACE   := eth1
OMEC_ENB_NET_IP         := 192.168.11.12/29
OMEC_DEFAULT_INTERFACE  := eth1
OMEC_MACHINE_IP         := 192.168.10.21/29
RIC_MACHINE_IP          := 192.168.10.22/24
RIC_DEFAULT_IP          := eth1
```

Then, we should deploy RIC with one of below commands for the version we want:
```bash
RIC $ cd path/to/sdran-in-a-box
# type one of below commands
# for "master-stable" version
RIC $ make OPT=ric VER=stable
# for "latest" version
RIC $ make OPT=ric VER=latest
# for a specific version
RIC $ make OPT=ric VER=v1.0.0
RIC $ make OPT=ric VER=v1.1.0
RIC $ make OPT=ric VER=v1.1.1
RIC $ make OPT=ric VER=v1.2.0
RIC $ make OPT=ric VER=v1.3.0
RIC $ make OPT=ric VER=v1.4.0
# for a "dev" version
RIC $ make OPT=ric VER=dev
```

Once we push one of above commands, the deployment procedure starts.

If we don't see any error or failure messages, everything is deployed.
```bash
$ kubectl get po --all-namespaces
NAMESPACE     NAME                                              READY   STATUS    RESTARTS   AGE
kube-system   atomix-controller-99f978c7d-4t2xz                 1/1     Running   0          2d22h
kube-system   atomix-raft-storage-controller-75979cfff8-hgln4   1/1     Running   0          2d22h
kube-system   calico-kube-controllers-6b84489d67-ctxs4          1/1     Running   0          2d22h
kube-system   calico-node-78hmc                                 1/1     Running   1          2d22h
kube-system   coredns-dff8fc7d-bn7np                            1/1     Running   0          2d22h
kube-system   dns-autoscaler-5d74bb9b8f-w9x76                   1/1     Running   0          2d22h
kube-system   kube-apiserver-node1                              1/1     Running   0          2d22h
kube-system   kube-controller-manager-node1                     1/1     Running   0          2d22h
kube-system   kube-multus-ds-amd64-fdtvr                        1/1     Running   0          2d22h
kube-system   kube-proxy-cvhx7                                  1/1     Running   0          2d22h
kube-system   kube-scheduler-node1                              1/1     Running   0          2d22h
kube-system   kubernetes-dashboard-667c4c65f8-cspjh             1/1     Running   0          2d22h
kube-system   kubernetes-metrics-scraper-54fbb4d595-tvrvv       1/1     Running   0          2d22h
kube-system   nodelocaldns-hvnzp                                1/1     Running   0          2d22h
kube-system   onos-operator-app-676674b79c-4fjqr                1/1     Running   0          2d22h
kube-system   onos-operator-topo-7698956594-wr962               1/1     Running   0          2d22h
riab          onos-a1t-84db77df99-rj5fb                         2/2     Running   0          2d20h
riab          onos-cli-6b746874c8-qqz7n                         1/1     Running   0          2d20h
riab          onos-config-7bd4b6f7f6-zt74q                      4/4     Running   0          2d20h
riab          onos-consensus-store-0                            1/1     Running   0          2d20h
riab          onos-e2t-58b4cd867-mw65z                          3/3     Running   0          2d20h
riab          onos-kpimon-966bdf77f-xlbs6                       2/2     Running   0          2d20h
riab          onos-rsm-86df4894bd-cszdr                         2/2     Running   0          2d20h
riab          onos-topo-7cc9d754d7-kdrxm                        3/3     Running   0          2d20h
riab          onos-uenib-779cb5dbd6-8kwhr                       3/3     Running   0          2d20h
```

NOTE: If we see any issue when deploying RiaB, please check [Troubleshooting](./troubleshooting.md)

### Config and run OMEC VM
In the OMEC VM, we should initially clone this repository.
```bash
Host $ cd /path/to/sdran-in-a-box/vagrant
Host $ ./vcmd.sh omec ssh
OMEC $ git clone https://github.com/onosproject/sdran-in-a-box
```

Next, we should update `sdran-in-a-box/MakefileVar.mk` file.
```
...
S1MME_CU_INTERFACE      := eth1
...
ENB_SUBNET              := 192.168.11.8/29
ENB_GATEWAY             := 192.168.11.9/29
ACCESS_SUBNET           := 192.168.11.16/29
UPF_ACCESS_NET_IP       := 192.168.11.19/29
ACCESS_GATEWAY          := 192.168.11.17/29
CORE_SUBNET             := 192.168.11.0/29
UPF_CORE_NET_IP         := 192.168.11.3/29
CORE_GATEWAY            := 192.168.11.1/29
OAI_ENB_NET_IP          := 192.168.11.10/29
OAI_MACHINE_IP          := 192.168.13.21/16
OAI_ENB_NET_INTERFACE   := eth1
OMEC_ENB_NET_IP         := 192.168.11.12/29
OMEC_DEFAULT_INTERFACE  := eth1
OMEC_MACHINE_IP         := 192.168.10.21/29
RIC_MACHINE_IP          := 192.168.10.22/24
RIC_DEFAULT_IP          := eth1
```

Then, we should update UPF config in the `sdran-in-a-box-values-master-stable.yaml` file.
```yaml
config:
...
   upf:
     privileged: true
     enb:
       subnet: 192.168.11.8/29
     access:
       gateway: 192.168.11.17
       ip: 192.168.11.19/29
     core:
       gateway: 192.168.11.1
       ip: 192.168.11.3/29
...
```

After updating the above two files, we should deploy OMEC with the below command:
```bash
OMEC $ make omec
OMEC $ make routing-hw-omec
```

After deployment, we should see below results on OMEC VM.
```bash
OMEC $ kubectl get po --all-namespaces
NAMESPACE     NAME                                          READY   STATUS    RESTARTS   AGE
default       router                                        1/1     Running   0          2d23h
kube-system   calico-kube-controllers-59c5f46b69-f6srk      1/1     Running   0          2d23h
kube-system   calico-node-wl556                             1/1     Running   0          2d23h
kube-system   coredns-dff8fc7d-s7v6r                        1/1     Running   0          2d23h
kube-system   dns-autoscaler-5d74bb9b8f-r5wdx               1/1     Running   0          2d23h
kube-system   kube-apiserver-node1                          1/1     Running   0          2d23h
kube-system   kube-controller-manager-node1                 1/1     Running   0          2d23h
kube-system   kube-multus-ds-amd64-jcjl2                    1/1     Running   0          2d23h
kube-system   kube-proxy-g47md                              1/1     Running   0          2d23h
kube-system   kube-scheduler-node1                          1/1     Running   0          2d23h
kube-system   kubernetes-dashboard-667c4c65f8-86m6w         1/1     Running   0          2d23h
kube-system   kubernetes-metrics-scraper-54fbb4d595-dfksw   1/1     Running   0          2d23h
kube-system   nodelocaldns-s29k8                            1/1     Running   0          2d23h
riab          cassandra-0                                   1/1     Running   0          2d20h
riab          hss-0                                         1/1     Running   0          2d20h
riab          mme-0                                         4/4     Running   0          2d20h
riab          pcrf-0                                        1/1     Running   0          2d20h
riab          spgwc-0                                       2/2     Running   0          2d20h
riab          upf-0                                         4/4     Running   0          2d20h
```

### Config and run RAN VM
First, we should clone this repository in RAN VM.
```bash
Host $ cd /path/to/sdran-in-a-box/vagrant
Host $ ./vcmd.sh ran ssh
RAN $ git clone https://github.com/onosproject/sdran-in-a-box
```

Next, we should update `sdran-in-a-box/MakefileVar.mk` file.
```
...
S1MME_CU_INTERFACE      := eth1
...
E2T_NODEPORT_IPADDR     := 192.168.10.22/24
...
+ENB_SUBNET             := 192.168.11.8/29
+ENB_GATEWAY            := 192.168.11.9/29
+ACCESS_SUBNET          := 192.168.11.16/29
+UPF_ACCESS_NET_IP      := 192.168.11.19/29
+ACCESS_GATEWAY         := 192.168.11.17/29
+CORE_SUBNET            := 192.168.11.0/29
+UPF_CORE_NET_IP        := 192.168.11.3/29
+CORE_GATEWAY           := 192.168.11.1/29
+OAI_ENB_NET_IP         := 192.168.11.10/29
+OAI_MACHINE_IP         := 192.168.13.21/16
+OAI_ENB_NET_INTERFACE  := eth1
+OMEC_ENB_NET_IP        := 192.168.11.12/29
+OMEC_DEFAULT_INTERFACE := eth1
+OMEC_MACHINE_IP        := 192.168.10.21/29
+RIC_MACHINE_IP         := 192.168.10.22/24
+RIC_DEFAULT_IP         := eth1
```

Then, we should update `oai-enb-cu` Makefile target in `sdran-in-a-box/mk/ran.mk` file.
It is just deleting `$(M)/ric` dependency from `oai-enb-cu` target.
```
...
$(M)/oai-enb-cu: | version $(M)/helm-ready
...
```

After that, we should update `mme` and `oai-enb-cu` in `sdran-in-a-box/sdran-in-a-box-master-stable.yaml` file.
```yaml
config:
  mme:
    address: 192.168.10.21
...
  oai-enb-cu:
    networks:
...
      s1u:
        interface: eth1
...
```

After updating those three above files, we should do some network configurations.
First of all, we should get `onos-e2t` POD IP address.
`onos-e2t` POD IP address should be collected from `RIC` VM with below commands (not RAN VM):
```bash
Host $ cd /path/to/sdran-in-a-box/vagrant
Host $ ./vcmd.sh ric ssh
RIC $ kubectl get po -n riab -o wide | grep onos-e2t | awk '{print $6}'
<E2T_POD_IP>
```

Once we get `E2T_POD_IP`, we should add a routing rule.
And also, we should two dummy network interfaces in RAN VM (Not RIC VM):
```bash
Host $ cd /path/to/sdran-in-a-box/vagrant
Host $ ./vcmd.sh ran ssh
RAN $ git clone https://github.com/onosproject/sdran-in-a-box
RAN $ sudo ip l add cu_e2f1_if type dummy
RAN $ sudo ip l add du_e2f1_if type dummy
RAN $ sudo ifconfig cu_e2f1_if 192.168.200.21 up
RAN $ sudo ifconfig du_e2f1_if 192.168.200.22 up
RAN $ sudo route add -host <E2T_POD_IP> gw 192.168.10.22
```

After finishing the configuration, we should deploy RAN nFAPI emulator with below commands:
```bash
RAN $ make routing-hw-oai
RAN $ make oai
```

After deployment, we should see below outputs on RAN VM:
```bash
RAN $ kubectl get po --all-namespaces
NAMESPACE     NAME                                              READY   STATUS    RESTARTS   AGE
kube-system   atomix-controller-99f978c7d-ltfc7                 1/1     Running   0          2d22h
kube-system   atomix-raft-storage-controller-75979cfff8-jflp6   1/1     Running   0          2d22h
kube-system   calico-kube-controllers-6d9c99cc7c-p2vwv          1/1     Running   0          2d23h
kube-system   calico-node-p4qvj                                 1/1     Running   0          2d23h
kube-system   coredns-dff8fc7d-46szp                            1/1     Running   0          2d23h
kube-system   dns-autoscaler-5d74bb9b8f-86kkx                   1/1     Running   0          2d23h
kube-system   kube-apiserver-node1                              1/1     Running   0          2d23h
kube-system   kube-controller-manager-node1                     1/1     Running   0          2d23h
kube-system   kube-multus-ds-amd64-ds6rt                        1/1     Running   0          2d23h
kube-system   kube-proxy-sf8tx                                  1/1     Running   0          2d23h
kube-system   kube-scheduler-node1                              1/1     Running   0          2d23h
kube-system   kubernetes-dashboard-667c4c65f8-9xp2l             1/1     Running   0          2d23h
kube-system   kubernetes-metrics-scraper-54fbb4d595-vgdcm       1/1     Running   0          2d23h
kube-system   nodelocaldns-sn4x7                                1/1     Running   0          2d23h
riab          oai-enb-cu-0                                      1/1     Running   0          2d20h
riab          oai-enb-du-0                                      1/1     Running   0          2d20h
riab          oai-ue-0                                          1/1     Running   0          2d20

```

## End-to-End (E2E) tests for verification
For the E2E verification, we can use `ping` command on RAN VM:
```bash
$ ping 1.1.1.1 -I oaitun_ue1
PING 1.1.1.1 (1.1.1.1) from 172.250.255.252 oaitun_ue1: 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=53 time=36.2 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=53 time=29.0 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=53 time=28.0 ms
64 bytes from 1.1.1.1: icmp_seq=4 ttl=53 time=39.9 ms
64 bytes from 1.1.1.1: icmp_seq=5 ttl=53 time=35.0 ms
...
```

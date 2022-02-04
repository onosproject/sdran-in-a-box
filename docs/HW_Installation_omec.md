<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Install OMEC

This section explains how to install the EPC OMEC components using RiaB in the EPC-OMEC machine.

## Start the RiaB EPC-OMEC components

After changing the file `sdran-in-a-box-values.yaml`, run the following commands:

```bash
$ cd /path/to/sdran-in-a-box
$ sudo apt install build-essential
$ make omec
```

## Verify whether everything is up and running
After a while, RiaB Makefile completes to install K8s and deploy OMEC CP, OMEC UP, and an internal router.
Once it is done, you can check with the below command in the EPC-OMEC machine.
```bash
$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                          READY   STATUS    RESTARTS   AGE
default       router                                        1/1     Running   0          19h
kube-system   calico-kube-controllers-865c7978b5-k6f62      1/1     Running   0          19h
kube-system   calico-node-bldr4                             1/1     Running   0          19h
kube-system   coredns-dff8fc7d-hqfcn                        1/1     Running   0          19h
kube-system   dns-autoscaler-5d74bb9b8f-5w2j4               1/1     Running   0          19h
kube-system   kube-apiserver-node1                          1/1     Running   0          19h
kube-system   kube-controller-manager-node1                 1/1     Running   0          19h
kube-system   kube-multus-ds-amd64-jzvzr                    1/1     Running   0          19h
kube-system   kube-proxy-wclnq                              1/1     Running   0          19h
kube-system   kube-scheduler-node1                          1/1     Running   0          19h
kube-system   kubernetes-dashboard-667c4c65f8-bqkgl         1/1     Running   0          19h
kube-system   kubernetes-metrics-scraper-54fbb4d595-7kjss   1/1     Running   0          19h
kube-system   nodelocaldns-p6j8m                            1/1     Running   0          19h
omec          cassandra-0                                   1/1     Running   0          113m
omec          hss-0                                         1/1     Running   0          113m
omec          mme-0                                         4/4     Running   0          113m
omec          pcrf-0                                        1/1     Running   0          113m
omec          spgwc-0                                       2/2     Running   0          113m
omec          upf-0                                         4/4     Running   0          112m
```
If you can see the router and all OMEC PODs are running, then everything is good to go.

## Network parameter configuration

We should then configure the network parameters (e.g., routing rules, MTU size, and packet fregmentation) on EPC-OMEC so it can reach out to OAI-CU/DU machine.

```
$ cd /path/to/sdran-in-a-box
$ make routing-hw-omec
```

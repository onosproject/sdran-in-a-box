<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Install the ONOS-RIC

This section explains how to install the RIC components using RiaB in the ONOS-RIC machine.

## Start the RiaB ONOS-RIC components

```bash
$ cd /path/to/sdran-in-a-box
$ sudo apt install build-essential
$ make riab OPT=ric
```

*Note: If we want to deploy a specific RIC version, we should add `VER=VERSION` argument; VERSION should be one of {v1.0.0, v1.1.0, v1.2.0, latest, stable}.*

## Verify whether everything is up and running
After a while, RiaB Makefile completes to install K8s and deploy ONOS-RIC components.
Once it is done, you can check with the below command in the ONOS-RIC machine.

```bash
NAMESPACE     NAME                                                     READY   STATUS             RESTARTS   AGE
default       router                                                   1/1     Running            0          16m
kube-system   atomix-controller-6b6d96775-bc8s4                        1/1     Running            0          15m
kube-system   atomix-raft-storage-controller-77bd965f8d-785gz          1/1     Running            0          15m
kube-system   calico-kube-controllers-6759976d49-zkvjt                 1/1     Running            0          3d7h
kube-system   calico-node-n22vw                                        1/1     Running            0          3d7h
kube-system   coredns-dff8fc7d-b8lvl                                   1/1     Running            52         3d7h
kube-system   dns-autoscaler-5d74bb9b8f-5948j                          1/1     Running            0          3d7h
kube-system   kube-apiserver-node1                                     1/1     Running            64         3d7h
kube-system   kube-controller-manager-node1                            1/1     Running            64         3d7h
kube-system   kube-multus-ds-amd64-wg99f                               1/1     Running            0          3d7h
kube-system   kube-proxy-cvxz2                                         1/1     Running            1          3d7h
kube-system   kube-scheduler-node1                                     1/1     Running            62         3d7h
kube-system   kubernetes-dashboard-667c4c65f8-5kdcp                    1/1     Running            97         3d7h
kube-system   kubernetes-metrics-scraper-54fbb4d595-slnlv              1/1     Running            63         3d7h
kube-system   nodelocaldns-55nr9                                       1/1     Running            53         3d7h
kube-system   onos-operator-app-d56cb6f55-bbqbp                        1/1     Running            0          10m
kube-system   onos-operator-config-7986b568b-vj8tj                     1/1     Running            0          10m
kube-system   onos-operator-topo-76fdf46db5-56rh9                      1/1     Running            0          10m
prometheus    alertmanager-prometheus-prometheus-oper-alertmanager-0   2/2     Running            46         3d4h
prometheus    prometheus-grafana-d6545c767-pjchc                       2/2     Running            40         3d4h
prometheus    prometheus-kube-state-metrics-c65b87574-w92hj            1/1     Running            98         3d4h
prometheus    prometheus-prometheus-node-exporter-khqbv                1/1     Running            84         3d4h
prometheus    prometheus-prometheus-oper-operator-5ff8fbd5fb-6dm4g     2/2     Running            0          3d4h
prometheus    prometheus-prometheus-prometheus-oper-prometheus-0       3/3     Running            38         3d4h
riab          onos-cli-9f75bc57c-vf4mr                                 1/1     Running            0          7m44s
riab          onos-config-5d7cd9dd8c-ml8fk                             4/4     Running            0          7m44s
riab          onos-consensus-store-0                                   1/1     Running            0          7m44s
riab          onos-e2t-65cddb59cc-jztrn                                3/3     Running            0          7m44s
riab          onos-kpimon-6bdff5875c-gng64                             2/2     Running            0          7m44s
riab          onos-rsm-59f79876ff-qhmpm                                2/2     Running            0          7m44s
riab          onos-topo-775f5f946f-t29b2                               3/3     Running            0          7m44s
riab          onos-uenib-5b6445d58f-qljqp                              3/3     Running            0          7m44s
```

**Note: RIC does not have a fixed IP address by which oai-enb-cu (or another eNB) can communicate with it. The onos-e2t component exposes a service in port 36421, which is associated with the IP address of the eno1 interface (i.e., the default gateway interface) where it is running. To check that IP address run the command "kubectl -n riab get svc". In the output of this command, one of the lines should show something similar to "onos-e2t-external        NodePort    x.y.w.z   <none>        36421:36421/SCTP             0m40s". The IP address "x.y.w.z" shown in the output of the previous command (listed in the onos-e2t-external service) is the one that is accessible from the outside of the RIC VM, i.e., by the oai-enb-cu in case of this tutorial. In a test case with another eNB, that should be the IP address to be configured in the eNB so it can communicate with onos RIC.**


## Routing
If RIC is running outside the OAI-CU/DU machine, run below command:
```bash
$ make routing-ric-external-ran
```

If there are multiple machines, we should manually add routing rules like:
```bash
$ sudo route add -host <CU IP address described in CU config file> gw <CU machine IP address> dev <RIC VM network interface name>
$ sudo route add -host <DU IP address described in DU config file> gw <DU machine IP address> dev <RIC VM network interface name>
```
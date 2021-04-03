# Install OMEC

This section explains how to install the EPC OMEC components using RiaB in the EPC-OMEC machine.

## Change the target /fabric in the Makefile

In the cloned RiaB repository at the EPC-OMEC machine, edit the Makefile target to look like the following lines below.

*Note: The IP addresses prefix (i.e., 192.168.x.z) correspond to the prefix assigned to the same subnet where the whole setup is defined. In a custom setup, make sure these IP addresses subnet match too.*

```bash
$(M)/fabric: | $(M)/setup /opt/cni/bin/simpleovs /opt/cni/bin/static
	sudo apt install -y openvswitch-switch
	sudo ovs-vsctl --may-exist add-br br-enb-net
	sudo ovs-vsctl --may-exist add-port br-enb-net enb -- set Interface enb type=internal
	sudo ip addr add 192.168.11.12/29 dev enb || true
	sudo ip link set enb up
	sudo ethtool --offload enb tx off
	sudo ip route replace 192.168.11.16/29 via 192.168.11.9 dev enb
	kubectl apply -f $(RESOURCEDIR)/router.yaml
	kubectl wait pod -n default --for=condition=Ready -l app=router --timeout=300s
	kubectl -n default exec router ip route add $(UE_IP_POOL)/$(UE_IP_MASK) via 192.168.11.10
	kubectl delete net-attach-def core-net
	touch $@
```

**These IP addresses are assigned to OMEC because they must be reachable by the NUC-OAI-CU/DU machine, so the oai-enb-cu component can communicate with the omec-mme component. More details about custom settings are explained in the [Custom Settings](#network-routes-and-ip-addresses).**


## Change the router networks

In the cloned RiaB repository at the EPC-OMEC machine, edit the file located at path-to/sdran-in-a-box/resources/router.yaml, so the router Pod have its networks annotations to look like the lines below:

*Note: The IP addresses prefix (i.e., 192.168.x.z) correspond to the prefix assigned to the same subnet where the whole setup is defined. In a custom setup, make sure these IP addresses subnet match too.*

```text
…
apiVersion: v1
kind: Pod
metadata:
  name: router
  labels:
    app: router
  annotations:
    k8s.v1.cni.cncf.io/networks: '[
            { "name": "core-net", "interface": "core-rtr", "ips": ["192.168.11.1/29"] },
            { "name": "enb-net", "interface": "enb-rtr", "ips": ["192.168.11.9/29"] },
            { "name": "access-net", "interface": "access-rtr", "ips": ["192.168.11.17/29"] }
    ]'
…
```

**These IP addresses are assigned to a router pod in the OMEC VM, making possible the UPF component of OMEC can communicate with the enb and core networks. More details about custom settings are explained in the [Custom Settings](#network-routes-and-ip-addresses).**


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

### Install some network tools
```bash
$ sudo apt install net-tools ethtool
```

*NOTE: Normally, those tools are already installed. If not, we can command it.*

### Configuration in EPC-OMEC machine
First, we should go to the EPC-OMEC machine.

We should add a single routing rule and disable TCP TX/RX checksum and Generic Receive Offloading (GRO) configuration.
```bash
$ ROUTER_IP=$(kubectl exec -it router -- ifconfig eth0 | grep inet | awk '{print $2}' | awk -F ':' '{print $2}')
$ ROUTER_IF=$(route -n | grep $ROUTER_IP  | awk '{print $NF}')
$ sudo ethtool -K $ROUTER_IF gro off rx off
$ sudo ethtool -K eno1 rx off tx on gro off gso on  #Notice here, this is the primary interface of the EPC-OMEC machine
$ sudo ethtool -K enb rx off tx on gro off gso on
$ sudo route add -host 192.168.11.10 gw 192.168.13.21 dev eno1 #Defines the route to OAI-CU/DU secondary IP address

```

### Configuration in EPC-OMEC internal router
Second, we should configure network parameters in the EPC-OMEC internal router.
In order to access the EPC-OMEC internal router, go to the EPC-OMEC machine and command below:

```bash
$ kubectl exec -it router -- bash
```

On the router prompt, we initially add a routing rule and MTU size.
Then, we should disable TX/RX checksum and GRO for all network interfaces in the router.

```bash
$ # Add routing rule
$ route add -host 192.168.11.10 gw 192.168.11.12 dev enb-rtr  #Defines the route to OAI-CU/DU machine (secondary IP address) via the enb interface (attached to br-enb-rtr bridge)

$ # Change MTU size
$ ifconfig core-rtr mtu 1550
$ ifconfig access-rtr mtu 1550

$ # Disable checksum and GRO
$ apt update; apt install ethtool
$ ethtool -K eth0 tx off rx off gro off gso off
$ ethtool -K enb-rtr tx off rx off gro off gso off
$ ethtool -K access-rtr tx off rx off gro off gso off
$ ethtool -K core-rtr tx off rx off gro off gso off
```

### Configuration in UPF
Next, we should go to the UPF running in the RiaB NUC machine:
```bash
$ kubectl exec -it upf-0 -n riab -- bash
```

On the UPF prompt, we should change the MTU size.
```bash
$ ip l set mtu 1550 dev access
$ ip l set mtu 1550 dev core
```
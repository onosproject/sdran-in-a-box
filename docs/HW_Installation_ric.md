# Install the ONOS-RIC

This section explains how to install the RIC components using RiaB in the ONOS-RIC machine.

## Start the RiaB ONOS-RIC components

```bash
$ cd /path/to/sdran-in-a-box
$ sudo apt install build-essential
$ make ric-oai-latest
```

## Verify whether everything is up and running
After a while, RiaB Makefile completes to install K8s and deploy ONOS-RIC components.
Once it is done, you can check with the below command in the ONOS-RIC machine.

```bash
NAMESPACE     NAME                                          READY   STATUS     RESTARTS   AGE
kube-system   atomix-controller-694586d498-6jfll            1/1     Running    0          12m
kube-system   cache-storage-controller-5996c8fd45-5pvl4     1/1     Running    0          12m
kube-system   calico-kube-controllers-7597dc5bf7-z9czz      1/1     Running    0          14m
kube-system   calico-node-sd55n                             1/1     Running    0          14m
kube-system   config-operator-69f7498fb5-6lcjw              1/1     Running    0          11m
kube-system   coredns-dff8fc7d-mskrc                        1/1     Running    0          14m
kube-system   dns-autoscaler-5d74bb9b8f-ql9rq               1/1     Running    0          14m
kube-system   kube-apiserver-node1                          1/1     Running    0          13m
kube-system   kube-controller-manager-node1                 1/1     Running    0          13m
kube-system   kube-multus-ds-amd64-qrbcl                    1/1     Running    0          14m
kube-system   kube-proxy-d8tgv                              1/1     Running    0          14m
kube-system   kube-scheduler-node1                          1/1     Running    0          13m
kube-system   kubernetes-dashboard-667c4c65f8-jdm86         1/1     Running    0          14m
kube-system   kubernetes-metrics-scraper-54fbb4d595-8r98c   1/1     Running    0          14m
kube-system   nodelocaldns-k5p82                            1/1     Running    0          14m
kube-system   raft-storage-controller-7755865dcd-z68ws      1/1     Running    0          12m
kube-system   topo-operator-558f4545bd-n8pbn                1/1     Running    0          11m
riab          onos-cli-6655c68cb4-dzg5m                     1/1     Running    0          10m
riab          onos-config-59884c6766-kgdwd                  2/2     Running    0          10m
riab          onos-consensus-db-1-0                         1/1     Running    0          10m
riab          onos-e2sub-7588dcbc7b-tvpkz                   1/1     Running    0          10m
riab          onos-e2t-56549f6648-bbzxz                     1/1     Running    0          10m
riab          onos-kpimon-v2-846f556cfb-nd9fs               1/1     Running    0          10m
riab          onos-pci-85f465c9cf-gfkp2                     1/1     Running    0          10m
riab          onos-topo-5df4cf454c-8lrcf                    1/1     Running    0          10m
```

**Note: RIC does not have a fixed IP address by which oai-enb-cu (or another eNB) can communicate with it. The onos-e2t component exposes a service in port 36421, which is associated with the IP address of the eno1 interface (i.e., the default gateway interface) where it is running. To check that IP address run the command "kubectl -n riab get svc". In the output of this command, one of the lines should show something similar to "onos-e2t-external        NodePort    x.y.w.z   <none>        36421:36421/SCTP             0m40s". The IP address "x.y.w.z" shown in the output of the previous command (listed in the onos-e2t-external service) is the one that is accessible from the outside of the RIC VM, i.e., by the oai-enb-cu in case of this tutorial. In a test case with another eNB, that should be the IP address to be configured in the eNB so it can communicate with onos RIC.**
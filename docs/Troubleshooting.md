<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Troubleshooting
This section covers how to solve the reported issues. This section will be updated, continuously.

## Helm charts are out-of-date
If we want to update Helm chart up-to-date, we can fetch all charts to `~/helm-charts/aether-helm-charts` and  `~/helm-charts/sdran-helm-charts` directories.
For the development perspective, sometimes we need to fetch the latest Helm chart commits, although the RiaB uses a specific chart version. This command fetches all latest commits:
```bash
$ make fetch-all-charts
```
It just fetches the all latest commits, i.e., it does not change/checkout the specific branch/commit.

NOTE: It may request credentials for the OpenCORD gerrit and SD-RAN Github.

## SPGW-C or UPF is not working
Please check the log with below commands:
```bash
$ kubectl logs spgwc-0 -n riab -c spgwc # for SPGW-C log
$ kubectl logs upf-0 -n riab -c bess # for UPF log
```

In the log, if we can see `unsupported CPU type` or `a specific flag (e.g., AES) is missing`, we should check the CPU microarchitecture. RiaB requires Intel Haswell or more recent CPU microarchitecture.
If we have the appropriate CPU type, we should build SPGW-C or UPF image on the machine where RiaB will run.

To build SPGW-C, first clone the SPGW-C repository on the machine with `git clone https://github.com/omec-project/spgw`. Then, edit below line in Makefile:
```makefile
DOCKER_BUILD_ARGS        ?= --build-arg RTE_MACHINE='native'
```
Then, run `make` on the `spgw` directory.

Likewise, for building UPF image, we should clone UPF repository with `git clone https://github.com/omec-project/upf-epc`. Then, edit below line in Makefile:
```makefile
CPU                      ?= native
```
Then, run `make` on the `upf-epc` directory.

After building those images, we should modify overriding value yaml file (i.e., `sdran-in-a-box-values.yaml`). Go to the file and write down below:
```yaml
images:
  tags:
    spgwc: <spgwc_image_tag>
    bess: <bess_upf_image_tag>
    pfcpiface: <pfcpiface_upf_image_tab>
  pullPolicy: IfNotPresent
```
Then, run below commands:
```bash
$ cd /path/to/sdran-in-a-box
$ make reset-test
# after all OMEC pods are deleted, run make again
$ make
```

## ETCD is not working
Sometimes, we see the below outputs when building RiaB.
```text
TASK [etcd : Configure | Ensure etcd is running] ***********************************************************************
FAILED - RETRYING: Configure | Check if etcd cluster is healthy (4 retries left).
FAILED - RETRYING: Configure | Check if etcd cluster is healthy (3 retries left).
FAILED - RETRYING: Configure | Check if etcd cluster is healthy (2 retries left).
FAILED - RETRYING: Configure | Check if etcd cluster is healthy (1 retries left).
```

If we see this, we can command below:
```bash
$ sudo systemctl restart docker
$ cd /path/to/sdran-in-a-box
$ make
```

## Pod onos-consensus-db-1-0 initialization failed

In Ubuntu 20.04 (kernel 5.4.0-65-generic), the k8s pod named `onos-consensus-db-1-0` might fail due to a bug of using go and alpine together (e.g., https://github.com/docker-library/golang/issues/320).

It can be seen in `kubectl logs -n riab onos-consensus-db-1-0` as:
```bash
runtime: mlock of signal stack failed: 12
runtime: increase the mlock limit (ulimit -l) or
runtime: update your kernel to 5.3.15+, 5.4.2+, or 5.5+
fatal error: mlock failed
```

Such pod utilizes the docker image atomix/raft-storage-node:v0.5.3, tagged from the build of the image atomix/dragonboat-raft-storage-node:latest available at https://github.com/atomix/dragonboat-raft-storage-node.

A quick fix (allowing an unlimited amount memory to be locked by the pod) to this issue is cloning the repository https://github.com/atomix/dragonboat-raft-storage-node, and changing the Makefile:

```bash
# Before change
image: build
	docker build . -f build/dragonboat-raft-storage-node/Dockerfile -t atomix/dragonboat-raft-storage-node:${RAFT_STORAGE_NODE_VERSION}

# After change: unlimited maximum locked-in-memory address space
image: build
	docker build --ulimit memlock=-1 . -f build/dragonboat-raft-storage-node/Dockerfile -t atomix/dragonboat-raft-storage-node:${RAFT_STORAGE_NODE_VERSION}
```

Then running in the source dir of this repository the command `make image`, and tagging the built image as:

```bash
docker tag atomix/dragonboat-raft-storage-node:latest  atomix/raft-storage-node:v0.5.3
```

After that proceed with the execution of the Riab setup again.

## Cannot see Google Map view on the Facebook-AirHop xAPP GUI
### for all SD-RAN releases
Please remove caches and then try again.
Or, it would be good to use `Incognito window` in Chrome.

### only for SD-RAN release 1.1 and 1.1.1
The Google Map API in the Facebook-AirHop xAPP GUI only allows us to use `localhost:8080` URL.
If we runs Facebook-AirHop xAPP on the remote machine, we have to make a SSH tunnel from the local machine to the remote machine:
```bash
$ ssh <id>@<RiaB server IP address> -L "*:8080:<RiaB server IP address>:30095"
```

## Failed to install with `Create kubeadm token for joining nodes with 24h expiration` message
In order to resolve this problem, we need to reinstall RiaB again.
You should `make clean` or `make clean-all` and then install RiaB again.

## Failed to clean RiaB
When we clean up RiaB, sometimes we can see below error messages.
```bash
TASK [reset : reset | gather mounted kubelet dirs] *******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
fatal: [node1]: FAILED! => {"changed": true, "cmd": "set -o pipefail && mount | grep /var/lib/kubelet/ | awk '{print $3}' | tac", "delta": "0:00:00.007286", "end": "2021-07-15 19:15:47.566996", "msg": "non-zero return code", "rc": 1, "start": "2021-07-15 19:15:47.559710", "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node1                      : ok=14   changed=7    unreachable=0    failed=1    skipped=22   rescued=0    ignored=0
```

The easiest way to solve this issue is to remove Kubernetes manually.
Here is the instructions to remote the Kubernetes.
```bash
sudo reboot

docker rm -f $(docker ps -qa)
docker rmi -f $(docker images -q)
docker volume rm $(docker volume ls -q)

sudo su

for mount in $(mount | grep tmpfs | grep '/var/lib/kubelet' | awk '{ print $3 }') /var/lib/kubelet /var/lib/rancher; do umount $mount; done

rm -rf /etc/ceph \
       /etc/cni \
       /etc/kubernetes \
       /opt/cni \
       /opt/rke \
       /run/secrets/kubernetes.io \
       /run/calico \
       /run/flannel \
       /var/lib/calico \
       /var/lib/etcd \
       /var/lib/cni \
       /var/lib/kubelet \
       /var/lib/rancher/rke/log \
       /var/log/containers \
       /var/log/kube-audit \
       /var/log/pods \
       /var/run/calico

sudo reboot
```

## Other issues?
Please contact ONF SD-RAN team, if you see any issue. Any issue report from users is very welcome.
Mostly, the redeployment by using `make clean-all and make [option]` resolves issues.
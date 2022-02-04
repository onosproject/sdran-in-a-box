<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Troubleshooting Guide

This section covers how to solve the reported issues. This section will be updated, continuously.

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

## Atomix controllers cannot be deleted/reset
Sometimes, Atomix controllers cannot be deleted (maybe we will get stuck when deleting Atomix controller pods) when we command `make reset-test`.
```bash
rm -f /tmp/build/milestones/oai-enb-cu
rm -f /tmp/build/milestones/oai-enb-du
rm -f /tmp/build/milestones/oai-ue
helm delete -n riab sd-ran || true
release "sd-ran" uninstalled
cd /tmp/build/milestones; rm -f ric
kubectl delete -f https://raw.githubusercontent.com/atomix/kubernetes-controller/master/deploy/atomix-controller.yaml || true
customresourcedefinition.apiextensions.k8s.io "databases.cloud.atomix.io" deleted
customresourcedefinition.apiextensions.k8s.io "partitions.cloud.atomix.io" deleted
customresourcedefinition.apiextensions.k8s.io "members.cloud.atomix.io" deleted
customresourcedefinition.apiextensions.k8s.io "primitives.cloud.atomix.io" deleted
serviceaccount "atomix-controller" deleted
clusterrole.rbac.authorization.k8s.io "atomix-controller" deleted
clusterrolebinding.rbac.authorization.k8s.io "atomix-controller" deleted
service "atomix-controller" deleted
deployment.apps "atomix-controller" deleted
```

If the script is stopped here, we can command:
```bash
# Commmand Ctrl+c first to stop the Makefile script if the make reset-test is got stuck. Then command below.
$ make reset-atomix # Manually delete Atomix controller pods
$ make atomix # Manually install Atomix controller pods
$ make reset-test # Then, make reset-test again
```

Or, sometimes we see this when deploying RiaB:
```text
Error from server (AlreadyExists): error when creating "https://raw.githubusercontent.com/atomix/kubernetes-controller/master/deploy/atomix-controller.yaml": object is being deleted: customresourcedefinitions.apiextensions.k8s.io "members.cloud.atomix.io" already exists
Makefile:231: recipe for target '/tmp/build/milestones/atomix' failed
```

In this case, we can manually delete atomix with the command `make atomix || make reset-atomix`, and then resume to deploy RiaB.

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


## Other issues?
Please contact ONF SD-RAN team, if you see any issue. Any issue report from users is very welcome.
Mostly, the redeployment by using `make reset-test and make [option]` resolves issues.
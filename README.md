# SDRAN-in-a-Box (RiaB)
SDRAN-in-a-Box (RiaB) is a SD-RAN cluster which is able to operate within a single host machine.
It provides a development/test environment for developers/users in ONF SD-RAN community.
RiaB deploys SD-RAN infrastructure - the EPC (OMEC), emulated RAN (CU/DU/UE), and RIC (ONOS-RIC) - over Kubernetes.
On top of the SD-RAN infrastructure, we can conduct E2E tests in terms of the user plane and the SD-RAN control plane.

## Supported machines
* CloudLab Wisconsin and Utah cluster
  * CPU: Intel CPU and Haswell microarchitecture or beyond; at least 4 cores
  * OS: Ubuntu 18.04 (e.g., OnePC-Ubuntu18.04 profile in CloudLab)
  * RAM: At least 16GB
  * Storage: At least 50GB (recommendation: 100GB)
* Any baremetal server or VM
  * CPU: Intel CPU and Haswell microarchitecture or beyond; at least 4 cores
  * OS: Ubuntu 18.04 or 20.04 (e.g., OnePC-Ubuntu18.04 profile in CloudLab)
  * RAM: At least 16GB
  * Storage: At least 50GB (recommendation: 100GB)

## Quick Start
### Clone this repository
To begin with, clone this repository:
```bash
$ git clone https://github.com/onosproject/sdran-in-a-box
```

NOTE: If we want to use a specific release, we can change the branch with `git checkout [args]` command.
```bash
$ cd /path/to/sdran-in-a-box
$ git checkout v1.0.0 # for release 1
$ git checkout master # for the latest
```

### Deploy RiaB - CU-CP/OAI version (option 1)
Go to the `sdran-in-a-box` directory and build/deploy CU-CP, OAI DU, OAI UE, OMEC, and RIC. We can choose one of three commands:
```bash
$ cd /path/to/sdran-in-a-box
# Use latest charts and images
$ make #or make riab-oai, make riab-oai-latest
# Use charts and images for SD-RAN release 1.0
$ make riab-oai-v1.0.0
# Use charts in the local directory (~/helm-charts/) and images defined in sdran-in-a-box-values.yaml file
# Useful for the SD-RAN development
$ make riab-oai-dev
```

### Deploy RiaB - RANSim version (option 2)
Go to the `sdran-in-a-box` directory and build/deploy RIC and RANSim. We can choose one of three commands:
```bash
$ cd /path/to/sdran-in-a-box
# Use latest charts and images
$ make riab-ransim # or make riab-ransim-latest
# Use charts and images for SD-RAN release 1.0
$ make riab-ransim-v1.0.0
# Use charts in the local directory (~/helm-charts/) and images defined in sdran-in-a-box-values.yaml file
# Useful for the SD-RAN development
$ make riab-ransim-dev
```

### Write credentials when deploying RiaB
Running the Makefile script, we have to write some credentials for (i) opencord gerrit, (ii) onosproject github, and (iii) sdran private Helm chart repository.
```bash
aether-helm-chart repo is not in /users/wkim/helm-charts directory. Start to clone - it requires HTTPS key
Cloning into '/users/wkim/helm-charts/aether-helm-charts'...
Username for 'https://gerrit.opencord.org': <OPENCORD_GERRIT_ID>
Password for 'https://<OPENCORD_GERRIT_ID>@gerrit.opencord.org': <OPENCORD_GERRIT_HTTPS_PASSWORD>
remote: Total 1103 (delta 0), reused 1103 (delta 0)
Receiving objects: 100% (1103/1103), 526.14 KiB | 5.31 MiB/s, done.
Resolving deltas: 100% (604/604), done.
sdran-helm-chart repo is not in /users/wkim/helm-charts directory. Start to clone - it requires Github credential
Cloning into '/users/wkim/helm-charts/sdran-helm-charts'...
Username for 'https://github.com': <ONOSPROJECT_GITHUB_ID>
Password for 'https://<ONOSPROJECT_GITHUB_ID>@github.com': <ONOSPROJECT_GITHUB_PASSWORD>
remote: Enumerating objects: 19, done.
remote: Counting objects: 100% (19/19), done.
remote: Compressing objects: 100% (17/17), done.
remote: Total 2259 (delta 7), reused 3 (delta 2), pack-reused 2240
Receiving objects: 100% (2259/2259), 559.35 KiB | 2.60 MiB/s, done.
Resolving deltas: 100% (1558/1558), done.

.....

helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
"incubator" has been added to your repositories
helm repo add cord https://charts.opencord.org
"cord" has been added to your repositories
Username for ONF SDRAN private chart: <SDRAN_PRIVATE_CHART_REPO_ID>
Password for ONF SDRAN private chart: <SDRAN_PRIVATE_CHART_REPO_PASSWORD>
"sdran" has been added to your repositories
touch /tmp/build/milestones/helm-ready
```

If we did not see any error, everything is deployed.

### Deployed K8s pods for CU-CP/OAI version (option 1)
```bash
# It shows the result when we deploy CU-CP/OAI version (option 1)
$ kubectl get po -n riab
NAME                              READY   STATUS    RESTARTS   AGE
cassandra-0                       1/1     Running   0          3h26m
hss-0                             1/1     Running   0          3h26m
mme-0                             4/4     Running   0          3h26m
oai-enb-cu-0                      1/1     Running   0          3h25m
oai-enb-du-0                      1/1     Running   0          3h25m
oai-ue-0                          1/1     Running   0          3h25m
onos-config-66744d748-xr95k       1/1     Running   0          3h25m
onos-consensus-db-1-0             1/1     Running   0          3h25m
onos-e2sub-5f5fd6fdfb-5k92l       1/1     Running   0          3h25m
onos-e2t-74c765bc79-9h4sm         1/1     Running   0          3h25m
onos-kpimon-5649d85d57-7jvcw      1/1     Running   0          3h25m
onos-sdran-cli-678d547cbd-hbrtn   1/1     Running   0          3h25m
onos-topo-5bfbffb577-vvdcw        1/1     Running   0          3h25m
pcrf-0                            1/1     Running   0          3h26m
spgwc-0                           2/2     Running   0          3h26m
upf-0                             4/4     Running   0          3h26m
```

### Deployed K8s pods for RANSim version (option 2)
```bash
# It shows the result when we deploy RANSim version (option 2)
$ kubectl get po -n riab
NAME                              READY   STATUS    RESTARTS   AGE
onos-config-76f5b95d8f-zjfpj      1/1     Running   0          92s
onos-consensus-db-1-0             1/1     Running   0          92s
onos-e2sub-5dff4f9b9-cljn7        1/1     Running   0          92s
onos-e2t-67cbfb8c55-gpph4         1/1     Running   0          92s
onos-kpimon-5649d85d57-28kt4      1/1     Running   0          92s
onos-sdran-cli-7f4fc59b47-5sppt   1/1     Running   0          92s
onos-topo-85647b8cc6-98nd5        1/1     Running   0          92s
ran-simulator-57956df985-hc5n4    1/1     Running   0          92s
```

### Verification

#### The user plane (for option 1 - CU-CP/OAI version)
We should check if the user plane is working by using `make test-user-plane` command:
```bash
$ make test-user-plane
*** T1: Internal network test: ping 192.168.250.1 (Internal router IP) ***
PING 192.168.250.1 (192.168.250.1) from 172.250.255.253 oaitun_ue1: 56(84) bytes of data.
64 bytes from 192.168.250.1: icmp_seq=1 ttl=64 time=38.5 ms
64 bytes from 192.168.250.1: icmp_seq=2 ttl=64 time=47.0 ms
64 bytes from 192.168.250.1: icmp_seq=3 ttl=64 time=33.4 ms

--- 192.168.250.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 33.456/39.694/47.038/5.599 ms
*** T2: Internet connectivity test: ping to 8.8.8.8 ***
PING 8.8.8.8 (8.8.8.8) from 172.250.255.253 oaitun_ue1: 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=114 time=53.6 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=114 time=52.0 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=114 time=33.9 ms

--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 33.988/46.556/53.665/8.912 ms
*** T3: DNS test: ping to google.com ***
PING google.com (172.217.12.78) from 172.250.255.253 oaitun_ue1: 56(84) bytes of data.
64 bytes from dfw28s05-in-f14.1e100.net (172.217.12.78): icmp_seq=1 ttl=113 time=51.8 ms
64 bytes from dfw28s05-in-f14.1e100.net (172.217.12.78): icmp_seq=2 ttl=113 time=51.3 ms
64 bytes from dfw28s05-in-f14.1e100.net (172.217.12.78): icmp_seq=3 ttl=113 time=50.4 ms

--- google.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 50.472/51.219/51.872/0.632 ms
```

If we can see all above Kubernetes pods running and ping is running, the user plane is working well.

#### RIC by using ONOS-KPIMON xAPP (for both options)
Also, we should check whether the ONOS-RIC micro-services are working by using ONOS-KPIMON xAPP.
For this test, we can use `make test-kpimon` command:
```bash
$ make test-kpimon
*** Get KPIMON result through CLI ***
Key[PLMNID, nodeID]                       num(Active UEs)
{eNB-CU-Eurecom-LTEBox [0 2 16] 57344}   1
```

If we can see that `num(Active UEs)` is `1`, RIC is working well.

### Completely delete/reset RiaB
This deletes not only deployed Helm chart but also Kubernetes and Helm.
```bash
make clean # if we want to keep the ~/helm-charts directory - option to develop/test changed/new Helm charts
make clean-all # if we also want to delete ~/helm-charts directory
```

## Useful commands
### Deploy specific charts
For the development, we should deploy/reset some specific charts; this Makefile script also supports deploying/deleting some specific charts.

#### Deploy OMEC
```bash
$ make omec
```

#### Deploy OAI and CU-CP
```bash
$ make oai
```
NOTE: When deploying OAI and CU-CP chart, Makefile script automatically deploy OMEC chart (if it is not deployed).

#### Deploy ONOS-RIC micro-services
```bash
$ make ric
```
NOTE: When deploying ONOS-RIC micro-services chart, Makefile script automatically deploy Atomix chart (if it is not deployed).

#### Deploy Atomix controllers
```bash
$ make atomix
```

#### Deploy all undeployed Helm charts
We can reset/delete some specific charts by using some commands described in the below subsection (`Reset/delete specific charts`). To deploy all the reset/deleted charts, we can use the below command.
```bash
$ make riab-oai-[version] # for Option 1
$ make riab-ransim-[version] # for Option 2
```

### Reset/delete specific charts
In order to remove some specific charts already deployed, this Makefile script provides some commands for the development.

#### Reset/delete OMEC
```bash
$ make reset-omec
```
NOTE: When deleting OMEC chart, Makefile script automatically deletes OAI and CU-CP chart.

#### Reset/delete OAI and CU-CP
```bash
$ make reset-oai
```

#### Reset/delete ONOS-RIC micro-services
```bash
$ make reset-ric
```

#### Reset/delete Atomix controller
```bash
$ make reset-atomix
```

#### Delete/Reset charts for RiaB
This deletes all deployed Helm charts for SD-RAN development/test (i.e., Atomix, RIC, OAI, and OMEC). It does not delete K8s, Helm, or other software.
```bash
$ make reset-test
```

### Manage UEs (for Option 1)
#### Deploy multiple UEs.
Currently not working yet; under development.

#### Manually detach a UE
Currently, RiaB can emulates a single UE running on `oai-ue` pod. In order to manually detach this UE, we can use the below command:
```bash
$ echo -en "AT+CPIN=0000\r" | nc -u -w 1 localhost 10000
$ echo -en "AT+CGATT=0\r" | nc -u -w 1 localhost 10000
```

NOTE: Since reattachment is not working, we have to redeploy all charts again by using `make reset-oai reset-ric && make riab-oai`. This will be fixed in the next release.

#### Manually reattach a UE
Currently not working yet; Under development. This will support in the near future (next release).

### Miscellaneous
#### Fetch Aether and SD-RAN Helm charts
For the development perspective, we need to fetch the latest Helm chart commits, although the RiaB uses a specific chart version. This command fetches all latest commits:
```bash
$ make fetch-all-charts
```
It just fetches the all latest commits, i.e., it does not change/checkout the specific branch/commit.

NOTE: It may request credentials for the OpenCORD gerrit and SD-RAN Github.

#### Use SD-RAN CLI
In order to use the SD-RAN CLI, we should access to the onos-sdran-cli pod first. Then, we can use SD-RAN CLI commands.
```bash
$ kubectl exec -it deployment/onos-sdran-cli -n riab -- bash
$ sdran [arg1] [arg2] ...
```

## Troubleshooting
This section covers how to solve the reported issues. This section will be updated, continuously.

### SPGW-C or UPF is not working
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

### ETCD is not working
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

### Atomix controllers cannot be deleted/reset
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

### Pod onos-consensus-db-1-0 initialization failed

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

### Other issues?
Please contact ONF SD-RAN team, if you see any issue. Any issue report from users is very welcome.
Mostly, the redeployment by using `make reset-test and make [option]` resolves issues.
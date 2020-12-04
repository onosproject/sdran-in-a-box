# sdran-in-a-box
SDRAN-in-a-Box (RiaB) for SD-RAN project

## Supported machines
* CloudLab Wisc and Utah cluster [tested]
  * CPU: Intel CPU and Haswell microarchitecture or beyond; at least 4 cores
  * OS: Ubuntu 18.04 (e.g., OnePC-Ubuntu18.04 profile in CloudLab)
  * RAM: At least 16GB
  * Storage: At least 50GB (recommendation: 100GB)
* Any baremetal server or VM [under test]
  * CPU: Intel CPU and Haswell microarchitecture or beyond; at least 4 cores
  * OS: Ubuntu 18.04 or 20.04 (e.g., OnePC-Ubuntu18.04 profile in CloudLab)
  * RAM: At least 16GB
  * Storage: At least 50GB (recommendation: 100GB)

## Quick Start
### Deploy RiaB - CU-CP/OAI version (option 1)
To begin with, clone this repository:
```bash
$ git clone https://github.com/onosproject/sdran-in-a-box
```

Go to the `sdran-in-a-box` directory and build/deploy CU-CP, OAI DU, OAI UE, OMEC, and RIC.
```bash
$ cd /path/to/sdran-in-a-box
$ make #or make riab-oai
```

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

After deployment, we can use the below command to check whether all essential charts:
```bash
$ kubectl get po -n omec
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
onos-sdran-cli-678d547cbd-hbrtn   1/1     Running   0          3h25m
onos-topo-5bfbffb577-vvdcw        1/1     Running   0          3h25m
pcrf-0                            1/1     Running   0          3h26m
spgwc-0                           2/2     Running   0          3h26m
upf-0                             4/4     Running   0          3h26m
```

Then, we should check if the user plane is working by using the below command:
```
$ ping 8.8.8.8 -I oaitun_ue1
```

If we can see all above Kubernetes pods running and ping is runnig, RiaB is successfully deployed.

NOTE: ONOS-KPIMON xApp is under development and test - not fully working. If we want to deploy KPIMON xAPP chart for the development, we can use below command (not stable yet):
```
$ make kpimon
```

### Deploy RiaB - RANSim version (option 2)
WIP.

### Deploy specific charts
For the development, we should deploy some specific charts; this Makefile script also supports deploying some specific charts.

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

#### Deploy KPIMON
```bash
$ make kpimon
```
NOTE: When deploying ONOS-KPIMON xAPP chart, Makefile script automatically deploy Atomix chart and ONOS-RIC micro-services chart (if they are not deployed).

#### Deploy RANSim
WIP.

#### Deploy all undeployed Helm charts
We can reset/delete some specific charts by using some commands described in the below subsection (`Reset/delete specific charts`). To deploy all the reset/deleted charts, we can use the below command.
```bash
$ make
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
NOTE: When deleting ONOS-RIC micro-services chart, Makefile script automatically deletes ONOS-KPIMON xApp chart.

#### Reset/delete KPIMON only
```bash
make reset-kpimon
```

#### Delete/Reset charts for RiaB - CU-CP/OAI version (option 1)
This deletes only deployed Helm charts for option 1.
```bash
make reset-oai-test
```

#### Delete/Reset charts for RiaB - RANSim version (option 2)
WIP.

### Delete/Reset RiaB
This deletes not only deployed Helm chart but also Kubernetes and Helm.
```bash
make clean # if we want to keep the ~/helm-charts directory - option to develop/test changed/new Helm charts
make clean-all # if we also want to delete ~/helm-charts directory
```

## Detailed information (TL;DR)
TBD

## Troubleshooting
This section covers how to solve the reported issues. This section will be updated, continuously.

### SPGW-C or UPF is not working
Please check the log with below commands:
```bash
$ kubectl logs spgwc-0 -n omec -c spgwc # for SPGW-C log
$ kubectl logs upf-0 -n omec -c bess # for UPF log
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
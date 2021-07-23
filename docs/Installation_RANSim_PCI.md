# Installation with RAN-Simulator and ONOS PCI xAPP
This document covers how to install ONOS RIC services with RAN-Simulator.
With this option, RiaB will deploy ONOS RIC services including ONOS-KPIMON-V2 (KPM 2.0 supported) and ONOS-PCI xAPPs together with RAN-Simulator

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
$ git checkout master # for master
```

## Deploy RiaB with RAN-Simulator
### Command options
To deploy RiaB with RAN-Simulator, we should go to `sdran-in-a-box` directory and command below:
```bash
$ cd /path/to/sdran-in-a-box
# type one of below commands
# for "latest" version
$ make-ransim # or make riab-ransim-latest
# for "master-stable" version
$ make riab-ransim-master-stable
# for a specific version
$ make riab-ransim-v1.0.0 # for release SD-RAN 1.0
$ make riab-ransim-v1.1.0 # for release SD-RAN 1.1
# for a "dev" version
$ make riab-ransim-dev
```

Once we push one of above commands, the deployment procedure starts.

### Credentials
In the deployment procedure, we should type some credentials on the prompt:
* OpenCORD username and HTTPS key
* GitHub username and password
* Aether/SD-RAN Helm chart repository credentials

```bash
aether-helm-chart repo is not in /users/wkim/helm-charts directory. Start to clone - it requires HTTPS key
Cloning into '/users/wkim/helm-charts/aether-helm-charts'...
Username for 'https://gerrit.opencord.org': <OPENCORD_GERRIT_ID>
Password for 'https://<OPENCORD_GERRIT_ID>@gerrit.opencord.org': <OPENCORD_GERRIT_HTTPS_KEY>
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

If we don't see any error or failure messages, everything is deployed.
```bash
$ kubectl get po --all-namespaces
NAMESPACE     NAME                                          READY   STATUS    RESTARTS   AGE
default       router                                        1/1     Running   0          44h
kube-system   atomix-controller-694586d498-m55lk            1/1     Running   0          90s
kube-system   cache-storage-controller-5996c8fd45-rq7tv     1/1     Running   0          89s
kube-system   calico-kube-controllers-86d8c59b9f-vpztg      1/1     Running   0          45h
kube-system   calico-node-jxqp6                             1/1     Running   0          45h
kube-system   config-operator-69f7498fb5-zwxk8              1/1     Running   0          88s
kube-system   coredns-dff8fc7d-9fw8d                        1/1     Running   0          45h
kube-system   dns-autoscaler-5d74bb9b8f-6mvnv               1/1     Running   0          45h
kube-system   kube-apiserver-node1                          1/1     Running   0          45h
kube-system   kube-controller-manager-node1                 1/1     Running   0          45h
kube-system   kube-multus-ds-amd64-d6v5q                    1/1     Running   0          45h
kube-system   kube-proxy-rsfvr                              1/1     Running   0          45h
kube-system   kube-scheduler-node1                          1/1     Running   0          45h
kube-system   kubernetes-dashboard-667c4c65f8-cdcqz         1/1     Running   0          45h
kube-system   kubernetes-metrics-scraper-54fbb4d595-ffd4g   1/1     Running   0          45h
kube-system   nodelocaldns-lbhf2                            1/1     Running   0          45h
kube-system   raft-storage-controller-7755865dcd-mhjvh      1/1     Running   0          89s
kube-system   topo-operator-558f4545bd-jqjxm                1/1     Running   0          87s
riab          onos-cli-6655c68cb4-gjgx5                     1/1     Running   0          57s
riab          onos-config-59884c6766-dqcnh                  2/2     Running   0          57s
riab          onos-consensus-db-1-0                         1/1     Running   0          57s
riab          onos-e2sub-7588dcbc7b-wgft7                   1/1     Running   0          57s
riab          onos-e2t-56549f6648-24227                     1/1     Running   0          57s
riab          onos-kpimon-v2-846f556cfb-x7gsz               1/1     Running   0          57s
riab          onos-pci-85f465c9cf-5z8b9                     1/1     Running   0          57s
riab          onos-topo-5df4cf454c-dqvsp                    1/1     Running   0          57s
riab          ran-simulator-b6754dc97-czgvx                 1/1     Running   0          57s
```

NOTE: If we see any issue when deploying RiaB, please check [Troubleshooting](./troubleshooting.md)

## End-to-End (E2E) tests for verification
In order to check whether everything is running, we should conduct some E2E tests and check their results.
Since RAN-Sim does only generate SD-RAN control messages, we can run E2E tests on the SD-RAN control plane.

### The E2E test on SD-RAN control plane
In order to verify the SD-RAN control plane, we should command below for each version.
* `make test-kpimon`: only for SD-RAN release 1.0
```bash
$ make test-kpimon
*** Get KPIMON result through CLI ***
Key[PLMNID, nodeID]                       num(Active UEs)
{eNB-CU-Eurecom-LTEBox [0 2 16] 5153}   1
{eNB-CU-Eurecom-LTEBox [0 2 16] 5154}   1
```

* `make test-kpimon-v2`: for SD-RAN release 1.1, release 1.1.1, master-stable, latest, and dev versions
```bash
$ make test-kpimon-v2
*** Get KPIMON result through CLI ***
PlmnID    egNB ID   Cell ID           Time         RRC.Conn.Avg   RRC.Conn.Max   RRC.ConnEstabAtt.Tot   RRC.ConnEstabSucc.Tot   RRC.ConnReEstabAtt.HOFail   RRC.ConnReEstabAtt.Other   RRC.ConnReEstabAtt.Tot   RRC.ConnReEstabAtt.reconfigFail
1279014   5153      343332707639553   23:25:28.0   5              5              0                      0                       0                           0                          0                        0
1279014   5153      343332707639554   23:25:28.0   5              5              0                      0                       0                           0                          0                        0
1279014   5154      343332707639809   23:25:28.0   5              5              0                      0                       0                           0                          0                        0
1279014   5153      343332707639555   23:25:28.0   5              5              0                      0                       0                           0                          0                        0
1279014   5154      343332707639810   23:25:28.0   5              5              0                      0                       0                           0                          0                        0
1279014   5154      343332707639811   23:25:28.0   5              5              0                      0                       0                           0                          0                        0
```

* `make test-pci`: for SD-RAN release 1.1, release 1.1.1, master-stable, latest, and dev versions
```bash
$ make test-pci
*** Get PCI result through CLI ***
ID                num(conflicts)
343332707639554   1
343332707639811   0
343332707639810   0
343332707639809   1
343332707639555   1
343332707639553   3
```

If we can see like the above code block, the SD-RAN cotrol plane is working fine.

NOTE 1: Since SD-RAN release 1.0 does not support RC-PRE service model, `make test-pci` is not working in RiaB 1.0.0 version.

NOTE 2: The result `make test-pci` may vary but at least IDs `343332707639554`, `343332707639809`, `343332707639555`, and `343332707639553` should have one or more `num(conflicts)`.

## Other commands
### Reset and delete RiaB environment
If we want to reset our RiaB environment or delete RiaB compoents, we can use below commands:
* `make reset-test`: It deletes ONOS RIC services and RAN-Simulator but Kubernetes is still running
* `make clean`: It just deletes Kubernets environment; Eventually, all ONOS RIC and RAN-Simulator are terminated; The Helm chart directory is not deleted
* `make clean-all`: It deletes all including Kubernetes environment, all componentes/PODs which RiaB deployed, and even the Helm chart directory

### Deploy or reset a chart/service
If we want to only deploy or reset a chart/service, we can use below command:
* `make atomix`: It deploys Atomix controllers
* `make reset-atomix`: It deletes Atomix controllers
* `make ric`: It deploys ONOS RIC services
* `make reset-ric`: It deletes ONOS RIC services
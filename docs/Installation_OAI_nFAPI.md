# Installation with CU-CP and OAI nFAPI emulator
This document covers how to install ONOS RIC services with CU-CP and OAI nFAPI emulator.
With this option, RiaB will deploy ONOS RIC services including ONOS-KPIMON-V2 (KPM 2.0 supported) and ONOS-PCI xAPPs together with CU-CP, OAI DU (nFAPI), and OAI UE (nFAPI).

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

## Deploy RiaB with OAI nFAPI emulator

### Command options
To deploy RiaB with OAI nFAPI emulator, we should go to `sdran-in-a-box` directory and command below:
```bash
$ cd /path/to/sdran-in-a-box
# type one of below commands
# for "latest" version
$ make # make riab-oai, or make riab-oai-latest
# for "master-stable" version
$ make riab-oai-master-stable
# for a specific version
$ make riab-oai-v1.0.0 # for release SD-RAN 1.0
$ make riab-oai-v1.1.0 # for release SD-RAN 1.1
# for a "dev" version
$ make riab-oai-dev
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
default       router                                        1/1     Running   0          1h
kube-system   atomix-controller-694586d498-mj2kr            1/1     Running   0          1h
kube-system   cache-storage-controller-5996c8fd45-z6pgr     1/1     Running   0          1h
kube-system   calico-kube-controllers-86d8c59b9f-vpztg      1/1     Running   0          1h
kube-system   calico-node-jxqp6                             1/1     Running   0          1h
kube-system   config-operator-69f7498fb5-4gzzp              1/1     Running   0          1h
kube-system   coredns-dff8fc7d-9fw8d                        1/1     Running   0          1h
kube-system   dns-autoscaler-5d74bb9b8f-6mvnv               1/1     Running   0          1h
kube-system   kube-apiserver-node1                          1/1     Running   0          1h
kube-system   kube-controller-manager-node1                 1/1     Running   0          1h
kube-system   kube-multus-ds-amd64-d6v5q                    1/1     Running   0          1h
kube-system   kube-proxy-rsfvr                              1/1     Running   0          1h
kube-system   kube-scheduler-node1                          1/1     Running   0          1h
kube-system   kubernetes-dashboard-667c4c65f8-cdcqz         1/1     Running   0          1h
kube-system   kubernetes-metrics-scraper-54fbb4d595-ffd4g   1/1     Running   0          1h
kube-system   nodelocaldns-lbhf2                            1/1     Running   0          1h
kube-system   raft-storage-controller-7755865dcd-j44kq      1/1     Running   0          1h
kube-system   topo-operator-558f4545bd-7ncr7                1/1     Running   0          1h
riab          cassandra-0                                   1/1     Running   0          1h
riab          hss-0                                         1/1     Running   0          1h
riab          mme-0                                         4/4     Running   0          1h
riab          oai-enb-cu-0                                  1/1     Running   0          1h
riab          oai-enb-du-0                                  1/1     Running   0          1h
riab          oai-ue-0                                      1/1     Running   0          1h
riab          onos-cli-6655c68cb4-jhprs                     1/1     Running   0          1h
riab          onos-config-59884c6766-r5ckf                  2/2     Running   0          1h
riab          onos-consensus-db-1-0                         1/1     Running   0          1h
riab          onos-e2sub-7588dcbc7b-qc8xk                   1/1     Running   0          1h
riab          onos-e2t-56549f6648-kjrh4                     1/1     Running   0          1h
riab          onos-kpimon-v2-846f556cfb-z5x88               1/1     Running   0          1h
riab          onos-topo-5df4cf454c-dr5bf                    1/1     Running   0          1h
riab          pcrf-0                                        1/1     Running   0          1h
riab          spgwc-0                                       2/2     Running   0          1h
riab          upf-0                                         4/4     Running   0          1h
```

NOTE: If we see any issue when deploying RiaB, please check [Troubleshooting](./troubleshooting.md)

## End-to-End (E2E) tests for verification
In order to check whether everything is running, we should conduct some E2E tests and check their results.
Since CU-CP supports the SD-RAN control plane and OAI nFAPI services the LTE user plane, we can do E2E tests on the user plane and SD-RAN control plane.

### The E2E test on the user plane
We can type `make test-user-plane` on the prompt for the user plane verification.

```bash
$ make test-user-plane
*** T1: Internal network test: ping 192.168.250.1 (Internal router IP) ***
PING 192.168.250.1 (192.168.250.1) from 172.250.255.254 oaitun_ue1: 56(84) bytes of data.
64 bytes from 192.168.250.1: icmp_seq=1 ttl=64 time=20.4 ms
64 bytes from 192.168.250.1: icmp_seq=2 ttl=64 time=19.9 ms
64 bytes from 192.168.250.1: icmp_seq=3 ttl=64 time=18.6 ms

--- 192.168.250.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 18.664/19.686/20.479/0.758 ms
*** T2: Internet connectivity test: ping to 8.8.8.8 ***
PING 8.8.8.8 (8.8.8.8) from 172.250.255.254 oaitun_ue1: 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=113 time=57.8 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=113 time=56.4 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=113 time=55.0 ms

--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 55.004/56.441/57.878/1.189 ms
*** T3: DNS test: ping to google.com ***
PING google.com (172.217.9.142) from 172.250.255.254 oaitun_ue1: 56(84) bytes of data.
64 bytes from dfw25s26-in-f14.1e100.net (172.217.9.142): icmp_seq=1 ttl=112 time=54.7 ms
64 bytes from dfw25s26-in-f14.1e100.net (172.217.9.142): icmp_seq=2 ttl=112 time=53.6 ms
64 bytes from dfw25s26-in-f14.1e100.net (172.217.9.142): icmp_seq=3 ttl=112 time=51.9 ms

--- google.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 51.990/53.452/54.712/1.136 ms
```

If we can see that ping is working without any loss, the user plane is working well.

### The E2E test on SD-RAN control plane
In order to verify the SD-RAN control plane, we should command below for each version.
* `make test-kpimon`: only for SD-RAN release 1.0
```bash
$ make test-kpimon
*** Get KPIMON result through CLI ***
Key[PLMNID, nodeID]                       num(Active UEs)
{eNB-CU-Eurecom-LTEBox [0 2 16] 57344}   1
```
* `make test-kpimon-v2`: for SD-RAN release 1.1, release 1.1.1, master-stable, latest, and dev versions
```bash
$ make test-kpimon-v2
*** Get KPIMON result through CLI ***
PlmnID    egNB ID   Cell ID           Time           RRC.ConnEstabAtt.sum   RRC.ConnEstabSucc.sum   RRC.ConnMax   RRC.ConnMean   RRC.ConnReEstabAtt.sum
1112066   57344     298517943869440   12:04:03.0     0                      0                       0             0              0
```

* `make detach-ue && make test-kpimon` for SD-RAN release 1.0; `detach-ue` detaches a UE so the number of active UEs decreases
```bash
$ make test-kpimon
*** Get KPIMON result through CLI ***
Key[PLMNID, nodeID]                       num(Active UEs)
{eNB-CU-Eurecom-LTEBox [0 2 16] 57344}   1
$ make detach-ue
echo -en "AT+CPIN=0000\r" | nc -u -w 1 localhost 10000

OK
echo -en "AT+CGATT=0\r" | nc -u -w 1 localhost 10000

OK
$ make test-kpimon
*** Get KPIMON result through CLI ***
Key[PLMNID, nodeID]                       num(Active UEs)
{eNB-CU-Eurecom-LTEBox [0 2 16] 57344}   0
```

* `make detach-ue && make test-kpimon-v2`: for SD-RAN release 1.1, release 1.1.1, master-stable, latest, and dev versions; `detach-ue` detaches a UE so the number of active UEs decreases
```bash
$ make test-kpimon-v2
*** Get KPIMON result through CLI ***
PlmnID    egNB ID   Cell ID           Time           RRC.ConnEstabAtt.sum   RRC.ConnEstabSucc.sum   RRC.ConnMax   RRC.ConnMean   RRC.ConnReEstabAtt.sum
1112066   57344     298517943869440   12:04:03.0     1                      1                       1             1              0
$ make detach-ue
echo -en "AT+CPIN=0000\r" | nc -u -w 1 localhost 10000

OK
echo -en "AT+CGATT=0\r" | nc -u -w 1 localhost 10000

OK
$ make test-kpimon-v2
*** Get KPIMON result through CLI ***
PlmnID    egNB ID   Cell ID           Time           RRC.ConnEstabAtt.sum   RRC.ConnEstabSucc.sum   RRC.ConnMax   RRC.ConnMean   RRC.ConnReEstabAtt.sum
1112066   57344     298517943869440   12:04:03.0     1                      1                       0             0              0
```

If we can see like the above code block, the SD-RAN cotrol plane is working fine.

NOTE 1: If we enable ONOS-KPIMON-V1 in the `sdran-in-a-box-values-<version>.yaml`, we can also use `make test-kpimon-v1` in SD-RAN release 1.1, release 1.1.1, master-stable, latest, and dev version.

NOTE 2: Currently, there is no way to reattach the detached UE. For reattachment, we should redeploy RiaB (at least ONOS RIC services, CU-CP, OAI nFAPI emulator).

NOTE 3: Even though RiaB deploys ONOS-PCI xAPP, `make test-pci` does not print anything. The reason is that CU-CP does not support the RC-PRE service model.

## Other commands
### Reset and delete RiaB environment
If we want to reset our RiaB environment or delete RiaB compoents, we can use below commands:
* `make reset-test`: It deletes ONOS RIC services, CU-CP, and OAI nFAPI emulator but Kubernetes is still running
* `make clean`: It just deletes Kubernets environment; Eventually, all ONOS RIC services, CU-CP, and OAI nFAPI emulator are terminated; The Helm chart directory is not deleted
* `make clean-all`: It deletes all including Kubernetes environment, all componentes/PODs which RiaB deployed, and even the Helm chart directory

### Deploy or reset a chart/service
If we want to only deploy or reset a chart/service, we can use below command:
* `make omec`: It deploys OMEC chart
* `make reset-omec`: It deletes OMEC chart
* `make atomix`: It deploys Atomix controllers
* `make reset-atomix`: It deletes Atomix controllers
* `make ric`: It deploys ONOS RIC services
* `make reset-ric`: It deletes ONOS RIC services
* `make oai`: It deploys CU-CP and OAI nFAPI emulator
* `make reset-oai`: It deletes CU-CP and OAI nFAPI emulator

# Installation with RAN-Simulator and Facebook-AirHop xAPP
This document covers how to install ONOS RIC services with RAN-Simulator and Facebook-Airhop xAPP.
With this option, RiaB will deploy ONOS RIC services including ONOS-KPIMON (KPM 2.0 supported) together with RAN-Simulator and Facebook-AirHop xAPP.

## Clone this repository
To begin with, clone this repository:
```bash
$ git clone https://github.com/onosproject/sdran-in-a-box
```
**NOTE: If we want to use a specific release, we can change the branch with `git checkout [args]` command:**
```bash
$ cd /path/to/sdran-in-a-box
$ git checkout v1.1.0 # for release 1.1
$ git checkout v1.1.1 # for release 1.1.1
$ git checkout v1.2.0 # for release 1.2
$ git checkout v1.2.0 # for release 1.3
$ git checkout master # for master
```

## Deploy RiaB with RAN-Simulator and Facebook-AirHop xAPP
To deploy RiaB with RAN-Simulator and Facebook-AirHop xAPP, we should go to `sdran-in-a-box` directory and command below:
```bash
$ cd /path/to/sdran-in-a-box
# type one of below commands
# for "master-stable" version
$ make riab OPT=fbah VER=stable # or just make riab OPT=fbah
# for "latest" version
$ make riab OPT=fbah VER=latest
# for a specific version
$ make riab OPT=fbah VER=v1.1.0 # for release SD-RAN 1.1
$ make riab OPT=fbah VER=v1.1.1 # for release SD-RAN 1.1.1
$ make riab OPT=fbah VER=v1.2.0 # for release SD-RAN 1.2
$ make riab OPT=fbah VER=v1.3.0 # for release SD-RAN 1.3
# for a "dev" version
$ make riab OPT=fbah VER=dev # for dev version
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
NAMESPACE     NAME                                                     READY   STATUS    RESTARTS   AGE
kube-system   atomix-controller-6b6d96775-fnjm2                        1/1     Running   0          17m
kube-system   atomix-raft-storage-controller-77bd965f8d-97wql          1/1     Running   0          17m
kube-system   calico-kube-controllers-6759976d49-zkvjt                 1/1     Running   0          3d7h
kube-system   calico-node-n22vw                                        1/1     Running   0          3d7h
kube-system   coredns-dff8fc7d-b8lvl                                   1/1     Running   0          3d7h
kube-system   dns-autoscaler-5d74bb9b8f-5948j                          1/1     Running   0          3d7h
kube-system   kube-apiserver-node1                                     1/1     Running   0          3d7h
kube-system   kube-controller-manager-node1                            1/1     Running   0          3d7h
kube-system   kube-multus-ds-amd64-wg99f                               1/1     Running   0          3d7h
kube-system   kube-proxy-cvxz2                                         1/1     Running   1          3d7h
kube-system   kube-scheduler-node1                                     1/1     Running   0          3d7h
kube-system   kubernetes-dashboard-667c4c65f8-5kdcp                    1/1     Running   0          3d7h
kube-system   kubernetes-metrics-scraper-54fbb4d595-slnlv              1/1     Running   0          3d7h
kube-system   nodelocaldns-55nr9                                       1/1     Running   0          3d7h
kube-system   onos-operator-app-d56cb6f55-n25qc                        1/1     Running   0          17m
kube-system   onos-operator-config-7986b568b-hr8qk                     1/1     Running   0          17m
kube-system   onos-operator-topo-76fdf46db5-rlkth                      1/1     Running   0          17m
riab          ah-eson-test-server-85dfc8694f-8vfbg                     1/1     Running   0          79s
riab          fb-ah-gui-66bb7d75cc-6zhhn                               1/1     Running   0          79s
riab          fb-ah-xapp-69bb4d6d89-9vfmr                              1/2     Running   3          79s
riab          fb-kpimon-xapp-689f6c99dd-cn96l                          1/2     Running   3          79s
riab          onos-cli-9f75bc57c-68zpt                                 1/1     Running   0          79s
riab          onos-config-5d7cd9dd8c-zprwv                             4/4     Running   0          79s
riab          onos-consensus-store-0                                   1/1     Running   0          79s
riab          onos-e2t-ff696bc5d-svwvl                                 3/3     Running   0          79s
riab          onos-kpimon-6bdff5875c-z5z9s                             2/2     Running   0          79s
riab          onos-topo-775f5f946f-fchq4                               3/3     Running   0          79s
riab          onos-uenib-5b6445d58f-2mrxq                              3/3     Running   0          79s
riab          ran-simulator-66c897df5c-hwvjp                           1/1     Running   0          79s
```

NOTE: If we see any issue when deploying RiaB, please check [Troubleshooting](./troubleshooting.md)

## End-to-End (E2E) tests for verification
In order to check whether everything is running, we should conduct some E2E tests and check their results.
Since RAN-Sim does only generate SD-RAN control messages, we can run E2E tests on the SD-RAN control plane.

### The E2E test on SD-RAN control plane
* `make test-kpimon`: 
```bash
$ make test-kpimon
...
*** Get KPIMON result through CLI ***
Node ID          Cell Object ID       Cell Global ID            Time    RRC.Conn.Avg    RRC.Conn.Max    RRC.ConnEstabAtt.Sum    RRC.ConnEstabSucc.Sum    RRC.ConnReEstabAtt.HOFail    RRC.ConnReEstabAtt.Other    RRC.ConnReEstabAtt.Sum    RRC.ConnReEstabAtt.reconfigFail
e2:1/5153       13842601454c001             1454c001      02:43:07.0               2               3                       0                        0                            0                           0                         0                                  0
e2:1/5153       13842601454c002             1454c002      02:43:07.0               1               1                       0                        0                            0                           0                         0                                  0
e2:1/5153       13842601454c003             1454c003      02:43:07.0               1               2                       0                        0                            0                           0                         0                                  0
e2:1/5154       138426014550001             14550001      02:43:07.0               2               3                       0                        0                            0                           0                         0                                  0
e2:1/5154       138426014550002             14550002      02:43:07.0               2               2                       0                        0                            0                           0                         0                                  0
e2:1/5154       138426014550003             14550003      02:43:07.0               2               3                       0                        0                            0                           0                         0                                  0
```

* Use Facebook-AirHop GUI page: for SD-RAN release 1.1, release 1.1.1, release 1.2, release 1.3, master-stable, latest, and dev versions

### GUI [for SD-RAN release 1.2 and beyond]

To access GUI, we should open web browser like [Chrome](https://www.google.com/chrome/) or [Safari](https://www.apple.com/safari/).
Next, go to `http://<RiaB server IP address>:30095`
Then, we can see the xAPP webpage.

![FBAH WEB GUI](./figures/fbah-with-map-v1.2.png)

*Note: If we put the mouse cursor over the black circles, some tool tips should pop up.*

### GUI [for SD-RAN release 1.1 and 1.1.1]

To access GUI, we should open web browser like [Chrome](https://www.google.com/chrome/) or [Safari](https://www.apple.com/safari/).
Next, go to `http://<RiaB server IP address>:30095`
Then, we can see the xAPP webpage.

![FBAH WEB GUI](./figures/fbah-no-map-v1.1.png)

On this page, we can see the `Cells` table which shows ECGI, PCI, and each cell's neighbor cells.

If we want to see the Google Map View, we should make a SSH tunnel from our local machine to the RiaB server with below command:
```bash
$ ssh <id>@<RiaB server IP address> -L "*:8080:<RiaB server IP address>:30095"
```
After that, go to `http://localhost:8080` on the web browser.

![FBAH WEB GUI](./figures/fbah-with-map-v1.1.png)

Since the Google Map API only allows us to use the url `localhost:8080` to show Google Map view, we should make the SSH tunnel.

NOTE 1: Of course, all other port forwarding should work as long as we can access the GUI with `localhost:8080` URL.

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
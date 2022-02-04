<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Install RIC only

This section explains how to execute only the RIC components (without RanSim/OAI) using the RiaB Makefile.

## Get the RiaB source code 

To get the source code, please see: `https://github.com/onosproject/sdran-in-a-box`.

Since SDRAN-in-a-Box repository is a member-only repository, a user should log in github and then check the git clone command on that web site.
Clone the RiaB repository to the target machine.

This option is usefull to test RIC with CU/DU components running in other machines.


## Run RIC

In the sdran-in-a-box folder, edit the Makefile to disable the ran-simulator execution, it should look like the line below:

```bash
RANSIM_ARGS			?= --set import.ran-simulator.enabled=false # Change this value from true to false
```

Then run the RIC components with the commands below.

```bash
$ cd /path/to/sdran-in-a-box
$ sudo apt install build-essential
$ make OPT=ric VER=<version>
```

**Notice: The sdran-in-a-box-values.yaml contain the latest versions of the RIC components. In order to use the v1.0.0 or v1.1.0 versions make sure to respectively copy and paste to the sdran-in-a-box-values.yaml file the contents of the files sdran-in-a-box-values-v1.0.0.yaml and sdran-in-a-box-values-v1.1.0.yaml as needed.**

Check the deployed RIC components using the commands:
```bash
$ kubectl -n riab get pods
$ kubectl -n riab get svc
```

Notice, in the output of the command `kubectl -n riab get svc` the service onos-e2t-external must be present in order to  E2 nodes reach the RIC running node using a remote SCTP connection in port 36421. The IP address to be configured in E2 nodes connecting to RIC must be the IP address of the primary network interface of the RIC host machine.

If such service (onos-e2t-external) does not exist, make sure in the file sdran-in-a-box-values.yaml the lines below are not commented.

```yaml
onos-e2t:
  service:
    external:
      enabled: true
    e2:
     nodePort: 36421
```

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

## Stop/Clean RIC

This deletes all deployed Helm charts for RIC components (keeps Kubernetes and Helm installed/running).

```bash
$ make reset-ric
```

And this deletes not only deployed Helm charts but also Kubernetes and Helm.

```bash
make clean      # if we want to keep the ~/helm-charts directory - option to develop/test changed/new Helm charts
make clean-all  # if we also want to delete ~/helm-charts directory
```
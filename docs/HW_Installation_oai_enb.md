<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Install OAI CU/DU

This section explains how to execute only the OAI components using the RiaB Makefile.

Bofere proceeding, make sure you follow all the instructions on how to install the OAI/USRP requirements prerequisites in the NUC machines.

In the RiaB makefile targets are included options to execute OAI CU/DU/UE components using helm charts. Those steps do not require any source code compilation of OAI, the OAI components run in docker images and have their parameters configured by the sdran-in-a-box-values.yaml file.

**Notice: The sdran-in-a-box-values.yaml contain the latest versions/tags of the OAI docker images. In order to use the versions of the OAI docker images specified in RiaB v1.0.0 or v1.1.0 releases make sure to respectively copy and paste to the sdran-in-a-box-values.yaml file the contents of the files sdran-in-a-box-values-v1.0.0.yaml and sdran-in-a-box-values-v1.1.0.yaml as needed.**

## Network parameter configuration

We should then configure the network parameters (e.g., routing rules, MTU size, and packet fregmentation) on the OAI-CU/DU machine.

### Configure the IP addresses on the OAI NUC
Before run CU-CP, the NUC machine for OAI has to have two IP addresses on the Ethernet port.
The one IP address is the IP address in 192.168.11.8/29 subnet to communiacte with Quagga internal router in OMEC VM.
The other ons is for the IP address to communicate with the OMEC machine and RIC machine.
This the the IP assignment:
```bash
$ ip a show eno1
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 1c:69:7a:6e:97:91 brd ff:ff:ff:ff:ff:ff
    inet 192.168.11.10/29 brd 192.168.11.15 scope global eno1
       valid_lft forever preferred_lft forever
    inet 192.168.13.21/16 brd 192.168.255.255 scope global eno1
       valid_lft forever preferred_lft forever
...
```

Here, the most important thing is the order of IP address. The IP address `192.168.11.10/29` should be first and the IP address `192.168.13.21/16` should be the secondary IP address.
Otherwise, the user traffic does not work as well as the CU-CP cannot make a E2 connection.
In order to assign two IP address like above, we can configure the `netplan`.
```bash
$ cat /etc/netplan/50-cloud-init.yaml
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eno1:
            addresses:
            - 192.168.11.10/29
            - 192.168.13.21/16
            gateway4: 192.168.0.1
            nameservers:
                addresses:
                - 8.8.8.8
    version: 2
```

### Configuration in OAI-CU/DU machine
Then, We should go to the the OAI-CU/DU NUC machine and add some routing rules

```bash
$ cd /path/to/sdran-in-a-box
$ make routing-hw-oai
```

## Run OAI eNB CU/DU 

```bash
$ cd /path/to/sdran-in-a-box
$ sudo apt install build-essential
$ make oai-hw
```

This command starts the execution of oai-enb-cu and oai-enb-du components.

This step might take some time due to the download of the oai-enb-cu and oai-enb-du docker images.
After the conditions (pod/oai-enb-cu-0 condition met and pod/oai-enb-du-0 condition met) were achieved the deployment was successful.

The pod pod/oai-enb-du-0 takes some time to start as it needs to configure the USRP first.

*Note: If we want to deploy a specific release version of OAI in SD-RAN project, we should add `VER=VERSION` argument; VERSION should be one of {v1.0.0, v1.1.0, v1.2.0, latest, stable}.*

## Stop/Clean OAI components

After finishing the hardware installation setup procedures, run the command below to delete all deployed Helm charts for OAI CU/DU components:

```bash
$ make reset-oai
```

And this deletes not only deployed Helm chart but also Kubernetes and Helm.

```bash
make clean      # if we want to keep the ~/helm-charts directory - option to develop/test changed/new Helm charts
make clean-all  # if we also want to delete ~/helm-charts directory
```

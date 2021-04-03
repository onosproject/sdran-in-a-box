# Install OAI CU/DU

This section explains how to execute only the OAI components using the RiaB Makefile.

Bofere proceeding, make sure you follow all the instructions on how to install the OAI/USRP requirements prerequisites in the NUC machines.

In the RiaB makefile targets are included options to execute OAI CU/DU/UE components using helm charts. Those steps do not require any source code compilation of OAI, the OAI components run in docker images and have their parameters configured by the sdran-in-a-box-values.yaml file.

**Notice: The sdran-in-a-box-values.yaml contain the latest versions/tags of the OAI docker images. In order to use the versions of the OAI docker images specified in RiaB v1.0.0 or v1.1.0 releases make sure to respectively copy and paste to the sdran-in-a-box-values.yaml file the contents of the files sdran-in-a-box-values-v1.0.0.yaml and sdran-in-a-box-values-v1.1.0.yaml as needed.**

## Network parameter configuration

We should then configure the network parameters (e.g., routing rules, MTU size, and packet fregmentation) on the OAI-CU/DU machine.


### Configure the secondary IP address on the OAI NUC
Before run CU-CP, the NUC machine for OAI should have a secondary IP address on the Ethernet port.
The secondary IP address should have one of the IP address in `192.168.11.8/29` subnet.
The purpose of this IP address is to communicate with the other NUC machine which RiaB is running inside.
```bash
$ sudo ip a add 192.168.11.10/29 dev eno1
```
*NOTE: The reference setup has 192.168.11.10/29 for the secondary IP address, as defined in the same network prefix 192.168. as OMEC-EPC.*


### Install some network tools
```bash
$ sudo apt install net-tools ethtool
```

*NOTE: Normally, those tools are already installed. If not, we can command it.*

### Configuration in OAI-CU/DU machine
Last, we should configure network configuration in the OAI-CU/DU NUC machine.
We should go to the the OAI-CU/DU NUC machine and change the network configuration such as TX/RX checksum, GRO, and routing rules.

```bash
$ sudo ethtool -K eno1 tx off rx off gro off gso off
$ sudo route del -net 192.168.11.8/29 dev eno1 # ignore error if happened
$ sudo route add -net 192.168.11.0/29 gw 192.168.10.21 dev eno1 # This route forwards traffic to the EPC machine 
$ sudo route add -net 192.168.11.8/29 gw 192.168.10.21 dev eno1 # This route forwards traffic to the EPC machine 
$ sudo route add -net 192.168.11.16/29 gw 192.168.10.21 dev eno1 # This route forwards traffic to the EPC machine 
```

## Run OAI eNB CU/DU 

```bash
$ cd /path/to/sdran-in-a-box
$ sudo apt install build-essential
$ make oai-enb-usrp
```

This command starts the execution of oai-enb-cu and oai-enb-du components.

This step might take some time due to the download of the oai-enb-cu and oai-enb-du docker images.
After the conditions (pod/oai-enb-cu-0 condition met and pod/oai-enb-du-0 condition met) were achieved the deployment was successful.

The pod pod/oai-enb-du-0 takes some time to start as it needs to configure the USRP first.


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

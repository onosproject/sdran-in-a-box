<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# SDRAN-in-a-Box (RiaB)
SDRAN-in-a-Box (RiaB) is a SD-RAN cluster which is able to operate within a single host machine .
It provides a development/test environment for developers/users in ONF SD-RAN community.
RiaB deploys SD-RAN infrastructure - the EPC ([OMEC](https://github.com/omec-project)), emulated RAN (CU/DU/UE), and ONOS RAN Intelligent Controller (ONOS RIC) services - over Kubernetes.
On top of the SD-RAN infrastructure, we can conduct end-to-end tests in terms of the user plane and the SD-RAN control plane.

## Features
* Installs Kubernetes and Helm that are the required infrastructure for SD-RAN services
* Provides one of three choices to emulate/simulate Radio Access Networks (RANs)
  * RAN-Simulator
    * Simulates multiple E2 nodes (CU-CP/DU/RU) and UEs
    * Generates SD-RAN control plane messages
    * Does not support the LTE traffic
  * OMEC / CU-CP / OAI nFAPI emulator for DU/UE
    * Completely runs OMEC, a 4G/LTE core network - not emulation
    * Completely runs CU-CP, which generates SD-RAN control plane messages - not emulation
    * Emulates DU and UEs (up to three UEs) with OAI nAFPI emulator, which generate LTE control and user plane traffic
  * OMEC / CU-CP / OAI DU and UE with USRP hardware and/or LTE smartphones
    * Completely runs OMEC, a 4G/LTE core network - not emulation
    * Completely runs CU-CP, which generates SD-RAN control plane messages - not emulation
    * Completely runs OAI DU together with the CU-CP and a USRP device to open a cell - Software Defined Radio (SDR) device-based emulation which commercial LTE phones can attach
    * Completely runs OAI UE with a USRP device to attach the cell the CU-CP and OAI DU opens
* Support End-to-End (E2E) connectivity test
  * The user plane E2E test
    * Works with CU-CP / OAI nFAPI emulator and CU-CP / OAI DU and UE with USRP hardware cases, since RAN-Sim does not support the data traffic
  * The SD-RAN control plane E2E test
    * Works with xAPPs such as onos-kpimon, onos-pci, onos-mlb and onos-mho

## RiaB versions and options

### Versions
RiaB has three versions: **latest**, **master-stable**, **dev**, and each release/tag such as **v1.0.0**, **v1.1.0**, **v1.1.1**, and **v1.2.0**.

#### Latest version
The *latest* version of RiaB deploys latest Helm charts and latest Docker container images.

#### Master-stable version
The *master-stable* version of RiaB deploys latest Helm charts but not latest Docker container images.
It deploys the Docker containers according to the image tag described in each Helm chart. 

#### Release/tag versions
The release/tag version such as *v1.0.0*, *v1.1.0*, *v1.1.1*, and *v1.2.0* deployes a specific SD-RAN release version of Helm charts and Docker container images.

#### Dev version
The *dev* version deploys Helm charts in the `~/helm-charts/sdran-helm-charts` directory and Docker container images `sdran-in-a-box-values.yaml` file.
All other versions initially change the `~/helm-charts/sdran-helm-charts` branch to the specific version.
For example, the *latest* version and *master-stable* version change the the `~/helm-charts/sdran-helm-charts` branch to `master`, 
while the *v1.0.0*, *v1.1.0*, *v1.1.1*, and *v1.2.0* versions change that branch to *v1.0.0*, *v1.1.0*, *v1.1.1*, and *v1.2.0*, respectively.
If we change some Helm chart code in `~/helm-charts/sdran-helm-charts` directory for a test, the above versions will reset to the *master* or a specific version branch.
However, since the *dev* option just uses the Helm chart in `~/helm-charts/sdran-helm-charts` as is, we can test the Helm chart chages.
Also, once we specify image tags in the `sdran-in-a-box-values.yaml` files, this version deploys the Docker containers with the Helm chart change.

### Options
RiaB also has four options: **ONOS RIC with OAI nFAPI emulator**, **ONOS RIC with RAN-Simulator**, **ONOS RIC with OAI and USRP devices**, and **Facebook-AirHop xAPP use case**.

#### ONOS RIC with OAI nFAPI emulator option
The *ONOS RIC with OAAI nFAPI emulator* option deploys ONOS RIC services (i.e., Atomix, onos-operator, onos-topo, onos-config, onos-cli, onos-e2t, onos-e2sub, etc) with OMEC, CU-CP, and OAI nFAPI emulator.
It supports E2E connectivities on the data plane and SD-RAN control plane.
The data plane is running without the real radio signal, but nFAPI.

#### ONOS RIC with RAN-Simulator option
The *ONOS RIC with RAN-Simulator* option deploys ONOS RIC services with RAN-Simulator.
It supports an E2E connectivity on the SD-RAN control plane.

#### ONOS RIC with OAI and USRP devices option
The *ONOS RIC with OAI and USRP devices* option deploys ONOS RIC services with OMEC, CU-CP, OAI DU, and OAI UE with USRP devices.
It supports E2E connectivities on the data plane and SD-RAN control plane.
The data plane is running with the real radio signal, so that we can also test with commercial LTE smartphones.

#### Facebook-AirHop use case option
The *Facebook-AirHop use case* option is similar to the *ONOS RIC with RAN-Simulator* option.
The only difference is the PCI xAPP.
This option deploys the PCI xAPP from Facebook-AirHop, while *ONOS RIC with RAN-Simulator* option uses ONF ONOS-PCI xAPP.


## Detailed information
See [docs](docs) directory for details of RiaB.

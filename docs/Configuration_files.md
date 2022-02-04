<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# RiaB configuration

## Configuration files for each version
If we want to tune RiaB, we should modify below YAML file for each version before the RiaB deployment.
* For `latest` and `dev` version: `sdran-in-a-box-values.yaml` file
* For `master-stable` version: `sdran-in-a-box-values-master-stable.yaml` file
* For a specific release version: `sdran-in-a-box-values-<version>.yaml` file

## First block - Enables Cassandra DB in OMEC
This is the Cassandra DB configuration for OMEC. We don't really need to change this.
```yaml
cassandra:
  config:
    cluster_size: 1
    seed_size: 1
```

## Second block - Enables CPU/MEM size configuration
This is for the CPU/MEM size configuration. We don't need to change this.
```yaml
resources:
  enabled: false
```

## Third block - OMEC, CU-CP, and OAI nFAPI parameter configuration block
This block has parameters for OMEC, CU-CP, OAI DU (nFAPI), and OAI UE (nFAPI) parameter configuration.
```yaml
config:
  spgwc:
    pfcp: true
    ueIpPool:
      ip: 172.250.0.0 # if we use RiaB, Makefile script will override this value with the value defined in Makefile script.
  upf:
    name: "oaisim"
    sriov:
      enabled: false
    hugepage:
      enabled: false
    cniPlugin: simpleovs
    ipam: static
    cfgFiles:
      upf.json:
        mode: af_packet
  mme:
    cfgFiles:
      config.json:
        mme:
          mcc:
            dig1: 2
            dig2: 0
            dig3: 8
          mnc:
            dig1: 0
            dig2: 1
            dig3: -1
          apnlist:
            internet: "spgwc"
  hss:
    bootstrap:
      users:
        - apn: "internet"
          key: "465b5ce8b199b49faa5f0a2ee238a6bc"
          opc: "d4416644f6154936193433dd20a0ace0"
          sqn: 96
          imsiStart: "208014567891201"
          msisdnStart: "1122334455"
          count: 10
      mmes:
        - id: 1
          mme_identity: mme.riab.svc.cluster.local
          mme_realm: riab.svc.cluster.local
          isdn: "19136246000"
          unreachability: 1
  oai-enb-cu:
    networks:
      f1:
        interface: eno1 # if we use RiaB, Makefile script will automatically apply appropriate interface name
        address: 10.128.100.100 #if we use RiaB, Makefile script will automatically apply appropriate IP address
      s1mme:
        interface: eno1 # if we use RiaB, Makefile script will automatically apply appropriate interface name
      s1u:
        interface: enb
  oai-enb-du:
    mode: nfapi #or local_L1 for USRP and BasicSim
    networks:
      f1:
        interface: eno1 #if we use RiaB, Makefile script will automatically apply appropriate IP address
        address: 10.128.100.100 #if we use RiaB, Makefile script will automatically apply appropriate IP address
      nfapi:
        interface: eno1 #if we use RiaB, Makefile script will automatically apply appropriate IP address
        address: 10.128.100.100 #if we use RiaB, Makefile script will automatically apply appropriate IP address
  oai-ue:
    numDevices: 1 # support up to 3
    networks:
      nfapi:
        interface: eno1 #if we use RiaB, Makefile script will automatically apply appropriate IP address
        address: 10.128.100.100 #if we use RiaB, Makefile script will automatically apply appropriate IP address
  onos-e2t:
    enabled: "yes"
    networks:
      e2:
        address: 127.0.0.1 # if we use RiaB, Makefile script will automatically apply appropriate interface name
        port: 36421
```

Normally, we don't need to touch one of those values except for `numDevices` in `oai-ue` block. 
If we want to deploy more UEs, we should change `numDevices` and then deploy RiaB with OAI nFAPI emulator option.

## Fourth block - image tag block
This block has all containers' repository, tag/version, and pulling policy.
To test a specific Docker container image within RiaB, we should change imamge tag and repository in this block.
```yaml
# for the development, we can use the custom images
# For ONOS-RIC
onos-topo:
  image:
    pullPolicy: IfNotPresent
    repository: onosproject/onos-topo
    tag: latest
onos-config:
  image:
    pullPolicy: IfNotPresent
    repository: onosproject/onos-config
    tag: latest
onos-e2t:
  service:
    external:
      enabled: true
    e2:
     nodePort: 36421
  image:
    pullPolicy: IfNotPresent
    repository: onosproject/onos-e2t
    tag: latest
onos-e2sub:
  image:
    pullPolicy: IfNotPresent
    repository: onosproject/onos-e2sub
    tag: latest
onos-cli:
  image:
    pullPolicy: IfNotPresent
    repository: onosproject/onos-cli
    tag: latest
ran-simulator:
  image:
    pullPolicy: IfNotPresent
    repository: onosproject/ran-simulator
    tag: latest
onos-kpimon-v1:
  image:
    pullPolicy: IfNotPresent
    repository: onosproject/onos-kpimon
    tag: latest
onos-kpimon-v2:
  image:
    pullPolicy: IfNotPresent
    repository: onosproject/onos-kpimon
    tag: latest
onos-pci:
  image:
    pullPolicy: IfNotPresent
    repository: onosproject/onos-pci
    tag: latest
fb-ah-xapp:
  image:
    repository: onosproject/fb-ah-xapp
    tag: 0.0.1
    pullPolicy: IfNotPresent
fb-ah-gui:
  image:
    repository: onosproject/fb-ah-gui
    tag: 0.0.1
    pullPolicy: IfNotPresent
ah-eson-test-server:
  image:
    repository: onosproject/ah-eson-test-server
    tag: 0.0.1
    pullPolicy: IfNotPresent

# For OMEC & OAI
images:
  pullPolicy: IfNotPresent
  tags:
# For OMEC - Those images are stable image for RiaB
# latest Aether helm chart commit ID: 3d1e936e87b4ddae784a33f036f87899e9d00b95
#    init: docker.io/omecproject/pod-init:1.0.0
#    depCheck: quay.io/stackanetes/kubernetes-entrypoint:v0.3.1
    hssdb: docker.io/onosproject/riab-hssdb:v1.0.0
    hss: docker.io/onosproject/riab-hss:v1.0.0
    mme: docker.io/onosproject/riab-nucleus-mme:v1.0.0
    spgwc: docker.io/onosproject/riab-spgw:v1.0.0
    pcrf: docker.io/onosproject/riab-pcrf:v1.0.0
    pcrfdb: docker.io/onosproject/riab-pcrfdb:v1.0.0
    bess: docker.io/onosproject/riab-bess-upf:v1.0.0
    pfcpiface: docker.io/onosproject/riab-pfcpiface:v1.0.0
# For OAI
    oaicucp: docker.io/onosproject/oai-enb-cu:latest
    oaidu: docker.io/onosproject/oai-enb-du:latest
    oaiue: docker.io/onosproject/oai-ue:latest
```

## Fifth block - import block
This block is the import block to speicify which services are onboarded in ONOS RIC services.
In fact, ONOS RIC services are packaged as a single umbrella Helm chart.
By adjusting this block, we can configure which service is onboarded and which service is not deployed.
```yaml
# For SD-RAN Umbrella chart:
# ONOS-KPIMON xAPP is imported in the RiaB by default
import:
  onos-kpimon-v1:
    enabled: false
  onos-kpimon-v2:
    enabled: true
  onos-pci:
    enabled: true
# Other ONOS-RIC micro-services
#   onos-topo:
#     enabled: true
#   onos-e2t:
#     enabled: true
#   onos-e2sub:
#     enabled: true
#   onos-o1t:
#     enabled: false
#   onos-config:
#     enabled: true
#   onos-sdran-cli:
#     enabled: true
# ran-simulator chart is automatically imported when pushing ransim option
#   ran-simulator:
#     enabled: false
#   onos-gui:
#     enabled: false
#   nem-monitoring:
#     enabled: false
# fb-ah-xapp, fb-ah-gui, and ah-eson-test-server are automatically imported when pushing fbc-pci option
#   fb-ah-xapp:
#     enabled: false
#   fb-ah-gui:
#     enabled: false
#   ah-eson-test-server:
#     enabled: false
```
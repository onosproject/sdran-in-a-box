<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Operations Guide

## Evaluate the RIC operation

In the ONOS-RIC machine, log in the onos-cli pod, running:

```bash
$ kubectl -n riab exec -ti deployment/onos-cli -- bash
```

Once inside the onos-cli pod, check the ONOS-RIC connections and subscriptions:

```bash
$ onos e2t list connections      #Shows the associated CU/DU connection
$ onos e2sub list subscriptions  #Shows the apps subscrition to the CU/DU nodes
```

In the output of the kpimonv2 list of metrics, there should appear 1 UE registered. It means the UE was attached to the DU/CU setup.

```bash
$ kubectl exec -it deployment/onos-cli -n riab -- onos kpimonv2 list metrics
Cell ID         RRC.ConnEstabAtt.sum   RRC.ConnEstabSucc.sum   RRC.ConnMax   RRC.ConnMean   RRC.ConnReEstabAtt.sum
1112066:57344   0                      0                       0             1              0
```

## Custom Network Routes and IP Addresses

It is important to explain the custom settings associated with the hardware installation setup, in specific the network routes and IP addresses defined in the EPC-OMEC router and the OAI-CU/DU machine and the cu.onf.conf file.

In the EPC-OMEC, a router Pod (running the Quagga engine) interconnects the core, enb and access networks, each one respectively in the following subnets 192.168.11.0/29, 192.168.11.8/29, and 192.168.11.16/29.

Via the definition of the secondary IP address (192.168.11.10/29) in the OAI-CU/DU machine, it was possible to configure the EPC-OMEC core to forward traffic to the host 192.168.11.10 via the gateway 192.168.13.21 (the primary OAI-CU/DU IP address).

In the OAI-CU/DU machine, the set of routes had to be configured so the traffic from the CU/DU be forwarded to the EPC-OMEC machine.

Inside the router of the EPC-OMEC, a route had to be configured to reach the secondary IP address of OAI-CU/DU via the enb interface.

And the cu.onf.conf file in the OAI-CU/DU machine had to be correctly configured using the IP addresses of the MME (EPC-CORE) and RIC machines.

**Notice, in summary the routing rule and IP addresses configuration are performed so OAI-CU/DU can reach EPC-OMEC and vice-versa.**


## User Equipment (UE) Handset
As of now, the current OAI with RiaB setup is running over LTE Band 7.
To communicate with this setup, we should prepare the Android smartphone which supports LTE Band 7.
We should then insert a SIM card to the smartphone, where the SIM card should have the below IMSI, Key, and OPc values:

* IMSI: `315010999912340-315010999912370`
* Key: `465b5ce8b199b49faa5f0a2ee238a6bc`
* OPc: `69d5c2eb2e2e624750541d3bbc692ba5`

If we want to use the different IMSI number, we have to change the HSS configuration.
In order to change SIM information in HSS, we first go to the ONOS-RIC machine and open the `sdran-in-a-box-values.yaml` file.
And change this section to the appropriate number:
```yaml
  hss:
    bootstrap:
      users:
        - apn: "internet"
          key: "000102030405060708090a0b0c0d0e0f" # Change me
          opc: "69d5c2eb2e2e624750541d3bbc692ba5" # Change me
          sqn: 135
          imsiStart: "315010999912340" # Change me
          msisdnStart: "9999334455"
          count: 30
```

If the new SIM information has the different PLMN ID, we should also change the PLMN ID into MME, HSS, CU-CP, and DU configuration files.
We should find PLMN ID or MCC/MNC values and change them to the appropriate number.

`sdran-in-a-box-values.yaml`:
```yaml
  spgwc:
    pfcp: true
    multiUpfs: true
    jsonCfgFiles:
      subscriber_mapping.json:
        subscriber-selection-rules:
          - selected-user-plane-profile: "menlo"
            keys:
              serving-plmn:
                mcc: 315 # Change me
                mnc: 10 # Change me
...
  mme:
    cfgFiles:
      config.json:
        mme:
          logging: debug
          mcc:
            dig1: 3 # Change me
            dig2: 1 # Change me
            dig3: 5 # Change me
          mnc:
            dig1: 0 # Change me
            dig2: 1 # Change me
            dig3: 0 # Change me
          apnlist:
            internet: "spgwc"
```

`cu.onf.conf`:
```text
tracking_area_code = 1001;
plmn_list = ( { mcc = 315; mnc = 010; mnc_length = 3; } ) // Change me
```

`du.onf.conf`:
```text
tracking_area_code = 1001;
plmn_list = ( { mcc = 315; mnc = 010; mnc_length = 3; } ) // Change me
```
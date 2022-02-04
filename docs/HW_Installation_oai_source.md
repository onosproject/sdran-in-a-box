<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Install OAI CU/DU/UE on Baremetal

This section explains how to compile and execute only the OAI components from the source code.

Bofere proceeding, make sure you follow all the instructions on how to install the OAI/USRP requirements prerequisites in the NUC machines.

## Install UHD driver and push UHD image to USRP B210 device
Once we finished to check that the power management and CPU frequency configuration are good, we should reboot NUC machine again.
After the NUC is completely rebooted, then we should connect the USRP B210 device to the NUC machine.
To make the USRP B210 device run along with the NUC board, we should install UHD driver on the NUC machine.
And then, we should push the UHD image to USRP B210 device.

```bash
$ # Install UHD driver
$ sudo apt-get install libuhd-dev libuhd003 uhd-host
$ # Push UHD image to the USRP B210 device
$ sudo uhd_images_downloader
```

*NOTE 1: When we cannot install `libuhd003`, we can replace it with `libuhd003.010.003`.*

*NOTE 2: USRP B210 device has a power cable. We should keep that plugged in.*
*If we plugged off the USRP B210 power due to whatever reasons, we should push UHD image to USRP B210 device again by using `uhd_image_downloader` command.*

## Verification of UHD driver installation and UHD image push
In order to verify the UHD driver installation and UHD image push to the USRP B210 driver, we can use below command.
```bash
$ uhd_usrp_probe
[INFO] [UHD] linux; GNU C++ version 7.5.0; Boost_106501; UHD_3.15.0.0-release
[INFO] [B200] Detected Device: B210
[INFO] [B200] Operating over USB 2.
[INFO] [B200] Initialize CODEC control...
[INFO] [B200] Initialize Radio control...
[INFO] [B200] Performing register loopback test...
[INFO] [B200] Register loopback test passed
[INFO] [B200] Performing register loopback test...
[INFO] [B200] Register loopback test passed
[INFO] [B200] Setting master clock rate selection to 'automatic'.
[INFO] [B200] Asking for clock rate 16.000000 MHz...
[INFO] [B200] Actually got clock rate 16.000000 MHz.
  _____________________________________________________
 /
|       Device: B-Series Device
|     _____________________________________________________
|    /
|   |       Mboard: B210
|   |   serial: 31EABDC
|   |   name: MyB210
|   |   product: 2
|   |   revision: 4
|   |   FW Version: 8.0
|   |   FPGA Version: 16.0
|   |
|   |   Time sources:  none, internal, external, gpsdo
|   |   Clock sources: internal, external, gpsdo
|   |   Sensors: ref_locked
|   |     _____________________________________________________
|   |    /
|   |   |       RX DSP: 0
|   |   |
|   |   |   Freq range: -8.000 to 8.000 MHz
|   |     _____________________________________________________
|   |    /
|   |   |       RX DSP: 1
|   |   |
|   |   |   Freq range: -8.000 to 8.000 MHz
|   |     _____________________________________________________
|   |    /
|   |   |       RX Dboard: A
|   |   |     _____________________________________________________
|   |   |    /
|   |   |   |       RX Frontend: A
|   |   |   |   Name: FE-RX2
|   |   |   |   Antennas: TX/RX, RX2
|   |   |   |   Sensors: temp, rssi, lo_locked
|   |   |   |   Freq range: 50.000 to 6000.000 MHz
|   |   |   |   Gain range PGA: 0.0 to 76.0 step 1.0 dB
|   |   |   |   Bandwidth range: 200000.0 to 56000000.0 step 0.0 Hz
|   |   |   |   Connection Type: IQ
|   |   |   |   Uses LO offset: No
|   |   |     _____________________________________________________
|   |   |    /
|   |   |   |       RX Frontend: B
|   |   |   |   Name: FE-RX1
|   |   |   |   Antennas: TX/RX, RX2
|   |   |   |   Sensors: temp, rssi, lo_locked
|   |   |   |   Freq range: 50.000 to 6000.000 MHz
|   |   |   |   Gain range PGA: 0.0 to 76.0 step 1.0 dB
|   |   |   |   Bandwidth range: 200000.0 to 56000000.0 step 0.0 Hz
|   |   |   |   Connection Type: IQ
|   |   |   |   Uses LO offset: No
|   |   |     _____________________________________________________
|   |   |    /
|   |   |   |       RX Codec: A
|   |   |   |   Name: B210 RX dual ADC
|   |   |   |   Gain Elements: None
|   |     _____________________________________________________
|   |    /
|   |   |       TX DSP: 0
|   |   |
|   |   |   Freq range: -8.000 to 8.000 MHz
|   |     _____________________________________________________
|   |    /
|   |   |       TX DSP: 1
|   |   |
|   |   |   Freq range: -8.000 to 8.000 MHz
|   |     _____________________________________________________
|   |    /
|   |   |       TX Dboard: A
|   |   |     _____________________________________________________
|   |   |    /
|   |   |   |       TX Frontend: A
|   |   |   |   Name: FE-TX2
|   |   |   |   Antennas: TX/RX
|   |   |   |   Sensors: temp, lo_locked
|   |   |   |   Freq range: 50.000 to 6000.000 MHz
|   |   |   |   Gain range PGA: 0.0 to 89.8 step 0.2 dB
|   |   |   |   Bandwidth range: 200000.0 to 56000000.0 step 0.0 Hz
|   |   |   |   Connection Type: IQ
|   |   |   |   Uses LO offset: No
|   |   |     _____________________________________________________
|   |   |    /
|   |   |   |       TX Frontend: B
|   |   |   |   Name: FE-TX1
|   |   |   |   Antennas: TX/RX
|   |   |   |   Sensors: temp, lo_locked
|   |   |   |   Freq range: 50.000 to 6000.000 MHz
|   |   |   |   Gain range PGA: 0.0 to 89.8 step 0.2 dB
|   |   |   |   Bandwidth range: 200000.0 to 56000000.0 step 0.0 Hz
|   |   |   |   Connection Type: IQ
|   |   |   |   Uses LO offset: No
|   |   |     _____________________________________________________
|   |   |    /
|   |   |   |       TX Codec: A
|   |   |   |   Name: B210 TX dual DAC
|   |   |   |   Gain Elements: None
```

If we see the above results which shows the device name `B210`, we are good to go.

## Build OAI

The OAI repository (https://github.com/onosproject/openairinterface5g) used in this tutorial requires member-only access, a user should log in github and then check the git clone command on that web site.

After the USRP configuration, we should build the OAI code.
```bash
$ git clone https://github.com/onosproject/openairinterface5g
$ cd /path/to/openairinterface5g
$ source oaienv
$ cd cmake_targets/
$ ./build_oai -c -I --eNB --UE -w USRP -g --build-ric-agent
```

*NOTE: It takes really a long time to build OAI.*


## Configure CU-CP on the OAI NUC
After that, we should copy the sample CU-CP configuration file in the HOME directory.
```bash
$ cp /path/to/openairinterface5g/ci-scripts/conf_files/cu.band7.tm1.25PRB.conf ~/cu.onf.conf
```

Then, modify below parameters in the copied file `~/cu.onf.conf`:
```text
…
////////// RIC parameters:
RIC : {
    remote_ipv4_addr = "192.168.10.22";
    remote_port = 36421;
    enabled = "yes";
};
…

tracking_area_code = 1;
plmn_list = ( { mcc = 315; mnc = 010; mnc_length = 3; } )
…
    ////////// MME parameters:
    mme_ip_address  = (
      {
        ipv4       = "192.168.10.21";    // *Write down EPC-CORE SDRAN-in-a-Box IP*
        ipv6       = "192:168:30::17";  // *Don’t care*
        active     = "yes";
        preference = "ipv4";
      }
    );

    NETWORK_INTERFACES : {
      ENB_INTERFACE_NAME_FOR_S1_MME = "eno1";             // Ethernet interface name of OAI NUC
      ENB_IPV4_ADDRESS_FOR_S1_MME   = "192.168.13.21/16";  // OAI NUC IP address
      ENB_INTERFACE_NAME_FOR_S1U    = "eno1";             // Ethernet interface name of OAI NUC
      ENB_IPV4_ADDRESS_FOR_S1U      = "192.168.11.10/29";  // Write the secondary IP address which we set above
      ENB_PORT_FOR_S1U              = 2152; # Spec 2152   # Don't touch
      ENB_IPV4_ADDRESS_FOR_X2C      = "192.168.13.21/16";  // OAI NUC IP address
      ENB_PORT_FOR_X2C              = 36422; # Spec 36422 # Don't touch
    };
  }

```

## Configure DU on the OAI NUC
Likewise, we should copy the sample DU configuration file in the HOME directory.
```bash
$ cp /path/to/openairinterface5g/ci-scripts/conf_files/du.band7.tm1.25PRB.conf ~/du.onf.conf
```

And then, we should open the copied file `~/du.onf.conf` and change the blow variables:
```text
tracking_area_code = 1001;
plmn_list = ( { mcc = 315; mnc = 010; mnc_length = 3; } )
```

## Run CU and DU in the OAI-CU/DU machine

Before running CU and DU, make sure to follow the instructions provided at [Network Parameter Configuration](#network-parameter-configuration).

### Run CU-CP
On the OAI NUC machine, we should go to `/path/to/openairinterface5g/cmake_targets/ran_build/build` and run the command below:
```bash
ENODEB=1 sudo -E ./lte-softmodem -O ~/cu.onf.conf
```

### Run DU
After CU-CP is running, in another terminal we should go to `/path/to/openairinterface5g/cmake_targets/ran_build/build` and  run the command below:
```bash
while true; do ENODEB=1 sudo -E ./lte-softmodem -O ~/du.onf.conf; done
```

## Run the User Equipment (UE) on the OAI-UE machine

Write down a file named ~/sim.conf with the following content:

```text
# List of known PLMNS
PLMN: {
    PLMN0: {
           FULLNAME="Test network";
           SHORTNAME="OAI4G";
           MNC="01";
           MCC="001";

    };
    PLMN1: {
           FULLNAME="SFR France";
           SHORTNAME="SFR";
           MNC="10";
           MCC="208";

    };
    PLMN2: {
           FULLNAME="SFR France";
           SHORTNAME="SFR";
           MNC="11";
           MCC="208";
    };
    PLMN3: {
           FULLNAME="SFR France";
           SHORTNAME="SFR";
           MNC="13";
           MCC="208";
    };
    PLMN4: {
           FULLNAME="Aether";
           SHORTNAME="Aether";
           MNC="010";
           MCC="315";
    };
    PLMN5: {
           FULLNAME="T-Mobile USA";
           SHORTNAME="T-Mobile";
           MNC="280";
           MCC="310";
    };
    PLMN6: {
           FULLNAME="FICTITIOUS USA";
           SHORTNAME="FICTITIO";
           MNC="028";
           MCC="310";
    };
    PLMN7: {
           FULLNAME="Vodafone Italia";
           SHORTNAME="VODAFONE";
           MNC="10";
           MCC="222";
    };
    PLMN8: {
           FULLNAME="Vodafone Spain";
           SHORTNAME="VODAFONE";
           MNC="01";
           MCC="214";
    };
    PLMN9: {
           FULLNAME="Vodafone Spain";
           SHORTNAME="VODAFONE";
           MNC="06";
           MCC="214";
    };
    PLMN10: {
           FULLNAME="Vodafone Germ";
           SHORTNAME="VODAFONE";
           MNC="02";
           MCC="262";
    };
    PLMN11: {
           FULLNAME="Vodafone Germ";
           SHORTNAME="VODAFONE";
           MNC="04";
           MCC="262";
    };
};

UE0:
{
    USER: {
        IMEI="356113022094149";
        MANUFACTURER="EURECOM";
        MODEL="LTE Android PC";
        PIN="0000";
    };

    SIM: {
        MSIN="206000001";
        USIM_API_K="000102030405060708090a0b0c0d0e0f";
        OPC=       "69d5c2eb2e2e624750541d3bbc692ba5";
        MSISDN="1122334455";
    };

    # Home PLMN Selector with Access Technology
    HPLMN= "315010";

    # User controlled PLMN Selector with Access Technology
    UCPLMN_LIST = ();

    # Operator PLMN List
    OPLMN_LIST = ("00101", "20810", "20811", "20813", "315010", "310280", "310028");

    # Operator controlled PLMN Selector with Access Technology
    OCPLMN_LIST = ("22210", "21401", "21406", "26202", "26204");

    # Forbidden plmns
    FPLMN_LIST = ();

    # List of Equivalent HPLMNs
#TODO: UE does not connect if set, to be fixed in the UE
#    EHPLMN_LIST= ("20811", "20813");
    EHPLMN_LIST= ();
};

```

On the OAI-UE NUC machine, we should go to `/path/to/openairinterface5g/cmake_targets/ran_build/build`.

Then execute the command below to generate the UE settings.

```bash
../../nas_sim_tools/build/conf2uedata -c ~/sim.conf -o .
```

After that, initialize the UE process:

```bash
sudo ./lte-uesoftmodem -C 2630000000 -r 25 --ue-rxgain 120 --ue-txgain 0 --ue-max-power 0 --ue-scan-carrier --nokrnmod 1  2>&1 | tee UE.log
```
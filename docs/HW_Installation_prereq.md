<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Prerequisites

This section explains how to install the requirements needed for the execution of an OAI component in a host machine connected to a USRP.

In the case of the hardware installation tutorial using 2 NUCs, proceed with the execution of the steps below on both NUCs.

Before we start this section, we consider the host machine already have Ubuntu 18.04 server OS installed.
**Also, please DO NOT connect the USRP B210 device to the host machines yet.**
**Otherwise, the host machine may not boot up.**


## Install Linux Image low-latency

```bash
$ sudo apt install linux-image-lowlatency linux-headers-lowlatency
```

## Power management and CPU frequency configuration
To run on OAI, we must disable p-state and c-state in Linux.
Go to `/etc/default/grub` file and add change `GRUB_CMDLINE_LINUX_DEFAULT` line as below:
```text
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_pstate=disable processor.max_cstate=1 intel_idle.max_cstate=0 idle=poll"
```

After save that file, we should command this:
```bash
$ sudo update-grub2
```

Next, go to `/etc/modprobe.d/blacklist.conf` file and append below at the end of the file:
```text
# for OAI
blacklist intel_powerclamp
```

After that, reboot the NUC machine. When rebooting, we have to change the `BIOS` configuration.
Go to the BIOS setup page and change some parameters:
* Disable secure booting option
* Disable hyperthreading
* Enable virtualization
* Disable all power management functions (c-/p-state related)
* Enable real-time tuning and Intel Turbo boost
Once it is done, we should save and exit. Then, we reboot NUC board again.

When NUC is up and running, we should install the below tool:
```bash
$ sudo apt-get install cpufrequtils
```

After the installation, go to `/etc/default/cpufrequtils` and write below:
```text
GOVERNOR="performance"
```

*NOTE: If the `/etc/default/cpufrequtils` file does not exist, we should make that file.*

Next, we should command below:
```bash
$ sudo systemctl disable ondemand.service
$ sudo /etc/init.d/cpufrequtils restart
```

After that, we should reboot this machine again.

## Verification of the power management and CPU frequency configuration
In order to verify configurations for the power management and CPU frequency, we should use `i7z` tool.
```bash
$ sudo apt install i7z
$ sudo i7z
True Frequency (without accounting Turbo) 1607 MHz
  CPU Multiplier 16x || Bus clock frequency (BCLK) 100.44 MHz

Socket [0] - [physical cores=6, logical cores=6, max online cores ever=6]
  TURBO ENABLED on 6 Cores, Hyper Threading OFF
  Max Frequency without considering Turbo 1707.44 MHz (100.44 x [17])
  Max TURBO Multiplier (if Enabled) with 1/2/3/4/5/6 Cores is  47x/47x/41x/41x/39x/39x
  Real Current Frequency 3058.82 MHz [100.44 x 30.45] (Max of below)
        Core [core-id]  :Actual Freq (Mult.)      C0%   Halt(C1)%  C3 %   C6 %  Temp      VCore
        Core 1 [0]:       3058.81 (30.45x)       100       0       0       0    64      0.9698
        Core 2 [1]:       3058.82 (30.45x)       100       0       0       0    63      0.9698
        Core 3 [2]:       3058.82 (30.45x)       100       0       0       0    64      0.9698
        Core 4 [3]:       3058.81 (30.45x)       100       0       0       0    64      0.9698
        Core 5 [4]:       3058.81 (30.45x)       100       0       0       0    65      0.9698
        Core 6 [5]:       3058.82 (30.45x)       100       0       0       0    62      0.9686
```

In the above results, we have to see that all cores should get `C0%` as `100` and `Halt(C1)%` as `0`.
If not, some of the above configuration are missing.
Or, some of BIOS configurations are incorrect.

**The steps above conclude the installation of OAI/USRP requirements.**

**Now, please connect the USRP B210 device to the host machines (usb 3.0).**
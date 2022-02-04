<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Install OAI UE

This section explains how to execute only the OAI components using the RiaB Makefile.

Bofere proceeding, make sure you follow all the instructions on how to install the OAI/USRP requirements prerequisites in the NUC machines.

In the RiaB makefile targets are included options to execute OAI CU/DU/UE components using helm charts. Those steps do not require any source code compilation of OAI, the OAI components run in docker images and have their parameters configured by the sdran-in-a-box-values.yaml file.

**Notice: The sdran-in-a-box-values.yaml contain the latest versions/tags of the OAI docker images. In order to use the versions of the OAI docker images specified in RiaB v1.0.0 or v1.1.0 releases make sure to respectively copy and paste to the sdran-in-a-box-values.yaml file the contents of the files sdran-in-a-box-values-v1.0.0.yaml and sdran-in-a-box-values-v1.1.0.yaml as needed.**

## Update UE image tag in sdran-in-a-box-values-version.yaml file
In the `sdran-in-a-box-values-version.yaml` file, we can find `oai-ue` image tag. The `oai-ue` tag should be `sdran-1.1.2`:
```yaml
   oaicucp: docker.io/onosproject/oai-enb-cu:v0.1.6
   oaidu: docker.io/onosproject/oai-enb-du:v0.1.6
   oaiue: docker.io/onosproject/oai-ue:sdran-1.1.2
```

## Run OAI UE
```bash
$ cd /path/to/sdran-in-a-box
$ sudo apt install build-essential
$ make oai-ue-usrp
```

This step might take some time due to the download of the oai-ue docker image.
After the condition (pod/oai-ue-0 condition met) were achieved proceed to the next topic.

The pod pod/oai-ue-0 takes some time to start as it needs to configure the USRP first.


## Stop/Clean OAI components

After finishing the hardware installation setup procedures, run the command below to delete all deployed Helm charts for OAI UE component.

```bash
$ make reset-oai
```

And this deletes not only deployed Helm chart but also Kubernetes and Helm.

```bash
make clean      # if we want to keep the ~/helm-charts directory - option to develop/test changed/new Helm charts
make clean-all  # if we also want to delete ~/helm-charts directory
```

# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

# Directory arguments
SHELL						:= /bin/bash
RIABDIR						:= $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
WORKSPACE					?= $(RIABDIR)/workspace
M							?= $(WORKSPACE)/milestones
BUILD						?= $(WORKSPACE)/build
VENV						?= $(BUILD)/venv/riab
SCRIPTDIR					?= $(RIABDIR)/scripts
CHARTDIR					?= $(WORKSPACE)/helm-charts
AETHERCHARTDIR				?= $(CHARTDIR)/aether-helm-charts
SDRANCHARTDIR				?= $(CHARTDIR)/sdran-helm-charts
RESOURCEDIR					?= $(RIABDIR)/resources

# Commit IDs
AETHERCHARTCID				?= 6b3a267e428402d6bb8531bd921c1d202bb338b2
SDRANCHARTCID-LATEST		?= origin/master
SDRANCHARTCID-V1.0.0		?= v1.0.0 #branch: v1.0.0
SDRANCHARTCID-V1.1.0		?= 6670e6da25129b665b024a7c6d0fd79cfda52f25
SDRANCHARTCID-V1.1.1		?= 479ff0b59d4ae9f09cd9f7be6ea9a189f207b810
SDRANCHARTCID-V1.1.1-REV3	?= sd-ran-1.1.4-rev3
SDRANCHARTCID-V1.1.1-REV4	?= sd-ran-1.1.4-rev4

#  Helm arguments
DEFAULT_HELM_ARGS			:= --set import.ran-simulator.enabled=true --set import.onos-pci.enabled=true
HELM_ARGS					?= $(DEFAULT_HELM_ARGS)
HELM_ARGS_RANSIM			?= --set import.ran-simulator.enabled=true --set import.onos-pci.enabled=true
HELM_ARGS_OAI				?=
HELM_ARGS_RIC				?= --set import.onos-pci.enabled=false
HELM_ARGS_FBAH				?= --set import.fb-ah-xapp.enabled=true --set import.fb-ah-gui.enabled=true --set import.ah-eson-test-server.enabled=true --set import.ran-simulator.enabled=true

# Helm values file
DEFAULT_HELM_VALUES			:= $(RIABDIR)/sdran-in-a-box-values-master-stable.yaml
HELM_VALUES					?= $(DEFAULT_HELM_VALUES)
HELM_VALUES_V1.0.0			?= $(RIABDIR)/sdran-in-a-box-values-v1.0.0.yaml
HELM_VALUES_V1.1.0			?= $(RIABDIR)/sdran-in-a-box-values-v1.1.0.yaml
HELM_VALUES_V1.1.1			?= $(RIABDIR)/sdran-in-a-box-values-v1.1.1.yaml
HELM_VALUES_V1.1.1-REV3		?= $(RIABDIR)/sdran-in-a-box-values-v1.1.1-rev3.yaml
HELM_VALUES_V1.1.1-REV4		?= $(RIABDIR)/sdran-in-a-box-values-v1.1.1-rev4.yaml
HELM_VALUES_STABLE			?= $(RIABDIR)/sdran-in-a-box-values-master-stable.yaml
HELM_VALUES_LATEST			?= $(RIABDIR)/sdran-in-a-box-values.yaml
HELM_VALUES_DEV				?= $(RIABDIR)/sdran-in-a-box-values.yaml

# Options - ransim (by default), oai, ric, and fbah
DEFAULT_OPT					:= ransim
OPT							?= $(DEFAULT_OPT)

# Versions - v1.0.0, v1.1.0, v1.1.1, stable, latest, and dev
DEFAULT_VER					:= stable
VER							?= $(DEFAULT_VER)

# Default RiaB namespace
DEFAULT_RIAB_NAMESPACE		:= riab
RIAB_NAMESPACE				?= $(DEFAULT_RIAB_NAMESPACE)

# URLs
CORD_GERRIT_URL				?= https://gerrit.opencord.org
ONOS_GITHUB_URL				?= https://github.com/onosproject
HELM_INCUBATOR_URL			?= https://charts.helm.sh/incubator
HELM_OPENCORD_URL			?= https://charts.opencord.org
HELM_SDRAN_URL				?= https://sdrancharts.onosproject.org

# Infrastructure component version
KUBESPRAY_VERSION			?= release-2.14
DOCKER_VERSION				?= 19.03
K8S_VERSION					?= v1.18.9
HELM_VERSION				?= v3.2.4

# OMEC parameters
UE_IP_POOL					?= 172.250.0.0
UE_IP_MASK					?= 16

# For system check
CPU_FAMILY					:= $(shell lscpu | grep 'CPU family:' | awk '{print $$3}')
CPU_MODEL					:= $(shell lscpu | grep 'Model:' | awk '{print $$2}')
OS_VENDOR					:= $(shell lsb_release -i -s)
OS_RELEASE					:= $(shell lsb_release -r -s)

# For RIC
F1_CU_INTERFACE				:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
F1_CU_IPADDR				:= $(shell ip -4 a show $(F1_CU_INTERFACE) | grep inet | awk '{print $$2}' | awk -F '/' '{print $$1}' | tail -n 1)
F1_DU_INTERFACE				:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
F1_DU_IPADDR				:= $(shell ip -4 a show $(F1_DU_INTERFACE) | grep inet | awk '{print $$2}' | awk -F '/' '{print $$1}' | head -n 1)
S1MME_CU_INTERFACE			:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
NFAPI_DU_INTERFACE			:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
NFAPI_DU_IPADDR				:= $(shell ip -4 a show $(NFAPI_DU_INTERFACE) | grep inet | awk '{print $$2}' | awk -F '/' '{print $$1}' | tail -n 1)
NFAPI_UE_INTERFACE			:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
NFAPI_UE_IPADDR				:= $(shell ip -4 a show $(NFAPI_UE_INTERFACE) | grep inet | awk '{print $$2}' | awk -F '/' '{print $$1}' | tail -n 1)
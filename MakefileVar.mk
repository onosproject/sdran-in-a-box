# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

# Directory arguments
SHELL							:= /bin/bash
RIABDIR							:= $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
WORKSPACE						?= $(RIABDIR)/workspace
M								?= $(WORKSPACE)/milestones
BUILD							?= $(WORKSPACE)/build
VENV							?= $(BUILD)/venv/riab
SCRIPTDIR						?= $(RIABDIR)/scripts
CHARTDIR						?= $(WORKSPACE)/helm-charts
AETHERCHARTDIR					?= $(CHARTDIR)/aether-helm-charts
SDRANCHARTDIR					?= $(CHARTDIR)/sdran-helm-charts
RESOURCEDIR						?= $(RIABDIR)/resources

# Commit IDs
AETHERCHARTCID-V1.0.0			?= 6b3a267e428402d6bb8531bd921c1d202bb338b2
AETHERCHARTCID-V1.3.0			?= 9f79ab87a96ae9ee2bb9a1540f4cd1574261611b
AETHERCHARTCID-V1.4.0			?= 9f79ab87a96ae9ee2bb9a1540f4cd1574261611b
AETHERCHARTCID-LATEST			?= 9f79ab87a96ae9ee2bb9a1540f4cd1574261611b
SDRANCHARTCID-LATEST			?= origin/master
SDRANCHARTCID-E2AP101-LATEST	?= origin/e2ap101
SDRANCHARTCID-E2AP101-V1.3.0	?= sd-ran-1.2.129
SDRANCHARTCID-E2AP101-V1.4.0	?= sd-ran-1.2.129
SDRANCHARTCID-V1.0.0			?= v1.0.0 #branch: v1.0.0
SDRANCHARTCID-V1.1.0			?= 6670e6da25129b665b024a7c6d0fd79cfda52f25
SDRANCHARTCID-V1.1.1			?= origin/rel-1.1.1
SDRANCHARTCID-V1.2.0			?= origin/rel-1.2
SDRANCHARTCID-V1.3.0			?= origin/rel-1.3
SDRANCHARTCID-V1.4.0			?= sd-ran-1.4.2

#  Helm arguments
DEFAULT_HELM_ARGS				:= --set import.ran-simulator.enabled=true --set import.onos-pci.enabled=true
HELM_ARGS						?= $(DEFAULT_HELM_ARGS)
HELM_ARGS_RANSIM				?= --set import.ran-simulator.enabled=true --set import.onos-pci.enabled=true
HELM_ARGS_OAI					?= --set import.onos-rsm.enabled=true
HELM_ARGS_RIC					?= --set import.onos-pci.enabled=false --set import.onos-rsm.enabled=true
HELM_ARGS_RIC_E2AP101			?= --set import.onos-pci.enabled=false --set import.onos-rsm.enabled=true
HELM_ARGS_FBAH					?= --set import.fb-ah-xapp.enabled=true --set import.fb-ah-gui.enabled=true --set import.ah-eson-test-server.enabled=true --set import.ran-simulator.enabled=true --set import.fb-kpimon-xapp.enabled=true
HELM_ARGS_MLB       	        ?= --set import.ran-simulator.enabled=true --set import.onos-pci.enabled=true --set import.onos-mlb.enabled=true --set ran-simulator.pci.modelName=three-cell-n-node-model --set ran-simulator.pci.metricName=three-cell-n-node-metrics
HELM_ARGS_MHO           	    ?= --set import.ran-simulator.enabled=true --set import.onos-mho.enabled=true --set ran-simulator.pci.modelName=two-cell-two-node-model
HELM_ARGS_RIMEDOTS           	?= --set import.ran-simulator.enabled=true --set import.rimedo-ts.enabled=true --set ran-simulator.pci.modelName=two-cell-two-node-model

# Helm values file
DEFAULT_HELM_VALUES				:= $(RIABDIR)/sdran-in-a-box-values-master-stable.yaml
HELM_VALUES						?= $(DEFAULT_HELM_VALUES)
HELM_VALUES_V1.0.0				?= $(RIABDIR)/sdran-in-a-box-values-v1.0.0.yaml
HELM_VALUES_V1.1.0				?= $(RIABDIR)/sdran-in-a-box-values-v1.1.0.yaml
HELM_VALUES_V1.1.1				?= $(RIABDIR)/sdran-in-a-box-values-v1.1.1.yaml
HELM_VALUES_V1.2.0				?= $(RIABDIR)/sdran-in-a-box-values-v1.2.0.yaml
HELM_VALUES_V1.3.0				?= $(RIABDIR)/sdran-in-a-box-values-v1.3.0.yaml
HELM_VALUES_V1.4.0				?= $(RIABDIR)/sdran-in-a-box-values-v1.4.0.yaml
HELM_VALUES_STABLE				?= $(RIABDIR)/sdran-in-a-box-values-master-stable.yaml
HELM_VALUES_LATEST				?= $(RIABDIR)/sdran-in-a-box-values.yaml
HELM_VALUES_DEV					?= $(RIABDIR)/sdran-in-a-box-values.yaml

# Options - ransim (by default), oai, ric, and fbah
DEFAULT_OPT						:= ransim
OPT								?= $(DEFAULT_OPT)

# Versions - v1.0.0, v1.1.0, v1.1.1, v1.2.0, v1.3.0, v1.4.0, stable, latest, and dev
DEFAULT_VER						:= stable
VER								?= $(DEFAULT_VER)

# Default RiaB namespace
DEFAULT_RIAB_NAMESPACE			:= riab
RIAB_NAMESPACE					?= $(DEFAULT_RIAB_NAMESPACE)

# URLs
CORD_GERRIT_URL					?= https://gerrit.opencord.org
ONOS_GITHUB_URL					?= https://github.com/onosproject
HELM_INCUBATOR_URL				?= https://charts.helm.sh/incubator
HELM_OPENCORD_URL				?= https://charts.opencord.org
HELM_SDRAN_URL					?= https://sdrancharts.onosproject.org

# Infrastructure component version
KUBESPRAY_VERSION				?= release-2.18
DOCKER_VERSION					?= '20.10'
K8S_VERSION						?= v1.20.11
HELM_VERSION					?= v3.7.1

# OMEC parameters
UE_IP_POOL						?= 172.250.0.0
UE_IP_MASK						?= 16
STATIC_UE_IP_POOL				?= 172.249.0.0
STATIC_UE_IP_MASK				?= 16

# For system check
CPU_VENDOR						:= $(shell lscpu | grep 'Vendor ID:' | awk '{print $$3}')
CPU_FAMILY						:= $(shell lscpu | grep 'CPU family:' | awk '{print $$3}')
CPU_MODEL						:= $(shell lscpu | grep 'Model:' | awk '{print $$2}')
OS_VENDOR						:= $(shell lsb_release -i -s)
OS_RELEASE						:= $(shell lsb_release -r -s)

# For RIC
E2_F1_CU_INTERFACE				:= cu_e2f1_if
E2_F1_CU_IPADDR					:= 192.168.200.21/24
E2_F1_DU_INTERFACE				:= du_e2f1_if
E2_F1_DU_IPADDR					:= 192.168.200.22/24
S1MME_CU_INTERFACE				:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
NFAPI_DU_INTERFACE				:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
NFAPI_DU_IPADDR					:= $(shell ip -4 a show $(NFAPI_DU_INTERFACE) | grep inet | awk '{print $$2}' | awk -F '/' '{print $$1}' | tail -n 1)
NFAPI_UE_INTERFACE				:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
NFAPI_UE_IPADDR					:= $(shell ip -4 a show $(NFAPI_UE_INTERFACE) | grep inet | awk '{print $$2}' | awk -F '/' '{print $$1}' | tail -n 1)
E2T_NODEPORT_INTERFACE			:= e2t_e2_if
E2T_NODEPORT_IPADDR				:= 192.168.200.11/24
E2_F1_BRIDGE_NAME				:= br-e2f1-net

# For routing configuarion
ENB_SUBNET	            	    := 192.168.251.0/24
ENB_GATEWAY 	                := 192.168.251.1/24
ACCESS_SUBNET   	            := 192.168.252.0/24
UPF_ACCESS_NET_IP   	        := 192.168.252.3/24
ACCESS_GATEWAY		            := 192.168.252.1/24
CORE_SUBNET     	            := 192.168.250.0/24
UPF_CORE_NET_IP     	        := 192.168.250.3/24
CORE_GATEWAY            	    := 192.168.250.1/24
OAI_ENB_NET_IP	    	        := 192.168.251.5/24
OAI_MACHINE_IP  	            := 192.168.254.1/24 # It's dummy IP address. It should be changed to appropriate routable IP address for OAI machine
OAI_ENB_NET_INTERFACE		    := $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
OMEC_ENB_NET_IP         	    := 192.168.251.4/24
OMEC_DEFAULT_INTERFACE      	:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
OMEC_MACHINE_IP	            	:= 192.168.254.2/24 # It's dummy IP address. It should be changed to appropriate routable IP address for OMEC machine
RIC_MACHINE_IP					:= 192.168.254.3/24 # It's dummy IP address. It should be changed to appropriate routable IP address for RIC machine
RIC_DEFAULT_IP					:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')

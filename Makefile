# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

SHELL				:= /bin/bash
BUILD				?= /tmp/build
M					?= $(BUILD)/milestones
RIABDIR				:= $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
WORKSPACE			?= $(HOME)
SCRIPTDIR			?= $(RIABDIR)/scripts
RESOURCEDIR			?= $(RIABDIR)/resources
VENV				?= $(BUILD)/venv/riab
RIABVALUES			?= $(RIABDIR)/sdran-in-a-box-values.yaml
RIABVALUES-LATEST	?= $(RIABDIR)/sdran-in-a-box-values.yaml
RIABVALUES-V1.0.0	?= $(RIABDIR)/sdran-in-a-box-values-v1.0.0.yaml
RIABVALUES-MS		?= $(RIABDIR)/sdran-in-a-box-values-master-stable.yaml
CHARTDIR			?= $(WORKSPACE)/helm-charts
AETHERCHARTDIR		?= $(CHARTDIR)/aether-helm-charts
AETHERCHARTCID		?= 6b3a267e428402d6bb8531bd921c1d202bb338b2
SDRANCHARTDIR		?= $(CHARTDIR)/sdran-helm-charts
SDRANCHARTCID-LATEST	?= origin/master
SDRANCHARTCID-V1.0.0	?= v1.0.0#branch: v1.0.0

KUBESPRAY_VERSION	?= release-2.14
DOCKER_VERSION		?= 19.03
K8S_VERSION			?= v1.18.9
HELM_VERSION		?= v3.2.4

HELM_GLOBAL_ARGS	?=
HELM_NEM_ARGS		?= $(HELM_GLOBAL_ARGS)
HELM_ONOS_ARGS		?= $(HELM_GLOBAL_ARGS)

CORD_GERRIT_URL ?= https://gerrit.opencord.org
ONOS_GITHUB_URL ?= https://github.com/onosproject

UE_IP_POOL			?= 172.250.0.0
UE_IP_MASK			?= 16

RIAB_OPTION			?=
# If we want to use different namespace, feel free to change it.
# However, the overriding value file, sdran-in-a-box-values.yaml, should be changed as well - config.hss.mmes section.
RIAB_NAMESPACE		?= riab
RANSIM_ARGS			?= --set import.ran-simulator.enabled=true

F1_CU_INTERFACE		:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
F1_CU_IPADDR		:= $(shell ip -4 a show $(F1_CU_INTERFACE) | grep inet | awk '{print $$2}' | awk -F '/' '{print $$1}' | tail -n 1)
F1_DU_INTERFACE		:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
F1_DU_IPADDR		:= $(shell ip -4 a show $(F1_DU_INTERFACE) | grep inet | awk '{print $$2}' | awk -F '/' '{print $$1}' | head -n 1)
S1MME_CU_INTERFACE	:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
NFAPI_DU_INTERFACE	:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
NFAPI_DU_IPADDR		:= $(shell ip -4 a show $(NFAPI_DU_INTERFACE) | grep inet | awk '{print $$2}' | awk -F '/' '{print $$1}' | head -n 1)
NFAPI_UE_INTERFACE	:= $(shell ip -4 route list default | awk -F 'dev' '{ print $$2; exit }' | awk '{ print $$1 }')
NFAPI_UE_IPADDR		:= $(shell ip -4 a show $(NFAPI_UE_INTERFACE) | grep inet | awk '{print $$2}' | awk -F '/' '{print $$1}' | head -n 1)

cpu_family	:= $(shell lscpu | grep 'CPU family:' | awk '{print $$3}')
cpu_model	:= $(shell lscpu | grep 'Model:' | awk '{print $$2}')
os_vendor	:= $(shell lsb_release -i -s)
os_release	:= $(shell lsb_release -r -s)

.PHONY: riab-oai riab-ransim riab-oai-latest riab-oai-v1.0.0 riab-ransim-latest riab-ransim-v1.0.0 riab-oai-master-stable riab-ransim-master-stable set-option-oai set-option-ransim set-stable-aether-chart set-latest-sdran-chart set-v1.0.0-sdran-chart set-latest-riab-values set-v1.0.0-riab-values set-master-stable-riab-values fetch-all-charts omec oai oai-enb-cu oai-enb-du oai-ue ric atomix test-user-plane test-kpimon reset-oai reset-omec reset-atomix reset-ric reset-oai-test reset-ransim-test reset-test clean

riab-oai: set-option-oai $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-latest-sdran-chart set-latest-riab-values omec ric oai
riab-ransim: set-option-ransim $(M)/system-check $(M)/helm-ready set-latest-sdran-chart set-latest-riab-values ric

riab-oai-latest: riab-oai
riab-ransim-latest: riab-ransim

riab-oai-v1.0.0: set-option-oai $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-v1.0.0-sdran-chart set-v1.0.0-riab-values omec ric oai
riab-ransim-v1.0.0: set-option-ransim $(M)/system-check $(M)/helm-ready set-v1.0.0-sdran-chart set-v1.0.0-riab-values ric

riab-oai-dev: set-option-oai $(M)/system-check $(M)/helm-ready set-latest-riab-values omec ric oai
riab-ransim-dev: set-option-ransim $(M)/system-check $(M)/helm-ready set-latest-riab-values ric

oai-enb-usrp: set-option-oai $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-latest-sdran-chart set-latest-riab-values $(M)/oai-enb-cu-hw $(M)/oai-enb-du
oai-ue-usrp: set-option-oai $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-latest-sdran-chart set-latest-riab-values $(M)/oai-ue
ric-oai-latest: set-option-oai set-latest-sdran-chart set-latest-riab-values ric

riab-oai-master-stable: set-option-oai $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-latest-sdran-chart set-master-stable-riab-values omec ric oai
riab-ransim-master-stable: set-option-oai $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-latest-sdran-chart set-master-stable-riab-values ric

omec: $(M)/omec
oai: set-option-oai $(M)/oai-enb-cu $(M)/oai-enb-du $(M)/oai-ue
oai-enb-cu: set-option-oai $(M)/oai-enb-cu
oai-enb-du: set-option-oai $(M)/oai-enb-du
oai-ue: set-option-oai $(M)/oai-ue
ric: $(M)/ric
atomix: $(M)/atomix

set-option-oai:
	$(eval RIAB_OPTION="oai")
	$(eval RANSIM_ARGS=)

set-option-ransim:
	$(eval RIAB_OPTION="ransim")

set-stable-aether-chart:
	cd $(AETHERCHARTDIR); \
	git checkout $(AETHERCHARTCID);

set-latest-sdran-chart:
	cd $(SDRANCHARTDIR); \
	git checkout $(SDRANCHARTCID-LATEST)

set-v1.0.0-sdran-chart:
	cd $(SDRANCHARTDIR); \
	git fetch origin $(SDRANCHARTCID-V1.0.0); \
	git checkout $(SDRANCHARTCID-V1.0.0)

set-latest-riab-values:
	$(eval RIABVALUES=$(RIABVALUES-LATEST))

set-v1.0.0-riab-values:
	$(eval RIABVALUES=$(RIABVALUES-V1.0.0))

set-master-stable-riab-values:
	$(eval RIABVALUES=$(RIABVALUES-MS))

fetch-all-charts:
	cd $(AETHERCHARTDIR); \
	git fetch --all; \
	cd $(SDRANCHARTDIR); \
	git fetch --all;

$(M):
	mkdir -p $(M)

$(M)/repos: | $(M)
	mkdir -p $(CHARTDIR)
	cd $(CHARTDIR)
	@if [[ ! -d "$(AETHERCHARTDIR)" ]]; then \
                echo "aether-helm-chart repo is not in $(CHARTDIR) directory. Start to clone - it requires HTTPS key"; \
				git clone $(CORD_GERRIT_URL)/aether-helm-charts $(AETHERCHARTDIR); \
				cd $(AETHERCHARTDIR); \
				git checkout $(AETHERCHARTCID); \
	fi
	@if [[ ! -d "$(SDRANCHARTDIR)" ]]; then \
                echo "sdran-helm-chart repo is not in $(CHARTDIR) directory. Start to clone - it requires Github credential"; \
				git clone $(ONOS_GITHUB_URL)/sdran-helm-charts $(SDRANCHARTDIR) || true; \
	fi
	touch $@

$(M)/system-check: | $(M) $(M)/repos
	@if [[ $(cpu_family) -eq 6 ]]; then \
		if [[ $(cpu_model) -lt 60 ]]; then \
			echo "FATAL: haswell CPU or newer is required."; \
			exit 1; \
		fi \
	else \
		echo "FATAL: unsupported CPU family."; \
		exit 1; \
	fi
	@if [[ $(os_vendor) =~ (Ubuntu) ]]; then \
		if [[ ! $(os_release) =~ (18.04) ]] && [[ ! $(os_release) =~ (20.04) ]]; then \
			echo "WARN: $(os_vendor) $(os_release) has not been tested."; \
		fi; \
		if dpkg --compare-versions 4.15 gt $(shell uname -r); then \
			echo "FATAL: kernel 4.15 or later is required."; \
			echo "Please upgrade your kernel by running" \
			"apt install --install-recommends linux-generic-hwe-$(os_release)"; \
			exit 1; \
		fi \
	else \
		echo "FAIL: unsupported OS."; \
		exit 1; \
	fi
	@if [[ ! -d "$(AETHERCHARTDIR)" ]]; then \
                echo "FATAL: Please manually clone aether-helm-chart under $(CHARTDIR) directory."; \
                exit 1; \
	fi
	@if [[ ! -d "$(SDRANCHARTDIR)" ]]; then \
                echo "FATAL: Please manually clone sdran-helm-chart under $(CHARTDIR) directory."; \
                exit 1; \
	fi
	touch $@

$(M)/setup: | $(M) $(M)/system-check
	sudo $(SCRIPTDIR)/cloudlab-disksetup.sh
	sudo apt update; sudo apt install -y software-properties-common python3-pip jq httpie ipvsadm
	touch $@

$(BUILD)/kubespray: | $(M)/setup
	mkdir -p $(BUILD)
	cd $(BUILD); git clone https://github.com/kubernetes-incubator/kubespray.git -b $(KUBESPRAY_VERSION)

$(VENV)/bin/activate: | $(M)/setup
	sudo pip3 install virtualenv
	virtualenv $(VENV)

$(M)/kubespray-requirements: $(BUILD)/kubespray | $(VENV)/bin/activate
	source "$(VENV)/bin/activate" && \
	pip3 install -r $(BUILD)/kubespray/requirements.txt
	touch $@

$(M)/k8s-ready: | $(M)/setup $(BUILD)/kubespray $(VENV)/bin/activate $(M)/kubespray-requirements
	source "$(VENV)/bin/activate" && cd $(BUILD)/kubespray; \
	ansible-playbook -b -i inventory/local/hosts.ini \
		-e "{'override_system_hostname' : False, 'disable_swap' : True}" \
		-e "{'docker_version' : $(DOCKER_VERSION)}" \
		-e "{'docker_iptables_enabled' : True}" \
		-e "{'kube_version' : $(K8S_VERSION)}" \
		-e "{'kube_network_plugin_multus' : True, 'multus_version' : stable, 'multus_cni_version' : 0.3.1}" \
		-e "{'kube_proxy_metrics_bind_address' : '0.0.0.0:10249'}" \
		-e "{'kube_pods_subnet' : 192.168.0.0/17, 'kube_service_addresses' : 192.168.128.0/17}" \
		-e "{'kube_apiserver_node_port_range' : 2000-36767}" \
		-e "{'kubeadm_enabled': True}" \
		-e "{'kube_feature_gates' : [SCTPSupport=True]}" \
		-e "{'kubelet_custom_flags' : [--allowed-unsafe-sysctls=net.*]}" \
		-e "{'dns_min_replicas' : 1}" \
		-e "{'helm_enabled' : True, 'helm_version' : $(HELM_VERSION)}" \
		cluster.yml
	mkdir -p $(HOME)/.kube
	sudo cp -f /etc/kubernetes/admin.conf $(HOME)/.kube/config
	sudo chown $(shell id -u):$(shell id -g) $(HOME)/.kube/config
	kubectl wait pod -n kube-system --for=condition=Ready --all
	kubectl get namespace $(RIAB_NAMESPACE) 2> /dev/null || kubectl create namespace $(RIAB_NAMESPACE)
	touch $@

$(M)/helm-ready: | $(M)/k8s-ready
	helm repo add incubator https://charts.helm.sh/incubator
	helm repo add cord https://charts.opencord.org
	@if [ "$$SDRAN_USERNAME" == "" ]; then read -r -p "Username for ONF SDRAN private chart: " SDRAN_USERNAME; \
	read -r -p "Password for ONF SDRAN private chart: " SDRAN_PASSWORD; fi ;\
	helm repo add sdran https://sdrancharts.onosproject.org --username $$SDRAN_USERNAME --password $$SDRAN_PASSWORD;
	touch $@

/opt/cni/bin/simpleovs: | $(M)/k8s-ready
	sudo cp $(RESOURCEDIR)/simpleovs /opt/cni/bin/

/opt/cni/bin/static: | $(M)/k8s-ready
	mkdir -p $(BUILD)/cni-plugins; cd $(BUILD)/cni-plugins; \
	wget https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz && \
	tar xvfz cni-plugins-linux-amd64-v0.8.2.tgz
	sudo cp $(BUILD)/cni-plugins/static /opt/cni/bin/

$(M)/fabric: | $(M)/setup /opt/cni/bin/simpleovs /opt/cni/bin/static
	sudo apt install -y openvswitch-switch
	sudo ovs-vsctl --may-exist add-br br-enb-net
	sudo ovs-vsctl --may-exist add-port br-enb-net enb -- set Interface enb type=internal
	sudo ip addr add 192.168.251.4/24 dev enb || true
	sudo ip link set enb up
	sudo ethtool --offload enb tx off
	sudo ip route replace 192.168.252.0/24 via 192.168.251.1 dev enb
	kubectl apply -f $(RESOURCEDIR)/router.yaml
	kubectl wait pod -n default --for=condition=Ready -l app=router --timeout=300s
	kubectl -n default exec router ip route add $(UE_IP_POOL)/$(UE_IP_MASK) via 192.168.250.3
	touch $@

$(M)/atomix: | $(M)/helm-ready
	kubectl get po -n kube-system | grep atomix-controller | grep -v Terminating || kubectl create -f https://raw.githubusercontent.com/atomix/kubernetes-controller/master/deploy/atomix-controller.yaml
	kubectl get po -n kube-system | grep raft-storage-controller | grep -v Terminating || kubectl create -f https://raw.githubusercontent.com/atomix/raft-storage-controller/master/deploy/raft-storage-controller.yaml
	kubectl get po -n kube-system | grep cache-storage-controller | grep -v Terminating || kubectl create -f https://raw.githubusercontent.com/atomix/cache-storage-controller/master/deploy/cache-storage-controller.yaml
	touch $@

$(M)/ric: | $(M)/helm-ready $(M)/atomix
	kubectl get po -n kube-system | grep config-operator | grep -v Terminating || kubectl create -f https://raw.githubusercontent.com/onosproject/onos-operator/v0.4.0/deploy/onos-operator.yaml && \
	kubectl wait pod -n kube-system --for=condition=Ready -l name=config-operator --timeout=300s && \
	kubectl wait pod -n kube-system --for=condition=Ready -l name=topo-operator --timeout=300s
	kubectl get namespace $(RIAB_NAMESPACE) 2> /dev/null || kubectl create namespace $(RIAB_NAMESPACE)
	cd $(SDRANCHARTDIR)/sd-ran; helm dep update
	helm upgrade --install $(HELM_GLOBAL_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(RIABVALUES) \
		$(RANSIM_ARGS) \
		sd-ran \
		$(SDRANCHARTDIR)/sd-ran && \
	kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l app=onos --timeout=300s
	touch $@

$(M)/omec: | $(M)/helm-ready $(M)/fabric
	kubectl get namespace $(RIAB_NAMESPACE) 2> /dev/null || kubectl create namespace $(RIAB_NAMESPACE)
	helm repo update
	helm dep up $(AETHERCHARTDIR)/omec/omec-control-plane
	helm upgrade --install $(HELM_GLOBAL_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(RIABVALUES) \
		--set config.spgwc.ueIpPool.ip=$(UE_IP_POOL) \
		omec-control-plane \
		$(AETHERCHARTDIR)/omec/omec-control-plane && \
	kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=omec-control-plane --timeout=300s && \
	helm upgrade --install $(HELM_GLOBAL_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(RIABVALUES) \
		omec-user-plane \
		$(AETHERCHARTDIR)/omec/omec-user-plane && \
	kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=omec-user-plane --timeout=300s
	touch $@

$(M)/oai-enb-cu: | $(M)/helm-ready $(M)/ric
	$(eval e2t_addr=$(shell  kubectl get svc onos-e2t -n $(RIAB_NAMESPACE) --no-headers | awk '{print $$3'}))
	helm upgrade --install $(HELM_GLOBAL_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(RIABVALUES) \
		--set config.oai-enb-cu.networks.s1mme.interface=$(S1MME_CU_INTERFACE) \
		--set config.onos-e2t.networks.e2.address=$(e2t_addr) \
		--set config.oai-enb-cu.networks.f1.interface=$(F1_CU_INTERFACE) \
		--set config.oai-enb-cu.networks.f1.address=$(F1_CU_IPADDR) \
		--set config.oai-enb-du.networks.f1.interface=$(F1_DU_INTERFACE) \
		--set config.oai-enb-du.networks.f1.address=$(F1_DU_IPADDR) \
		oai-enb-cu \
		$(SDRANCHARTDIR)/oai-enb-cu && \
		kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=oai-enb-cu --timeout=100s && \
		sleep 10
	touch $@

$(M)/oai-enb-cu-hw: | $(M)/helm-ready
	helm upgrade --install $(HELM_GLOBAL_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(RIABVALUES) \
		--set config.oai-enb-cu.networks.s1mme.interface=$(S1MME_CU_INTERFACE) \
		--set config.oai-enb-cu.networks.f1.interface=$(F1_CU_INTERFACE) \
		--set config.oai-enb-cu.networks.f1.address=$(F1_CU_IPADDR) \
		--set config.oai-enb-du.networks.f1.interface=$(F1_DU_INTERFACE) \
		--set config.oai-enb-du.networks.f1.address=$(F1_DU_IPADDR) \
		oai-enb-cu \
		$(SDRANCHARTDIR)/oai-enb-cu && \
		kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=oai-enb-cu --timeout=100s && \
		sleep 10
	touch $@

$(M)/oai-enb-du: | $(M)/helm-ready
	helm upgrade --install $(HELM_GLOBAL_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(RIABVALUES) \
		--set config.oai-enb-cu.networks.f1.interface=$(F1_CU_INTERFACE) \
		--set config.oai-enb-cu.networks.f1.address=$(F1_CU_IPADDR) \
		--set config.oai-enb-du.networks.f1.interface=$(F1_DU_INTERFACE) \
		--set config.oai-enb-du.networks.f1.address=$(F1_DU_IPADDR) \
		--set config.oai-enb-du.networks.nfapi.interface=$(NFAPI_DU_INTERFACE) \
		--set config.oai-enb-du.networks.nfapi.address=$(NFAPI_DU_IPADDR) \
		--set config.oai-ue.networks.nfapi.interface=$(NFAPI_UE_INTERFACE) \
		--set config.oai-ue.networks.nfapi.address=$(NFAPI_UE_IPADDR) \
		oai-enb-du \
		$(SDRANCHARTDIR)/oai-enb-du && \
		kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=oai-enb-du --timeout=100s && \
		sleep 10
	touch $@

$(M)/oai-ue: | $(M)/helm-ready
	helm upgrade --install $(HELM_GLOBAL_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(RIABVALUES) \
		--set config.oai-enb-du.networks.nfapi.interface=$(NFAPI_DU_INTERFACE) \
		--set config.oai-enb-du.networks.nfapi.address=$(NFAPI_DU_IPADDR) \
		--set config.oai-ue.networks.nfapi.interface=$(NFAPI_UE_INTERFACE) \
		--set config.oai-ue.networks.nfapi.address=$(NFAPI_UE_IPADDR) \
		oai-ue \
		$(SDRANCHARTDIR)/oai-ue && \
		kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=oai-ue --timeout=100s && \
		sleep 10
	touch $@

test-user-plane: | $(M)/omec $(M)/oai-ue
	@echo "*** T1: Internal network test: ping 192.168.250.1 (Internal router IP) ***"; \
	ping -c 3 192.168.250.1 -I oaitun_ue1; \
	echo "*** T2: Internet connectivity test: ping to 8.8.8.8 ***"; \
	ping -c 3 8.8.8.8 -I oaitun_ue1; \
	echo "*** T3: DNS test: ping to google.com ***"; \
	ping -c 3 google.com -I oaitun_ue1;

test-kpimon: | $(M)/ric
	@echo "*** Get KPIMON result through CLI ***"; \
	kubectl exec -it deploy/onos-cli -n riab -- onos kpimon list numues;

detach-ue: | $(M)/oai-enb-cu $(M)/oai-enb-du $(M)/oai-ue
	echo -en "AT+CPIN=0000\r" | nc -u -w 1 localhost 10000
	echo -en "AT+CGATT=0\r" | nc -u -w 1 localhost 10000

reset-oai:
	helm delete -n $(RIAB_NAMESPACE) oai-enb-cu || true
	helm delete -n $(RIAB_NAMESPACE) oai-enb-du || true
	helm delete -n $(RIAB_NAMESPACE) oai-ue || true
	rm -f $(M)/oai-enb-cu*
	rm -f $(M)/oai-enb-du
	rm -f $(M)/oai-ue

reset-omec:
	helm delete -n $(RIAB_NAMESPACE) omec-control-plane || true
	helm delete -n $(RIAB_NAMESPACE) omec-user-plane || true
	cd $(M); rm -f omec

reset-atomix:
	kubectl delete -f https://raw.githubusercontent.com/atomix/raft-storage-controller/master/deploy/raft-storage-controller.yaml || true
	kubectl delete -f https://raw.githubusercontent.com/atomix/cache-storage-controller/master/deploy/cache-storage-controller.yaml || true
	kubectl delete -f https://raw.githubusercontent.com/atomix/kubernetes-controller/master/deploy/atomix-controller.yaml || true
	cd $(M); rm -f atomix

reset-ric:
	helm delete -n $(RIAB_NAMESPACE) sd-ran || true
	kubectl delete -f https://raw.githubusercontent.com/onosproject/onos-operator/v0.4.0/deploy/onos-operator.yaml || true
	@until [ $$(kubectl get po -n $(RIAB_NAMESPACE) -l app=onos --no-headers | wc -l) == 0 ]; do sleep 1; done
	@until [ $$(kubectl get po -n kube-system -l name=topo-operator --no-headers | wc -l) == 0 ]; do sleep 1; done
	@until [ $$(kubectl get po -n kube-system -l name=config-operator --no-headers | wc -l) == 0 ]; do sleep 1; done
	cd $(M); rm -f ric

reset-oai-test: reset-omec reset-oai reset-ric

reset-ransim-test: reset-ric

reset-test: reset-oai-test reset-ransim-test reset-atomix

clean: reset-test
	helm repo remove sdran || true
	kubectl delete po router || true
	kubectl delete net-attach-def core-net || true
	sudo ovs-vsctl del-br br-access-net || true
	sudo ovs-vsctl del-br br-core-net || true
	sudo apt remove --purge openvswitch-switch -y || true
	source "$(VENV)/bin/activate" && cd $(BUILD)/kubespray; \
	ansible-playbook --extra-vars "reset_confirmation=yes" -b -i inventory/local/hosts.ini reset.yml || true
	@if [ -d /usr/local/etc/emulab ]; then \
		mount | grep /mnt/extra/kubelet/pods | cut -d" " -f3 | sudo xargs umount; \
		sudo rm -rf /mnt/extra/kubelet; \
	fi
	rm -rf $(M)

clean-all: clean
	rm -rf $(CHARTDIR)

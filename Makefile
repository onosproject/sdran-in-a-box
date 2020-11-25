# Copyright 2020-present Open Networking Foundation
#
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
CHARTDIR			?= $(WORKSPACE)/helm-charts
AETHERCHARTDIR		?= $(CHARTDIR)/aether-helm-charts
SDRANCHARTDIR		?= $(CHARTDIR)/sdran-helm-charts
OAICHARTDIR			?= $(CHARTDIR)/sdran-helm-charts

KUBESPRAY_VERSION	?= release-2.14
DOCKER_VERSION		?= 19.03
K8S_VERSION			?= v1.18.9
HELM_VERSION		?= v3.2.4

HELM_GLOBAL_ARGS	?=
HELM_NEM_ARGS		?= $(HELM_GLOBAL_ARGS)
HELM_ONOS_ARGS		?= $(HELM_GLOBAL_ARGS)

cpu_family	:= $(shell lscpu | grep 'CPU family:' | awk '{print $$3}')
cpu_model	:= $(shell lscpu | grep 'Model:' | awk '{print $$2}')
os_vendor	:= $(shell lsb_release -i -s)
os_release	:= $(shell lsb_release -r -s)

.PHONY: riab clean

riab: $(M)/system-check $(M)/helm-ready $(M)/oai-ue

$(M):
	mkdir -p $(M)

$(M)/system-check: | $(M)
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
                echo "FATAL: Please clone aether-helm-charts under $(CHARTDIR) directory."; \
                exit 1; \
	fi
	@if [[ ! -d "$(SDRANCHARTDIR)" ]]; then \
                echo "FATAL: Please clone sdran-helm-charts under $(CHARTDIR) directory."; \
                exit 1; \
	fi
	touch $@

	@if [[ ! -d "$(OAICHARTDIR)" ]]; then \
                echo "FATAL: Please clone oai-helm-charts under $(CHARTDIR) directory."; \
                exit 1; \
	fi
	touch $@

$(M)/setup: | $(M)
	sudo $(SCRIPTDIR)/cloudlab-disksetup.sh
	sudo apt update; sudo apt install -y software-properties-common python-pip jq httpie ipvsadm
	sudo ip a add 127.0.0.2/8 dev lo | true
	sudo ip a add 127.0.0.3/8 dev lo | true
	sudo ip a add 127.0.0.4/8 dev lo | true
	touch $@

$(BUILD)/kubespray: | $(M)/setup
	mkdir -p $(BUILD)
	cd $(BUILD); git clone https://github.com/kubernetes-incubator/kubespray.git -b $(KUBESPRAY_VERSION)

$(VENV)/bin/activate: | $(M)/setup
	sudo pip install virtualenv
	virtualenv $(VENV)

$(M)/kubespray-requirements: $(BUILD)/kubespray | $(VENV)/bin/activate
	source "$(VENV)/bin/activate" && \
	pip install -r $(BUILD)/kubespray/requirements.txt
	touch $@

$(M)/k8s-ready: | $(M)/setup $(BUILD)/kubespray $(VENV)/bin/activate $(M)/kubespray-requirements
	source "$(VENV)/bin/activate" && cd $(BUILD)/kubespray; \
	ansible-playbook -b -i inventory/local/hosts.ini \
		-e "{'override_system_hostname' : False, 'disable_swap' : True}" \
		-e "{'docker_version' : $(DOCKER_VERSION)}" \
		-e "{'docker_iptables_enabled' : True}" \
		-e "{'kube_version' : $(K8S_VERSION)}" \
		-e "{'kube_network_plugin_multus' : True, 'multus_version' : stable, 'multus_cni_version' : 0.3.1}" \
		-e "{'kube_proxy_metrics_bind_address' : 0.0.0.0:10249}" \
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
	touch $@

$(M)/helm-ready: | $(M)/k8s-ready
	helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
	helm repo add cord https://charts.opencord.org
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
	kubectl -n default exec router ip route add 10.250.0.0/16 via 192.168.250.3
	kubectl delete net-attach-def core-net
	touch $@

$(M)/omec: | $(M)/helm-ready $(M)/fabric
	kubectl get namespace omec 2> /dev/null || kubectl create namespace omec
	helm repo update
	helm dep up $(AETHERCHARTDIR)/omec/omec-control-plane
	helm upgrade --install $(HELM_GLOBAL_ARGS) \
		--namespace omec \
		--values $(RIABVALUES) \
		omec-control-plane \
		$(AETHERCHARTDIR)/omec/omec-control-plane && \
	kubectl wait pod -n omec --for=condition=Ready -l release=omec-control-plane --timeout=300s && \
	helm upgrade --install $(HELM_GLOBAL_ARGS) \
		--namespace omec \
		--values $(RIABVALUES) \
		omec-user-plane \
		$(AETHERCHARTDIR)/omec/omec-user-plane && \
	kubectl wait pod -n omec --for=condition=Ready -l release=omec-user-plane --timeout=300s
	touch $@

$(M)/oai-enb-cu: | $(M)/omec
	helm upgrade --install $(HELM_GLOBAL_ARGS) \
		--namespace omec \
		--values $(RIABVALUES) \
		oai-enb-cu \
		$(OAICHARTDIR)/oai-enb-cu && \
		kubectl wait pod -n omec --for=condition=Ready -l release=oai-enb-cu --timeout=100s
	touch $@

$(M)/oai-enb-du: | $(M)/oai-enb-cu
	helm upgrade --install $(HELM_GLOBAL_ARGS) \
		--namespace omec \
		--values $(RIABVALUES) \
		oai-enb-du \
		$(OAICHARTDIR)/oai-enb-du && \
		kubectl wait pod -n omec --for=condition=Ready -l release=oai-enb-du --timeout=100s
	touch $@

$(M)/oai-ue: | $(M)/oai-enb-du
	helm upgrade --install $(HELM_GLOBAL_ARGS) \
		--namespace omec \
		--values $(RIABVALUES) \
		oai-ue \
		$(OAICHARTDIR)/oai-ue && \
		kubectl wait pod -n omec --for=condition=Ready -l release=oai-ue --timeout=100s
	touch $@

reset-oai:
	helm delete -n omec oai-enb-cu || true
	helm delete -n omec oai-enb-du || true
	helm delete -n omec oai-ue || true
	rm -f $(M)/oai-enb-cu
	rm -f $(M)/oai-enb-du
	rm -f $(M)/oai-ue

reset-test: | reset-oai
	helm delete -n omec omec-control-plane || true
	helm delete -n omec omec-user-plane || true
	cd $(M); rm -f omec

clean: reset-test
	kubectl delete po router || true
	kubectl delete net-attach-def core-net || true
	sudo ovs-vsctl del-br br-access-net || true
	sudo ovs-vsctl del-br br-core-net || true
	sudo apt remove --purge openvswitch-switch -y
	source "$(VENV)/bin/activate" && cd $(BUILD)/kubespray; \
	ansible-playbook -b -i inventory/local/hosts.ini reset.yml
	@if [ -d /usr/local/etc/emulab ]; then \
		mount | grep /mnt/extra/kubelet/pods | cut -d" " -f3 | sudo xargs umount; \
		sudo rm -rf /mnt/extra/kubelet; \
	fi
	sudo ip a del 127.0.0.2/8 dev lo | true
	sudo ip a del 127.0.0.4/8 dev lo | true
	sudo ip a del 127.0.0.3/8 dev lo | true
	rm -rf $(M)

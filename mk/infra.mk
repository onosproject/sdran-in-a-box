# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

# PHONY definitions
INFRA_PHONY					:= infra-kubespray infra-k8s infra-fabric infra-atomix infra-onos-op

infra-kubespray: $(BUILD)/kubespray $(M)/kubespray-requirements
infra-k8s: infra-kubespray $(M)/k8s-ready $(M)/helm-ready
infra-fabric: $(M)/fabric
infra-atomix: $(M)/atomix
infra-onos-op: $(M)/onos-operator

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
	helm repo add incubator $(HELM_INCUBATOR_URL)
	helm repo add cord $(HELM_OPENCORD_URL)
	@if [ "$$SDRAN_USERNAME" == "" ]; then read -r -p "Username for ONF SDRAN private chart: " SDRAN_USERNAME; \
	read -r -p "Password for ONF SDRAN private chart: " SDRAN_PASSWORD; fi ;\
	helm repo add sdran $(HELM_SDRAN_URL) --username $$SDRAN_USERNAME --password $$SDRAN_PASSWORD;
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

$(M)/atomix: | $(M)/k8s-ready
	kubectl get po -n kube-system | grep atomix-controller | grep -v Terminating || kubectl create -f https://raw.githubusercontent.com/atomix/kubernetes-controller/master/deploy/atomix-controller.yaml
	kubectl get po -n kube-system | grep raft-storage-controller | grep -v Terminating || kubectl create -f https://raw.githubusercontent.com/atomix/raft-storage-controller/master/deploy/raft-storage-controller.yaml
	kubectl get po -n kube-system | grep cache-storage-controller | grep -v Terminating || kubectl create -f https://raw.githubusercontent.com/atomix/cache-storage-controller/master/deploy/cache-storage-controller.yaml
	@until [ $$(kubectl get po -n kube-system | grep -e atomix-controller -e raft-storage-controller -e cache-storage-controller | grep 1/1 | wc -l) == 3 ]; do sleep 1; done
	touch $@

$(M)/onos-operator: | $(M)/k8s-ready
	kubectl get po -n kube-system | grep config-operator | grep -v Terminating || kubectl create -f https://raw.githubusercontent.com/onosproject/onos-operator/v0.4.0/deploy/onos-operator.yaml
	@until [ $$(kubectl get po -n kube-system | grep -e config-operator -e topo-operator | grep 1/1 | wc -l) == 2 ]; do sleep 1; done
	touch $@
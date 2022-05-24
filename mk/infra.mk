# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

# PHONY definitions
INFRA_PHONY					:= infra-kubespray infra-k8s infra-fabric infra-atomix infra-onos-op infra-fabric-cu-du infra-prom-op-servicemonitor

infra-kubespray: $(BUILD)/kubespray $(M)/kubespray-requirements
infra-k8s: infra-kubespray $(M)/k8s-ready $(M)/helm-ready
infra-fabric: $(M)/fabric
infra-fabric-cu-du: $(M)/fabric-cu-du
infra-atomix: $(M)/atomix
infra-onos-op: $(M)/onos-operator
infra-prom-op-servicemonitor: $(M)/prom-op-servicemonitor

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
	kubectl wait pod -n kube-system --for=condition=Ready --all --timeout=600s
	kubectl get namespace $(RIAB_NAMESPACE) 2> /dev/null || kubectl create namespace $(RIAB_NAMESPACE)
	touch $@

$(M)/helm-ready: | $(M)/k8s-ready
	helm repo add incubator $(HELM_INCUBATOR_URL)
	helm repo add cord $(HELM_OPENCORD_URL)
	helm repo add sdran $(HELM_SDRAN_URL)
	helm repo add atomix https://charts.atomix.io
	helm repo add onos https://charts.onosproject.org
	helm repo update
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
	sudo ovs-vsctl --if-exists del-br br-enb-net
	sudo ovs-vsctl --may-exist add-br br-enb-net
	sudo ovs-vsctl --may-exist add-port br-enb-net enb -- set Interface enb type=internal
	sudo ip addr add $(OMEC_ENB_NET_IP) dev enb || true
	sudo ip link set enb up
	sudo ovs-vsctl --may-exist add-br $(E2_F1_BRIDGE_NAME)
	sudo ovs-vsctl --may-exist add-port $(E2_F1_BRIDGE_NAME) $(E2_F1_CU_INTERFACE) -- set Interface $(E2_F1_CU_INTERFACE) type=internal
	sudo ovs-vsctl --may-exist add-port $(E2_F1_BRIDGE_NAME) $(E2_F1_DU_INTERFACE) -- set Interface $(E2_F1_DU_INTERFACE) type=internal
	sudo ovs-vsctl --may-exist add-port $(E2_F1_BRIDGE_NAME) $(E2T_NODEPORT_INTERFACE) -- set Interface $(E2T_NODEPORT_INTERFACE) type=internal
	sudo ip addr add $(E2_F1_CU_IPADDR) dev $(E2_F1_CU_INTERFACE) || true
	sudo ip addr add $(E2_F1_DU_IPADDR) dev $(E2_F1_DU_INTERFACE) || true
	sudo ip addr add $(E2T_NODEPORT_IPADDR) dev $(E2T_NODEPORT_INTERFACE) || true
	sudo ip link set $(E2_F1_CU_INTERFACE) up
	sudo ip link set $(E2_F1_DU_INTERFACE) up
	sudo ip link set $(E2T_NODEPORT_INTERFACE) up
	sudo ethtool --offload enb tx off
	sudo ip route replace $(ACCESS_SUBNET) via $(shell echo $(ENB_GATEWAY) | awk -F '/' '{print $$1}')  dev enb
	cp $(RESOURCEDIR)/router-template.yaml $(RESOURCEDIR)/router.yaml
	sed -i -e "s#CORE_GATEWAY#$(CORE_GATEWAY)#" $(RESOURCEDIR)/router.yaml
	sed -i -e "s#ENB_GATEWAY#$(ENB_GATEWAY)#" $(RESOURCEDIR)/router.yaml
	sed -i -e "s#ACCESS_GATEWAY#$(ACCESS_GATEWAY)#" $(RESOURCEDIR)/router.yaml
	kubectl apply -f $(RESOURCEDIR)/router.yaml
	kubectl wait pod -n default --for=condition=Ready -l app=router --timeout=300s
	kubectl -n default exec router ip route add $(UE_IP_POOL)/$(UE_IP_MASK) via $(shell echo $(UPF_CORE_NET_IP) | awk -F '/' '{print $$1}') || true
	touch $@

$(M)/fabric-cu-du: | $(M)/setup /opt/cni/bin/simpleovs /opt/cni/bin/static
	sudo apt install -y openvswitch-switch
	sudo ovs-vsctl --may-exist add-br $(E2_F1_BRIDGE_NAME)
	sudo ovs-vsctl --may-exist add-port $(E2_F1_BRIDGE_NAME) $(E2_F1_CU_INTERFACE) -- set Interface $(E2_F1_CU_INTERFACE) type=internal
	sudo ovs-vsctl --may-exist add-port $(E2_F1_BRIDGE_NAME) $(E2_F1_DU_INTERFACE) -- set Interface $(E2_F1_DU_INTERFACE) type=internal
	sudo ip addr add $(E2_F1_CU_IPADDR) dev $(E2_F1_CU_INTERFACE) || true
	sudo ip addr add $(E2_F1_DU_IPADDR) dev $(E2_F1_DU_INTERFACE) || true
	sudo ip link set $(E2_F1_CU_INTERFACE) up
	sudo ip link set $(E2_F1_DU_INTERFACE) up
	touch $@

$(M)/prom-op-servicemonitor: | $(M)/k8s-ready
	kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.54.0/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml || true
	touch $@

$(M)/atomix: | $(M)/k8s-ready
	helm repo update
ifeq ($(VER), v1.0.0)
	kubectl create -f https://raw.githubusercontent.com/atomix/kubernetes-controller/0a9e82ef37df25cf567a4dbc18f35b2bb454bda1/deploy/atomix-controller.yaml
	kubectl create -f https://raw.githubusercontent.com/atomix/raft-storage-controller/668951dff14e339f3c71b489863cbca8ec326a96/deploy/raft-storage-controller.yaml
	kubectl create -f https://raw.githubusercontent.com/atomix/cache-storage-controller/85014c6216e3d8cdf22df09aab3d1f16852fc584/deploy/cache-storage-controller.yaml
else ifeq ($(VER), v1.1.0)
	helm install -n kube-system atomix-controller atomix/atomix-controller --version 0.5.2 --wait || true
	helm install -n kube-system raft-storage-controller atomix/raft-storage-controller --version 0.5.1 --wait || true
	helm install -n kube-system cache-storage-controller atomix/cache-storage-controller --version 0.4.0 --wait || true
else ifeq ($(VER), v1.1.1)
	helm install -n kube-system atomix-controller atomix/atomix-controller --version 0.5.2 --wait || true
	helm install -n kube-system raft-storage-controller atomix/raft-storage-controller --version 0.5.1 --wait || true
	helm install -n kube-system cache-storage-controller atomix/cache-storage-controller --version 0.4.0 --wait || true
else ifeq ($(VER), v1.2.0)
	helm install -n kube-system atomix-controller atomix/atomix-controller --version 0.6.7 --wait || true
	helm install -n kube-system atomix-raft-storage atomix/atomix-raft-storage --version 0.1.8 --wait || true
	helm install -n kube-system atomix-memory-storage atomix/atomix-memory-storage --version 0.1.1 --wait || true
else ifeq ($(VER), v1.3.0)
	helm install -n kube-system atomix-controller atomix/atomix-controller --version 0.6.8 --wait || true
	helm install -n kube-system atomix-raft-storage atomix/atomix-raft-storage --version 0.1.15 --wait || true
else ifeq ($(VER), v1.4.0)
	helm install -n kube-system atomix-controller atomix/atomix-controller --version 0.6.9 --wait || true
	helm install -n kube-system atomix-raft-storage atomix/atomix-raft-storage --version 0.1.25 --wait || true
else ifeq ($(VER), stable)
	helm install -n kube-system atomix-controller atomix/atomix-controller --wait || true
	helm install -n kube-system atomix-raft-storage atomix/atomix-raft-storage --wait || true
else ifeq ($(VER), latest)
	helm install -n kube-system atomix-controller atomix/atomix-controller --wait || true
	helm install -n kube-system atomix-raft-storage atomix/atomix-raft-storage --wait || true
else ifeq ($(VER), dev)
	helm install -n kube-system atomix-controller atomix/atomix-controller --wait || true
	helm install -n kube-system atomix-raft-storage atomix/atomix-raft-storage --wait || true
else
	helm install -n kube-system atomix-controller atomix/atomix-controller --wait || true
	helm install -n kube-system atomix-raft-storage atomix/atomix-raft-storage --wait || true
endif
	touch $@

$(M)/onos-operator: | $(M)/k8s-ready
	helm repo update
ifeq ($(VER), v1.0.0)
	@echo v1.0.0 does not need onos-operator: skip deploying onos-operator chart
else ifeq ($(VER), v1.1.0)
	helm install onos-operator onos/onos-operator -n kube-system --version 0.4.1 --wait || true
else ifeq ($(VER), v1.1.1)
	helm install onos-operator onos/onos-operator -n kube-system --version 0.4.1 --wait || true
else ifeq ($(VER), v1.2.0)
	helm install onos-operator onos/onos-operator -n kube-system --version 0.4.6 --wait || true
else ifeq ($(VER), v1.3.0)
	helm install onos-operator onos/onos-operator -n kube-system --version 0.4.14 --wait || true
else ifeq ($(VER), v1.4.0)
	helm install onos-operator onos/onos-operator -n kube-system --version 0.5.2 --wait || true
else ifeq ($(VER), stable)
	helm install onos-operator onos/onos-operator -n kube-system --wait || true
else ifeq ($(VER), latest)
	helm install onos-operator onos/onos-operator -n kube-system --wait || true
else ifeq ($(VER), dev)
	helm install onos-operator onos/onos-operator -n kube-system --wait || true
else
	helm install onos-operator onos/onos-operator -n kube-system --wait || true
endif
	touch $@

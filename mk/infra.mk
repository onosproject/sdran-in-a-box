# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

# PHONY definitions
INFRA_PHONY					:= infra-k8s infra-fabric infra-atomix infra-onos-op infra-fabric-cu-du infra-prom-op-servicemonitor

infra-k8s: $(M)/k8s-ready $(M)/helm-ready
infra-fabric: $(M)/fabric
infra-fabric-cu-du: $(M)/fabric-cu-du
infra-atomix: $(M)/atomix
infra-onos-op: $(M)/onos-operator
infra-prom-op-servicemonitor: $(M)/prom-op-servicemonitor

$(M)/k8s-ready: | $(M)/setup
	sudo mkdir -p /etc/rancher/rke2/
	[ -d /usr/local/etc/emulab ] && [ ! -e /var/lib/rancher ] && sudo ln -s /var/lib/rancher /mnt/extra/rancher || true  # that link gets deleted on cleanup
	echo "cni: multus,calico" >> config.yaml
	echo "cluster-cidr: 192.168.84.0/24" >> config.yaml
	echo "service-cidr: 192.168.85.0/24" >> config.yaml
	echo "kubelet-arg:" >> config.yaml
	echo "- --allowed-unsafe-sysctls="net.*"" >> config.yaml
	echo "- --node-ip="$(NODE_IP)"" >> config.yaml
	echo "pause-image: k8s.gcr.io/pause:3.3" >> config.yaml
	echo "kube-proxy-arg:" >> config.yaml
	echo "- --metrics-bind-address="0.0.0.0:10249"" >> config.yaml
	echo "- --proxy-mode="ipvs"" >> config.yaml
	echo "kube-apiserver-arg:" >> config.yaml
	echo "- --service-node-port-range="2000-36767"" >> config.yaml
	sudo mv config.yaml /etc/rancher/rke2/
	curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_VERSION=$(RKE2_K8S_VERSION) sh -
	sudo systemctl enable rke2-server.service
	sudo systemctl start rke2-server.service
	sudo /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml wait nodes --for=condition=Ready --all --timeout=300s
	sudo /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml wait deployment -n kube-system --for=condition=available --all --timeout=300s
	@$(eval STORAGE_CLASS := $(shell /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml get storageclass -o name))
	@echo "STORAGE_CLASS: ${STORAGE_CLASS}"
	if [ "$(STORAGE_CLASS)" == "" ]; then \
		sudo /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/$(LPP_VERSION)/deploy/local-path-storage.yaml --wait=true; \
		sudo /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'; \
	fi
	curl -LO "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/amd64/kubectl"
	sudo chmod +x kubectl
	sudo mv kubectl /usr/local/bin/
	kubectl version --client
	mkdir -p $(HOME)/.kube
	sudo cp /etc/rancher/rke2/rke2.yaml $(HOME)/.kube/config
	sudo chown -R $(shell id -u):$(shell id -g) $(HOME)/.kube
	touch $@

$(M)/helm-ready: | $(M)/k8s-ready
	curl -fsSL -o ${GET_HELM} https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
	chmod 700 ${GET_HELM}
	sudo DESIRED_VERSION=$(HELM_VERSION) ./${GET_HELM}
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
	helm install -n kube-system atomix-runtime atomix/atomix --version 1.1.2 --wait || true
else ifeq ($(VER), latest)
	helm install -n kube-system atomix-runtime atomix/atomix --wait || true
else ifeq ($(VER), dev)
	helm install -n kube-system atomix-runtime atomix/atomix --wait || true
else
	helm install -n kube-system atomix-runtime atomix/atomix --wait || true
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

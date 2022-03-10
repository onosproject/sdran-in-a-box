# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

# PHONY definitions
EPC_PHONY					:= omec 5gc

omec: $(M)/omec
5gc:  $(M)/5gc

$(M)/omec: | version $(M)/helm-ready $(M)/fabric
	kubectl get namespace $(RIAB_NAMESPACE) 2> /dev/null || kubectl create namespace $(RIAB_NAMESPACE)
	helm repo update
	helm dep up $(AETHERCHARTDIR)/omec/omec-control-plane
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		--set config.spgwc.ueIpPool.ip=$(UE_IP_POOL) \
		--set config.spgwc.cfgFiles.cp.json.ip_pool_config.ueIpPool.ip=$(UE_IP_POOL) \
		--set config.spgwc.cfgFiles.cp.json.ip_pool_config.staticUeIpPool.ip=$(STATIC_UE_IP_POOL) \
		omec-control-plane \
		$(AETHERCHARTDIR)/omec/omec-control-plane && \
	kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=omec-control-plane --timeout=300s && \
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		--set config.upf.cfgFiles.upf.json.cpiface.ue_ip_pool=$(UE_IP_POOL)/$(UE_IP_MASK) \
		omec-user-plane \
		$(AETHERCHARTDIR)/omec/omec-user-plane && \
	kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=omec-user-plane --timeout=300s
	touch $@

$(M)/5gc: | version $(M)/helm-ready $(M)/fabric
	kubectl get namespace $(RIAB_NAMESPACE) 2> /dev/null || kubectl create namespace $(RIAB_NAMESPACE)
	helm repo update
	helm dep up $(AETHERCHARTDIR)/omec/5g-control-plane
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		sim-app \
		$(AETHERCHARTDIR)/omec/omec-sub-provision && \
	kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=sim-app --timeout=300s && \
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		5g-core-up \
		$(AETHERCHARTDIR)/omec/omec-user-plane && \
	kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=5g-core-up --timeout=300s && \
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		--set config.upf.cfgFiles.upf.json.cpiface.ue_ip_pool=$(UE_IP_POOL)/$(UE_IP_MASK) \
		fgc-core \
		$(AETHERCHARTDIR)/omec/5g-control-plane && \
	kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=fgc-core --timeout=300s && \
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		5g-ransim-plane \
		$(AETHERCHARTDIR)/omec/5g-ran-sim && \
	kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=5g-ransim-plane --timeout=300s
	touch $@
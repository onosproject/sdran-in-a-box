# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

# PHONY definitions
EPC_PHONY					:= omec

omec: $(M)/omec

$(M)/omec: | version $(M)/helm-ready $(M)/fabric
	kubectl get namespace $(RIAB_NAMESPACE) 2> /dev/null || kubectl create namespace $(RIAB_NAMESPACE)
	helm repo update
	helm dep up $(AETHERCHARTDIR)/omec/omec-control-plane
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		--set config.spgwc.ueIpPool.ip=$(UE_IP_POOL) \
		omec-control-plane \
		$(AETHERCHARTDIR)/omec/omec-control-plane && \
	kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=omec-control-plane --timeout=300s && \
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		omec-user-plane \
		$(AETHERCHARTDIR)/omec/omec-user-plane && \
	kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=omec-user-plane --timeout=300s
	touch $@
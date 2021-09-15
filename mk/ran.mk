# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

# PHONY definitions
RAN_PHONY					:= oai oai-hw oai-enb-cu oai-enb-cu-hw oai-enb-du oai-ue

oai: oai-enb-cu oai-enb-du oai-ue
oai-enb-cu: $(M)/oai-enb-cu
oai-enb-du: $(M)/oai-enb-du
oai-ue: $(M)/oai-ue

oai-hw: oai-enb-cu-hw oai-enb-du
oai-enb-cu-hw: $(M)/oai-enb-cu-hw

$(M)/oai-enb-cu: | version $(M)/helm-ready $(M)/ric
	$(eval e2t_addr=$(shell  kubectl get svc onos-e2t -n $(RIAB_NAMESPACE) --no-headers | awk '{print $$3'}))
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		--set config.oai-enb-cu.networks.s1mme.interface=$(S1MME_CU_INTERFACE) \
		--set config.onos-e2t.networks.e2.address=$(e2t_addr) \
		--set config.oai-enb-cu.networks.f1.interface=$(F1_CU_INTERFACE) \
		--set config.oai-enb-cu.networks.f1.address=$(F1_CU_IPADDR) \
		--set config.oai-enb-du.networks.f1.interface=$(F1_DU_INTERFACE) \
		--set config.oai-enb-du.networks.f1.address=$(F1_DU_IPADDR) \
		oai-enb-cu \
		$(SDRANCHARTDIR)/oai-enb-cu && \
		sleep 60 && \
		kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=oai-enb-cu --timeout=600s && \
		sleep 10
	touch $@

$(M)/oai-enb-cu-hw: | version $(M)/helm-ready
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		--set config.oai-enb-cu.networks.s1mme.interface=$(S1MME_CU_INTERFACE) \
		--set config.oai-enb-cu.networks.f1.interface=$(F1_CU_INTERFACE) \
		--set config.oai-enb-cu.networks.f1.address=$(F1_CU_IPADDR) \
		--set config.oai-enb-du.networks.f1.interface=$(F1_DU_INTERFACE) \
		--set config.oai-enb-du.networks.f1.address=$(F1_DU_IPADDR) \
		oai-enb-cu \
		$(SDRANCHARTDIR)/oai-enb-cu && \
		sleep 60 && \
		kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l app=oai-enb-cu --timeout=600s && \
		sleep 10
	touch $@

$(M)/oai-enb-du: | version $(M)/helm-ready
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
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
		sleep 60 && \
		kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l app=oai-enb-du --timeout=600s && \
		sleep 10
	touch $@

$(M)/oai-ue: | version $(M)/helm-ready
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		--set config.oai-enb-du.networks.nfapi.interface=$(NFAPI_DU_INTERFACE) \
		--set config.oai-enb-du.networks.nfapi.address=$(NFAPI_DU_IPADDR) \
		--set config.oai-ue.networks.nfapi.interface=$(NFAPI_UE_INTERFACE) \
		--set config.oai-ue.networks.nfapi.address=$(NFAPI_UE_IPADDR) \
		oai-ue \
		$(SDRANCHARTDIR)/oai-ue && \
		sleep 60 && \
		kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l app=oai-ue --timeout=600s && \
	touch $@
# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

# PHONY definitions
RAN_PHONY					:= oai oai-hw oai-enb-cu oai-enb-cu-hw oai-enb-du oai-ue

oai: oai-enb-cu oai-enb-du oai-ue
oai-enb-cu: $(M)/oai-enb-cu
oai-enb-du: $(M)/oai-enb-du
oai-ue: $(M)/oai-ue

oai-hw: oai-enb-cu-hw oai-enb-du
oai-enb-cu-hw: $(M)/oai-enb-cu-hw

$(M)/oai-enb-cu: | version $(M)/helm-ready
	$(eval cu_e2t_nodeport_ipaddr=$(shell echo $(E2T_NODEPORT_IPADDR) | awk -F '/' '{print $$1}'))
	$(eval cu_e2_f1_cu_ipaddr=$(shell echo $(E2_F1_CU_IPADDR) | awk -F '/' '{print $$1}'))
	$(eval cu_e2_f1_du_ipaddr=$(shell echo $(E2_F1_DU_IPADDR) | awk -F '/' '{print $$1}'))
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		--set config.oai-enb-cu.networks.s1mme.interface=$(S1MME_CU_INTERFACE) \
		--set config.onos-e2t.networks.e2.address=$(cu_e2t_nodeport_ipaddr) \
		--set config.oai-enb-cu.networks.f1.interface=$(E2_F1_CU_INTERFACE) \
		--set config.oai-enb-cu.networks.f1.address=$(cu_e2_f1_cu_ipaddr) \
		--set config.oai-enb-du.networks.f1.interface=$(E2_F1_DU_INTERFACE) \
		--set config.oai-enb-du.networks.f1.address=$(cu_e2_f1_du_ipaddr) \
		oai-enb-cu \
		$(SDRANCHARTDIR)/oai-enb-cu && \
		sleep 60 && \
		kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l release=oai-enb-cu --timeout=600s && \
		sleep 10
	touch $@

$(M)/oai-enb-cu-hw: | version $(M)/helm-ready
	$(eval cu_e2t_nodeport_ipaddr=$(shell echo $(E2T_NODEPORT_IPADDR) | awk -F '/' '{print $$1}'))
	$(eval cu_e2_f1_cu_ipaddr=$(shell echo $(E2_F1_CU_IPADDR) | awk -F '/' '{print $$1}'))
	$(eval cu_e2_f1_du_ipaddr=$(shell echo $(E2_F1_DU_IPADDR) | awk -F '/' '{print $$1}'))
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		--set config.oai-enb-cu.networks.s1mme.interface=$(S1MME_CU_INTERFACE) \
		--set config.oai-enb-cu.networks.f1.interface=$(E2_F1_CU_INTERFACE) \
		--set config.onos-e2t.networks.e2.address=$(cu_e2t_nodeport_ipaddr) \
		--set config.oai-enb-cu.networks.f1.address=$(cu_e2_f1_cu_ipaddr) \
		--set config.oai-enb-du.networks.f1.interface=$(E2_F1_DU_INTERFACE) \
		--set config.oai-enb-du.networks.f1.address=$(cu_e2_f1_du_ipaddr) \
		oai-enb-cu \
		$(SDRANCHARTDIR)/oai-enb-cu && \
		sleep 60 && \
		kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l app=oai-enb-cu --timeout=600s && \
		sleep 10
	touch $@

$(M)/oai-enb-du: | version $(M)/helm-ready
	$(eval du_e2t_nodeport_ipaddr=$(shell echo $(E2T_NODEPORT_IPADDR) | awk -F '/' '{print $$1}'))
	$(eval du_e2_f1_cu_ipaddr=$(shell echo $(E2_F1_CU_IPADDR) | awk -F '/' '{print $$1}'))
	$(eval du_e2_f1_du_ipaddr=$(shell echo $(E2_F1_DU_IPADDR) | awk -F '/' '{print $$1}'))
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		--set config.oai-enb-cu.networks.f1.interface=$(E2_F1_CU_INTERFACE) \
		--set config.oai-enb-cu.networks.f1.address=$(du_e2_f1_cu_ipaddr) \
		--set config.oai-enb-du.networks.f1.interface=$(E2_F1_DU_INTERFACE) \
		--set config.oai-enb-du.networks.f1.address=$(du_e2_f1_du_ipaddr) \
		--set config.onos-e2t.networks.e2.address=$(du_e2t_nodeport_ipaddr) \
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
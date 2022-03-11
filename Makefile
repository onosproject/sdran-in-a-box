# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

# Include Variable file
include ./MakefileVar.mk
include ./mk/*.mk

# Default target
.DEFAULT_GOAL				:= riab

# PHONY definitions
OPT_SELECTION_PHONY			:= option
VER_SELECTION_PHONY			:= version
RUN_PHONY					:= riab
MAIN_PHONY					:= $(OPT_SELECTION_PHONY) $(VER_SELECTION_PHONY) $(RUN_PHONY) $(PRELIMINARIES_PHONY) $(INFRA_PHONY) $(EPC_PHONY) $(RIC_PHONY) $(RAN_PHONY) $(TEST_PHONY) $(RESET_CLEAN_PHONY) $(UTIL_PHONY) $(OBS_PHONY) $(ROUTING_PHONY)

.PHONY: $(MAINPHONY)

$(WORKSPACE):
	mkdir -p $(WORKSPACE)

$(M): | $(WORKSPACE) $(BUILD)
	mkdir -p $(M)

$(BUILD): | $(WORKSPACE)
	mkdir -p $(BUILD)

ifeq ($(OPT), ransim)
riab: option version preliminaries infra-k8s infra-atomix infra-onos-op ric
	@echo Done
else ifeq ($(OPT), oai)
riab: option version preliminaries infra-k8s infra-fabric routing-quagga infra-atomix infra-onos-op omec routing-omec ric oai
	@echo Done
else ifeq ($(OPT), oai-ran-cu-du)
riab: option version preliminaries infra-k8s infra-fabric-cu-du oai-enb-cu-hw oai-enb-du routing-hw-oai
	@echo Done
else ifeq ($(OPT), ric)
riab: option version preliminaries infra-k8s infra-atomix infra-onos-op ric routing-ric-external-ran
	@echo Done
else ifeq ($(OPT), ric-e2ap101)
riab: option version preliminaries infra-k8s infra-atomix infra-onos-op ric routing-ric-external-ran
	@echo Done
else ifeq ($(OPT), fbah)
riab: option version preliminaries infra-k8s infra-atomix infra-onos-op infra-prom-op-servicemonitor ric enable-fbah-gui
	@echo Done
else ifeq ($(OPT), mlb)
riab: option version preliminaries infra-k8s infra-atomix infra-onos-op ric
	@echo Done
else ifeq ($(OPT), mho)
riab: option version preliminaries infra-k8s infra-atomix infra-onos-op ric
	@echo Done
else ifeq ($(OPT), rimedots)
riab: option version preliminaries infra-k8s infra-atomix infra-onos-op ric
	@echo Done
else
riab: option version
	@echo "Invalid option"
	@echo "Option:" $(OPT)
endif

$(M)/repos: | $(M)
	mkdir -p $(CHARTDIR)
	cd $(CHARTDIR)
	@if [[ ! -d "$(AETHERCHARTDIR)" ]]; then \
                echo "aether-helm-chart repo is not in $(CHARTDIR) directory. Start to clone - it requires HTTPS key"; \
				git clone $(CORD_GERRIT_URL)/aether-helm-charts $(AETHERCHARTDIR) || true; \
	fi
	@if [[ ! -d "$(SDRANCHARTDIR)" ]]; then \
                echo "sdran-helm-chart repo is not in $(CHARTDIR) directory. Start to clone - it requires Github credential"; \
				git clone $(ONOS_GITHUB_URL)/sdran-helm-charts $(SDRANCHARTDIR) || true; \
	fi
	touch $@

option: | $(M) $(M)/repos
ifeq ($(OPT), ransim)
	$(eval OPT=ransim)
	$(eval HELM_ARGS=$(HELM_ARGS_RANSIM))
	@echo "Helm arguments for ransim: $(HELM_ARGS_RANSIM)"
else ifeq ($(OPT), oai)
	$(eval OPT=oai)
	$(eval HELM_ARGS=$(HELM_ARGS_OAI))
	@echo "Helm arguments for oai: $(HELM_ARGS_OAI)"
else ifeq ($(OPT), oai-ran-cu-du)
	$(eval OPT=oai-ran-cu-du)
	$(eval HELM_ARGS=$(HELM_ARGS_OAI))
	@echo "Helm arguments for oai: $(HELM_ARGS_OAI)"
else ifeq ($(OPT), ric)
	$(eval OPT=ric)
	$(eval HELM_ARGS=$(HELM_ARGS_RIC))
	@echo "Helm arguments for ric: $(HELM_ARGS_RIC)"
else ifeq ($(OPT), ric-e2ap101)
	$(eval OPT=ric-e2ap101)
	$(eval HELM_ARGS=$(HELM_ARGS_RIC_E2AP101))
	@echo "Helm arguments for ric: $(HELM_ARGS_RIC_E2AP101)"
else ifeq ($(OPT), fbah)
	$(eval OPT=fbah)
	$(eval HELM_ARGS=$(HELM_ARGS_FBAH))
	@echo "Helm arguments for Facebook-AirHop usecase: $(HELM_ARGS_FBAH)"
else ifeq ($(OPT), mlb)
	$(eval OPT=ransim)
	$(eval HELM_ARGS=$(HELM_ARGS_MLB))
	@echo "Helm arguments for mlb: $(HELM_ARGS_MLB)"
else ifeq ($(OPT), mho)
	$(eval OPT=ransim)
	$(eval HELM_ARGS=$(HELM_ARGS_MHO))
	@echo "Helm arguments for mho: $(HELM_ARGS_MHO)"
else ifeq ($(OPT), rimedots)
	$(eval OPT=ransim)
	$(eval HELM_ARGS=$(HELM_ARGS_RIMEDOTS))
	@echo "Helm arguments for rimedots: $(HELM_ARGS_RIMEDOTS)"
else
	$(eval OPT=ransim)
	$(eval HELM_ARGS=$(HELM_ARGS_RANSIM))
	@echo "Helm arguments for ransim (default): $(HELM_ARGS_RANSIM)"
endif

version: | $(M) $(M)/repos
ifeq ($(VER), v1.0.0)
	$(eval VER=v1.0.0)
	$(eval HELM_VALUES=$(HELM_VALUES_V1.0.0))
	@echo "Helm values.yaml file: $(HELM_VALUES_V1.0.0)"
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-V1.0.0)
	@cd $(AETHERCHARTDIR); git checkout $(AETHERCHARTCID-V1.0.0)
else ifeq ($(VER), v1.1.0)
	$(eval VER=v1.1.0)
	$(eval HELM_VALUES=$(HELM_VALUES_V1.1.0))
	@echo "Helm values.yaml file: $(HELM_VALUES_V1.1.0)"
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-V1.1.0)
	@cd $(AETHERCHARTDIR); git checkout $(AETHERCHARTCID-V1.0.0)
else ifeq ($(VER), v1.1.1)
	$(eval VER=v1.1.1)
	$(eval HELM_VALUES=$(HELM_VALUES_V1.1.1))
	@echo "Helm values.yaml file: $(HELM_VALUES_V1.1.1)"
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-V1.1.1)
	@cd $(AETHERCHARTDIR); git checkout $(AETHERCHARTCID-V1.0.0)
else ifeq ($(VER), v1.2.0)
	$(eval VER=v1.2.0)
	$(eval HELM_VALUES=$(HELM_VALUES_V1.2.0))
	@echo "Helm values.yaml file: $(HELM_VALUES_V1.2.0)"
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-V1.2.0)
	@cd $(AETHERCHARTDIR); git checkout $(AETHERCHARTCID-V1.0.0)
else ifeq ($(VER), v1.3.0)
	$(eval VER=v1.3.0)
	$(eval HELM_VALUES=$(HELM_VALUES_V1.3.0))
	@echo "Helm values.yaml file: $(HELM_VALUES_V1.3.0)"
	@cd $(AETHERCHARTDIR); git checkout $(AETHERCHARTCID-V1.3.0)
ifeq ($(OPT), oai)
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-E2AP101-V1.3.0)
else ifeq ($(OPT), ric-e2ap101)
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-E2AP101-V1.3.0)
else
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-V1.3.0)
endif
else ifeq ($(VER), v1.4.0)
	$(eval VER=v1.4.0)
	$(eval HELM_VALUES=$(HELM_VALUES_V1.4.0))
	@echo "Helm values.yaml file: $(HELM_VALUES_V1.4.0)"
	@cd $(AETHERCHARTDIR); git checkout $(AETHERCHARTCID-V1.4.0)
ifeq ($(OPT), oai)
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-V1.4.0)
else ifeq ($(OPT), ric-e2ap101)
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-E2AP101-V1.4.0)
else
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-V1.4.0)
endif
else ifeq ($(VER), stable)
	$(eval VER=stable)
	$(eval HELM_VALUES=$(HELM_VALUES_STABLE))
	@echo "Helm values.yaml file: $(HELM_VALUES_STABLE)"
	@cd $(AETHERCHARTDIR); git checkout $(AETHERCHARTCID-LATEST)
ifeq ($(OPT), oai)
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-LATEST)
else ifeq ($(OPT), ric-e2ap101)
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-E2AP101-LATEST)
else
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-LATEST)
endif
else ifeq ($(VER), latest)
	$(eval VER=latest)
	$(eval HELM_VALUES=$(HELM_VALUES_LATEST))
	@echo "Helm values.yaml file: $(HELM_VALUES_LATEST)"
	@cd $(AETHERCHARTDIR); git checkout $(AETHERCHARTCID-LATEST)
ifeq ($(OPT), oai)
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-LATEST)
else ifeq ($(OPT), ric-e2ap101)
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-E2AP101-LATEST)
else
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-LATEST)
endif
else ifeq ($(VER), dev)
	$(eval VER=dev)
	$(eval HELM_VALUES=$(HELM_VALUES_DEV))
	@echo "Helm values.yaml file: $(HELM_VALUES_DEV)"
	@cd $(AETHERCHARTDIR); git checkout $(AETHERCHARTCID-LATEST)
else
	$(eval VER=stable)
	$(eval HELM_VALUES=$(HELM_VALUES_STABLE))
	@echo "Helm values.yaml file: $(HELM_VALUES_STABLE)"
	@cd $(AETHERCHARTDIR); git checkout $(AETHERCHARTCID-LATEST)
ifeq ($(OPT), oai)
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-LATEST)
else ifeq ($(OPT), ric-e2ap101)
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-E2AP101-LATEST)
else
	@cd $(SDRANCHARTDIR); git checkout $(SDRANCHARTCID-LATEST)
endif
endif

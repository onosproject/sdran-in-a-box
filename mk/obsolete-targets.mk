# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

# PHONY definitions
OBS_PHONY					:= set-option-oai set-option-ransim set-option-fbah set-option-ric set-stable-aether-chart set-latest-sdran-chart set-v1.0.0-sdran-chart set-v1.1.0-sdran-chart set-v1.1.1-sdran-chart set-latest-riab-values set-v1.0.0-riab-values set-v1.1.0-riab-values set-v1.1.1-riab-values set-master-stable-riab-values atomix riab-oai riab-ransim riab-ric riab-fbah riab-oai-latest riab-ransim-latest riab-ric-latest riab-fbah-latest riab-oai-v1.0.0 riab-ransim-v1.0.0 riab-ric-v1.0.0 riab-oai-v1.1.0 riab-ransim-v1.1.0 riab-ric-v1.1.0 riab-fbah-v1.1.0 riab-oai-v1.1.1 riab-ransim-v1.1.1 riab-ric-v1.1.1 riab-fbah-v1.1.1 riab-oai-dev riab-ransim-dev riab-ric-dev riab-fbah-dev oai-enb-usrp oai-ue-usrp ric-oai-latest riab-oai-master-stable riab-ransim-master-stable riab-ric-master-stable riab-fbah-master-stable

set-option-oai:
	$(eval HELM_ARGS=$(HELM_ARGS_OAI))
	$(eval OPT=oai)

set-option-ransim:
	$(eval HELM_ARGS=$(HELM_ARGS_RANSIM))
	$(eval OPT=ransim)

set-option-fbah:
	$(eval HELM_ARGS=$(HELM_ARGS_FBAH))
	$(eval OPT=fbah)

set-option-ric:
	$(eval HELM_ARGS=$(HELM_ARGS_RIC))
	$(eval OPT=ric)

set-stable-aether-chart:
	cd $(AETHERCHARTDIR); \
	git checkout $(AETHERCHARTCID-LATEST);

set-latest-sdran-chart:
	cd $(SDRANCHARTDIR); \
	git checkout $(SDRANCHARTCID-LATEST)

set-v1.0.0-sdran-chart:
	cd $(SDRANCHARTDIR); \
	git fetch origin $(SDRANCHARTCID-V1.0.0); \
	git checkout $(SDRANCHARTCID-V1.0.0)

set-v1.1.0-sdran-chart:
	cd $(SDRANCHARTDIR); \
	git fetch origin $(SDRANCHARTCID-V1.1.0); \
	git checkout $(SDRANCHARTCID-V1.1.0)

set-v1.1.1-sdran-chart:
	cd $(SDRANCHARTDIR); \
	git fetch origin $(SDRANCHARTCID-V1.1.1); \
	git checkout $(SDRANCHARTCID-V1.1.1)

set-latest-riab-values:
	$(eval HELM_VALUES=$(HELM_VALUES_LATEST))
	$(eval VER=latest)

set-v1.0.0-riab-values:
	$(eval HELM_VALUES=$(HELM_VALUES_V1.0.0))
	$(eval VER=v1.0.0)

set-v1.1.0-riab-values:
	$(eval HELM_VALUES=$(HELM_VALUES_V1.1.0))
	$(eval VER=v1.1.0)

set-v1.1.1-riab-values:
	$(eval HELM_VALUES=$(HELM_VALUES_V1.1.1))
	$(eval VER=v1.1.1)

set-master-stable-riab-values:
	$(eval HELM_VALUES=$(HELM_VALUES_STABLE))
	$(eval VER=stable)

atomix: $(M)/atomix

riab-oai: set-option-oai $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-latest-sdran-chart set-latest-riab-values omec ric oai
riab-ransim: set-option-ransim $(M)/system-check $(M)/helm-ready set-latest-sdran-chart set-latest-riab-values ric
riab-ric: set-option-ric $(M)/system-check $(M)/helm-ready set-latest-sdran-chart set-latest-riab-values ric
riab-fbah: set-option-fbah $(M)/system-check $(M)/helm-ready set-latest-sdran-chart set-latest-riab-values ric

riab-oai-latest: riab-oai
riab-ransim-latest: riab-ransim
riab-ric-latest: riab-ric
riab-fbah-latest: riab-fbah

riab-oai-v1.0.0: set-option-oai $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-v1.0.0-sdran-chart set-v1.0.0-riab-values omec ric oai
riab-ransim-v1.0.0: set-option-ransim $(M)/system-check $(M)/helm-ready set-v1.0.0-sdran-chart set-v1.0.0-riab-values ric
riab-ric-v1.0.0: set-option-ric $(M)/system-check $(M)/helm-ready set-v1.0.0-sdran-chart set-v1.0.0-riab-values ric

riab-oai-v1.1.0: set-option-oai $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-v1.1.0-sdran-chart set-v1.1.0-riab-values omec ric oai
riab-ransim-v1.1.0: set-option-ransim $(M)/system-check $(M)/helm-ready set-v1.1.0-sdran-chart set-v1.1.0-riab-values ric
riab-ric-v1.1.0: set-option-ric $(M)/system-check $(M)/helm-ready set-v1.1.0-sdran-chart set-v1.1.0-riab-values ric
riab-fbah-v1.1.0: set-option-fbah $(M)/system-check $(M)/helm-ready set-v1.1.0-sdran-chart set-v1.1.0-riab-values ric

riab-oai-v1.1.1: set-option-oai $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-v1.1.1-sdran-chart set-v1.1.1-riab-values omec ric oai
riab-ransim-v1.1.1: set-option-ransim $(M)/system-check $(M)/helm-ready set-v1.1.1-sdran-chart set-v1.1.1-riab-values ric
riab-ric-v1.1.1: set-option-ric $(M)/system-check $(M)/helm-ready set-v1.1.1-sdran-chart set-v1.1.1-riab-values ric
riab-fbah-v1.1.1: set-option-fbah $(M)/system-check $(M)/helm-ready set-v1.1.1-sdran-chart set-v1.1.1-riab-values ric

riab-oai-dev: set-option-oai $(M)/system-check $(M)/helm-ready set-latest-riab-values omec ric oai
riab-ransim-dev: set-option-ransim $(M)/system-check $(M)/helm-ready set-latest-riab-values ric
riab-ric-dev: set-option-ric $(M)/system-check $(M)/helm-ready set-latest-riab-values ric
riab-fbah-dev: set-option-fbah $(M)/system-check $(M)/helm-ready set-latest-riab-values ric

oai-enb-usrp: set-option-oai $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-latest-sdran-chart set-latest-riab-values $(M)/oai-enb-cu-hw $(M)/oai-enb-du
oai-ue-usrp: set-option-oai $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-latest-sdran-chart set-latest-riab-values $(M)/oai-ue
ric-oai-latest: set-option-oai set-latest-sdran-chart set-latest-riab-values ric

riab-oai-master-stable: set-option-oai $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-latest-sdran-chart set-master-stable-riab-values omec ric oai
riab-ransim-master-stable: set-option-ransim $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-latest-sdran-chart set-master-stable-riab-values ric
riab-ric-master-stable: set-option-ric $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-latest-sdran-chart set-master-stable-riab-values ric
riab-fbah-master-stable: set-option-fbah $(M)/system-check $(M)/helm-ready set-stable-aether-chart set-latest-sdran-chart set-master-stable-riab-values ric
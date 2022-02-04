# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

# PHONY definitions
RIC_PHONY					:= ric

ric: $(M)/ric

$(M)/ric: | version $(M)/helm-ready $(M)/atomix $(M)/onos-operator
	kubectl get namespace $(RIAB_NAMESPACE) 2> /dev/null || kubectl create namespace $(RIAB_NAMESPACE)
	cd $(SDRANCHARTDIR)/sd-ran; rm -rf charts Chart.lock tmpcharts; helm dep update
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		sd-ran \
		$(SDRANCHARTDIR)/sd-ran && \
	kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l app=onos --timeout=600s
	touch $@
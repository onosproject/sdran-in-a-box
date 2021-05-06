# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

# PHONY definitions
RIC_PHONY					:= omec

ric: $(M)/ric

$(M)/ric: | version $(M)/helm-ready $(M)/atomix $(M)/onos-operator
	kubectl get po -n kube-system | grep config-operator | grep -v Terminating || kubectl create -f https://raw.githubusercontent.com/onosproject/onos-operator/v0.4.0/deploy/onos-operator.yaml
	@until [ $$(kubectl get po -n kube-system | grep -e config-operator -e topo-operator | grep 1/1 | wc -l) == 2 ]; do sleep 1; done
	kubectl get namespace $(RIAB_NAMESPACE) 2> /dev/null || kubectl create namespace $(RIAB_NAMESPACE)
	cd $(SDRANCHARTDIR)/sd-ran; helm dep update
	helm upgrade --install $(HELM_ARGS) \
		--namespace $(RIAB_NAMESPACE) \
		--values $(HELM_VALUES) \
		sd-ran \
		$(SDRANCHARTDIR)/sd-ran && \
	kubectl wait pod -n $(RIAB_NAMESPACE) --for=condition=Ready -l app=onos --timeout=600s
	touch $@
# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

# PHONY definitions
UTIL_PHONY					:= detach-ue fetch-all-charts enable-fbah-gui

detach-ue: | $(M)/oai-enb-cu $(M)/oai-enb-du $(M)/oai-ue
	echo -en "AT+CPIN=0000\r" | nc -u -w 1 localhost 10000
	echo -en "AT+CGATT=0\r" | nc -u -w 1 localhost 10000

fetch-all-charts:
	cd $(AETHERCHARTDIR); \
	git fetch --all; \
	cd $(SDRANCHARTDIR); \
	git fetch --all;


enable-fbah-gui:
	kubectl wait --for=condition=available deployment/fb-ah-xapp -n riab --timeout=300s
	kubectl wait --for=condition=available deployment/fb-ah-gui -n riab --timeout=300s
	kubectl wait --for=condition=available deployment/fb-kpimon-xapp -n riab --timeout=300s
	until [ $(shell kubectl exec -it deployment/onos-cli -n riab -- onos topo get entity --no-headers | grep e2cell | wc -l) -eq 6 ]; do sleep 1; done
	$(SCRIPTDIR)/push-cell-loc.sh
	kubectl rollout -n riab restart deployments/fb-ah-gui
	kubectl rollout -n riab status deployments/fb-ah-gui
	kubectl rollout -n riab restart deployments/fb-ah-xapp
	kubectl rollout -n riab status deployments/fb-ah-xapp
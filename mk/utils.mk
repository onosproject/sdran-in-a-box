# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

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
	while true; do sleep 1; NUM_CELLS=$$(kubectl exec -it deployment/onos-cli -n riab -- onos topo get entity --no-headers | grep e2cell | wc -l); if [ $$NUM_CELLS -eq 6 ]; then break; fi; echo "Waiting until cells are all up"; done
	$(SCRIPTDIR)/push-cell-loc.sh
	kubectl rollout -n riab restart deployments/fb-ah-gui
	kubectl rollout -n riab status deployments/fb-ah-gui
	kubectl rollout -n riab restart deployments/fb-ah-xapp
	kubectl rollout -n riab status deployments/fb-ah-xapp
# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

# PHONY definitions
TEST_PHONY					:= test-user-plane test-kpimon test-pci

test-user-plane: | $(M)/omec $(M)/oai-ue
	@echo "*** T1: Internal network test: ping $(shell echo $(CORE_GATEWAY) | awk -F '/' '{print $$1}') (Internal router IP) ***"; \
	ping -c 3 $(shell echo $(CORE_GATEWAY) | awk -F '/' '{print $$1}') -I oaitun_ue1; \
	echo "*** T2: Internet connectivity test: ping to 8.8.8.8 ***"; \
	ping -c 3 8.8.8.8 -I oaitun_ue1; \
	echo "*** T3: DNS test: ping to google.com ***"; \
	ping -c 3 google.com -I oaitun_ue1;

test-kpimon: | $(M)/ric
	@echo "*** Get KPIMON result through CLI ***"; \
	kubectl exec -it deploy/onos-cli -n riab -- onos kpimon list metrics;

test-pci: | $(M)/ric
	@echo "*** Get PCI result through CLI ***"; \
	kubectl exec -it deployment/onos-cli -n riab -- onos pci get resolved;

test-mlb: | $(M)/ric
	@echo "*** Get MLB result through CLI ***"; \
	kubectl exec -it deployment/onos-cli -n riab -- onos mlb list ocns;

test-rnib: | $(M)/ric
	@echo "*** Get R-NIB result through CLI ***"; \
	kubectl exec -it deployment/onos-cli -n riab -- onos topo get entity -v;

test-uenib: | $(M)/ric
	@echo "*** Get UE-NIB result through CLI ***"; \
	kubectl exec -it deployment/onos-cli -n riab -- onos uenib get ues -v;

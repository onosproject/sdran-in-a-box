# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

# PHONY definitions
TEST_PHONY					:= test-user-plane test-kpimon test-kpimon-v1 test-kpimon-v2 test-pci

test-user-plane: | $(M)/omec $(M)/oai-ue
	@echo "*** T1: Internal network test: ping 192.168.250.1 (Internal router IP) ***"; \
	ping -c 3 192.168.250.1 -I oaitun_ue1; \
	echo "*** T2: Internet connectivity test: ping to 8.8.8.8 ***"; \
	ping -c 3 8.8.8.8 -I oaitun_ue1; \
	echo "*** T3: DNS test: ping to google.com ***"; \
	ping -c 3 google.com -I oaitun_ue1;

test-kpimon: | $(M)/ric
	@echo "*** Get KPIMON result through CLI ***"; \
	kubectl exec -it deploy/onos-cli -n riab -- onos kpimon list numues;

test-kpimon-v1: | $(M)/ric
	@echo "*** Get KPIMON result through CLI ***"; \
	kubectl exec -it deploy/onos-cli -n riab -- onos kpimonv1 list metrics;

test-kpimon-v2: | $(M)/ric
	@echo "*** Get KPIMON result through CLI ***"; \
	kubectl exec -it deploy/onos-cli -n riab -- onos kpimonv2 list metrics;

test-pci: | $(M)/ric
	@echo "*** Get PCI result through CLI ***"; \
	kubectl exec -it deployment/onos-cli -n riab -- onos pci listall numconflicts;

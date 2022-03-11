# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

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

test-e2-connection: | $(M)/ric
	@echo "*** Get E2 connections through CLI ***"; \
	kubectl exec -it deployment/onos-cli -n riab -- onos e2t get connections;

test-e2-subscription: | $(M)/ric
	@echo "*** Get E2 subscriptions through CLI ***"; \
	kubectl exec -it deployment/onos-cli -n riab -- onos e2t get subscriptions;

test-rsm-dataplane: $(M)/ric $(M)/omec $(M)/oai-ue
	@echo "*** Test downlink traffic (UDP) ***"
	sudo apt install -y iperf3
	kubectl exec -it router -- apt install -y iperf3
	iperf3 -s -B $$(ip a show oaitun_ue1 | grep inet | grep -v inet6 | awk '{print $$2}' | awk -F '/' '{print $$1}') -p 5001 > /dev/null &
	kubectl exec -it router -- iperf3 -u -c $$(ip a show oaitun_ue1 | grep inet | grep -v inet6 | awk '{print $$2}' | awk -F '/' '{print $$1}') -p 5001 -b 20M -l 1450 -O 2 -t 12 --get-server-output
	pkill -9 -ef iperf3

test-mho: | $(M)/ric
	@echo "*** Get MHO result through CLI - Cells ***"; \
	kubectl exec -it deployment/onos-cli -n riab -- onos mho get cells;
	@echo "*** Get MHO result through CLI - UEs ***"; \
	kubectl exec -it deployment/onos-cli -n riab -- onos mho get ues;

test-a1t: | $(M)/ric
	@echo "*** Get A1T subscriptions through CLI ***"; \
	kubectl exec -it deployment/onos-cli -n riab -- onos a1t get subscription
	@echo "*** Get A1T policy type through CLI ***"; \
	kubectl exec -it deployment/onos-cli -n riab -- onos a1t get policy type
	@echo "*** Get A1T policy objects through CLI ***"; \
	kubectl exec -it deployment/onos-cli -n riab -- onos a1t get policy object
	@echo "*** Get A1T policy status through CLI ***"; \
	kubectl exec -it deployment/onos-cli -n riab -- onos a1t get policy status
# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

# PHONY definitions
UTIL_PHONY					:= detach-ue fetch-all-charts enable-fbah-gui routing-hw-oai routing-hw-omec

detach-ue: | $(M)/oai-enb-cu $(M)/oai-enb-du $(M)/oai-ue
	echo -en "AT+CPIN=0000\r" | nc -u -w 1 localhost 10000
	echo -en "AT+CGATT=0\r" | nc -u -w 1 localhost 10000

fetch-all-charts:
	cd $(AETHERCHARTDIR); \
	git fetch --all; \
	cd $(SDRANCHARTDIR); \
	git fetch --all;

routing-hw-oai:
	sudo ethtool -K $(OAI_ENB_NET_INTERFACE) tx off rx off gro off gso off || true
	sudo route del -net $(ENB_SUBNET) dev $(OAI_ENB_NET_INTERFACE) || true
	sudo route add -net $(ENB_SUBNET) gw $(shell echo $(OMEC_MACHINE_IP) | awk -F '/' '{print $$1}') dev $(OAI_ENB_NET_INTERFACE) || true
	sudo route add -net $(ACCESS_SUBNET) gw $(shell echo $(OMEC_MACHINE_IP) | awk -F '/' '{print $$1}') dev $(OAI_ENB_NET_INTERFACE) || true
	sudo route add -net $(CORE_SUBNET) gw $(shell echo $(OMEC_MACHINE_IP) | awk -F '/' '{print $$1}') dev $(OAI_ENB_NET_INTERFACE) || true


routing-hw-omec:
	$(eval ROUTER_IP=$(shell kubectl exec -it router -- ifconfig eth0 | grep inet | awk '{print $$2}' | awk -F ':' '{print $$2}'))
	$(eval ROUTER_IF=$(shell route -n | grep $(ROUTER_IP)  | awk '{print $$NF}'))
	sudo ethtool -K $(ROUTER_IF) gro off rx off || true
	sudo ethtool -K $(OMEC_DEFAULT_INTERFACE) rx off tx on gro off gso on || true
	sudo ethtool -K enb rx off tx on gro off gso on || true
	sudo route add -host $(shell echo $(OAI_ENB_NET_IP) | awk -F '/' '{print $$1}') gw $(shell echo $(OAI_MACHINE_IP) | awk -F '/' '{print $$1}') dev $(OMEC_DEFAULT_INTERFACE) || true
	kubectl exec -it router -- route add -host $(shell echo $(OAI_ENB_NET_IP) | awk -F '/' '{print $$1}') gw $(shell echo $(OMEC_ENB_NET_IP) | awk -F '/' '{print $$1}') dev enb-rtr || true
	kubectl exec -it router -- ifconfig core-rtr mtu 1550 || true
	kubectl exec -it router -- ifconfig access-rtr mtu 1550 || true
	kubectl exec -it router -- sudo apt update || true
	kubectl exec -it router -- sudo apt install ethtool -y || true
	kubectl exec -it router -- sudo ethtool -K eth0 tx off rx off gro off gso off || true
	kubectl exec -it router -- sudo ethtool -K enb-rtr tx off rx off gro off gso off || true
	kubectl exec -it router -- sudo ethtool -K access-rtr tx off rx off gro off gso off || true
	kubectl exec -it router -- sudo ethtool -K core-rtr tx off rx off gro off gso off || true
	kubectl exec -it upf-0 -n $(RIAB_NAMESPACE) -- ip l set mtu 1550 dev access || true
	kubectl exec -it upf-0 -n $(RIAB_NAMESPACE) -- ip l set mtu 1550 dev core || true
	sudo route add -net $(UE_IP_POOL)/$(UE_IP_MASK) gw $(shell echo $(ENB_GATEWAY) | awk -F '/' '{print $$1}') dev enb || true

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
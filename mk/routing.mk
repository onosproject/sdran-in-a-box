# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

# Phony definition
ROUTING_PHONY					:= routing-hw-oai routing-hw-omec routing-omec routing-external-ran routing-quagga routing-ric-external-ran

routing-hw-oai:
	sudo ethtool -K $(OAI_ENB_NET_INTERFACE) tx off rx off gro off gso off || true
	sudo route del -net $(ENB_SUBNET) dev $(OAI_ENB_NET_INTERFACE) || true
	sudo route add -net $(ENB_SUBNET) gw $(shell echo $(OMEC_MACHINE_IP) | awk -F '/' '{print $$1}') dev $(OAI_ENB_NET_INTERFACE) || true
	sudo route add -net $(ACCESS_SUBNET) gw $(shell echo $(OMEC_MACHINE_IP) | awk -F '/' '{print $$1}') dev $(OAI_ENB_NET_INTERFACE) || true
	sudo route add -net $(CORE_SUBNET) gw $(shell echo $(OMEC_MACHINE_IP) | awk -F '/' '{print $$1}') dev $(OAI_ENB_NET_INTERFACE) || true

routing-hw-omec: routing-omec routing-external-ran routing-quagga

routing-ric-external-ran:
	sudo route add -host $(shell echo $(E2_F1_CU_IPADDR) | awk -F '/' '{print $$1}') gw $(shell echo $(OAI_MACHINE_IP) | awk -F '/' '{print $$1}') dev $(RIC_DEFAULT_IP) || true
	sudo route add -host $(shell echo $(E2_F1_DU_IPADDR) | awk -F '/' '{print $$1}') gw $(shell echo $(OAI_MACHINE_IP) | awk -F '/' '{print $$1}') dev $(RIC_DEFAULT_IP) || true

routing-omec:
	sudo ethtool -K $(OMEC_DEFAULT_INTERFACE) rx off tx on gro off gso on || true
	sudo ethtool -K enb rx off tx on gro off gso on || true
	kubectl exec -it upf-0 -n $(RIAB_NAMESPACE) -- ip l set mtu 1550 dev access || true
	kubectl exec -it upf-0 -n $(RIAB_NAMESPACE) -- ip l set mtu 1550 dev core || true
	sudo route add -net $(UE_IP_POOL)/$(UE_IP_MASK) gw $(shell echo $(ENB_GATEWAY) | awk -F '/' '{print $$1}') dev enb || true

routing-external-ran:
	sudo route add -host $(shell echo $(OAI_ENB_NET_IP) | awk -F '/' '{print $$1}') gw $(shell echo $(OAI_MACHINE_IP) | awk -F '/' '{print $$1}') dev $(OMEC_DEFAULT_INTERFACE) || true
	kubectl exec -it router -- route add -host $(shell echo $(OAI_ENB_NET_IP) | awk -F '/' '{print $$1}') gw $(shell echo $(OMEC_ENB_NET_IP) | awk -F '/' '{print $$1}') dev enb-rtr || true

routing-quagga:
	$(eval ROUTER_IP=$(shell kubectl exec -it router -- ifconfig eth0 | grep inet | awk '{print $$2}' | awk -F ':' '{print $$2}'))
	$(eval ROUTER_IF=$(shell route -n | grep $(ROUTER_IP)  | awk '{print $$NF}'))
	sudo ethtool -K $(ROUTER_IF) gro off rx off || true
	kubectl exec -it router -- ifconfig core-rtr mtu 1550 || true
	kubectl exec -it router -- ifconfig access-rtr mtu 1550 || true
	kubectl exec -it router -- sudo apt update || true
	kubectl exec -it router -- sudo apt install ethtool -y || true
	kubectl exec -it router -- sudo ethtool -K eth0 tx off rx off gro off gso off || true
	kubectl exec -it router -- sudo ethtool -K enb-rtr tx off rx off gro off gso off || true
	kubectl exec -it router -- sudo ethtool -K access-rtr tx off rx off gro off gso off || true
	kubectl exec -it router -- sudo ethtool -K core-rtr tx off rx off gro off gso off || true
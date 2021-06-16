# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

# PHONY definitions
RESET_CLEAN_PHONY			:= reset-oai reset-omec reset-atomix reset-onos-op reset-ric reset-fabric reset-oai-test reset-ransim-test reset-test clean clean-all

reset-oai:
	helm delete -n $(RIAB_NAMESPACE) oai-enb-cu || true
	helm delete -n $(RIAB_NAMESPACE) oai-enb-du || true
	helm delete -n $(RIAB_NAMESPACE) oai-ue || true
	rm -f $(M)/oai-enb-cu*
	rm -f $(M)/oai-enb-du
	rm -f $(M)/oai-ue

reset-oai-enb-cu:
	helm delete -n $(RIAB_NAMESPACE) oai-enb-cu || true
	rm -f $(M)/oai-enb-cu*

reset-oai-enb-du:
	helm delete -n $(RIAB_NAMESPACE) oai-enb-du || true
	rm -f $(M)/oai-enb-du

reset-oai-ue:
	helm delete -n $(RIAB_NAMESPACE) oai-ue || true
	rm -f $(M)/oai-ue

reset-omec:
	helm delete -n $(RIAB_NAMESPACE) omec-control-plane || true
	helm delete -n $(RIAB_NAMESPACE) omec-user-plane || true
	cd $(M); rm -f omec

reset-atomix:
	helm uninstall atomix-controller -n kube-system || true
	helm uninstall atomix-memory-storage -n kube-system || true
	helm uninstall atomix-raft-storage -n kube-system || true
	cd $(M); rm -f atomix

reset-onos-op:
	helm uninstall onos-operator -n kube-system || true
	cd $(M); rm -f onos-operator

reset-ric:
	helm delete -n $(RIAB_NAMESPACE) sd-ran || true
	@until [ $$(kubectl get po -n $(RIAB_NAMESPACE) -l app=onos --no-headers | wc -l) == 0 ]; do sleep 1; done
	cd $(M); rm -f ric

reset-fabric:
	kubectl delete -f $(RESOURCEDIR)/router.yaml || true
	sudo apt remove --purge openvswitch-switch -y || true
	cd $(M); rm -rf fabric

reset-oai-test: reset-omec reset-fabric reset-oai reset-ric

reset-ransim-test: reset-ric

reset-test: reset-oai-test reset-ransim-test reset-onos-op reset-atomix

clean: reset-test
	helm repo remove sdran || true
	source "$(VENV)/bin/activate" && cd $(BUILD)/kubespray; \
	ansible-playbook --extra-vars "reset_confirmation=yes" -b -i inventory/local/hosts.ini reset.yml || true
	@if [ -d /usr/local/etc/emulab ]; then \
		mount | grep /mnt/extra/kubelet/pods | cut -d" " -f3 | sudo xargs umount; \
		sudo rm -rf /mnt/extra/kubelet; \
	fi
	rm -rf $(M)

clean-all: clean
	rm -rf $(CHARTDIR)

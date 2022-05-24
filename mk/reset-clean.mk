# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

# PHONY definitions
RESET_CLEAN_PHONY			:= reset-oai reset-omec reset-atomix reset-onos-op reset-ric reset-fabric reset-oai-test reset-ransim-test reset-test clean clean-all reset-prom-op-servicemonitor

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

reset-5gc:
	helm uninstall -n $(RIAB_NAMESPACE) sim-app || true
	helm uninstall -n $(RIAB_NAMESPACE) fgc-core || true
	helm uninstall -n $(RIAB_NAMESPACE) 5g-core-up || true
	helm uninstall -n $(RIAB_NAMESPACE) 5g-ransim-plane || true
	helm uninstall -n $(RIAB_NAMESPACE) mongo || true
	cd $(M); rm -f 5gc

reset-atomix:
	helm uninstall atomix-controller -n kube-system || true
	helm uninstall atomix-memory-storage -n kube-system || true
	helm uninstall atomix-raft-storage -n kube-system || true
	helm uninstall raft-storage-controller -n kube-system || true
	helm uninstall cache-storage-controller -n kube-system || true
	kubectl delete -f https://raw.githubusercontent.com/atomix/kubernetes-controller/0a9e82ef37df25cf567a4dbc18f35b2bb454bda1/deploy/atomix-controller.yaml || true
	kubectl delete -f https://raw.githubusercontent.com/atomix/raft-storage-controller/668951dff14e339f3c71b489863cbca8ec326a96/deploy/raft-storage-controller.yaml || true
	kubectl delete -f https://raw.githubusercontent.com/atomix/cache-storage-controller/85014c6216e3d8cdf22df09aab3d1f16852fc584/deploy/cache-storage-controller.yaml || true
	for i in $$(kubectl get crd --no-headers --all-namespaces | grep atomix | awk '{print $$1}'); do for j in $$(kubectl get $$i --no-headers -n kube-system | awk '{print $$1}'); do kubectl patch $$i/$$j -n kube-system --type=merge --patch '{"metadata":{"finalizers":[]}}' || true; done; for k in $$(kubectl get $$i --no-headers -n riab | awk '{print $$1}'); do kubectl patch $$i/$$k -n riab --type=merge --patch '{"metadata":{"finalizers":[]}}' || true; done; kubectl delete crd $$i || true; done
	cd $(M); rm -f atomix

reset-onos-op:
	helm uninstall onos-operator -n kube-system || true
	for i in $$(kubectl get crd --no-headers --all-namespaces | grep onos | awk '{print $$1}'); do for j in $$(kubectl get $$i --no-headers -n kube-system | awk '{print $$1}'); do kubectl patch $$i/$$j -n kube-system --type=merge --patch '{"metadata":{"finalizers":[]}}' || true; done; for k in $$(kubectl get $$i --no-headers -n riab | awk '{print $$1}'); do kubectl patch $$i/$$k -n riab --type=merge --patch '{"metadata":{"finalizers":[]}}' || true; done; kubectl delete crd $$i || true; done
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

reset-prom-op-servicemonitor:
	kubectl delete  -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.54.0/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml || true
	cd $(M); rm -rf prom-op-servicemonitor

reset-test: reset-oai-test reset-5gc reset-ransim-test reset-prom-op-servicemonitor reset-onos-op reset-atomix

clean: reset-test
	helm repo remove sdran || true
	@if [[ $(OS_VENDOR) =~ (Debian) ]]; then \
		cp $(RESOURCEDIR)/kubespray-reset-defaults.yml $(BUILD)/kubespray/roles/reset/defaults/main.yml; \
	fi
	source "$(VENV)/bin/activate" && cd $(BUILD)/kubespray; \
	ansible-playbook --extra-vars "reset_confirmation=yes" -b -i inventory/local/hosts.ini reset.yml || true
	@if [ -d /usr/local/etc/emulab ]; then \
		mount | grep /mnt/extra/kubelet/pods | cut -d" " -f3 | sudo xargs umount; \
		sudo rm -rf /mnt/extra/kubelet; \
	fi
	rm -rf $(M)

clean-all: clean
	rm -rf $(CHARTDIR)

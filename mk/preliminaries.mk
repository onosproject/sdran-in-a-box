# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

# PHONY definitions
PRELIMINARIES_PHONY			:= preliminaries $(M)/proxy-setting

preliminaries: $(M) $(M)/system-check $(M)/setup

$(M)/system-check: | $(M) $(M)/repos
	@if [[ $(CPU_FAMILY) -eq 6 ]]; then \
		if [[ $(CPU_MODEL) -lt 60 ]]; then \
			echo "FATAL: haswell CPU or newer is required."; \
			exit 1; \
		fi \
	else \
		echo "FATAL: unsupported CPU family."; \
		exit 1; \
	fi
	@if [[ $(OS_VENDOR) =~ (Ubuntu) ]] || [[ $(OS_VENDOR) =~ (Debian) ]]; then \
		if [[ ! $(OS_RELEASE) =~ (18.04) ]] && [[ ! $(OS_RELEASE) =~ (20.04) ]]; then \
			echo "WARN: $(OS_VENDOR) $(OS_RELEASE) has not been tested."; \
		fi; \
		if dpkg --compare-versions 4.15 gt $(shell uname -r); then \
			echo "FATAL: kernel 4.15 or later is required."; \
			echo "Please upgrade your kernel by running" \
			"apt install --install-recommends linux-generic-hwe-$(OS_RELEASE)"; \
			exit 1; \
		fi \
	else \
		echo "FAIL: unsupported OS."; \
		exit 1; \
	fi
	@if [[ ! -d "$(AETHERCHARTDIR)" ]]; then \
                echo "FATAL: Please manually clone aether-helm-chart under $(CHARTDIR) directory."; \
                exit 1; \
	fi
	@if [[ ! -d "$(SDRANCHARTDIR)" ]]; then \
                echo "FATAL: Please manually clone sdran-helm-chart under $(CHARTDIR) directory."; \
                exit 1; \
	fi
	touch $@

$(M)/setup: | $(M)/system-check $(M)/proxy-setting
	sudo $(SCRIPTDIR)/cloudlab-disksetup.sh
	sudo apt update; sudo apt install -y software-properties-common python3-pip jq httpie ipvsadm ethtool net-tools
	systemctl list-units --full -all | grep "docker.service" || sudo apt install -y docker.io
	sudo adduser $(USER) docker || true
	touch $@

ifeq ($(PROXY_ENABLED),true)
$(M)/proxy-setting: | $(M)
	echo "Defaults env_keep += \"HTTP_PROXY HTTPS_PROXY NO_PROXY http_proxy https_proxy no_proxy\"" | sudo EDITOR='tee -a' visudo -f /etc/sudoers.d/proxy
	echo "HTTP_PROXY=$(HTTP_PROXY)" >> rke2-server
	echo "HTTPS_PROXY=$(HTTPS_PROXY)" >> rke2-server
	echo "NO_PROXY=$(NO_PROXY),.cluster.local,.svc,$(NODE_IP),192.168.84.0/24,192.168.85.0/24,$(RAN_SUBNET)" >> rke2-server
	sudo mv rke2-server /etc/default/
	echo "[Service]" >> http-proxy.conf
	echo "Environment='HTTP_PROXY=$(HTTP_PROXY)'" >> http-proxy.conf
	echo "Environment='HTTPS_PROXY=$(HTTPS_PROXY)'" >> http-proxy.conf
	echo "Environment='NO_PROXY=$(NO_PROXY)'" >> http-proxy.conf
	sudo mkdir -p /etc/systemd/system/docker.service.d
	sudo mv http-proxy.conf /etc/systemd/system/docker.service.d
	sudo systemctl daemon-reload
	sudo systemctl restart docker
	touch $(M)/proxy-setting
else
$(M)/proxy-setting: | $(M)
	@echo -n ""
	touch $(M)/proxy-setting
endif
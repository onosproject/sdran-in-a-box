# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

# PHONY definitions
PRELIMINARIES_PHONY			:= preliminaries

preliminaries: $(M) $(M)/system-check $(M)/setup

$(M)/system-check: | $(M) $(M)/repos
	@if [[ $(CPU_VENDOR) == "GenuineIntel" ]]; then \
		if [[ $(CPU_FAMILY) -eq 6 ]]; then \
			if [[ $(CPU_MODEL) -lt 60 ]]; then \
				echo "FATAL: haswell CPU or newer is required."; \
				exit 1; \
			fi \
		else \
			echo "FATAL: unsupported CPU family."; \
			exit 1; \
		fi \
	fi
	@if [[ $(CPU_VENDOR) == "AuthenticAMD" ]]; then \
		if [[ $(CPU_FAMILY) -gt 22 ]]; then \
			if [[ $(CPU_MODEL) -lt 1 ]]; then \
				echo "FATAL: ryzen 1 CPU or newer is required."; \
				exit 1; \
			fi \
		else \
			echo "FATAL: unsupported CPU family."; \
			exit 1; \
		fi \
	fi
	@if [[ ! (($(CPU_VENDOR) == "GenuineIntel") || ($(CPU_VENDOR) == "AuthenticAMD")) ]]; then \
		echo "FATAL: unsupported CPU vendor."; \
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

$(M)/setup: | $(M)/system-check
	sudo $(SCRIPTDIR)/cloudlab-disksetup.sh
	sudo apt update; sudo apt install -y software-properties-common python3-pip jq httpie ipvsadm ethtool
	touch $@
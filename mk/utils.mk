# Copyright 2020-present Open Networking Foundation
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

# PHONY definitions
UTIL_PHONY					:= detach-ue fetch-all-charts

detach-ue: | $(M)/oai-enb-cu $(M)/oai-enb-du $(M)/oai-ue
	echo -en "AT+CPIN=0000\r" | nc -u -w 1 localhost 10000
	echo -en "AT+CGATT=0\r" | nc -u -w 1 localhost 10000

fetch-all-charts:
	cd $(AETHERCHARTDIR); \
	git fetch --all; \
	cd $(SDRANCHARTDIR); \
	git fetch --all;
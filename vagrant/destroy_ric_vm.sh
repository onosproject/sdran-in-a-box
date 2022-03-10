#!/bin/bash

# Copyright 2022-present Open Networking Foundation
#
# SPDX-License-Identifier: Apache-2.0

echo Run RIC node
pushd ric
sudo vagrant destroy
popd
#!/bin/bash

# Copyright 2022-present Open Networking Foundation
#
# SPDX-License-Identifier: Apache-2.0

echo Run RAN node
pushd ran
sudo vagrant up
popd

echo Run RIC node
pushd ric
sudo vagrant up
popd

echo Run OMEC node
pushd omec
sudo vagrant up
popd
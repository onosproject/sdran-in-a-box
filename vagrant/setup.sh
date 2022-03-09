#!/bin/bash

# Copyright 2022-present Open Networking Foundation
#
# SPDX-License-Identifier: Apache-2.0

echo Install VM hypervisor and OpenVSwitch
sudo apt update
sudo apt install qemu libvirt-daemon-system libvirt-clients libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev ruby-libvirt ebtables dnsmasq-base qemu-kvm libvirt-bin bridge-utils virt-manager openvswitch-switch -y

echo Install Vagrant
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vagrant -y

echo Add Vagrant plugins
vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-mutate

echo Add OVS
sudo ovs-vsctl --may-exist add-br br0
sudo ovs-vsctl show

./run_vms.sh
# SPDX-FileCopyrightText: 2020-present Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: Apache-2.0

Vagrant.configure(2) do |config|
    config.vm.define "ric" do |ric|
        ric.vm.box = "generic/ubuntu1804"
        ric.vm.disk :disk, size: "30GB", primary: true
        ric.vm.hostname = "ric"
        ric.vm.network :public_network, :dev => "br0", :ovs => true, :mode => "bridge", :type => "bridge"
        ric.vm.provider "libvirt" do |v|
            v.cpus = 4
            v.memory = 8192
        end
    end
end
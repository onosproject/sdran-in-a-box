# SPDX-FileCopyrightText: 2020-present Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: Apache-2.0

Vagrant.configure(2) do |config|
    config.vm.define "omec" do |omec|
        omec.vm.box = "generic/ubuntu1804"
        omec.vm.disk :disk, size: "30GB", primary: true
        omec.vm.hostname = "omec"
        omec.vm.network :public_network, :dev => "br0", :ovs => true, :mode => "bridge", :type => "bridge"
        omec.vm.provider "libvirt" do |v|
            v.cpus = 4
            v.memory = 8192
        end
    end
end
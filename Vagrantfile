# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

IMAGE_NAME      = "generic/ubuntu2004"
IP_NETWORK      = "192.168.60."
IP_NODE_START   = 1
NUM_NODE        = 1
NODE_MEMORY     = 4096
NODE_CPU        = 2

Vagrant.configure("2") do |config|
    config.vm.box = IMAGE_NAME

    (1..NUM_NODE).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.hostname = "node-#{i}"
            node.vm.provider "libvirt" do |lv|
                lv.memory = NODE_MEMORY
                lv.cpus   = NODE_CPU
            end
            node.vm.network "private_network",
                :ip                     => IP_NETWORK + "#{IP_NODE_START + i}",
                :libvirt__guest_ipv6    => "no"
            node.vm.network "forwarded_port", guest: 80, host: "#{8080 + i}"
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "ansible/playbooks/ami-provisioning.yaml"
            end
        end
    end
end             
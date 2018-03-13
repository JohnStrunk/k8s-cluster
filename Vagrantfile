# -*- mode: ruby -*-
# vi: set ft=ruby :

WORKERS = 3
DISKS = 1
DISKSIZE = "30G"

Vagrant.configure("2") do |config|
  #config.vm.box = "fedora/26-cloud-base"
  config.vm.box = "centos/7"
  config.vm.provider "libvirt" do |lv|
    lv.cpus = "2"
    lv.memory = "2048"
    lv.nested = true
    lv.volume_cache = "none"
  end

  # Can't write to /vagrant on atomic-host, so disable default sync dir
  config.vm.synced_folder ".", "/vagrant", disabled: true


  config.vm.define "master" do |node|
    node.vm.hostname = "master"
    # master gets this repo synced to /vagrant
    node.vm.synced_folder ".", "/vagrant", type: "sshfs"
  end

  (0..WORKERS-1).each do |i|
    config.vm.define "worker#{i}" do |node|
      node.vm.hostname = "worker#{i}"
      node.vm.provider "libvirt" do |provider|
        for _ in 0..DISKS-1 do
          provider.storage :file, :size => DISKSIZE
        end
      end
      # Only set up provisioning on the last worker node so ansible only gets
      # called once during the provisioning step.
      if i == WORKERS-1
        node.vm.provision :ansible do |ansible|
          #ansible.extra_vars = {
          #  "master_ip" => MASTER_IP
          #}
          ansible.groups = {
            "masters" => ["master"],
            "workers" => (0..WORKERS-1).map {|j| "worker#{j}"}
          }
          ansible.limit = "all"
          ansible.playbook = "ansible/initial_provisioning.yml"
          #ansible.verbose = true
        end
      end
    end
  end
end

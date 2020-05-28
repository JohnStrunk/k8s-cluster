# -*- mode: ruby -*-
# vi: set ft=ruby :

WORKERS = 3
DISKS = 2
DISKSIZE = "30G"

Vagrant.configure("2") do |config|
  #config.vm.box = "fedora/26-cloud-base"
  config.vm.box = "centos/7"
  config.vm.provider "libvirt" do |lv|
    lv.channel :type => "unix", :target_name => "org.qemu.guest_agent.0", :target_type => "virtio"
    lv.cpus = "2"
    lv.cpu_mode = "host-passthrough"
    lv.graphics_type = "none"
    lv.memory = "2048"
    lv.nested = false
    lv.random :model => "random"
    # lv.usb_controller :model => "none"  # (requires vagrant-libvirt 0.44 which is not in Fedora yet)
    lv.volume_cache = "writeback"
    lv.video_type = "vga"
    lv.video_vram = "1024"
    # Always use system connection instead of QEMU session
    lv.qemu_use_session = false
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
          ansible.groups = {
            "masters" => ["master"],
            "workers" => (0..WORKERS-1).map {|j| "worker#{j}"}
          }
          ansible.limit = "all"
          ansible.playbook = "ansible/initial_provisioning.yml"
        end
      end
    end
  end
end

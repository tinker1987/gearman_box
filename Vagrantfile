# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
	config.vm.box = "ubuntu/trusty64"
	config.vm.hostname = "vagrant-s1"
	config.vm.box_check_update = false
	config.vm.network "private_network", ip: "192.168.33.101"

	# configure your folders
	config.vm.synced_folder "~/Development/queues/converter", "/home/vagrant/projects/converter"

	config.vm.provider "virtualbox" do |vb|
		vb.gui = false
		vb.cpus = 2
		vb.memory = "1024"
	end

	config.vm.provision "sutup", type: "shell", :path => "scripts/setup.sh", :args =>"-imn"
	config.vm.provision "sutup_gearman", type: "shell", :path => "scripts/install_gearman.sh", :args =>"-lguodsm"
	config.vm.provision "shell", inline: <<-SHELL
		cp /vagrant/scripts/gearmand /etc/init.d/gearmand
	SHELL
end

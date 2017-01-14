Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"
  config.vm.network :forwarded_port, guest: 443, host: 443

  config.vm.provider "virtualbox" do |v|
    v.name = "Own-Mailbox-Proxy"
    v.memory = 256
  end

  config.vm.provision "shell", inline: <<-SHELL
    cd /vagrant/
    DEBIAN_FRONTEND=noninteractive ./packages.sh
    DEBIAN_FRONTEND=noninteractive ./install.sh
  SHELL
end

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_url = "https://app.vagrantup.com/ubuntu/boxes/xenial64"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.provision :shell, :path => "provisioning/bootstrap.sh"
  config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=666"]
end
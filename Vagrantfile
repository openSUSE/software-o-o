# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'
IMAGE_USERID=`id -u`

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "default" do |web|
    web.vm.provider 'docker' do |d|
      d.build_dir       = "."
      d.name            = 'software_web'
      d.create_args     = ['-i', '-t']
      d.build_args      = ['--build-arg', "IMAGE_USERID=#{IMAGE_USERID}"]
      d.cmd             = ['/bin/bash', '-l']
      d.remains_running = false
      d.ports           = ['3000:3000']
    end
  end

end

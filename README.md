Own-Mailbox Proxy Server
========================

Installation in a docker container
----------------------------------

First install docker: https://docs.docker.com/engine/installation/linux/debian/

Then:

+ ./docker.sh build
+ ./docker.sh create
+ ./docker.sh install
+ ./docker.sh shell


Installation in a virtual machine
---------------------------------

First install Vagrant: https://www.vagrantup.com/downloads.html

Then:

+ vagrant up
+ vagrant ssh

Etc. (see: https://www.vagrantup.com/docs/getting-started/)

Note: For the time being, `mysql-server` fails to be installed
in the virtual machine.

# Own-Mailbox Proxy Server

## Prerequisite
You need to have:
+ A machine with a public IP address with a clean reputation.
+ A domain name (E.g omb.one) configured so that the authority DNS for this name is the machine described above.

You need to edit settings file and change:
+ SERVER_IP: The ip of the proxy
+ MASTER_DOMAIN: your domain name
+ DBPASS: The db password (don't leave it to default)

## Installation on Debian Jessie
Warning!!! make sure your machine is fully dedicated to being the proxy
before running this. Do not install this way on a machine that hosts other services.

./install-wo-docker.sh

## Installation in Virtualbox with vagrant

vagrant up

## Installation with docker
Warning!!! make sure your machine is fully dedicated to being the proxy
before running this. Do not install this way on a machine that hosts other services.

Also make sure that __no Apache2, mysql/mariadb or tor__ is running on the host machine.

+ First install docker: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/

+ Then build and run the docker image:
  ```
  docker build -t proxy .
  docker run -d --network host --hostname proxy --name=proxy proxy
  ```
  + The `--network host` option is essential for the proxy functionality as it forces the container
  to use the host machine's network stack.
  + The `--hostname proxy` option changes the hostname of the container to "proxy" (as by default it is the
  same with the host's hostname).


+ You can get shell access to the container (if needed) by using:

  ```
  docker exec -it proxy bash
  ```

An automated build/run script will be in a future update


## Web interfaces

you can access:

+ phpmyadmin:  [yourserver]/phpmyadmin
+ Create identification links: [yourserver]/request-omb/Create_Acounts/

## Trouble shooting

If the DNS configuration did not fully propagate at the time of installation, you may not
get a https certificate. Make sure your server responds in https on port 6565:

+ https://[yourserver]:6565/

If not run
+ scripts/cfg/get-ssl-cert.sh

Once DNS configuration is fully updated.

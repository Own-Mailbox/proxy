# Own-Mailbox Proxy Server

## Installation

+ First install docker: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/

+ Then install Docker-Scripts: https://github.com/docker-scripts/ds#installation

    git clone https://github.com/docker-scripts/ds /opt/docker-scripts/ds
    cd /opt/docker-scripts/ds/
    make install

+ Next, get OMB-Proxy, init the workdir, and fix/customize the settings:

    git clone https://github.com/Own-Mailbox/proxy /opt/docker-scripts/omb/proxy
    ds init omb/proxy @ombproxy
    cd /var/ds/ombproxy
    vim settings.sh

+ Finally create and start the container:

    cd /var/ds/ombproxy
    ds make

  The last command is actually a shortcut for `ds build; ds create; ds config`.


## Maintenance

Try:

    ds stop
    ds start
    ds shell
    ds help

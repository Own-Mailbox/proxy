#!/bin/bash

# go to the directory of the script
cd $(dirname $0)

IMAGE=ownmailboxproxy
CONTAINER=ownmailboxproxy

cmd_help() {
    cat <<-_EOF
Usage: $0 ( build | create | install | shell | erase | start | stop )

Build the image, create the container, and install own-mailbox-proxy:
    $0 build [Dockerfile]
    $0 create
    $0 install

Enter the shell of the container:
    $0 shell

When testing is done, clean up the container and the image:
    $0 erase

Otherwise, stop and start it as needed:
    $0 stop
    $0 start

_EOF
}

cmd_build() {
    local dockerfile=${1:-"Dockerfile"}

    datestamp=$(date +%F | tr -d -)
    nohup_out=nohup-$IMAGE-$datestamp.out
    rm -f $nohup_out
    nohup nice docker build --tag=$IMAGE --file="$dockerfile" . > $nohup_out &
    sleep 1
    tail -f $nohup_out
}

cmd_create() {
    ### configure the host for running systemd containers
    if [[ -z $(nsenter --mount=/proc/1/ns/mnt -- mount | grep /sys/fs/cgroup/systemd) ]]; then
	[[ ! -d /sys/fs/cgroup/systemd ]] && mkdir -p /sys/fs/cgroup/systemd
	nsenter --mount=/proc/1/ns/mnt -- mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
    fi

    cmd_stop
    docker rm $CONTAINER 2>/dev/null

    docker create --name=$CONTAINER --hostname=$CONTAINER \
        --restart=unless-stopped \
        --cap-add ALL --privileged=true \
        --tmpfs /run --tmpfs /run/lock \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        -v "$(pwd)":/proxy -w /proxy \
        -p 80:80 -p 443:443 \
        $IMAGE
        #--cap-add SYS_ADMIN --cap-add=NET_ADMIN \
}

cmd_install() {
    cmd_start
    cmd_exec ./install.sh
    sleep 5
    cmd_stop
    cmd_start
}

cmd_exec() {
    docker exec -it $CONTAINER env TERM=xterm \
        script /dev/null -c "$@" -q
}

cmd_shell() {
    cmd_start
    cmd_exec bash
}

cmd_start() {
    docker start $CONTAINER
    #cmd_exec "/etc/init.d/haveged start"
}

cmd_stop() {
    docker stop $CONTAINER 2>/dev/null
}

cmd_erase() {
    cmd_stop
    docker rm $CONTAINER 2>/dev/null
    docker rmi $IMAGE 2>/dev/null
}

# run the given command
cmd=${1:-help} ; shift
case $cmd in
    help|build|create|install|shell|erase|start|stop) cmd_$cmd "$@" ;;
    *) docker "$@" ;;
esac

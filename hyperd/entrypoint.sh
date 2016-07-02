#! /bin/bash

SRCHYPERHQ=$GOPATH/src/github.com/hyperhq
SRCDIR="hyperd hyperstart runv"
MODULES="kvm_intel tun"

if [ -z $SKIPREBUILD ]; then
    pushd .
    for I in $SRCDIR; do
        cd $SRCHYPERHQ/$I
        git pull
        ./autogen.sh && ./configure && make
    done
    popd
fi

for I in $MODULES; do
    /sbin/modprobe $I
done

sh /cgroupfs-mount

libvirtd 2>&1 > /var/log/libvirtd.log &

# wait a bit for libvirtd to come up
SECONDS=0
while [ $SECONDS -lt 30 ]
do
    ip addr show dev virbr0
    if [ $? -ne 0 ]; then
        sleep 1
    else
        break
    fi
done

# get correct bridge ip
CIDR=`ip addr show dev virbr0|grep "inet\ "|awk '{print $2}'`
sed -i -e "/BridgeIP=/d" /etc/hyper/config
echo BridgeIP=$CIDR >> /etc/hyper/config

hyperd --nondaemon --v=3 --log_dir=/var/log/hyper

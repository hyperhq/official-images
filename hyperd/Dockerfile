From centos:7
MAINTAINER Hyper Developers <dev@hyper.sh>

RUN yum install -y git wget qemu-kvm curl autoconf automake gcc make cpio pkg-config \
                   device-mapper-devel device-mapper libvirt-devel &&\
    mkdir -p /gopath/src/github.com/hyperhq &&\
    mkdir -p /goroot/ &&\
    mkdir -p /tmp/

ENV GIT_SSL_NO_VERIFY true

RUN cd /gopath/src/github.com/hyperhq &&\
    git clone https://github.com/hyperhq/hyperstart.git hyperstart &&\
    git clone https://github.com/hyperhq/runv.git runv &&\
    git clone https://github.com/hyperhq/hyperd.git hyperd &&\
    wget --no-check-certificate -nv https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz -O /tmp/go.tgz

RUN tar xzf /tmp/go.tgz -C /goroot/ &&\
    rm /tmp/go.tgz
ENV GOPATH /gopath/
ENV GOROOT /goroot/go/
ENV PATH $GOROOT/bin:$PATH

RUN yum install -y libvirt libvirt-daemon &&\
    rm -rf /usr/share/qemu &&\
    ln -s /usr/share/qemu-kvm /usr/share/qemu &&\
    wget --no-check-certificate -nv http://hypercontainer-install.s3.amazonaws.com/qemu-hyper-2.4.1-2.el7.centos.x86_64.rpm -O /tmp/qemu-hyper-2.4.1-2.el7.centos.x86_64.rpm &&\
    wget --no-check-certificate -nv http://hypercontainer-install.s3.amazonaws.com/hyperstart-0.6-1.el7.centos.x86_64.rpm -O /tmp/hyperstart-0.6-1.el7.centos.x86_64.rpm &&\
    wget --no-check-certificate -nv http://hypercontainer-install.s3.amazonaws.com/hyper-container-0.6-1.el7.centos.x86_64.rpm -O /tmp/hyper-container-0.6-1.el7.centos.x86_64.rpm &&\
    yum install -y /tmp/*.rpm &&\
    rm -f /tmp/*.rpm

RUN cd /gopath/src/github.com/hyperhq/hyperstart &&\
    ./autogen.sh &&\
    ./configure &&\
    make

RUN cd /gopath/src/github.com/hyperhq/hyperd &&\
    ./autogen.sh &&\
    ./configure &&\
    make

RUN rm -f /usr/local/bin/hyper /usr/local/bin/hyperd /usr/local/bin/hyperctl \
      /usr/bin/hyper /usr/bin/hyperd /usr/bin/hyperctl \
      /var/lib/hyper/kernel /var/lib/hyper/hyper-initrd.img \
      /var/lib/hyper/cbfs.rom /var/lib/hyper/bios-qboot.bin &&\
      ln -s /gopath/src/github.com/hyperhq/hyperd/hyperd /usr/local/bin/hyperd &&\
      ln -s /gopath/src/github.com/hyperhq/hyperd/hyperctl /usr/local/bin/hyperctl &&\
      ln -s /gopath/src/github.com/hyperhq/hyperstart/build/kernel /var/lib/hyper/kernel &&\
      ln -s /gopath/src/github.com/hyperhq/hyperstart/build/hyper-initrd.img /var/lib/hyper/hyper-initrd.img &&\
      ln -s /usr/local/bin/hyperclt /usr/bin/ &&\
      ln -s /usr/local/bin/hyperd /usr/bin/

RUN echo -e "Hypervisor=libvirt\n\
Kernel=/var/lib/hyper/kernel\n\
Initrd=/var/lib/hyper/hyper-initrd.img\n\
DisableIptables=true\n\
StorageDriver=overlay\n\
Bridge=virbr0\n\
BridgeIP=192.168.140.0/24\n\
ContainerDB=127.0.0.1" > /etc/hyper/config

RUN sed -i -e '/unix_sock_rw_perms/d' -e '/unix_sock_admin_perms/d' -e '/clear_emulator_capabilities/d' \
           -e '/unix_sock_group/d' -e '/auth_unix_ro/d' -e '/auth_unix_rw/d' /etc/libvirt/libvirtd.conf &&\
    echo unix_sock_rw_perms=\"0777\" >> /etc/libvirt/libvirtd.conf &&\
    echo unix_sock_admin_perms=\"0777\" >> /etc/libvirt/libvirtd.conf &&\
    echo unix_sock_group=\"root\" >> /etc/libvirt/libvirtd.conf &&\
    echo unix_sock_ro_perms=\"0777\" >> /etc/libvirt/libvirtd.conf &&\
    echo auth_unix_ro=\"none\" >> /etc/libvirt/libvirtd.conf &&\
    echo auth_unix_rw=\"none\" >> /etc/libvirt/libvirtd.conf

RUN sed -i -e '/^clear_emulator_capabilities =/d' -e '/^user =/d' -e '/^group =/d' /etc/libvirt/qemu.conf &&\
    echo clear_emulator_capabilities=0 >> /etc/libvirt/qemu.conf &&\
    echo user=\"root\" >> /etc/libvirt/qemu.conf &&\
    echo group=\"root\" >> /etc/libvirt/qemu.conf &&\
    sed -i -e 's/192\.168\.122\./192\.168\.140\./g' /etc/libvirt/qemu/networks/default.xml

ADD cgroupfs-mount /cgroupfs-mount
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

FROM fedora:25
MAINTAINER Hyper Developers <dev@hyper.sh>

RUN dnf install -y cmake gcc git gcc-c++ krb5-devel bison flex rpcbind iproute; dnf clean all; mkdir /root/src; git clone --recursive -b V2.4-stable https://github.com/nfs-ganesha/nfs-ganesha.git /root/src/nfs-ganesha; cd /root/src/nfs-ganesha/src/; mkdir build; cd build; cmake -DUSE_FSAL_GPFS=OFF ..; make; make install; rm -rf /root/src; dnf remove -y cmake gcc git gcc-c++ bison flex
RUN mkdir -p /var/lib/nfs/ganesha /run/rpcbind/

EXPOSE 2049/tcp
ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

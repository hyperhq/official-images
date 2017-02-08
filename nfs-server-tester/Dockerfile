FROM hyperhq/nfs-server
MAINTAINER Hyper Developers <dev@hyper.sh>

RUN mkdir /export && dd if=/dev/zero of=/vol bs=100M count=0 seek=1 && mkfs.ext4 /vol

EXPOSE 2049/tcp
ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

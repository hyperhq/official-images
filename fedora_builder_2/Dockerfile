FROM       fedora:25
MAINTAINER Hyper Developers <dev@hyper.sh>

RUN dnf install -y @development-tools git fedora-packager rpmdevtools \
	automake autoconf gcc make glibc-devel glibc-devel.i686 device-mapper-devel pcre-devel libsepol-devel libselinux-devel systemd-devel sqlite-devel libvirt-devel \
	gcc-c++ zlib-devel libcap-devel libattr-devel librbd1-devel libtool awscli && \
	dnf clean all
RUN curl -sL https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz | tar -C /usr/local -zxf -
RUN /usr/sbin/useradd makerpm; usermod -a -G mock makerpm; su makerpm -c 'rpmdev-setuptree'

ADD entrypoint.sh /home/makerpm/
RUN mkdir -p ~makerpm/{hyperd,hyperstart} &&\
	cd ~makerpm/hyperd && git init && git remote add origin https://github.com/hyperhq/hyperd.git && \
	cd ~makerpm/hyperstart && git init && git remote add origin https://github.com/hyperhq/hyperstart.git && \
	chown -R makerpm.makerpm ~makerpm/{hyperd,hyperstart}

ENV PATH /usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

USER       makerpm
WORKDIR    /home/makerpm
ENTRYPOINT ["/home/makerpm/entrypoint.sh"]

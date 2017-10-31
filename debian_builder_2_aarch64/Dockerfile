FROM       aarch64/debian:jessie
MAINTAINER Hyper Developers <dev@hyper.sh>

RUN apt-get update &&\
	apt-get install -y autoconf automake pkg-config dh-make cpio git \
		libdevmapper-dev libsqlite3-dev libvirt-dev python-pip && \
	pip install awscli && \
	apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -sL https://redirector.gvt1.com/edgedl/go/go1.8.5.linux-arm64.tar.gz | tar -C /usr/local -zxf -

RUN useradd makedeb && mkdir -p ~makedeb/.aws && chown -R makedeb.makedeb ~makedeb && chmod og-rw ~makedeb/.aws
RUN mkdir -p /hypersrc/hyperd/../hyperstart &&\
	cd /hypersrc/hyperd && git init && git remote add origin https://github.com/hyperhq/hyperd.git && \
	cd /hypersrc/hyperstart && git init && git remote add origin https://github.com/hyperhq/hyperstart.git && \
	chown makedeb.makedeb -R /hypersrc

ENV PATH /usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ADD entrypoint.sh /

USER makedeb
WORKDIR /hypersrc
ENTRYPOINT ["/entrypoint.sh"]


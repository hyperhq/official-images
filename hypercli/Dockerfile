From ubuntu:trusty

RUN  apt-get update &&\
     apt-get install --no-install-recommends --no-install-suggests -y git wget gcc libc6-dev &&\
     mkdir -p /gopath/src/github.com/hyperhq &&\
     mkdir -p /goroot/ &&\
     mkdir -p /tmp &&\
     rm -rf /var/lib/apt/lists/*

ENV GIT_SSL_NO_VERIFY=true

RUN cd /gopath/src/github.com/hyperhq &&\
    git clone https://github.com/hyperhq/hypercli.git &&\
    wget --no-check-certificate -nv https://storage.googleapis.com/golang/go1.9.3.linux-amd64.tar.gz -O /tmp/go.tgz &&\
    tar xzf /tmp/go.tgz -C /goroot/ &&\
    rm /tmp/go.tgz

ENV GOPATH /gopath/
ENV GOROOT /goroot/go/
ENV PATH $GOROOT/bin:/usr/local/bin:$PATH

RUN cd /gopath/src/github.com/hyperhq/hypercli &&\
    ./build.sh &&\
    cp hyper/hyper /usr/local/bin

RUN apt-get purge --yes git wget gcc libc6-dev && apt-get autoremove --yes && rm -rf /gopath /goroot

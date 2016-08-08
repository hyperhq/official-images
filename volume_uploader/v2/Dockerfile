From ubuntu:trusty

RUN  apt-get update &&\
     apt-get install --no-install-recommends --no-install-suggests -y git wget &&\
     mkdir -p /gopath/src/github.com/hyperhq &&\
     mkdir -p /goroot/ &&\
     mkdir -p /tmp &&\
     rm -rf /var/lib/apt/lists/*

ENV GIT_SSL_NO_VERIFY=true

RUN cd /gopath/src/github.com/hyperhq &&\
    git clone https://github.com/bergwolf/daytona.git &&\
    wget --no-check-certificate -nv https://storage.googleapis.com/golang/go1.6.3.linux-amd64.tar.gz -O /tmp/go.tgz &&\
    tar xzf /tmp/go.tgz -C /goroot/ &&\
    rm /tmp/go.tgz

ENV GOPATH /gopath/
ENV GOROOT /goroot/go/
ENV PATH $GOROOT/bin:$PATH

RUN cd /gopath/src/github.com/hyperhq/daytona &&\
    go build daytona.go &&\
    cp daytona /

ADD entrypoint.sh /entrypoint.sh

RUN echo -e "#! /bin/bash\n\
cd /gopath/src/github.com/hyperhq/daytona\n\
git pull\n\
go build daytona.go\n\
cp daytona /\n\
cd /\n\
/daytona" > /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]

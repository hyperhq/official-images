From ubuntu:trusty

RUN  apt-get update &&\
     apt-get install --no-install-recommends --no-install-suggests -y git wget vsftpd &&\
     mkdir -p /var/run/vsftpd/empty &&\
     sed -i -e '/^root$/d' /etc/ftpusers &&\
     touch /etc/vsftpd.userlist &&\
     sed -i -e '/^root$/d' /etc/vsftpd.userlist &&\
     rm -rf /var/lib/apt/lists/*

ENV GIT_SSL_NO_VERIFY=true

ADD vsftpd.conf /etc/vsftpd.conf
ADD entrypoint.sh /entrypoint.sh

EXPOSE 20 21 10010-10020

ENTRYPOINT ["/entrypoint.sh"]

#! /bin/sh

if [ x$ROOTPASSWORD != "x" ]; then
	echo "$ROOTPASSWORD\n$ROOTPASSWORD" | passwd root
fi

if [ x$LOCALROOT != "x" ]; then
	mkdir -p $LOCALROOT
	sed -i -e '/^local_root/d' /etc/vsftpd.conf
	echo "local_root=$LOCALROOT" >> /etc/vsftpd.conf
fi

/usr/sbin/vsftpd /etc/vsftpd.conf

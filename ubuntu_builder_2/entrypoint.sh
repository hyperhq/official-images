#!/bin/bash

HYPERD_REF=${HYPERD_REF:-heads/master}
HYPERSTART_REF=${HYPERSTART_REF:-heads/master}
BUILD=${BUILD:-yes}
UPLOAD=${UPLOAD:-none}
ACCESS=${AWS_ACCESSKEY:-none}
SECRET=${AWS_SECRETKEY:-none}

cd /hypersrc/hyperd
echo "fetch hyperd ${HYPERD_REF}"
git fetch origin +refs/${HYPERD_REF#ref/}:refs/remotes/origin/target
git checkout -b target origin/target
hyperd_version=$(grep AC_INIT configure.ac|cut -d, -f2 |tr -d ' []')

cd /hypersrc/hyperstart
echo "fetch hyperstart ${HYPERSTART_REF}"
git fetch origin +refs/${HYPERSTART_REF#ref/}:refs/remotes/origin/target
git checkout -b target origin/target
hyperstart_version=$(grep AC_INIT configure.ac|cut -d, -f2 |tr -d ' []')

cat > ~/.aws/config <<END
[default]
region = us-west-1
END

cat > ~/.aws/credentials <<END
[default]
aws_access_key_id = ${ACCESS}
aws_secret_access_key = ${SECRET}
END
chmod og-rwx -R ~/.aws

if [ "${BUILD}x" == "yesx" ]; then
	echo Build packages...
        cd /hypersrc/hyperd/package/ubuntu/hypercontainer
	VERSION=${hyperd_version} BRANCH=target ./make-hypercontainer-deb.sh
        cd /hypersrc/hyperd/package/ubuntu/hyperstart
	VERSION=${hyperstart_version} BRANCH=target ./make-hyperstart-deb.sh

	if [ "${UPLOAD}x" != "nonex" ]; then
		echo "Upload packages to ${UPLOAD}..."
		for deb in /hypersrc/hyperd/package/ubuntu/hyperstart/*; do
			aws s3 cp $deb s3://hypercontainer-build/${UPLOAD}/$(basename $deb)
		done
		for deb in /hypersrc/hyperd/package/ubuntu/hypercontainer/*; do
			aws s3 cp $deb s3://hypercontainer-build/${UPLOAD}/$(basename $deb)
		done
	fi
fi

if [ $# -gt 0 ] ; then
	echo "now execute [$@]"
	exec $@
fi
echo finished.

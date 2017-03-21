#!/bin/bash

HYPERD_REF=${HYPERD_REF:-heads/master}
HYPERSTART_REF=${HYPERSTART_REF:-heads/master}
BUILD=${BUILD:-yes}
UPLOAD=${UPLOAD:-none}
ACCESS=${AWS_ACCESSKEY:-none}
SECRET=${AWS_SECRETKEY:-none}

cd ~makerpm/hyperd
echo "fetch hyperd ${HYPERD_REF}"
git fetch origin +refs/${HYPERD_REF#ref/}:refs/remotes/origin/target
git checkout -b target origin/target
hyperd_version=$(grep AC_INIT configure.ac|cut -d, -f2 |tr -d ' []')
git archive --format=tar.gz target > ~makerpm/rpmbuild/SOURCES/hyperd-${hyperd_version}.tar.gz
cp package/centos/rpm/SPECS/* ~makerpm/rpmbuild/SPECS/

cd ~makerpm/hyperstart
echo "fetch hyperstart ${HYPERSTART_REF}"
git fetch origin +refs/${HYPERSTART_REF#ref/}:refs/remotes/origin/target
git checkout -b target origin/target
hyperstart_version=$(grep AC_INIT configure.ac|cut -d, -f2 |tr -d ' []')
git archive --format=tar.gz target > ~makerpm/rpmbuild/SOURCES/hyperstart-${hyperstart_version}.tar.gz

cd ~makerpm/rpmbuild/SPECS/

mkdir  -p ~makerpm/.aws
cat > ~makerpm/.aws/config <<END
[default]
region = us-west-1
END

cat > ~makerpm/.aws/credentials <<END
[default]
aws_access_key_id = ${ACCESS}
aws_secret_access_key = ${SECRET}
END

chmod og-rwx -R ~makerpm/.aws

if [ "${BUILD}x" == "yesx" ]; then
	echo Build packages...
	rpmbuild -ba hyper-container.spec
	rpmbuild -ba hyperstart.spec

	if [ "${UPLOAD}x" != "nonex" ]; then
		echo "Upload packages to ${UPLOAD}..."
		for rpm in ~makerpm/rpmbuild/RPMS/x86_64/* ; do
			aws s3 cp $rpm s3://hypercontainer-build/${UPLOAD}/$(basename $rpm)
		done
		for rpm in ~makerpm/rpmbuild/SRPMS/* ; do
			aws s3 cp $rpm s3://hypercontainer-build/${UPLOAD}/$(basename $rpm)
		done
	fi
fi

if [ $# -gt 0 ] ; then
	echo "now execute [$@]"
	exec $@
fi
echo finished.

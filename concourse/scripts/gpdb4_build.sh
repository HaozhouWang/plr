#!/bin/bash

set -x

if [ "$1" == "centos5" ]; then
    export CC=gcc44
    export PYTHON=/usr/bin/python26
    rm -f /usr/bin/python && ln -s /usr/bin/python26 /usr/bin/python
fi

mkdir /usr/local/greenplum-db
export BLD_ARCH=$2
cd gpdb4_src

if [ "$1" == "suse11" ]; then
    ./configure --prefix=/usr/local/greenplum-db --enable-depend --enable-debug --with-python --with-libxml || exit 1
else
    CFLAGS="-Wno-error=unused-but-set-variable" ./configure --prefix=/usr/local/greenplum-db --enable-depend --enable-debug --with-python --with-libxml || exit 1
fi

make prefix=/usr/local/greenplum-db || exit 1
make install prefix=/usr/local/greenplum-db || exit 1
cd ..
pushd /usr/local
tar -zcvf bin_gpdb4git_$1.tar.gz greenplum-db
popd
mv /usr/local/bin_gpdb4git_$1.tar.gz gpdb4_$1_build/
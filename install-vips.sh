#!/usr/bin/env bash

export NOKOGIRI_USE_SYSTEM_LIBRARIES=true
export VIPS_SITE=http://www.vips.ecs.soton.ac.uk/supported
export VIPS_VERSION_MAJOR=8
export VIPS_VERSION_MINOR=4
export VIPS_VERSION_MICRO=5
export VIPS_VERSION=$VIPS_VERSION_MAJOR.$VIPS_VERSION_MINOR
export VIPS_VERSION_FULL=$VIPS_VERSION.$VIPS_VERSION_MICRO
export PATH=$HOME/vips/bin:$PATH
export LD_LIBRARY_PATH=$HOME/vips/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$HOME/vips/lib/pkgconfig:$PKG_CONFIG_PATH
export PYTHONPATH=$HOME/vips/lib/python2.7/site-packages:$PYTHONPATH
export GI_TYPELIB_PATH=$HOME/vips/lib/girepository-1.0:$GI_TYPELIB_PATH

set -e

# do we already have the correct vips built? early exit if yes
# we could check the configure params as well I guess
if [ -d "$HOME/vips/bin" ]; then
	version=$($HOME/vips/bin/vips --version)
	escaped_version="$VIPS_VERSION_MAJOR\.$VIPS_VERSION_MINOR\.$VIPS_VERSION_MICRO"
	echo "Need vips-$VIPS_VERSION_FULL"
	echo "Found $version"
	if [[ "$version" =~ ^vips-$escaped_version ]]; then
		echo "Using cached directory"
		exit 0
	fi
fi

rm -rf $HOME/vips
wget $VIPS_SITE/$VIPS_VERSION/vips-$VIPS_VERSION_FULL.tar.gz
tar xf vips-$VIPS_VERSION_FULL.tar.gz
cd vips-$VIPS_VERSION_FULL
CXXFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 ./configure --prefix=$HOME/vips $*
make && make install

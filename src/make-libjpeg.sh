#!/bin/bash

echo "building libjpeg"
mkdir -p /opt/imagemagick
cd /var/task/build
tar xf /var/task/vendor/jpegsrc*
cd jpeg*
./configure \
  --disable-dependency-tracking \
  --prefix=/opt/imagemagick
make
make install

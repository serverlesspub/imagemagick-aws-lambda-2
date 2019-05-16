#!/bin/bash

echo "running from source"
mkdir -p /opt/imagemagick
cd /var/task/build
tar xf /var/task/vendor/ImageMa*
cd ImageMa*
./configure --enable-shared=no --prefix=/opt/imagemagick
make
make install

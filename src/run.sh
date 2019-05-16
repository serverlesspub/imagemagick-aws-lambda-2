#!/bin/bash

echo "running from source"
cd /var/task/build
tar xf /var/task/vendor/ImageMa*
cd ImageMa*
./configure --enable-shared=no PREFIX=/opt/imagemagick
make

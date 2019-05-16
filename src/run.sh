#!/bin/bash

echo "running from source"
mkdir -p /opt/imagemagick
cd /var/task/build
tar xf /var/task/vendor/ImageMa*
cd ImageMa*
./configure \
  --without-shared \
  --without-modules \
  --with-static \
  --prefix=/opt/imagemagick \
  --without-perl \
  --without-x \
  --disable-docs \
  --without-magick-plus-plus
make
make install
rm -rf opt/imagemagick/share/ImageMagick-7/man
rm -rf opt/imagemagick/share/ImageMagick-7/doc

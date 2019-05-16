#!/bin/bash

echo "building imagemagick"
mkdir -p /opt/imagemagick
cd /var/task/build
tar xf /var/task/vendor/ImageMa*
cd ImageMa*
./configure \
  CPPFLAGS="-I/opt/imagemagick/include" LDFLAGS='-L/opt/imagemagick/lib' \
  --with-shared \
  --without-static \
  --without-modules \
  --with-static \
  --prefix=/opt/imagemagick \
  --disable-docs \
  --disable-dependency-tracking \
  --without-magick-plus-plus \
  --without-perl \
  --without-x
make
make install

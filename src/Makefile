
PNG_SOURCE=libpng-1.6.37.tar.xz
JPG_SOURCE=jpegsrc.v9c.tar.gz
OPENJP2_VERSION=2.3.1
OPENJP2_SOURCE=openjp2-$(OPENJP2_VERSION)
IMAGE_MAGICK_SOURCE=ImageMagick.tar.gz
TARGET_DIR ?= /opt/imagemagick

.ONESHELL:

$(IMAGE_MAGICK_SOURCE):
	curl -LO https://imagemagick.org/download/$(IMAGE_MAGICK_SOURCE)

$(JPG_SOURCE):
	curl -LO http://ijg.org/files/$(JPG_SOURCE)

$(PNG_SOURCE):
	curl -LO http://prdownloads.sourceforge.net/libpng/$(PNG_SOURCE)

$(OPENJP2_SOURCE):
	curl -L https://github.com/uclouvain/openjpeg/archive/v$(OPENJP2_VERSION).tar.gz -o $(OPENJP2_SOURCE)

$(TARGET_DIR)/lib/libpng.a: $(PNG_SOURCE)
	tar xf $(PNG_SOURCE) &&
	cd libpng*
	./configure \
	  --disable-dependency-tracking \
	  --disable-shared \
	  --enable-static \
	  --prefix=$(TARGET_DIR)
	make
	make install

$(TARGET_DIR)/lib/libjpeg.a: $(JPG_SOURCE)
	tar xf $(JPG_SOURCE)
	cd jpeg*
	./configure \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--prefix=$(TARGET_DIR)
	make
	make install

$(TARGET_DIR)/lib/libopenjp2.a: $(OPENJP2_SOURCE) $(TARGET_DIR)/lib/libpng.a
	tar xf $(OPENJP2_SOURCE) &&
	cd openjpeg-*
	mkdir -p build
	cd build 
	cmake .. \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$(TARGET_DIR) \
		-DBUILD_SHARED_LIBS:bool=off
	make
	make install

LIBS:=$(TARGET_DIR)/lib/libjpeg.a $(TARGET_DIR)/lib/libpng.a $(TARGET_DIR)/lib/libopenjp2.a

$(TARGET_DIR)/bin/identify: $(LIBS) $(IMAGE_MAGICK_SOURCE)
	tar xf $(IMAGE_MAGICK_SOURCE)
	cd ImageMa*
	PKG_CONFIG_PATH=$(TARGET_DIR)/lib/pkgconfig ./configure \
	  CPPFLAGS=-I$(TARGET_DIR)/include \
	  LDFLAGS=-L$(TARGET_DIR)/lib \
	  --prefix=$(TARGET_DIR) \
	  --disable-dependency-tracking \
	  --enable-delegate-build \
	  --disable-shared \
	  --enable-static \
	  --without-modules \
	  --disable-docs \
	  --without-magick-plus-plus \
	  --without-perl \
	  --without-x
	make
	make install

libs: $(LIBS)

all: $(TARGET_DIR)/bin/identify

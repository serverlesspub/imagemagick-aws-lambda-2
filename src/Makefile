
LIBPNG_SOURCE=libpng-1.6.37.tar.xz
LIBJPG_SOURCE=jpegsrc.v9c.tar.gz
OPENJP2_VERSION=2.3.1
OPENJP2_SOURCE=openjp2-$(OPENJP2_VERSION)
LIBTIFF_SOURCE=tiff-4.0.9.tar.gz
IMAGE_MAGICK_SOURCE=ImageMagick.tar.gz
TARGET_DIR ?= /opt/imagemagick

.ONESHELL:

$(IMAGE_MAGICK_SOURCE):
	curl -LO https://imagemagick.org/download/$(IMAGE_MAGICK_SOURCE)

$(LIBJPG_SOURCE):
	curl -LO http://ijg.org/files/$(LIBJPG_SOURCE)

$(LIBPNG_SOURCE):
	curl -LO http://prdownloads.sourceforge.net/libpng/$(LIBPNG_SOURCE)

$(OPENJP2_SOURCE):
	curl -L https://github.com/uclouvain/openjpeg/archive/v$(OPENJP2_VERSION).tar.gz -o $(OPENJP2_SOURCE)

$(LIBTIFF_SOURCE):
	curl -LO http://download.osgeo.org/libtiff/$(LIBTIFF_SOURCE)

CONFIGURE = PKG_CONFIG_PATH=$(TARGET_DIR)/lib/pkgconfig ./configure CPPFLAGS=-I$(TARGET_DIR)/include LDFLAGS=-L$(TARGET_DIR)/lib  --disable-dependency-tracking --disable-shared --enable-static --prefix=$(TARGET_DIR)

$(TARGET_DIR)/lib/libpng.a: $(LIBPNG_SOURCE)
	tar xf $(LIBPNG_SOURCE) &&
	cd libpng*
	$(CONFIGURE)	 
	make
	make install

$(TARGET_DIR)/lib/libjpeg.a: $(LIBJPG_SOURCE)
	tar xf $(LIBJPG_SOURCE)
	cd jpeg*
	$(CONFIGURE)	 
	make
	make install

$(TARGET_DIR)/lib/libtiff.a: $(LIBTIFF_SOURCE) $(TARGET_DIR)/lib/libjpeg.a
	tar xf $(LIBTIFF_SOURCE) &&
	cd tiff-*
	$(CONFIGURE)	 
	make
	make install

$(TARGET_DIR)/lib/libopenjp2.a: $(OPENJP2_SOURCE) $(TARGET_DIR)/lib/libpng.a $(TARGET_DIR)/lib/libtiff.a
	tar xf $(OPENJP2_SOURCE) &&
	cd openjpeg-*
	mkdir -p build
	cd build 
	PKG_CONFIG_PATH=$(TARGET_DIR)/lib/pkgconfig cmake .. \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$(TARGET_DIR) \
		-DBUILD_SHARED_LIBS:bool=off \
		-DBUILD_CODEC:bool=off
	make clean
	make install

LIBS:=$(TARGET_DIR)/lib/libjpeg.a $(TARGET_DIR)/lib/libpng.a $(TARGET_DIR)/lib/libopenjp2.a $(TARGET_DIR)/lib/libtiff.a

$(TARGET_DIR)/bin/identify: $(LIBS) $(IMAGE_MAGICK_SOURCE)
	tar xf $(IMAGE_MAGICK_SOURCE)
	cd ImageMa*
	$(CONFIGURE) \
	  --enable-delegate-build \
	  --without-modules \
	  --disable-docs \
	  --without-magick-plus-plus \
	  --without-perl \
	  --without-x
	make
	make install

libs: $(LIBS)

all: $(TARGET_DIR)/bin/identify

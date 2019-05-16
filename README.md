# ImageMagick for AWS Lambda (Amazon Linux 2)

Scripts to compile ImageMagick utilities for AWS Lambda instances powered by Amazon Linux 2.x, such as the `nodejs10.x` runtime.

Amazon Linux 2 instances for Lambda no longer contain system utilities, so `convert`, `mogrify` and `identify` from the [ImageMagick](https://imagemagick.org) package are no longer available. 

## Prerequisites

* Docker desktop
* Unix Make environment

## Compiling the code

* `make all`

The `Makefile` in the root directory just starts a Docker container matching the AWS Linux 2 environment for Lambda runtimes, and compiles a static version of ImageMagick tools. They will be in the `result` dir. By default, this compiles a version expecting to run as a Lambda layer from `/opt/imagemagick` (you can change the expected location in the (`Makefile`)[Makefile]).

## Bundled libraries

This is not a full-blown ImageMagick setup you can expect on a regular Linux box, it's a slimmed down version to save space that works with the most common formats. You can add more formats by including another library into the build process in [`src/Makefile`](src/Makefile).
* libpng
* libtiff
* libjpeg
* openjpeg2

## Info on scripts

For more information, check out:

* https://imagemagick.org/script/install-source.php
* http://www.linuxfromscratch.org/blfs/view/cvs/general/imagemagick.html

## Author

Gojko Adzic <https://gojko.net>

## License

* These scripts: [MIT](https://opensource.org/licenses/MIT)
* ImageMagick: https://imagemagick.org/script/license.php
* Contained libraries all have separate licenses, check the respective web sites for more information

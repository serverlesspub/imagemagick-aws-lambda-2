# ImageMagick Lambda Layer for Amazon Linux 2 AMIs

Static build of ImageMagick for Amazon Linux 2, packaged as a Lambda layer. 
Bundles ImageMagick 7.0.8-45, including convert, mogrify and identify tools
and support for jpeg, gif, png, tiff and webm formats.

This application provides a single output, `LayerVersion`, which points to a
Lambda Layer ARN you can use with Lambda runtimes based on Amazon Linux 2 (such
as the `nodejs10.x` or `nodejs12.x` runtime).

For an example of how to use the layer, check out 
https://github.com/serverlesspub/imagemagick-aws-lambda-2/tree/master/example

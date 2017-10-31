#!/bin/bash
set -e

# Inspect all the files in config and extract into env variables

BUILD_NUMBER=$( date +%s )

# Build each image and push
ROOT_DIR=`pwd`

# Build the NGINX image (configure Fast CGI)

# rallen: The nginx image should have no code whatsoever in it.
# Whatever user code nginx sees should be on a volume, not on the docker image.

cd code-nginx
docker build \
  --tag registry.ng.bluemix.net/jjdojo/code-nginx:${BUILD_NUMBER} \
  --tag registry.ng.bluemix.net/jjdojo/code-nginx:latest \
  --build-arg NGINX_VERSION=1.13.5 \
  .

# Build the PHP-FPM image (base image, inject code, run composer)
cd $ROOT_DIR/code-php-fpm

# TODO: There's really nothing to build on the code php image.
#docker build \
#  --tag registry.ng.bluemix.net/jjdojo/code-php-fpm:${BUILD_NUMBER} \
#  --tag registry.ng.bluemix.net/jjdojo/code-php-fpm:latest \
#  .

# Build the PHP-CLI image (base image, inject code, run composer)
cd $ROOT_DIR/code-php-cli
docker build \
  --tag registry.ng.bluemix.net/jjdojo/code-php-cli:${BUILD_NUMBER} \
  --tag registry.ng.bluemix.net/jjdojo/code-php-cli:latest \
  .

# Move back to ROOT_DIR
cd $ROOT_DIR

echo "Build completed."

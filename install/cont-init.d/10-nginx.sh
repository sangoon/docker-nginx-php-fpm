#!/usr/bin/with-contenv bash

  ### Adjust NGINX Runtime Variables
  UPLOAD_MAX_SIZE=${UPLOAD_MAX_SIZE:="2G"}
  PHP_TIMEOUT=${PHP_TIMEOUT:="180"}
  sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /etc/nginx/nginx.conf
  sed -i -e "s/<PHP_TIMEOUT>/$PHP_TIMEOUT/g" /etc/nginx/conf.d/default.conf



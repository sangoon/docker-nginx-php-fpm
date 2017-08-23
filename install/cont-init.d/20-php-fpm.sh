#!/usr/bin/with-contenv bash

  ### Adjust PHP Runtime Variables
  UPLOAD_MAX_SIZE=${UPLOAD_MAX_SIZE:="2G"}
  PHP_TIMEOUT=${PHP_TIMEOUT:="180"}
  sed -i -e "s/<PHP_MEMORY_LIMIT>/$PHP_MEMORY_LIMIT/g" /etc/php7/php-fpm.conf
  sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /etc/php7/php-fpm.conf
  sed -i -e "s/<PHP_LOG_LEVEL>/$PHP_LOG_LEVEL/g" /etc/php7/php-fpm.conf
  sed -i -e "s/<PHP_MEMORY_LIMIT>/$PHP_MEMORY_LIMIT/g" /etc/php7/php.ini
  sed -i -e "s/<PHP_TIMEOUT>/$PHP_TIMEOUT/g" /etc/php7/php.ini
  sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /etc/php7/php.ini
  sed -i -e "s/<APC_SHM_SIZE>/$APC_SHM_SIZE/g" /etc/php7/conf.d/apcu.ini
  sed -i -e "s/<OPCACHE_MEM_SIZE>/$OPCACHE_MEM_SIZE/g" /etc/php7/conf.d/00_opcache.ini

  ### Disable Modules
  if [ "$OPCACHE_MEM_SIZE" = "0" ]; then
  sed -i -e "s/opcache.enable=1/opcache.enable=0/g" /etc/php7/conf.d/00_opcache.ini
  sed -i -e "s/opcache.enable_cli=1/opcache.enable_cli=0/g" /etc/php7/conf.d/00_opcache.ini
  fi
  


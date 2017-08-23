FROM tiredofit/alpine:3.6
MAINTAINER Dave Conroy <dave at tiredofit dot ca>

### Default Runtime Environment Variables
  ENV PHP_MEMORY_LIMIT=128M \
      UPLOAD_MAX_SIZE=2G \
      APC_SHM_SIZE=128M \
      OPCACHE_MEM_SIZE=128 \
      TZ=America/Vancouver \
      UPLOAD_MAX_SIZE=2G \
      PHP_TIMEOUT=180 \
      PHP_LOG_LEVEL=notice \
      ZABBIX_HOSTNAME=nginx-php-fpm-app

### Dependency Installation
  RUN apk update && \
      apk add \
          ca-certificates \
          mariadb-client \
          msmtp \
          openssl \
          nginx \
          php7-apcu \
          php7-bcmath \
          php7-ctype \
          php7-curl \
          php7-dom \
          php7-fpm \
          php7-gd \
          php7-iconv \
          php7-intl \
          php7-json \
          php7-ldap \
          php7-mbstring \
          php7-mcrypt \
          php7-memcached \
          php7-mysqli \
          php7-opcache \
          php7-openssl \
          php7-pdo \
          php7-pdo_mysql \
          php7-pdo_sqlite \
          php7-phar\
          php7-redis \
          php7-session \
          php7-xml \
          php7-xmlreader \
          php7-zlib \
          && \
      apk add -u musl && \
      rm -rf /var/cache/apk/*

      
### MSMTP
  COPY install/msmtp/msmtp /etc/msmtp
  RUN rm -f /usr/sbin/sendmail && \
      ln -s /usr/bin/msmtp /usr/sbin/sendmail && \

### Nginx and PHP7 Setup
      sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php7/php.ini && \
      sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/www:\/bin\/bash/g" /etc/passwd && \
      sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/www:\/bin\/bash/g" /etc/passwd- && \
      ln -s /sbin/php-fpm7 /sbin/php-fpm

### Install PHP Composer
  RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 

### PHP7, APC and Nginx Configuration
  ADD install/nginx /etc/nginx
  ADD install/php7 /etc/php7

### WWW  Installation
  RUN mkdir -p /www/logs

### S6 Setup
  ADD install/s6 /etc/s6
  ADD install/cont-init.d /etc/cont-init.d
  RUN chmod +x /etc/cont-init.d/*.sh

## Logrotate Setup
  ADD install/logrotate.d /etc/logrotate.d

### Zabbix Setup 
  ADD install/zabbix /etc/zabbix
  RUN chmod +x /etc/zabbix/zabbix_agentd.conf.d/*.sh && \
      chown -R zabbix /etc/zabbix

### Networking Configuration
  EXPOSE 80

### Entrypoint Configuration
  ENTRYPOINT ["/init"]


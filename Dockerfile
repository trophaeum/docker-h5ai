FROM ubuntu:devel

ENV DEBIAN_FRONTEND noninteractive
ENV HTTPD_USER www-data

COPY sources.list /etc/apt/sources.list

RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y \
  nginx php7.2-fpm supervisor \
  wget unzip patch acl \
  libav-tools imagemagick \
  graphicsmagick zip unzip php7.2-gd php7.2-opcache php7.2-zip npm composer && apt-get clean && rm -rf /var/lib/apt/lists/*

# install h5ai and patch configuration
RUN wget -O h5ai.zip https://github.com/JixunMoe/h5ai/archive/master.zip
RUN unzip h5ai.zip -d /usr/share/h5ai && cd /usr/share/h5ai && npm install && npm run build && mkdir -p /usr/share/h5ai/_h5ai && ln -s /usr/share/h5ai/h5ai-master/src/_h5ai/private /usr/share/h5ai/_h5ai

# patch h5ai because we want to deploy it ouside of the document root and use /var/www as root for browsing
COPY class-setup.php.patch class-setup.php.patch
RUN patch -p1 -u -d /usr/share/h5ai/_h5ai/private/php/core/ -i /class-setup.php.patch && rm class-setup.php.patch

# add default configuration for nginx
RUN rm /etc/nginx/sites-enabled/default
ADD h5ai.nginx.conf /etc/nginx/sites-available/h5ai
RUN ln -s /etc/nginx/sites-available/h5ai /etc/nginx/sites-enabled/h5ai

# make the cache writable
RUN chown ${HTTPD_USER} /usr/share/h5ai/_h5ai/public/cache/
RUN chown ${HTTPD_USER} /usr/share/h5ai/_h5ai/private/cache/

# use supervisor to monitor all services
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf

# expose only nginx HTTP port
EXPOSE 80 443

# expose path
VOLUME /var/www


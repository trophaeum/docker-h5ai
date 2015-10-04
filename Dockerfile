FROM ubuntu:14.04
MAINTAINER Paul Valla <paul.valla+docker@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV H5AI_VERSION 0.27.0
ENV HTTPD_USER www-data

RUN apt-get update && apt-get install -y \
  nginx php5-fpm supervisor \
  wget unzip patch acl

# install h5ai and patch configuration
RUN wget http://release.larsjung.de/h5ai/h5ai-$H5AI_VERSION.zip
RUN unzip h5ai-$H5AI_VERSION.zip -d /usr/share/h5ai
# patch h5ai because we want to deploy it ouside of the document root and use /var/www as root for browsing
COPY App.php.patch App.php.patch
RUN patch -p1 -u -d /usr/share/h5ai/_h5ai/server/php/inc/ -i /App.php.patch && rm App.php.patch

RUN rm /etc/nginx/sites-enabled/default

#make the cache writable
RUN setfacl -R -m u:"$HTTPD_USER":rwX /usr/share/h5ai/_h5ai/cache/

# use supervisor to monitor all services
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf

# expose only nginx HTTP port
EXPOSE 80 443

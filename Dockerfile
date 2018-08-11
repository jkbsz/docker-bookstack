FROM ubuntu:18.04

MAINTAINER Jakub Szczygłowski <jszczyglowski@gmail.com>

WORKDIR /opt

# Deploy Apache and PHP

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 libapache2-mod-php  php-curl php-mbstring  php-gd  php-mysql php-xml php-fpm php-ldap php-tidy php-zip mysql-client git curl \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*


RUN a2enmod rewrite && a2enmod php7.2 

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Fetch bookstack

RUN git clone https://github.com/BookStackApp/BookStack.git --branch release --single-branch bookstack && \
	chown www-data:www-data -R /opt/bookstack && \
	chmod -R 755 /opt/bookstack/bootstrap/cache /opt/bookstack/public/uploads /opt/bookstack/storage

WORKDIR /opt/bookstack

RUN curl -s https://getcomposer.org/installer > composer-setup.php && php composer-setup.php && php composer.phar install

COPY bookstack-entrypoint.sh /opt
RUN chmod a+x /opt/bookstack-entrypoint.sh

# Expose and run

EXPOSE 80
VOLUME ["/opt/bookstack/public/uploads","/opt/bookstack/public/storage"]

ENTRYPOINT ["/opt/bookstack-entrypoint.sh"]


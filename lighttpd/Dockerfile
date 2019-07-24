FROM alpine:3.9

RUN apk update && apk add --no-cache\
	php7-common \
	php7-iconv \ 
	php7-json \ 
	php7-gd \ 
	php7-curl \ 
	php7-xml \ 
	php7-mysqli \ 
	php7-imap \ 
	php7-cgi \ 
	fcgi \ 
	php7-pdo \ 
	php7-pdo_mysql \ 
	php7-soap \ 
	php7-xmlrpc \ 
	php7-posix \ 
	php7-mcrypt \ 
	php7-gettext \ 
	php7-ldap \ 
	php7-ctype \ 
	php7-dom \
	lighttpd \
	&& sed -i 's/#   include "mod_fastcgi.conf"/    include "mod_fastcgi.conf"/g' /etc/lighttpd/lighttpd.conf && \
	sed -i 's+/usr/bin/php-cgi+/usr/bin/php-cgi7+g' /etc/lighttpd/mod_fastcgi.conf && \
	mkdir /scripts && \
	rm -rf /var/chache/apk/*

COPY ./script.sh /scripts/script.sh

RUN chmod +x /scripts/script.sh

CMD /scripts/script.sh
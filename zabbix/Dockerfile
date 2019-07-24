FROM alpine:3.9

RUN apk update && apk add --no-cache\
	php-mysqli \
	zabbix \
	zabbix-mysql \
	zabbix-webif \
	zabbix-setup \
	mysql-client \
	&& mkdir /scripts && \
	rm -rf /var/chache/apk/*

COPY ./script.sh /scripts/script.sh
COPY ./wait_for_mysql.sh /scripts/wait_for_mysql.sh

RUN chmod +x /scripts/script.sh && \
	chmod +x /scripts/wait_for_mysql.sh

CMD /scripts/wait_for_mysql.sh
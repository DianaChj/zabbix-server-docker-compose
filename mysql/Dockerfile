FROM alpine:3.9

RUN apk update && apk add --no-cache\
	mysql \
	mysql-client \
	&& mkdir /scripts && \
	rm -rf /var/cache/apk/*

COPY ./script.sh /scripts/script.sh
RUN chmod +x /scripts/script.sh

CMD ["./scripts/script.sh"]
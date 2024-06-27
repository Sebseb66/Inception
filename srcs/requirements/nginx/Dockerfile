FROM debian:bookworm

RUN apt-get update -y && \
    apt-get install -y nginx openssl && \
    rm /etc/nginx/sites-available/default && \
    rm /etc/nginx/sites-enabled/default && \
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=FR/ST=France/L=Perpignan/O=42Perpignan/CN=sfroidev.42.fr" \
    -keyout /etc/ssl/certs/inception.key \
    -out /etc/ssl/certs/inception.crt

ADD ./conf/login.42.fr.conf /etc/nginx/conf.d/login.42.fr.conf

ADD ./tools/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 443

CMD ["/docker-entrypoint.sh"]

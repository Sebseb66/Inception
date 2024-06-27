FROM debian:bookworm

RUN apt-get update -y && \
    apt-get install -y mariadb-server

ADD ./conf/50-server.cnf /etc/mysql/mariadb.conf.d
COPY ./tools/docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mariadbd-safe"]

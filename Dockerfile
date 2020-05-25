FROM gcc:latest
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        re2c \
        texinfo \
        expect \
    ; \
    rm -r /var/lib/apt/lists/*;
COPY ./Tools RosBE-Unix/Base-i386/tools/
COPY docker-entrypoint.sh /usr/local/bin/
# ENTRYPOINT ["docker-entrypoint.sh"]

FROM alpine:3.5

LABEL description "Rainloop is a simple, modern & fast web-based client" \
      maintainer="Hardware <contact@meshup.net>"

ARG GPG_FINGERPRINT="3B79 7ECE 694F 3B7B 70F3  11A4 ED7C 49D9 87DA 4591"

ENV UID=991 GID=991

RUN echo "@community https://nl.alpinelinux.org/alpine/v3.5/community" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    gnupg \
    openssl \
    wget" \
 && apk --no-cache -U add \
    ${BUILD_DEPS} \
    ca-certificates \
    nginx \
    s6 \
    su-exec \
    sqlite \
    php7-fpm@community \
    php7-curl@community \
    php7-iconv@community \
    php7-xml@community \
    php7-dom@community \
    php7-openssl@community \
    php7-json@community \
    php7-zlib@community \
    php7-pdo_mysql@community \
    php7-pdo_sqlite@community \
    php7-sqlite3@community \
    php7-ldap@community \
 && cd /tmp \
 && wget -q https://www.rainloop.net/repository/webmail/rainloop-community-latest.zip \
 && wget -q https://www.rainloop.net/repository/webmail/rainloop-community-latest.zip.asc \
 && wget -q https://www.rainloop.net/repository/RainLoop.asc \
 && echo "Verifying authenticity of rainloop-community-latest.zip using GPG..." \
 && gpg --import RainLoop.asc \
 && FINGERPRINT="$(LANG=C gpg --verify rainloop-community-latest.zip.asc rainloop-community-latest.zip 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "Warning! Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG_FINGERPRINT}" ]; then echo "Warning! Wrong GPG fingerprint!" && exit 1; fi \
 && echo "All seems good, now unzipping rainloop-community-latest.zip..." \
 && mkdir /rainloop && unzip -q /tmp/rainloop-community-latest.zip -d /rainloop \
 && find /rainloop -type d -exec chmod 755 {} \; \
 && find /rainloop -type f -exec chmod 644 {} \; \
 && apk del ${BUILD_DEPS} \
 && rm -rf /tmp/* /var/cache/apk/* /root/.gnupg

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /rainloop/data

EXPOSE 80

CMD ["run.sh"]

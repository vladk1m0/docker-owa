FROM alpine:latest
LABEL Maintainer="Vladislav Mostovoi <vladkimo@gmail.com>" \
      Description="Docker image for Open Web Analytics with Nginx & PHP-FPM 5.x based on Alpine Linux."

ARG OWA_VERSION
ARG TIMEZONE=Europe/Moscow

ENV OWA_UID="82"
ENV OWA_USER="www-data"

ENV OWA_GID="82"
ENV OWA_GROUP="www-data"

# Add application user and group
RUN set -ex \
	&& addgroup -g $OWA_UID -S $OWA_GROUP \
	&& adduser -u $OWA_GID -D -S -G $OWA_USER $OWA_GROUP

# Install packages
RUN apk update \
    && apk upgrade \
    && apk add --update tzdata \
    && apk --no-cache add \
    php5-fpm \    
    php5-mysql \
    php5-mysqli \
    php5-pcntl \
    php5-json \
    php5-openssl \
    php5-curl \
    php5-zlib \
    php5-xml \
    php5-phar \
    php5-intl \
    php5-dom \
    php5-xmlreader \
    php5-ctype \
    php5-gd \
    nginx supervisor curl jq

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/owa-www.conf /etc/php5/fpm.d/
COPY config/owa.ini /etc/php5/conf.d/

# Setup php-fpm unix user/group
RUN sed -i "s|user\s*=.*|user = ${OWA_USER}|g" /etc/php5/php-fpm.conf \
    && sed -i "s|group\s*=.*|group = ${OWA_GROUP}|g" /etc/php5/php-fpm.conf

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup timezone
RUN rm -rf /etc/localtime \
    && ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    && sed -i "s|;*date.timezone\s*=.*|date.timezone = \"${TIMEZONE}\"|i" /etc/php5/conf.d/owa.ini \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*

# Add Open Web Analytics (OWA)
ENV WEBROOT_DIR=/var/www/html
RUN mkdir -p $WEBROOT_DIR

RUN if [ "x$OWA_VERSION" = "x" ] ; then \
    OWA_VERSION=$(curl -L -s -H 'Accept: application/json' https://api.github.com/repos/padams/Open-Web-Analytics/releases/latest| jq '.tag_name'| tr -d \") ; \
    fi \
    && echo "Install Open Web Analytics (OWA) version $OWA_VERSION" \
    && curl -fsSL -o /tmp/owa.tar.gz "https://github.com/padams/Open-Web-Analytics/archive/$OWA_VERSION.tar.gz" \
    && tar -xzf /tmp/owa.tar.gz -C /tmp \
    && mv /tmp/Open-Web-Analytics-$OWA_VERSION/* $WEBROOT_DIR \
    && rm /tmp/owa.tar.gz \ 
    && chown -R $OWA_USER:$OWA_GROUP $WEBROOT_DIR/ \
    && chmod -R 0775 $WEBROOT_DIR/ \
    && apk del jq

WORKDIR $WEBROOT_DIR
EXPOSE 80 443
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# based on https://github.com/Homegear/Homegear-Docker/blob/master/nightly/Dockerfile
# and https://github.com/kreativmonkey/hassio-addons/blob/master/homegear/Dockerfile

ARG BUILD_FROM
ARG BUILD_ARCH

FROM $BUILD_FROM

MAINTAINER Daniel Fernau <github@danielfernau.de>

RUN apt-get update && apt-get -y install apt-transport-https apt-utils wget ca-certificates gnupg libzip4 libavahi-client3 libavahi-client-dev insserv
COPY installNightly.sh /installNightly.sh
RUN \
    touch /tmp/HOMEGEAR_STATIC_INSTALLATION; \
    touch /.dockerenv; \
    wget https://apt.homegear.eu/Release.key && apt-key add Release.key && rm Release.key; \
    echo 'deb https://apt.homegear.eu/Debian/ buster/' >> /etc/apt/sources.list.d/homegear.list; \
    chmod +x /installNightly.sh; \
    /installNightly.sh; \
    rm /installNightly.sh; \
    cp -a /etc/homegear /etc/homegear.config; \
    cp -a /var/lib/homegear /var/lib/homegear.data; \
    rm -rf /etc/homegear; \
    rm -rf /var/lib/homegear; \
    rm -rf /var/log/homegear; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/bin/bash", "-c", "/start.sh"]

EXPOSE 2001 2002 2003
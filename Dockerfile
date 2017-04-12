FROM alpine:3.5
MAINTAINER rijalati@gmail.com

RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.25-r0" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    wget \
        "https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub" \
        -O "/etc/apk/keys/sgerrand.rsa.pub" && \
    wget \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    printf "export LANG=C.UTF-8\nexport LC_ALL=C.UTF-8" > /etc/profile.d/locale.sh && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"
# UTF-8 by default
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install cURL
RUN apk --update --no-cache add curl ca-certificates tar \
    && curl -Ls http://cdn.azul.com/zulu/bin/zulu8.20.0.5-jdk8.0.121-linux_x64.tar.gz > /tmp/zulu-jdk8.tar.gz \
    && curl -Ls http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip > /tmp/zulu-crypt.zip \
    && mkdir -p /opt/jdk \
    && cd /opt/jdk \
    && tar -xzf /tmp/zulu-jdk8.tar.gz \
    && mv zulu8.20.0.5-jdk8.0.121-linux_x64 zulu-jdk8 \
    && unzip /tmp/zulu-crypt.zip \
    && cp -f ZuluJCEPolicies/* /opt/jdk/zulu-jdk8/jre/lib/security/ \
    && rm -fr ZuluJCEPolicies/ /tmp/zulu-jdk8.tar.gz /tmp/zulu-crypt.zip \
    && rm -f /opt/jdk/zulu-jdk8/src.zip \
    && chown -R root:root /opt/jdk/zulu-jdk8 \
    && cd /opt \
    && curl -Ls http://www-us.apache.org/dist/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz > /tmp/apache-maven-3.5.0-bin.tar.gz \
    && tar --strip-components=1 -xf /tmp/apache-maven-3.5.0-bin.tar.gz \
    && curl -Ls http://www-us.apache.org/dist//ant/binaries/apache-ant-1.10.1-bin.tar.gz > /tmp/apache-ant.tar.gz \
    && mkdir -p /usr/share/java/apache-ant \
    && cd  /usr/share/java/apache-ant \
    && tar -zxf /tmp/apache-ant.tar.gz \
    && rm -rf ${JAVA_HOME}/*src.zip \
           ${JAVA_HOME}/THIRDPARTYLICENSEREADME* \
           ${JAVA_HOME}/lib/missioncontrol \
           ${JAVA_HOME}/lib/visualvm \
           ${JAVA_HOME}/lib/*javafx* \
           ${JAVA_HOME}/lib/plugin.jar \
           ${JAVA_HOME}/lib/ext/jfxrt.jar \
           ${JAVA_HOME}/bin/javaws \
           ${JAVA_HOME}/lib/javaws.jar \
           ${JAVA_HOME}/lib/desktop \
           ${JAVA_HOME}/plugin \
           ${JAVA_HOME}/lib/deploy* \
           ${JAVA_HOME}/lib/*javafx* \
           ${JAVA_HOME}/lib/*jfx* \
           ${JAVA_HOME}/lib/amd64/libdecora_sse.so \
           ${JAVA_HOME}/lib/amd64/libprism_*.so \
           ${JAVA_HOME}/lib/amd64/libfxplugins.so \
           ${JAVA_HOME}/lib/amd64/libglass.so \
           ${JAVA_HOME}/lib/amd64/libgstreamer-lite.so \
           ${JAVA_HOME}/lib/amd64/libjavafx*.so \
           ${JAVA_HOME}/lib/amd64/libjfx*.so \
           /var/cache/apk/* \
/tmp/* \
&& ls -al /tmp

ENV JAVA_HOME=/opt/jdk/zulu-jdk8
ENV PATH=${PATH}:${JAVA_HOME}/bin:/opt/bin
ENV ANT_HOME /usr/share/java/apache-ant/apache-ant-1.10.1
ENV PATH ${PATH}:${ANT_HOME}/bin

ENTRYPOINT ["/opt/jdk/zulu-jdk8/bin/java", "-version"]

FROM alpine:3.5
MAINTAINER rijalati@gmail.com

# UTF-8 by default
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.25-r0" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    wget \
        "https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub" \
        -O "/etc/apk/keys/sgerrand.rsa.pub" && \
    cd /tmp && wget \
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
    printf "export LANG=C.UTF-8\n" > /etc/profile.d/locale.sh && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

# Install cURL
RUN apk --update --no-cache add curl ca-certificates tar \
    && mkdir -p /opt/jdk \
    && cd /opt/jdk \
    && curl -Ls http://cdn.azul.com/zulu/bin/zulu8.20.0.5-jdk8.0.121-linux_x64.tar.gz \
    | tar --exclude=zulu8.20.0.5-jdk8.0.121-linux_x64/demo/* \
          --exclude=zulu8.20.0.5-jdk8.0.121-linux_x64/sample/* \
          --exclude=zulu8.20.0.5-jdk8.0.121-linux_x64/man/* \
          --transform=s/zulu8.20.0.5-jdk8.0.121-linux_x64/zulu-jdk8/g -xzvf - \
    && ls -al \
    && curl -Ls http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip > ZuluJCEPolicies.zip \
    && unzip ZuluJCEPolicies.zip \
    && cp -vr ZuluJCEPolicies/* /opt/jdk/zulu-jdk8/jre/lib/security/ \
    && ls -al /opt/jdk/zulu-jdk8/jre/lib/security/ \
    && rm -fr ZuluJCEPolicies* \
    && cd /opt \
    && curl -Ls http://www-us.apache.org/dist/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz \
    | tar --strip-components=1 -xzf - \
    && mkdir -p /usr/share/java/apache-ant \
    && cd  /usr/share/java/apache-ant \
    && curl -Ls http://www-us.apache.org/dist//ant/binaries/apache-ant-1.10.1-bin.tar.gz \
    | tar --exclude=apache-ant-1.10.1/manual* -zxf - \
    && chown -R root:root /opt/jdk/zulu-jdk8 \
    && rm -fr /opt/jdk/zulu-jdk8/*src.zip \
           /opt/jdk/zulu-jdk8/THIRD_PARTY_README \
           /opt/jdk/zulu-jdk8/lib/missioncontrol \
           /opt/jdk/zulu-jdk8/lib/visualvm \
           /opt/jdk/zulu-jdk8/lib/*javafx* \
           /opt/jdk/zulu-jdk8/lib/plugin.jar \
           /opt/jdk/zulu-jdk8/lib/ext/jfxrt.jar \
           /opt/jdk/zulu-jdk8/bin/javaws \
           /opt/jdk/zulu-jdk8/lib/javaws.jar \
           /opt/jdk/zulu-jdk8/lib/desktop \
           /opt/jdk/zulu-jdk8/plugin \
           /opt/jdk/zulu-jdk8/lib/deploy* \
           /opt/jdk/zulu-jdk8/lib/*javafx* \
           /opt/jdk/zulu-jdk8/lib/*jfx* \
           /opt/jdk/zulu-jdk8/lib/amd64/libdecora_sse.so \
           /opt/jdk/zulu-jdk8/lib/amd64/libprism_*.so \
           /opt/jdk/zulu-jdk8/lib/amd64/libfxplugins.so \
           /opt/jdk/zulu-jdk8/lib/amd64/libglass.so \
           /opt/jdk/zulu-jdk8/lib/amd64/libgstreamer-lite.so \
           /opt/jdk/zulu-jdk8/lib/amd64/libjavafx*.so \
           /opt/jdk/zulu-jdk8/lib/amd64/libjfx*.so \
           /opt/jdk/zulu-jdk8/jre/lib/plugin.jar \
           /opt/jdk/zulu-jdk8/jre/lib/ext/jfxrt.jar \
           /opt/jdk/zulu-jdk8/jre/bin/javaws \
           /opt/jdk/zulu-jdk8/jre/lib/javaws.jar \
           /opt/jdk/zulu-jdk8/jre/lib/desktop \
           /opt/jdk/zulu-jdk8/jre/plugin \
           /opt/jdk/zulu-jdk8/jre/lib/deploy* \
           /opt/jdk/zulu-jdk8/jre/lib/*javafx* \
           /opt/jdk/zulu-jdk8/jre/lib/*jfx* \
           /opt/jdk/zulu-jdk8/jre/lib/amd64/libdecora_sse.so \
           /opt/jdk/zulu-jdk8/jre/lib/amd64/libprism_*.so \
           /opt/jdk/zulu-jdk8/jre/lib/amd64/libfxplugins.so \
           /opt/jdk/zulu-jdk8/jre/lib/amd64/libglass.so \
           /opt/jdk/zulu-jdk8/jre/lib/amd64/libgstreamer-lite.so \
           /opt/jdk/zulu-jdk8/jre/lib/amd64/libjavafx*.so \
           /opt/jdk/zulu-jdk8/jre/lib/amd64/libjfx*.so \
           /opt/jdk/zulu-jdk8/jre/bin/jjs \
           /opt/jdk/zulu-jdk8/jre/bin/orbd \
           /opt/jdk/zulu-jdk8/jre/bin/pack200 \
           /opt/jdk/zulu-jdk8/jre/bin/unpack200 \
           /opt/jdk/zulu-jdk8/jre/lib/ext/nashorn.jar \
           /var/cache/apk/* \
           /tmp/* \
           && ls -al /tmp

ENV JAVA_HOME=/opt/jdk/zulu-jdk8
ENV PATH=${PATH}:${JAVA_HOME}/bin:/opt/bin
ENV ANT_HOME /usr/share/java/apache-ant/apache-ant-1.10.1
ENV PATH ${PATH}:${ANT_HOME}/bin

ENTRYPOINT ["/opt/jdk/zulu-jdk8/bin/java", "-version"]

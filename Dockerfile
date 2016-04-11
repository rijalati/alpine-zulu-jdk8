FROM gliderlabs/alpine:3.3
MAINTAINER rijalati@gmail.com

# UTF-8 by default
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install cURL
RUN apk --update add curl ca-certificates tar \
        && curl -Ls https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk > /tmp/glibc-2.21-r2.apk \
        && apk add --allow-untrusted /tmp/glibc-2.21-r2.apk

RUN curl -Ls http://cdn.azul.com/zulu/bin/zulu8.13.0.5-jdk8.0.72-linux_x64.tar.gz > /tmp/zulu-jdk8.tar.gz \
    && curl -Ls http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip > /tmp/zulu-crypt.zip \
    && cd /tmp \
    && unzip /tmp/zulu-crypt.zip \
    && mkdir -p /opt/jdk \
    && cd /opt/jdk \
    && tar -xzf /tmp/zulu-jdk8.tar.gz \
    && mv -f /tmp/ZuluJCEPolicies/* /opt/jdk/zulu-jdk8/jre/lib/security/ \
    && rm -f /tmp/zulu-jdk8.tar.gz /tmp/zulu-crypt.zip

ENV JAVA_HOME=/opt/jdk/zulu-jdk8
ENV PATH=${PATH}:${JAVA_HOME}/bin

RUN curl -Ls http://mirrors.koehn.com/apache//ant/binaries/apache-ant-1.9.6-bin.tar.gz > /tmp/apache-ant.tar.gz \
    && mkdir -p /usr/share/java/apache-ant \
    && cd  /usr/share/java/apache-ant \
    && tar -zxf /tmp/apache-ant.tar.gz \
    && rm -f /tmp/apache-ant.tar.gz

ENV ANT_HOME /usr/share/java/apache-ant
ENV PATH ${PATH}:${ANT_HOME}/bin

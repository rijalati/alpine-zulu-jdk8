FROM alpine:3.5
MAINTAINER rijalati@gmail.com

# UTF-8 by default
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install cURL
RUN apk --update --no-cache add curl ca-certificates tar \
    && curl -Ls https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub > /etc/apk/keys/sgerrand.rsa.pub \
    && curl -Ls https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk > /tmp/glibc-2.25-r0.apk \
    && apk add /tmp/glibc-2.25-r0.apk


RUN curl -Ls http://cdn.azul.com/zulu/bin/zulu8.20.0.5-jdk8.0.121-linux_x64.tar.gz > /tmp/zulu-jdk8.tar.gz \
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
    && tar --strip-components=1 -xf /tmp/apache-maven-3.5.0-bin.tar.gz


ENV JAVA_HOME=/opt/jdk/zulu-jdk8
ENV PATH=${PATH}:${JAVA_HOME}/bin:/opt/bin

RUN curl -Ls http://www.gtlib.gatech.edu/pub/apache//ant/binaries/apache-ant-1.10.1-bin.tar.gz > /tmp/apache-ant.tar.gz \
    && mkdir -p /usr/share/java/apache-ant \
    && cd  /usr/share/java/apache-ant \
    && tar -zxf /tmp/apache-ant.tar.gz \
    && rm -f /tmp/apache-ant.tar.gz

ENV ANT_HOME /usr/share/java/apache-ant/apache-ant-1.10.1
ENV PATH ${PATH}:${ANT_HOME}/bin

ENTRYPOINT ["/opt/jdk/zulu-jdk8/bin/java", "-version"]

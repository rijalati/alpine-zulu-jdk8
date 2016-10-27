FROM gliderlabs/alpine:3.3
MAINTAINER rijalati@gmail.com

# UTF-8 by default
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install cURL
RUN apk --update --no-cache add curl ca-certificates tar \
    && curl -Ls https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub > /etc/apk/keys/sgerrand.rsa.pub \
    && curl -Ls https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk > /tmp/glibc-2.23-r3.apk \
    && apk add /tmp/glibc-2.23-r3.apk

RUN curl -Ls http://cdn.azul.com/zulu/bin/zulu8.17.0.3-jdk8.0.102-linux_x64.tar.gz > /tmp/zulu-jdk8.tar.gz \
    && curl -Ls http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip > /tmp/zulu-crypt.zip \
    && mkdir -p /opt/jdk \
    && cd /opt/jdk \
    && tar -xzf /tmp/zulu-jdk8.tar.gz \
    && mv zulu8.17.0.3-jdk8.0.102-linux_x64 zulu-jdk8 \
    && unzip /tmp/zulu-crypt.zip \
    && cp -f ZuluJCEPolicies/* /opt/jdk/zulu-jdk8/jre/lib/security/ \
    && rm -fr ZuluJCEPolicies/ /tmp/zulu-jdk8.tar.gz /tmp/zulu-crypt.zip


ENV JAVA_HOME=/opt/jdk/zulu-jdk8
ENV PATH=${PATH}:${JAVA_HOME}/bin

RUN curl -Ls http://www.gtlib.gatech.edu/pub/apache//ant/binaries/apache-ant-1.9.7-bin.tar.gz > /tmp/apache-ant.tar.gz \
    && mkdir -p /usr/share/java/apache-ant \
    && cd  /usr/share/java/apache-ant \
    && tar -zxf /tmp/apache-ant.tar.gz \
    && rm -f /tmp/apache-ant.tar.gz

ENV ANT_HOME /usr/share/java/apache-ant/apache-ant-1.9.7
ENV PATH ${PATH}:${ANT_HOME}/bin

ENTRYPOINT ["/opt/zulu-jdk8/bin", "java", "-version"]

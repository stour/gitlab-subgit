FROM gitlab/gitlab-ce:latest

USER root

# add SSL keys
RUN mkdir -p /etc/gitlab/ssl && \
    chmod 700 /etc/gitlab/ssl
COPY your-hostname.key /etc/gitlab/ssl/
COPY your-hostname.crt /etc/gitlab/ssl/

# install unzip
RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip

# install JDK
ENV JAVA_VERSION 8u112
ENV JAVA_VERSION_PREFIX 1.8.0_112
ENV JAVA_HOME /opt/jdk$JAVA_VERSION_PREFIX
ENV PATH $JAVA_HOME/bin:$PATH

ADD jdk-$JAVA_VERSION-linux-x64.tar.gz /opt/

# install SubGit
ENV SUBGIT_VERSION 3.2.2
ENV SUBGIT_HOME /opt/subgit-$SUBGIT_VERSION
ENV PATH $SUBGIT_HOME/bin/:$PATH
COPY subgit-$SUBGIT_VERSION.zip /tmp/

WORKDIR /tmp/
RUN unzip subgit-$SUBGIT_VERSION.zip && \
    mv subgit-$SUBGIT_VERSION /opt/ && \
    chown -R root:root $SUBGIT_HOME && \
    chmod -R go+x $SUBGIT_HOME && \
    rm subgit-$SUBGIT_VERSION.zip
ENV PATH $SUBGIT_HOME/bin/:$PATH

# copy SubGit registration key
COPY subgit.key $SUBGIT_HOME/

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
# and execute GitLab wrapper
CMD ["/assets/wrapper"]

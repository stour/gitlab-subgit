FROM gitlab/gitlab-ce:latest

USER root

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
ENV SUBGIT_HOME /opt/subgit-3.2.2
ENV PATH $SUBGIT_HOME/bin/:$PATH
COPY subgit-$SUBGIT_VERSION.zip /tmp/

WORKDIR /tmp/
RUN unzip subgit-$SUBGIT_VERSION.zip && \
    mv subgit-$SUBGIT_VERSION /opt/ && \
    chown -R root:root /opt/subgit-$SUBGIT_VERSION && \
    chmod -R go+x /opt/subgit-$SUBGIT_VERSION && \
    rm subgit-$SUBGIT_VERSION.zip
ENV PATH /opt/subgit-$SUBGIT_VERSION/bin/:$PATH

# copy SubGit registration key
COPY subgit.key /opt/subgit-$SUBGIT_VERSION/

COPY entrypoint.sh /entrypoint.sh
# restart SubGit daemon on configured repositories
ENTRYPOINT ["/entrypoint.sh"]
# and execute GitLab wrapper
CMD ["/assets/wrapper"]
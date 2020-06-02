FROM ubuntu:20.04

RUN apt-get -y update && apt-get -y install --no-install-recommends \
  ca-certificates \
  gnupg2 \
  vsftpd \
  jq \
  supervisor \
  apt-transport-https \
  s3fs \
  wget \
  unzip \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home
RUN mkdir -p /var/run/vsftpd/empty/

RUN wget https://github.com/storj/gateway/releases/download/v1.1.2/gateway_linux_amd64.zip && \
    unzip gateway_linux_amd64.zip && \
    mv gateway /usr/local/bin/gateway && \
    rm gateway_linux_amd64.zip

VOLUME /root/.local/share/storj/gateway

#ADD gateway.sh start.sh add_users_in_container.sh /usr/local/
ADD gateway.sh start.sh /usr/local/

ADD vsftpd.conf /etc/vsftpd.conf

RUN chown root:root /etc/vsftpd.conf

RUN echo "/usr/sbin/nologin" >> /etc/shells

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#RUN groupadd ftpaccess

EXPOSE 21 30000-30100

ENV STORJ_CONFIG_DIR=/root/.local/share/storj/gateway \
    STORJ_SERVER_ADDRESS=0.0.0.0:7777 \
    STORJ_ACCESS= \
    STORJ_SAT_ADDRESS= \
    STORJ_API_KEY= \
    STORJ_PASSPHRASE= \
    FTP_BUCKET= \
    FTP_PASV_ADDRESS= \
    FTP_USER=

CMD ["/usr/bin/supervisord"]

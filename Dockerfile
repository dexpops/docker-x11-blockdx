FROM debian:stretch-slim as builder

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu wget unzip \
	&& mkdir /tmp/bin

ENV BLOCKNETDX_VERSION 3.12.1
ENV BLOCKNETDX_URL https://github.com/BlocknetDX/blocknet/releases/download/v$BLOCKNETDX_VERSION/blocknetdx-$BLOCKNETDX_VERSION-x86_64-linux-gnu.tar.gz
ENV CONSUL_TEMPLATE_VERSION 0.20.0
ENV GOSU_VERSION 1.11

WORKDIR /tmp

# install blocknetdx, consul-temlate and gosu binaries
RUN set -ex \
&& wget -qO blocknetdx.tar.gz "$BLOCKNETDX_URL" \
&& wget -qO gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
&& wget -qO consul-template.zip "https://releases.hashicorp.com/consul-template/0.20.0/consul-template_0.20.0_linux_amd64.zip" \
&& tar -xzvf blocknetdx.tar.gz --strip-components=2 "blocknetdx-$BLOCKNETDX_VERSION/bin/blocknetdx-cli" "blocknetdx-$BLOCKNETDX_VERSION/bin/blocknetdxd" "blocknetdx-$BLOCKNETDX_VERSION/bin/blocknetdx-qt" \
&& cp blocknetdx-cli /tmp/bin && cp blocknetdxd /tmp/bin && cp blocknetdx-qt /tmp/bin \
&& unzip -d /tmp/bin consul-template.zip \
&& cp gosu /tmp/bin && cp $(which wget) /tmp/bin && cp $(which unzip) /tmp/bin

FROM debian:sid-slim
COPY --from=builder "/tmp/bin" /usr/local/bin

RUN ls -lastrh /usr/local/bin && chmod +x /usr/local/bin/gosu && groupadd -r blocknet && useradd -r -m -g blocknet blocknet

# create data directory
ENV BLOCKNETDX_DATA /data
RUN mkdir "$BLOCKNETDX_DATA" \
	&& chown -R blocknet:blocknet "$BLOCKNETDX_DATA" \
	&& ln -sfn "$BLOCKNETDX_DATA" /home/blocknet/.blocknetdx \
	&& chown -h blocknet:blocknet /home/blocknet/.blocknetdx

VOLUME /data

RUN apt-get update && apt-get install -y \
	ca-certificates \
	supervisor \
	netcat \
	gconf2 \
	gconf-service \
	libnotify4 \
	libappindicator1 \
	libxtst6 \
	libnss3 \
	libxss1 \
	libgtk-3-dev \
	libasound2 \
	procps curl net-tools dnsutils vim \
	--no-install-recommends \
  && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/apt \
  && mkdir -p /var/cache/apt

ENV LANG en-US

# libgtk-3-dev \
# hicolor-icon-theme \
# fonts-noto \
# fonts-noto-cjk \
# fonts-noto-color-emoji \

RUN wget -qO block-dx.deb https://github.com/BlocknetDX/block-dx/releases/download/v1.0.1/BLOCK-DX-1.0.1-linux.deb
RUN dpkg -i block-dx.deb

COPY bin/* /usr/local/bin/
COPY config/blocknetdx.conf /home/blocknet/.blocknetdx/blocknetdx.conf

# -----------------------
# SETUP CONSUL TEMPLATE
#------------------------
COPY config/consul-template.hcl /usr/local/etc/consul-template/etc/config.hcl
COPY consul_templates/start-blockdx.ctmpl /usr/local/bin/start-blockdx.ctmpl
COPY consul_templates/xbridge.conf.ctmpl /home/blocknet/.blocknetdx/xbridge.conf.ctmpl
COPY consul_templates/blocknetdx.conf.ctmpl /home/blocknet/.blocknetdx/blocknetdx.conf.ctmpl
COPY consul_templates/app-meta.json.ctmpl /home/blocknet/.config/BLOCK-DX/app-meta.json.ctmpl

# ----------------------
# SETUP SUPERVISOR
#-----------------------
COPY supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisor/conf.d/* /etc/supervisor/conf.d/

RUN chmod +x /usr/local/bin/* && chown -R blocknet:blocknet /usr/local/bin

EXPOSE 41414

ENTRYPOINT [ "supervisord", "-c", "/etc/supervisor/supervisord.conf" ]
FROM debian:sid-slim

RUN apt-get update && apt-get install -y \
	ca-certificates \
	libgtk-3-dev \
	hicolor-icon-theme \
	fonts-noto \
	fonts-noto-cjk \
	fonts-noto-color-emoji \
	wget gconf2 gconf-service libnotify4 libappindicator1 libnss3 libxss1 libasound2 \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV LANG en-US

COPY local.conf /etc/fonts/local.conf

RUN wget -qO block-dx.deb https://github.com/BlocknetDX/block-dx/releases/download/v1.0.1/BLOCK-DX-1.0.1-linux.deb && \
dpkg -i block-dx.deb && \
mkdir -p /root/.config/BLOCK-DX

COPY bin/* /usr/bin/
COPY files/app-meta.json /root/.config/BLOCK-DX/app-meta.json

ENTRYPOINT [ "startblockdx" ]
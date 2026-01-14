#############
# Nginx Custom (Pre-built from nginx-source)
#############

FROM debian:trixie-slim AS final
LABEL maintainer="Mark Deng"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG TARGETPLATFORM
ARG TARGETARCH
ARG NGINX_RELEASE_URL="https://github.com/markd3ng/nginx-source/releases/download/rolling"

RUN echo "Base: debian:trixie-slim, ${TARGETPLATFORM:-linux/amd64}" > /built-for-arch

ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	apache2-utils \
	ca-certificates \
	curl \
	figlet \
	jq \
	libmaxminddb0 \
	libxml2 \
	libxslt1.1 \
	libgd3 \
	libpam0g \
	libzstd1 \
	libpcre2-8-0 \
	openssl \
	perl \
	tzdata \
	unzip \
	wget \
	xz-utils \
	moreutils \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/cache/* /var/log/* /tmp/* /var/lib/dpkg/status-old

# Download and extract pre-built Nginx
ADD ${NGINX_RELEASE_URL}/nginx-custom-linux-${TARGETARCH}.tar.gz /tmp/
RUN tar -xzf /tmp/nginx-custom-linux-${TARGETARCH}.tar.gz -C / \
	&& rm /tmp/nginx-custom-linux-${TARGETARCH}.tar.gz \
	&& ldconfig

# Create directories required by NPM at runtime
RUN mkdir -p /etc/nginx/conf.d \
	&& mkdir -p /run/nginx \
	&& mkdir -p /tmp/nginx/body \
	&& mkdir -p /var/cache/nginx \
	&& mkdir -p /var/lib/nginx/cache/public \
	&& mkdir -p /var/lib/nginx/cache/private \
	&& mkdir -p /var/log/nginx \
	&& touch /var/log/nginx/error.log \
	&& touch /var/log/nginx/access.log

# Create openresty symlinks (NPM code calls 'openresty' command)
RUN ln -sf /usr/sbin/nginx /usr/local/bin/openresty \
	&& ln -sf /usr/sbin/nginx /usr/bin/openresty

# Copy shell config
COPY ./files/.bashrc /root/.bashrc

LABEL org.label-schema.schema-version="1.0" \
	org.label-schema.license="MIT" \
	org.label-schema.name="nginx-full" \
	org.label-schema.description="A base image for use by Nginx Proxy Manager" \
	org.label-schema.url="https://github.com/markd3ng/docker-nginx-full" \
	org.label-schema.vcs-url="https://github.com/markd3ng/docker-nginx-full.git" \
	org.label-schema.cmd="docker run --rm -ti markd3ng/nginx-full:latest"

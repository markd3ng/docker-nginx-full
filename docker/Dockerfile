#############
# Nginx Custom (Pre-built from nginx-source)
#############

FROM debian:trixie-slim AS final
LABEL maintainer="Mark Deng"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG TARGETPLATFORM
ARG TARGETARCH
ARG NGINX_VERSION
ARG NGINX_ENCODED_TAG
ARG NGINX_FULL_TAG
# Use URL-encoded tag for download URL (GitHub requires %2F instead of / in tag names)
ARG NGINX_RELEASE_URL="https://github.com/markd3ng/nginx-builder-ng/releases/download/${NGINX_ENCODED_TAG}"

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
ADD ${NGINX_RELEASE_URL}/sha256sums-${TARGETARCH}.txt /tmp/sha256sums.txt
ADD ${NGINX_RELEASE_URL}/nginx-mainline-mk-${NGINX_VERSION}-linux-${TARGETARCH}.tar.gz /tmp/
RUN cd /tmp \
	&& grep "nginx-mainline-mk-${NGINX_VERSION}-linux-${TARGETARCH}.tar.gz" sha256sums.txt | sha256sum -c - \
	&& tar -xzf nginx-mainline-mk-${NGINX_VERSION}-linux-${TARGETARCH}.tar.gz -C / \
	&& rm nginx-mainline-mk-${NGINX_VERSION}-linux-${TARGETARCH}.tar.gz sha256sums.txt \
	&& ldconfig

# Download expected modules list for self-describing tests
ADD ${NGINX_RELEASE_URL}/expected_modules.txt /etc/nginx/modules/expected_modules.txt

# Create directories required by NPM at runtime
RUN mkdir -p /etc/nginx/conf.d \
	&& mkdir -p /etc/nginx/nginx \
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
	org.label-schema.name="nginx-base-image" \
	org.label-schema.description="A base image for use by Nginx Proxy Manager" \
	org.label-schema.url="https://github.com/markd3ng/nginx-base-image" \
	org.label-schema.vcs-url="https://github.com/markd3ng/nginx-base-image.git" \
	org.label-schema.cmd="docker run --rm -ti markd3ng/nginx-base-image:latest"

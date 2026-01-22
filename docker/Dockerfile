#############
# Downloader Stage
#############
FROM debian:trixie-slim AS downloader

ARG TARGETARCH
ARG NGINX_VERSION
ARG NGINX_ENCODED_TAG
ARG NGINX_RELEASE_URL="https://github.com/markd3ng/nginx-builder-ng/releases/download/${NGINX_ENCODED_TAG}"

# Install tar/xz/grep/ca-certificates if needed (debian slim has them usually, but safe to check if network needed)
# Actually ADD/COPY handles remote URL if supported, but here acts as Context. 
# Wait, ADD supports URL. 
# We need basic tools to extract.
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates xz-utils && rm -rf /var/lib/apt/lists/*

# Download and extract pre-built Nginx
WORKDIR /extract

# Download via ADD (Cached by Docker if URL/Content doesn't change)
ADD ${NGINX_RELEASE_URL}/sha256sums-${TARGETARCH}.txt /tmp/sha256sums.txt
ADD ${NGINX_RELEASE_URL}/nginx-mainline-mk-${NGINX_VERSION}-linux-${TARGETARCH}.tar.gz /tmp/nginx.tar.gz

# Verify checksum (keep tarball for final stage)
RUN cd /tmp \
	&& grep "nginx-mainline-mk-${NGINX_VERSION}-linux-${TARGETARCH}.tar.gz" sha256sums.txt | sed 's/nginx-mainline-mk.*\.tar\.gz/nginx.tar.gz/' | sha256sum -c - \
	&& rm sha256sums.txt

# Download expected modules list
ADD ${NGINX_RELEASE_URL}/expected_modules.txt /tmp/expected_modules.txt

#############
# Final Image
#############

FROM debian:trixie-slim AS final
LABEL maintainer="Mark Deng"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG TARGETPLATFORM
ARG TARGETARCH

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

# Copy and extract Nginx from downloader stage (tar handles symlinks correctly)
COPY --from=downloader /tmp/nginx.tar.gz /tmp/nginx.tar.gz
COPY --from=downloader /tmp/expected_modules.txt /etc/nginx/modules/expected_modules.txt
RUN tar -xzf /tmp/nginx.tar.gz -C / && rm /tmp/nginx.tar.gz

# Post-install setup
RUN ldconfig \
	# Create directories
	&& mkdir -p /etc/nginx/conf.d \
	&& mkdir -p /etc/nginx/nginx \
	&& mkdir -p /run/nginx \
	&& mkdir -p /tmp/nginx/body \
	&& mkdir -p /var/cache/nginx \
	&& mkdir -p /var/lib/nginx/cache/public \
	&& mkdir -p /var/lib/nginx/cache/private \
	&& mkdir -p /var/log/nginx \
	&& touch /var/log/nginx/error.log \
	&& touch /var/log/nginx/access.log \
	# Create symlinks
	&& ln -sf /usr/sbin/nginx /usr/local/bin/openresty \
	&& ln -sf /usr/sbin/nginx /usr/bin/openresty

# Smoke Test (Verify binary works after COPY)
RUN nginx -t && openresty -V

# Copy shell config
COPY ./files/.bashrc /root/.bashrc

LABEL org.label-schema.schema-version="1.0" \
	org.label-schema.license="MIT" \
	org.label-schema.name="nginx-base-image" \
	org.label-schema.description="A base image for use by Nginx Proxy Manager" \
	org.label-schema.url="https://github.com/markd3ng/nginx-base-image" \
	org.label-schema.vcs-url="https://github.com/markd3ng/nginx-base-image.git" \
	org.label-schema.cmd="docker run --rm -ti markd3ng/nginx-base-image:latest"

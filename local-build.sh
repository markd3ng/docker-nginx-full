#!/bin/bash -e

BLUE='\E[1;34m'
CYAN='\E[1;36m'
YELLOW='\E[1;33m'
GREEN='\E[1;32m'
RESET='\E[0m'

REGISTRY=${REGISTRY:-}
DOCKER_IMAGE="${REGISTRY}nginxproxymanager/nginx-full"

# Fetch latest tag from nginx-builder-ng
echo -e "${BLUE}❯ ${CYAN}Resolving latest Nginx version...${RESET}"
FULL_TAG=$(git ls-remote --tags --refs --sort='v:refname' https://github.com/markd3ng/nginx-builder-ng.git | grep -oE "nginx-mainline-mk/[0-9.]+(-[0-9]+)?" | tail -n1)

if [ -z "$FULL_TAG" ]; then
    echo -e "${YELLOW}Error: Could not resolve latest tag from nginx-builder-ng${RESET}"
    exit 1
fi

ENCODED_TAG=$(echo "$FULL_TAG" | sed 's/\//%2F/g')
VERSION=${FULL_TAG#nginx-mainline-mk/}

echo -e "  Full Tag:    ${GREEN}$FULL_TAG${RESET}"
echo -e "  Encoded Tag: ${GREEN}$ENCODED_TAG${RESET}"
echo -e "  Version:     ${GREEN}$VERSION${RESET}"

export BASE_IMAGE="${DOCKER_IMAGE}:latest"
export ACMESH_IMAGE="${DOCKER_IMAGE}:acmesh"
export CERTBOT_IMAGE="${DOCKER_IMAGE}:certbot"
export CERTBOT_NODE_IMAGE="${DOCKER_IMAGE}:certbot-node"
export ACMESH_GOLANG_IMAGE="${DOCKER_IMAGE}:acmesh-golang"

# Builds

echo -e "${BLUE}❯ ${CYAN}Building ${YELLOW}latest ${CYAN}...${RESET}"
docker build \
	--pull \
	--build-arg NGINX_VERSION="$VERSION" \
	--build-arg NGINX_FULL_TAG="$FULL_TAG" \
    --build-arg NGINX_ENCODED_TAG="$ENCODED_TAG" \
	-t "$BASE_IMAGE" \
	-f docker/Dockerfile \
	.

echo -e "${BLUE}❯ ${CYAN}Building ${YELLOW}acmesh ${CYAN}...${RESET}"
docker build \
	--build-arg BASE_IMAGE \
	-t "$ACMESH_IMAGE" \
	-f docker/Dockerfile.acmesh \
	.

echo -e "${BLUE}❯ ${CYAN}Building ${YELLOW}certbot ${CYAN}...${RESET}"
docker build \
	--build-arg BASE_IMAGE \
	-t "$CERTBOT_IMAGE" \
	-f docker/Dockerfile.certbot \
	.

echo -e "${BLUE}❯ ${CYAN}Building ${YELLOW}acmesh-golang ${CYAN}...${RESET}"
docker build \
	--build-arg ACMESH_IMAGE \
	-t "$ACMESH_GOLANG_IMAGE" \
	-f docker/Dockerfile.acmesh-golang \
	.

echo -e "${BLUE}❯ ${CYAN}Building ${YELLOW}certbot-node ${CYAN}...${RESET}"
docker build \
	--build-arg CERTBOT_IMAGE \
	-t "$CERTBOT_NODE_IMAGE" \
	-f docker/Dockerfile.certbot-node \
	.

echo -e "${BLUE}❯ ${GREEN}All done!${RESET}"

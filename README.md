# nginx-base-image

<p>
  <a href="https://github.com/markd3ng/nginx-base-image/actions/workflows/build.yml">
    <img src="https://github.com/markd3ng/nginx-base-image/actions/workflows/build.yml/badge.svg" alt="Build Status">
  </a>
  <a href="https://github.com/markd3ng/nginx-base-image/pkgs/container/nginx-base-image">
    <img src="https://img.shields.io/badge/ghcr.io-nginx--base--image-blue?style=flat-square&logo=github" alt="GHCR">
  </a>
</p>

Docker base images for [Nginx Proxy Manager](https://github.com/NginxProxyManager/nginx-proxy-manager), built with pre-compiled Nginx binaries from [nginx-builder-ng](https://github.com/markd3ng/nginx-builder-ng).

## Features

- 🚀 **Pre-built Nginx** — Uses optimized, pre-compiled binaries (no compilation during image build)
- 🏗️ **Multi-stage Dockerfile** — Minimal final image size
- ⚡ **Parallel Architecture Builds** — AMD64 and ARM64 built simultaneously
- ✅ **Built-in Smoke Tests** — `nginx -t` validation during build
- 🔄 **Automatic Triggers** — Supports `repository_dispatch` for upstream releases

## Available Images

| Tag | Description |
|-----|-------------|
| `latest` | Base image with Nginx/OpenResty |
| `certbot` | + Certbot, Python3, pip |
| `certbot-node` | + Certbot, Python3, pip, Node.js *(NPM v2)* |
| `acmesh` | + acme.sh *(NPM v3)* |
| `acmesh-golang` | + acme.sh, Golang *(NPM v3 dev)* |

## Supported Architectures

- `linux/amd64`
- `linux/arm64`

## Usage

### As Base Image

```dockerfile
FROM ghcr.io/markd3ng/nginx-base-image:latest

# Your application layers...
```

### Local Build

```bash
./local-build.sh
```

This script automatically fetches the latest Nginx version from `nginx-builder-ng` releases.

### Acme.sh Example

```bash
docker run --rm \
  -v /path/to/acme-data:/data/.acme.sh \
  ghcr.io/markd3ng/nginx-base-image:acmesh \
  acme.sh --help
```

## Build Pipeline

```
nginx-builder-ng (compile Nginx)
        ↓
   GitHub Release (tar.gz + checksums)
        ↓
nginx-base-image (download → verify → extract → package)
        ↓
   GHCR (multi-arch manifest)
```

## Related Projects

- [nginx-builder-ng](https://github.com/markd3ng/nginx-builder-ng) — Nginx compiler with OpenSSL, PCRE2, zlib
- [nginx-proxy-manager](https://github.com/NginxProxyManager/nginx-proxy-manager) — Full proxy management UI

## License

MIT

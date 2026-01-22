# nginx-base-image

<p>
  <a href="https://github.com/markd3ng/nginx-base-image/actions/workflows/build.yml">
    <img src="https://github.com/markd3ng/nginx-base-image/actions/workflows/build.yml/badge.svg" alt="构建状态">
  </a>
  <a href="https://github.com/markd3ng/nginx-base-image/pkgs/container/nginx-base-image">
    <img src="https://img.shields.io/badge/ghcr.io-nginx--base--image-blue?style=flat-square&logo=github" alt="GHCR">
  </a>
</p>

[Nginx Proxy Manager](https://github.com/NginxProxyManager/nginx-proxy-manager) 的 Docker 基础镜像，使用 [nginx-builder-ng](https://github.com/markd3ng/nginx-builder-ng) 预编译的 Nginx 二进制文件。

## 特性

- 🚀 **预编译 Nginx** — 使用优化过的预编译二进制，无需在镜像构建时编译
- 🏗️ **多阶段 Dockerfile** — 最小化最终镜像体积
- ⚡ **并行架构构建** — AMD64 和 ARM64 同时构建
- ✅ **内置冒烟测试** — 构建时自动执行 `nginx -t` 验证
- 🔄 **自动触发** — 支持 `repository_dispatch` 响应上游发布

## 可用镜像

| 标签 | 描述 |
|-----|-------------|
| `latest` | 基础镜像，包含 Nginx/OpenResty |
| `certbot` | + Certbot, Python3, pip |
| `certbot-node` | + Certbot, Python3, pip, Node.js *(NPM v2)* |
| `acmesh` | + acme.sh *(NPM v3)* |
| `acmesh-golang` | + acme.sh, Golang *(NPM v3 开发)* |

## 支持架构

- `linux/amd64`
- `linux/arm64`

## 使用方法

### 作为基础镜像

```dockerfile
FROM ghcr.io/markd3ng/nginx-base-image:latest

# 你的应用层...
```

### 本地构建

```bash
./local-build.sh
```

该脚本会自动从 `nginx-builder-ng` 获取最新的 Nginx 版本。

### Acme.sh 示例

```bash
docker run --rm \
  -v /path/to/acme-data:/data/.acme.sh \
  ghcr.io/markd3ng/nginx-base-image:acmesh \
  acme.sh --help
```

## 构建流水线

```
nginx-builder-ng (编译 Nginx)
        ↓
   GitHub Release (tar.gz + 校验和)
        ↓
nginx-base-image (下载 → 验证 → 解压 → 打包)
        ↓
   GHCR (多架构 manifest)
```

## 相关项目

- [nginx-builder-ng](https://github.com/markd3ng/nginx-builder-ng) — Nginx 编译器，集成 OpenSSL, PCRE2, zlib
- [nginx-proxy-manager](https://github.com/NginxProxyManager/nginx-proxy-manager) — 完整的代理管理界面

## 许可证

MIT

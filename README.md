# 🚀 Kua9 Hysteria2 Server

这是一个用于快速在各种云平台（包括 PaaS 平台如 Zeabur, Render, Koyeb 等）和独立服务器上部署 **Hysteria2** 节点的 Docker/源码构建方案。

通过环境变量动态传递端口和密码，自动生成自签名证书和客户端一键导入链接。

## ✨ 特性

- **基于 Alpine Linux**：镜像体积极小，安全轻量。
- **自动获取与更新**：部署时自动拉取 Github 官方最新版 Hysteria2 核心。
- **动态配置**：完全通过环境变量控制 `PORT` (端口) 和 `PASSWORD` (密码)，无需修改代码。
- **一键导入配置**：启动容器后，自动在控制台打印支持多种客户端（v2rayN, Nekobox, Shadowrocket 等）的订阅 / 单节点分享链接。
- **兼容性强**：不仅支持标准 Docker 部署，也完美支持云平台通过 **“从 Github 源码构建” (Dockerfile 构建)** 的方式部署，有效解决国内机器拉取 Docker Hub 镜像失败 (`registry-1.docker.io server misbehaving`) 的问题。

## 📦 部署方式一：通过云平台源码部署 (推荐用于 PaaS 平台)

如果你遇到了从 Docker Hub 拉取镜像失败的问题，或者你正在使用按应用计费的云平台，推荐此方法：

1. **Fork 或 Clone** 本仓库到你自己的 GitHub。
2. 在你的云平台创建新项目，选择 **"从 GitHub 仓库导入"**。
3. 选择构建方式为 **Dockerfile**（大多数平台会自动识别此仓库内的 `Dockerfile`）。
4. 在云平台的 **Environment Variables (环境变量)** 设置中，添加以下变量：
    - `PORT`: 平台分配给你的外部访问端口（注意：Hysteria2 是 **纯 UDP** 协议，请确保平台支持开放 UDP 端口）。如果不填，默认是 `8443`。
    - `PASSWORD`: 你自己设定的连接密码。如果不填，默认是 `kua9`。
5. 点击 **Deploy (部署)**，等待平台自动构建并启动完成。
6. 在平台的 **Logs (日志)** 页面查看你的专属分享链接！

## 🐳 部署方式二：通过 Docker / Docker Compose 部署 (推荐用于独立 VPS)

如果你有一台独立的云服务器 (VPS)，可以直接使用 Docker Compose。

1. 确保服务器已安装 `docker` 和 `docker-compose`。
2. 创建或使用仓库里的 `docker-compose.yml` 文件：

```yaml
version: '3.8'

services:
  hysteria2:
    build: . # 如果你已经克隆了本仓库，可以直接用 build 本地构建来防墙
    # image: kua9/hysteria2:latest # 如果你能正常连 Docker Hub，可以用这行代替上一行
    container_name: hysteria2-server
    restart: always
    network_mode: "host" 
    environment:
       - PORT=8443        # 自定义你的监听端口
       - PASSWORD=你的密码 # 自定义你的密码
       # - HOST=1.2.3.4   # (可选) 强制指定分享链接中的IP或域名
```

3. 在该文件所在目录执行命令在后台启动：
```bash
docker-compose up -d --build
```
*(注：`--build` 会利用本地的 `Dockerfile` 实时构建镜像，彻底避开拉取外部镜像的网络问题)*

4. 查看日志不仅能确认是否启动成功，还能**获取客户端分享链接**：
```bash
docker logs hysteria2-server --tail 50
```

## ⚠️ 注意事项

- **UDP 协议限制**：Hysteria2 协议基于 QUIC，是**纯 UDP** 传输。务必确保你的服务器防火墙（如阿里云安全组、宝塔面板防火墙）或云供应商已经放行了你在 `PORT` 变量中设置的 **UDP 端口**。如果只放行 TCP，是绝对连不上的！
- **自签名证书**：本项目默认帮你自动生成有效期 10 年的自签名证书。客户端链接中会自动附带 `insecure=1` 参数来允许不安全证书，请勿在客户端删掉此配置。

## 📄 文件结构简述

- `Dockerfile`: 构建镜像的配方，负责准备运行环境和拉取核心文件。
- `entrypoint.sh`: 容器启动时实际运行的脚本，负责处理环境变量、生成证书、生成配置文件并最后启动 Hysteria2。
- `docker-compose.yml`: 供拥有独立服务器的用户快速启动使用的编排文件。
- `部署说明.md`: (本文档之前的版本) 包含了打包发布镜像到 Docker Hub 的命令备忘。

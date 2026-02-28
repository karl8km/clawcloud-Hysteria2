# 🚀 Kua9 Hysteria2 Server (Claw Cloud / 爪云专用部署版)

这是一个专为在 **Claw Cloud (爪云)** 等云平台上极速部署 **Hysteria2** 节点而制作的纯正净像包。

本镜像托管于 GitHub Packages (GHCR)，完美解决了传统的 Docker Hub 镜像在国内机器或部分特定云平台由于网络受限导致拉取失败（如报 `server misbehaving` 错误）的问题。

## 📦 如何在爪云部署

非常简单！在爪云创建应用时，选择 **Docker Image / 容器镜像** 部署方式，并在镜像地址一栏直接填入以下链接：

```text
ghcr.io/karl8km/clawcloud-hysteria2:latest
```

## ⚙️ 必需的环境变量 (Environment Variables)

在爪云的部署配置页面，请务必找到 **环境变量 (Environment Variables)** 设置区域，至少添加以下两个变量(一定要大写，否则读取不了)：

- **`PORT`**：输入你想设置（或平台分配给你）的节点**外部访问端口**。（如果不填，默认 `8443`）。
- **`PASSWORD`**：输入你自己想设置的**节点连接密码**。（如果不填，默认 `kua9`）。

## ⚠️ 关键注意事项

1. **UDP 协议放行**：Hysteria2 协议基于 QUIC，是 **纯 UDP 流量**。请务必确认你在爪云的安全组/防火墙设置面板里，**开放了那个端口的 UDP 流量协议**，如果只开了 TCP 是绝对连不上的！
2. **获取分享链接**：容器启动成功后，请在爪云应用对应的 **日志 (Logs** 或 **Console)** 面板中查看，里面会自动打印出带有你密码和端口的**一键导入链接**，支持直接复制到 V2rayN、Nekobox 等主流客户端使用。

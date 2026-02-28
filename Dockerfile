# [cite_start]使用轻量级的 Alpine 作为基础镜像 [cite: 1]
FROM alpine:latest

# 安装必备组件：openssl(用于生成证书), ca-certificates(用于TLS校验), curl(用于下载)
RUN apk add --no-cache openssl ca-certificates curl tzdata

# 下载最新版的 Hysteria2 (默认拉取 linux-amd64 架构)
RUN curl -L -o /usr/local/bin/hysteria https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-amd64 && \
    chmod +x /usr/local/bin/hysteria

# 设置工作目录
WORKDIR /app

# 复制启动脚本并赋予执行权限
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 端口由环境变量 $PORT 决定，默认 8443
# EXPOSE 语句仅为声明，不实际映射端口，这里省略以避免硬编码误导

# 启动命令
CMD ["/app/entrypoint.sh"]
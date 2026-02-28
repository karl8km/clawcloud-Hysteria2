#!/bin/sh
set -e # 发生任何错误即中止脚本执行

# 读取环境变量，没设置就使用默认值
PORT=${PORT:-8443}
PASSWORD=${PASSWORD:-"kua9"}

echo "初始化 Hysteria2 节点..."

# 获取服务器的公网 IP（增加超时限制，防止无网络时永久卡死）
HOST=${HOST:-$(curl -s4 -m 5 ifconfig.me 2>/dev/null || echo "您的服务器公网IP")}

# 生成自签名证书
if [ ! -f "/app/server.crt" ]; then
    echo "未检测到证书，正在生成自签名证书..."
    openssl req -x509 -nodes -newkey rsa:2048 \
        -keyout /app/server.key \
        -out /app/server.crt \
        -days 3650 \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=bing.com" \
        > /dev/null 2>&1
fi

# 动态生成配置文件，这里的变量会直接被替换成你在 docker-compose 里设置的值
cat <<EOF > /app/config.yaml
listen: :$PORT

tls:
  cert: /app/server.crt
  key: /app/server.key

auth:
  type: password
  password: $PASSWORD
EOF

# 打印配置信息和最终分享链接到 Log
echo "========================================================"
echo "🎉 Hysteria2 服务准备就绪！（变量PORT和PASSWORD一定要大写）"
echo "监听端口: $PORT (纯 UDP 模式)"
echo "连接密码: $PASSWORD"
echo "服务器IP: $HOST"
echo "--------------------------------------------------------"
echo "👇 请复制以下一键导入链接 (支持 V2rayN / Nekobox / 等客户端) 👇"
echo "👇 根据自己情况二选一 👇"
echo ""
echo "一：平台分配的端口和地址域名"
echo "hysteria2://$PASSWORD@【请替换为平台分配的公网地址：平台分配的5位数端口】/?insecure=1&sni=bing.com#Kua9-Hysteria2"
echo "二：服务器IP和端口"
echo "hysteria2://$PASSWORD@$HOST:$PORT/?insecure=1&sni=bing.com#Kua9-Hysteria2"
echo ""
echo "⚠️ 注意事项:"
echo "1. 由于使用自签名证书，链接自带 insecure=1 参数，请勿修改。"
echo "2. 请务必确认你的云主机面板已放行 $PORT 端口的 UDP 流量！"
echo "========================================================"

# 启动 Hysteria2 服务器
exec /usr/local/bin/hysteria server -c /app/config.yaml
#!/bin/bash
# <UDF name="http_port" label="HTTP NodePort of Ingress Controller" example="30080" default="">
# <UDF name="https_port" label="HTTPS NodePort of Ingress Controller" example="30443" default="">
# <UDF name="private_ips" label="Private IP Addresses of LKE Cluster Nodes" example="192.168.200.200 192.168.200.201" default="">

# Enable TCP BBR
echo net.core.default_qdisc=fq >> /etc/sysctl.conf
echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control

# Install HAProxy
apt-get install -y haproxy

cat > /etc/haproxy/haproxy.cfg <<EOF
global
    maxconn     50000
    log         127.0.0.1 local0
    user        haproxy
    daemon

frontend http
    bind :80
    bind :::80
    mode tcp
    default_backend	http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend https
    bind :443
    bind :::443
    mode tcp
    default_backend	https
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

backend http
    mode        tcp
    balance     roundrobin
EOF

PRIVATE_IP=($PRIVATE_IPS)
for i in "${!PRIVATE_IP[@]}"; do
echo "    server      http${i} ${PRIVATE_IP[$i]}:${HTTP_PORT} check send-proxy" >> /etc/haproxy/haproxy.cfg
done

cat >> /etc/haproxy/haproxy.cfg <<EOF

backend https
    mode        tcp
    balance     roundrobin
EOF

for i in "${!PRIVATE_IP[@]}"; do
echo "    server      https${i} ${PRIVATE_IP[$i]}:${HTTPS_PORT} check send-proxy" >> /etc/haproxy/haproxy.cfg
done

systemctl restart haproxy
systemctl enable haproxy

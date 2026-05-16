#!/bin/sh

set -e

echo "📥 Downloading Xray Core v26.3.27..."
wget -O /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v26.3.27/Xray-linux-64.zip

echo "📂 Installing Xray..."
unzip -o /tmp/xray.zip -d /tmp/xray_dist
chmod +x /tmp/xray_dist/xray
mv /tmp/xray_dist/xray /usr/local/bin/xray

echo "🧹 Cleaning up..."
rm -rf /tmp/xray.zip /tmp/xray_dist

echo "✅ Xray installed successfully!"

# ── Gaming Network Optimizations ──────────────────────────────────
echo "🎮 Applying gaming network optimizations..."

# Enable BBR congestion control (reduces packet loss significantly)
if modprobe tcp_bbr 2>/dev/null; then
  echo "tcp_bbr" >> /etc/modules-load.d/bbr.conf
  echo "net.core.default_qdisc=fq"         >> /etc/sysctl.d/99-gaming.conf
  echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/99-gaming.conf
  echo "✅ BBR enabled"
else
  echo "⚠️  BBR not available, skipping"
fi

# TCP buffer & latency tuning
cat >> /etc/sysctl.d/99-gaming.conf << 'EOF'
# Reduce bufferbloat → lower ping spikes
net.ipv4.tcp_low_latency=1
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_moderate_rcvbuf=1

# TCP Fast Open (client + server)
net.ipv4.tcp_fastopen=3

# Keep-alive to recover dropped connections faster
net.ipv4.tcp_keepalive_time=60
net.ipv4.tcp_keepalive_intvl=10
net.ipv4.tcp_keepalive_probes=6

# Retransmit faster on packet loss
net.ipv4.tcp_retries2=8
net.ipv4.tcp_syn_retries=3

# Socket buffer sizes (4MB)
net.core.rmem_max=4194304
net.core.wmem_max=4194304
net.ipv4.tcp_rmem=4096 87380 4194304
net.ipv4.tcp_wmem=4096 65536 4194304

# Reduce TIME_WAIT sockets
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_fin_timeout=15
EOF

sysctl -p /etc/sysctl.d/99-gaming.conf 2>/dev/null || true
echo "✅ Network tuning applied"

# ── UUID & Config ──────────────────────────────────────────────────
UUID=$(cat /proc/sys/kernel/random/uuid)
echo "🔑 Generated UUID: $UUID"
sed -i "s/__UUID__/$UUID/" /etc/config.json

# ── Print configs script ───────────────────────────────────────────
cat > /usr/local/bin/print-configs.sh << SCRIPT
#!/bin/sh
UUID=\$(grep -o '"id": *"[^"]*"' /etc/config.json | grep -o '[0-9a-f-]\{36\}')
SNI="\${CODESPACE_NAME}-443.app.github.dev"
IRAN_TIME=\$(TZ='Asia/Tehran' date +'%H:%M')

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎮 G-Tunnel GAMING CONFIGS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "vless://\${UUID}@63.141.252.203:443?encryption=none&security=tls&type=ws&sni=\${SNI}&path=%2Flive-chat#@Subioir DarkForce&LifeisBrown US1 - \${IRAN_TIME}"
echo ""
echo "vless://\${UUID}@142.54.178.211:443?encryption=none&security=tls&type=ws&sni=\${SNI}&path=%2Flive-chat#@Subioir DarkForce&LifeisBrown US2 - \${IRAN_TIME}"
echo ""
echo "vless://\${UUID}@204.12.196.34:443?encryption=none&security=tls&type=ws&sni=\${SNI}&path=%2Flive-chat#@Subioir DarkForce&LifeisBrown US3 - \${IRAN_TIME}"
echo ""
echo "vless://\${UUID}@50.7.87.2:443?encryption=none&security=tls&type=ws&sni=\${SNI}&path=%2Flive-chat#@Subioir DarkForce&LifeisBrown DE1 - \${IRAN_TIME}"
echo ""
echo "vless://\${UUID}@50.7.87.5:443?encryption=none&security=tls&type=ws&sni=\${SNI}&path=%2Flive-chat#@Subioir DarkForce&LifeisBrown DE2 - \${IRAN_TIME}"
echo ""
echo "vless://\${UUID}@50.7.87.4:443?encryption=none&security=tls&type=ws&sni=\${SNI}&path=%2Flive-chat#@Subioir DarkForce&LifeisBrown DE3 - \${IRAN_TIME}"
echo ""
echo "vless://\${UUID}@138.201.54.122:443?encryption=none&security=tls&type=ws&sni=\${SNI}&path=%2Flive-chat#@Subioir DarkForce&LifeisBrown DE4 - \${IRAN_TIME}"
echo ""
echo "vless://\${UUID}@94.130.50.12:443?encryption=none&security=tls&type=ws&sni=\${SNI}&path=%2Flive-chat#@Subioir DarkForce&LifeisBrown DE5 - \${IRAN_TIME}"
echo ""
echo "vless://\${UUID}@94.130.13.19:443?encryption=none&security=tls&type=ws&sni=\${SNI}&path=%2Flive-chat#@Subioir DarkForce&LifeisBrown DE6 - \${IRAN_TIME}"
echo ""
echo "vless://\${UUID}@50.7.87.3:443?encryption=none&security=tls&type=ws&sni=\${SNI}&path=%2Flive-chat#@Subioir DarkForce&LifeisBrown DE7 - \${IRAN_TIME}"
echo ""
echo "vless://\${UUID}@85.10.207.48:443?encryption=none&security=tls&type=ws&sni=\${SNI}&path=%2Flive-chat#@Subioir DarkForce&LifeisBrown DE8 - \${IRAN_TIME}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
SCRIPT

chmod +x /usr/local/bin/print-configs.sh

# Print configs at end of install
/usr/local/bin/print-configs.sh

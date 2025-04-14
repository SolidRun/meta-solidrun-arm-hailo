#!/bin/sh

IFACE="eth0"
CONFIG_DIR="/var/lib/connman"

MAC=$(cat /sys/class/net/${IFACE}/address | tr -d ':')
SERVICE_ID="ethernet_${MAC}_cable"
SETTINGS_FILE="${CONFIG_DIR}/${SERVICE_ID}/settings"

mkdir -p "${CONFIG_DIR}/${SERVICE_ID}"
MOD_DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)

cat > "${SETTINGS_FILE}" <<EOF
[${SERVICE_ID}]
Name=Wired
AutoConnect=true
Modified=${MOD_DATE}
IPv4.method=manual
IPv4.netmask_prefixlen=24
IPv4.local_address=10.0.0.1
IPv4.gateway=10.0.0.1
IPv6.method=off
IPv6.privacy=disabled
EOF

# Disable the init script by removing symlink
INIT_LINK="/etc/rc5.d/S02connman_static_ip"
[ -L "$INIT_LINK" ] && rm -f "$INIT_LINK"

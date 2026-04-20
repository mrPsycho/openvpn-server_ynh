#!/bin/bash
# Test script for OpenVPN Server YunoHost package
# Usage: ssh root@<server> < test_install.sh

set -e

echo "=== Testing OpenVPN Server Package Installation ==="

# Answer the interactive prompts
{
    echo "Yes, I understand"
    echo "1194"
    echo "udp"
    echo "1"
    echo "google"
} | yunohost app install https://github.com/mrPsycho/openvpn-server_ynh

echo ""
echo "=== Installation Complete. Checking files ==="

# Check if config files exist
OVPN_DIR="/etc/openvpn/server/openvpn-server"

echo "Listing $OVPN_DIR:"
ls -la "$OVPN_DIR"

echo ""
echo "=== Checking openvpn.conf file ==="
if [ -f "$OVPN_DIR/openvpn.conf" ]; then
    echo "✓ openvpn.conf file found!"
    echo "File size: $(stat -f%z "$OVPN_DIR/openvpn.conf" 2>/dev/null || stat -c%s "$OVPN_DIR/openvpn.conf")"
    echo ""
    echo "First 10 lines of openvpn.conf:"
    head -10 "$OVPN_DIR/openvpn.conf"
else
    echo "✗ openvpn.conf file NOT found!"
    exit 1
fi

echo ""
echo "=== Checking service status ==="
systemctl status openvpn-server@openvpn-server || echo "Note: Service may not be running in test environment"

echo ""
echo "=== Test Complete ==="

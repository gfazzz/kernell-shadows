#!/bin/bash
# KERNEL SHADOWS: Episode 07 — iptables Rules (low-level firewall)
# For advanced users who prefer iptables over UFW
#
# ⚠️ UFW is recommended for most users (simpler, safer)
# ⚠️ iptables is for advanced scenarios (custom rules, performance)
#
# DO NOT run this if UFW is active! (ufw uses iptables under the hood)

set -e
set -u

echo "═══════════════════════════════════════════════════════════════"
echo "  iptables RULES — Advanced Firewall Configuration"
echo "  ⚠️  WARNING: This will replace existing iptables rules!"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Check if UFW is active
if command -v ufw &> /dev/null && ufw status | grep -q "Status: active"; then
    echo "ERROR: UFW is active! Disable UFW first: sudo ufw disable"
    echo "(UFW uses iptables internally, conflicts will occur)"
    exit 1
fi

read -p "Continue with iptables configuration? (y/N): " confirm
[[ "$confirm" != "y" ]] && { echo "Aborted."; exit 0; }

echo ""
echo "[1/5] Flushing existing rules..."

# ============================================================================
# STEP 1: Flush existing rules (clean slate)
# ============================================================================
sudo iptables -F          # Flush all rules
sudo iptables -X          # Delete all user chains
sudo iptables -t nat -F   # Flush NAT table
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X

# ============================================================================
# STEP 2: Set default policies (DROP = deny)
# ============================================================================
echo "[2/5] Setting default policies..."
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# ============================================================================
# STEP 3: Allow loopback and established connections
# ============================================================================
echo "[3/5] Allowing loopback and established connections..."

# Loopback interface (localhost traffic)
sudo iptables -A INPUT -i lo -j ACCEPT

# Established and related connections (stateful firewall)
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# ============================================================================
# STEP 4: Allow critical services
# ============================================================================
echo "[4/5] Allowing critical services..."

# SSH (with rate limiting)
# Max 6 connections per 30 seconds per IP (prevents brute-force)
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set --name SSH
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 30 --hitcount 6 --rttl --name SSH -j DROP
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT -m comment --comment "SSH with rate limiting"

# HTTP
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT -m comment --comment "HTTP web server"

# HTTPS
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT -m comment --comment "HTTPS web server"

# Prometheus (internal network only)
sudo iptables -A INPUT -p tcp -s 10.20.30.0/24 --dport 9090 -j ACCEPT -m comment --comment "Prometheus monitoring"

# Grafana (internal network only)
sudo iptables -A INPUT -p tcp -s 10.20.30.0/24 --dport 3000 -j ACCEPT -m comment --comment "Grafana dashboards"

# PostgreSQL (only from specific app servers)
sudo iptables -A INPUT -p tcp -s 10.20.30.10 --dport 5432 -j ACCEPT -m comment --comment "PostgreSQL from app-01"
sudo iptables -A INPUT -p tcp -s 10.20.30.11 --dport 5432 -j ACCEPT -m comment --comment "PostgreSQL from app-02"

# ============================================================================
# STEP 5: Block known malicious IPs
# ============================================================================
echo "[5/5] Blocking known malicious IPs..."

# Krylov's C2 infrastructure
sudo iptables -A INPUT -s 185.220.101.0/24 -j DROP -m comment --comment "Krylov C2 network"
sudo iptables -A INPUT -s 45.138.172.0/24 -j DROP -m comment --comment "FSB tracking"
sudo iptables -A INPUT -s 195.154.146.0/24 -j DROP -m comment --comment "Russian VPS"

# TOR exit nodes
sudo iptables -A INPUT -s 199.249.230.0/24 -j DROP -m comment --comment "Tor exit nodes"

# China botnet
sudo iptables -A INPUT -s 218.92.0.0/16 -j DROP -m comment --comment "China botnet"

# ============================================================================
# STEP 6: DDoS Protection (SYN flood protection)
# ============================================================================

# SYN cookies (kernel parameter, not iptables rule)
echo 1 | sudo tee /proc/sys/net/ipv4/tcp_syncookies > /dev/null

# Limit SYN packets
sudo iptables -A INPUT -p tcp --syn -m limit --limit 1/s --limit-burst 3 -j ACCEPT
sudo iptables -A INPUT -p tcp --syn -j DROP -m comment --comment "SYN flood protection"

# ============================================================================
# STEP 7: Logging (optional, for debugging)
# ============================================================================

# Log dropped packets (useful for troubleshooting)
# sudo iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables-dropped: " --log-level 7

# ============================================================================
# STEP 8: Save rules (persist across reboots)
# ============================================================================
echo ""
echo "Saving iptables rules..."

# Save to file
sudo iptables-save | sudo tee /etc/iptables/rules.v4 > /dev/null

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "✓ iptables Configuration Complete!"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Show current rules
sudo iptables -L -v -n --line-numbers

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "Rules saved to: /etc/iptables/rules.v4"
echo ""
echo "To restore on reboot:"
echo "  sudo apt install iptables-persistent"
echo "  # Rules will auto-restore from /etc/iptables/rules.v4"
echo ""
echo "Verification:"
echo "  sudo iptables -L -v -n          # List rules with stats"
echo "  sudo iptables -L INPUT -v -n    # Show INPUT chain only"
echo "  sudo iptables -S                # Show rules as commands"
echo "═══════════════════════════════════════════════════════════════"

# ============================================================================
# IMPORTANT NOTES:
#
# 1. iptables vs UFW:
#    - UFW: Simple, user-friendly wrapper around iptables
#    - iptables: Direct control, more powerful, more complex
#    - DON'T use both! They conflict.
#
# 2. Rule Order Matters:
#    - iptables processes rules top-to-bottom, first match wins
#    - More specific rules MUST come before general rules
#    - Default policy (DROP) applies if no match
#
# 3. Stateful Firewall:
#    - ESTABLISHED,RELATED: allows response packets
#    - Without this, outgoing connections won't work!
#    - Example: Your HTTP request → server response allowed
#
# 4. Rate Limiting:
#    - SSH: 6 attempts per 30 seconds per IP
#    - SYN flood: 1 SYN per second (burst 3)
#    - Prevents brute-force and DDoS
#
# 5. Persistence:
#    - iptables rules are NOT persistent by default
#    - Install iptables-persistent package
#    - Or use systemd service to restore on boot
#
# 6. Debugging:
#    - List rules: sudo iptables -L -v -n
#    - Show counters: sudo iptables -L -v (packets/bytes per rule)
#    - Reset counters: sudo iptables -Z
#    - Watch live: watch -n1 'sudo iptables -L -v -n'
#
# 7. Common Issues:
#    - Locked out of SSH? Boot into recovery, run: iptables -F
#    - Rules not persisting? Install iptables-persistent
#    - UFW conflict? Disable UFW first: sudo ufw disable
#
# ============================================================================


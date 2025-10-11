#!/bin/bash

# ════════════════════════════════════════════════════════════════
# Episode 08: VPN & SSH Tunneling — SOLUTION
# Season 2: Networking (FINAL)
# ════════════════════════════════════════════════════════════════
#
# 🎯 TYPE A EPISODE: Workflow Automation
#
# Философия:
#   - Это Type A: bash АВТОМАТИЗИРУЕТ multi-step workflow
#   - НЕ Type A: bash НЕ ПЕРЕПИСЫВАЕТ существующие инструменты
#
# Что делает скрипт:
#   ✓ USES ssh-keygen (не пишет свой key generator!)
#   ✓ USES wg/wg-quick (не пишет свой VPN!)
#   ✓ AUTOMATES workflow:
#       1. Generate SSH keys × 5 team members
#       2. Create SSH config (координация aliases + keys)
#       3. Generate WireGuard keys × 6 (server + 5 clients)
#       4. Create WireGuard configs × 6 (coordination!)
#       5. Generate audit report (collection)
#
# Почему Type A appropriate здесь:
#   - Multi-step process (5+ steps)
#   - Repetitive tasks (generate keys × 5)
#   - Coordination needed (server config needs client public keys)
#   - NO single tool exists for "setup VPN for team of 5"
#   - Bash fills the gap: orchestration, NOT replacement
#
# Сравнение:
#   Episode 07 (Type B): ufw exists for firewall → use ufw directly
#   Episode 08 (Type A): NO tool for "team VPN setup" → bash workflow
#
# LILITH:
#   "Type A ≠ плохо. Type A = когда bash appropriate для automation.
#    Этот скрипт НЕ пытается быть WireGuard. Он использует wg.
#    Просто автоматизирует 50+ manual commands в один workflow.
#    Smart automation."
#
# ════════════════════════════════════════════════════════════════

set -e

# Global variables
KEYS_DIR="artifacts/ssh_keys"
VPN_DIR="artifacts/wireguard"
REPORT_FILE="artifacts/season2_final_audit.txt"
SSH_CONFIG="artifacts/ssh_config"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Team members
TEAM=("viktor" "alex" "anna" "dmitry" "max")

# VPN network configuration
VPN_NETWORK="10.8.0"
SERVER_PORT=51820
SERVER_ENDPOINT="vpn-zurich.kernel-shadows.com:$SERVER_PORT"
DNS_SERVER="1.1.1.1"

# ════════════════════════════════════════════════════════════════
# Task 1: Generate SSH Keys (ed25519)
# ════════════════════════════════════════════════════════════════

generate_ssh_keys() {
    echo "=== TASK 1: GENERATING SSH KEYS ==="
    echo ""
    
    mkdir -p "$KEYS_DIR"
    
    for member in "${TEAM[@]}"; do
        KEY_FILE="$KEYS_DIR/${member}_key"
        EMAIL="${member}@kernel-shadows.com"
        
        if [ -f "$KEY_FILE" ]; then
            echo "⚠ Key exists: $KEY_FILE (skipping)"
            continue
        fi
        
        echo "Generating key for: $member"
        ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_FILE" -N "" -q
        
        if [ $? -eq 0 ]; then
            echo "✓ Generated: $KEY_FILE"
            
            # Show fingerprint
            FINGERPRINT=$(ssh-keygen -lf "${KEY_FILE}.pub" | awk '{print $2}')
            echo "  Fingerprint: $FINGERPRINT"
        else
            echo "✗ Failed: $member"
        fi
        
        echo ""
    done
    
    echo "✓ SSH keys generated for ${#TEAM[@]} team members"
    ls -lh "$KEYS_DIR"/*.pub
    echo ""
}

# ════════════════════════════════════════════════════════════════
# Task 2: Create SSH Config
# ════════════════════════════════════════════════════════════════

create_ssh_config() {
    echo "=== TASK 2: CREATING SSH CONFIG ==="
    echo ""
    
    cat > "$SSH_CONFIG" << 'EOF'
# SSH Config для KERNEL SHADOWS Operation
# Generated: $TIMESTAMP
# Copy to ~/.ssh/config: cp artifacts/ssh_config ~/.ssh/config

# ═══════════════════════════════════════════════════════════════
# Global Settings
# ═══════════════════════════════════════════════════════════════
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    Compression yes
    ForwardAgent no
    AddKeysToAgent yes
    IdentitiesOnly yes

# ═══════════════════════════════════════════════════════════════
# VPN Gateway (Zürich, Switzerland)
# Neutral territory, strong privacy laws
# ═══════════════════════════════════════════════════════════════
Host vpn-zurich vpn
    HostName 195.14.20.10
    User max
    Port 22
    IdentityFile ~/.ssh/max_key
    ServerAliveInterval 30
    StrictHostKeyChecking ask

# ═══════════════════════════════════════════════════════════════
# Moscow Infrastructure (через VPN для безопасности)
# ═══════════════════════════════════════════════════════════════

# Shadow Server 02 (main operational server)
Host shadow-02 shadow
    HostName 10.50.1.2
    User max
    IdentityFile ~/.ssh/max_key
    ProxyJump vpn-zurich
    LocalForward 8080 localhost:80

# Viktor's coordination server
Host viktor
    HostName 10.50.1.10
    User viktor
    IdentityFile ~/.ssh/viktor_key
    ProxyJump vpn-zurich

# Alex's security server
Host alex
    HostName 10.50.1.11
    User alex
    IdentityFile ~/.ssh/alex_key
    ProxyJump vpn-zurich

# Anna's forensics server
Host anna
    HostName 10.50.1.12
    User anna
    IdentityFile ~/.ssh/anna_key
    ProxyJump vpn-zurich

# Dmitry's DevOps server
Host dmitry
    HostName 10.50.1.13
    User dmitry
    IdentityFile ~/.ssh/dmitry_key
    ProxyJump vpn-zurich

# ═══════════════════════════════════════════════════════════════
# Stockholm (Erik's Bahnhof Pionen datacenter)
# ═══════════════════════════════════════════════════════════════
Host stockholm pionen
    HostName 185.12.64.10
    User max
    Port 22
    IdentityFile ~/.ssh/max_key

# ═══════════════════════════════════════════════════════════════
# Emergency Access (direct, bypass VPN)
# USE ONLY IF VPN IS DOWN!
# ═══════════════════════════════════════════════════════════════
Host shadow-emergency
    HostName shadow-server-02.ops.internal
    User max
    IdentityFile ~/.ssh/max_key
    Port 22
    # WARNING: Krylov может видеть этот трафик!

EOF
    
    # Replace $TIMESTAMP
    sed -i "s/\$TIMESTAMP/$TIMESTAMP/g" "$SSH_CONFIG"
    
    echo "✓ SSH config generated: $SSH_CONFIG"
    echo ""
    echo "To use:"
    echo "  cp $SSH_CONFIG ~/.ssh/config"
    echo "  chmod 600 ~/.ssh/config"
    echo ""
}

# ════════════════════════════════════════════════════════════════
# Task 3: SSH Tunnel Script (Local Forward)
# ════════════════════════════════════════════════════════════════

create_ssh_tunnel() {
    local LOCAL_PORT="$1"
    local REMOTE_HOST="$2"
    local REMOTE_PORT="$3"
    local SSH_SERVER="${4:-shadow-02}"
    
    echo "=== TASK 3: SSH TUNNEL (LOCAL FORWARD) ==="
    echo "localhost:$LOCAL_PORT → $REMOTE_HOST:$REMOTE_PORT (via $SSH_SERVER)"
    echo ""
    
    # Check if port is already in use
    if lsof -Pi :$LOCAL_PORT -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        echo "⚠ Port $LOCAL_PORT is already in use"
        echo "Active process:"
        lsof -Pi :$LOCAL_PORT -sTCP:LISTEN
        return 1
    fi
    
    echo "Starting tunnel..."
    echo "Command: ssh -L $LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT -N -f $SSH_SERVER"
    
    # Note: This would actually create a tunnel if SSH server is accessible
    # For demonstration, we create a placeholder
    
    echo "✓ Tunnel configured (would start with: ssh -L ...)"
    echo "  Access: http://localhost:$LOCAL_PORT"
    echo ""
    echo "To stop: kill \$(pgrep -f 'ssh -L $LOCAL_PORT')"
    echo ""
}

# ════════════════════════════════════════════════════════════════
# Task 4: SOCKS Proxy (Dynamic Forward)
# ════════════════════════════════════════════════════════════════

create_socks_proxy() {
    local SOCKS_PORT="${1:-1080}"
    local SSH_SERVER="${2:-vpn-zurich}"
    
    echo "=== TASK 4: SOCKS PROXY (DYNAMIC FORWARD) ==="
    echo "Port: $SOCKS_PORT"
    echo "Server: $SSH_SERVER"
    echo ""
    
    # Check if port is in use
    if lsof -Pi :$SOCKS_PORT -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        echo "⚠ Port $SOCKS_PORT is already in use"
        return 1
    fi
    
    echo "Command: ssh -D $SOCKS_PORT -N -f $SSH_SERVER"
    echo ""
    
    echo "✓ SOCKS proxy configured"
    echo ""
    echo "Browser configuration:"
    echo "  Proxy type: SOCKS5"
    echo "  Proxy host: localhost"
    echo "  Proxy port: $SOCKS_PORT"
    echo "  ✓ Enable 'Proxy DNS when using SOCKS v5'"
    echo ""
    echo "Test with curl:"
    echo "  curl --socks5 localhost:$SOCKS_PORT http://ifconfig.me"
    echo ""
}

# ════════════════════════════════════════════════════════════════
# Task 5: Generate WireGuard Configurations
# ════════════════════════════════════════════════════════════════

generate_wireguard_configs() {
    echo "=== TASK 5: WIREGUARD VPN CONFIGURATION ==="
    echo ""
    
    mkdir -p "$VPN_DIR"
    
    # Generate server keys
    if [ ! -f "$VPN_DIR/server_private.key" ]; then
        echo "[SERVER] Generating keys..."
        wg genkey | tee "$VPN_DIR/server_private.key" | wg pubkey > "$VPN_DIR/server_public.key" 2>/dev/null || true
        chmod 600 "$VPN_DIR/server_private.key" 2>/dev/null || true
        echo "✓ Server keys generated"
    fi
    
    SERVER_PRIVATE=$(cat "$VPN_DIR/server_private.key" 2>/dev/null || echo "SERVER_PRIVATE_KEY_HERE")
    SERVER_PUBLIC=$(cat "$VPN_DIR/server_public.key" 2>/dev/null || echo "SERVER_PUBLIC_KEY_HERE")
    
    # Generate client keys
    declare -A CLIENT_PUBLIC
    IP_INDEX=2
    
    for member in "${TEAM[@]}"; do
        if [ ! -f "$VPN_DIR/${member}_private.key" ]; then
            echo "[$member] Generating keys..."
            wg genkey | tee "$VPN_DIR/${member}_private.key" | wg pubkey > "$VPN_DIR/${member}_public.key" 2>/dev/null || true
            chmod 600 "$VPN_DIR/${member}_private.key" 2>/dev/null || true
        fi
        
        CLIENT_PUBLIC[$member]=$(cat "$VPN_DIR/${member}_public.key" 2>/dev/null || echo "${member^^}_PUBLIC_KEY")
        echo "✓ $member keys ready"
    done
    
    echo ""
    echo "Generating configs..."
    echo ""
    
    # Generate server config
    cat > "$VPN_DIR/server_wg0.conf" << EOF
# WireGuard Server Config
# Location: Zürich, Switzerland
# Generated: $TIMESTAMP

[Interface]
# Server address in VPN network
Address = ${VPN_NETWORK}.1/24

# Server private key
PrivateKey = $SERVER_PRIVATE

# Listening port
ListenPort = $SERVER_PORT

# Enable IP forwarding and NAT
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# Team members (peers)
EOF
    
    # Add peers to server config
    IP_INDEX=2
    for member in "${TEAM[@]}"; do
        cat >> "$VPN_DIR/server_wg0.conf" << EOF

[Peer]
# $member
PublicKey = ${CLIENT_PUBLIC[$member]}
AllowedIPs = ${VPN_NETWORK}.${IP_INDEX}/32
EOF
        IP_INDEX=$((IP_INDEX + 1))
    done
    
    echo "✓ Server config: $VPN_DIR/server_wg0.conf"
    
    # Generate client configs
    IP_INDEX=2
    for member in "${TEAM[@]}"; do
        MEMBER_PRIVATE=$(cat "$VPN_DIR/${member}_private.key" 2>/dev/null || echo "${member^^}_PRIVATE_KEY")
        MEMBER_IP="${VPN_NETWORK}.${IP_INDEX}"
        
        cat > "$VPN_DIR/${member}.conf" << EOF
# WireGuard Client Config
# User: $member
# Generated: $TIMESTAMP

[Interface]
# Client address in VPN network
Address = ${MEMBER_IP}/24

# Client private key
PrivateKey = $MEMBER_PRIVATE

# DNS through VPN
DNS = $DNS_SERVER

[Peer]
# VPN Server (Zürich)
PublicKey = $SERVER_PUBLIC

# Server endpoint
Endpoint = $SERVER_ENDPOINT

# Route all traffic through VPN
AllowedIPs = 0.0.0.0/0, ::/0

# Keep alive for NAT traversal
PersistentKeepalive = 25
EOF
        
        echo "✓ Client config: $VPN_DIR/${member}.conf"
        IP_INDEX=$((IP_INDEX + 1))
    done
    
    echo ""
    echo "✓ WireGuard configs generated!"
    echo ""
}

# ════════════════════════════════════════════════════════════════
# Task 6: VPN Monitoring
# ════════════════════════════════════════════════════════════════

monitor_vpn() {
    echo "=== TASK 6: VPN MONITORING ==="
    echo ""
    
    INTERFACE="wg0"
    
    # Check if VPN interface exists
    if ! ip link show $INTERFACE &>/dev/null; then
        echo "⚠ VPN interface $INTERFACE not found"
        echo "Note: VPN monitoring would work when interface is up"
        echo ""
        echo "Commands that would be used:"
        echo "  sudo wg show"
        echo "  sudo wg show wg0 transfer"
        echo "  ip route | grep wg0"
        echo ""
        return 1
    fi
    
    echo "✓ VPN interface $INTERFACE is UP"
    echo ""
    
    # Show peers (would run if wg is installed)
    echo "WireGuard status:"
    echo "  Command: sudo wg show"
    echo ""
    
    # Connectivity test
    VPN_GATEWAY="${VPN_NETWORK}.1"
    echo "VPN gateway: $VPN_GATEWAY"
    echo "  Test: ping -c 1 $VPN_GATEWAY"
    echo ""
    
    echo "✓ Monitoring commands ready"
    echo ""
}

# ════════════════════════════════════════════════════════════════
# Task 7: Security Tests (IP & DNS Leak)
# ════════════════════════════════════════════════════════════════

test_vpn_security() {
    echo "=== TASK 7: VPN SECURITY TESTS ==="
    echo ""
    
    # Test 1: Public IP check
    echo "[1] Public IP test:"
    echo "  Command: curl http://ifconfig.me"
    PUBLIC_IP=$(curl -s --max-time 3 http://ifconfig.me 2>/dev/null || echo "N/A")
    if [ "$PUBLIC_IP" != "N/A" ]; then
        echo "  Your IP: $PUBLIC_IP"
        echo "  Expected: VPN server IP (Zürich)"
    else
        echo "  (Would show your public IP)"
    fi
    echo ""
    
    # Test 2: DNS leak check
    echo "[2] DNS leak test:"
    echo "  Command: cat /etc/resolv.conf"
    if [ -f /etc/resolv.conf ]; then
        echo "  Current DNS:"
        grep nameserver /etc/resolv.conf | head -3
        echo "  Expected: 1.1.1.1 or VPN server DNS"
    else
        echo "  (Would show current DNS servers)"
    fi
    echo ""
    
    # Test 3: Online leak test
    echo "[3] Comprehensive test:"
    echo "  Visit: https://dnsleaktest.com/"
    echo "  Visit: https://ipleak.net/"
    echo ""
    
    echo "✓ Security test commands ready"
    echo ""
}

# ════════════════════════════════════════════════════════════════
# Task 8: Final Security Audit Report
# ════════════════════════════════════════════════════════════════

generate_final_report() {
    echo "=== TASK 8: GENERATING FINAL SECURITY AUDIT ==="
    echo ""
    
    cat > "$REPORT_FILE" << 'EOFAUDIT'
╔═══════════════════════════════════════════════════════════════╗
║         SEASON 2: NETWORKING — FINAL SECURITY AUDIT          ║
║         Episode 08: VPN & SSH Tunneling                      ║
╚═══════════════════════════════════════════════════════════════╝

Date:       $TIMESTAMP
Location:   Moscow, Russia 🇷🇺
Operator:   Max Sokolov
Duration:   16 days (Episode 05-08)
Status:     ✓ SEASON 2 COMPLETE

════════════════════════════════════════════════════════════════
[1] MISSION SUMMARY
════════════════════════════════════════════════════════════════

Objective: Build secure network infrastructure for KERNEL SHADOWS
          operation under threat from Polkovnik Krylov (FSB).

Challenges Faced:
  ✓ DDoS attack (50K pps, 847 botnet IPs) — MITIGATED
  ✓ DNS spoofing attempts — DETECTED & BLOCKED
  ✓ Deep Packet Inspection (DPI) — ENCRYPTED
  ✓ Traffic interception — PROTECTED (VPN)

Result: SUCCESSFUL
  - All communications encrypted (ChaCha20-Poly1305)
  - VPN operational (WireGuard, Zürich server)
  - SSH key-based authentication (ed25519)
  - Zero successful intrusions

════════════════════════════════════════════════════════════════
[2] INFRASTRUCTURE DEPLOYED
════════════════════════════════════════════════════════════════

Network Configuration:
  ✓ TCP/IP fundamentals implemented (Episode 05)
  ✓ DNS secured (DNSSEC, DoT) (Episode 06)
  ✓ Firewall deployed (UFW + iptables) (Episode 07)
  ✓ VPN established (WireGuard) (Episode 08)

Security Layers:
  1. Firewall (Layer 3-4)
     - Default deny policy
     - Rate limiting (20 conn/IP)
     - Botnet IP blocking (847 IPs)
     
  2. VPN (Layer 3)
     - WireGuard (Curve25519 + ChaCha20)
     - Server: Zürich, Switzerland (neutral)
     - Clients: 5 team members
     
  3. SSH (Layer 7)
     - Key-based authentication (ed25519)
     - Tunneling capabilities
     - SOCKS proxy ready

════════════════════════════════════════════════════════════════
[3] SECURITY METRICS
════════════════════════════════════════════════════════════════

Episode 05: TCP/IP Fundamentals
  - Network audit: 12 servers scanned
  - Ports analyzed: 65,535 range
  - Services identified: SSH, HTTP, HTTPS, PostgreSQL

Episode 06: DNS & Name Resolution
  - Internal domains: 15 (not in public DNS ✓)
  - DNS spoofing attempts: 0 successful
  - DNSSEC enabled: 100%

Episode 07: Firewalls & iptables
  - DDoS attack mitigated: 20 minutes
  - Load Average: 47.82 → 1.92
  - IPs blocked: 847 (botnet)
  - Rate limiting: 20 conn/IP

Episode 08: VPN & SSH Tunneling
  - SSH keys generated: 5 (ed25519)
  - VPN clients: 5 (team members)
  - VPN uptime: 99.9%
  - Encryption: ChaCha20-Poly1305 (256-bit)
  - DNS leaks: 0

════════════════════════════════════════════════════════════════
[4] SKILLS ACQUIRED
════════════════════════════════════════════════════════════════

Technical Skills (Max Sokolov):
  ✓ TCP/IP model, IP addressing & subnetting
  ✓ DNS (dig, DNSSEC, DoT)
  ✓ Firewall (UFW, iptables, rate limiting)
  ✓ VPN (WireGuard configuration)
  ✓ SSH (keys, config, tunneling, SOCKS proxy)
  ✓ Incident response (under pressure)
  ✓ Security audit & documentation

Soft Skills:
  ✓ Work under pressure (5-minute deadline)
  ✓ Team collaboration (5 members)
  ✓ Decision making (under uncertainty)

Character Development:
  ✓ Confidence (junior → competent)
  ✓ Trust building with team
  ✓ International experience (Stockholm 🇸🇪)

════════════════════════════════════════════════════════════════
[5] SECURITY POSTURE
════════════════════════════════════════════════════════════════

Before Season 2:
  ⚠️ No firewall
  ⚠️ Unencrypted communications
  ⚠️ Password-based SSH
  Status: VULNERABLE

After Season 2:
  ✓ Multi-layer firewall
  ✓ End-to-end encryption (VPN)
  ✓ Key-based authentication
  ✓ DDoS mitigation
  Status: HARDENED

Risk Level: CRITICAL → MEDIUM

════════════════════════════════════════════════════════════════
[6] NEXT STEPS (Season 3 Preview)
════════════════════════════════════════════════════════════════

Location: Санкт-Петербург → Таллин 🇪🇪 (Days 17-24)
Theme:    System Administration

Upcoming:
  - User management (sudo, permissions)
  - Process management (systemd, cron)
  - Log analysis (rsyslog, journald)
  - Backup & recovery
  - Performance tuning

New Threat: "Новая Эра" organization surfaces
New Allies: Andrei Volkov, Kristjan Tamm, Liisa Kask

════════════════════════════════════════════════════════════════
[7] FINAL ASSESSMENT
════════════════════════════════════════════════════════════════

Season 2 Objectives: ✓ ACHIEVED

Technical Implementation: 95/100
Team Collaboration: 98/100
Crisis Management: 100/100
Documentation: 90/100

Overall Season 2 Grade: A+ (96/100)

════════════════════════════════════════════════════════════════
SEASON 2: NETWORKING — COMPLETE ✓
════════════════════════════════════════════════════════════════

"In cryptography we trust. In firewall we verify."
  — Alex Sokolov

Stay vigilant. Krylov is not defeated, only delayed.

════════════════════════════════════════════════════════════════
END OF SEASON 2 AUDIT REPORT
════════════════════════════════════════════════════════════════
EOFAUDIT
    
    # Replace timestamp
    sed -i "s/\$TIMESTAMP/$TIMESTAMP/g" "$REPORT_FILE"
    
    echo "✓ Final audit report generated: $REPORT_FILE"
    echo ""
}

# ════════════════════════════════════════════════════════════════
# Main Function
# ════════════════════════════════════════════════════════════════

main() {
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║         Episode 08: VPN & SSH Tunneling                  ║"
    echo "║         Season 2: Networking (FINAL)                     ║"
    echo "║         SOLUTION SCRIPT                                  ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    echo "Starting comprehensive VPN & SSH setup..."
    echo "Timestamp: $TIMESTAMP"
    echo ""
    
    # Execute all tasks
    generate_ssh_keys
    create_ssh_config
    
    # SSH Tunneling examples
    create_ssh_tunnel 3000 localhost 3000 shadow-02
    create_socks_proxy 1080 vpn-zurich
    
    generate_wireguard_configs
    monitor_vpn
    test_vpn_security
    generate_final_report
    
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║         SEASON 2: NETWORKING — COMPLETE! ✓               ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    echo "✓ All tasks completed successfully!"
    echo ""
    echo "Generated files:"
    echo "  - $KEYS_DIR/*.key (SSH keys)"
    echo "  - $SSH_CONFIG (SSH config)"
    echo "  - $VPN_DIR/*.conf (WireGuard configs)"
    echo "  - $REPORT_FILE (Final audit)"
    echo ""
    echo "Installation:"
    echo "  1. SSH config: cp $SSH_CONFIG ~/.ssh/config"
    echo "  2. SSH keys: cp $KEYS_DIR/*.key ~/.ssh/"
    echo "  3. VPN server: sudo cp $VPN_DIR/server_wg0.conf /etc/wireguard/wg0.conf"
    echo "  4. VPN start: sudo wg-quick up wg0"
    echo ""
    echo "Season 2 Statistics:"
    echo "  Episodes completed: 4/4"
    echo "  Duration: 16 days"
    echo "  Progress: 26.7% (16/60 days)"
    echo "  Grade: A+ (96/100)"
    echo ""
    echo "Next: Season 3 — System Administration"
    echo "      Санкт-Петербург → Таллин 🇪🇪"
    echo "      Days 17-24"
    echo ""
    echo "Thank you for completing Season 2!"
    echo ""
}

main "$@"

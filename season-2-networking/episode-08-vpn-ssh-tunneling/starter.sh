#!/bin/bash

# ════════════════════════════════════════════════════════════════
# Episode 08: VPN & SSH Tunneling
# Season 2: Networking (FINAL)
# ════════════════════════════════════════════════════════════════

set -e

# Global variables
KEYS_DIR="artifacts/ssh_keys"
VPN_DIR="artifacts/wireguard"
REPORT_FILE="artifacts/vpn_security_report.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Team members
TEAM=("viktor" "alex" "anna" "dmitry" "max")

# VPN network configuration
VPN_NETWORK="10.8.0"
SERVER_PORT=51820
SERVER_ENDPOINT="vpn-zurich.kernel-shadows.com:$SERVER_PORT"

# ════════════════════════════════════════════════════════════════
# Task 1: Generate SSH Keys (ed25519)
# ════════════════════════════════════════════════════════════════

generate_ssh_keys() {
    echo "=== TASK 1: GENERATING SSH KEYS ==="
    echo ""
    
    # TODO: Create keys directory
    # Hint: mkdir -p
    
    # TODO: Loop through TEAM members
    # TODO: Generate ed25519 key for each member
    # TODO: Use format: ${member}_key
    # TODO: Email: ${member}@kernel-shadows.com
    # TODO: No passphrase for automation (-N "")
    
    # Example:
    # ssh-keygen -t ed25519 -C "email" -f "keyfile" -N ""
    
    echo "TODO: Implement SSH key generation"
    # Your code here
}

# ════════════════════════════════════════════════════════════════
# Task 2: Create SSH Config
# ════════════════════════════════════════════════════════════════

create_ssh_config() {
    echo ""
    echo "=== TASK 2: CREATING SSH CONFIG ==="
    echo ""
    
    # TODO: Create artifacts/ssh_config file
    # TODO: Add global settings (ServerAliveInterval, Compression)
    # TODO: Add VPN server entry (vpn-zurich)
    # TODO: Add team member servers (through ProxyJump)
    
    # Example format:
    # Host vpn-zurich
    #     HostName 195.14.20.10
    #     User max
    #     IdentityFile ~/.ssh/max_key
    
    echo "TODO: Implement SSH config generation"
    # Your code here
}

# ════════════════════════════════════════════════════════════════
# Task 3: SSH Tunnel Script (Local Forward)
# ════════════════════════════════════════════════════════════════

create_ssh_tunnel() {
    local LOCAL_PORT="$1"
    local REMOTE_HOST="$2"
    local REMOTE_PORT="$3"
    local SSH_SERVER="${4:-shadow-02}"
    
    echo ""
    echo "=== TASK 3: SSH TUNNEL (LOCAL FORWARD) ==="
    echo "localhost:$LOCAL_PORT → $REMOTE_HOST:$REMOTE_PORT (via $SSH_SERVER)"
    echo ""
    
    # TODO: Check if port is already in use
    # Hint: lsof -Pi :$LOCAL_PORT
    
    # TODO: Create SSH tunnel
    # Format: ssh -L local_port:remote_host:remote_port server
    # Add -N flag (no commands)
    # Add -f flag (background)
    
    # TODO: Save PID to /tmp/ssh_tunnel_${LOCAL_PORT}.pid
    
    echo "TODO: Implement SSH local forward tunnel"
    # Your code here
}

# ════════════════════════════════════════════════════════════════
# Task 4: SOCKS Proxy (Dynamic Forward)
# ════════════════════════════════════════════════════════════════

create_socks_proxy() {
    local SOCKS_PORT="${1:-1080}"
    local SSH_SERVER="${2:-vpn-zurich}"
    
    echo ""
    echo "=== TASK 4: SOCKS PROXY (DYNAMIC FORWARD) ==="
    echo "Port: $SOCKS_PORT"
    echo "Server: $SSH_SERVER"
    echo ""
    
    # TODO: Check if port is in use
    
    # TODO: Create SOCKS proxy
    # Format: ssh -D port -N -f server
    
    # TODO: Save PID to /tmp/socks_proxy_${SOCKS_PORT}.pid
    
    # TODO: Print configuration instructions for browser
    
    echo "TODO: Implement SOCKS proxy"
    # Your code here
}

# ════════════════════════════════════════════════════════════════
# Task 5: Generate WireGuard Configurations
# ════════════════════════════════════════════════════════════════

generate_wireguard_configs() {
    echo ""
    echo "=== TASK 5: WIREGUARD VPN CONFIGURATION ==="
    echo ""
    
    # TODO: Create VPN directory
    # mkdir -p "$VPN_DIR"
    
    # TODO: Generate server keys
    # wg genkey | tee privatekey | wg pubkey > publickey
    
    # TODO: Generate client keys for each team member
    
    # TODO: Create server config (server_wg0.conf)
    # Include:
    #   [Interface] section (Address, PrivateKey, ListenPort)
    #   PostUp/PostDown iptables rules (NAT)
    #   [Peer] sections for each client
    
    # TODO: Create client configs for each team member
    # Include:
    #   [Interface] section (Address, PrivateKey, DNS)
    #   [Peer] section (server PublicKey, Endpoint, AllowedIPs)
    
    echo "TODO: Implement WireGuard config generation"
    # Your code here
}

# ════════════════════════════════════════════════════════════════
# Task 6: VPN Monitoring
# ════════════════════════════════════════════════════════════════

monitor_vpn() {
    echo ""
    echo "=== TASK 6: VPN MONITORING ==="
    echo ""
    
    # TODO: Check if wg0 interface exists
    # Hint: ip link show wg0
    
    # TODO: Show WireGuard status
    # Hint: sudo wg show
    
    # TODO: Parse and display peer information:
    #   - Public key (truncated)
    #   - Allowed IPs
    #   - Latest handshake
    #   - Transfer (RX/TX)
    
    # TODO: Check connectivity to VPN gateway
    # Hint: ping -c 1 VPN_GATEWAY_IP
    
    echo "TODO: Implement VPN monitoring"
    # Your code here
}

# ════════════════════════════════════════════════════════════════
# Task 7: Security Tests (IP & DNS Leak)
# ════════════════════════════════════════════════════════════════

test_vpn_security() {
    echo ""
    echo "=== TASK 7: VPN SECURITY TESTS ==="
    echo ""
    
    # TODO: Test 1 — Public IP check
    # Hint: curl http://ifconfig.me
    # Should show VPN server IP, not your real IP
    
    # TODO: Test 2 — DNS leak check
    # Hint: cat /etc/resolv.conf
    # Should show VPN DNS (1.1.1.1 or VPN server)
    
    # TODO: Test 3 — DNS resolution test
    # Hint: dig @1.1.1.1 kernel-shadows.com
    
    echo "TODO: Implement security tests"
    # Your code here
}

# ════════════════════════════════════════════════════════════════
# Task 8: Final Security Audit Report
# ════════════════════════════════════════════════════════════════

generate_final_report() {
    echo ""
    echo "=== TASK 8: GENERATING FINAL SECURITY AUDIT ==="
    echo ""
    
    # TODO: Create comprehensive security audit report
    # Include:
    #   1. Mission summary
    #   2. Infrastructure deployed
    #   3. Threat analysis (Krylov)
    #   4. Security metrics (all episodes)
    #   5. Skills acquired
    #   6. Lessons learned
    #   7. Security posture (before/after)
    #   8. Team status
    #   9. Next steps (Season 3 preview)
    #   10. Final assessment
    
    # Format: Professional report with sections
    # Save to: $REPORT_FILE
    
    echo "TODO: Implement final audit report generation"
    # Your code here
}

# ════════════════════════════════════════════════════════════════
# Main Function
# ════════════════════════════════════════════════════════════════

main() {
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║         Episode 08: VPN & SSH Tunneling                  ║"
    echo "║         Season 2: Networking (FINAL)                     ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    echo "Starting VPN & SSH setup..."
    echo "Timestamp: $TIMESTAMP"
    echo ""
    
    # Execute tasks
    generate_ssh_keys
    create_ssh_config
    
    # SSH Tunneling examples (uncomment when implemented)
    # create_ssh_tunnel 3000 localhost 3000 shadow-02
    # create_socks_proxy 1080 vpn-zurich
    
    generate_wireguard_configs
    
    # Monitoring (requires VPN to be running)
    # monitor_vpn
    # test_vpn_security
    
    generate_final_report
    
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║         SEASON 2: NETWORKING — COMPLETE! ✓               ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    echo "✓ SSH keys generated"
    echo "✓ SSH config created"
    echo "✓ WireGuard configs ready"
    echo "✓ Final audit report generated"
    echo ""
    echo "Next steps:"
    echo "  1. Review report: $REPORT_FILE"
    echo "  2. Install configs:"
    echo "     cp artifacts/ssh_config ~/.ssh/config"
    echo "     chmod 600 ~/.ssh/config"
    echo "  3. Deploy VPN:"
    echo "     sudo cp $VPN_DIR/server_wg0.conf /etc/wireguard/wg0.conf"
    echo "     sudo wg-quick up wg0"
    echo ""
    echo "Season 3: System Administration (Coming Soon)"
    echo "Location: Санкт-Петербург → Таллин 🇪🇪"
    echo ""
}

main "$@"

#!/bin/bash

# Episode 07: Firewalls & iptables
# Student template script
# Fill in the TODO sections

set -e

# Global variables
REPORT_FILE="artifacts/firewall_audit_report.txt"
BOTNET_FILE="artifacts/botnet_ips.txt"
BLOCKED_LOG="artifacts/blocked_ips.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# ═════════════════════════════════════════════════════════════
# Function 1: Check firewall status (Task 1)
# ═════════════════════════════════════════════════════════════
check_firewall_status() {
    echo "=== TASK 1: Checking Firewall Status ==="
    echo ""
    
    # TODO: Check UFW status
    # Hint: sudo ufw status verbose
    
    echo "UFW Status: (TODO)"
    echo ""
    
    # TODO: Check iptables rules
    # Hint: sudo iptables -L -n -v
    
    echo "iptables rules: (TODO)"
    echo ""
    
    # TODO: Check SYN_RECV connections (SYN flood indicator)
    # Hint: netstat -an | grep SYN_RECV | wc -l
    
    local syn_count=0  # TODO: Replace with actual count
    echo "SYN_RECV connections: $syn_count"
    echo ""
    
    if [ "$syn_count" -gt 100 ]; then
        echo -e "${RED}⚠ WARNING: Possible SYN flood attack!${NC}"
    else
        echo -e "${GREEN}✓ Normal SYN_RECV count${NC}"
    fi
    
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 2: Enable UFW safely (Task 2)
# ═════════════════════════════════════════════════════════════
enable_ufw_safely() {
    echo "=== TASK 2: Enabling UFW (Safely) ==="
    echo ""
    
    # TODO: Set default policies
    # Hint: sudo ufw default deny incoming
    #       sudo ufw default allow outgoing
    
    echo "[1] Setting default policies..."
    # YOUR CODE HERE
    echo "✓ Default policies set (TODO)"
    echo ""
    
    # TODO: Allow SSH (CRITICAL! Do this BEFORE enabling UFW)
    # Hint: sudo ufw allow 22/tcp comment 'SSH access'
    
    echo "[2] Allowing SSH..."
    # YOUR CODE HERE
    echo "✓ SSH allowed (TODO)"
    echo ""
    
    # TODO: Enable UFW
    # Hint: echo "y" | sudo ufw enable (auto-yes)
    
    echo "[3] Enabling UFW..."
    # YOUR CODE HERE
    echo "✓ UFW enabled (TODO)"
    echo ""
    
    # TODO: Verify status
    # Hint: sudo ufw status verbose
    
    echo "[4] Current status:"
    # YOUR CODE HERE
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 3: Allow web traffic (Task 3)
# ═════════════════════════════════════════════════════════════
allow_web_traffic() {
    echo "=== TASK 3: Allowing Web Traffic ==="
    echo ""
    
    # TODO: Allow HTTP (port 80)
    # Hint: sudo ufw allow 80/tcp comment 'HTTP'
    
    echo "[1] Allowing HTTP..."
    # YOUR CODE HERE
    echo "✓ HTTP allowed (TODO)"
    echo ""
    
    # TODO: Allow HTTPS (port 443)
    # Hint: sudo ufw allow 443/tcp comment 'HTTPS'
    
    echo "[2] Allowing HTTPS..."
    # YOUR CODE HERE
    echo "✓ HTTPS allowed (TODO)"
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 4: Block botnet IPs (Task 4)
# ═════════════════════════════════════════════════════════════
block_botnet_ips() {
    echo "=== TASK 4: Blocking Botnet IPs ==="
    echo ""
    
    # Check if botnet file exists
    if [[ ! -f "$BOTNET_FILE" ]]; then
        echo -e "${RED}✗ Error: $BOTNET_FILE not found!${NC}"
        return 1
    fi
    
    # Initialize log
    echo "Blocked IPs - $TIMESTAMP" > "$BLOCKED_LOG"
    
    local blocked_count=0
    
    # TODO: Read botnet_ips.txt and block each IP
    # Hint: Use while loop with iptables
    # while IFS= read -r ip; do
    #     [[ -z "$ip" || "$ip" =~ ^# ]] && continue
    #     sudo iptables -I INPUT -s "$ip" -j DROP
    #     blocked_count=$((blocked_count + 1))
    # done < "$BOTNET_FILE"
    
    echo "Blocking IPs from $BOTNET_FILE..."
    # YOUR CODE HERE
    
    echo ""
    echo "✓ Blocked $blocked_count IPs (TODO)"
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 5: Configure rate limiting (Task 5)
# ═════════════════════════════════════════════════════════════
configure_rate_limiting() {
    echo "=== TASK 5: Configuring Rate Limiting ==="
    echo ""
    
    # TODO: Limit simultaneous connections per IP
    # Hint: sudo iptables -A INPUT -p tcp --syn -m connlimit \
    #           --connlimit-above 20 -j REJECT
    
    echo "[1] Limiting simultaneous connections..."
    # YOUR CODE HERE
    echo "✓ Max 20 connections per IP (TODO)"
    echo ""
    
    # TODO: SSH brute-force protection
    # Hint: Use -m recent module
    # iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
    # iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 5 -j DROP
    
    echo "[2] SSH brute-force protection..."
    # YOUR CODE HERE
    echo "✓ Max 4 SSH attempts per minute (TODO)"
    echo ""
    
    # TODO: HTTP/HTTPS rate limiting
    # Hint: Use -m hashlimit
    # iptables -A INPUT -p tcp --dport 80 -m hashlimit \
    #     --hashlimit-above 50/sec --hashlimit-mode srcip -j DROP
    
    echo "[3] HTTP/HTTPS rate limiting..."
    # YOUR CODE HERE
    echo "✓ Max 50 requests/sec per IP (TODO)"
    echo ""
    
    # TODO: ICMP flood protection
    # Hint: iptables -A INPUT -p icmp -m limit --limit 5/sec -j ACCEPT
    #       iptables -A INPUT -p icmp -j DROP
    
    echo "[4] ICMP flood protection..."
    # YOUR CODE HERE
    echo "✓ Max 5 pings/sec (TODO)"
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 6: Configure logging (Task 6)
# ═════════════════════════════════════════════════════════════
configure_logging() {
    echo "=== TASK 6: Configuring Attack Logging ==="
    echo ""
    
    # TODO: Log SSH brute-force attempts
    # Hint: iptables -A INPUT -p tcp --dport 22 -m recent --rcheck \
    #           -j LOG --log-prefix '[SSH BRUTEFORCE] '
    
    echo "[1] SSH brute-force logging..."
    # YOUR CODE HERE
    echo "✓ SSH attack logging enabled (TODO)"
    echo ""
    
    # TODO: Log SYN flood attempts
    # Hint: iptables -A INPUT -p tcp --syn -m connlimit --connlimit-above 20 \
    #           -m limit --limit 2/min -j LOG --log-prefix '[SYN FLOOD] '
    
    echo "[2] SYN flood logging..."
    # YOUR CODE HERE
    echo "✓ SYN flood logging enabled (TODO)"
    echo ""
    
    # TODO: Configure rsyslog for firewall logs
    # Hint: Create /etc/rsyslog.d/10-firewall.conf
    #       :msg, contains, "[FIREWALL" /var/log/firewall.log
    
    echo "[3] Configuring rsyslog..."
    # YOUR CODE HERE
    echo "✓ Firewall logs → /var/log/firewall.log (TODO)"
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 7: Monitor firewall (Task 7)
# ═════════════════════════════════════════════════════════════
monitor_firewall() {
    echo "=== TASK 7: Firewall Monitoring ==="
    echo ""
    
    # TODO: Get current load average
    # Hint: uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1
    
    local load="0.00"  # TODO: Replace with actual load
    echo "[1] Server Load:        $load"
    echo ""
    
    # TODO: Get SYN_RECV count
    # Hint: netstat -an | grep SYN_RECV | wc -l
    
    local syn_count=0  # TODO: Replace with actual count
    echo "[2] SYN_RECV connections: $syn_count"
    echo ""
    
    # TODO: Get blocked packets count
    # Hint: sudo iptables -L INPUT -n -v | grep DROP | awk '{sum+=$1} END {print sum}'
    
    local blocked_packets=0  # TODO: Replace with actual count
    echo "[3] Blocked packets:      $blocked_packets"
    echo ""
    
    # TODO: Show top attacking IPs
    # Hint: netstat -an | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -5
    
    echo "[4] Top attacking IPs:"
    # YOUR CODE HERE
    echo "(TODO)"
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 8: Generate audit report (Task 8)
# ═════════════════════════════════════════════════════════════
generate_audit_report() {
    echo "=== TASK 8: Generating Security Audit Report ==="
    echo ""
    
    # TODO: Create comprehensive audit report
    # Should include:
    # - Incident summary (start time, end time, attack type)
    # - Firewall configuration (UFW + iptables)
    # - Blocked IPs statistics
    # - Current system status (load, connections, memory, CPU)
    # - Attack logs analysis
    # - Security measures implemented
    # - Recommendations
    
    {
        echo "╔═══════════════════════════════════════════════════════════╗"
        echo "║         FIREWALL SECURITY AUDIT REPORT                   ║"
        echo "╚═══════════════════════════════════════════════════════════╝"
        echo ""
        echo "Date:     $TIMESTAMP"
        echo "Operator: Max Sokolov"
        echo ""
        
        # TODO: Add report sections here
        # Section 1: Incident Summary
        # Section 2: Firewall Configuration
        # Section 3: Blocked IPs Statistics
        # Section 4: Current System Status
        # Section 5: Security Assessment
        # Section 6: Recommendations
        
        echo "TODO: Complete the report sections"
        echo ""
        echo "END OF REPORT"
        
    } > "$REPORT_FILE"
    
    echo "✓ Report generated: $REPORT_FILE"
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Main function
# ═════════════════════════════════════════════════════════════
main() {
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║  Episode 07: Firewalls & iptables                        ║"
    echo "║  DDoS Attack Response - Emergency Mode                   ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    echo "Time: $TIMESTAMP"
    echo "Location: ЦОД 'Москва-1', Серверная A-12"
    echo "Status: 🔴 UNDER ATTACK"
    echo ""
    echo "───────────────────────────────────────────────────────────"
    echo ""
    
    # Execute tasks in sequence
    check_firewall_status
    
    read -p "Press Enter to continue to Task 2 (Enable UFW)..." 
    enable_ufw_safely
    
    read -p "Press Enter to continue to Task 3 (Allow Web Traffic)..."
    allow_web_traffic
    
    read -p "Press Enter to continue to Task 4 (Block Botnet IPs)..."
    block_botnet_ips
    
    read -p "Press Enter to continue to Task 5 (Rate Limiting)..."
    configure_rate_limiting
    
    read -p "Press Enter to continue to Task 6 (Logging)..."
    configure_logging
    
    read -p "Press Enter to continue to Task 7 (Monitoring)..."
    monitor_firewall
    
    read -p "Press Enter to continue to Task 8 (Audit Report)..."
    generate_audit_report
    
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "FIREWALL SETUP COMPLETE"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "Next steps:"
    echo "  1. Review the audit report: cat $REPORT_FILE"
    echo "  2. Monitor logs: sudo tail -f /var/log/firewall.log"
    echo "  3. Check if attack stopped: watch 'uptime && netstat -an | grep SYN_RECV | wc -l'"
    echo ""
    echo "✓ Episode 07 tasks completed (check TODO sections)"
}

# Run main function
main "$@"

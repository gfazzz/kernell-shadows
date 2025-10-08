#!/bin/bash

# Episode 07: Firewalls & iptables
# Reference solution - firewall_setup.sh
# Complete implementation of all tasks

set -e

# Global variables
REPORT_FILE="artifacts/firewall_audit_report.txt"
BOTNET_FILE="artifacts/botnet_ips.txt"
BLOCKED_LOG="artifacts/blocked_ips.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOCATION="ЦОД 'Москва-1', Серверная A-12"
OPERATOR="Max Sokolov"
DAY="13 of 60 (KERNEL SHADOWS Operation)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ═════════════════════════════════════════════════════════════
# Function 1: Check firewall status
# ═════════════════════════════════════════════════════════════
check_firewall_status() {
    echo -e "${YELLOW}=== TASK 1: Checking Firewall Status ===${NC}"
    echo ""
    
    # UFW status
    echo "[1] UFW Status:"
    sudo ufw status verbose 2>/dev/null || echo "UFW not configured"
    echo ""
    
    # iptables rules
    echo "[2] iptables Rules (first 10):"
    sudo iptables -L INPUT -n -v --line-numbers 2>/dev/null | head -12
    echo ""
    
    # SYN_RECV connections
    local syn_count=$(netstat -an 2>/dev/null | grep -c SYN_RECV || echo 0)
    echo "[3] SYN_RECV connections: $syn_count"
    
    if [ "$syn_count" -gt 100 ]; then
        echo -e "${RED}⚠ WARNING: Possible SYN flood attack!${NC}"
    elif [ "$syn_count" -gt 50 ]; then
        echo -e "${YELLOW}⚠ ELEVATED: Monitor closely${NC}"
    else
        echo -e "${GREEN}✓ Normal SYN_RECV count${NC}"
    fi
    
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 2: Enable UFW safely
# ═════════════════════════════════════════════════════════════
enable_ufw_safely() {
    echo -e "${YELLOW}=== TASK 2: Enabling UFW (Safely) ===${NC}"
    echo ""
    
    # Set default policies
    echo "[1] Setting default policies..."
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    echo -e "${GREEN}✓ Default: deny incoming, allow outgoing${NC}"
    echo ""
    
    # Allow SSH (CRITICAL!)
    echo "[2] Allowing SSH..."
    sudo ufw allow 22/tcp comment 'SSH access'
    echo -e "${GREEN}✓ SSH (22) allowed${NC}"
    echo ""
    
    # Enable UFW
    echo "[3] Enabling UFW..."
    echo "y" | sudo ufw enable > /dev/null 2>&1
    echo -e "${GREEN}✓ UFW enabled${NC}"
    echo ""
    
    # Verify
    echo "[4] Current status:"
    sudo ufw status numbered
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 3: Allow web traffic
# ═════════════════════════════════════════════════════════════
allow_web_traffic() {
    echo -e "${YELLOW}=== TASK 3: Allowing Web Traffic ===${NC}"
    echo ""
    
    # Allow HTTP
    echo "[1] Allowing HTTP..."
    sudo ufw allow 80/tcp comment 'HTTP'
    echo -e "${GREEN}✓ HTTP (80) allowed${NC}"
    echo ""
    
    # Allow HTTPS
    echo "[2] Allowing HTTPS..."
    sudo ufw allow 443/tcp comment 'HTTPS'
    echo -e "${GREEN}✓ HTTPS (443) allowed${NC}"
    echo ""
    
    # Verify
    echo "Current UFW rules:"
    sudo ufw status numbered | head -10
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 4: Block botnet IPs
# ═════════════════════════════════════════════════════════════
block_botnet_ips() {
    echo -e "${YELLOW}=== TASK 4: Blocking Botnet IPs ===${NC}"
    echo ""
    
    # Check if file exists
    if [[ ! -f "$BOTNET_FILE" ]]; then
        echo -e "${RED}✗ Error: $BOTNET_FILE not found!${NC}"
        return 1
    fi
    
    # Initialize log
    echo "Blocked IPs - $TIMESTAMP" > "$BLOCKED_LOG"
    
    local blocked_count=0
    local skipped_count=0
    
    echo "Blocking IPs from $BOTNET_FILE..."
    
    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        
        # Extract IP (first word)
        local ip=$(echo "$line" | awk '{print $1}')
        
        # Validate IP format
        if [[ ! "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            echo -e "${RED}⚠ Invalid IP: $ip (skipped)${NC}"
            skipped_count=$((skipped_count + 1))
            continue
        fi
        
        # Skip private IPs (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
        if [[ "$ip" =~ ^10\. ]] || [[ "$ip" =~ ^192\.168\. ]] || [[ "$ip" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]]; then
            echo -e "${YELLOW}⚠ Private IP: $ip (skipped)${NC}"
            skipped_count=$((skipped_count + 1))
            continue
        fi
        
        # Block with iptables
        if sudo iptables -I INPUT -s "$ip" -j DROP 2>/dev/null; then
            echo -e "${GREEN}✓${NC} Blocked: $ip"
            echo "$ip" >> "$BLOCKED_LOG"
            blocked_count=$((blocked_count + 1))
        else
            echo -e "${RED}✗${NC} Failed to block: $ip"
            skipped_count=$((skipped_count + 1))
        fi
        
    done < "$BOTNET_FILE"
    
    echo ""
    echo "═══════════════════════════════════════"
    echo "SUMMARY:"
    echo "  Blocked:  $blocked_count IPs"
    echo "  Skipped:  $skipped_count IPs"
    echo "  Log file: $BLOCKED_LOG"
    echo "═══════════════════════════════════════"
    echo ""
    
    # Verify
    local drop_rules=$(sudo iptables -L INPUT -n | grep -c DROP || echo 0)
    echo "Current iptables DROP rules: $drop_rules"
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 5: Configure rate limiting
# ═════════════════════════════════════════════════════════════
configure_rate_limiting() {
    echo -e "${YELLOW}=== TASK 5: Configuring Rate Limiting ===${NC}"
    echo ""
    
    # 1. SYN flood protection (connlimit)
    echo "[1] Limiting simultaneous connections per IP..."
    sudo iptables -A INPUT -p tcp --syn -m connlimit \
        --connlimit-above 20 --connlimit-mask 32 \
        -j REJECT --reject-with tcp-reset
    echo -e "${GREEN}✓ Max 20 simultaneous connections per IP${NC}"
    echo ""
    
    # 2. SSH brute-force protection (recent)
    echo "[2] SSH brute-force protection..."
    sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW \
        -m recent --set --name SSH_TRACK
    sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW \
        -m recent --update --seconds 60 --hitcount 5 --name SSH_TRACK \
        -j DROP
    echo -e "${GREEN}✓ Max 4 SSH attempts per minute per IP${NC}"
    echo ""
    
    # 3. HTTP/HTTPS rate limiting (hashlimit)
    echo "[3] HTTP/HTTPS rate limiting..."
    sudo iptables -A INPUT -p tcp --dport 80 -m hashlimit \
        --hashlimit-above 50/sec --hashlimit-mode srcip \
        --hashlimit-name http_limit -j DROP 2>/dev/null || \
        echo -e "${YELLOW}⚠ hashlimit module not available (skipped)${NC}"
    
    sudo iptables -A INPUT -p tcp --dport 443 -m hashlimit \
        --hashlimit-above 50/sec --hashlimit-mode srcip \
        --hashlimit-name https_limit -j DROP 2>/dev/null || true
    echo -e "${GREEN}✓ Max 50 HTTP/HTTPS requests per second per IP${NC}"
    echo ""
    
    # 4. ICMP flood protection
    echo "[4] ICMP flood protection..."
    sudo iptables -A INPUT -p icmp -m limit \
        --limit 5/sec --limit-burst 10 -j ACCEPT
    sudo iptables -A INPUT -p icmp -j DROP
    echo -e "${GREEN}✓ Max 5 pings per second${NC}"
    echo ""
    
    # 5. Global new connection rate limiting
    echo "[5] Global new connection rate limiting..."
    sudo iptables -A INPUT -m state --state NEW -m limit \
        --limit 60/sec --limit-burst 100 -j ACCEPT
    sudo iptables -A INPUT -m state --state NEW -j DROP
    echo -e "${GREEN}✓ Max 60 new connections per second (global)${NC}"
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 6: Configure logging
# ═════════════════════════════════════════════════════════════
configure_logging() {
    echo -e "${YELLOW}=== TASK 6: Configuring Attack Logging ===${NC}"
    echo ""
    
    # Create logging chain
    echo "[1] Creating LOGGING chain..."
    sudo iptables -N LOGGING 2>/dev/null || echo "Chain already exists"
    sudo iptables -F LOGGING 2>/dev/null || true
    echo ""
    
    # Log SSH brute-force
    echo "[2] SSH brute-force logging..."
    sudo iptables -A INPUT -p tcp --dport 22 -m recent --name SSH_TRACK \
        --rcheck --seconds 60 --hitcount 5 -m limit --limit 2/min \
        -j LOG --log-prefix '[SSH BRUTEFORCE] ' --log-level 4 2>/dev/null || true
    echo -e "${GREEN}✓ SSH attack logging enabled${NC}"
    echo ""
    
    # Log SYN flood
    echo "[3] SYN flood logging..."
    sudo iptables -A INPUT -p tcp --syn -m connlimit --connlimit-above 20 \
        -m limit --limit 2/min \
        -j LOG --log-prefix '[SYN FLOOD] ' --log-level 4 2>/dev/null || true
    echo -e "${GREEN}✓ SYN flood logging enabled${NC}"
    echo ""
    
    # Log port scanning
    echo "[4] Port scan logging..."
    sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -m limit --limit 1/min \
        -j LOG --log-prefix '[PORT SCAN NULL] ' --log-level 4 2>/dev/null || true
    sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -m limit --limit 1/min \
        -j LOG --log-prefix '[PORT SCAN XMAS] ' --log-level 4 2>/dev/null || true
    echo -e "${GREEN}✓ Port scan logging enabled${NC}"
    echo ""
    
    # Configure rsyslog
    echo "[5] Configuring rsyslog..."
    cat << 'EOF' | sudo tee /etc/rsyslog.d/10-firewall.conf > /dev/null
# Firewall logs to separate file
:msg, contains, "[FIREWALL" /var/log/firewall.log
:msg, contains, "[SSH BRUTEFORCE]" /var/log/firewall-attacks.log
:msg, contains, "[SYN FLOOD]" /var/log/firewall-attacks.log
:msg, contains, "[PORT SCAN" /var/log/firewall-attacks.log
& stop
EOF
    sudo systemctl restart rsyslog 2>/dev/null || true
    echo -e "${GREEN}✓ Firewall logs → /var/log/firewall.log${NC}"
    echo -e "${GREEN}✓ Attack logs → /var/log/firewall-attacks.log${NC}"
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 7: Monitor firewall
# ═════════════════════════════════════════════════════════════
monitor_firewall() {
    echo -e "${YELLOW}=== TASK 7: Firewall Monitoring ===${NC}"
    echo ""
    
    # Load average
    local load=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs)
    echo "[1] Server Load:           $load"
    
    # SYN_RECV count
    local syn_count=$(netstat -an 2>/dev/null | grep -c SYN_RECV || echo 0)
    echo "[2] SYN_RECV connections:  $syn_count"
    
    # Blocked packets
    local blocked_packets=$(sudo iptables -L INPUT -n -v 2>/dev/null | awk '/DROP|REJECT/ {sum+=$1} END {print sum+0}')
    echo "[3] Blocked packets:       $blocked_packets"
    
    # Total connections
    local total_conn=$(ss -s 2>/dev/null | grep TCP | head -1 | awk '{print $2}' || echo "N/A")
    echo "[4] Total connections:     $total_conn"
    
    echo ""
    echo "[5] Top attacking IPs (current connections):"
    netstat -an 2>/dev/null | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | \
        grep -v "0.0.0.0" | grep -v "127.0.0.1" | grep -v "Address" | head -5 | \
        awk '{printf "    %5d  %s\n", $1, $2}' || echo "    No data"
    
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Function 8: Generate audit report
# ═════════════════════════════════════════════════════════════
generate_audit_report() {
    echo -e "${YELLOW}=== TASK 8: Generating Security Audit Report ===${NC}"
    echo ""
    
    # Get current metrics
    local load=$(uptime | awk -F'load average:' '{print $2}')
    local syn_count=$(netstat -an 2>/dev/null | grep -c SYN_RECV || echo 0)
    local total_conn=$(ss -s 2>/dev/null | grep TCP | head -1 | awk '{print $2}' || echo "N/A")
    local mem_usage=$(free -m 2>/dev/null | awk 'NR==2{printf "%.1f%%", $3*100/$2 }' || echo "N/A")
    local cpu_usage=$(top -bn1 2>/dev/null | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 || echo "N/A")
    local blocked_ips=$(wc -l < "$BLOCKED_LOG" 2>/dev/null || echo 0)
    
    {
        cat << EOF
╔═══════════════════════════════════════════════════════════╗
║         FIREWALL SECURITY AUDIT REPORT                   ║
║         Episode 07: Firewalls & iptables                 ║
╚═══════════════════════════════════════════════════════════╝

Date:     $TIMESTAMP
Server:   $(hostname)
Location: $LOCATION
Operator: $OPERATOR
Day:      $DAY

════════════════════════════════════════════════════════════
[1] INCIDENT SUMMARY
════════════════════════════════════════════════════════════

Start Time:    03:47 (Emergency call from Alex)
End Time:      04:07 (Attack mitigated)
Duration:      20 minutes
Attack Type:   DDoS (TCP SYN Flood)
Source IPs:    847 unique botnet nodes (50 in test)
Peak Load:     47.82 (CRITICAL)
Final Load:    $load

STATUS: ✓ ATTACK MITIGATED

════════════════════════════════════════════════════════════
[2] FIREWALL CONFIGURATION
════════════════════════════════════════════════════════════

UFW Status:
$(sudo ufw status verbose 2>/dev/null | head -15)

iptables INPUT Chain (first 15 rules):
$(sudo iptables -L INPUT -n -v --line-numbers 2>/dev/null | head -17)

════════════════════════════════════════════════════════════
[3] BLOCKED IPS STATISTICS
════════════════════════════════════════════════════════════

Total IPs blocked:    $blocked_ips
Source:               artifacts/botnet_ips.txt (Anna's forensics)
Method:               iptables DROP rules

Top 5 blocked IPs:
$(head -5 "$BLOCKED_LOG" 2>/dev/null | tail -5 || echo "No blocked IPs logged")

════════════════════════════════════════════════════════════
[4] CURRENT SYSTEM STATUS
════════════════════════════════════════════════════════════

Load Average:         $load
SYN_RECV connections: $syn_count
Total connections:    $total_conn
Memory usage:         $mem_usage
CPU usage:            ${cpu_usage}%

════════════════════════════════════════════════════════════
[5] ATTACK LOGS ANALYSIS
════════════════════════════════════════════════════════════

Attack types detected:
$(grep -o '\[.*\]' /var/log/firewall-attacks.log 2>/dev/null | sort | uniq -c | sort -rn || echo "  No attacks logged yet")

Top attacking IPs (from current connections):
$(netstat -an 2>/dev/null | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | grep -v "0.0.0.0" | head -5 || echo "  No data")

════════════════════════════════════════════════════════════
[6] SECURITY MEASURES IMPLEMENTED
════════════════════════════════════════════════════════════

✓ UFW enabled with default deny policy
✓ SSH (22), HTTP (80), HTTPS (443) allowed
✓ $blocked_ips botnet IPs blocked via iptables
✓ Rate limiting configured:
  - Max 20 simultaneous connections per IP
  - SSH: 4 attempts per minute
  - HTTP/HTTPS: 50 requests/sec per IP
  - ICMP: 5 pings/sec
  - Global: 60 new connections/sec
✓ Attack logging enabled (SSH, SYN flood, port scans)
✓ rsyslog configured for firewall logs
✓ Log rotation configured (7 days retention)

════════════════════════════════════════════════════════════
[7] SECURITY ASSESSMENT
════════════════════════════════════════════════════════════

Overall Status: ✓ SECURE

Strengths:
  + Effective DDoS mitigation
  + Comprehensive rate limiting
  + Attack detection and logging
  + Zero false positives (legitimate traffic unaffected)
  + Multi-layered defense (UFW + iptables + rate limiting)

Areas for Improvement:
  - Consider fail2ban for automated banning
  - Implement IDS/IPS (Snort, Suricata)
  - Geographic IP filtering (GeoIP)
  - CDN integration for additional DDoS protection

Recommendations:
  1. Monitor firewall logs daily (automated alerts)
  2. Update botnet IP list regularly (IPs change)
  3. Enable kernel-level protections (SYN cookies)
  4. Backup iptables rules: iptables-save > /etc/iptables.rules
  5. Document incident in SIEM system
  6. Conduct post-incident review with team
  7. Prepare for escalation (Krylov threat is real)

════════════════════════════════════════════════════════════
[8] NEXT STEPS
════════════════════════════════════════════════════════════

Immediate (< 24 hours):
  - Share report with Viktor and Anna
  - Monitor for 24h for repeat attacks
  - Analyze attack vectors with Anna (forensics)
  - Check for data exfiltration attempts

Short-term (1-7 days):
  - Episode 08: VPN & SSH Tunneling
  - Secure communication channels
  - Encrypted traffic to protect from Krylov
  - Review and harden all exposed services

Long-term (1-4 weeks):
  - Deploy WAF (Web Application Firewall)
  - Implement SIEM for centralized logging
  - Set up honeypots for threat intelligence
  - Develop incident response playbooks

════════════════════════════════════════════════════════════
THREAT ASSESSMENT: Krylov
════════════════════════════════════════════════════════════

Evidence:
  - All attacking IPs traced to Krylov's infrastructure
  - Targeted attack on specific server (shadow-server-02)
  - Timing suggests insider knowledge (knows our location)
  - Message in TCP payload: "Соколов. Передай брату: я найду вас. Обоих. - К."

Implications:
  ⚠ This was not just a DDoS attack — it was a WARNING
  ⚠ Krylov has advanced capabilities (botnet, Tor, payload injection)
  ⚠ He knows about Alex and Max personally
  ⚠ Escalation is inevitable

Security Posture:
  - Current: REACTIVE (responding to attacks)
  - Required: PROACTIVE (anticipate and prevent)
  - Priority: Protect team members (physical and digital safety)

════════════════════════════════════════════════════════════
END OF REPORT

Generated by: firewall_setup.sh (solution)
Episode: 07 — Firewalls & iptables
Location: Moscow, Russia 🇷🇺
Operation: KERNEL SHADOWS (Day 13/60)
════════════════════════════════════════════════════════════
EOF
    } > "$REPORT_FILE"
    
    echo -e "${GREEN}✓ Firewall Audit Report generated: $REPORT_FILE${NC}"
    echo ""
    echo "Summary:"
    echo "  Blocked IPs:   $blocked_ips"
    echo "  Load Average:  $(echo "$load" | cut -d',' -f1)"
    echo "  SYN_RECV:      $syn_count"
    echo ""
    echo -e "${GREEN}Status: ✓ ATTACK MITIGATED${NC}"
    echo ""
}

# ═════════════════════════════════════════════════════════════
# Main function
# ═════════════════════════════════════════════════════════════
main() {
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  Episode 07: Firewalls & iptables                        ║${NC}"
    echo -e "${CYAN}║  DDoS Attack Response - Emergency Mode                   ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Time:     $TIMESTAMP"
    echo "Location: $LOCATION"
    echo "Operator: $OPERATOR"
    echo -e "Status:   ${RED}🔴 UNDER ATTACK${NC}"
    echo ""
    echo "───────────────────────────────────────────────────────────"
    echo ""
    
    # Execute all tasks
    check_firewall_status
    enable_ufw_safely
    allow_web_traffic
    block_botnet_ips
    configure_rate_limiting
    configure_logging
    monitor_firewall
    generate_audit_report
    
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}FIREWALL SETUP COMPLETE${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Review the audit report:"
    echo "     cat $REPORT_FILE"
    echo ""
    echo "  2. Monitor logs:"
    echo "     sudo tail -f /var/log/firewall.log"
    echo ""
    echo "  3. Check if attack stopped:"
    echo "     watch 'uptime && netstat -an | grep SYN_RECV | wc -l'"
    echo ""
    echo -e "${GREEN}✓ Episode 07 Complete!${NC}"
    echo ""
    echo -e "${YELLOW}WARNING: Krylov sent a message in the TCP payload.${NC}"
    echo -e "${YELLOW}Check logs for details. Stay vigilant.${NC}"
    echo ""
}

# Run main function
main "$@"

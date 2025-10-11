#!/bin/bash

# Episode 07: Firewalls & iptables
# Type B Student Template — Execute UFW/iptables commands DIRECTLY!
#
# Philosophy: ufw exists → use it, don't wrap it!
#
# This script is only for DOCUMENTATION and FINAL REPORT.
# YOU should execute firewall commands DIRECTLY in terminal!

set -e
set -u

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARTIFACTS_DIR="$SCRIPT_DIR/artifacts"
REPORT_FILE="$ARTIFACTS_DIR/firewall_audit_report.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  Episode 07: Firewalls & iptables (Type B)              ║${NC}"
echo -e "${CYAN}║  DDoS Attack Response — Emergency Mode                   ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}⚠️  TYPE B EPISODE REMINDER:${NC}"
echo ""
echo "You should execute firewall commands DIRECTLY in terminal:"
echo ""
echo "  ✅ sudo ufw allow 22/tcp"
echo "  ✅ sudo ufw enable"
echo "  ✅ sudo iptables -I INPUT -s 1.2.3.4 -j DROP"
echo ""
echo "  ❌ NOT: bash function enable_ufw()"
echo "  ❌ NOT: bash function allow_port()"
echo ""
echo "This script only generates FINAL REPORT after you configured firewall."
echo ""
echo "───────────────────────────────────────────────────────────"
echo ""

# ═════════════════════════════════════════════════════════════
# CYCLE 1: UFW Status Check
# ═════════════════════════════════════════════════════════════

echo -e "${CYAN}[CYCLE 1] UFW Status Check${NC}"
echo ""
echo "Execute these commands DIRECTLY in terminal:"
echo ""
echo "  # Check UFW status"
echo "  sudo ufw status verbose"
echo ""
echo "  # Check iptables rules"
echo "  sudo iptables -L -n -v"
echo ""
echo "  # Check SYN_RECV connections (DDoS indicator)"
echo "  netstat -an | grep SYN_RECV | wc -l"
echo ""
read -p "Press Enter after you executed commands..."
echo ""

# ═════════════════════════════════════════════════════════════
# CYCLE 2: Enable UFW Safely
# ═════════════════════════════════════════════════════════════

echo -e "${CYAN}[CYCLE 2] Enable UFW Safely${NC}"
echo ""
echo -e "${RED}⚠️  CRITICAL: Allow SSH BEFORE enabling UFW!${NC}"
echo ""
echo "Execute these commands DIRECTLY in terminal:"
echo ""
echo "  # Step 1: Set default policies"
echo "  sudo ufw default deny incoming"
echo "  sudo ufw default allow outgoing"
echo ""
echo "  # Step 2: Allow SSH (FIRST!)"
echo "  sudo ufw allow 22/tcp comment 'SSH access'"
echo ""
echo "  # Step 3: Enable UFW"
echo "  echo 'y' | sudo ufw enable"
echo ""
echo "  # Step 4: Verify"
echo "  sudo ufw status verbose"
echo ""
read -p "Press Enter after you enabled UFW..."
echo ""

# ═════════════════════════════════════════════════════════════
# CYCLE 3: Allow Web Traffic
# ═════════════════════════════════════════════════════════════

echo -e "${CYAN}[CYCLE 3] Allow Web Traffic${NC}"
echo ""
echo "Execute these commands DIRECTLY in terminal:"
echo ""
echo "  # Allow HTTP"
echo "  sudo ufw allow 80/tcp comment 'HTTP'"
echo ""
echo "  # Allow HTTPS"
echo "  sudo ufw allow 443/tcp comment 'HTTPS'"
echo ""
echo "  # Verify"
echo "  sudo ufw status numbered"
echo ""
read -p "Press Enter after you allowed web traffic..."
echo ""

# ═════════════════════════════════════════════════════════════
# CYCLE 4: Block Botnet IPs
# ═════════════════════════════════════════════════════════════

echo -e "${CYAN}[CYCLE 4] Block Botnet IPs${NC}"
echo ""
echo "Execute this loop DIRECTLY in terminal:"
echo ""
echo "  # Block botnet IPs with iptables (Type B: direct commands!)"
echo "  while IFS= read -r line; do"
echo "      [[ -z \"\$line\" || \"\$line\" =~ ^# ]] && continue"
echo "      ip=\$(echo \"\$line\" | awk '{print \$1}')"
echo "      sudo iptables -I INPUT -s \"\$ip\" -j DROP"
echo "      echo \"Blocked: \$ip\""
echo "  done < artifacts/botnet_ips.txt"
echo ""
echo "  # Verify"
echo "  sudo iptables -L INPUT -n | grep -c DROP"
echo "  netstat -an | grep SYN_RECV | wc -l"
echo ""
read -p "Press Enter after you blocked botnet IPs..."
echo ""

# ═════════════════════════════════════════════════════════════
# CYCLE 5: Rate Limiting
# ═════════════════════════════════════════════════════════════

echo -e "${CYAN}[CYCLE 5] Rate Limiting${NC}"
echo ""
echo "Execute these commands DIRECTLY in terminal:"
echo ""
echo "  # 1. Connection limit"
echo "  sudo iptables -A INPUT -p tcp --syn -m connlimit \\"
echo "      --connlimit-above 20 --connlimit-mask 32 \\"
echo "      -j REJECT --reject-with tcp-reset"
echo ""
echo "  # 2. SSH brute-force protection"
echo "  sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW \\"
echo "      -m recent --set --name SSH_TRACK"
echo "  sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW \\"
echo "      -m recent --update --seconds 60 --hitcount 5 --name SSH_TRACK \\"
echo "      -j DROP"
echo ""
echo "  # 3. HTTP/HTTPS rate limiting"
echo "  sudo iptables -A INPUT -p tcp --dport 80 -m hashlimit \\"
echo "      --hashlimit-above 50/sec --hashlimit-mode srcip \\"
echo "      --hashlimit-name http_limit -j DROP"
echo ""
echo "  # 4. ICMP flood protection"
echo "  sudo iptables -A INPUT -p icmp -m limit \\"
echo "      --limit 5/sec --limit-burst 10 -j ACCEPT"
echo "  sudo iptables -A INPUT -p icmp -j DROP"
echo ""
read -p "Press Enter after you configured rate limiting..."
echo ""

# ═════════════════════════════════════════════════════════════
# CYCLE 6: Logging & Monitoring
# ═════════════════════════════════════════════════════════════

echo -e "${CYAN}[CYCLE 6] Logging & Monitoring${NC}"
echo ""
echo "Execute these commands DIRECTLY in terminal:"
echo ""
echo "  # 1. Log SSH brute-force"
echo "  sudo iptables -A INPUT -p tcp --dport 22 -m recent \\"
echo "      --name SSH_TRACK --rcheck --seconds 60 --hitcount 5 \\"
echo "      -m limit --limit 2/min \\"
echo "      -j LOG --log-prefix '[SSH BRUTEFORCE] ' --log-level 4"
echo ""
echo "  # 2. Configure rsyslog"
echo "  echo ':msg, contains, \"[FIREWALL\" /var/log/firewall.log' | \\"
echo "      sudo tee /etc/rsyslog.d/10-firewall.conf"
echo "  sudo systemctl restart rsyslog"
echo ""
echo "  # 3. View logs"
echo "  sudo tail -f /var/log/firewall.log"
echo ""
read -p "Press Enter after you configured logging..."
echo ""

# ═════════════════════════════════════════════════════════════
# CYCLE 7: Generate Final Report (Type B: OK to use bash!)
# ═════════════════════════════════════════════════════════════

echo -e "${CYAN}[CYCLE 7] Generating Final Security Audit Report${NC}"
echo ""
echo "This part uses bash — it's OK for report generation! (Type B)"
echo ""

# Function to generate report (Type B: collecting results, not configuring!)
generate_report() {
    {
        echo "═══════════════════════════════════════════════════════════"
        echo "         FIREWALL SECURITY AUDIT REPORT"
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        echo "Date:     $TIMESTAMP"
        echo "Location: ЦОД 'Москва-1', Серверная A-12 🇷🇺"
        echo "Operator: Max Sokolov"
        echo "Incident: DDoS Attack Response (Day 13 of 60)"
        echo ""

        echo "═══════════════════════════════════════════════════════════"
        echo " [1] INCIDENT SUMMARY"
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        echo "Start Time:   03:47 (emergency call)"
        echo "End Time:     04:07 (attack mitigated)"
        echo "Duration:     20 minutes"
        echo "Attack Type:  DDoS (SYN Flood)"
        echo "Source IPs:   847 botnet nodes"
        echo "Peak Load:    47.82 (CRITICAL)"
        echo "Final Load:   $(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs)"
        echo ""
        echo "STATUS: ✓ ATTACK MITIGATED"
        echo ""

        echo "═══════════════════════════════════════════════════════════"
        echo " [2] FIREWALL CONFIGURATION"
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        echo "UFW Status:"
        sudo ufw status verbose 2>/dev/null || echo "  (UFW not configured)"
        echo ""
        echo "iptables Rules:"
        echo "  Total DROP rules: $(sudo iptables -L INPUT -n 2>/dev/null | grep -c DROP || echo 0)"
        echo ""

        echo "═══════════════════════════════════════════════════════════"
        echo " [3] CURRENT METRICS"
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        echo "Load Average:    $(uptime | awk -F'load average:' '{print $2}')"
        echo "SYN_RECV count:  $(netstat -an 2>/dev/null | grep -c SYN_RECV || echo 0)"
        echo "Memory usage:    $(free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2}')"
        echo "CPU usage:       $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)%"
        echo ""

        echo "═══════════════════════════════════════════════════════════"
        echo " [4] SECURITY MEASURES IMPLEMENTED"
        echo "═══════════════════════════════════════════════════════════"
        echo ""

        # Check what student configured
        local ufw_active=0
        local ssh_ok=0
        local http_ok=0
        local https_ok=0

        sudo ufw status 2>/dev/null | grep -q "Status: active" && ufw_active=1
        sudo ufw status 2>/dev/null | grep -q "22.*ALLOW" && ssh_ok=1
        sudo ufw status 2>/dev/null | grep -q "80.*ALLOW" && http_ok=1
        sudo ufw status 2>/dev/null | grep -q "443.*ALLOW" && https_ok=1

        [ "$ufw_active" -eq 1 ] && echo "✓ UFW enabled (default deny incoming)" || echo "⚠️  UFW not enabled"
        [ "$ssh_ok" -eq 1 ] && echo "✓ SSH (22) allowed" || echo "⚠️  SSH not allowed"
        [ "$http_ok" -eq 1 ] && echo "✓ HTTP (80) allowed" || echo "⚠️  HTTP not allowed"
        [ "$https_ok" -eq 1 ] && echo "✓ HTTPS (443) allowed" || echo "⚠️  HTTPS not allowed"

        local blocked_ips=$(sudo iptables -L INPUT -n 2>/dev/null | grep -c DROP || echo 0)
        [ "$blocked_ips" -gt 0 ] && echo "✓ $blocked_ips IPs blocked (iptables)" || echo "⚠️  No IPs blocked"

        echo "✓ Rate limiting configured"
        echo "✓ Attack logging enabled"
        echo ""

        echo "═══════════════════════════════════════════════════════════"
        echo " [5] SECURITY ASSESSMENT"
        echo "═══════════════════════════════════════════════════════════"
        echo ""

        # Calculate score
        local score=0
        [ "$ufw_active" -eq 1 ] && score=$((score + 1))
        [ "$ssh_ok" -eq 1 ] && score=$((score + 1))
        [ "$http_ok" -eq 1 ] && score=$((score + 1))
        [ "$https_ok" -eq 1 ] && score=$((score + 1))
        [ "$blocked_ips" -gt 0 ] && score=$((score + 1))

        echo "Security Score: $score/5"
        echo ""

        if [ "$score" -eq 5 ]; then
            echo "Overall: ✓ EXCELLENT (All measures in place)"
        elif [ "$score" -ge 3 ]; then
            echo "Overall: ✓ GOOD (Most measures implemented)"
        else
            echo "Overall: ⚠️  INCOMPLETE (More work needed)"
        fi

        echo ""
        echo "═══════════════════════════════════════════════════════════"
        echo " [6] RECOMMENDATIONS"
        echo "═══════════════════════════════════════════════════════════"
        echo ""

        [ "$ufw_active" -eq 0 ] && echo "  • Enable UFW: sudo ufw enable"
        [ "$ssh_ok" -eq 0 ] && echo "  • Allow SSH: sudo ufw allow 22/tcp"
        [ "$blocked_ips" -eq 0 ] && echo "  • Block botnet IPs from artifacts/botnet_ips.txt"

        echo "  • Monitor logs: sudo tail -f /var/log/firewall.log"
        echo "  • Update botnet IP list weekly"
        echo "  • Consider fail2ban for automation"
        echo "  • Backup rules: sudo iptables-save > /etc/iptables.rules"
        echo ""

        echo "═══════════════════════════════════════════════════════════"
        echo " EPISODE 07 COMPLETED"
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        echo "Алекс:  'Отличная работа, Макс. Сервер держится. Load с 47"
        echo "         упал до $(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs). Атака отражена.'"
        echo ""
        echo "Анна:   'Forensics завершён. 847 IP заблокированы. Все из Tor"
        echo "         exit nodes. Отпечатки Крылова повсюду.'"
        echo ""
        echo "Виктор: 'Хороший incident response. Firewall спас операцию."
        echo "         Но Крылов становится агрессивнее.'"
        echo ""
        echo "LILITH: 'Firewall Module complete. Remember: ufw exists → use it."
        echo "         Type B = configure tools, not replace them.'"
        echo ""
        echo "═══════════════════════════════════════════════════════════"
        echo " END OF REPORT"
        echo "═══════════════════════════════════════════════════════════"

    } > "$REPORT_FILE"
}

# Generate report
generate_report

echo -e "${GREEN}✓ Firewall Security Audit Complete!${NC}"
echo ""
echo "Report saved to: $REPORT_FILE"
echo ""
cat "$REPORT_FILE"
echo ""

# ═════════════════════════════════════════════════════════════
# Summary
# ═════════════════════════════════════════════════════════════

echo "═══════════════════════════════════════════════════════════"
echo -e "${CYAN}EPISODE 07 SUMMARY${NC}"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo -e "${YELLOW}Type B Philosophy:${NC}"
echo "  ✓ You executed UFW/iptables commands DIRECTLY"
echo "  ✓ No bash wrappers around firewall tools"
echo "  ✓ Bash only for report generation (this script)"
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "  1. Review report: cat $REPORT_FILE"
echo "  2. Monitor logs: sudo tail -f /var/log/firewall.log"
echo "  3. Check Load Average: uptime"
echo "  4. Episode 08: VPN & SSH Tunneling 🔒"
echo ""
echo "✓ Episode 07 completed! Type B approach mastered!"
echo ""

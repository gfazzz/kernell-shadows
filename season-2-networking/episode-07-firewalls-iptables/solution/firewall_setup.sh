#!/bin/bash
# KERNEL SHADOWS — Episode 07: Firewalls & iptables
# Solution: firewall_setup.sh (Type B — Minimal Bash)
#
# Philosophy: Use UFW/iptables directly, NOT bash wrappers
# This script ONLY generates report from results YOU already configured

set -e
set -u

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARTIFACTS_DIR="$SCRIPT_DIR/artifacts"
REPORT_FILE="$ARTIFACTS_DIR/firewall_audit_report.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "═══════════════════════════════════════════════════"
echo "     FIREWALL SECURITY AUDIT - Type B Approach"
echo "═══════════════════════════════════════════════════"
    echo ""
echo "Philosophy: ufw exists → use it, don't wrap it"
echo "This script collects results and generates report"
    echo ""
    
# Function 1: Check UFW status
# (Students already did: sudo ufw status verbose)
check_ufw_status() {
    echo -n "Checking UFW status... "

    if sudo ufw status | grep -q "Status: active"; then
        echo -e "${GREEN}ACTIVE${NC}"
        return 0
    else
        echo -e "${RED}INACTIVE${NC}"
        return 1
    fi
}

# Function 2: Count firewall rules
# (Students already configured rules with: sudo ufw allow/deny)
count_rules() {
    local allow_count=$(sudo ufw status numbered 2>/dev/null | grep -c "ALLOW" || echo 0)
    local deny_count=$(sudo ufw status numbered 2>/dev/null | grep -c "DENY" || echo 0)
    local total=$((allow_count + deny_count))

    echo "$allow_count:$deny_count:$total"
}

# Function 3: Check critical ports
# (Students already did: sudo ufw allow 22/80/443)
check_critical_ports() {
    local ssh_ok=0
    local http_ok=0
    local https_ok=0

    sudo ufw status | grep -q "22.*ALLOW" && ssh_ok=1
    sudo ufw status | grep -q "80.*ALLOW" && http_ok=1
    sudo ufw status | grep -q "443.*ALLOW" && https_ok=1

    echo "$ssh_ok:$http_ok:$https_ok"
}

# Function 4: Check blocked IPs
# (Students already did: while read ip; do sudo ufw deny from $ip; done)
check_blocked_ips() {
    local blocked_count=$(sudo ufw status numbered 2>/dev/null | grep -c "DENY.*Anywhere" || echo 0)
    echo "$blocked_count"
}

# Function 5: Check rate limiting
# (Students already did: sudo ufw limit 22/tcp)
check_rate_limiting() {
    if sudo ufw status | grep -q "22/tcp.*LIMIT"; then
        echo "ENABLED"
    else
        echo "DISABLED"
    fi
}

# Function 6: Check logging
# (Students already did: sudo ufw logging on)
check_logging() {
    local log_level=$(sudo ufw status verbose | grep "Logging:" | awk '{print $2}')
    echo "${log_level:-off}"
}

# Function 7: Analyze attack effectiveness
# (Based on system metrics after firewall configuration)
analyze_attack_metrics() {
    # Current load
    local load=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ')

    # SYN_RECV connections
    local syn_count=$(netstat -an 2>/dev/null | grep -c "SYN_RECV" || echo 0)

    # Established connections
    local est_count=$(netstat -an 2>/dev/null | grep -c "ESTABLISHED" || echo 0)

    echo "$load:$syn_count:$est_count"
}

# Function 8: Generate comprehensive report
generate_report() {
    local ufw_active="$1"
    local rules_counts="$2"
    local ports_status="$3"
    local blocked_ips="$4"
    local rate_limit="$5"
    local logging="$6"
    local attack_metrics="$7"

    # Parse data
    IFS=':' read -r allow_count deny_count total_rules <<< "$rules_counts"
    IFS=':' read -r ssh_ok http_ok https_ok <<< "$ports_status"
    IFS=':' read -r load syn_count est_count <<< "$attack_metrics"

    {
        echo "═══════════════════════════════════════════════════════════════"
        echo "             FIREWALL SECURITY AUDIT REPORT"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "Date:       $TIMESTAMP"
        echo "Location:   ЦОД 'Москва-1', Серверная A-12 🇷🇺"
        echo "Operator:   Max Sokolov"
        echo "Incident:   DDoS Attack Response (Day 13 of 60)"
        echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " [1] UFW STATUS"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        if [ "$ufw_active" -eq 1 ]; then
            echo "  Status: ✓ ACTIVE"
        else
            echo "  Status: ✗ INACTIVE"
        fi
        echo "  Total Rules: $total_rules"
        echo "    - ALLOW rules: $allow_count"
        echo "    - DENY rules:  $deny_count"
        echo ""

        echo "═══════════════════════════════════════════════════════════════"
        echo " [2] CRITICAL PORTS"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        [ "$ssh_ok" -eq 1 ] && echo "  SSH (22):    ✓ ALLOWED" || echo "  SSH (22):    ✗ BLOCKED"
        [ "$http_ok" -eq 1 ] && echo "  HTTP (80):   ✓ ALLOWED" || echo "  HTTP (80):   ✗ BLOCKED"
        [ "$https_ok" -eq 1 ] && echo "  HTTPS (443): ✓ ALLOWED" || echo "  HTTPS (443): ✗ BLOCKED"
        echo ""

        echo "═══════════════════════════════════════════════════════════════"
        echo " [3] BOTNET BLOCKING"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "  Blocked IPs: $blocked_ips"
        if [ "$blocked_ips" -gt 0 ]; then
            echo "  Status: ✓ Botnet IPs blocked"
        else
            echo "  Status: ⚠️  No IPs blocked yet"
        fi
        echo ""

        echo "═══════════════════════════════════════════════════════════════"
        echo " [4] RATE LIMITING"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "  SSH Rate Limit: $rate_limit"
        if [ "$rate_limit" = "ENABLED" ]; then
            echo "  Status: ✓ SYN flood protection active"
        else
            echo "  Status: ⚠️  No rate limiting configured"
        fi
    echo ""
    
        echo "═══════════════════════════════════════════════════════════════"
        echo " [5] LOGGING"
        echo "═══════════════════════════════════════════════════════════════"
    echo ""
        echo "  Log Level: $logging"
        if [ "$logging" != "off" ]; then
            echo "  Status: ✓ Attack logging enabled"
            echo "  Log File: /var/log/ufw.log"
        else
            echo "  Status: ⚠️  Logging disabled"
        fi
    echo ""
    
        echo "═══════════════════════════════════════════════════════════════"
        echo " [6] ATTACK METRICS"
        echo "═══════════════════════════════════════════════════════════════"
    echo ""
        echo "  Current Load:     $load"
        echo "  SYN_RECV count:   $syn_count"
        echo "  ESTABLISHED:      $est_count"
    echo ""
    
        # Evaluate effectiveness
        local effectiveness="UNKNOWN"
        if [ "$blocked_ips" -gt 0 ] && [ "$rate_limit" = "ENABLED" ]; then
            if (( $(echo "$load < 5.0" | bc -l 2>/dev/null || echo 0) )); then
                effectiveness="EXCELLENT"
            elif (( $(echo "$load < 15.0" | bc -l 2>/dev/null || echo 0) )); then
                effectiveness="GOOD"
            else
                effectiveness="PARTIAL"
            fi
        else
            effectiveness="INSUFFICIENT"
        fi

        echo "  Effectiveness: $effectiveness"
    echo ""
    
        if [ "$effectiveness" = "EXCELLENT" ]; then
            echo "  Status: ✓ Attack successfully mitigated!"
            echo "          Load normalized, SYN flood stopped."
        elif [ "$effectiveness" = "GOOD" ]; then
            echo "  Status: ✓ Attack significantly reduced"
            echo "          Monitor closely for additional measures."
        elif [ "$effectiveness" = "PARTIAL" ]; then
            echo "  Status: ⚠️  Attack partially mitigated"
            echo "          Additional rules may be needed."
        else
            echo "  Status: ⚠️  Attack continues"
            echo "          Review firewall configuration."
        fi

    echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " [7] SECURITY ASSESSMENT"
        echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
        # Calculate security score
        local score=0
        local max_score=7

        [ "$ufw_active" -eq 1 ] && score=$((score + 1))
        [ "$ssh_ok" -eq 1 ] && score=$((score + 1))
        [ "$http_ok" -eq 1 ] && score=$((score + 1))
        [ "$https_ok" -eq 1 ] && score=$((score + 1))
        [ "$blocked_ips" -gt 0 ] && score=$((score + 1))
        [ "$rate_limit" = "ENABLED" ] && score=$((score + 1))
        [ "$logging" != "off" ] && score=$((score + 1))

        echo "  Security Score: $score/$max_score"
    echo ""
    
        if [ "$score" -eq 7 ]; then
            echo "  Overall: ✓ EXCELLENT (All security measures in place)"
        elif [ "$score" -ge 5 ]; then
            echo "  Overall: ✓ GOOD (Most security measures implemented)"
        elif [ "$score" -ge 3 ]; then
            echo "  Overall: ⚠️  ACCEPTABLE (Basic protection active)"
        else
            echo "  Overall: ❌ CRITICAL (Insufficient protection!)"
        fi

    echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " [8] RECOMMENDATIONS"
        echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
        [ "$ufw_active" -eq 0 ] && echo "  • Enable UFW immediately: sudo ufw enable"
        [ "$ssh_ok" -eq 0 ] && echo "  • Allow SSH before lockout: sudo ufw allow 22/tcp"
        [ "$blocked_ips" -eq 0 ] && echo "  • Block botnet IPs from artifacts/botnet_ips.txt"
        [ "$rate_limit" = "DISABLED" ] && echo "  • Enable rate limiting: sudo ufw limit 22/tcp"
        [ "$logging" = "off" ] && echo "  • Enable logging: sudo ufw logging on"

        echo "  • Monitor /var/log/ufw.log for blocked attempts"
        echo "  • Regular security audits (weekly)"
        echo "  • Keep UFW rules updated"
        echo "  • Document all firewall changes"
    
    echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " EPISODE 07 COMPLETED"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "Алекс:     'Отличная работа, Макс. Сервер держится. Load с 47 упал"
        echo "            до $load. Атака отражена. Крылов не прошёл.'"
        echo ""
        echo "Анна:      'Forensics завершён. 847 IP заблокированы. Все из Tor"
        echo "            exit nodes. Отпечатки Крылова повсюду.'"
        echo ""
        echo "Виктор:    'Хороший incident response. Firewall спас операцию."
        echo "            Но Крылов становится агрессивнее. Готовься к худшему.'"
    echo ""
        echo "LILITH:    'Firewall Module complete. Remember: ufw exists → use it."
        echo "            Type B = configure tools, not replace them.'"
    echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " END OF REPORT"
        echo "═══════════════════════════════════════════════════════════════"

    } > "$REPORT_FILE"
}

# Main execution
main() {
    echo "Running Firewall Security Audit..."
    echo ""
    
    # Execute all checks (using UFW/iptables directly)
    echo -e "${YELLOW}[1/7]${NC} Checking UFW status..."
    check_ufw_status
    ufw_active=$?

    echo -e "${YELLOW}[2/7]${NC} Counting firewall rules..."
    rules_counts=$(count_rules)

    echo -e "${YELLOW}[3/7]${NC} Checking critical ports..."
    ports_status=$(check_critical_ports)

    echo -e "${YELLOW}[4/7]${NC} Checking blocked IPs..."
    blocked_ips=$(check_blocked_ips)

    echo -e "${YELLOW}[5/7]${NC} Checking rate limiting..."
    rate_limit=$(check_rate_limiting)

    echo -e "${YELLOW}[6/7]${NC} Checking logging status..."
    logging=$(check_logging)

    echo -e "${YELLOW}[7/7]${NC} Analyzing attack metrics..."
    attack_metrics=$(analyze_attack_metrics)
    
    echo ""
    echo "Generating comprehensive report..."

    generate_report "$ufw_active" "$rules_counts" "$ports_status" "$blocked_ips" \
                    "$rate_limit" "$logging" "$attack_metrics"

    echo ""
    echo -e "${GREEN}✓ Firewall Security Audit Complete!${NC}"
    echo ""
    echo "Report saved to: $REPORT_FILE"
    echo ""
    cat "$REPORT_FILE"
}

# Run main
main "$@"

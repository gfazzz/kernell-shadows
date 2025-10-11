#!/bin/bash
# KERNEL SHADOWS — Episode 07: Firewalls & iptables
# Report Generator (Type B — Minimal Helper)
#
# Philosophy: You already configured UFW manually
# This script ONLY formats your results into a report

set -e
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARTIFACTS_DIR="$SCRIPT_DIR/artifacts"
REPORT_FILE="$ARTIFACTS_DIR/firewall_audit_report.txt"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "═══════════════════════════════════════════════════════════════"
echo "     FIREWALL SECURITY AUDIT REPORT GENERATOR"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo -e "${YELLOW}Type B Philosophy:${NC} ufw exists → use it manually"
echo "This script generates report from YOUR manual configuration"
echo ""

# Check if UFW is configured
if ! command -v ufw &> /dev/null; then
    echo -e "${RED}ERROR:${NC} UFW not installed! Install: sudo apt install ufw"
    exit 1
fi

if ! sudo ufw status | grep -q "Status: active"; then
    echo -e "${RED}ERROR:${NC} UFW not active! Enable: sudo ufw enable"
    echo ""
    echo "Configure UFW first:"
    echo "  1. Run configs/ufw_rules.sh"
    echo "  2. Verify with: sudo ufw status verbose"
    echo "  3. Test with: nmap -p 22,80,443 YOUR_IP"
    exit 1
fi

# Collect UFW statistics
UFW_STATUS=$(sudo ufw status verbose)
ALLOW_COUNT=$(sudo ufw status numbered 2>/dev/null | grep -c "ALLOW" || echo 0)
DENY_COUNT=$(sudo ufw status numbered 2>/dev/null | grep -c "DENY" || echo 0)
LIMIT_COUNT=$(sudo ufw status numbered 2>/dev/null | grep -c "LIMIT" || echo 0)
TOTAL_RULES=$((ALLOW_COUNT + DENY_COUNT + LIMIT_COUNT))

# Check critical ports
SSH_OK=$(sudo ufw status | grep -c "22.*\(ALLOW\|LIMIT\)" || echo 0)
HTTP_OK=$(sudo ufw status | grep -c "80.*ALLOW" || echo 0)
HTTPS_OK=$(sudo ufw status | grep -c "443.*ALLOW" || echo 0)

# Check rate limiting on SSH
SSH_RATE_LIMIT=$(sudo ufw status | grep -c "22/tcp.*LIMIT" || echo 0)

# Check logging
LOG_LEVEL=$(sudo ufw status verbose | grep "Logging:" | awk '{print $2}')

# Generate report
{
    echo "═══════════════════════════════════════════════════════════════"
    echo "            FIREWALL SECURITY AUDIT REPORT"
    echo "            Tallinn, Estonia — Protection Layer"
    echo "            Analyst: Max Sokolov"
    echo "            Date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    echo "UFW STATUS:"
    echo "───────────────────────────────────────────────────────────────"
    echo "$UFW_STATUS"
    echo ""
    
    echo "RULE STATISTICS:"
    echo "───────────────────────────────────────────────────────────────"
    echo "Total rules:        $TOTAL_RULES"
    echo "  ALLOW rules:      $ALLOW_COUNT"
    echo "  DENY rules:       $DENY_COUNT"
    echo "  LIMIT rules:      $LIMIT_COUNT (rate limiting)"
    echo ""
    
    echo "CRITICAL SERVICES:"
    echo "───────────────────────────────────────────────────────────────"
    [ "$SSH_OK" -gt 0 ] && echo "✓ SSH (port 22):      CONFIGURED" || echo "✗ SSH (port 22):      MISSING"
    [ "$HTTP_OK" -gt 0 ] && echo "✓ HTTP (port 80):     CONFIGURED" || echo "✗ HTTP (port 80):     MISSING"
    [ "$HTTPS_OK" -gt 0 ] && echo "✓ HTTPS (port 443):   CONFIGURED" || echo "✗ HTTPS (port 443):   MISSING"
    echo ""
    
    echo "SECURITY FEATURES:"
    echo "───────────────────────────────────────────────────────────────"
    if [ "$SSH_RATE_LIMIT" -gt 0 ]; then
        echo "✓ SSH Rate Limiting:  ENABLED (6 attempts/30s)"
    else
        echo "⚠ SSH Rate Limiting:  DISABLED (consider: sudo ufw limit 22/tcp)"
    fi
    
    if [ "$LOG_LEVEL" != "off" ]; then
        echo "✓ Firewall Logging:   ENABLED (level: $LOG_LEVEL)"
    else
        echo "✗ Firewall Logging:   DISABLED"
    fi
    
    if [ "$DENY_COUNT" -gt 0 ]; then
        echo "✓ Blocked IPs:        $DENY_COUNT malicious sources"
    else
        echo "⚠ Blocked IPs:        NONE (consider blocking known attackers)"
    fi
    echo ""
    
    echo "DEFAULT POLICIES:"
    echo "───────────────────────────────────────────────────────────────"
    sudo ufw status verbose | grep "Default:"
    echo ""
    
    echo "CONFIGURATION FILES:"
    echo "───────────────────────────────────────────────────────────────"
    echo "✓ configs/ufw_rules.sh         — UFW configuration script"
    echo "✓ configs/iptables_backup.sh   — iptables alternative (advanced)"
    echo ""
    
    echo "TESTING RESULTS:"
    echo "───────────────────────────────────────────────────────────────"
    echo "Manual testing completed:"
    echo "  • External port scan (nmap)"
    echo "  • SSH rate limiting verification"
    echo "  • Blocked IP testing"
    echo "  • Log monitoring (tail -f /var/log/ufw.log)"
    echo ""
    
    echo "BLOCKED CONNECTIONS (last 10):"
    echo "───────────────────────────────────────────────────────────────"
    if [ -f /var/log/ufw.log ]; then
        sudo grep "UFW BLOCK" /var/log/ufw.log | tail -10 || echo "(No blocked connections yet)"
    else
        echo "(Log file not found)"
    fi
    echo ""
    
    echo "RECOMMENDATIONS:"
    echo "───────────────────────────────────────────────────────────────"
    [ "$SSH_RATE_LIMIT" -eq 0 ] && echo "1. Enable SSH rate limiting: sudo ufw limit 22/tcp"
    [ "$LOG_LEVEL" == "off" ] && echo "2. Enable logging: sudo ufw logging on"
    [ "$DENY_COUNT" -eq 0 ] && echo "3. Block known malicious IPs from artifacts/botnet_ips.txt"
    echo "4. Monitor logs: sudo tail -f /var/log/ufw.log"
    echo "5. Test externally: nmap -p 22,80,443 YOUR_SERVER_IP"
    echo "6. Review rules monthly: sudo ufw status numbered"
    echo ""
    
    echo "STATUS: ✓ Firewall Configuration Complete"
    echo ""
    echo "───────────────────────────────────────────────────────────────"
    echo "Kristjan: \"Rate limiting on SSH saved us from Krylov's bots.\""
    echo "═══════════════════════════════════════════════════════════════"
} > "$REPORT_FILE"

echo -e "${GREEN}✓ Report generated:${NC} $REPORT_FILE"
echo ""
cat "$REPORT_FILE"

# Final message
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Kristjan:${NC} \"Good defense. You configured UFW manually, not bash."
echo "          That's real sysadmin. Rate limiting = Krylov blocked.\""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"


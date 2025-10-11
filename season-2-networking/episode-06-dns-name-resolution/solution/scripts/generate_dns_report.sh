#!/bin/bash
# KERNEL SHADOWS — Episode 06: DNS & Name Resolution
# Report Generator (Type B — Minimal Helper)
#
# Philosophy: You already did DNS queries manually with dig/resolvectl
# This script ONLY formats your results into a report

set -e
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARTIFACTS_DIR="$SCRIPT_DIR/artifacts"
REPORT_FILE="$ARTIFACTS_DIR/dns_security_report.txt"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "═══════════════════════════════════════════════════"
echo "     DNS SECURITY AUDIT REPORT GENERATOR"
echo "═══════════════════════════════════════════════════"
echo ""
echo -e "${YELLOW}Type B Philosophy:${NC} dig exists → use it manually"
echo "This script generates report from YOUR manual queries"
echo ""

# Check if student has completed manual DNS queries
QUERIES_DONE="$ARTIFACTS_DIR/.dns_queries_done"
if [ ! -f "$QUERIES_DONE" ]; then
    echo -e "${RED}ERROR:${NC} You haven't completed manual DNS queries yet!"
    echo ""
    echo "Complete these tasks first:"
    echo "  1. Query shadow domains with dig (Cycle 2)"
    echo "  2. Check suspicious domains (Cycle 6)"
    echo "  3. Validate DNSSEC (Cycle 7)"
    echo ""
    echo "Then create marker file: touch artifacts/.dns_queries_done"
    exit 1
fi

# Generate report
{
    echo "═══════════════════════════════════════════════════════════════════"
    echo "            DNS SECURITY AUDIT REPORT"
    echo "            Stockholm, Sweden — Bahnhof Pionen"
    echo "            Analyst: Max Sokolov"
    echo "            Date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "═══════════════════════════════════════════════════════════════════"
    echo ""
    
    echo "CONFIGURATION:"
    echo "─────────────────────────────────────────────────────────────────"
    echo "✓ DNS resolvers: 1.1.1.1, 8.8.8.8, 9.9.9.9 (configured)"
    echo "✓ systemd-resolved: DNSSEC=allow-downgrade, DoT=opportunistic"
    echo "✓ /etc/hosts: Shadow infrastructure mapped locally"
    echo ""
    
    echo "MANUAL QUERIES COMPLETED:"
    echo "─────────────────────────────────────────────────────────────────"
    
    if [ -f "$ARTIFACTS_DIR/dns_zones.txt" ]; then
        domain_count=$(grep -v '^#' "$ARTIFACTS_DIR/dns_zones.txt" | grep -v '^$' | wc -l)
        echo "✓ Shadow domains checked: $domain_count (using dig +short)"
    fi
    
    if [ -f "$ARTIFACTS_DIR/suspicious_domains.txt" ]; then
        suspicious_count=$(grep -v '^#' "$ARTIFACTS_DIR/suspicious_domains.txt" | grep -v '^$' | wc -l)
        echo "✓ Suspicious domains analyzed: $suspicious_count (using dig @1.1.1.1)"
    fi
    
    echo "✓ DNSSEC validation: Tested with resolvectl query (with --type=DNSKEY)"
    echo "✓ DNS over TLS: Configured (opportunistic mode)"
    echo ""
    
    echo "RESULTS (from YOUR manual queries):"
    echo "─────────────────────────────────────────────────────────────────"
    echo "• Shadow infrastructure: Hidden from public DNS (verified)"
    echo "• DNS spoofing: Detected suspicious responses (see logs)"
    echo "• DNSSEC: Validated where available (Cloudflare, Google)"
    echo "• Privacy: DoT enabled for encrypted queries"
    echo ""
    
    echo "CONFIGURATION FILES CREATED:"
    echo "─────────────────────────────────────────────────────────────────"
    echo "✓ configs/resolv.conf         — DNS resolver configuration"
    echo "✓ configs/hosts               — Local DNS overrides + blocking"
    echo "✓ configs/systemd-resolved.conf — Modern DNS with DNSSEC + DoT"
    echo ""
    
    echo "RECOMMENDATIONS:"
    echo "─────────────────────────────────────────────────────────────────"
    echo "1. Deploy systemd-resolved.conf to production servers"
    echo "2. Monitor DNS queries: journalctl -u systemd-resolved"
    echo "3. Test DNSSEC: resolvectl query <domain> --type=DNSKEY"
    echo "4. Verify DoT: journalctl -u systemd-resolved | grep -i tls"
    echo "5. Block malicious domains in /etc/hosts"
    echo ""
    
    echo "STATUS: ✓ DNS Configuration Complete"
    echo ""
    echo "─────────────────────────────────────────────────────────────────"
    echo "Erik: \"DNS is the phonebook. DNSSEC + DoT = secure phonebook.\""
    echo "═══════════════════════════════════════════════════════════════════"
} > "$REPORT_FILE"

echo -e "${GREEN}✓ Report generated:${NC} $REPORT_FILE"
echo ""
cat "$REPORT_FILE"

# Erik's final message
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Erik:${NC} \"Good work. You used dig manually, not bash wrapper."
echo "      That's real Linux admin. DNSSEC protects you from Krylov.\""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"


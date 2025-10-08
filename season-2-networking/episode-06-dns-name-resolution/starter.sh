#!/bin/bash
################################################################################
# KERNEL SHADOWS — Episode 06: DNS & Name Resolution
#
# DNS Security Audit Script (STARTER TEMPLATE)
#
# Location: Bahnhof Pionen, Stockholm, Sweden 🇸🇪
# Day: 10-12 of 60
# Operator: Max Sokolov
#
# Mission: Create comprehensive DNS security audit
#
################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

# ═══════════════════════════════════════════════════════════════════════════
# Global Variables
# ═══════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_FILE="$SCRIPT_DIR/artifacts/dns_security_report.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color

# ═══════════════════════════════════════════════════════════════════════════
# Function 1: Check Shadow Servers (Task 2)
# ═══════════════════════════════════════════════════════════════════════════

check_shadow_servers() {
    echo -e "${BLUE}[1] Checking shadow servers...${NC}"

    local dns_zones_file="$SCRIPT_DIR/artifacts/dns_zones.txt"

    # TODO: Check if file exists
    # if [ ! -f "$dns_zones_file" ]; then
    #     echo "Error: $dns_zones_file not found"
    #     return 1
    # fi

    local total=0
    local not_in_dns=0

    # TODO: Read file line by line
    # while IFS= read -r domain; do
    #     # Skip comments and empty lines
    #     [[ -z "$domain" || "$domain" =~ ^# ]] && continue
    #
    #     total=$((total + 1))
    #
    #     # TODO: Check if domain is in public DNS
    #     # Use: dig +short "$domain"
    #     # If result is empty → domain is not in public DNS (good!)
    #
    #     # TODO: Count domains not in DNS
    #
    # done < "$dns_zones_file"

    # TODO: Return count of domains not in public DNS
    # echo "$not_in_dns"

    echo -e "${YELLOW}TODO: Implement shadow servers check${NC}"
    echo "0"  # Placeholder
}

# ═══════════════════════════════════════════════════════════════════════════
# Function 2: Check DNS Records (Task 3)
# ═══════════════════════════════════════════════════════════════════════════

check_dns_records() {
    echo -e "${BLUE}[2] Checking DNS records types...${NC}"

    local test_domain="google.com"

    # TODO: Check A records (IPv4)
    # Use: dig +short "$test_domain" A

    # TODO: Check AAAA records (IPv6)
    # Use: dig +short "$test_domain" AAAA

    # TODO: Check MX records (Mail)
    # Use: dig +short "$test_domain" MX

    # TODO: Check TXT records
    # Use: dig +short "$test_domain" TXT

    # TODO: Check NS records (Name servers)
    # Use: dig +short "$test_domain" NS

    # TODO: Count how many record types found
    # Return count

    echo -e "${YELLOW}TODO: Implement DNS records check${NC}"
    echo "0"  # Placeholder
}

# ═══════════════════════════════════════════════════════════════════════════
# Function 3: Reverse DNS Check (Task 4)
# ═══════════════════════════════════════════════════════════════════════════

check_reverse_dns() {
    echo -e "${BLUE}[3] Checking reverse DNS...${NC}"

    # Test IPs
    declare -a test_ips=(
        "8.8.8.8"
        "1.1.1.1"
        "9.9.9.9"
    )

    local checked=0
    local with_ptr=0

    # TODO: For each IP, check reverse DNS
    # for ip in "${test_ips[@]}"; do
    #     checked=$((checked + 1))
    #
    #     # TODO: Reverse DNS lookup
    #     # Use: dig -x "$ip" +short
    #     # If result is not empty → PTR record exists
    #
    #     # TODO: Count IPs with PTR records
    #
    # done

    # TODO: Return count of IPs with PTR records
    # echo "$with_ptr"

    echo -e "${YELLOW}TODO: Implement reverse DNS check${NC}"
    echo "0"  # Placeholder
}

# ═══════════════════════════════════════════════════════════════════════════
# Function 4: DNS Spoofing Detection (Task 6)
# ═══════════════════════════════════════════════════════════════════════════

detect_dns_spoofing() {
    echo -e "${BLUE}[4] Detecting DNS spoofing...${NC}"

    local suspicious_file="$SCRIPT_DIR/artifacts/suspicious_domains.txt"

    # TODO: Check if file exists
    # if [ ! -f "$suspicious_file" ]; then
    #     echo "Error: $suspicious_file not found"
    #     return 1
    # fi

    local checked=0
    local spoofed=0

    # TODO: Read file (format: domain expected_ip)
    # while IFS=' ' read -r domain expected_ip comment; do
    #     # Skip comments and empty lines
    #     [[ "$domain" =~ ^# || -z "$domain" ]] && continue
    #
    #     checked=$((checked + 1))
    #
    #     # TODO: Get actual IP from DNS
    #     # Use: dig +short "$domain" | head -n1
    #
    #     # TODO: Compare actual IP with expected IP
    #     # If they don't match → spoofed!
    #
    #     # TODO: Count spoofed domains
    #
    # done < "$suspicious_file"

    # TODO: Return count of spoofed domains
    # echo "$spoofed"

    echo -e "${YELLOW}TODO: Implement DNS spoofing detection${NC}"
    echo "0"  # Placeholder
}

# ═══════════════════════════════════════════════════════════════════════════
# Function 5: DNSSEC Validation (Task 7)
# ═══════════════════════════════════════════════════════════════════════════

check_dnssec() {
    echo -e "${BLUE}[5] Checking DNSSEC...${NC}"

    # Test domains
    declare -a test_domains=(
        "google.com"
        "cloudflare.com"
        "example.com"
    )

    local checked=0
    local secured=0

    # TODO: For each domain, check DNSSEC
    # for domain in "${test_domains[@]}"; do
    #     checked=$((checked + 1))
    #
    #     # TODO: Check for DNSSEC (RRSIG records)
    #     # Use: dig +dnssec "$domain" | grep "RRSIG"
    #     # If RRSIG found → DNSSEC enabled
    #
    #     # TODO: Count domains with DNSSEC
    #
    # done

    # TODO: Return count of domains with DNSSEC
    # echo "$secured"

    echo -e "${YELLOW}TODO: Implement DNSSEC check${NC}"
    echo "0"  # Placeholder
}

# ═══════════════════════════════════════════════════════════════════════════
# Function 6: Generate Report
# ═══════════════════════════════════════════════════════════════════════════

generate_report() {
    local shadow_ok=$1
    local dns_records_ok=$2
    local reverse_dns_ok=$3
    local spoofed=$4
    local dnssec_secured=$5

    echo ""
    echo -e "${BLUE}[6] Generating report...${NC}"

    # TODO: Create detailed report
    # Save to: $REPORT_FILE

    {
        echo "═══════════════════════════════════════════════════════════════"
        echo "           DNS SECURITY AUDIT REPORT"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "Date:       $TIMESTAMP"
        echo "Location:   Bahnhof Pionen, Stockholm, Sweden 🇸🇪"
        echo "Operator:   Max Sokolov"
        echo "Episode:    06 — DNS & Name Resolution"
        echo ""
        echo "════════════════════════════════════════════════════════════════"
        echo ""

        # TODO: Add detailed sections:
        # [1] Shadow Servers Check
        # [2] DNS Records Analysis
        # [3] Reverse DNS
        # [4] DNS Spoofing Detection
        # [5] DNSSEC Validation

        echo "[1] SHADOW SERVERS CHECK"
        echo "    Not in public DNS:   $shadow_ok"
        echo ""

        echo "[2] DNS RECORDS ANALYSIS"
        echo "    Record types found:  $dns_records_ok"
        echo ""

        echo "[3] REVERSE DNS"
        echo "    PTR records found:   $reverse_dns_ok"
        echo ""

        echo "[4] DNS SPOOFING DETECTION"
        echo "    Spoofed domains:     $spoofed"
        if [ "$spoofed" -gt 0 ]; then
            echo "    Status:              ⚠️  ATTACK DETECTED!"
        else
            echo "    Status:              ✓ NO SPOOFING DETECTED"
        fi
        echo ""

        echo "[5] DNSSEC VALIDATION"
        echo "    DNSSEC enabled:      $dnssec_secured/3"
        echo ""

        echo "════════════════════════════════════════════════════════════════"
        echo ""
        echo "SECURITY ASSESSMENT:"
        echo ""

        # TODO: Add security assessment logic
        # Determine risk level based on results
        # Low Risk: no spoofing, most domains have DNSSEC
        # Medium Risk: some issues found
        # High Risk: spoofing detected or critical issues

        if [ "$spoofed" -gt 0 ]; then
            echo "Overall Status: ⚠️  HIGH RISK"
            echo ""
            echo "Issues Found:"
            echo "  - DNS spoofing detected ($spoofed domains)"
            echo ""
            echo "Recommendations:"
            echo "  1. URGENT: Flush DNS cache"
            echo "     sudo systemd-resolve --flush-caches"
            echo "  2. Switch to trusted DNS (8.8.8.8, 1.1.1.1)"
            echo "  3. Enable DNSSEC validation"
            echo "  4. Report to Anna (forensics)"
        elif [ "$dnssec_secured" -lt 2 ]; then
            echo "Overall Status: ⚠️  MEDIUM RISK"
            echo ""
            echo "Recommendations:"
            echo "  - Enable DNSSEC on more domains"
            echo "  - Use DNSSEC-validating resolver"
        else
            echo "Overall Status: ✓ LOW RISK"
            echo ""
            echo "All checks passed. DNS infrastructure is secure."
        fi

        echo ""
        echo "════════════════════════════════════════════════════════════════"
        echo ""
        echo "Next Steps:"
        echo "  - Episode 07: Firewalls & iptables (return to Moscow)"
        echo ""
        echo "Generated by: dns_audit.sh"
        echo "END OF REPORT"
        echo ""

    } > "$REPORT_FILE"

    echo -e "${GREEN}✓ Report saved: $REPORT_FILE${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════
# Main Function
# ═══════════════════════════════════════════════════════════════════════════

main() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║  KERNEL SHADOWS — Episode 06: DNS & Name Resolution          ║"
    echo "║  DNS Security Audit Script                                    ║"
    echo "║                                                               ║"
    echo "║  Location: Bahnhof Pionen, Stockholm, Sweden 🇸🇪             ║"
    echo "║  Day: 10-12 of 60                                             ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    # Run checks
    shadow_ok=$(check_shadow_servers)
    dns_records=$(check_dns_records)
    reverse_dns=$(check_reverse_dns)
    spoofed=$(detect_dns_spoofing)
    dnssec=$(check_dnssec)

    # Generate report
    generate_report "$shadow_ok" "$dns_records" "$reverse_dns" "$spoofed" "$dnssec"

    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}DNS Security Audit Complete!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Review report: $REPORT_FILE"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# Entry Point
# ═══════════════════════════════════════════════════════════════════════════

main "$@"

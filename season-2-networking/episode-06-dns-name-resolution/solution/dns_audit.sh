#!/bin/bash
# KERNEL SHADOWS — Episode 06: DNS & Name Resolution
# Solution: dns_audit.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_FILE="$SCRIPT_DIR/artifacts/dns_security_report.txt"

check_shadow_servers() {
    local file="$SCRIPT_DIR/artifacts/dns_zones.txt"
    [ ! -f "$file" ] && echo "0" && return
    local count=0
    while IFS= read -r domain; do
        [[ -z "$domain" || "$domain" =~ ^# ]] && continue
        result=$(dig +short "$domain" 2>/dev/null)
        [ -z "$result" ] && count=$((count + 1))
    done < "$file"
    echo "$count"
}

detect_dns_spoofing() {
    local file="$SCRIPT_DIR/artifacts/suspicious_domains.txt"
    [ ! -f "$file" ] && echo "0" && return
    local spoofed=0
    while IFS=' ' read -r domain expected_ip _; do
        [[ "$domain" =~ ^# || -z "$domain" ]] && continue
        actual=$(dig +short "$domain" 2>/dev/null | head -n1)
        [ -n "$actual" ] && [ "$actual" != "$expected_ip" ] && spoofed=$((spoofed + 1))
    done < "$file"
    echo "$spoofed"
}

check_dnssec() {
    local domains=("google.com" "cloudflare.com")
    local secure=0
    for domain in "${domains[@]}"; do
        dig +dnssec "$domain" 2>/dev/null | grep -q "RRSIG" && secure=$((secure + 1))
    done
    echo "$secure"
}

generate_report() {
    {
        echo "═══════════════════════════════════════════════════════════════"
        echo "           DNS SECURITY AUDIT REPORT"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "Date:       $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Location:   Bahnhof Pionen, Stockholm, Sweden 🇸🇪"
        echo "Operator:   Max Sokolov"
        echo ""
        echo "[1] Shadow Servers: $1 not in public DNS ✓"
        echo "[2] DNS Spoofing:   $2 domains spoofed"
        [ "$2" -gt 0 ] && echo "    ⚠️  ATTACK DETECTED!"
        echo "[3] DNSSEC:         $3/2 domains secured"
        echo ""
        echo "════════════════════════════════════════════════════════════════"
        echo "END OF REPORT"
    } > "$REPORT_FILE"
}

main() {
    echo "Running DNS Security Audit..."
    shadow=$(check_shadow_servers)
    spoofed=$(detect_dns_spoofing)
    dnssec=$(check_dnssec)
    generate_report "$shadow" "$spoofed" "$dnssec"
    echo "✓ Report: $REPORT_FILE"
}

main "$@"

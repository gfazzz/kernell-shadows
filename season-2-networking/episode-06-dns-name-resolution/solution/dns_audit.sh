#!/bin/bash
# KERNEL SHADOWS — Episode 06: DNS & Name Resolution
# Solution: dns_audit.sh (Type B — Minimal Bash)
#
# Philosophy: Use DNS tools (dig, resolvectl) directly, NOT bash wrappers
# This script ONLY generates report from results YOU already collected

set -e
set -u

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARTIFACTS_DIR="$SCRIPT_DIR/artifacts"
REPORT_FILE="$ARTIFACTS_DIR/dns_security_report.txt"

echo "═══════════════════════════════════════════════════"
echo "     DNS SECURITY AUDIT - Type B Approach"
echo "═══════════════════════════════════════════════════"
echo ""
echo "Philosophy: dig exists → use it, don't wrap it"
echo "This script collects results and generates report"
echo ""

# Function 1: Check shadow servers in public DNS
# (Students already did this manually with dig in Cycle 2)
check_shadow_servers() {
    local file="$ARTIFACTS_DIR/dns_zones.txt"

    if [ ! -f "$file" ]; then
        echo "0"
        return
    fi

    local count=0
    local leaked=0

    while IFS= read -r domain; do
        # Skip comments and empty lines
        [[ -z "$domain" || "$domain" =~ ^# ]] && continue

        count=$((count + 1))

        # Query DNS (students did this manually)
        result=$(dig +short "$domain" 2>/dev/null)

        if [ -n "$result" ]; then
            echo "⚠️  LEAK: $domain → $result" >&2
            leaked=$((leaked + 1))
        fi
    done < "$file"

    echo "$count:$leaked"
}

# Function 2: Detect DNS spoofing
# (Students already did this manually with dig in Cycle 6)
detect_dns_spoofing() {
    local file="$ARTIFACTS_DIR/suspicious_domains.txt"

    if [ ! -f "$file" ]; then
        echo "0:0"
        return
    fi

    local checked=0
    local spoofed=0

    while IFS=' ' read -r domain expected_ip comment; do
        # Skip comments and empty lines
        [[ "$domain" =~ ^# || -z "$domain" ]] && continue

        checked=$((checked + 1))

        # Query DNS (students did this manually)
        actual=$(dig +short "$domain" 2>/dev/null | head -n1)

        if [ -n "$actual" ] && [ "$actual" != "$expected_ip" ]; then
            echo "⚠️  SPOOF: $domain expected $expected_ip, got $actual" >&2
            spoofed=$((spoofed + 1))
        fi
    done < "$file"

    echo "$checked:$spoofed"
}

# Function 3: Check DNSSEC support
# (Students already did this manually with dig +dnssec in Cycle 7)
check_dnssec() {
    local domains=("google.com" "cloudflare.com")
    local checked=0
    local secured=0

    for domain in "${domains[@]}"; do
        checked=$((checked + 1))

        # Query DNSSEC (students did this manually)
        if dig +dnssec "$domain" 2>/dev/null | grep -q "RRSIG"; then
            secured=$((secured + 1))
        fi
    done

    echo "$checked:$secured"
}

# Function 4: Check DNS configuration files
# (Students already did cat /etc/hosts, /etc/resolv.conf in Cycle 5)
check_dns_config() {
    local hosts_ok="OK"
    local resolv_ok="OK"

    # Check /etc/hosts for suspicious entries
    if grep -E "^[0-9]" /etc/hosts 2>/dev/null | grep -qv "127.0"; then
        # Check for non-localhost entries (might be legitimate)
        hosts_ok="CHECK"
    fi

    # Check /etc/resolv.conf exists
    if [ ! -f /etc/resolv.conf ]; then
        resolv_ok="MISSING"
    fi

    echo "$hosts_ok:$resolv_ok"
}

# Function 5: Check systemd-resolved status
# (Students already did resolvectl status in Cycle 5)
check_systemd_resolved() {
    if command -v resolvectl &>/dev/null; then
        if resolvectl status &>/dev/null; then
            echo "ACTIVE"
        else
            echo "ERROR"
        fi
    else
        echo "N/A"
    fi
}

# Function 6: Check DNS performance
# (Students already did dig with Query time check in Cycle 1)
check_dns_performance() {
    local domain="google.com"
    local query_time

    # Extract query time from dig output
    query_time=$(dig "$domain" 2>/dev/null | grep "Query time:" | awk '{print $4}')

    if [ -z "$query_time" ]; then
        echo "N/A"
    elif [ "$query_time" -lt 50 ]; then
        echo "${query_time}ms:EXCELLENT"
    elif [ "$query_time" -lt 100 ]; then
        echo "${query_time}ms:GOOD"
    elif [ "$query_time" -lt 200 ]; then
        echo "${query_time}ms:ACCEPTABLE"
    else
        echo "${query_time}ms:SLOW"
    fi
}

# Function 7: Generate comprehensive report
# (This is the MAIN purpose of Type B script — documentation)
generate_report() {
    local shadow_result="$1"
    local spoof_result="$2"
    local dnssec_result="$3"
    local config_result="$4"
    local resolved_status="$5"
    local perf_result="$6"

    # Parse results
    IFS=':' read -r shadow_checked shadow_leaked <<< "$shadow_result"
    IFS=':' read -r spoof_checked spoof_count <<< "$spoof_result"
    IFS=':' read -r dnssec_checked dnssec_secured <<< "$dnssec_result"
    IFS=':' read -r hosts_status resolv_status <<< "$config_result"
    IFS=':' read -r perf_time perf_rating <<< "$perf_result"

    {
        echo "═══════════════════════════════════════════════════════════════"
        echo "               DNS SECURITY AUDIT REPORT"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "Date:       $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Location:   Bahnhof Pionen, Stockholm, Sweden 🇸🇪"
        echo "Operator:   Max Sokolov"
        echo "Audited by: Erik Johansson, Katarina Lindström"
        echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " [1] DNS CONFIGURATION"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "  /etc/hosts:          $hosts_status"
        echo "  /etc/resolv.conf:    $resolv_status"
        echo "  systemd-resolved:    $resolved_status"
        echo ""

        if [ "$hosts_status" = "OK" ] && [ "$resolv_status" = "OK" ]; then
            echo "  Status: ✓ CONFIGURATION OK"
        else
            echo "  Status: ⚠️  CONFIGURATION NEEDS REVIEW"
        fi

        echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " [2] SHADOW SERVERS CHECK"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "  Internal domains checked:  $shadow_checked"
        echo "  Public DNS leaks found:    $shadow_leaked"
        echo ""

        if [ "$shadow_leaked" -eq 0 ]; then
            echo "  Status: ✓ NO LEAKS (internal domains not in public DNS)"
        else
            echo "  Status: ⚠️  INFORMATION LEAK DETECTED!"
            echo "          $shadow_leaked domains exposed in public DNS"
        fi

        echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " [3] DNS SPOOFING DETECTION"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "  Suspicious domains checked:  $spoof_checked"
        echo "  Spoofed domains found:       $spoof_count"
        echo ""

        if [ "$spoof_count" -eq 0 ]; then
            echo "  Status: ✓ NO SPOOFING DETECTED"
        else
            echo "  Status: ⚠️  DNS SPOOFING ATTACK!"
            echo "          $spoof_count domains return fake IPs"
            echo "          Likely cache poisoning by Krylov"
        fi

        echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " [4] DNSSEC VALIDATION"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "  Major domains checked:  $dnssec_checked"
        echo "  DNSSEC enabled:         $dnssec_secured"
        echo ""

        if [ "$dnssec_secured" -eq "$dnssec_checked" ]; then
            echo "  Status: ✓ DNSSEC ENABLED on all tested domains"
        else
            echo "  Status: ⚠️  Some domains lack DNSSEC protection"
        fi

        echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " [5] DNS PERFORMANCE"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "  Query time:  $perf_time"
        echo "  Rating:      $perf_rating"
        echo ""

        if [ "$perf_rating" = "EXCELLENT" ] || [ "$perf_rating" = "GOOD" ]; then
            echo "  Status: ✓ PERFORMANCE OK (< 100 ms)"
        elif [ "$perf_rating" = "ACCEPTABLE" ]; then
            echo "  Status: ⚠️  PERFORMANCE ACCEPTABLE (100-200 ms)"
        else
            echo "  Status: ⚠️  PERFORMANCE SLOW (> 200 ms)"
            echo "          Possible network issues or MITM attack"
        fi

        echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " [6] SECURITY ASSESSMENT"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""

        # Calculate overall security score
        local score=0
        local max_score=5

        [ "$shadow_leaked" -eq 0 ] && score=$((score + 1))
        [ "$spoof_count" -eq 0 ] && score=$((score + 1))
        [ "$dnssec_secured" -gt 0 ] && score=$((score + 1))
        [ "$hosts_status" = "OK" ] && score=$((score + 1))
        [ "$perf_rating" != "SLOW" ] && score=$((score + 1))

        echo "  Security Score: $score/$max_score"
        echo ""

        if [ "$score" -eq 5 ]; then
            echo "  Overall: ✓ EXCELLENT (No critical issues)"
        elif [ "$score" -ge 3 ]; then
            echo "  Overall: ⚠️  ACCEPTABLE (Some issues found)"
        else
            echo "  Overall: ❌ CRITICAL (Multiple security issues!)"
        fi

        echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " [7] RECOMMENDATIONS"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""

        [ "$shadow_leaked" -gt 0 ] && echo "  • Remove internal domains from public DNS"
        [ "$spoof_count" -gt 0 ] && echo "  • Flush DNS cache immediately (resolvectl flush-caches)"
        [ "$spoof_count" -gt 0 ] && echo "  • Switch to trusted DNS servers (8.8.8.8, 1.1.1.1)"
        [ "$dnssec_secured" -lt "$dnssec_checked" ] && echo "  • Enable DNSSEC for critical domains"
        [ "$perf_rating" = "SLOW" ] && echo "  • Investigate DNS performance issues"
        [ "$resolved_status" != "ACTIVE" ] && echo "  • Check systemd-resolved configuration"

        echo "  • Configure DNS over TLS (DoT) for query encryption"
        echo "  • Regular /etc/hosts audits for malware detection"
        echo "  • Monitor DNS query logs for anomalies"
        echo "  • Document all DNS configuration changes"

        echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " EPISODE 06 COMPLETED"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "Erik Johansson: 'Excellent work, Max. DNS security is foundation"
        echo "                 of network security. You now understand why.'"
        echo ""
        echo "Анна Ковалева:  'Нашла отпечатки Крылова в DNS логах."
        echo "                 Этот аудит помог идентифицировать векторы атак.'"
        echo ""
        echo "LILITH:         'DNS Module complete. Remember: dig exists → use it."
        echo "                 Type B = configure tools, not replace them.'"
        echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo " END OF REPORT"
        echo "═══════════════════════════════════════════════════════════════"

    } > "$REPORT_FILE"
}

# Main execution
main() {
    echo "Running DNS Security Audit..."
    echo ""

    # Execute all checks (using dig, resolvectl directly)
    echo -e "${YELLOW}[1/6]${NC} Checking shadow servers..."
    shadow_result=$(check_shadow_servers)

    echo -e "${YELLOW}[2/6]${NC} Detecting DNS spoofing..."
    spoof_result=$(detect_dns_spoofing)

    echo -e "${YELLOW}[3/6]${NC} Validating DNSSEC..."
    dnssec_result=$(check_dnssec)

    echo -e "${YELLOW}[4/6]${NC} Checking DNS configuration..."
    config_result=$(check_dns_config)

    echo -e "${YELLOW}[5/6]${NC} Checking systemd-resolved..."
    resolved_status=$(check_systemd_resolved)

    echo -e "${YELLOW}[6/6]${NC} Measuring DNS performance..."
    perf_result=$(check_dns_performance)

    echo ""
    echo "Generating comprehensive report..."

    generate_report "$shadow_result" "$spoof_result" "$dnssec_result" \
                    "$config_result" "$resolved_status" "$perf_result"

    echo ""
    echo -e "${GREEN}✓ DNS Security Audit Complete!${NC}"
    echo ""
    echo "Report saved to: $REPORT_FILE"
    echo ""
    cat "$REPORT_FILE"
}

# Run main
main "$@"

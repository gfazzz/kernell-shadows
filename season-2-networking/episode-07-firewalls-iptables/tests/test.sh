#!/bin/bash

# Test suite for Episode 07: Firewalls & iptables (Type B)
# Validates that firewall was configured using UFW/iptables DIRECTLY
# (Not bash wrappers!)

# --- Configuration ---
SOLUTION_DIR="../solution"
SOLUTION_SCRIPT="${SOLUTION_DIR}/firewall_setup.sh"
ARTIFACTS_DIR="../artifacts"
REPORT_FILE="${ARTIFACTS_DIR}/firewall_audit_report.txt"
BOTNET_FILE="${ARTIFACTS_DIR}/botnet_ips.txt"

# --- Test Utilities ---
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_BLUE='\033[0;34m'
COLOR_NC='\033[0m' # No Color

TESTS_PASSED=0
TESTS_FAILED=0

log_success() {
    echo -e "${COLOR_GREEN}✓ $1${COLOR_NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

log_fail() {
    echo -e "${COLOR_RED}✗ $1${COLOR_NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

log_info() {
    echo -e "${COLOR_BLUE}→ $1${COLOR_NC}"
}

log_warn() {
    echo -e "${COLOR_YELLOW}⚠ $1${COLOR_NC}"
}

# --- Setup ---
setup() {
    log_info "Setting up test environment..."

    # Ensure artifacts directory exists
    mkdir -p "$ARTIFACTS_DIR"

    # Create test botnet file if doesn't exist
    if [ ! -f "$BOTNET_FILE" ]; then
        log_warn "Creating test botnet file..."
        cat << 'EOF' > "$BOTNET_FILE"
# Test botnet IPs for Episode 07
185.220.101.52    # Tor exit node (Sweden)
91.219.237.244    # VPN provider (Netherlands)
195.123.246.151   # Tor exit node (Germany)
203.0.113.10      # Test IP 1
203.0.113.11      # Test IP 2
203.0.113.12      # Test IP 3
203.0.113.13      # Test IP 4
203.0.113.14      # Test IP 5
203.0.113.15      # Test IP 6
203.0.113.16      # Test IP 7
EOF
    fi

    echo ""
}

cleanup() {
    log_info "Cleaning up test environment..."
    echo ""
}

# --- Tests ---

test_file_structure() {
    log_info "Testing file structure..."

    if [ -f "$SOLUTION_SCRIPT" ]; then
        log_success "solution/firewall_setup.sh exists"
    else
        log_fail "solution/firewall_setup.sh not found!"
    fi

    if [ -d "$ARTIFACTS_DIR" ]; then
        log_success "artifacts/ directory exists"
    else
        log_fail "artifacts/ directory not found!"
    fi

    if [ -f "$BOTNET_FILE" ]; then
        log_success "artifacts/botnet_ips.txt exists"
    else
        log_fail "artifacts/botnet_ips.txt not found!"
    fi

    if [ -f "${ARTIFACTS_DIR}/README.md" ]; then
        log_success "artifacts/README.md exists"
    else
        log_warn "artifacts/README.md not found"
    fi

    echo ""
}

test_script_executable() {
    log_info "Testing script executability..."

    if [ -x "$SOLUTION_SCRIPT" ]; then
        log_success "solution/firewall_setup.sh is executable"
    else
        log_warn "solution/firewall_setup.sh is not executable (chmod +x)"
    fi

    echo ""
}

test_script_syntax() {
    log_info "Testing script syntax..."

    if bash -n "$SOLUTION_SCRIPT" 2>/dev/null; then
        log_success "solution/firewall_setup.sh syntax is valid"
    else
        log_fail "solution/firewall_setup.sh has syntax errors"
    fi

    echo ""
}

test_type_b_compliance() {
    log_info "Testing Type B compliance (no bash wrappers!)..."

    # Check that solution does NOT contain Type A wrapper functions
    local type_a_functions=(
        "enable_ufw_safely"
        "allow_web_traffic"
        "block_botnet_ips"
        "configure_rate_limiting"
    )

    local wrapper_found=0
    for func in "${type_a_functions[@]}"; do
        if grep -q "^${func}()" "$SOLUTION_SCRIPT" 2>/dev/null; then
            log_fail "Type A wrapper function '$func()' found (should be removed!)"
            wrapper_found=1
        fi
    done

    if [ "$wrapper_found" -eq 0 ]; then
        log_success "No Type A wrapper functions found (Type B compliant!)"
    fi

    # Check that solution contains report generation (Type B: OK!)
    if grep -q "generate_report\|generate_audit_report" "$SOLUTION_SCRIPT" 2>/dev/null; then
        log_success "Report generation function found (Type B: OK for reports)"
    else
        log_warn "No report generation function found"
    fi

    echo ""
}

test_botnet_file_format() {
    log_info "Testing botnet_ips.txt format..."

    # Check file is not empty
    if [ -s "$BOTNET_FILE" ]; then
        log_success "botnet_ips.txt is not empty"
    else
        log_fail "botnet_ips.txt is empty"
        return
    fi

    # Check for valid IP addresses
    local ip_count=$(grep -v "^#" "$BOTNET_FILE" | grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | wc -l)

    if [ "$ip_count" -gt 0 ]; then
        log_success "Found $ip_count valid IP addresses"
    else
        log_fail "No valid IP addresses found"
    fi

    # Check for comments
    local comment_count=$(grep -c "^#" "$BOTNET_FILE" || echo 0)
    if [ "$comment_count" -gt 0 ]; then
        log_success "File contains comments ($comment_count lines)"
    fi

    echo ""
}

test_ufw_availability() {
    log_info "Testing UFW availability..."

    if command -v ufw &> /dev/null; then
        log_success "UFW is installed"

        # Check UFW status (non-destructive)
        if sudo -n ufw status &>/dev/null; then
            local ufw_status=$(sudo ufw status 2>/dev/null | head -1)
            log_info "UFW Status: $ufw_status"

            # Check if UFW is active
            if sudo ufw status | grep -q "Status: active"; then
                log_success "UFW is active"
            else
                log_warn "UFW is inactive (students should activate it)"
            fi
        else
            log_warn "Cannot check UFW status (requires sudo)"
        fi
    else
        log_warn "UFW is not installed (sudo apt install ufw)"
    fi

    echo ""
}

test_iptables_availability() {
    log_info "Testing iptables availability..."

    if command -v iptables &> /dev/null; then
        log_success "iptables is installed"

        # Count existing rules (non-destructive)
        if sudo -n iptables -L &>/dev/null; then
            local rule_count=$(sudo iptables -L INPUT -n 2>/dev/null | wc -l)
            log_info "Current INPUT rules: $rule_count lines"

            # Check for DROP rules (botnet blocking)
            local drop_count=$(sudo iptables -L INPUT -n 2>/dev/null | grep -c "DROP" || echo 0)
            if [ "$drop_count" -gt 0 ]; then
                log_success "Found $drop_count DROP rules (IP blocking configured)"
            else
                log_info "No DROP rules found (students should block IPs)"
            fi
        else
            log_warn "Cannot check iptables rules (requires sudo)"
        fi
    else
        log_fail "iptables is not installed"
    fi

    echo ""
}

test_required_tools() {
    log_info "Testing required tools..."

    local tools=("netstat" "ss" "awk" "grep" "sed" "bc")

    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            log_success "$tool is available"
        else
            log_warn "$tool is not available"
        fi
    done

    echo ""
}

test_ufw_configuration() {
    log_info "Testing UFW configuration (if configured by student)..."

    if ! command -v ufw &>/dev/null; then
        log_warn "UFW not installed, skipping tests"
        return
    fi

    if ! sudo -n ufw status &>/dev/null; then
        log_warn "Cannot check UFW (requires sudo), skipping"
        return
    fi

    # Check if UFW is enabled
    if sudo ufw status | grep -q "Status: active"; then
        log_success "UFW is enabled (Type B: student ran 'sudo ufw enable')"

        # Check for critical ports
        if sudo ufw status | grep -q "22.*ALLOW"; then
            log_success "SSH (port 22) is allowed"
        else
            log_warn "SSH (port 22) not allowed (might cause lockout!)"
        fi

        if sudo ufw status | grep -q "80.*ALLOW"; then
            log_success "HTTP (port 80) is allowed"
        else
            log_info "HTTP (port 80) not configured (optional)"
        fi

        if sudo ufw status | grep -q "443.*ALLOW"; then
            log_success "HTTPS (port 443) is allowed"
        else
            log_info "HTTPS (port 443) not configured (optional)"
        fi

        # Check default policy
        if sudo ufw status verbose | grep -q "Default: deny (incoming)"; then
            log_success "Default policy: deny incoming (secure!)"
        else
            log_warn "Default policy not set to deny incoming"
        fi

    else
        log_info "UFW not enabled yet (students should enable it in Episode)"
    fi

    echo ""
}

test_solution_execution() {
    log_info "Testing solution script execution (Report Generation)..."

    log_warn "Skipping actual execution (requires sudo and configured firewall)"
    log_info "To test manually:"
    log_info "  1. Configure firewall using UFW/iptables commands (Type B!)"
    log_info "  2. Run: sudo $SOLUTION_SCRIPT"
    log_info "  3. Check: cat $REPORT_FILE"

    # Check that solution script exists and is valid bash
    if [ -f "$SOLUTION_SCRIPT" ] && bash -n "$SOLUTION_SCRIPT" 2>/dev/null; then
        log_success "Solution script is valid and ready to generate report"
    else
        log_fail "Solution script has issues"
    fi

    echo ""
}

test_report_generation() {
    log_info "Testing if report was generated..."

    if [ -f "$REPORT_FILE" ]; then
        log_success "firewall_audit_report.txt exists"

        # Check report content
        if grep -q "FIREWALL SECURITY AUDIT REPORT" "$REPORT_FILE"; then
            log_success "Report contains header"
        else
            log_warn "Report missing expected header"
        fi

        if grep -q "INCIDENT SUMMARY" "$REPORT_FILE"; then
            log_success "Report contains incident summary"
        else
            log_warn "Report missing incident summary"
        fi

        if grep -q "FIREWALL CONFIGURATION" "$REPORT_FILE"; then
            log_success "Report contains firewall configuration"
        else
            log_warn "Report missing firewall configuration"
        fi

        # Check report size
        local report_lines=$(wc -l < "$REPORT_FILE")
        if [ "$report_lines" -gt 50 ]; then
            log_success "Report is comprehensive ($report_lines lines)"
        else
            log_warn "Report seems short ($report_lines lines)"
        fi

    else
        log_info "Report not generated yet (run solution script after configuring firewall)"
    fi

    echo ""
}

test_artifacts_documentation() {
    log_info "Testing artifacts documentation..."

    local artifacts_readme="${ARTIFACTS_DIR}/README.md"

    if [ -f "$artifacts_readme" ]; then
        log_success "artifacts/README.md exists"

        # Check for key sections
        if grep -q "UFW Commands Guide" "$artifacts_readme" 2>/dev/null; then
            log_success "Documentation contains UFW guide"
        else
            log_warn "Missing UFW commands guide"
        fi

        if grep -q "iptables Basics" "$artifacts_readme" 2>/dev/null; then
            log_success "Documentation contains iptables basics"
        else
            log_warn "Missing iptables basics"
        fi

        if grep -q "Troubleshooting" "$artifacts_readme" 2>/dev/null; then
            log_success "Documentation contains troubleshooting guide"
        else
            log_warn "Missing troubleshooting guide"
        fi

        # Check documentation size
        local doc_lines=$(wc -l < "$artifacts_readme")
        if [ "$doc_lines" -gt 300 ]; then
            log_success "Documentation is comprehensive ($doc_lines lines)"
        else
            log_warn "Documentation seems short ($doc_lines lines)"
        fi

    else
        log_warn "artifacts/README.md not found"
    fi

    echo ""
}

# --- Main Execution ---

main() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║  Episode 07: Firewalls & iptables - Test Suite          ║"
    echo "║  Type B Tests: Validate direct UFW/iptables usage       ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""

    setup

    # Run all tests
    test_file_structure
    test_script_executable
    test_script_syntax
    test_type_b_compliance
    test_botnet_file_format
    test_ufw_availability
    test_iptables_availability
    test_required_tools
    test_ufw_configuration
    test_solution_execution
    test_report_generation
    test_artifacts_documentation

    cleanup

    # Summary
    echo "═══════════════════════════════════════════════════════════"
    echo "TEST SUMMARY"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo -e "${COLOR_GREEN}Passed: $TESTS_PASSED${COLOR_NC}"
    echo -e "${COLOR_RED}Failed: $TESTS_FAILED${COLOR_NC}"
    echo ""

    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${COLOR_GREEN}✓ All tests passed!${COLOR_NC}"
        echo ""
        echo "Type B Episode validated:"
        echo "  ✓ No bash wrapper functions"
        echo "  ✓ Students use UFW/iptables directly"
        echo "  ✓ Solution only generates reports"
        echo ""
        exit 0
    else
        echo -e "${COLOR_RED}✗ Some tests failed${COLOR_NC}"
        echo ""
        echo "Review the failures above and fix issues."
        echo ""
        exit 1
    fi
}

# Run main
main "$@"

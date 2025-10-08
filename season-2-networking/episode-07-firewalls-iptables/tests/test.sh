#!/bin/bash

# Test suite for Episode 07: Firewalls & iptables
# Validates firewall configuration and security measures

# --- Configuration ---
SOLUTION_DIR="../solution"
STARTER_SCRIPT="../starter.sh"
SOLUTION_SCRIPT="${SOLUTION_DIR}/firewall_setup.sh"
ARTIFACTS_DIR="../artifacts"
REPORT_FILE="${ARTIFACTS_DIR}/firewall_audit_report.txt"
BOTNET_FILE="${ARTIFACTS_DIR}/botnet_ips.txt"
BLOCKED_LOG="${ARTIFACTS_DIR}/blocked_ips.log"

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
# Test botnet IPs
203.0.113.10
203.0.113.11
203.0.113.12
203.0.113.13
203.0.113.14
EOF
    fi
    
    # Clean up previous test artifacts
    rm -f "$REPORT_FILE" "$BLOCKED_LOG"
    
    echo ""
}

cleanup() {
    log_info "Cleaning up test environment..."
    
    # Note: We don't actually clean up iptables rules here
    # as it requires sudo and could affect running system
    # Manual cleanup: sudo iptables -F
    
    echo ""
}

# --- Tests ---

test_file_structure() {
    log_info "Running file structure tests..."
    
    if [ -f "$STARTER_SCRIPT" ]; then
        log_success "starter.sh exists"
    else
        log_fail "starter.sh not found!"
    fi
    
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
    
    echo ""
}

test_script_executable() {
    log_info "Testing script executability..."
    
    if [ -x "$STARTER_SCRIPT" ]; then
        log_success "starter.sh is executable"
    else
        log_warn "starter.sh is not executable (chmod +x)"
    fi
    
    if [ -x "$SOLUTION_SCRIPT" ]; then
        log_success "solution/firewall_setup.sh is executable"
    else
        log_warn "solution/firewall_setup.sh is not executable (chmod +x)"
    fi
    
    echo ""
}

test_script_syntax() {
    log_info "Testing script syntax..."
    
    # Test starter.sh syntax
    if bash -n "$STARTER_SCRIPT" 2>/dev/null; then
        log_success "starter.sh syntax is valid"
    else
        log_fail "starter.sh has syntax errors"
    fi
    
    # Test solution.sh syntax
    if bash -n "$SOLUTION_SCRIPT" 2>/dev/null; then
        log_success "solution/firewall_setup.sh syntax is valid"
    else
        log_fail "solution/firewall_setup.sh has syntax errors"
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
        local ufw_status=$(sudo ufw status 2>/dev/null | head -1)
        log_info "UFW Status: $ufw_status"
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
        local rule_count=$(sudo iptables -L INPUT -n 2>/dev/null | wc -l)
        log_info "Current INPUT rules: $rule_count lines"
    else
        log_fail "iptables is not installed"
    fi
    
    echo ""
}

test_required_tools() {
    log_info "Testing required tools..."
    
    local tools=("netstat" "ss" "awk" "grep" "sed")
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            log_success "$tool is available"
        else
            log_warn "$tool is not available"
        fi
    done
    
    echo ""
}

test_solution_execution() {
    log_info "Testing solution script execution (DRY RUN)..."
    
    log_warn "Skipping actual execution (requires sudo and could affect system)"
    log_info "To test manually: sudo $SOLUTION_SCRIPT"
    
    # We can test that the script would run without actually executing it
    # by checking if all required functions are defined
    
    local required_functions=(
        "check_firewall_status"
        "enable_ufw_safely"
        "allow_web_traffic"
        "block_botnet_ips"
        "configure_rate_limiting"
        "configure_logging"
        "monitor_firewall"
        "generate_audit_report"
    )
    
    for func in "${required_functions[@]}"; do
        if grep -q "^${func}()" "$SOLUTION_SCRIPT"; then
            log_success "Function '$func' is defined"
        else
            log_fail "Function '$func' is not defined"
        fi
    done
    
    echo ""
}

test_report_generation() {
    log_info "Testing report generation logic..."
    
    # Check if solution script contains report generation code
    if grep -q "FIREWALL SECURITY AUDIT REPORT" "$SOLUTION_SCRIPT"; then
        log_success "Report template is present"
    else
        log_fail "Report template is missing"
    fi
    
    # Check for required report sections
    local sections=(
        "INCIDENT SUMMARY"
        "FIREWALL CONFIGURATION"
        "BLOCKED IPS STATISTICS"
        "CURRENT SYSTEM STATUS"
        "SECURITY ASSESSMENT"
    )
    
    for section in "${sections[@]}"; do
        if grep -q "$section" "$SOLUTION_SCRIPT"; then
            log_success "Report section '$section' is present"
        else
            log_warn "Report section '$section' is missing"
        fi
    done
    
    echo ""
}

test_security_features() {
    log_info "Testing security features in solution..."
    
    # Check for UFW configuration
    if grep -q "ufw default deny" "$SOLUTION_SCRIPT"; then
        log_success "UFW default deny policy is configured"
    else
        log_warn "UFW default deny policy not found"
    fi
    
    # Check for SSH protection before UFW enable
    if grep -q "ufw allow 22" "$SOLUTION_SCRIPT"; then
        log_success "SSH is allowed before UFW enable"
    else
        log_warn "SSH allow rule not found (could lock out!)"
    fi
    
    # Check for rate limiting
    if grep -q "connlimit" "$SOLUTION_SCRIPT"; then
        log_success "Connection limiting (connlimit) is configured"
    else
        log_warn "Connection limiting not found"
    fi
    
    if grep -q "recent" "$SOLUTION_SCRIPT"; then
        log_success "Rate limiting (recent) is configured"
    else
        log_warn "Rate limiting (recent) not found"
    fi
    
    # Check for logging
    if grep -q "LOG" "$SOLUTION_SCRIPT"; then
        log_success "Logging is configured"
    else
        log_warn "Logging not found"
    fi
    
    echo ""
}

test_error_handling() {
    log_info "Testing error handling..."
    
    # Check for set -e (exit on error)
    if grep -q "set -e" "$SOLUTION_SCRIPT"; then
        log_success "Error handling (set -e) is enabled"
    else
        log_warn "Error handling (set -e) not found"
    fi
    
    # Check for file existence checks
    if grep -q "if \[\[.*-f.*\]\]" "$SOLUTION_SCRIPT"; then
        log_success "File existence checks are present"
    else
        log_warn "File existence checks not found"
    fi
    
    # Check for IP validation
    if grep -q "^[0-9].*\.[0-9]" "$SOLUTION_SCRIPT"; then
        log_success "IP address validation is present"
    else
        log_warn "IP address validation not found"
    fi
    
    echo ""
}

# --- Main Test Execution ---
main() {
    echo -e "${COLOR_BLUE}╔═══════════════════════════════════════════════════════════╗${COLOR_NC}"
    echo -e "${COLOR_BLUE}║  Episode 07: Firewalls & iptables - Test Suite          ║${COLOR_NC}"
    echo -e "${COLOR_BLUE}╚═══════════════════════════════════════════════════════════╝${COLOR_NC}"
    echo ""
    
    setup
    
    # Run all tests
    test_file_structure
    test_script_executable
    test_script_syntax
    test_botnet_file_format
    test_ufw_availability
    test_iptables_availability
    test_required_tools
    test_solution_execution
    test_report_generation
    test_security_features
    test_error_handling
    
    # Summary
    echo ""
    echo -e "${COLOR_BLUE}═══════════════════════════════════════════════════════════${COLOR_NC}"
    echo -e "${COLOR_BLUE}TEST SUMMARY${COLOR_NC}"
    echo -e "${COLOR_BLUE}═══════════════════════════════════════════════════════════${COLOR_NC}"
    echo -e "${COLOR_GREEN}Passed: $TESTS_PASSED${COLOR_NC}"
    echo -e "${COLOR_RED}Failed: $TESTS_FAILED${COLOR_NC}"
    echo ""
    
    if [ "$TESTS_FAILED" -eq 0 ]; then
        echo -e "${COLOR_GREEN}✓ All critical tests passed!${COLOR_NC}"
        echo ""
        echo "Next steps:"
        echo "  1. Run the solution manually (requires sudo):"
        echo "     sudo $SOLUTION_SCRIPT"
        echo ""
        echo "  2. Check the generated report:"
        echo "     cat $REPORT_FILE"
        echo ""
        echo "  3. Monitor firewall status:"
        echo "     sudo ufw status verbose"
        echo "     sudo iptables -L -n -v"
        echo ""
        exit 0
    else
        echo -e "${COLOR_RED}✗ Some tests failed. Review the output above.${COLOR_NC}"
        echo ""
        exit 1
    fi
    
    cleanup
}

# Run tests
main "$@"

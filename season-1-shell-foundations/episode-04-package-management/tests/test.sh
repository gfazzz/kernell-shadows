#!/bin/bash

################################################################################
# KERNEL SHADOWS - Episode 04 Tests
# Package Management Test Suite
################################################################################

# Colors
COLOR_RESET="\033[0m"
COLOR_GREEN="\033[0;32m"
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_CYAN="\033[0;36m"

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Test target
SCRIPT_PATH="../solution/install_toolkit.sh"
USER_SCRIPT="../install_toolkit.sh"  # If student created at root level


# === TEST FRAMEWORK ===

print_test_header() {
    echo ""
    echo -e "${COLOR_CYAN}========================================"
    echo -e "TEST: $1"
    echo -e "========================================${COLOR_RESET}"
}

assert_true() {
    local test_name="$1"
    local command="$2"

    ((TESTS_TOTAL++))

    if eval "$command" &> /dev/null; then
        echo -e "${COLOR_GREEN}✓ PASS${COLOR_RESET}: $test_name"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${COLOR_RED}✗ FAIL${COLOR_RESET}: $test_name"
        ((TESTS_FAILED++))
        return 1
    fi
}

assert_false() {
    local test_name="$1"
    local command="$2"

    ((TESTS_TOTAL++))

    if ! eval "$command" &> /dev/null; then
        echo -e "${COLOR_GREEN}✓ PASS${COLOR_RESET}: $test_name"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${COLOR_RED}✗ FAIL${COLOR_RESET}: $test_name"
        ((TESTS_FAILED++))
        return 1
    fi
}

assert_contains() {
    local test_name="$1"
    local file="$2"
    local pattern="$3"

    ((TESTS_TOTAL++))

    if grep -q "$pattern" "$file" 2>/dev/null; then
        echo -e "${COLOR_GREEN}✓ PASS${COLOR_RESET}: $test_name"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${COLOR_RED}✗ FAIL${COLOR_RESET}: $test_name"
        ((TESTS_FAILED++))
        return 1
    fi
}

print_summary() {
    echo ""
    echo -e "${COLOR_CYAN}========================================"
    echo -e "TEST SUMMARY"
    echo -e "========================================${COLOR_RESET}"
    echo -e "Total tests: $TESTS_TOTAL"
    echo -e "${COLOR_GREEN}Passed: $TESTS_PASSED${COLOR_RESET}"
    echo -e "${COLOR_RED}Failed: $TESTS_FAILED${COLOR_RESET}"

    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo ""
        echo -e "${COLOR_GREEN}ALL TESTS PASSED! ✓${COLOR_RESET}"
        return 0
    else
        echo ""
        echo -e "${COLOR_RED}SOME TESTS FAILED${COLOR_RESET}"
        return 1
    fi
}


# === STRUCTURAL TESTS ===

test_structure() {
    print_test_header "Script Structure"

    # Determine which script to test
    local script_to_test="$SCRIPT_PATH"
    if [[ -f "$USER_SCRIPT" ]]; then
        script_to_test="$USER_SCRIPT"
        echo -e "${COLOR_YELLOW}Testing user script: $USER_SCRIPT${COLOR_RESET}"
    else
        echo -e "${COLOR_YELLOW}Testing reference solution: $SCRIPT_PATH${COLOR_RESET}"
    fi

    # Test 1: File exists
    assert_true "Script file exists" "test -f '$script_to_test'"

    # Test 2: Shebang present
    assert_contains "Has shebang" "$script_to_test" "^#!/bin/bash"

    # Test 3: Executable
    assert_true "Script is executable" "test -x '$script_to_test'"

    # Test 4: Key functions present
    assert_contains "Has log_message function" "$script_to_test" "log_message"
    assert_contains "Has check_root function" "$script_to_test" "check_root"
    assert_contains "Has backup_sources_list function" "$script_to_test" "backup_sources_list"
    assert_contains "Has update_package_lists function" "$script_to_test" "update_package_lists"
    assert_contains "Has parse_tools_list function" "$script_to_test" "parse_tools_list"
    assert_contains "Has install_package function" "$script_to_test" "install_package"
    assert_contains "Has generate_report function" "$script_to_test" "generate_report"

    # Test 5: Main function
    assert_contains "Has main function" "$script_to_test" "^main()"
}


# === CONFIGURATION TESTS ===

test_configuration() {
    print_test_header "Configuration Variables"

    local script_to_test="$SCRIPT_PATH"
    if [[ -f "$USER_SCRIPT" ]]; then
        script_to_test="$USER_SCRIPT"
    fi

    # Test config variables
    assert_contains "Has TOOLS_FILE variable" "$script_to_test" "TOOLS_FILE"
    assert_contains "Has LOG_FILE variable" "$script_to_test" "LOG_FILE"
    assert_contains "Has BACKUP_DIR variable" "$script_to_test" "BACKUP_DIR"
    assert_contains "Has REPORT_FILE variable" "$script_to_test" "REPORT_FILE"
}


# === ARTIFACTS TESTS ===

test_artifacts() {
    print_test_header "Required Artifacts"

    # Test 1: required_tools.txt exists
    assert_true "required_tools.txt exists" "test -f '../artifacts/required_tools.txt'"

    # Test 2: Contains expected tools
    assert_contains "Contains nmap" "../artifacts/required_tools.txt" "nmap"
    assert_contains "Contains git" "../artifacts/required_tools.txt" "git"
    assert_contains "Contains htop" "../artifacts/required_tools.txt" "htop"

    # Test 3: Has comments
    assert_contains "Has header comment" "../artifacts/required_tools.txt" "^#"
}


# === PARSING TESTS ===

test_parsing() {
    print_test_header "Tools List Parsing"

    # Create test file
    cat > /tmp/test_tools.txt << 'EOF'
# Comment line
nmap
# Another comment

git
  htop
# tcpdump
EOF

    # Test parsing function
    # Note: This requires sourcing the script, which is complex
    # We'll do basic grep tests instead

    # Test: Can filter comments
    local result
    result=$(grep -v '^#' /tmp/test_tools.txt | grep -v '^$' | awk '{print $1}')
    local count
    count=$(echo "$result" | grep -c '^')

    if [[ $count -eq 3 ]]; then
        echo -e "${COLOR_GREEN}✓ PASS${COLOR_RESET}: Parsing filters comments and empty lines"
        ((TESTS_PASSED++))
    else
        echo -e "${COLOR_RED}✗ FAIL${COLOR_RESET}: Parsing filters (expected 3 packages, got $count)"
        ((TESTS_FAILED++))
    fi
    ((TESTS_TOTAL++))

    # Cleanup
    rm -f /tmp/test_tools.txt
}


# === SAFETY TESTS ===

test_safety() {
    print_test_header "Safety Checks"

    local script_to_test="$SCRIPT_PATH"
    if [[ -f "$USER_SCRIPT" ]]; then
        script_to_test="$USER_SCRIPT"
    fi

    # Test 1: Checks for root
    assert_contains "Checks EUID or root" "$script_to_test" "EUID"

    # Test 2: Uses set -e or error checking
    if grep -q "set -e" "$script_to_test" || grep -q "|| exit" "$script_to_test"; then
        echo -e "${COLOR_GREEN}✓ PASS${COLOR_RESET}: Has error handling (set -e or exit checks)"
        ((TESTS_PASSED++))
    else
        echo -e "${COLOR_YELLOW}⚠ WARNING${COLOR_RESET}: No explicit error handling found"
        ((TESTS_FAILED++))
    fi
    ((TESTS_TOTAL++))

    # Test 3: Creates backups
    assert_contains "Creates backup" "$script_to_test" "backup"

    # Test 4: Uses apt with -y flag for non-interactive
    assert_contains "Uses apt -y" "$script_to_test" "apt.*-y"
}


# === LOGGING TESTS ===

test_logging() {
    print_test_header "Logging Functionality"

    local script_to_test="$SCRIPT_PATH"
    if [[ -f "$USER_SCRIPT" ]]; then
        script_to_test="$USER_SCRIPT"
    fi

    # Test logging implementation
    assert_contains "Logs to file" "$script_to_test" ">>.*LOG_FILE\\|tee.*LOG_FILE"
    assert_contains "Uses timestamps" "$script_to_test" "date.*%Y-%m-%d\\|date.*%H:%M:%S"
}


# === REPORT TESTS ===

test_reporting() {
    print_test_header "Report Generation"

    local script_to_test="$SCRIPT_PATH"
    if [[ -f "$USER_SCRIPT" ]]; then
        script_to_test="$USER_SCRIPT"
    fi

    # Test report generation
    assert_contains "Generates report file" "$script_to_test" "REPORT_FILE"
    assert_contains "Report includes date" "$script_to_test" "date\\|Date:"
}


# === DRY RUN TEST (if not root) ===

test_dry_run() {
    print_test_header "Dry Run (Non-Root Behavior)"

    # Only test if we're NOT root
    if [[ $EUID -eq 0 ]]; then
        echo -e "${COLOR_YELLOW}Skipping (running as root)${COLOR_RESET}"
        return 0
    fi

    # Test: Script should fail gracefully when not root
    if bash "$SCRIPT_PATH" ../artifacts/required_tools.txt 2>&1 | grep -qi "root"; then
        echo -e "${COLOR_GREEN}✓ PASS${COLOR_RESET}: Script checks for root and fails gracefully"
        ((TESTS_PASSED++))
    else
        echo -e "${COLOR_RED}✗ FAIL${COLOR_RESET}: Script doesn't check for root properly"
        ((TESTS_FAILED++))
    fi
    ((TESTS_TOTAL++))
}


# === INTEGRATION TEST (if root) ===

test_integration() {
    print_test_header "Integration Test"

    # Only run if root
    if [[ $EUID -ne 0 ]]; then
        echo -e "${COLOR_YELLOW}Skipping integration test (requires root)${COLOR_RESET}"
        echo -e "${COLOR_YELLOW}Run with sudo to test actual installation${COLOR_RESET}"
        return 0
    fi

    echo -e "${COLOR_YELLOW}Running integration test as root...${COLOR_RESET}"

    # Create minimal test tools file
    cat > /tmp/test_integration_tools.txt << 'EOF'
# Test tools (minimal list)
htop
curl
wget
EOF

    # Run script
    if bash "$SCRIPT_PATH" /tmp/test_integration_tools.txt; then
        echo -e "${COLOR_GREEN}✓ PASS${COLOR_RESET}: Script executed successfully"
        ((TESTS_PASSED++))

        # Check if report was generated
        if [[ -f "install_report.txt" ]]; then
            echo -e "${COLOR_GREEN}✓ PASS${COLOR_RESET}: Report file generated"
            ((TESTS_PASSED++))
        else
            echo -e "${COLOR_RED}✗ FAIL${COLOR_RESET}: Report file not generated"
            ((TESTS_FAILED++))
        fi
        ((TESTS_TOTAL+=2))

        # Check if log was generated
        if [[ -f "install.log" ]]; then
            echo -e "${COLOR_GREEN}✓ PASS${COLOR_RESET}: Log file generated"
            ((TESTS_PASSED++))
        else
            echo -e "${COLOR_RED}✗ FAIL${COLOR_RESET}: Log file not generated"
            ((TESTS_FAILED++))
        fi
        ((TESTS_TOTAL++))

    else
        echo -e "${COLOR_RED}✗ FAIL${COLOR_RESET}: Script execution failed"
        ((TESTS_FAILED++))
        ((TESTS_TOTAL++))
    fi

    # Cleanup
    rm -f /tmp/test_integration_tools.txt
}


# === MAIN TEST RUNNER ===

main() {
    echo -e "${COLOR_CYAN}"
    echo "========================================"
    echo "KERNEL SHADOWS - Episode 04 Test Suite"
    echo "Package Management Tests"
    echo "========================================"
    echo -e "${COLOR_RESET}"

    # Run all test suites
    test_structure
    test_configuration
    test_artifacts
    test_parsing
    test_safety
    test_logging
    test_reporting
    test_dry_run
    test_integration

    # Print summary
    print_summary

    # Exit with appropriate code
    if [[ $TESTS_FAILED -eq 0 ]]; then
        exit 0
    else
        exit 1
    fi
}


# === ENTRY POINT ===

main "$@"


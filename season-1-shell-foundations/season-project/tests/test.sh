#!/bin/bash
################################################################################
# TEST SUITE — Season 1 Integration Project
# Tests system_setup.sh for correctness
################################################################################

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
TESTS_PASSED=0
TESTS_FAILED=0
TOTAL_TESTS=0

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SCRIPT_TO_TEST="$PROJECT_DIR/system_setup.sh"
SOLUTION_SCRIPT="$PROJECT_DIR/solution/system_setup.sh"

#------------------------------------------------------------------------------
# HELPER FUNCTIONS
#------------------------------------------------------------------------------

print_test_header() {
    local text="$1"
    echo ""
    echo -e "${BLUE}============================================================${NC}"
    echo -e "${BLUE}  $text${NC}"
    echo -e "${BLUE}============================================================${NC}"
}

test_pass() {
    local message="$1"
    echo -e "${GREEN}[✓]${NC} $message"
    ((TESTS_PASSED++))
    ((TOTAL_TESTS++))
}

test_fail() {
    local message="$1"
    echo -e "${RED}[✗]${NC} $message"
    ((TESTS_FAILED++))
    ((TOTAL_TESTS++))
}

test_skip() {
    local message="$1"
    echo -e "${YELLOW}[~]${NC} $message (skipped)"
}

#------------------------------------------------------------------------------
# STRUCTURE TESTS
#------------------------------------------------------------------------------

test_structure() {
    print_test_header "Structure Tests"

    # Test 1: Script exists
    if [[ -f "$SCRIPT_TO_TEST" ]]; then
        test_pass "Script file exists"
    else
        test_fail "Script file not found: $SCRIPT_TO_TEST"
        return 1
    fi

    # Test 2: Shebang
    if head -n1 "$SCRIPT_TO_TEST" | grep -q "^#!/bin/bash"; then
        test_pass "Shebang present"
    else
        test_fail "Shebang missing or incorrect"
    fi

    # Test 3: Executable
    if [[ -x "$SCRIPT_TO_TEST" ]]; then
        test_pass "Script is executable"
    else
        test_fail "Script is not executable (run: chmod +x $SCRIPT_TO_TEST)"
    fi

    # Test 4: Functions present
    local required_functions=(
        "log_message"
        "print_status"
        "check_system"
        "monitor_system"
        "analyze_security"
        "install_packages"
        "generate_report"
        "main"
    )

    local missing_functions=()

    for func in "${required_functions[@]}"; do
        if grep -q "^[[:space:]]*${func}()" "$SCRIPT_TO_TEST"; then
            :  # Function found
        else
            missing_functions+=("$func")
        fi
    done

    if [[ ${#missing_functions[@]} -eq 0 ]]; then
        test_pass "All required functions present"
    else
        test_fail "Missing functions: ${missing_functions[*]}"
    fi

    # Test 5: set -euo pipefail
    if grep -q "set -euo pipefail" "$SCRIPT_TO_TEST"; then
        test_pass "Strict mode enabled (set -euo pipefail)"
    else
        test_fail "Strict mode not enabled"
    fi
}

#------------------------------------------------------------------------------
# FUNCTIONAL TESTS (DRY-RUN)
#------------------------------------------------------------------------------

test_functional() {
    print_test_header "Functional Tests (Dry-Run)"

    cd "$PROJECT_DIR"

    # Clean previous run
    rm -f system_report.txt security_analysis.txt setup.log install.log

    # Test 6: Script executes without errors (dry-run)
    if "$SCRIPT_TO_TEST" --dry-run > /dev/null 2>&1; then
        test_pass "Script executes without errors (--dry-run)"
    else
        test_fail "Script failed to execute (--dry-run)"
        return 1
    fi

    # Test 7: system_report.txt generated
    if [[ -f "system_report.txt" ]]; then
        test_pass "system_report.txt generated"
    else
        test_fail "system_report.txt not generated"
    fi

    # Test 8: security_analysis.txt generated
    if [[ -f "security_analysis.txt" ]]; then
        test_pass "security_analysis.txt generated"
    else
        test_fail "security_analysis.txt not generated"
    fi

    # Test 9: setup.log generated
    if [[ -f "setup.log" ]]; then
        test_pass "setup.log generated"
    else
        test_fail "setup.log not generated"
    fi

    # Test 10: Reports contain expected sections
    if [[ -f "system_report.txt" ]]; then
        local has_system_check=false
        local has_monitoring=false

        if grep -q "SYSTEM CHECK" "system_report.txt"; then
            has_system_check=true
        fi

        if grep -q "SYSTEM MONITORING" "system_report.txt"; then
            has_monitoring=true
        fi

        if [[ "$has_system_check" == true && "$has_monitoring" == true ]]; then
            test_pass "Report contains expected sections"
        else
            test_fail "Report missing expected sections"
        fi
    fi

    # Test 11: Security analysis contains failed login check
    if [[ -f "security_analysis.txt" ]]; then
        if grep -q "Failed Login" "security_analysis.txt" || \
           grep -q "auth.log" "security_analysis.txt"; then
            test_pass "Security analysis checks failed logins"
        else
            test_fail "Security analysis missing failed login check"
        fi
    fi
}

#------------------------------------------------------------------------------
# MODULE TESTS
#------------------------------------------------------------------------------

test_modules() {
    print_test_header "Module Tests"

    # Test 12: System check module (Episode 01 skills)
    if grep -q "df" "$SCRIPT_TO_TEST" && \
       grep -q "check.*path" "$SCRIPT_TO_TEST"; then
        test_pass "System check module uses Episode 01 skills (filesystem checks)"
    else
        test_fail "System check module incomplete"
    fi

    # Test 13: Monitoring module (Episode 02 skills)
    if grep -q "uptime\|load" "$SCRIPT_TO_TEST" && \
       grep -q "free\|mem" "$SCRIPT_TO_TEST"; then
        test_pass "Monitoring module uses Episode 02 skills (resource monitoring)"
    else
        test_fail "Monitoring module incomplete"
    fi

    # Test 14: Security module (Episode 03 skills)
    if grep -q "grep.*auth" "$SCRIPT_TO_TEST" && \
       grep -q "awk\|sort.*uniq" "$SCRIPT_TO_TEST"; then
        test_pass "Security module uses Episode 03 skills (text processing)"
    else
        test_fail "Security module incomplete"
    fi

    # Test 15: Package module (Episode 04 skills)
    if grep -q "apt.*install\|dpkg" "$SCRIPT_TO_TEST"; then
        test_pass "Package module uses Episode 04 skills (package management)"
    else
        test_fail "Package module incomplete"
    fi
}

#------------------------------------------------------------------------------
# ERROR HANDLING TESTS
#------------------------------------------------------------------------------

test_error_handling() {
    print_test_header "Error Handling Tests"

    cd "$PROJECT_DIR"

    # Test 16: Handles missing artifacts gracefully
    local backup_dir="${ARTIFACTS_DIR}_backup"
    if [[ -d "artifacts" ]]; then
        mv artifacts "$backup_dir" 2>/dev/null || true

        if "$SCRIPT_TO_TEST" --dry-run > /dev/null 2>&1; then
            test_pass "Handles missing artifacts gracefully"
        else
            test_fail "Crashes when artifacts missing"
        fi

        mv "$backup_dir" artifacts 2>/dev/null || true
    else
        test_skip "Cannot test missing artifacts (already missing)"
    fi

    # Test 17: Non-root doesn't break script
    if [[ $EUID -ne 0 ]]; then
        if "$SCRIPT_TO_TEST" --dry-run > /dev/null 2>&1; then
            test_pass "Runs without root privileges (dry-run)"
        else
            test_fail "Fails without root privileges"
        fi
    else
        test_skip "Running as root, cannot test non-root behavior"
    fi
}

#------------------------------------------------------------------------------
# INTEGRATION TESTS
#------------------------------------------------------------------------------

test_integration() {
    print_test_header "Integration Tests"

    cd "$PROJECT_DIR"

    # Clean
    rm -f system_report.txt security_analysis.txt setup.log install.log

    # Test 18: Full run produces all expected files
    "$SCRIPT_TO_TEST" --dry-run > /dev/null 2>&1

    local expected_files=("system_report.txt" "security_analysis.txt" "setup.log")
    local all_present=true

    for file in "${expected_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            all_present=false
            break
        fi
    done

    if [[ "$all_present" == true ]]; then
        test_pass "All expected output files generated"
    else
        test_fail "Some output files missing"
    fi

    # Test 19: Logs contain timestamps
    if [[ -f "setup.log" ]]; then
        if grep -q "\[20[0-9][0-9]-" "setup.log"; then
            test_pass "Logs contain timestamps"
        else
            test_fail "Logs missing timestamps"
        fi
    fi

    # Test 20: Exit code is 0 on success
    if "$SCRIPT_TO_TEST" --dry-run > /dev/null 2>&1; then
        local exit_code=$?
        if [[ $exit_code -eq 0 ]]; then
            test_pass "Exit code is 0 on success"
        else
            test_fail "Exit code is $exit_code (expected 0)"
        fi
    fi
}

#------------------------------------------------------------------------------
# MAIN TEST RUNNER
#------------------------------------------------------------------------------

main() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  KERNEL SHADOWS — Season 1 Integration Project Tests      ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"

    # Check which script to test
    if [[ ! -f "$SCRIPT_TO_TEST" ]]; then
        echo ""
        echo -e "${YELLOW}system_setup.sh not found. Testing solution script instead.${NC}"
        SCRIPT_TO_TEST="$SOLUTION_SCRIPT"

        if [[ ! -f "$SCRIPT_TO_TEST" ]]; then
            echo -e "${RED}Error: No script found to test${NC}"
            exit 1
        fi
    fi

    echo ""
    echo "Testing: $SCRIPT_TO_TEST"

    # Run test suites
    test_structure
    test_functional
    test_modules
    test_error_handling
    test_integration

    # Summary
    print_test_header "Test Summary"

    local total_expected=20
    local score=$((TESTS_PASSED * 100 / total_expected))

    echo ""
    echo -e "Total Tests: ${BLUE}$TOTAL_TESTS${NC}"
    echo -e "Passed:      ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Failed:      ${RED}$TESTS_FAILED${NC}"
    echo -e "Score:       ${BLUE}${score}%${NC}"
    echo ""

    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║               ALL TESTS PASSED! ✓                          ║${NC}"
        echo -e "${GREEN}║         Season 1 Integration Project COMPLETE              ║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${YELLOW}\"You've mastered Season 1. Shell, scripting, text processing,${NC}"
        echo -e "${YELLOW} package management — all integrated. Ready for Season 2.\"${NC}"
        echo -e "${YELLOW}                                              — LILITH${NC}"
        echo ""
        return 0
    elif [[ $score -ge 70 ]]; then
        echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${YELLOW}║             PASSING GRADE (${score}%)                        ║${NC}"
        echo -e "${YELLOW}║        Review failed tests and improve                     ║${NC}"
        echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        return 1
    else
        echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║              TESTS FAILED (${score}%)                        ║${NC}"
        echo -e "${RED}║        Review errors and try again                         ║${NC}"
        echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        return 1
    fi
}

#------------------------------------------------------------------------------
# EXECUTION
#------------------------------------------------------------------------------

main "$@"


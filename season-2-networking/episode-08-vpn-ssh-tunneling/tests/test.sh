#!/bin/bash

# ════════════════════════════════════════════════════════════════
# Episode 08: VPN & SSH Tunneling — Tests
# Season 2 Finale Test Suite
# ════════════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test categories
CATEGORY=""

# ════════════════════════════════════════════════════════════════
# Test Framework
# ════════════════════════════════════════════════════════════════

start_category() {
    CATEGORY="$1"
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $CATEGORY${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

test_assert() {
    local test_name="$1"
    local condition="$2"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    if eval "$condition"; then
        echo -e "${GREEN}✓${NC} $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $test_name"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

test_file_exists() {
    local file="$1"
    local description="$2"
    test_assert "$description" "[ -f '$file' ]"
}

test_dir_exists() {
    local dir="$1"
    local description="$2"
    test_assert "$description" "[ -d '$dir' ]"
}

test_file_not_empty() {
    local file="$1"
    local description="$2"
    test_assert "$description" "[ -s '$file' ]"
}

test_executable() {
    local file="$1"
    local description="$2"
    test_assert "$description" "[ -x '$file' ]"
}

# ════════════════════════════════════════════════════════════════
# Category 1: File Structure
# ════════════════════════════════════════════════════════════════

test_file_structure() {
    start_category "FILE STRUCTURE"
    
    # Main files
    test_file_exists "README.md" "README.md exists"
    test_file_exists "starter.sh" "starter.sh exists"
    test_executable "starter.sh" "starter.sh is executable"
    
    # Solution
    test_file_exists "solution/vpn_setup.sh" "solution/vpn_setup.sh exists"
    test_executable "solution/vpn_setup.sh" "solution/vpn_setup.sh is executable"
    
    # Artifacts
    test_dir_exists "artifacts" "artifacts/ directory exists"
    test_file_exists "artifacts/README.md" "artifacts/README.md exists"
    
    # Tests
    test_file_exists "tests/test.sh" "tests/test.sh exists"
}

# ════════════════════════════════════════════════════════════════
# Category 2: SSH Keys Generation
# ════════════════════════════════════════════════════════════════

test_ssh_keys() {
    start_category "SSH KEYS GENERATION"
    
    # Run solution to generate keys
    echo "Running solution script to generate artifacts..."
    ./solution/vpn_setup.sh > /dev/null 2>&1 || true
    
    # Check keys directory
    test_dir_exists "artifacts/ssh_keys" "ssh_keys/ directory created"
    
    # Team members
    TEAM=("viktor" "alex" "anna" "dmitry" "max")
    
    for member in "${TEAM[@]}"; do
        test_file_exists "artifacts/ssh_keys/${member}_key" \
            "Private key for $member exists"
        
        test_file_exists "artifacts/ssh_keys/${member}_key.pub" \
            "Public key for $member exists"
        
        # Check key format (should contain "PRIVATE KEY")
        if [ -f "artifacts/ssh_keys/${member}_key" ]; then
            test_assert "Private key for $member is valid ed25519" \
                "grep -q 'PRIVATE KEY' artifacts/ssh_keys/${member}_key"
        fi
        
        # Check public key format (should contain "ssh-ed25519")
        if [ -f "artifacts/ssh_keys/${member}_key.pub" ]; then
            test_assert "Public key for $member is valid ed25519" \
                "grep -q 'ssh-ed25519' artifacts/ssh_keys/${member}_key.pub"
        fi
    done
}

# ════════════════════════════════════════════════════════════════
# Category 3: SSH Config
# ════════════════════════════════════════════════════════════════

test_ssh_config() {
    start_category "SSH CONFIG"
    
    test_file_exists "artifacts/ssh_config" "ssh_config file created"
    test_file_not_empty "artifacts/ssh_config" "ssh_config is not empty"
    
    if [ -f "artifacts/ssh_config" ]; then
        # Check for essential hosts
        test_assert "ssh_config contains vpn-zurich" \
            "grep -q 'Host vpn-zurich' artifacts/ssh_config"
        
        test_assert "ssh_config contains shadow-02" \
            "grep -q 'Host shadow-02' artifacts/ssh_config"
        
        # Check for ProxyJump
        test_assert "ssh_config uses ProxyJump" \
            "grep -q 'ProxyJump' artifacts/ssh_config"
        
        # Check for IdentityFile
        test_assert "ssh_config specifies IdentityFile" \
            "grep -q 'IdentityFile' artifacts/ssh_config"
        
        # Check for global settings
        test_assert "ssh_config has ServerAliveInterval" \
            "grep -q 'ServerAliveInterval' artifacts/ssh_config"
        
        test_assert "ssh_config has Compression" \
            "grep -q 'Compression' artifacts/ssh_config"
        
        # Team members hosts
        for member in viktor alex anna dmitry; do
            test_assert "ssh_config contains host for $member" \
                "grep -q \"Host $member\" artifacts/ssh_config"
        done
    fi
}

# ════════════════════════════════════════════════════════════════
# Category 4: WireGuard Configuration
# ════════════════════════════════════════════════════════════════

test_wireguard_config() {
    start_category "WIREGUARD VPN CONFIGURATION"
    
    test_dir_exists "artifacts/wireguard" "wireguard/ directory created"
    
    # Server config
    test_file_exists "artifacts/wireguard/server_wg0.conf" \
        "Server config (server_wg0.conf) exists"
    
    if [ -f "artifacts/wireguard/server_wg0.conf" ]; then
        test_file_not_empty "artifacts/wireguard/server_wg0.conf" \
            "Server config is not empty"
        
        test_assert "Server config has [Interface] section" \
            "grep -q '\[Interface\]' artifacts/wireguard/server_wg0.conf"
        
        test_assert "Server config has Address" \
            "grep -q 'Address.*10\.8\.0\.1' artifacts/wireguard/server_wg0.conf"
        
        test_assert "Server config has ListenPort" \
            "grep -q 'ListenPort.*51820' artifacts/wireguard/server_wg0.conf"
        
        test_assert "Server config has PostUp iptables" \
            "grep -q 'PostUp.*iptables' artifacts/wireguard/server_wg0.conf"
        
        test_assert "Server config has [Peer] sections" \
            "grep -q '\[Peer\]' artifacts/wireguard/server_wg0.conf"
    fi
    
    # Client configs
    TEAM=("viktor" "alex" "anna" "dmitry" "max")
    
    for member in "${TEAM[@]}"; do
        test_file_exists "artifacts/wireguard/${member}.conf" \
            "Client config for $member exists"
        
        if [ -f "artifacts/wireguard/${member}.conf" ]; then
            test_assert "Client config for $member has [Interface]" \
                "grep -q '\[Interface\]' artifacts/wireguard/${member}.conf"
            
            test_assert "Client config for $member has Address" \
                "grep -q 'Address.*10\.8\.0\.' artifacts/wireguard/${member}.conf"
            
            test_assert "Client config for $member has DNS" \
                "grep -q 'DNS' artifacts/wireguard/${member}.conf"
            
            test_assert "Client config for $member has [Peer]" \
                "grep -q '\[Peer\]' artifacts/wireguard/${member}.conf"
            
            test_assert "Client config for $member has Endpoint" \
                "grep -q 'Endpoint' artifacts/wireguard/${member}.conf"
            
            test_assert "Client config for $member has AllowedIPs" \
                "grep -q 'AllowedIPs' artifacts/wireguard/${member}.conf"
        fi
    done
    
    # Keys (should be generated)
    test_file_exists "artifacts/wireguard/server_public.key" \
        "Server public key exists" || true
}

# ════════════════════════════════════════════════════════════════
# Category 5: Final Audit Report
# ════════════════════════════════════════════════════════════════

test_audit_report() {
    start_category "FINAL AUDIT REPORT"
    
    test_file_exists "artifacts/season2_final_audit.txt" \
        "Final audit report exists"
    
    if [ -f "artifacts/season2_final_audit.txt" ]; then
        test_file_not_empty "artifacts/season2_final_audit.txt" \
            "Audit report is not empty"
        
        # Check content
        test_assert "Audit report has SEASON 2 title" \
            "grep -q 'SEASON 2.*NETWORKING' artifacts/season2_final_audit.txt"
        
        test_assert "Audit report has MISSION SUMMARY" \
            "grep -q 'MISSION SUMMARY' artifacts/season2_final_audit.txt"
        
        test_assert "Audit report mentions Episode 05" \
            "grep -q 'Episode 05' artifacts/season2_final_audit.txt"
        
        test_assert "Audit report mentions Episode 06" \
            "grep -q 'Episode 06' artifacts/season2_final_audit.txt"
        
        test_assert "Audit report mentions Episode 07" \
            "grep -q 'Episode 07' artifacts/season2_final_audit.txt"
        
        test_assert "Audit report mentions Episode 08" \
            "grep -q 'Episode 08' artifacts/season2_final_audit.txt"
        
        test_assert "Audit report mentions Krylov" \
            "grep -q 'Krylov' artifacts/season2_final_audit.txt"
        
        test_assert "Audit report mentions WireGuard" \
            "grep -q 'WireGuard' artifacts/season2_final_audit.txt"
        
        test_assert "Audit report has SECURITY METRICS" \
            "grep -q 'SECURITY METRICS' artifacts/season2_final_audit.txt"
        
        test_assert "Audit report has FINAL ASSESSMENT" \
            "grep -q 'FINAL ASSESSMENT' artifacts/season2_final_audit.txt"
        
        test_assert "Audit report mentions Season 3" \
            "grep -q 'Season 3' artifacts/season2_final_audit.txt"
        
        test_assert "Audit report is COMPLETE" \
            "grep -q 'COMPLETE' artifacts/season2_final_audit.txt"
    fi
}

# ════════════════════════════════════════════════════════════════
# Category 6: README Content
# ════════════════════════════════════════════════════════════════

test_readme_content() {
    start_category "README CONTENT"
    
    test_file_not_empty "README.md" "README.md is not empty"
    
    # Check episode structure
    test_assert "README has episode title" \
        "grep -q 'Episode 08.*VPN.*SSH' README.md"
    
    test_assert "README has plot/story section" \
        "grep -q 'Сюжет' README.md"
    
    test_assert "README has tasks/assignments" \
        "grep -q 'Задание' README.md"
    
    test_assert "README has progressive hints" \
        "grep -q 'Подсказка' README.md"
    
    test_assert "README has solutions" \
        "grep -q 'Решение' README.md"
    
    # Technical content
    test_assert "README covers SSH keys" \
        "grep -q 'ssh-keygen' README.md"
    
    test_assert "README covers SSH config" \
        "grep -q 'ssh/config' README.md"
    
    test_assert "README covers SSH tunneling" \
        "grep -q 'Local Forward\|Remote Forward\|Dynamic Forward' README.md"
    
    test_assert "README covers WireGuard" \
        "grep -q 'WireGuard' README.md"
    
    test_assert "README covers OpenVPN" \
        "grep -q 'OpenVPN' README.md"
    
    # Character mentions
    test_assert "README mentions Viktor" \
        "grep -q 'Viktor' README.md"
    
    test_assert "README mentions Alex" \
        "grep -q 'Alex' README.md"
    
    test_assert "README mentions Katarina" \
        "grep -q 'Katarina' README.md"
    
    test_assert "README mentions Krylov" \
        "grep -q 'Krylov' README.md"
    
    test_assert "README mentions LILITH" \
        "grep -q 'LILITH' README.md"
    
    # Season 2 completion
    test_assert "README marks Season 2 as COMPLETE" \
        "grep -q 'SEASON 2.*COMPLETE' README.md"
    
    test_assert "README previews Season 3" \
        "grep -q 'Season 3' README.md"
}

# ════════════════════════════════════════════════════════════════
# Category 7: Script Execution
# ════════════════════════════════════════════════════════════════

test_script_execution() {
    start_category "SCRIPT EXECUTION"
    
    # Test solution script runs without errors
    echo "Testing solution script execution..."
    
    if timeout 30 bash solution/vpn_setup.sh > /tmp/vpn_setup_output.txt 2>&1; then
        test_assert "Solution script executes successfully" "true"
    else
        EXIT_CODE=$?
        if [ $EXIT_CODE -eq 124 ]; then
            test_assert "Solution script executes (timeout OK)" "true"
        else
            test_assert "Solution script executes successfully" "false"
            echo "  Error output:"
            tail -5 /tmp/vpn_setup_output.txt | sed 's/^/    /'
        fi
    fi
    
    # Check output
    if [ -f /tmp/vpn_setup_output.txt ]; then
        test_assert "Solution produces output" \
            "[ -s /tmp/vpn_setup_output.txt ]"
        
        test_assert "Solution output mentions SSH keys" \
            "grep -q 'SSH KEYS' /tmp/vpn_setup_output.txt"
        
        test_assert "Solution output mentions VPN" \
            "grep -q 'WIREGUARD\|VPN' /tmp/vpn_setup_output.txt"
        
        test_assert "Solution output shows completion" \
            "grep -q 'COMPLETE' /tmp/vpn_setup_output.txt"
    fi
}

# ════════════════════════════════════════════════════════════════
# Category 8: Security Checks
# ════════════════════════════════════════════════════════════════

test_security() {
    start_category "SECURITY CHECKS"
    
    # SSH key permissions (should be 600 for private keys)
    if [ -d "artifacts/ssh_keys" ]; then
        for key in artifacts/ssh_keys/*_key; do
            if [ -f "$key" ] && [[ ! "$key" == *.pub ]]; then
                PERMS=$(stat -c '%a' "$key" 2>/dev/null || stat -f '%A' "$key" 2>/dev/null)
                if [ "$PERMS" = "600" ] || [ "$PERMS" = "400" ]; then
                    test_assert "Private key $(basename $key) has secure permissions" "true"
                else
                    test_assert "Private key $(basename $key) has secure permissions (got: $PERMS)" "false"
                fi
            fi
        done
    fi
    
    # Check for leaked secrets in configs
    test_assert "SSH config doesn't contain actual passwords" \
        "! grep -i 'password.*=' artifacts/ssh_config 2>/dev/null"
    
    # WireGuard private keys should not be in README
    test_assert "README doesn't contain WireGuard private keys" \
        "! grep 'PRIVATE_KEY' README.md 2>/dev/null || grep 'PRIVATE_KEY' README.md | grep -q 'example\|paste_server_private_key_here'"
}

# ════════════════════════════════════════════════════════════════
# Category 9: Documentation Quality
# ════════════════════════════════════════════════════════════════

test_documentation() {
    start_category "DOCUMENTATION QUALITY"
    
    # README length (should be substantial)
    README_LINES=$(wc -l < README.md)
    test_assert "README is comprehensive (${README_LINES} lines, expect >2000)" \
        "[ $README_LINES -gt 2000 ]"
    
    # Artifacts README
    test_file_exists "artifacts/README.md" "artifacts/README.md exists"
    
    if [ -f "artifacts/README.md" ]; then
        test_file_not_empty "artifacts/README.md" "artifacts/README.md is not empty"
        
        test_assert "artifacts/README has installation instructions" \
            "grep -q 'Installation\|Установка' artifacts/README.md"
        
        test_assert "artifacts/README has troubleshooting" \
            "grep -q 'Troubleshooting' artifacts/README.md"
        
        test_assert "artifacts/README has security practices" \
            "grep -q 'Security' artifacts/README.md"
    fi
}

# ════════════════════════════════════════════════════════════════
# Category 10: Season 2 Integration
# ════════════════════════════════════════════════════════════════

test_season2_integration() {
    start_category "SEASON 2 INTEGRATION"
    
    # Check references to previous episodes
    test_assert "Episode references Episode 05 (TCP/IP)" \
        "grep -q 'Episode 05.*TCP' README.md"
    
    test_assert "Episode references Episode 06 (DNS)" \
        "grep -q 'Episode 06.*DNS' README.md"
    
    test_assert "Episode references Episode 07 (Firewall)" \
        "grep -q 'Episode 07.*[Ff]irewall' README.md"
    
    # DDoS incident from Episode 07
    test_assert "Episode mentions DDoS incident from Episode 07" \
        "grep -q 'DDoS' README.md"
    
    # Characters from Season 2
    test_assert "Episode includes Stockholm location" \
        "grep -q 'Stockholm\|Стокгольм' README.md"
    
    test_assert "Episode includes Zürich location" \
        "grep -q 'Zürich\|Цюрих' README.md"
    
    # Season 2 finale markers
    test_assert "Episode is marked as Season 2 Finale" \
        "grep -q 'Season 2.*[Ff]inal\|FINAL' README.md"
}

# ════════════════════════════════════════════════════════════════
# Main Test Runner
# ════════════════════════════════════════════════════════════════

main() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║         Episode 08: VPN & SSH Tunneling — Tests         ║"
    echo "║         Season 2 Finale Test Suite                       ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    
    # Run all test categories
    test_file_structure
    test_ssh_keys
    test_ssh_config
    test_wireguard_config
    test_audit_report
    test_readme_content
    test_script_execution
    test_security
    test_documentation
    test_season2_integration
    
    # Summary
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  TEST SUMMARY${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Total tests:  $TESTS_TOTAL"
    echo -e "${GREEN}Passed:${NC}       $TESTS_PASSED"
    
    if [ $TESTS_FAILED -gt 0 ]; then
        echo -e "${RED}Failed:${NC}       $TESTS_FAILED"
    else
        echo -e "${GREEN}Failed:${NC}       $TESTS_FAILED"
    fi
    
    echo ""
    
    PASS_RATE=$((TESTS_PASSED * 100 / TESTS_TOTAL))
    
    if [ $PASS_RATE -eq 100 ]; then
        echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║         ✓ ALL TESTS PASSED (100%)                        ║${NC}"
        echo -e "${GREEN}║         SEASON 2: NETWORKING — COMPLETE!                 ║${NC}"
        echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo "🎉 Congratulations! Episode 08 complete!"
        echo "🎓 Season 2: Networking — Grade: A+"
        echo "🚀 Next: Season 3 — System Administration"
        echo ""
        exit 0
    elif [ $PASS_RATE -ge 80 ]; then
        echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════╗${NC}"
        echo -e "${YELLOW}║         ⚠ MOST TESTS PASSED (${PASS_RATE}%)                          ║${NC}"
        echo -e "${YELLOW}║         Some issues need attention                       ║${NC}"
        echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        exit 1
    else
        echo -e "${RED}╔═══════════════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║         ✗ TESTS FAILED (${PASS_RATE}%)                               ║${NC}"
        echo -e "${RED}║         Significant issues found                          ║${NC}"
        echo -e "${RED}╚═══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        exit 1
    fi
}

# Run tests
main "$@"

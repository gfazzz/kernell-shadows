#!/bin/bash
# KERNEL SHADOWS — Episode 06: Tests

set -e

EPISODE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOLUTION="$EPISODE_DIR/solution/dns_audit.sh"

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  Episode 06: DNS & Name Resolution — Tests                   ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

passed=0
failed=0

# Test 1: Solution exists
if [ -f "$SOLUTION" ]; then
    echo "✓ [1] Solution file exists"
    ((passed++))
else
    echo "✗ [1] Solution file missing"
    ((failed++))
fi

# Test 2: Solution is executable
if [ -x "$SOLUTION" ]; then
    echo "✓ [2] Solution is executable"
    ((passed++))
else
    echo "✗ [2] Solution not executable"
    ((failed++))
fi

# Test 3: Has shebang
if head -n1 "$SOLUTION" | grep -q "^#!/bin/bash"; then
    echo "✓ [3] Has bash shebang"
    ((passed++))
else
    echo "✗ [3] Missing bash shebang"
    ((failed++))
fi

# Test 4: Artifacts exist
if [ -f "$EPISODE_DIR/artifacts/dns_zones.txt" ]; then
    echo "✓ [4] dns_zones.txt exists"
    ((passed++))
else
    echo "✗ [4] dns_zones.txt missing"
    ((failed++))
fi

# Test 5: Run solution
if "$SOLUTION" &>/dev/null; then
    echo "✓ [5] Solution runs without errors"
    ((passed++))
else
    echo "✗ [5] Solution execution failed"
    ((failed++))
fi

# Test 6: Report generated
if [ -f "$EPISODE_DIR/artifacts/dns_security_report.txt" ]; then
    echo "✓ [6] Report generated"
    ((passed++))
else
    echo "✗ [6] Report not generated"
    ((failed++))
fi

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "Results: $passed passed, $failed failed"
[ $failed -eq 0 ] && echo "✓ ALL TESTS PASSED" || echo "✗ SOME TESTS FAILED"
echo "════════════════════════════════════════════════════════════════"

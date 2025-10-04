#!/bin/bash

################################################################################
# OPERATION KERNEL SHADOWS
# Episode 01: Terminal Awakening — Test Script
#
# Проверяет правильность выполнения миссии
################################################################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  KERNEL SHADOWS — Episode 01 Test Suite                      ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Функция проверки
check_test() {
    local test_name="$1"
    local test_result=$2
    
    if [ $test_result -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $test_name"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}✗${NC} $test_name"
        FAILED=$((FAILED + 1))
    fi
}

# TEST 1: Проверка наличия test_environment
echo "Running tests..."
echo ""

if [ -d "../artifacts/test_environment" ]; then
    check_test "Test environment exists" 0
else
    check_test "Test environment exists" 1
    echo ""
    echo -e "${RED}Error:${NC} test_environment not found!"
    echo "Run: cp -r ../artifacts/test_environment ./"
    exit 1
fi

# TEST 2: Проверка briefing.txt
if [ -f "../artifacts/test_environment/documents/briefing.txt" ]; then
    check_test "briefing.txt exists" 0
    
    # Проверка содержимого
    if grep -q "OPERATION KERNEL SHADOWS" "../artifacts/test_environment/documents/briefing.txt"; then
        check_test "briefing.txt contains correct data" 0
    else
        check_test "briefing.txt contains correct data" 1
    fi
else
    check_test "briefing.txt exists" 1
fi

# TEST 3: Проверка .secret_location
if [ -f "../artifacts/test_environment/documents/.secret_location" ]; then
    check_test ".secret_location exists" 0
    
    # Проверка координат
    if grep -q "55.7558" "../artifacts/test_environment/documents/.secret_location"; then
        check_test ".secret_location contains coordinates" 0
    else
        check_test ".secret_location contains coordinates" 1
    fi
else
    check_test ".secret_location exists" 1
fi

# TEST 4: Проверка .next_server
if [ -f "../artifacts/test_environment/.next_server" ]; then
    check_test ".next_server exists" 0
    
    # Проверка IP
    if grep -q "185.192.45.119" "../artifacts/test_environment/.next_server"; then
        check_test ".next_server contains IP address" 0
    else
        check_test ".next_server contains IP address" 1
    fi
else
    check_test ".next_server exists" 1
fi

# TEST 5: Проверка скрипта (если существует)
if [ -f "../solution/find_files.sh" ]; then
    check_test "Solution script exists" 0
    
    # Проверка shebang
    if head -1 "../solution/find_files.sh" | grep -q "#!/bin/bash"; then
        check_test "Script has correct shebang" 0
    else
        check_test "Script has correct shebang" 1
    fi
    
    # Проверка прав на выполнение
    if [ -x "../solution/find_files.sh" ]; then
        check_test "Script is executable" 0
    else
        check_test "Script is executable" 1
    fi
else
    check_test "Solution script exists" 1
fi

# TEST 6: Запуск find команды
echo ""
echo "Testing file search..."
cd ../artifacts/test_environment 2>/dev/null

FOUND_FILES=$(find . -name "briefing.txt" -o -name ".secret_location" -o -name ".next_server" 2>/dev/null | wc -l)

if [ $FOUND_FILES -eq 3 ]; then
    check_test "All 3 files can be found with 'find' command" 0
else
    check_test "All 3 files can be found with 'find' command" 1
    echo -e "${YELLOW}   Found: $FOUND_FILES/3 files${NC}"
fi

cd - > /dev/null

# Summary
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  Test Results                                                 ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}Passed:${NC} $PASSED"
echo -e "${RED}Failed:${NC} $FAILED"
echo ""

TOTAL=$((PASSED + FAILED))
PERCENTAGE=$((PASSED * 100 / TOTAL))

if [ $PERCENTAGE -eq 100 ]; then
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✓✓✓ ALL TESTS PASSED! Mission Success! ✓✓✓${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Вы готовы к Episode 02!"
    exit 0
elif [ $PERCENTAGE -ge 75 ]; then
    echo -e "${YELLOW}⚠ Good, but some issues remain ⚠${NC}"
    echo "Review failed tests and try again."
    exit 1
else
    echo -e "${RED}✗✗✗ MISSION FAILED ✗✗✗${NC}"
    echo "Review the mission.md and README.md"
    exit 1
fi


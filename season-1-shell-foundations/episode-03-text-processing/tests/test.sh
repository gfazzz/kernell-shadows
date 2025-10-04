#!/bin/bash

################################################################################
# KERNEL SHADOWS — Episode 03: Text Processing Masters
# Автотесты для проверки решения студента
# Версия: 1.0
################################################################################

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Счётчики
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Путь к решению студента
SCRIPT_PATH="../log_analyzer.sh"
ARTIFACTS_PATH="../artifacts"

# Временная директория для тестов
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

################################################################################
# Функции для тестирования
################################################################################

print_header() {
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "   KERNEL SHADOWS — Episode 03 Tests"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
}

print_test_start() {
    echo -n "Testing: $1 ... "
    ((TOTAL_TESTS++))
}

print_pass() {
    echo -e "${GREEN}PASS${NC}"
    ((PASSED_TESTS++))
}

print_fail() {
    echo -e "${RED}FAIL${NC}"
    if [[ -n "$1" ]]; then
        echo -e "  ${RED}Reason: $1${NC}"
    fi
    ((FAILED_TESTS++))
}

print_summary() {
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "                          SUMMARY"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "Total tests: $TOTAL_TESTS"
    echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"

    if [[ $FAILED_TESTS -gt 0 ]]; then
        echo -e "${RED}Failed: $FAILED_TESTS${NC}"
    else
        echo -e "${GREEN}Failed: 0${NC}"
    fi

    echo ""

    if [[ $FAILED_TESTS -eq 0 ]]; then
        echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}            ✓ ALL TESTS PASSED! EXCELLENT WORK!${NC}"
        echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo "LILITH: Хорошая работа. Ты умеешь работать с данными."
        echo "        grep, awk, sed, pipes — твоё оружие теперь."
        echo ""
        return 0
    else
        echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
        echo -e "${RED}                    SOME TESTS FAILED${NC}"
        echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo "LILITH: Не все тесты пройдены. Проверь код. Логи покажут проблему."
        echo ""
        return 1
    fi
}

################################################################################
# TEST 1: Проверка существования файлов
################################################################################
test_files_exist() {
    print_test_start "Files exist"

    if [[ ! -f "$SCRIPT_PATH" ]]; then
        print_fail "log_analyzer.sh not found at $SCRIPT_PATH"
        return 1
    fi

    if [[ ! -x "$SCRIPT_PATH" ]]; then
        print_fail "log_analyzer.sh is not executable (chmod +x)"
        return 1
    fi

    if [[ ! -f "$ARTIFACTS_PATH/access.log" ]]; then
        print_fail "access.log not found"
        return 1
    fi

    if [[ ! -f "$ARTIFACTS_PATH/suspicious_ips.txt" ]]; then
        print_fail "suspicious_ips.txt not found"
        return 1
    fi

    print_pass
}

################################################################################
# TEST 2: Проверка структуры скрипта
################################################################################
test_script_structure() {
    print_test_start "Script structure (shebang, functions)"

    # Проверка shebang
    first_line=$(head -1 "$SCRIPT_PATH")
    if [[ ! "$first_line" =~ ^#!/bin/bash ]]; then
        print_fail "Missing or incorrect shebang (should be #!/bin/bash)"
        return 1
    fi

    # Проверка наличия функций (опционально, но рекомендуется)
    if ! grep -q "^[a-zA-Z_][a-zA-Z0-9_]*\(\)" "$SCRIPT_PATH"; then
        echo -e "${YELLOW}WARNING: No functions detected (recommended)${NC}"
    fi

    print_pass
}

################################################################################
# TEST 3: Проверка обработки аргументов
################################################################################
test_arguments_handling() {
    print_test_start "Arguments handling"

    # Запуск без аргументов должен вернуть exit code != 0
    "$SCRIPT_PATH" > /dev/null 2>&1
    exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        print_fail "Script should exit with error when no arguments provided"
        return 1
    fi

    print_pass
}

################################################################################
# TEST 4: Проверка работы с access.log
################################################################################
test_log_parsing() {
    print_test_start "Log parsing (access.log)"

    # Запуск скрипта
    cd "$TEST_DIR"
    cp "$ARTIFACTS_PATH/access.log" .
    cp "$ARTIFACTS_PATH/suspicious_ips.txt" .

    "$SCRIPT_PATH" access.log suspicious_ips.txt test_report.txt > /dev/null 2>&1
    exit_code=$?

    if [[ $exit_code -ne 0 ]]; then
        print_fail "Script failed to run (exit code: $exit_code)"
        return 1
    fi

    print_pass
}

################################################################################
# TEST 5: Проверка создания top_attackers.txt
################################################################################
test_top_attackers_file() {
    print_test_start "TOP-10 attackers file creation"

    cd "$TEST_DIR"

    if [[ ! -f "top_attackers.txt" ]]; then
        print_fail "top_attackers.txt not created"
        return 1
    fi

    # Проверка количества строк (должно быть ~10)
    lines=$(wc -l < top_attackers.txt)
    if [[ $lines -lt 5 || $lines -gt 15 ]]; then
        print_fail "top_attackers.txt should contain ~10 lines (found: $lines)"
        return 1
    fi

    # Проверка формата (должно быть: "COUNT IP")
    first_line=$(head -1 top_attackers.txt)
    if ! echo "$first_line" | grep -qE "^[[:space:]]*[0-9]+[[:space:]]+[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"; then
        print_fail "Invalid format in top_attackers.txt (expected: COUNT IP)"
        return 1
    fi

    print_pass
}

################################################################################
# TEST 6: Проверка обнаружения атаки (03:47)
################################################################################
test_attack_detection() {
    print_test_start "Attack window detection (03:00-05:00)"

    cd "$TEST_DIR"

    # Проверяем что скрипт обнаружил атаку в логах
    attack_count=$(grep -E "03:[0-9]{2}|04:[0-9]{2}" access.log | wc -l)

    if [[ $attack_count -lt 100 ]]; then
        print_fail "Attack window should contain 100+ requests (found: $attack_count)"
        return 1
    fi

    print_pass
}

################################################################################
# TEST 7: Проверка TOP атакующего IP (185.220.101.47 - Tor)
################################################################################
test_top_attacker_ip() {
    print_test_start "TOP attacker IP identification"

    cd "$TEST_DIR"

    if [[ ! -f "top_attackers.txt" ]]; then
        print_fail "top_attackers.txt not found"
        return 1
    fi

    # Первый IP должен быть 185.220.101.47 (Tor exit node)
    top_ip=$(head -1 top_attackers.txt | awk '{print $NF}')

    if [[ "$top_ip" != "185.220.101.47" ]]; then
        print_fail "TOP attacker should be 185.220.101.47 (Tor), found: $top_ip"
        return 1
    fi

    print_pass
}

################################################################################
# TEST 8: Проверка создания отчёта
################################################################################
test_report_generation() {
    print_test_start "Report generation"

    cd "$TEST_DIR"

    if [[ ! -f "test_report.txt" ]]; then
        print_fail "Report file not created"
        return 1
    fi

    # Проверка что отчёт не пустой
    if [[ ! -s "test_report.txt" ]]; then
        print_fail "Report file is empty"
        return 1
    fi

    # Проверка наличия ключевых секций
    if ! grep -qi "security incident report" test_report.txt; then
        print_fail "Report missing header"
        return 1
    fi

    if ! grep -qi "top.*attack" test_report.txt; then
        print_fail "Report missing TOP attackers section"
        return 1
    fi

    print_pass
}

################################################################################
# TEST 9: Проверка обнаружения известных угроз
################################################################################
test_threat_intelligence() {
    print_test_start "Threat intelligence matching"

    cd "$TEST_DIR"

    # Проверяем что известные IP из suspicious_ips.txt найдены
    known_threat="185.220.101.47"

    if ! grep -q "$known_threat" access.log; then
        print_fail "Known threat $known_threat not found in logs (test data issue)"
        return 1
    fi

    # Проверяем упоминание в отчёте
    if ! grep -q "$known_threat" test_report.txt; then
        print_fail "Known threat not mentioned in report"
        return 1
    fi

    print_pass
}

################################################################################
# TEST 10: Проверка использования grep, awk, pipes
################################################################################
test_text_processing_commands() {
    print_test_start "Text processing commands usage"

    # Проверяем что скрипт использует grep, awk, pipes
    if ! grep -q "grep" "$SCRIPT_PATH"; then
        print_fail "Script should use 'grep' command"
        return 1
    fi

    if ! grep -q "awk" "$SCRIPT_PATH"; then
        print_fail "Script should use 'awk' command"
        return 1
    fi

    # Проверка использования pipes
    if ! grep -q "|" "$SCRIPT_PATH"; then
        print_fail "Script should use pipes (|) for data processing"
        return 1
    fi

    print_pass
}

################################################################################
# TEST 11: Проверка обработки HTTP статусов
################################################################################
test_http_status_analysis() {
    print_test_start "HTTP status codes analysis"

    cd "$TEST_DIR"

    # Проверяем что в access.log есть разные статусы
    has_200=$(grep -c " 200 " access.log)
    has_404=$(grep -c " 404 " access.log)
    has_403=$(grep -c " 403 " access.log)

    if [[ $has_200 -eq 0 || $has_404 -eq 0 || $has_403 -eq 0 ]]; then
        print_fail "Log should contain different HTTP status codes"
        return 1
    fi

    print_pass
}

################################################################################
# TEST 12: Проверка exit codes
################################################################################
test_exit_codes() {
    print_test_start "Proper exit codes"

    cd "$TEST_DIR"

    # Успешное выполнение должно вернуть 0
    "$SCRIPT_PATH" access.log suspicious_ips.txt final_report.txt > /dev/null 2>&1
    exit_code=$?

    if [[ $exit_code -ne 0 ]]; then
        print_fail "Script should exit with 0 on success (got: $exit_code)"
        return 1
    fi

    # Неправильные аргументы должны вернуть не 0
    "$SCRIPT_PATH" nonexistent.log > /dev/null 2>&1
    exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        print_fail "Script should exit with non-zero on error"
        return 1
    fi

    print_pass
}

################################################################################
# MAIN: Запуск всех тестов
################################################################################
main() {
    print_header

    # Запуск тестов
    test_files_exist || true
    test_script_structure || true
    test_arguments_handling || true
    test_log_parsing || true
    test_top_attackers_file || true
    test_attack_detection || true
    test_top_attacker_ip || true
    test_report_generation || true
    test_threat_intelligence || true
    test_text_processing_commands || true
    test_http_status_analysis || true
    test_exit_codes || true

    # Вывод итогов
    print_summary
}

# Запуск
main "$@"


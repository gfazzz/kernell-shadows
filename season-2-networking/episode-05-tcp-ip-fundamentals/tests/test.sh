#!/bin/bash

###############################################################################
# Episode 05: TCP/IP Fundamentals — Tests
# KERNEL SHADOWS — Season 2: Networking
#
# Этот скрипт проверяет решение студента
###############################################################################

set -u  # Exit on undefined variable

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Счётчики
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

###############################################################################
# Helper Functions
###############################################################################

run_test() {
    local test_name="$1"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    echo -e "${BLUE}[TEST $TESTS_TOTAL] $test_name${NC}"
}

pass() {
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo -e "${GREEN}  ✓ PASS${NC}"
    echo ""
}

fail() {
    local reason="$1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo -e "${RED}  ✗ FAIL: $reason${NC}"
    echo ""
}

###############################################################################
# Tests
###############################################################################

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  KERNEL SHADOWS — Episode 05: TCP/IP Fundamentals            ║"
echo "║  Automated Tests                                             ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Category 1: File Structure
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

run_test "Проверка наличия файла starter.sh"
if [ -f "starter.sh" ]; then
    pass
else
    fail "starter.sh не найден"
fi

run_test "Проверка что starter.sh исполняемый"
if [ -f "starter.sh" ] && [ -x "starter.sh" ]; then
    pass
else
    fail "starter.sh не исполняемый (chmod +x starter.sh)"
fi

run_test "Проверка наличия shebang в starter.sh"
if [ -f "starter.sh" ] && head -n1 starter.sh | grep -q "^#!/bin/bash"; then
    pass
else
    fail "starter.sh должен начинаться с #!/bin/bash"
fi

run_test "Проверка наличия artifacts/network_map.txt"
if [ -f "artifacts/network_map.txt" ]; then
    pass
else
    fail "artifacts/network_map.txt не найден"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Category 2: Script Structure
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

run_test "Проверка наличия функций в скрипте"
if [ -f "starter.sh" ]; then
    # Проверяем что есть хотя бы одна функция (function_name() {)
    if grep -Eq "^[a-zA-Z_][a-zA-Z0-9_]*\(\)" starter.sh; then
        pass
    else
        fail "Скрипт должен содержать функции"
    fi
else
    fail "starter.sh не найден"
fi

run_test "Проверка использования get_workstation_ip функции"
if [ -f "starter.sh" ] && grep -q "get_workstation_ip" starter.sh; then
    pass
else
    fail "Функция get_workstation_ip не найдена в starter.sh"
fi

run_test "Проверка использования get_viktor_server_ip функции"
if [ -f "starter.sh" ] && grep -q "get_viktor_server_ip" starter.sh; then
    pass
else
    fail "Функция get_viktor_server_ip не найдена в starter.sh"
fi

run_test "Проверка использования generate_report функции"
if [ -f "starter.sh" ] && grep -q "generate_report" starter.sh; then
    pass
else
    fail "Функция generate_report не найдена в starter.sh"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Category 3: Required Commands Usage
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

run_test "Проверка использования команды 'ip'"
if [ -f "starter.sh" ] && grep -qE "\bip\b" starter.sh; then
    pass
else
    fail "Команда 'ip' должна использоваться в скрипте (для ip a, ip route)"
fi

run_test "Проверка использования команды 'ping'"
if [ -f "starter.sh" ] && grep -qE "\bping\b" starter.sh; then
    pass
else
    fail "Команда 'ping' должна использоваться в скрипте"
fi

run_test "Проверка использования ss или netstat"
if [ -f "starter.sh" ] && grep -qE "\b(ss|netstat)\b" starter.sh; then
    pass
else
    fail "Команда 'ss' или 'netstat' должна использоваться для проверки портов"
fi

run_test "Проверка упоминания nmap (или симуляция)"
if [ -f "starter.sh" ] && grep -qE "\bnmap\b" starter.sh; then
    pass
else
    fail "nmap должен упоминаться (реальное использование или симуляция)"
fi

run_test "Проверка использования grep для парсинга"
if [ -f "starter.sh" ] && grep -qE "\bgrep\b" starter.sh; then
    pass
else
    fail "grep должен использоваться для парсинга network_map.txt"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Category 4: Script Execution
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

run_test "Выполнение starter.sh (проверка синтаксиса)"
if [ -f "starter.sh" ] && [ -x "starter.sh" ]; then
    # Проверка синтаксиса bash (не запускаем, только проверяем)
    if bash -n starter.sh 2>/dev/null; then
        pass
    else
        fail "Ошибка синтаксиса в starter.sh (запустите: bash -n starter.sh)"
    fi
else
    fail "starter.sh не найден или не исполняемый"
fi

run_test "Запуск starter.sh (реальное выполнение)"
if [ -f "starter.sh" ] && [ -x "starter.sh" ]; then
    # Запускаем скрипт с timeout 30 секунд
    if timeout 30 ./starter.sh >/dev/null 2>&1; then
        pass
    else
        EXIT_CODE=$?
        if [ $EXIT_CODE -eq 124 ]; then
            fail "Скрипт выполняется слишком долго (> 30 секунд)"
        else
            fail "Скрипт завершился с ошибкой (exit code: $EXIT_CODE)"
        fi
    fi
else
    fail "starter.sh не найден или не исполняемый"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Category 5: Output & Report
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

run_test "Проверка создания artifacts/network_report.txt"
if [ -f "starter.sh" ] && [ -x "starter.sh" ]; then
    # Запускаем скрипт
    timeout 30 ./starter.sh >/dev/null 2>&1 || true

    if [ -f "artifacts/network_report.txt" ]; then
        pass
    else
        fail "artifacts/network_report.txt не создан скриптом"
    fi
else
    fail "starter.sh не найден или не исполняемый"
fi

run_test "Проверка содержимого отчёта: Workstation IP"
if [ -f "artifacts/network_report.txt" ]; then
    if grep -qi "workstation" artifacts/network_report.txt && \
       grep -Eq "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" artifacts/network_report.txt; then
        pass
    else
        fail "Отчёт должен содержать IP адрес рабочей станции"
    fi
else
    fail "artifacts/network_report.txt не найден"
fi

run_test "Проверка содержимого отчёта: Viktor Server"
if [ -f "artifacts/network_report.txt" ]; then
    if grep -qi "viktor" artifacts/network_report.txt || \
       grep -qi "shadow-server-02" artifacts/network_report.txt; then
        pass
    else
        fail "Отчёт должен упоминать сервер Viktor"
    fi
else
    fail "artifacts/network_report.txt не найден"
fi

run_test "Проверка содержимого отчёта: IP адреса"
if [ -f "artifacts/network_report.txt" ]; then
    # Проверяем что есть хотя бы один IP адрес в формате X.X.X.X
    if grep -Eq "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" artifacts/network_report.txt; then
        pass
    else
        fail "Отчёт должен содержать IP адреса"
    fi
else
    fail "artifacts/network_report.txt не найден"
fi

run_test "Проверка содержимого отчёта: Открытые порты упоминаются"
if [ -f "artifacts/network_report.txt" ]; then
    if grep -qiE "(port|порт)" artifacts/network_report.txt; then
        pass
    else
        fail "Отчёт должен упоминать открытые порты"
    fi
else
    fail "artifacts/network_report.txt не найден"
fi

run_test "Проверка содержимого отчёта: Routing/маршрутизация"
if [ -f "artifacts/network_report.txt" ]; then
    if grep -qiE "(route|routing|маршрут)" artifacts/network_report.txt; then
        pass
    else
        fail "Отчёт должен содержать информацию о маршрутизации"
    fi
else
    fail "artifacts/network_report.txt не найден"
fi

run_test "Проверка размера отчёта (не пустой)"
if [ -f "artifacts/network_report.txt" ]; then
    SIZE=$(wc -c < artifacts/network_report.txt)
    if [ "$SIZE" -gt 500 ]; then
        pass
    else
        fail "Отчёт слишком мал ($SIZE bytes). Должен быть детальным (> 500 bytes)"
    fi
else
    fail "artifacts/network_report.txt не найден"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Category 6: Best Practices
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

run_test "Проверка использования кавычек вокруг переменных"
if [ -f "starter.sh" ]; then
    # Проверяем что есть "$VAR" (хорошая практика)
    if grep -q '"\$' starter.sh; then
        pass
    else
        fail "Используйте кавычки вокруг переменных: \"\$VAR\" (best practice)"
    fi
else
    fail "starter.sh не найден"
fi

run_test "Проверка наличия комментариев"
if [ -f "starter.sh" ]; then
    COMMENT_COUNT=$(grep -c "^#" starter.sh || echo 0)
    if [ "$COMMENT_COUNT" -gt 5 ]; then
        pass
    else
        fail "Добавьте больше комментариев в скрипт ($COMMENT_COUNT найдено, нужно > 5)"
    fi
else
    fail "starter.sh не найден"
fi

run_test "Проверка использования set -e или проверки ошибок"
if [ -f "starter.sh" ]; then
    if grep -qE "(set -e|if.*\$\?)" starter.sh; then
        pass
    else
        fail "Рекомендуется использовать 'set -e' или проверку exit codes"
    fi
else
    fail "starter.sh не найден"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Category 7: Episode-Specific Requirements
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

run_test "Проверка чтения network_map.txt"
if [ -f "starter.sh" ]; then
    if grep -q "network_map.txt" starter.sh; then
        pass
    else
        fail "Скрипт должен читать artifacts/network_map.txt для получения IP серверов"
    fi
else
    fail "starter.sh не найден"
fi

run_test "Проверка hostname shadow-server-02.ops.internal в коде"
if [ -f "starter.sh" ]; then
    if grep -q "shadow-server-02.ops.internal" starter.sh; then
        pass
    else
        fail "Скрипт должен упоминать shadow-server-02.ops.internal"
    fi
else
    fail "starter.sh не найден"
fi

run_test "Проверка формата отчёта (структура)"
if [ -f "artifacts/network_report.txt" ]; then
    # Проверяем что есть хотя бы 3 секции (помеченные [1], [2], [3] или подобное)
    SECTIONS=$(grep -cE "^\[?[0-9]+\]?" artifacts/network_report.txt || echo 0)
    if [ "$SECTIONS" -ge 3 ]; then
        pass
    else
        fail "Отчёт должен иметь структурированный формат с секциями (найдено: $SECTIONS)"
    fi
else
    fail "artifacts/network_report.txt не найден"
fi

###############################################################################
# Summary
###############################################################################

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  РЕЗУЛЬТАТЫ ТЕСТИРОВАНИЯ                                      ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

echo "Всего тестов:   $TESTS_TOTAL"
echo -e "${GREEN}Пройдено:       $TESTS_PASSED${NC}"
echo -e "${RED}Провалено:      $TESTS_FAILED${NC}"
echo ""

PERCENTAGE=$((TESTS_PASSED * 100 / TESTS_TOTAL))
echo "Прогресс: $PERCENTAGE%"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║  ✓ ВСЕ ТЕСТЫ ПРОЙДЕНЫ!                                        ║"
    echo "║                                                               ║"
    echo "║  Отличная работа, Max!                                        ║"
    echo "║  TCP/IP Fundamentals освоены.                                 ║"
    echo "║                                                               ║"
    echo "║  Следующий эпизод: Episode 06 — DNS & Name Resolution         ║"
    echo "║  Локация: Stockholm, Sweden (Bahnhof Pionen Datacenter)      ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    echo -e "${BLUE}LILITH:${NC}"
    echo '"Каждый пакет рассказывает историю. Ты научился слушать.'
    echo ' Москва — первый бой. Стокгольм — следующий уровень.'
    echo ' Готовься к DNS spoofing атаке Krylov..."'
    echo ""
    exit 0
elif [ $PERCENTAGE -ge 70 ]; then
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║  ⚠ БОЛЬШИНСТВО ТЕСТОВ ПРОЙДЕНО                                ║"
    echo "║                                                               ║"
    echo "║  Хорошая работа! Но есть что улучшить.                        ║"
    echo "║  Проверьте провалившиеся тесты выше.                          ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    exit 1
else
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║  ✗ НУЖНО ДОРАБОТАТЬ                                           ║"
    echo "║                                                               ║"
    echo "║  Много тестов провалено.                                      ║"
    echo "║  Проверьте:                                                   ║"
    echo "║    - Структура скрипта (функции)                              ║"
    echo "║    - Использование команд (ip, ping, ss, nmap)                ║"
    echo "║    - Генерация отчёта                                         ║"
    echo "║                                                               ║"
    echo "║  Подсказка: посмотрите solution/network_audit.sh              ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    exit 1
fi

#!/bin/bash

################################################################################
# OPERATION KERNEL SHADOWS - Episode 02
# Automated Test Suite
################################################################################

set -euo pipefail

# Цвета
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Счётчики
tests_total=0
tests_passed=0
tests_failed=0

################################################################################
# Функция: запуск теста
################################################################################
run_test() {
    local test_name="$1"
    local test_command="$2"

    ((tests_total++))

    echo -n "Test $tests_total: $test_name ... "

    # Временно отключаем set -e для теста
    set +e
    eval "$test_command" &>/dev/null
    local result=$?
    set -e

    if [[ $result -eq 0 ]]; then
        echo -e "${GREEN}PASS${NC}"
        ((tests_passed++))
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        ((tests_failed++))
        return 1
    fi
}

################################################################################
# Функция: проверка файла
################################################################################
check_file_exists() {
    local file="$1"
    [[ -f "$file" ]]
}

################################################################################
# Функция: проверка исполняемости
################################################################################
check_executable() {
    local file="$1"
    [[ -x "$file" ]]
}

################################################################################
# Функция: проверка содержимого
################################################################################
check_file_contains() {
    local file="$1"
    local pattern="$2"
    grep -q "$pattern" "$file"
}

################################################################################
# Главная функция
################################################################################
main() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║        KERNEL SHADOWS - Episode 02 Test Suite             ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Переход в директорию эпизода
    cd "$(dirname "$0")/.."

    echo "Working directory: $(pwd)"
    echo ""

    # ========================================
    # Тест 1: Проверка структуры
    # ========================================

    run_test "artifacts/servers.txt существует" \
        "check_file_exists artifacts/servers.txt" || true

    run_test "starter.sh существует" \
        "check_file_exists starter.sh" || true

    run_test "solution/server_monitor.sh существует" \
        "check_file_exists solution/server_monitor.sh" || true

    # ========================================
    # Тест 2: Проверка starter.sh
    # ========================================

    if [[ -f "starter.sh" ]]; then
        run_test "starter.sh имеет shebang" \
            "check_file_contains starter.sh '^#!/bin/bash'" || true

        run_test "starter.sh содержит функции" \
            "check_file_contains starter.sh 'check_server_status\\(\\)'" || true
    fi

    # ========================================
    # Тест 3: Проверка solution
    # ========================================

    if [[ -f "solution/server_monitor.sh" ]]; then
        run_test "solution исполняемый" \
            "check_executable solution/server_monitor.sh" || true

        run_test "solution имеет shebang" \
            "check_file_contains solution/server_monitor.sh '^#!/bin/bash'" || true

        run_test "solution содержит set -euo pipefail" \
            "check_file_contains solution/server_monitor.sh 'set -euo pipefail'" || true

        run_test "solution содержит функцию check_server_status" \
            "check_file_contains solution/server_monitor.sh 'check_server_status\\(\\)'" || true

        run_test "solution содержит функцию log_to_file" \
            "check_file_contains solution/server_monitor.sh 'log_to_file\\(\\)'" || true
    fi

    # ========================================
    # Тест 4: Функциональные тесты solution
    # ========================================

    if [[ -f "solution/server_monitor.sh" && -x "solution/server_monitor.sh" ]]; then
        echo ""
        echo -e "${YELLOW}=== Функциональное тестирование ===${NC}"
        echo ""

        # Подготовка тестовой среды
        test_dir=$(mktemp -d)
        cp solution/server_monitor.sh "$test_dir/"

        # Создаём тестовый servers.txt
        cat > "$test_dir/servers.txt" << 'EOF'
# Test servers
test-online-1 8.8.8.8
test-online-2 1.1.1.1
test-offline-1 192.168.255.255
EOF

        cd "$test_dir"

        # Запуск скрипта
        echo "Запуск server_monitor.sh..."
        if ./server_monitor.sh 2>/dev/null; then
            exit_code=$?
        else
            exit_code=$?
        fi

        cd - >/dev/null

        # Проверки
        run_test "Создан monitor.log" \
            "[[ -f '$test_dir/monitor.log' ]]" || true

        run_test "Создан alerts.txt" \
            "[[ -f '$test_dir/alerts.txt' ]]" || true

        if [[ -f "$test_dir/monitor.log" ]]; then
            run_test "monitor.log содержит логи" \
                "[[ -s '$test_dir/monitor.log' ]]" || true

            run_test "Логи содержат timestamp" \
                "grep -q '\\[[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}' '$test_dir/monitor.log'" || true
        fi

        # Очистка
        rm -rf "$test_dir"
    fi

    # ========================================
    # Тест 5: Проверка пользовательского решения
    # ========================================

    echo ""
    echo -e "${YELLOW}=== Проверка пользовательского решения ===${NC}"
    echo ""

    # Ищем server_monitor.sh в текущей директории или artifacts/
    user_script=""

    if [[ -f "server_monitor.sh" ]]; then
        user_script="server_monitor.sh"
    elif [[ -f "artifacts/server_monitor.sh" ]]; then
        user_script="artifacts/server_monitor.sh"
    elif [[ -f "../server_monitor.sh" ]]; then
        user_script="../server_monitor.sh"
    fi

    if [[ -n "$user_script" ]]; then
        echo "Найден пользовательский скрипт: $user_script"
        echo ""

        run_test "Пользовательский скрипт имеет shebang" \
            "check_file_contains '$user_script' '^#!/bin/bash'" || true

        run_test "Пользовательский скрипт содержит функции" \
            "check_file_contains '$user_script' '\\(\\)'" || true

        if [[ -x "$user_script" ]]; then
            run_test "Пользовательский скрипт исполняемый" "true" || true
        else
            run_test "Пользовательский скрипт исполняемый" "false" || true
            echo -e "  ${YELLOW}→ Подсказка: chmod +x $user_script${NC}"
        fi
    else
        echo -e "${YELLOW}Пользовательский скрипт не найден.${NC}"
        echo "Создай server_monitor.sh в одной из директорий:"
        echo "  - $(pwd)/"
        echo "  - $(pwd)/artifacts/"
        echo ""
    fi

    # ========================================
    # Итоги
    # ========================================

    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                      Test Results                          ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Всего тестов: $tests_total"
    echo -e "${GREEN}Пройдено: $tests_passed${NC}"

    if [[ $tests_failed -gt 0 ]]; then
        echo -e "${RED}Провалено: $tests_failed${NC}"
        echo ""
        echo -e "${YELLOW}Рекомендации:${NC}"
        echo "1. Проверь что все файлы созданы"
        echo "2. Убедись что скрипт исполняемый: chmod +x server_monitor.sh"
        echo "3. Проверь что скрипт содержит все необходимые функции"
        echo "4. Протестируй скрипт вручную: ./server_monitor.sh"
        echo ""
        exit 1
    else
        echo ""
        echo -e "${GREEN}✅ Все тесты пройдены!${NC}"
        echo ""
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo "LILITH: \"Хорошая работа, Max. Код чистый, тесты пройдены."
        echo "         Dmitry будет доволен. Ты готов к Episode 03.\""
        echo ""
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        exit 0
    fi
}

################################################################################
# Запуск
################################################################################
main "$@"


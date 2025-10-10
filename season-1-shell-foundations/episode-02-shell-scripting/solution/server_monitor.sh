#!/bin/bash

################################################################################
# OPERATION KERNEL SHADOWS - Episode 02
# Server Monitoring Script
# Author: Max Sokolov
# Date: 04 October 2025
#
# Описание:
#   Проверяет доступность серверов из файла servers.txt
#   Логирует результаты в monitor.log
#   Создаёт алерты в alerts.txt для offline серверов
#
# Использование:
#   ./server_monitor.sh
################################################################################

set -euo pipefail

# Константы
readonly SERVERS_FILE="servers.txt"
readonly LOG_FILE="monitor.log"
readonly ALERT_FILE="alerts.txt"

# Цвета для вывода
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Счётчики
total_servers=0
online_servers=0
offline_servers=0

################################################################################
# Функция: проверка доступности сервера
# Аргументы:
#   $1 - IP адрес сервера
# Возвращает:
#   0 - сервер доступен
#   1 - сервер недоступен
################################################################################
check_server_status() {
    local server_ip="$1"
    local timeout=2
    local count=1

    if ping -c "$count" -W "$timeout" "$server_ip" &>/dev/null; then
        return 0  # Online
    else
        return 1  # Offline
    fi
}

################################################################################
# Функция: логирование в файл с timestamp
# Аргументы:
#   $1 - сообщение для логирования
################################################################################
log_to_file() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" >> "$LOG_FILE"
}

################################################################################
# Функция: добавление алерта
# Аргументы:
#   $1 - сообщение алерта
################################################################################
add_alert() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] ALERT: $message" >> "$ALERT_FILE"
}

################################################################################
# Функция: вывод статуса в терминал с цветом
# Аргументы:
#   $1 - имя сервера
#   $2 - IP адрес
#   $3 - статус (online/offline)
################################################################################
print_status() {
    local server_name="$1"
    local server_ip="$2"
    local status="$3"

    if [[ "$status" == "online" ]]; then
        echo -e "${GREEN}✅${NC} $server_name ($server_ip) — ${GREEN}ONLINE${NC}"
    else
        echo -e "${RED}❌${NC} $server_name ($server_ip) — ${RED}OFFLINE${NC}"
    fi
}

################################################################################
# Функция: проверка всех серверов
################################################################################
check_all_servers() {
    echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║    KERNEL SHADOWS - Server Monitoring         ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
    echo ""

    # Проверка существования файла
    if [[ ! -f "$SERVERS_FILE" ]]; then
        echo -e "${RED}❌ ОШИБКА: Файл $SERVERS_FILE не найден${NC}"
        log_to_file "ERROR: $SERVERS_FILE not found"
        exit 1
    fi

    # Очистка файла алертов
    > "$ALERT_FILE"

    log_to_file "=== Monitoring started ==="

    # Читаем файл построчно
    while IFS= read -r line; do
        # Пропускаем пустые строки и комментарии
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        # Парсинг строки (имя и IP)
        local server_name=$(echo "$line" | awk '{print $1}')
        local server_ip=$(echo "$line" | awk '{print $2}')

        # Пропускаем если IP пустой
        [[ -z "$server_ip" ]] && continue

        ((total_servers++))

        # Проверка статуса
        if check_server_status "$server_ip"; then
            print_status "$server_name" "$server_ip" "online"
            log_to_file "$server_name ($server_ip) — ONLINE"
            ((online_servers++))
        else
            print_status "$server_name" "$server_ip" "offline"
            log_to_file "$server_name ($server_ip) — OFFLINE"
            add_alert "$server_name ($server_ip) is OFFLINE"
            ((offline_servers++))
        fi

    done < "$SERVERS_FILE"

    log_to_file "=== Monitoring completed | Online: $online_servers/$total_servers ==="
}

################################################################################
# Функция: вывод статистики
################################################################################
print_statistics() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}📊 Статистика:${NC}"
    echo "   Всего серверов: $total_servers"
    echo -e "   ${GREEN}Онлайн: $online_servers${NC}"

    if [[ $offline_servers -gt 0 ]]; then
        echo -e "   ${RED}Оффлайн: $offline_servers${NC}"
        echo ""
        echo -e "${YELLOW}⚠️  Обнаружены проблемы! Проверь $ALERT_FILE${NC}"
    else
        echo -e "   ${GREEN}Оффлайн: 0${NC}"
        echo ""
        echo -e "${GREEN}✅ Все серверы работают нормально${NC}"
    fi

    echo ""
    echo "📝 Логи: $LOG_FILE"
    echo "⚠️  Алерты: $ALERT_FILE"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

################################################################################
# Главная функция
################################################################################
main() {
    # Проверка всех серверов
    check_all_servers

    # Статистика
    print_statistics

    # Exit code
    if [[ $offline_servers -gt 0 ]]; then
        exit 1  # Есть проблемы
    else
        exit 0  # Всё ОК
    fi
}

################################################################################
# Запуск
################################################################################
main "$@"

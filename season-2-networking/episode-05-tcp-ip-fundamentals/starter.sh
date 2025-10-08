#!/bin/bash

###############################################################################
# Episode 05: TCP/IP Fundamentals — Network Audit Script
# KERNEL SHADOWS — Season 2: Networking
#
# Operator: Max Sokolov
# Location: ЦОД "Москва-1", Россия
# Day: 9 of 60
#
# Mission: Создать скрипт для аудита сети операции Viktor
###############################################################################

# Строгий режим (рекомендуется)
set -e  # Exit on error

# Цвета для вывода (опционально)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

###############################################################################
# TODO 1: Определить IP адрес рабочей станции
###############################################################################

# Подсказка: Используйте команду `ip a` и извлеките IP адрес
# Пример: ip a show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1

get_workstation_ip() {
    # TODO: Реализуйте функцию
    # Должна вернуть IP адрес (например, 192.168.100.42)

    echo "???.???.???.???"  # Замените на реальный IP
}

###############################################################################
# TODO 2: Определить IP сервера Viktor
###############################################################################

# Подсказка: Используйте ping или host команду
# Альтернатива: прочитайте из artifacts/network_map.txt

get_viktor_server_ip() {
    local hostname="shadow-server-02.ops.internal"

    # TODO: Реализуйте функцию
    # Вариант 1: ping -c 1 $hostname | grep "PING" | awk -F'[()]' '{print $2}'
    # Вариант 2: Прочитайте из artifacts/network_map.txt

    # Для симуляции (если нет реального DNS):
    if [ -f "artifacts/network_map.txt" ]; then
        grep "$hostname" artifacts/network_map.txt | awk '{print $1}'
    else
        echo "10.50.1.100"  # Fallback
    fi
}

###############################################################################
# TODO 3: Проверить доступность сервера (ping)
###############################################################################

check_server_availability() {
    local server_ip="$1"

    # TODO: Реализуйте функцию
    # Используйте ping -c 4
    # Проверьте exit code: $? -eq 0 = success

    echo "Проверка доступности $server_ip..."

    # Ваш код здесь

    echo "✓ Сервер доступен"  # Или "✗ Сервер недоступен"
}

###############################################################################
# TODO 4: Traceroute (симуляция)
###############################################################################

# Подсказка: traceroute требует sudo и может не работать локально
# Для симуляции можете просто вывести ожидаемый результат

simulate_traceroute() {
    local server_ip="$1"

    echo "Маршрут до сервера Viktor ($server_ip):"

    # TODO: Реализуйте симуляцию traceroute
    # Пример вывода:
    # echo "  1  192.168.100.1    1.2ms   (Gateway)"
    # echo "  2  10.50.0.1        2.5ms   (ЦОД Switch)"
    # echo "  3  $server_ip       3.1ms   (Viktor Server)"

    # Ваш код здесь
}

###############################################################################
# TODO 5: Проверить открытые порты локально (ss или netstat)
###############################################################################

check_local_ports() {
    echo "Открытые порты на рабочей станции Max:"

    # TODO: Используйте ss -tuln или netstat -tuln
    # Фильтруйте только LISTEN состояния

    # Ваш код здесь
}

###############################################################################
# TODO 6: Сканирование портов сервера Viktor (nmap симуляция)
###############################################################################

# Подсказка: nmap может не работать если сервер не существует
# Для симуляции выведите ожидаемые порты

scan_viktor_server() {
    local server_ip="$1"

    echo "Сканирование портов сервера Viktor ($server_ip)..."

    # TODO: Реализуйте симуляцию nmap
    # Или используйте реальный nmap если доступен:
    # if command -v nmap &> /dev/null; then
    #     nmap --top-ports 100 "$server_ip"
    # fi

    # Симуляция:
    echo "  22/tcp   open  ssh"
    echo "  80/tcp   open  http"
    echo "  443/tcp  open  https"
}

###############################################################################
# TODO 7: Показать routing table
###############################################################################

show_routing_table() {
    echo "Таблица маршрутизации:"

    # TODO: Используйте ip route show

    # Ваш код здесь
}

###############################################################################
# TODO 8: Генерация отчёта
###############################################################################

generate_report() {
    local workstation_ip="$1"
    local viktor_ip="$2"
    local report_file="artifacts/network_report.txt"

    echo "Генерация отчёта..."

    # TODO: Создайте детальный отчёт
    # Формат:
    # === NETWORK AUDIT REPORT ===
    # Date: $(date)
    # Operator: Max Sokolov
    # Location: ЦОД "Москва-1"
    #
    # [1] Workstation IP: ...
    # [2] Viktor Server: ...
    # [3] Traceroute: ...
    # [4] Open Ports (Local): ...
    # [5] Open Ports (Viktor Server): ...
    # [6] Routing: ...
    # === END REPORT ===

    {
        echo "=== NETWORK AUDIT REPORT ==="
        echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Operator: Max Sokolov"
        echo "Location: ЦОД \"Москва-1\""
        echo ""

        # TODO: Добавьте остальные секции

        echo "=== END REPORT ==="
    } > "$report_file"

    echo "✓ Отчёт сохранён: $report_file"
}

###############################################################################
# Главная функция
###############################################################################

main() {
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║  KERNEL SHADOWS — Episode 05: TCP/IP Fundamentals        ║"
    echo "║  Network Audit Script                                     ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""

    # TODO: Вызовите все функции

    # 1. Определить IP рабочей станции
    WORKSTATION_IP=$(get_workstation_ip)
    echo "[1] Workstation IP: $WORKSTATION_IP"
    echo ""

    # 2. Определить IP сервера Viktor
    VIKTOR_SERVER_IP=$(get_viktor_server_ip)
    echo "[2] Viktor Server IP: $VIKTOR_SERVER_IP"
    echo ""

    # 3. Проверить доступность
    # TODO: check_server_availability "$VIKTOR_SERVER_IP"
    echo ""

    # 4. Traceroute
    # TODO: simulate_traceroute "$VIKTOR_SERVER_IP"
    echo ""

    # 5. Открытые порты локально
    # TODO: check_local_ports
    echo ""

    # 6. Сканирование Viktor сервера
    # TODO: scan_viktor_server "$VIKTOR_SERVER_IP"
    echo ""

    # 7. Routing table
    # TODO: show_routing_table
    echo ""

    # 8. Генерация отчёта
    # TODO: generate_report "$WORKSTATION_IP" "$VIKTOR_SERVER_IP"
    echo ""

    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║  Миссия завершена!                                        ║"
    echo "║  Проверьте artifacts/network_report.txt                   ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
}

# Запуск
main "$@"

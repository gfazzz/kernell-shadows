#!/bin/bash

###############################################################################
# Episode 05: TCP/IP Fundamentals — Network Audit Script (SOLUTION)
# KERNEL SHADOWS — Season 2: Networking
#
# Operator: Max Sokolov
# Location: ЦОД "Москва-1", Россия
# Day: 9 of 60
#
# Mission: Создать скрипт для аудита сети операции Viktor
###############################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

###############################################################################
# Функция 1: Определить IP адрес рабочей станции
###############################################################################

get_workstation_ip() {
    # Попробуем найти активный сетевой интерфейс (не loopback)
    # Приоритет: eth0, ens33, wlan0, или первый доступный

    local ip=""

    # Попытка 1: eth0
    if ip a show eth0 &>/dev/null; then
        ip=$(ip a show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1 | head -n1)
    fi

    # Попытка 2: ens33 (VirtualBox/VMware часто используют)
    if [ -z "$ip" ] && ip a show ens33 &>/dev/null; then
        ip=$(ip a show ens33 | grep "inet " | awk '{print $2}' | cut -d/ -f1 | head -n1)
    fi

    # Попытка 3: wlan0 (Wi-Fi)
    if [ -z "$ip" ] && ip a show wlan0 &>/dev/null; then
        ip=$(ip a show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1 | head -n1)
    fi

    # Попытка 4: Первый доступный интерфейс (не lo)
    if [ -z "$ip" ]; then
        ip=$(ip -4 a | grep -v "127.0.0.1" | grep "inet " | awk '{print $2}' | cut -d/ -f1 | head -n1)
    fi

    # Fallback: localhost (если ничего не найдено)
    if [ -z "$ip" ]; then
        ip="127.0.0.1"
    fi

    echo "$ip"
}

###############################################################################
# Функция 2: Определить IP сервера Viktor
###############################################################################

get_viktor_server_ip() {
    local hostname="shadow-server-02.ops.internal"
    local ip=""

    # Попытка 1: Прочитать из artifacts/network_map.txt (симуляция)
    if [ -f "artifacts/network_map.txt" ]; then
        ip=$(grep "$hostname" artifacts/network_map.txt 2>/dev/null | awk '{print $1}')
    fi

    # Попытка 2: Проверить /etc/hosts (если добавили вручную)
    if [ -z "$ip" ]; then
        ip=$(grep "$hostname" /etc/hosts 2>/dev/null | grep -v "^#" | awk '{print $1}' | head -n1)
    fi

    # Попытка 3: DNS lookup (host команда)
    if [ -z "$ip" ] && command -v host &>/dev/null; then
        ip=$(host "$hostname" 2>/dev/null | grep "has address" | awk '{print $4}' | head -n1)
    fi

    # Fallback: Симуляция
    if [ -z "$ip" ]; then
        ip="10.50.1.100"
    fi

    echo "$ip"
}

###############################################################################
# Функция 3: Проверить доступность сервера (ping)
###############################################################################

check_server_availability() {
    local server_ip="$1"

    echo -e "${BLUE}[3] Проверка доступности сервера $server_ip...${NC}"

    # ping -c 4: отправить 4 пакета
    # -W 2: timeout 2 секунды
    # &>/dev/null: скрыть вывод

    if ping -c 4 -W 2 "$server_ip" &>/dev/null; then
        echo -e "${GREEN}✓ Сервер доступен (ping successful)${NC}"

        # Показать latency
        local latency=$(ping -c 4 -W 2 "$server_ip" 2>/dev/null | tail -1 | awk -F '/' '{print $5}')
        if [ -n "$latency" ]; then
            echo "  Average latency: ${latency}ms"
        fi

        return 0
    else
        echo -e "${RED}✗ Сервер недоступен (ping failed)${NC}"
        echo "  Возможные причины:"
        echo "    - Сервер выключен"
        echo "    - Firewall блокирует ICMP"
        echo "    - Сетевая проблема"

        return 1
    fi
}

###############################################################################
# Функция 4: Traceroute (симуляция)
###############################################################################

simulate_traceroute() {
    local server_ip="$1"

    echo -e "${BLUE}[4] Маршрут до сервера Viktor ($server_ip):${NC}"

    # Попытка использовать реальный traceroute/tracepath
    if command -v tracepath &>/dev/null; then
        echo "  (Используя tracepath...)"
        tracepath -n "$server_ip" 2>/dev/null | head -n 10 || true
    elif command -v traceroute &>/dev/null; then
        echo "  (Используя traceroute...)"
        timeout 10 traceroute -n -m 10 "$server_ip" 2>/dev/null | head -n 10 || true
    else
        # Симуляция (если команды недоступны)
        echo "  (Симуляция traceroute)"
        echo "  1  192.168.100.1    1.2ms   (Home Gateway)"
        echo "  2  10.50.0.1        2.5ms   (ЦОД 'Москва-1' Switch)"
        echo "  3  $server_ip       3.1ms   (shadow-server-02.ops.internal)"
        echo ""
        echo -e "${GREEN}✓ 3 hops, последний узел в ЦОДе Москва-1${NC}"
    fi
}

###############################################################################
# Функция 5: Проверить открытые порты локально (ss или netstat)
###############################################################################

check_local_ports() {
    echo -e "${BLUE}[5] Открытые порты на рабочей станции Max:${NC}"

    # Используем ss если доступен (более современный)
    if command -v ss &>/dev/null; then
        echo "  (Используя ss -tuln)"
        ss -tuln | grep LISTEN | awk '{print "  " $1 "\t" $5}' | head -n 10
    # Fallback: netstat
    elif command -v netstat &>/dev/null; then
        echo "  (Используя netstat -tuln)"
        netstat -tuln | grep LISTEN | awk '{print "  " $1 "\t" $4}' | head -n 10
    else
        echo -e "${YELLOW}  ⚠ ss/netstat не найдены${NC}"
    fi

    echo ""
    echo -e "${YELLOW}  ⚠ Проверьте: нужны ли все эти порты?${NC}"
    echo "    Каждый открытый порт = потенциальная уязвимость"
}

###############################################################################
# Функция 6: Сканирование портов сервера Viktor (nmap симуляция)
###############################################################################

scan_viktor_server() {
    local server_ip="$1"

    echo -e "${BLUE}[6] Сканирование портов сервера Viktor ($server_ip):${NC}"

    # Попытка использовать nmap если установлен
    if command -v nmap &>/dev/null; then
        echo "  (Используя nmap --top-ports 100)"
        # Timeout 30 секунд для защиты
        timeout 30 nmap --top-ports 100 -T4 "$server_ip" 2>/dev/null | grep -E "^[0-9]+" || true
    else
        # Симуляция (если nmap не установлен)
        echo "  (Симуляция nmap — установите nmap для реального сканирования)"
        echo ""
        echo "  PORT     STATE  SERVICE"
        echo "  22/tcp   open   ssh"
        echo "  80/tcp   open   http"
        echo "  443/tcp  open   https"
        echo ""
        echo -e "${GREEN}✓ Обнаружено 3 открытых порта${NC}"
    fi

    echo ""
    echo -e "${YELLOW}  Analysis:${NC}"
    echo "    ✓ SSH (22) — OK (нужен для управления)"
    echo "    ⚠ HTTP (80) — зачем? Должен быть только HTTPS"
    echo "    ✓ HTTPS (443) — OK (веб-интерфейс)"
}

###############################################################################
# Функция 7: Показать routing table
###############################################################################

show_routing_table() {
    echo -e "${BLUE}[7] Таблица маршрутизации:${NC}"

    if command -v ip &>/dev/null; then
        ip route show | sed 's/^/  /'
    else
        echo -e "${YELLOW}  ⚠ ip команда не найдена${NC}"
    fi

    echo ""

    # Найти default gateway
    local gateway=$(ip route | grep default | awk '{print $3}' | head -n1)
    if [ -n "$gateway" ]; then
        echo -e "${GREEN}✓ Default gateway: $gateway${NC}"
    else
        echo -e "${YELLOW}⚠ Default gateway не найден${NC}"
    fi
}

###############################################################################
# Функция 8: Генерация отчёта
###############################################################################

generate_report() {
    local workstation_ip="$1"
    local viktor_ip="$2"
    local report_file="artifacts/network_report.txt"

    echo -e "${BLUE}[8] Генерация отчёта...${NC}"

    # Убедиться что artifacts/ существует
    mkdir -p artifacts

    # Генерация отчёта
    {
        echo "╔═══════════════════════════════════════════════════════════════╗"
        echo "║           NETWORK AUDIT REPORT                                ║"
        echo "╚═══════════════════════════════════════════════════════════════╝"
        echo ""
        echo "Date:     $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Operator: Max Sokolov"
        echo "Location: ЦОД \"Москва-1\", Россия"
        echo "Day:      9 of 60 (KERNEL SHADOWS Operation)"
        echo ""
        echo "════════════════════════════════════════════════════════════════"
        echo ""

        echo "[1] WORKSTATION IP ADDRESS"
        echo "    $workstation_ip"
        echo ""

        echo "[2] VIKTOR SERVER"
        echo "    Hostname: shadow-server-02.ops.internal"
        echo "    IP:       $viktor_ip"

        # Проверка доступности (без вывода в консоль)
        if ping -c 2 -W 1 "$viktor_ip" &>/dev/null; then
            echo "    Status:   ONLINE ✓"
        else
            echo "    Status:   OFFLINE or FIREWALLED ✗"
        fi
        echo ""

        echo "[3] TRACEROUTE"
        echo "    Route to Viktor Server:"
        if command -v tracepath &>/dev/null; then
            tracepath -n "$viktor_ip" 2>/dev/null | head -n 5 | sed 's/^/    /' || echo "    (traceroute unavailable)"
        else
            echo "    1  192.168.100.1    (Gateway)"
            echo "    2  10.50.0.1        (ЦОД Switch)"
            echo "    3  $viktor_ip       (Viktor Server)"
        fi
        echo ""

        echo "[4] OPEN PORTS (Local Workstation)"
        if command -v ss &>/dev/null; then
            ss -tuln 2>/dev/null | grep LISTEN | awk '{print "    " $1 "\t" $5}' | head -n 10
        elif command -v netstat &>/dev/null; then
            netstat -tuln 2>/dev/null | grep LISTEN | awk '{print "    " $1 "\t" $4}' | head -n 10
        else
            echo "    (ss/netstat not available)"
        fi
        echo ""

        echo "[5] OPEN PORTS (Viktor Server)"
        if command -v nmap &>/dev/null; then
            timeout 20 nmap --top-ports 50 -T4 "$viktor_ip" 2>/dev/null | grep -E "^[0-9]+" | sed 's/^/    /' || echo "    (nmap scan failed or no open ports)"
        else
            echo "    22/tcp    open    ssh"
            echo "    80/tcp    open    http"
            echo "    443/tcp   open    https"
            echo "    (simulated — install nmap for real scan)"
        fi
        echo ""

        echo "[6] ROUTING TABLE"
        if command -v ip &>/dev/null; then
            ip route show 2>/dev/null | sed 's/^/    /'
        else
            echo "    (ip command not available)"
        fi
        echo ""

        echo "════════════════════════════════════════════════════════════════"
        echo ""
        echo "ANALYSIS & RECOMMENDATIONS:"
        echo ""
        echo "  ✓ Workstation IP identified: $workstation_ip"
        echo "  ✓ Viktor server located: $viktor_ip"

        if ping -c 1 -W 1 "$viktor_ip" &>/dev/null; then
            echo "  ✓ Server is reachable (ping successful)"
        else
            echo "  ⚠ Server is unreachable (check firewall/network)"
        fi

        echo ""
        echo "  Security Notes:"
        echo "    - Close unnecessary ports on local workstation"
        echo "    - HTTP port 80 on Viktor server should redirect to HTTPS"
        echo "    - Consider VPN for all communications (Episode 08)"
        echo "    - Monitor for unusual connections (Krylov surveillance)"
        echo ""

        echo "════════════════════════════════════════════════════════════════"
        echo ""
        echo "END OF REPORT"
        echo ""
        echo "Generated by: network_audit.sh"
        echo "Episode: 05 — TCP/IP Fundamentals"
        echo "Next: Episode 06 — DNS & Name Resolution (Stockholm, Sweden)"

    } > "$report_file"

    echo -e "${GREEN}✓ Отчёт сохранён: $report_file${NC}"
    echo "  Размер: $(du -h "$report_file" | awk '{print $1}')"
}

###############################################################################
# Главная функция
###############################################################################

main() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║  KERNEL SHADOWS — Episode 05: TCP/IP Fundamentals            ║"
    echo "║  Network Audit Script (SOLUTION)                             ║"
    echo "║                                                               ║"
    echo "║  Operator: Max Sokolov                                        ║"
    echo "║  Location: ЦОД \"Москва-1\"                                   ║"
    echo "║  Day: 9 of 60                                                 ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    # 1. Определить IP рабочей станции
    echo -e "${BLUE}[1] Определение IP адреса рабочей станции...${NC}"
    WORKSTATION_IP=$(get_workstation_ip)
    echo -e "${GREEN}✓ Workstation IP: $WORKSTATION_IP${NC}"
    echo ""

    # 2. Определить IP сервера Viktor
    echo -e "${BLUE}[2] Определение IP сервера Viktor...${NC}"
    VIKTOR_SERVER_IP=$(get_viktor_server_ip)
    echo -e "${GREEN}✓ Viktor Server: shadow-server-02.ops.internal → $VIKTOR_SERVER_IP${NC}"
    echo ""

    # 3. Проверить доступность
    check_server_availability "$VIKTOR_SERVER_IP" || true  # Continue even if ping fails
    echo ""

    # 4. Traceroute
    simulate_traceroute "$VIKTOR_SERVER_IP"
    echo ""

    # 5. Открытые порты локально
    check_local_ports
    echo ""

    # 6. Сканирование Viktor сервера
    scan_viktor_server "$VIKTOR_SERVER_IP"
    echo ""

    # 7. Routing table
    show_routing_table
    echo ""

    # 8. Генерация отчёта
    generate_report "$WORKSTATION_IP" "$VIKTOR_SERVER_IP"
    echo ""

    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║  ✓ Миссия завершена!                                          ║"
    echo "║                                                               ║"
    echo "║  Отчёт: artifacts/network_report.txt                          ║"
    echo "║  Тесты: ./tests/test.sh                                       ║"
    echo "║                                                               ║"
    echo "║  Next: Episode 06 — DNS & Name Resolution                     ║"
    echo "║        Stockholm, Sweden (Bahnhof Pionen Datacenter)          ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    # Показать содержимое отчёта
    echo -e "${YELLOW}Предпросмотр отчёта:${NC}"
    echo "─────────────────────────────────────────────────────────────────"
    head -n 30 artifacts/network_report.txt
    echo "  ..."
    echo "  (См. полный отчёт в artifacts/network_report.txt)"
    echo "─────────────────────────────────────────────────────────────────"
}

# Запуск
main "$@"

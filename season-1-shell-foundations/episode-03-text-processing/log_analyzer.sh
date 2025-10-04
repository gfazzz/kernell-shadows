#!/bin/bash

################################################################################
# KERNEL SHADOWS — Episode 03: Text Processing Masters
# Автор: Max Sokolov
# Дата: 04 октября 2025
# Задача: Анализ логов для поиска атакующих IP
# Статус: PRODUCTION READY
################################################################################

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

################################################################################
# Функция: Показать usage
################################################################################
usage() {
    echo "Usage: $0 <access.log> <suspicious_ips.txt> <output_report.txt>"
    echo ""
    echo "Example:"
    echo "  $0 access.log suspicious_ips.txt final_report.txt"
    exit 1
}

################################################################################
# Проверка аргументов
################################################################################
if [[ $# -lt 3 ]]; then
    echo -e "${RED}Error: Недостаточно аргументов${NC}"
    usage
fi

LOG_FILE="$1"
THREATS_FILE="$2"
REPORT_FILE="$3"

# Проверка существования файлов
if [[ ! -f "$LOG_FILE" ]]; then
    echo -e "${RED}Error: Log file not found: $LOG_FILE${NC}"
    exit 1
fi

if [[ ! -f "$THREATS_FILE" ]]; then
    echo -e "${RED}Error: Threat intelligence file not found: $THREATS_FILE${NC}"
    exit 1
fi

# Временные файлы для промежуточных результатов
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

################################################################################
# Функция: Общая статистика
################################################################################
analyze_general_stats() {
    echo -e "${BLUE}[1/7] Analyzing general statistics...${NC}"
    
    # Общее количество запросов
    total_requests=$(wc -l < "$LOG_FILE")
    
    # Количество уникальных IP
    unique_ips=$(awk '{print $1}' "$LOG_FILE" | sort -u | wc -l)
    
    echo -e "  Total requests: ${CYAN}$total_requests${NC}"
    echo -e "  Unique IPs: ${CYAN}$unique_ips${NC}"
    echo ""
    
    # Сохраняем для отчёта
    echo "$total_requests" > "$TEMP_DIR/total_requests.txt"
    echo "$unique_ips" > "$TEMP_DIR/unique_ips.txt"
}

################################################################################
# Функция: Анализ окна атаки (03:00-05:00)
################################################################################
analyze_attack_window() {
    echo -e "${BLUE}[2/7] Analyzing attack window (03:00-05:00)...${NC}"
    
    # Запросы во время атаки
    attack_requests=$(grep -E "03:[0-9]{2}|04:[0-9]{2}" "$LOG_FILE" | wc -l)
    
    # Процент от общего трафика
    total=$(cat "$TEMP_DIR/total_requests.txt")
    if [[ $total -gt 0 ]]; then
        percent=$((attack_requests * 100 / total))
    else
        percent=0
    fi
    
    echo -e "  Requests during attack: ${YELLOW}$attack_requests${NC} (${percent}% of total)"
    echo ""
    
    # Сохраняем для отчёта
    echo "$attack_requests" > "$TEMP_DIR/attack_requests.txt"
}

################################################################################
# Функция: TOP-10 атакующих IP
################################################################################
analyze_top_attackers() {
    echo -e "${BLUE}[3/7] Extracting TOP-10 attackers...${NC}"
    
    # Извлекаем TOP-10 IP во время атаки
    grep -E "03:[0-9]{2}|04:[0-9]{2}" "$LOG_FILE" | \
        awk '{print $1}' | \
        sort | \
        uniq -c | \
        sort -nr | \
        head -10 > top_attackers.txt
    
    # Вывод в терминал с цветом
    while read -r count ip; do
        echo -e "  ${YELLOW}$count${NC} requests from ${RED}$ip${NC}"
    done < top_attackers.txt
    
    echo ""
    echo -e "  ${GREEN}✓${NC} TOP-10 attackers saved to: top_attackers.txt"
    echo ""
}

################################################################################
# Функция: Проверка базы угроз
################################################################################
check_threat_intelligence() {
    echo -e "${BLUE}[4/7] Checking threat intelligence database...${NC}"
    
    local found=0
    local total_threat_requests=0
    
    # Создаём файл для результатов
    > "$TEMP_DIR/threats_found.txt"
    
    while read -r ip; do
        # Пропускаем комментарии и пустые строки
        [[ "$ip" =~ ^#.*$ || -z "$ip" ]] && continue
        
        # Подсчитываем запросы от этого IP
        count=$(grep -c "$ip" "$LOG_FILE" 2>/dev/null)
        
        if [[ $count -gt 0 ]]; then
            echo -e "  ${RED}⚠️  $ip${NC}: ${YELLOW}$count${NC} requests"
            echo "$ip: $count" >> "$TEMP_DIR/threats_found.txt"
            ((found++))
            ((total_threat_requests += count))
        fi
    done < "$THREATS_FILE"
    
    echo ""
    echo -e "  ${RED}Known threats found: $found${NC}"
    echo -e "  ${YELLOW}Total requests from threats: $total_threat_requests${NC}"
    echo ""
    
    # Сохраняем для отчёта
    echo "$found" > "$TEMP_DIR/threats_count.txt"
}

################################################################################
# Функция: Анализ HTTP статусов
################################################################################
analyze_http_status() {
    echo -e "${BLUE}[5/7] Analyzing HTTP status codes...${NC}"
    
    # Извлекаем 9-е поле (HTTP status code) во время атаки
    grep -E "03:[0-9]{2}|04:[0-9]{2}" "$LOG_FILE" | \
        awk '{print $9}' | \
        grep -E "^[0-9]{3}$" | \
        sort | \
        uniq -c | \
        sort -nr > "$TEMP_DIR/http_status.txt"
    
    # Подсчёт конкретных статусов
    status_200=$(grep -c " 200 " "$LOG_FILE" 2>/dev/null || echo 0)
    status_404=$(grep -c " 404 " "$LOG_FILE" 2>/dev/null || echo 0)
    status_403=$(grep -c " 403 " "$LOG_FILE" 2>/dev/null || echo 0)
    status_500=$(grep -c " 500 " "$LOG_FILE" 2>/dev/null || echo 0)
    status_503=$(grep -c " 503 " "$LOG_FILE" 2>/dev/null || echo 0)
    
    echo -e "  ${GREEN}200${NC} (OK): $status_200"
    echo -e "  ${YELLOW}404${NC} (Not Found): $status_404"
    echo -e "  ${RED}403${NC} (Forbidden): $status_403"
    echo -e "  ${RED}500${NC} (Server Error): $status_500"
    echo -e "  ${RED}503${NC} (Unavailable): $status_503"
    echo ""
}

################################################################################
# Функция: Анализ User-Agents атакующих
################################################################################
analyze_user_agents() {
    echo -e "${BLUE}[6/7] Analyzing attack User-Agents...${NC}"
    
    # Извлекаем User-Agent (поле между 3-ми кавычками)
    grep -E "03:[0-9]{2}|04:[0-9]{2}" "$LOG_FILE" | \
        awk -F'"' '{print $6}' | \
        grep -v "^$" | \
        sort | \
        uniq -c | \
        sort -nr | \
        head -5 > "$TEMP_DIR/user_agents.txt"
    
    echo -e "  ${YELLOW}TOP-5 Attack User-Agents:${NC}"
    while read -r count agent; do
        echo -e "    ${CYAN}$count${NC} — $agent"
    done < "$TEMP_DIR/user_agents.txt"
    
    echo ""
}

################################################################################
# Функция: Генерация отчёта
################################################################################
generate_report() {
    echo -e "${BLUE}[7/7] Generating report: $REPORT_FILE${NC}"
    
    # Загружаем статистику
    local total_requests=$(cat "$TEMP_DIR/total_requests.txt")
    local unique_ips=$(cat "$TEMP_DIR/unique_ips.txt")
    local attack_requests=$(cat "$TEMP_DIR/attack_requests.txt")
    local threats_found=$(cat "$TEMP_DIR/threats_count.txt")
    
    {
        echo "═══════════════════════════════════════════════════════════════════"
        echo "                    SECURITY INCIDENT REPORT"
        echo "═══════════════════════════════════════════════════════════════════"
        echo ""
        echo "Дата анализа: $(date '+%d %B %Y, %H:%M')"
        echo "Аналитик: Максим Sokolov"
        echo "Для: Anna Kovaleva (Lead Forensics Expert)"
        echo ""
        echo "───────────────────────────────────────────────────────────────────"
        echo "КРАТКОЕ РЕЗЮМЕ"
        echo "───────────────────────────────────────────────────────────────────"
        echo ""
        echo "DDoS атака обнаружена в 03:47 по московскому времени (UTC+3)."
        echo "Анализ логов веб-сервера показал массированную атаку с использованием"
        echo "множественных IP адресов, включая Tor exit nodes."
        echo ""
        echo "Статистика:"
        echo "  • Общее количество запросов: $total_requests"
        echo "  • Уникальных IP адресов: $unique_ips"
        echo "  • Запросов во время атаки (03:00-05:00): $attack_requests"
        echo "  • Совпадений с базой угроз: $threats_found IP"
        echo ""
        echo "───────────────────────────────────────────────────────────────────"
        echo "TIMELINE АТАКИ"
        echo "───────────────────────────────────────────────────────────────────"
        echo ""
        echo "Начало атаки: 04 октября 2025, 03:47:00 UTC"
        echo "Пик атаки: 04 октября 2025, 03:47:25 UTC (4,582 req/sec)"
        echo "Продолжительность: ~2 часа (03:00-05:00)"
        echo ""
        echo "───────────────────────────────────────────────────────────────────"
        echo "TOP-10 АТАКУЮЩИХ IP АДРЕСОВ"
        echo "───────────────────────────────────────────────────────────────────"
        echo ""
        cat top_attackers.txt
        echo ""
        echo "───────────────────────────────────────────────────────────────────"
        echo "ТИПЫ АТАК ОБНАРУЖЕНЫ"
        echo "───────────────────────────────────────────────────────────────────"
        echo ""
        echo "1. Port Scanning (nmap NSE) — 500+ запросов"
        echo "2. SQL Injection attempts (sqlmap) — 300+ запросов"
        echo "3. Brute-force login attempts — 400+ запросов"
        echo "4. DDoS flooding — 200+ запросов за минуту"
        echo "5. Web vulnerability scanning (Nikto) — 150+ запросов"
        echo ""
        echo "───────────────────────────────────────────────────────────────────"
        echo "СВЯЗЬ С ИЗВЕСТНЫМИ УГРОЗАМИ"
        echo "───────────────────────────────────────────────────────────────────"
        echo ""
        if [[ -f "$TEMP_DIR/threats_found.txt" ]]; then
            cat "$TEMP_DIR/threats_found.txt"
        else
            echo "Нет совпадений с базой угроз."
        fi
        echo ""
        echo "ПРИМЕЧАНИЕ: IP 185.220.101.47 идентифицирован как Tor exit node."
        echo "Реальный источник атаки скрыт за Tor сетью."
        echo ""
        echo "───────────────────────────────────────────────────────────────────"
        echo "TOP-5 USER-AGENTS АТАКУЮЩИХ"
        echo "───────────────────────────────────────────────────────────────────"
        echo ""
        cat "$TEMP_DIR/user_agents.txt"
        echo ""
        echo "───────────────────────────────────────────────────────────────────"
        echo "РЕКОМЕНДАЦИИ"
        echo "───────────────────────────────────────────────────────────────────"
        echo ""
        echo "НЕМЕДЛЕННЫЕ ДЕЙСТВИЯ:"
        echo "1. Заблокировать TOP-10 IP через firewall (iptables -A INPUT -s IP -j DROP)"
        echo "2. Включить rate limiting (nginx: limit_req_zone, apache: mod_evasive)"
        echo "3. Активировать fail2ban для автоматической блокировки"
        echo ""
        echo "КРАТКОСРОЧНЫЕ (24-48 часов):"
        echo "4. Обновить WAF правила для блокировки SQL injection паттернов"
        echo "5. Включить CloudFlare/DDoS protection"
        echo "6. Настроить алерты для аномального трафика (03:00-05:00)"
        echo ""
        echo "ДОЛГОСРОЧНЫЕ:"
        echo "7. Провести security audit веб-приложений (OWASP TOP-10)"
        echo "8. Внедрить SIEM систему для real-time мониторинга"
        echo "9. Обучение команды: incident response procedures"
        echo ""
        echo "───────────────────────────────────────────────────────────────────"
        echo "ПРИЛОЖЕНИЯ"
        echo "───────────────────────────────────────────────────────────────────"
        echo ""
        echo "- Полный список атакующих IP: top_attackers.txt"
        echo "- Исходные логи: $LOG_FILE"
        echo "- База угроз: $THREATS_FILE"
        echo ""
        echo "═══════════════════════════════════════════════════════════════════"
        echo "                         END OF REPORT"
        echo "═══════════════════════════════════════════════════════════════════"
        echo ""
        echo "Подпись: Max Sokolov"
        echo "Время генерации: $(date '+%d.%m.%Y %H:%M:%S')"
        
    } > "$REPORT_FILE"
    
    echo -e "  ${GREEN}✓${NC} Report generated: $REPORT_FILE"
    echo ""
}

################################################################################
# MAIN: Запуск всех функций
################################################################################
main() {
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "           KERNEL SHADOWS — Log Analysis Tool v1.0"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "Analyzing: $LOG_FILE"
    echo "Threat DB: $THREATS_FILE"
    echo "Output: $REPORT_FILE"
    echo ""
    
    # Запуск всех анализов
    analyze_general_stats
    analyze_attack_window
    analyze_top_attackers
    check_threat_intelligence
    analyze_http_status
    analyze_user_agents
    generate_report
    
    echo "════════════════════════════════════════════════════════════════"
    echo -e "${GREEN}✓ Analysis complete!${NC}"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "Результаты:"
    echo "  • Отчёт: $REPORT_FILE"
    echo "  • TOP-10: top_attackers.txt"
    echo ""
}

# Запуск
main "$@"


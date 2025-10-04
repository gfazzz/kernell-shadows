#!/bin/bash

################################################################################
# KERNEL SHADOWS — Episode 03: Text Processing Masters
# Автор: [Ваше имя]
# Дата: 04 октября 2025
# Задача: Анализ логов для поиска атакующих IP
################################################################################

# Цвета для вывода (опционально)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# TODO: Проверьте существование файлов
# Подсказка: [[ ! -f "$LOG_FILE" ]] && { echo "Error"; exit 1; }





################################################################################
# Функция: Общая статистика
################################################################################
analyze_general_stats() {
    echo -e "${BLUE}[1/7] Analyzing general statistics...${NC}"

    # TODO: Подсчитайте общее количество запросов
    # Подсказка: wc -l < "$LOG_FILE"
    total_requests=

    # TODO: Подсчитайте количество уникальных IP
    # Подсказка: awk '{print $1}' | sort -u | wc -l
    unique_ips=

    echo "  Total requests: $total_requests"
    echo "  Unique IPs: $unique_ips"
    echo ""
}

################################################################################
# Функция: Анализ окна атаки (03:00-05:00)
################################################################################
analyze_attack_window() {
    echo -e "${BLUE}[2/7] Analyzing attack window (03:00-05:00)...${NC}"

    # TODO: Найдите запросы во время атаки
    # Подсказка: grep -E "03:[0-9]{2}|04:[0-9]{2}" "$LOG_FILE"
    attack_requests=

    echo "  Requests during attack: $attack_requests"
    echo ""
}

################################################################################
# Функция: TOP-10 атакующих IP
################################################################################
analyze_top_attackers() {
    echo -e "${BLUE}[3/7] Extracting TOP-10 attackers...${NC}"

    # TODO: Извлеките TOP-10 IP адресов во время атаки
    # Подсказка:
    # 1. grep -E "03:[0-9]{2}|04:[0-9]{2}" "$LOG_FILE"
    # 2. awk '{print $1}'
    # 3. sort | uniq -c | sort -nr | head -10

    # Сохраните результат в top_attackers.txt




    echo "  TOP-10 attackers saved to: top_attackers.txt"
    echo ""
}

################################################################################
# Функция: Проверка базы угроз
################################################################################
check_threat_intelligence() {
    echo -e "${BLUE}[4/7] Checking threat intelligence database...${NC}"

    local found=0

    # TODO: Проверьте каждый IP из suspicious_ips.txt
    # Подсказка: while read -r ip; do ... done < "$THREATS_FILE"






    echo "  Known threats found: $found"
    echo ""
}

################################################################################
# Функция: Анализ HTTP статусов
################################################################################
analyze_http_status() {
    echo -e "${BLUE}[5/7] Analyzing HTTP status codes...${NC}"

    # TODO: Подсчитайте количество разных HTTP статусов
    # Подсказка: awk '{print $9}' | grep -E "^[0-9]{3}$" | sort | uniq -c

    # HTTP 200 (OK)
    status_200=

    # HTTP 404 (Not Found)
    status_404=

    # HTTP 403 (Forbidden)
    status_403=

    # HTTP 500 (Internal Server Error)
    status_500=

    # HTTP 503 (Service Unavailable)
    status_503=

    echo "  200 (OK): $status_200"
    echo "  404 (Not Found): $status_404"
    echo "  403 (Forbidden): $status_403"
    echo "  500 (Server Error): $status_500"
    echo "  503 (Unavailable): $status_503"
    echo ""
}

################################################################################
# Функция: Анализ User-Agents атакующих
################################################################################
analyze_user_agents() {
    echo -e "${BLUE}[6/7] Analyzing attack User-Agents...${NC}"

    # TODO: Извлеките TOP-5 User-Agents во время атаки
    # Подсказка:
    # 1. grep -E "03:[0-9]{2}|04:[0-9]{2}" "$LOG_FILE"
    # 2. awk -F'"' '{print $6}'
    # 3. grep -v "^$" | sort | uniq -c | sort -nr | head -5




    echo ""
}

################################################################################
# Функция: Генерация отчёта
################################################################################
generate_report() {
    echo -e "${BLUE}[7/7] Generating report: $REPORT_FILE${NC}"

    # TODO: Создайте структурированный отчёт
    # Можно использовать шаблон из report_template.txt
    # Или создать свой формат

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
        # TODO: Добавьте резюме атаки

        echo ""
        echo "───────────────────────────────────────────────────────────────────"
        echo "TOP-10 АТАКУЮЩИХ IP АДРЕСОВ"
        echo "───────────────────────────────────────────────────────────────────"
        echo ""
        # TODO: Вставьте TOP-10 из top_attackers.txt

        echo ""
        echo "───────────────────────────────────────────────────────────────────"
        echo "РЕКОМЕНДАЦИИ"
        echo "───────────────────────────────────────────────────────────────────"
        echo ""
        echo "1. Заблокировать TOP-10 IP через firewall (iptables/ufw)"
        echo "2. Включить rate limiting для предотвращения DDoS"
        echo "3. Усилить мониторинг на период 03:00-05:00"
        echo ""
        echo "═══════════════════════════════════════════════════════════════════"

    } > "$REPORT_FILE"

    echo -e "${GREEN}  ✓ Report generated: $REPORT_FILE${NC}"
    echo ""
}

################################################################################
# MAIN: Запуск всех функций
################################################################################
main() {
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "           KERNEL SHADOWS — Log Analysis Tool"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "Analyzing: $LOG_FILE"
    echo "Threat DB: $THREATS_FILE"
    echo "Output: $REPORT_FILE"
    echo ""

    # TODO: Вызовите все функции анализа
    analyze_general_stats
    analyze_attack_window
    analyze_top_attackers
    check_threat_intelligence
    analyze_http_status
    analyze_user_agents
    generate_report

    echo "════════════════════════════════════════════════════════════════"
    echo -e "${GREEN}Analysis complete!${NC}"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
}

# Запуск
main "$@"


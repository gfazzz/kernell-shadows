#!/bin/bash

################################################################################
# KERNEL SHADOWS — Episode 03: Text Processing Masters
# SOLUTION: log_analyzer.sh (Type B approach)
#
# Автор: Max Sokolov
# Дата: 05 октября 2025
#
# Type B philosophy:
#   - 70% Linux tools (grep, awk, sort, uniq)
#   - 30% bash glue (variables, output formatting)
#   - Focus on ONE-LINERS, not bash programming
################################################################################

set -euo pipefail  # Strict mode

# Check arguments
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <access.log>"
    echo ""
    echo "Example:"
    echo "  $0 artifacts/access.log"
    exit 1
fi

# Constants
readonly LOG="$1"
readonly THREATS="artifacts/suspicious_ips.txt"
readonly REPORT="final_report.txt"

# Validate log file exists
[[ ! -f "$LOG" ]] && { echo "Error: Log file not found: $LOG"; exit 1; }
[[ ! -f "$THREATS" ]] && { echo "Error: Threats file not found: $THREATS"; exit 1; }

################################################################################
# Report generation using ONE-LINERS
################################################################################

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
    echo "ОБЩАЯ СТАТИСТИКА"
    echo "───────────────────────────────────────────────────────────────────"
    echo ""

    # ONE-LINER: Total requests
    echo "Всего запросов: $(wc -l < "$LOG")"

    # ONE-LINER: Unique IPs
    echo "Уникальных IP: $(awk '{print $1}' "$LOG" | sort -u | wc -l)"

    # ONE-LINER: Attack window requests
    echo "Запросов во время атаки (03:47): $(grep -c "03:47" "$LOG")"

    echo ""
    echo "───────────────────────────────────────────────────────────────────"
    echo "TOP-10 АТАКУЮЩИХ IP АДРЕСОВ (03:47-04:00)"
    echo "───────────────────────────────────────────────────────────────────"
    echo ""

    # ONE-LINER: TOP-10 attacking IPs during attack window
    grep "03:47" "$LOG" | awk '{print $1}' | sort | uniq -c | sort -nr | head -10

    echo ""
    echo "───────────────────────────────────────────────────────────────────"
    echo "HTTP STATUS CODES СТАТИСТИКА"
    echo "───────────────────────────────────────────────────────────────────"
    echo ""

    # ONE-LINER: HTTP status codes distribution
    awk '{print $9}' "$LOG" | sort | uniq -c | sort -nr

    echo ""
    echo "───────────────────────────────────────────────────────────────────"
    echo "ПРОВЕРКА THREAT INTELLIGENCE DATABASE"
    echo "───────────────────────────────────────────────────────────────────"
    echo ""

    # Loop для проверки каждого IP из threat database
    # (Минимальный bash - единственное место где нужен loop)
    while read -r ip; do
        # Пропустить комментарии и пустые строки
        [[ "$ip" =~ ^#.*$ || -z "$ip" ]] && continue

        # ONE-LINER: Count requests from this IP
        count=$(grep -c "$ip" "$LOG" 2>/dev/null || echo 0)

        # Если найден - вывести
        [[ $count -gt 0 ]] && echo "  ⚠️  FOUND: $ip ($count requests)"
    done < "$THREATS"

    echo ""
    echo "───────────────────────────────────────────────────────────────────"
    echo "TOP-5 USER-AGENTS АТАКУЮЩИХ"
    echo "───────────────────────────────────────────────────────────────────"
    echo ""

    # ONE-LINER: TOP-5 User-Agents during attack
    grep "03:47" "$LOG" | awk -F'"' '{print $6}' | sort | uniq -c | sort -nr | head -5

    echo ""
    echo "───────────────────────────────────────────────────────────────────"
    echo "АНАЛИЗ ТИПОВ ЗАПРОСОВ"
    echo "───────────────────────────────────────────────────────────────────"
    echo ""

    # ONE-LINER: TOP-10 requested paths
    echo "TOP-10 запрашиваемых путей:"
    awk '{print $7}' "$LOG" | sort | uniq -c | sort -nr | head -10

    echo ""
    echo "───────────────────────────────────────────────────────────────────"
    echo "РЕКОМЕНДАЦИИ"
    echo "───────────────────────────────────────────────────────────────────"
    echo ""
    echo "НЕМЕДЛЕННЫЕ ДЕЙСТВИЯ:"
    echo "1. Заблокировать TOP-10 IP через iptables:"
    echo "   iptables -A INPUT -s 185.220.101.47 -j DROP"
    echo ""
    echo "2. Включить rate limiting на веб-сервере:"
    echo "   nginx: limit_req_zone"
    echo "   apache: mod_evasive"
    echo ""
    echo "3. Активировать fail2ban для автоматической блокировки"
    echo ""
    echo "КРАТКОСРОЧНЫЕ (24-48 часов):"
    echo "4. Обновить WAF правила (sqlmap, nmap signatures)"
    echo "5. Включить CloudFlare DDoS protection"
    echo "6. Настроить мониторинг алертов (03:00-05:00)"
    echo ""
    echo "═══════════════════════════════════════════════════════════════════"
    echo "                         END OF REPORT"
    echo "═══════════════════════════════════════════════════════════════════"
    echo ""
    echo "Подпись: Max Sokolov"
    echo "Время генерации: $(date '+%d.%m.%Y %H:%M:%S')"

} > "$REPORT"

# Также сохранить TOP-10 в отдельный файл для тестов
grep "03:47" "$LOG" | awk '{print $1}' | sort | uniq -c | sort -nr | head -10 > top_attackers.txt

################################################################################
# Summary output to terminal
################################################################################
echo ""
echo "════════════════════════════════════════════════════════════════"
echo "           KERNEL SHADOWS — Log Analysis Complete"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "✓ Analyzing: $LOG"
echo "✓ Threat DB: $THREATS"
echo "✓ Report saved: $REPORT"
echo "✓ TOP-10 saved: top_attackers.txt"
echo ""
echo "Quick stats:"
echo "  • Total requests: $(wc -l < "$LOG")"
echo "  • Unique IPs: $(awk '{print $1}' "$LOG" | sort -u | wc -l)"
echo "  • Attack window (03:47): $(grep -c "03:47" "$LOG") requests"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""

# Display preview of TOP-3 attackers
echo "TOP-3 Attackers:"
grep "03:47" "$LOG" | awk '{print $1}' | sort | uniq -c | sort -nr | head -3

echo ""
echo "Full report: $REPORT"
echo ""

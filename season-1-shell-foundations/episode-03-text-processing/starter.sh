#!/bin/bash

################################################################################
# KERNEL SHADOWS — Episode 03: Text Processing Masters
# STARTER TEMPLATE: log_analyzer.sh
#
# Задача: Построить минимальный bash wrapper используя ONE-LINERS
#
# Type B philosophy:
#   - 70% Linux tools (grep, awk, sort, uniq, pipes)
#   - 30% bash glue (variables, loops)
#   - ONE-LINERS вместо сложной bash логики
################################################################################

set -euo pipefail  # Strict mode: exit on error

# ═══════════════════════════════════════════════════════════════════════════
# TODO 1: SETUP — Constants and validation (5 минут)
# ═══════════════════════════════════════════════════════════════════════════

# TODO 1.1: Define constants
# Hints:
#   - LOG = first argument ($1)
#   - THREATS = "artifacts/suspicious_ips.txt"
#   - REPORT = "final_report.txt"
#   - Use 'readonly' для констант

# TODO: Uncomment and fill:
# readonly LOG="$1"
# readonly THREATS="artifacts/suspicious_ips.txt"
# readonly REPORT="final_report.txt"

# TODO 1.2: Validate arguments
# Hints:
#   - Check if LOG argument provided: [[ $# -lt 1 ]]
#   - Check if files exist: [[ ! -f "$LOG" ]]
#   - Exit with error code 1 if validation fails

# TODO: Uncomment and complete:
# if [[ $# -lt 1 ]]; then
#     echo "Usage: $0 <access.log>"
#     exit 1
# fi

# TODO: Add file existence checks here


# ═══════════════════════════════════════════════════════════════════════════
# TODO 2: REPORT HEADER — Create report structure (3 минуты)
# ═══════════════════════════════════════════════════════════════════════════

# TODO 2.1: Start report file with header
# Hints:
#   - Use { ... } > "$REPORT" для group commands
#   - Весь вывод внутри { } пойдёт в файл
#   - Используй echo для форматирования

# TODO: Create report header (example provided):
{
    echo "═══════════════════════════════════════════════════════════════════"
    echo "                    SECURITY INCIDENT REPORT"
    echo "═══════════════════════════════════════════════════════════════════"
    echo ""
    echo "Дата анализа: $(date '+%d %B %Y, %H:%M')"
    echo "Аналитик: Максим Sokolov"
    echo ""

    # ═══════════════════════════════════════════════════════════════════════
    # TODO 3: GENERAL STATISTICS — Use ONE-LINERS (10 минут)
    # ═══════════════════════════════════════════════════════════════════════

    echo "───────────────────────────────────────────────────────────────────"
    echo "ОБЩАЯ СТАТИСТИКА"
    echo "───────────────────────────────────────────────────────────────────"
    echo ""

    # TODO 3.1: Count total requests
    # Hints:
    #   - Use: wc -l < "$LOG"
    #   - Command substitution: $(...)
    # TODO: Uncomment and test:
    # echo "Всего запросов: $(wc -l < "$LOG")"

    # TODO 3.2: Count unique IP addresses
    # Hints:
    #   - Extract IP: awk '{print $1}' "$LOG"
    #   - Unique: sort -u
    #   - Count: wc -l
    # TODO: Build ONE-LINER:
    # echo "Уникальных IP: $(awk '{print $1}' "$LOG" | sort -u | wc -l)"

    # TODO 3.3: Count requests during attack window (03:47)
    # Hints:
    #   - Use: grep -c "03:47" "$LOG"
    # TODO: Complete:
    # echo "Запросов во время атаки: $(grep -c "03:47" "$LOG")"

    echo ""

    # ═══════════════════════════════════════════════════════════════════════
    # TODO 4: TOP-10 ATTACKERS — Build the classic pipeline (15 минут)
    # ═══════════════════════════════════════════════════════════════════════

    echo "───────────────────────────────────────────────────────────────────"
    echo "TOP-10 АТАКУЮЩИХ IP АДРЕСОВ (03:47)"
    echo "───────────────────────────────────────────────────────────────────"
    echo ""

    # TODO 4.1: Build ONE-LINER for TOP-10 attacking IPs
    # Hints:
    #   Step 1: Filter attack window: grep "03:47" "$LOG"
    #   Step 2: Extract IP field: | awk '{print $1}'
    #   Step 3: Sort for uniq: | sort
    #   Step 4: Count duplicates: | uniq -c
    #   Step 5: Sort by count (numeric, reverse): | sort -nr
    #   Step 6: Take TOP-10: | head -10
    #
    # TODO: Complete the pipeline:
    # grep "03:47" "$LOG" | awk '{print $1}' | sort | uniq -c | sort -nr | head -10

    echo ""

    # ═══════════════════════════════════════════════════════════════════════
    # TODO 5: HTTP STATUS CODES — Statistics (10 минут)
    # ═══════════════════════════════════════════════════════════════════════

    echo "───────────────────────────────────────────────────────────────────"
    echo "HTTP STATUS CODES СТАТИСТИКА"
    echo "───────────────────────────────────────────────────────────────────"
    echo ""

    # TODO 5.1: Extract and count HTTP status codes
    # Hints:
    #   - HTTP status = field #9: awk '{print $9}'
    #   - Sort, count, sort by frequency
    #
    # TODO: Build pipeline:
    # awk '{print $9}' "$LOG" | sort | uniq -c | sort -nr

    echo ""

    # ═══════════════════════════════════════════════════════════════════════
    # TODO 6: THREAT INTELLIGENCE CHECK — Loop через базу (10 минут)
    # ═══════════════════════════════════════════════════════════════════════

    echo "───────────────────────────────────────────────────────────────────"
    echo "ПРОВЕРКА THREAT INTELLIGENCE DATABASE"
    echo "───────────────────────────────────────────────────────────────────"
    echo ""

    # TODO 6.1: Check each IP from threat database
    # Hints:
    #   - Read file line by line: while read -r ip; do ... done < "$THREATS"
    #   - Skip comments: [[ "$ip" =~ ^#.*$ ]] && continue
    #   - Count matches: grep -c "$ip" "$LOG"
    #   - Check if found: [[ $count -gt 0 ]]
    #
    # TODO: Complete the loop:
    # while read -r ip; do
    #     [[ "$ip" =~ ^#.*$ || -z "$ip" ]] && continue
    #     count=$(grep -c "$ip" "$LOG" 2>/dev/null || echo 0)
    #     [[ $count -gt 0 ]] && echo "  ⚠️  FOUND: $ip ($count requests)"
    # done < "$THREATS"

    echo ""

    # ═══════════════════════════════════════════════════════════════════════
    # TODO 7: USER-AGENTS — Extract attack tools (10 минут)
    # ═══════════════════════════════════════════════════════════════════════

    echo "───────────────────────────────────────────────────────────────────"
    echo "TOP-5 USER-AGENTS АТАКУЮЩИХ"
    echo "───────────────────────────────────────────────────────────────────"
    echo ""

    # TODO 7.1: Extract and count User-Agents
    # Hints:
    #   - User-Agent в кавычках (6-е поле при разделителе = ")
    #   - Use awk with custom delimiter: awk -F'"' '{print $6}'
    #   - Filter attack window: grep "03:47"
    #   - Count and sort: sort | uniq -c | sort -nr | head -5
    #
    # TODO: Build pipeline:
    # grep "03:47" "$LOG" | awk -F'"' '{print $6}' | sort | uniq -c | sort -nr | head -5

    echo ""

    # ═══════════════════════════════════════════════════════════════════════
    # TODO 8: BONUS — Requested paths (опционально)
    # ═══════════════════════════════════════════════════════════════════════

    echo "───────────────────────────────────────────────────────────────────"
    echo "TOP-10 ЗАПРАШИВАЕМЫХ ПУТЕЙ"
    echo "───────────────────────────────────────────────────────────────────"
    echo ""

    # TODO 8.1: Extract requested paths (URLs)
    # Hints:
    #   - Request path = field #7: awk '{print $7}'
    #   - Similar pipeline to TOP-10 IPs
    #
    # TODO: Build pipeline:
    # awk '{print $7}' "$LOG" | sort | uniq -c | sort -nr | head -10

    echo ""

    # ═══════════════════════════════════════════════════════════════════════
    # FOOTER
    # ═══════════════════════════════════════════════════════════════════════

    echo "═══════════════════════════════════════════════════════════════════"
    echo "                         END OF REPORT"
    echo "═══════════════════════════════════════════════════════════════════"
    echo ""
    echo "Подпись: Max Sokolov"
    echo "Время генерации: $(date '+%d.%m.%Y %H:%M:%S')"

} > "$REPORT"

# ═══════════════════════════════════════════════════════════════════════════
# TODO 9: SAVE TOP-10 — For automated tests (2 минуты)
# ═══════════════════════════════════════════════════════════════════════════

# TODO 9.1: Save TOP-10 attackers to separate file (needed by tests)
# Hints:
#   - Reuse the same pipeline from TODO 4
#   - Redirect to: top_attackers.txt
#
# TODO: Uncomment:
# grep "03:47" "$LOG" | awk '{print $1}' | sort | uniq -c | sort -nr | head -10 > top_attackers.txt

# ═══════════════════════════════════════════════════════════════════════════
# TODO 10: SUMMARY OUTPUT — Terminal feedback (3 минуты)
# ═══════════════════════════════════════════════════════════════════════════

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "           KERNEL SHADOWS — Log Analysis Complete"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "✓ Report saved: $REPORT"
echo "✓ TOP-10 saved: top_attackers.txt"
echo ""

# TODO 10.1: Display quick preview stats
# Hints:
#   - Reuse ONE-LINERS from TODO 3
#
# TODO: Uncomment:
# echo "Quick stats:"
# echo "  • Total requests: $(wc -l < "$LOG")"
# echo "  • Unique IPs: $(awk '{print $1}' "$LOG" | sort -u | wc -l)"
# echo "  • Attack window: $(grep -c "03:47" "$LOG") requests"

echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""

################################################################################
# NOTES FOR STUDENT
################################################################################
#
# Type B Philosophy Summary:
#   ✅ 70% of the work = Linux tools (grep, awk, sort, uniq)
#   ✅ 30% of the work = bash glue (variables, output formatting, one loop)
#   ✅ Focus: BUILD ONE-LINERS, not complex bash functions
#
# Key ONE-LINERS to master:
#   1. TOP-N pattern: COMMAND | sort | uniq -c | sort -nr | head -N
#   2. Unique count: COMMAND | sort -u | wc -l
#   3. Field extraction: awk '{print $FIELD}' file
#   4. Filter + extract: grep "pattern" file | awk '{print $1}'
#   5. Custom delimiter: awk -F'delimiter' '{print $FIELD}' file
#
# Testing:
#   chmod +x starter.sh
#   ./starter.sh artifacts/access.log
#   cat final_report.txt
#   ./tests/test.sh
#
# Good luck! — LILITH
#
################################################################################

#!/bin/bash

################################################################################
# OPERATION KERNEL SHADOWS
# Episode 01: Terminal Awakening
#
# Решение: Автоматический поиск всех файлов и создание отчёта
#
# LILITH's notes:
# - Всегда shebang на первой строке
# - Кавычки вокруг переменных "$var" — ВСЕГДА
# - 2>/dev/null — подавляет ошибки (permission denied)
# - [[ -n "$var" ]] — проверка что переменная НЕ пустая
# - Security: никогда не запускай скрипты без чтения кода
################################################################################

echo "=== KERNEL SHADOWS: File Search Script ==="
echo "Searching for hidden files..."
echo ""

# LILITH: "Всегда знай где ты. pwd — первое что делаешь на чужом сервере."

# 1. Вывести текущую директорию
echo "Current directory:"
pwd
echo ""

# 2. Найти файл briefing.txt
# LILITH: "find . -name — рекурсивный поиск от текущей директории"
# 2>/dev/null = игнорировать ошибки типа "Permission denied"
echo "Searching for briefing.txt..."
BRIEFING=$(find . -name "briefing.txt" 2>/dev/null)
if [ -n "$BRIEFING" ]; then
    echo "Found: $BRIEFING"
else
    echo "briefing.txt not found!"
fi
echo ""

# 3. Найти все скрытые файлы
# LILITH: "Файлы с . в начале — скрытые. -type f = только файлы, не директории"
echo "Searching for hidden files..."
find . -name ".*" -type f 2>/dev/null | grep -v "^\.$"
echo ""

# 4. Прочитать содержимое файлов
# LILITH: "cat читает файл. ВСЕГДА кавычки вокруг переменных: cat \"$file\""
echo "=== File Contents ==="
echo ""

# [[ -n "$VAR" ]] = проверка: переменная НЕ пустая?
if [ -n "$BRIEFING" ]; then
    echo "--- briefing.txt ---"
    cat "$BRIEFING"
    echo ""
fi

# head -1 = взять первый результат (если файлов несколько)
SECRET_LOC=$(find . -name ".secret_location" -type f 2>/dev/null | head -1)
if [ -n "$SECRET_LOC" ]; then
    echo "--- .secret_location ---"
    cat "$SECRET_LOC"
    echo ""
fi

NEXT_SERVER=$(find . -name ".next_server" -type f 2>/dev/null | head -1)
if [ -n "$NEXT_SERVER" ]; then
    echo "--- .next_server ---"
    cat "$NEXT_SERVER"
    echo ""
fi

# 5. Сохранить результаты в report.txt
# LILITH: "{ ... } > file — перенаправление блока команд в файл"
# $(date) — command substitution, выполняется команда date
# $(whoami) — текущий пользователь
{
    echo "=== KERNEL SHADOWS: Mission Report ==="
    echo "Date: $(date)"
    echo "Operator: $(whoami)"
    echo ""
    echo "Current directory: $(pwd)"
    echo ""
    echo "=== Found Files ==="
    echo ""

    if [ -n "$BRIEFING" ]; then
        echo "File: $BRIEFING"
        echo "Content:"
        cat "$BRIEFING"
        echo ""
    fi

    if [ -n "$SECRET_LOC" ]; then
        echo "File: $SECRET_LOC"
        echo "Content:"
        cat "$SECRET_LOC"
        echo ""
    fi

    if [ -n "$NEXT_SERVER" ]; then
        echo "File: $NEXT_SERVER"
        echo "Content:"
        cat "$NEXT_SERVER"
        echo ""
    fi

    echo "=== Mission Status ==="
    # LILITH: "$((арифметика)) — bash калькулятор. Без $ внутри скобок!"
    FILES_FOUND=0
    [ -n "$BRIEFING" ] && FILES_FOUND=$((FILES_FOUND + 1))
    [ -n "$SECRET_LOC" ] && FILES_FOUND=$((FILES_FOUND + 1))
    [ -n "$NEXT_SERVER" ] && FILES_FOUND=$((FILES_FOUND + 1))

    echo "Files found: $FILES_FOUND/3"

    # -eq = equal (для чисел). Для строк используй ==
    if [ $FILES_FOUND -eq 3 ]; then
        echo "Status: ✅ SUCCESS"
        echo ""
        echo "All files located. Ready for next mission."
        echo "LILITH: \"Неплохо. Ты быстро учишься.\""
    else
        echo "Status: ⚠️ INCOMPLETE"
        echo ""
        echo "Some files missing. Continue search."
        echo "LILITH: \"Не все файлы найдены. Используй ls -la и find.\""
    fi

} > report.txt  # Вся output блока { ... } идёт в report.txt

echo "=== Search complete! ==="
echo "Results saved in report.txt"
echo ""
cat report.txt

# LILITH: "Скрипт завершен. Проверь report.txt. Логи не врут."


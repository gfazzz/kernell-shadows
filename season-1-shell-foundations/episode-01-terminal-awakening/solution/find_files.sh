#!/bin/bash

################################################################################
# OPERATION KERNEL SHADOWS
# Episode 01: Terminal Awakening
# 
# Решение: Автоматический поиск всех файлов и создание отчёта
################################################################################

echo "=== KERNEL SHADOWS: File Search Script ==="
echo "Searching for hidden files..."
echo ""

# 1. Вывести текущую директорию
echo "Current directory:"
pwd
echo ""

# 2. Найти файл briefing.txt
echo "Searching for briefing.txt..."
BRIEFING=$(find . -name "briefing.txt" 2>/dev/null)
if [ -n "$BRIEFING" ]; then
    echo "Found: $BRIEFING"
else
    echo "briefing.txt not found!"
fi
echo ""

# 3. Найти все скрытые файлы
echo "Searching for hidden files..."
find . -name ".*" -type f 2>/dev/null | grep -v "^\.$"
echo ""

# 4. Прочитать содержимое файлов
echo "=== File Contents ==="
echo ""

if [ -n "$BRIEFING" ]; then
    echo "--- briefing.txt ---"
    cat "$BRIEFING"
    echo ""
fi

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
    FILES_FOUND=0
    [ -n "$BRIEFING" ] && FILES_FOUND=$((FILES_FOUND + 1))
    [ -n "$SECRET_LOC" ] && FILES_FOUND=$((FILES_FOUND + 1))
    [ -n "$NEXT_SERVER" ] && FILES_FOUND=$((FILES_FOUND + 1))
    
    echo "Files found: $FILES_FOUND/3"
    
    if [ $FILES_FOUND -eq 3 ]; then
        echo "Status: ✅ SUCCESS"
        echo ""
        echo "All files located. Ready for next mission."
    else
        echo "Status: ⚠️ INCOMPLETE"
        echo ""
        echo "Some files missing. Continue search."
    fi
    
} > report.txt

echo "=== Search complete! ==="
echo "Results saved in report.txt"
echo ""
cat report.txt


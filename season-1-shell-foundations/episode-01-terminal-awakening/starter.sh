#!/bin/bash

################################################################################
# OPERATION KERNEL SHADOWS
# Episode 01: Terminal Awakening
#
# Задание: Найти все скрытые файлы и создать отчёт
#
# LILITH говорит:
# "Это твой первый скрипт. Не спеши. Каждая команда — инструмент.
#  Комментируй код. Проверяй ошибки. Думай как сисадмин."
#
# TODO: Заполните TODO блоки ниже
################################################################################

echo "=== KERNEL SHADOWS: File Search Script ==="
echo "Starting mission..."
echo ""

# LILITH: "Всегда знай где ты. pwd — первая команда на чужом сервере."

# TODO 1: Вывести текущую директорию
# Подсказка: используйте команду pwd
echo "Current directory:"
# YOUR CODE HERE


echo ""

# TODO 2: Найти файл briefing.txt
# Подсказка: используйте find . -name "briefing.txt"
# LILITH: "find — твой детектив. Он найдёт иголку в стоге сена."
echo "Searching for briefing.txt..."
# YOUR CODE HERE


echo ""

# TODO 3: Найти все скрытые файлы (начинаются с .)
# Подсказка: используйте find . -name ".*" -type f
# LILITH: "Точка = невидимость. Но не для тех, кто знает find."
echo "Searching for hidden files..."
# YOUR CODE HERE


echo ""

# TODO 4: Прочитать содержимое найденных файлов
# Подсказка: используйте cat для каждого файла
echo "Reading briefing.txt..."
# YOUR CODE HERE


echo ""
echo "Reading .secret_location..."
# YOUR CODE HERE


echo ""
echo "Reading .next_server..."
# YOUR CODE HERE


echo ""

# TODO 5: Сохранить результаты в report.txt
# Подсказка: перенаправьте вывод с помощью > или >>
# LILITH: "Automation = не делай руками то, что можно закодить."
echo "Saving results to report.txt..."
# YOUR CODE HERE


echo ""
echo "=== Search complete! ==="
echo "Results saved in report.txt"
echo ""
echo "🔍 LILITH: \"Неплохо для первого раза. Проверь report.txt.\""


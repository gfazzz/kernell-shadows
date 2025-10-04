#!/bin/bash

################################################################################
# OPERATION KERNEL SHADOWS
# Episode 01: Terminal Awakening
# 
# Задание: Найти все скрытые файлы и создать отчёт
#
# TODO: Заполните TODO блоки ниже
################################################################################

echo "=== KERNEL SHADOWS: File Search Script ==="
echo "Searching for hidden files..."
echo ""

# TODO 1: Вывести текущую директорию
# Подсказка: используйте команду pwd
echo "Current directory:"
# YOUR CODE HERE


echo ""

# TODO 2: Найти файл briefing.txt
# Подсказка: используйте find . -name "briefing.txt"
echo "Searching for briefing.txt..."
# YOUR CODE HERE


echo ""

# TODO 3: Найти все скрытые файлы (начинаются с .)
# Подсказка: используйте find . -name ".*" -type f
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
# Подсказка: перенаправьте вывод с помощью >
echo "Saving results to report.txt..."
# YOUR CODE HERE


echo ""
echo "=== Search complete! ==="
echo "Results saved in report.txt"


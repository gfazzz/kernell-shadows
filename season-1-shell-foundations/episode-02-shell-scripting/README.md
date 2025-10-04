# Episode 02: Shell Scripting Basics

```
ОПЕРАЦИЯ: KERNEL SHADOWS
СЕЗОН: 1 — Shell & Foundations
ЭПИЗОД: 02 — Shell Scripting Basics
СЛОЖНОСТЬ: ⭐⭐☆☆☆
ВРЕМЯ: 3-4 часа
```

---

## 📅 03 октября 2025, 14:05 — ГУМ, кофейня Bosco

Viktor уже здесь. За столом у окна, как обычно. Рядом с ним незнакомый мужчина — татуировки, толстовка с логотипом Docker, ноутбук с наклейками хакерских конференций.

> **Viktor:**
> *"Максим. Вовремя. Это Дмитрий Орлов. DevOps engineer. Он будет координировать техническую часть."*

Dmitry протягивает руку. Крепкое рукопожатие.

> **Dmitry:**
> *"Слышал ты справился с первым тестом. Неплохо для провинциала."*

Усмешка. Но не злобная.

> **Viktor:**
> *"У нас проблема. 50 серверов. Нужно проверять их доступность каждые 5 минут. Логировать всё. Автоматически."*

Dmitry открывает ноутбук, поворачивает к вам:

```
servers.txt:
shadow-server-01 185.192.45.118
shadow-server-02 185.192.45.119
shadow-server-03 185.192.45.120
...
shadow-server-50 185.192.45.167
```

> **Dmitry:**
> *"Мы не можем проверять это вручную. Нужен скрипт. Bash."*

> **Viktor:**
> *"Дмитрий научит тебя. Это второй тест. У тебя сегодня вечер."*

Он передаёт USB-флешку.

> **Viktor:**
> *"Здесь всё что нужно. Справишься — подпишем контракт завтра."*

---

## 18:30 — Хостел "Красный Октябрь"

Ноутбук. Терминал. USB-флешка вставлена.

Экран мигает:

```
┌─────────────────────────────────────────────────────────────┐
│                                                               │
│   LILITH здесь.                                               │
│                                                               │
│   Первый тест был разминкой. Теперь настоящая работа.        │
│                                                               │
│   Dmitry дал тебе задание. Я дам знания.                      │
│   Bash scripting — это оружие системного администратора.      │
│                                                               │
│   Покажи что ты способен мыслить алгоритмически.              │
│   Один скрипт может заменить 1000 повторений.                 │
│                                                               │
│   Начнём.                                                     │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 Подготовка

**Шаг 1: Перейдите в директорию эпизода**
```bash
cd ~/kernel-shadows/season-1-shell-foundations/episode-02-shell-scripting
```

**Шаг 2: Скопируйте артефакты**
```bash
cp -r artifacts/* ~/server_monitoring/
cd ~/server_monitoring/
```

> 💡 **Погружение:** Представьте, что Dmitry дал вам доступ к тестовому окружению. Всё что нужно — в папке artifacts.

---

## 🎯 Задание 1: Анатомия Bash скрипта

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Прежде чем писать скрипты, нужно понять их структуру.       │
│  Bash скрипт — это не просто список команд.                   │
│  Это программа со своими правилами."                          │
└─────────────────────────────────────────────────────────────┘
```

### 📚 Теория: Структура Bash скрипта

#### Базовый шаблон

```bash
#!/bin/bash
# Описание: Что делает этот скрипт
# Автор: Max Sokolov
# Дата: 03 октября 2025

# Функции (если есть)
function hello() {
    echo "Привет, $1"
}

# Основная логика
main() {
    echo "Начинаю работу..."
    hello "Max"
    echo "Работа завершена"
}

# Запуск
main "$@"
```

#### Shebang `#!/bin/bash`

**Первая строка** всегда должна быть:
```bash
#!/bin/bash
```

Или более универсальный вариант:
```bash
#!/usr/bin/env bash
```

> **LILITH:** *"Shebang — это не просто традиция. Это инструкция операционной системе. Без него скрипт может запуститься в sh вместо bash. И всё сломается."*

#### Комментарии

```bash
# Однострочный комментарий

: '
Многострочный
комментарий
через двоеточие
'
```

---

## 🎯 Задание 2: Переменные в Bash

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Переменные — это память скрипта. Научись их использовать."  │
└─────────────────────────────────────────────────────────────┘
```

### 📚 Теория: Переменные

#### Объявление и использование

```bash
#!/bin/bash

# Объявление (БЕЗ пробелов вокруг =!)
name="Max"
age=28
server_ip="185.192.45.118"

# Использование (с $ перед именем)
echo "Имя: $name"
echo "Возраст: $age"
echo "Сервер: $server_ip"

# Безопасное использование (в кавычках)
echo "Полное имя: ${name} Sokolov"
```

#### ⚠️ Важные правила:

1. **НЕТ пробелов вокруг `=`**
   ```bash
   ✅ name="Max"
   ❌ name = "Max"
   ```

2. **Всегда кавычки при использовании**
   ```bash
   ✅ echo "$name"
   ❌ echo $name        # Сломается на пробелах!
   ```

3. **Фигурные скобки для безопасности**
   ```bash
   ✅ echo "${name}_backup"
   ❌ echo "$name_backup"   # Ищет переменную name_backup!
   ```

#### Специальные переменные

```bash
$0      # Имя скрипта
$1, $2  # Аргументы (первый, второй)
$@      # Все аргументы
$#      # Количество аргументов
$?      # Exit code последней команды
$$      # PID текущего процесса
```

### 🤔 Практика (10 минут)

Создай файл `variables_test.sh`:

```bash
#!/bin/bash

# Получить имя из аргумента
name="$1"

# Проверка что аргумент передан
if [ -z "$name" ]; then
    echo "Ошибка: передай имя как аргумент"
    echo "Использование: $0 ИМЯ"
    exit 1
fi

echo "Привет, $name!"
echo "Ты запустил скрипт: $0"
echo "Всего аргументов: $#"
```

**Запуск:**
```bash
chmod +x variables_test.sh
./variables_test.sh Max
```

> **LILITH:** *"Переменные без кавычек — это как ходить по минному полю. Рано или поздно взорвётся."*

---

## 🎯 Задание 3: Условия (if/else)

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Скрипт должен уметь принимать решения. Условия."            │
└─────────────────────────────────────────────────────────────┘
```

### 📚 Теория: Условные конструкции

#### Базовый синтаксис

```bash
if [ УСЛОВИЕ ]; then
    # Код если истина
fi
```

```bash
if [ УСЛОВИЕ ]; then
    # Истина
else
    # Ложь
fi
```

```bash
if [ УСЛОВИЕ1 ]; then
    # Условие 1
elif [ УСЛОВИЕ2 ]; then
    # Условие 2
else
    # Иначе
fi
```

#### Операторы сравнения

**Для чисел:**
```bash
-eq     # равно (equal)
-ne     # не равно (not equal)
-gt     # больше (greater than)
-lt     # меньше (less than)
-ge     # больше или равно (greater or equal)
-le     # меньше или равно (less or equal)
```

**Пример:**
```bash
age=28

if [ "$age" -ge 18 ]; then
    echo "Взрослый"
else
    echo "Ребёнок"
fi
```

**Для строк:**
```bash
=       # равно
!=      # не равно
-z      # пустая строка (zero)
-n      # непустая строка (non-zero)
```

**Пример:**
```bash
name="Max"

if [ "$name" = "Max" ]; then
    echo "Привет, Max!"
fi

if [ -z "$name" ]; then
    echo "Имя пустое"
fi
```

**Для файлов:**
```bash
-f      # файл существует
-d      # директория существует
-r      # файл читаемый
-w      # файл записываемый
-x      # файл исполняемый
-e      # существует (любой тип)
```

**Пример:**
```bash
if [ -f "servers.txt" ]; then
    echo "Файл найден"
else
    echo "Файл не найден"
    exit 1
fi
```

#### Современный синтаксис: `[[ ]]`

**Рекомендуется использовать** `[[ ]]` вместо `[ ]`:

```bash
# Старый стиль
if [ "$name" = "Max" ]; then

# Новый стиль (лучше)
if [[ "$name" == "Max" ]]; then

# Поддержка regex
if [[ "$email" =~ @gmail\.com$ ]]; then
    echo "Gmail адрес"
fi

# Логические операторы
if [[ "$age" -ge 18 && "$country" == "RU" ]]; then
    echo "Взрослый из России"
fi
```

> **LILITH:** *"`[[ ]]` — это bash. `[ ]` — это POSIX. Используй `[[ ]]` пока не знаешь разницу."*

### 🤔 Практика (15 минут)

Создай `check_server.sh`:

```bash
#!/bin/bash

server_ip="$1"

# Проверка аргумента
if [[ -z "$server_ip" ]]; then
    echo "Ошибка: укажи IP сервера"
    exit 1
fi

echo "Проверка сервера $server_ip..."

# Проверка доступности (ping)
if ping -c 1 -W 2 "$server_ip" &>/dev/null; then
    echo "✅ Сервер $server_ip доступен"
    exit 0
else
    echo "❌ Сервер $server_ip недоступен"
    exit 1
fi
```

**Запуск:**
```bash
chmod +x check_server.sh
./check_server.sh 8.8.8.8       # Google DNS (должен быть доступен)
./check_server.sh 192.168.255.255  # Скорее всего недоступен
```

---

## 🎯 Задание 4: Циклы (for/while)

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "50 серверов. Ты не будешь проверять их вручную.             │
│  Циклы — это автоматизация повторений."                       │
└─────────────────────────────────────────────────────────────┘
```

### 📚 Теория: Циклы

#### For loop — перебор элементов

```bash
# Перебор списка
for item in один два три; do
    echo "Элемент: $item"
done

# Перебор файлов
for file in *.txt; do
    echo "Файл: $file"
done

# Перебор строк из файла
for line in $(cat servers.txt); do
    echo "Строка: $line"
done

# C-style for loop
for ((i=1; i<=10; i++)); do
    echo "Итерация $i"
done
```

#### While loop — пока условие истинно

```bash
counter=1

while [ $counter -le 5 ]; do
    echo "Счётчик: $counter"
    ((counter++))
done
```

#### Чтение файла построчно (правильный способ)

```bash
while IFS= read -r line; do
    echo "Строка: $line"
done < servers.txt
```

> **LILITH:** *"For loop когда знаешь сколько итераций. While loop когда не знаешь. Чтение файла — всегда через while read."*

### 🤔 Практика (20 минут)

Создай `check_multiple_servers.sh`:

```bash
#!/bin/bash

# Проверка что файл существует
if [[ ! -f "servers.txt" ]]; then
    echo "Ошибка: файл servers.txt не найден"
    exit 1
fi

echo "=== Проверка серверов ==="
echo ""

# Счётчики
total=0
online=0
offline=0

# Читаем файл построчно
while IFS= read -r line; do
    # Пропускаем пустые строки и комментарии
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Разбираем строку (имя IP)
    server_name=$(echo "$line" | awk '{print $1}')
    server_ip=$(echo "$line" | awk '{print $2}')

    ((total++))

    # Проверка доступности
    if ping -c 1 -W 2 "$server_ip" &>/dev/null; then
        echo "✅ $server_name ($server_ip) — ONLINE"
        ((online++))
    else
        echo "❌ $server_name ($server_ip) — OFFLINE"
        ((offline++))
    fi

done < servers.txt

echo ""
echo "=== Итого ==="
echo "Всего: $total"
echo "Онлайн: $online"
echo "Оффлайн: $offline"
```

**Запуск:**
```bash
chmod +x check_multiple_servers.sh
./check_multiple_servers.sh
```

---

## 🎯 Задание 5: Функции

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Код повторяется? Выноси в функции. DRY principle."          │
└─────────────────────────────────────────────────────────────┘
```

### 📚 Теория: Функции в Bash

#### Объявление функций

```bash
# Способ 1
function hello() {
    echo "Привет!"
}

# Способ 2 (предпочтительный)
hello() {
    echo "Привет!"
}

# Вызов
hello
```

#### Аргументы функций

```bash
greet() {
    local name="$1"
    local age="$2"

    echo "Привет, $name! Тебе $age лет."
}

# Вызов
greet "Max" 28
```

#### Возврат значений

```bash
# Exit code (0-255)
check_file() {
    if [[ -f "$1" ]]; then
        return 0  # Успех
    else
        return 1  # Ошибка
    fi
}

# Использование
if check_file "servers.txt"; then
    echo "Файл существует"
fi

# Вывод через echo (захват в переменную)
get_date() {
    echo "$(date +%Y-%m-%d)"
}

current_date=$(get_date)
echo "Дата: $current_date"
```

#### Локальные переменные

```bash
my_function() {
    local name="Max"      # Локальная (только в функции)
    global_var="Viktor"   # Глобальная
}
```

> **LILITH:** *"Функции без local — это как переменные без кавычек. Работает, пока не сломается."*

### 🤔 Практика (15 минут)

Рефакторим `check_multiple_servers.sh` с функциями:

```bash
#!/bin/bash

# Функция: проверка доступности сервера
check_server_status() {
    local server_ip="$1"

    if ping -c 1 -W 2 "$server_ip" &>/dev/null; then
        return 0  # Online
    else
        return 1  # Offline
    fi
}

# Функция: логирование с timestamp
log_message() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message"
}

# Главная функция
main() {
    log_message "Начало проверки серверов"

    if [[ ! -f "servers.txt" ]]; then
        log_message "ОШИБКА: servers.txt не найден"
        exit 1
    fi

    local total=0
    local online=0
    local offline=0

    while IFS= read -r line; do
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        local server_name=$(echo "$line" | awk '{print $1}')
        local server_ip=$(echo "$line" | awk '{print $2}')

        ((total++))

        if check_server_status "$server_ip"; then
            log_message "✅ $server_name ($server_ip) ONLINE"
            ((online++))
        else
            log_message "❌ $server_name ($server_ip) OFFLINE"
            ((offline++))
        fi

    done < servers.txt

    echo ""
    log_message "Итого: $total | Онлайн: $online | Оффлайн: $offline"
}

# Запуск
main "$@"
```

---

## 🎯 Задание 6: Exit Codes

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Скрипт должен сообщать успех или провал. Exit codes."       │
└─────────────────────────────────────────────────────────────┘
```

### 📚 Теория: Exit Codes

#### Что такое Exit Code?

**Exit code** (код возврата) — число от 0 до 255, которое программа возвращает при завершении.

- **0** = успех
- **1-255** = различные ошибки

#### Использование

```bash
#!/bin/bash

# Успех
exit 0

# Ошибка
exit 1
```

#### Проверка exit code

```bash
# Специальная переменная $?
ping -c 1 google.com
echo "Exit code: $?"

# В условиях
if ping -c 1 google.com; then
    echo "Успех (exit 0)"
else
    echo "Ошибка (exit ≠ 0)"
fi
```

#### Обработка ошибок

```bash
#!/bin/bash

# Строгий режим: выход при любой ошибке
set -e

# Выход при использовании неопределённой переменной
set -u

# Ошибка в pipe останавливает выполнение
set -o pipefail

# Или всё вместе:
set -euo pipefail
```

> **LILITH:** *"`set -euo pipefail` в начале каждого production скрипта. Без обсуждений."*

---

## 🎯 Задание 7: Финальный проект — Server Monitor

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Dmitry ждёт от тебя полноценный мониторинг скрипт.          │
│  Всё что ты узнал — применяй сейчас."                         │
│                                                               │
│  Требования:                                                  │
│  1. Проверка всех серверов из servers.txt                     │
│  2. Логирование в файл (с timestamp)                          │
│  3. Отправка алертов при проблемах                            │
│  4. Статистика в конце                                        │
│  5. Exit code: 0 если все ОК, 1 если есть проблемы            │
│                                                               │
│  Время: 60-90 минут. Покажи на что способен."                 │
└─────────────────────────────────────────────────────────────┘
```

### 🤔 Самостоятельное задание

Создай `server_monitor.sh` который:

**Функционал:**
1. Читает список серверов из `servers.txt`
2. Проверяет каждый сервер (ping)
3. Логирует результаты в `monitor.log` с timestamp
4. Выводит цветной статус в терминал
5. Создаёт `alerts.txt` при обнаружении оффлайн серверов
6. Показывает статистику в конце
7. Возвращает exit code 1 если хотя бы один сервер недоступен

<details>
<summary>💡 Подсказка: Цветной вывод</summary>

```bash
# ANSI цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}✅ Онлайн${NC}"
echo -e "${RED}❌ Оффлайн${NC}"
```

</details>

<details>
<summary>💡 Подсказка: Структура</summary>

```bash
#!/bin/bash
set -euo pipefail

# Цвета
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Файлы
SERVERS_FILE="servers.txt"
LOG_FILE="monitor.log"
ALERT_FILE="alerts.txt"

# Функция: проверка сервера
check_server() {
    local ip="$1"
    # YOUR CODE
}

# Функция: логирование
log_to_file() {
    local message="$1"
    # YOUR CODE
}

# Главная функция
main() {
    # YOUR CODE
}

main "$@"
```

</details>

<details>
<summary>✅ Полное решение</summary>

**Файл `server_monitor.sh`:**

```bash
#!/bin/bash

################################################################################
# OPERATION KERNEL SHADOWS - Episode 02
# Server Monitoring Script
# Author: Max Sokolov
# Date: 03 October 2025
################################################################################

set -euo pipefail

# Цвета для вывода
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Файлы
readonly SERVERS_FILE="servers.txt"
readonly LOG_FILE="monitor.log"
readonly ALERT_FILE="alerts.txt"

# Счётчики
total_servers=0
online_servers=0
offline_servers=0

################################################################################
# Функция: проверка доступности сервера
################################################################################
check_server_status() {
    local server_ip="$1"
    local timeout=2
    local count=1

    if ping -c "$count" -W "$timeout" "$server_ip" &>/dev/null; then
        return 0  # Online
    else
        return 1  # Offline
    fi
}

################################################################################
# Функция: логирование в файл с timestamp
################################################################################
log_to_file() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" >> "$LOG_FILE"
}

################################################################################
# Функция: добавление алерта
################################################################################
add_alert() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] ALERT: $message" >> "$ALERT_FILE"
}

################################################################################
# Функция: вывод статуса в терминал с цветом
################################################################################
print_status() {
    local server_name="$1"
    local server_ip="$2"
    local status="$3"

    if [[ "$status" == "online" ]]; then
        echo -e "${GREEN}✅${NC} $server_name ($server_ip) — ${GREEN}ONLINE${NC}"
    else
        echo -e "${RED}❌${NC} $server_name ($server_ip) — ${RED}OFFLINE${NC}"
    fi
}

################################################################################
# Функция: проверка всех серверов
################################################################################
check_all_servers() {
    echo -e "${BLUE}=== Проверка серверов ===${NC}"
    echo ""

    # Проверка существования файла
    if [[ ! -f "$SERVERS_FILE" ]]; then
        echo -e "${RED}ОШИБКА: Файл $SERVERS_FILE не найден${NC}"
        log_to_file "ERROR: $SERVERS_FILE not found"
        exit 1
    fi

    # Очистка файла алертов
    > "$ALERT_FILE"

    # Читаем файл построчно
    while IFS= read -r line; do
        # Пропускаем пустые строки и комментарии
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        # Парсинг строки (имя и IP)
        local server_name=$(echo "$line" | awk '{print $1}')
        local server_ip=$(echo "$line" | awk '{print $2}')

        # Пропускаем если IP пустой
        [[ -z "$server_ip" ]] && continue

        ((total_servers++))

        # Проверка статуса
        if check_server_status "$server_ip"; then
            print_status "$server_name" "$server_ip" "online"
            log_to_file "$server_name ($server_ip) — ONLINE"
            ((online_servers++))
        else
            print_status "$server_name" "$server_ip" "offline"
            log_to_file "$server_name ($server_ip) — OFFLINE"
            add_alert "$server_name ($server_ip) is OFFLINE"
            ((offline_servers++))
        fi

    done < "$SERVERS_FILE"
}

################################################################################
# Функция: вывод статистики
################################################################################
print_statistics() {
    echo ""
    echo -e "${BLUE}=== Статистика ===${NC}"
    echo "Всего серверов: $total_servers"
    echo -e "${GREEN}Онлайн: $online_servers${NC}"

    if [[ $offline_servers -gt 0 ]]; then
        echo -e "${RED}Оффлайн: $offline_servers${NC}"
        echo ""
        echo -e "${YELLOW}⚠️  Обнаружены проблемы! Проверь $ALERT_FILE${NC}"
    else
        echo -e "${GREEN}Оффлайн: 0${NC}"
        echo ""
        echo -e "${GREEN}✅ Все серверы работают нормально${NC}"
    fi

    echo ""
    echo "Логи: $LOG_FILE"
    echo "Алерты: $ALERT_FILE"
}

################################################################################
# Главная функция
################################################################################
main() {
    local start_time=$(date '+%Y-%m-%d %H:%M:%S')

    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║        KERNEL SHADOWS - Server Monitoring Script          ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    log_to_file "=== Monitoring started ==="

    # Проверка всех серверов
    check_all_servers

    # Статистика
    print_statistics

    local end_time=$(date '+%Y-%m-%d %H:%M:%S')
    log_to_file "=== Monitoring completed | Online: $online_servers/$total_servers ==="

    # Exit code
    if [[ $offline_servers -gt 0 ]]; then
        exit 1  # Есть проблемы
    else
        exit 0  # Всё ОК
    fi
}

################################################################################
# Запуск
################################################################################
main "$@"
```

</details>

### 🧪 Тестирование

```bash
chmod +x server_monitor.sh
./server_monitor.sh
```

**Проверь:**
- ✅ Скрипт запускается без ошибок
- ✅ Цветной вывод работает
- ✅ Создаётся `monitor.log`
- ✅ Создаётся `alerts.txt` (если есть проблемы)
- ✅ Правильный exit code (`echo $?`)

---

## 🎬 Финал: Оценка Dmitry

После запуска скрипта, телефон вибрирует. Сообщение от Dmitry:

```
┌─────────────────────────────────────────────────────────────┐
│ Dmitry Orlov                                        21:43    │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│ Получил логи. Проверил код.                                   │
│                                                               │
│ Неплохо. Чисто. Функции на месте. Exit codes правильные.     │
│ Цветной вывод — бонус.                                        │
│                                                               │
│ Один момент: добавь `set -euo pipefail` в начало.            │
│ Production код должен быть строгим.                           │
│                                                               │
│ Завтра встреча с Viktor. 10:00. Адрес вышлю утром.           │
│ Берём тебя в команду.                                         │
│                                                               │
│ Отдыхай. Дальше будет сложнее.                                │
│                                                               │
│ — Dmitry                                                      │
└─────────────────────────────────────────────────────────────┘
```

Экран терминала мигает:

```
┌─────────────────────────────────────────────────────────────┐
│                                                               │
│   LILITH: ASSESSMENT COMPLETE                                 │
│                                                               │
│   Bash скрипты: ✓                                             │
│   Переменные: ✓                                               │
│   Условия: ✓                                                  │
│   Циклы: ✓                                                    │
│   Функции: ✓                                                  │
│   Exit codes: ✓                                               │
│   Автоматизация: ✓                                            │
│                                                               │
│   Оценка: PASSED                                              │
│                                                               │
│   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
│                                                               │
│   "Dmitry прав. Код чистый. Ты мыслишь алгоритмически.        │
│    Это не просто последовательность команд —                  │
│    это программа."                                            │
│                                                               │
│   Автоматизация — это не лень. Это эффективность.            │
│   Один скрипт заменяет 1000 повторений.                       │
│                                                               │
│   Ты справился с Episode 02.                                  │
│   Episode 03 — обработка текста. Логи. Grep, awk, sed.        │
│                                                               │
│   Но это потом. Отдохни. Ты заслужил.                         │
│                                                               │
│   Я буду наблюдать. В тенях. Всегда.                          │
│                                                               │
│                                          — LILITH             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎓 Что ты узнал

### Концепции Bash:
- ✅ Структура bash скрипта (shebang, комментарии, функции)
- ✅ Переменные (`VAR="value"`, `$VAR`, `${VAR}`)
- ✅ Специальные переменные (`$0`, `$1`, `$@`, `$?`)
- ✅ Условия (`if`, `[[ ]]`, операторы сравнения)
- ✅ Циклы (`for`, `while`, `while read`)
- ✅ Функции (`function_name() { }`, `local`, `return`)
- ✅ Exit codes (0 = success, 1-255 = error)
- ✅ Строгий режим (`set -euo pipefail`)

### Практические навыки:
- ✅ Создание production-ready скриптов
- ✅ Автоматизация мониторинга серверов
- ✅ Логирование с timestamp
- ✅ Обработка ошибок
- ✅ Цветной вывод в терминале
- ✅ Чтение конфигурационных файлов

### Best Practices:
- ✅ Всегда кавычки вокруг переменных: `"$var"`
- ✅ Локальные переменные в функциях: `local name="$1"`
- ✅ Строгий режим: `set -euo pipefail`
- ✅ Осмысленные exit codes
- ✅ Комментарии для сложной логики

---

## 📊 Самопроверка

Ответь на вопросы:

1. **Что делает `set -euo pipefail`?**
2. **В чём разница между `[ ]` и `[[ ]]`?**
3. **Как правильно читать файл построчно?**
4. **Что означает `$?`?**
5. **Зачем использовать `local` в функциях?**

<details>
<summary>✅ Ответы</summary>

1. `-e` выход при ошибке, `-u` ошибка при неопределённых переменных, `-o pipefail` ошибка в pipe останавливает скрипт
2. `[[ ]]` — bash синтаксис, поддерживает regex, `&&`, `||`. `[ ]` — POSIX совместимый
3. `while IFS= read -r line; do ... done < file`
4. Exit code последней выполненной команды
5. Для изоляции переменных, чтобы не перезаписать глобальные

</details>

---

## 🔧 Проверка выполнения

Запусти автотест:

```bash
cd ~/kernel-shadows/season-1-shell-foundations/episode-02-shell-scripting
./tests/test.sh
```

Тесты проверят:
- ✓ Создан ли `server_monitor.sh`
- ✓ Исполняемый ли скрипт
- ✓ Содержит ли shebang
- ✓ Создаёт ли логи
- ✓ Правильный ли exit code

---

## 🎯 Следующий эпизод

**Episode 03: Text Processing Masters**

Anna Kovaleva обнаружила атаку в логах. 10,000+ строк. Нужно найти IP атакующих, извлечь TOP-10, создать отчёт.

Инструменты: `grep`, `awk`, `sed`, pipes, redirects.

> **LILITH:**
> *"Логи не врут. Люди — врут. Episode 03 научит тебя читать правду в терабайтах текста."*

---

## 📚 Дополнительные материалы

### Man Pages
```bash
man bash
man test
man [
```

### Ресурсы
- [ShellCheck](https://www.shellcheck.net/) — линтер для bash
- [Bash Guide](https://mywiki.wooledge.org/BashGuide) — продвинутое руководство
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

### Практика
- Создай скрипт для backup важных файлов
- Напиши скрипт для анализа системных ресурсов (CPU, RAM, Disk)
- Автоматизируй что-то из своей работы

---

<div align="center">

**OPERATION KERNEL SHADOWS**
*Episode 02 — Shell Scripting Basics*

*"Автоматизация — это не лень. Это эффективность."* — LILITH

**[← Episode 01](../episode-01-terminal-awakening/README.md) | [Season 1](../README.md) | [Episode 03 →](../episode-03-text-processing/README.md)**

</div>


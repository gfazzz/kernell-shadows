# Episode 03 — Артефакты: Text Processing

```
ЛОКАЦИЯ: 🇷🇺 Новосибирск, НГУ
ПОСТАВЩИК: Anna Kovaleva (Lead Forensics Expert)
ЗАДАЧА: Анализ логов атаки DDoS (04 октября 2025, 03:47 UTC)
```

---

## 📦 Содержимое

Этот директорий содержит **тестовые данные** для Episode 03:

```
artifacts/
├── README.md              ← Ты здесь (инструкции)
├── access.log             ← Логи веб-сервера (4400 строк, атака 03:47-04:00)
├── suspicious_ips.txt     ← База известных угроз от Anna (threat intelligence)
└── report_template.txt    ← Шаблон отчёта (опциональный reference)
```

---

## 📄 Файл 1: `access.log`

### Описание

**Apache Combined Log** формат — стандартные логи веб-сервера.

**Период:** 04 октября 2025, 02:00 — 06:00 (UTC)
**Атака:** 03:47:00 — 04:00:00 (пик: 03:47:25, 4,582 req/sec)
**Размер:** 4,400 строк (~400 KB)

### Формат

```
IP - - [timestamp] "METHOD /path HTTP/1.1" status size "referer" "user-agent"
│   │ │  │          │                       │      │     │         │
│   │ │  │          │                       │      │     │         └─ Программа клиента
│   │ │  │          │                       │      │     └─ Откуда пришёл
│   │ │  │          │                       │      └─ Размер ответа (bytes)
│   │ │  │          │                       └─ HTTP status code
│   │ │  │          └─ Запрос (метод + путь)
│   │ │  └─ Дата/время
│   │ └─ Аутентификация (- = нет)
│   └─ Remote logname (- = нет)
└─ IP адрес клиента
```

**Пример строки:**

```
185.220.101.47 - - [04/Oct/2025:03:47:23 +0000] "GET /admin HTTP/1.1" 404 0 "-" "nmap NSE"
```

**Разбор:**
- **IP:** 185.220.101.47
- **Timestamp:** 04/Oct/2025:03:47:23 +0000
- **Method:** GET
- **Path:** /admin
- **Status:** 404 (Not Found)
- **User-Agent:** nmap NSE (сканер портов! 🚨)

### Поля (для awk)

```
$1 = IP адрес                   185.220.101.47
$2 = -                          -
$3 = -                          -
$4 = [timestamp]                [04/Oct/2025:03:47:23
$5 = timezone]                  +0000]
$6 = "METHOD                    "GET
$7 = /path                      /admin
$8 = HTTP/1.1"                  HTTP/1.1"
$9 = status                     404
$10 = size                      0
$11 = "referer"                 "-"
$12 = "user-agent"              "nmap

# Для User-Agent используй разделитель кавычки:
# awk -F'"' '{print $6}' access.log
```

### Ключевые timestamps для анализа

| Период | Описание | Количество |
|--------|----------|------------|
| `02:00-03:46` | Нормальный трафик | ~1,200 |
| `03:47` | **Пик атаки** ⚠️ | ~1,200 |
| `03:48-04:00` | Продолжение атаки | ~1,000 |
| `04:01-06:00` | Затухание | ~1,000 |

**Для фильтрации атаки используй:**

```bash
grep "03:47" access.log   # Только пик
grep -E "03:4[789]" access.log   # 03:47-03:49
grep -E "0[34]:[0-9]{2}" access.log   # Всё окно 03:00-04:59
```

### HTTP статус коды

| Code | Значение | Типичное количество |
|------|----------|---------------------|
| 200 | OK | ~3,200 |
| 404 | Not Found | ~800 |
| 403 | Forbidden | ~250 |
| 500 | Server Error | ~100 |
| 503 | Service Unavailable | ~50 |

### TOP User-Agents атакующих

```
nmap NSE          — Port scanner (reconnaissance)
sqlmap/1.5.2      — SQL injection tool
curl/7.58.0       — HTTP client (automation)
Nikto/2.1.6       — Web vulnerability scanner
ZmEu              — Known PHP exploit scanner
```

---

## 📄 Файл 2: `suspicious_ips.txt`

### Описание

**Threat Intelligence Database** — база известных вредоносных IP адресов.

Предоставлена Anna Kovaleva из базы FSB Cyber Crime Unit.

**Формат:** Один IP per line, комментарии начинаются с `#`

**Пример:**

```
# Threat Intelligence Database
# Updated: 04 Oct 2025
# Source: FSB Cyber Crime Unit + Open Threat Exchange

185.220.101.47    # Tor exit node, multiple attacks
45.155.205.67     # Known botnet C&C server
91.234.56.78      # SQL injection attempts (last 30 days)

# Comment lines start with #
# Empty lines are ignored
```

### Использование

**Задача:** Проверить сколько запросов пришло от каждого IP из базы.

**Подход через loop:**

```bash
while read -r ip; do
    # Пропустить комментарии и пустые строки
    [[ "$ip" =~ ^#.*$ || -z "$ip" ]] && continue

    # Посчитать запросы от этого IP
    count=$(grep -c "$ip" access.log)

    # Если найдены - вывести
    [[ $count -gt 0 ]] && echo "FOUND: $ip ($count requests)"
done < suspicious_ips.txt
```

**Почему loop, а не ONE-LINER?**

Потому что нужно обработать **список IP** (файл) против **логов**.
`grep -f` могла бы работать, но loop даёт больше контроля (подсчёт, форматирование).

**Это единственное место в скрипте где нужен loop!** Всё остальное = ONE-LINERS.

---

## 📄 Файл 3: `report_template.txt` (опционально)

**Шаблон структуры отчёта** для reference.

Ты можешь использовать его как пример, но не обязательно копировать точно.

**Type B подход:** Твой скрипт должен генерировать отчёт используя ONE-LINERS, не сложный bash.

---

## 🎯 Задача Episode 03

### Построить `log_analyzer.sh`

**Требования:**

1. ✅ Читает `access.log`
2. ✅ Выводит TOP-10 атакующих IP (во время атаки 03:47)
3. ✅ Выводит статистику HTTP status codes
4. ✅ Проверяет IP из `suspicious_ips.txt` (threat database)
5. ✅ Выводит TOP-5 User-Agents
6. ✅ Сохраняет результаты в `final_report.txt`

**Type B approach:**

- 70% Linux tools (grep, awk, sort, uniq)
- 30% bash wrapper (переменные, один loop, форматирование)
- Фокус на **ONE-LINERS**, не на bash программировании

---

## 💻 Ключевые ONE-LINERS

### 1. Общая статистика

```bash
# Всего запросов:
wc -l < access.log

# Уникальных IP:
awk '{print $1}' access.log | sort -u | wc -l

# Запросов во время атаки:
grep -c "03:47" access.log
```

### 2. TOP-10 атакующих IP

```bash
# Классический pattern для TOP-N:
grep "03:47" access.log | awk '{print $1}' | sort | uniq -c | sort -nr | head -10

# Вывод:
#     523 185.220.101.47
#     234 45.155.205.67
#     156 91.234.56.78
#     ...
```

### 3. HTTP статус коды

```bash
# Статистика по всем кодам:
awk '{print $9}' access.log | sort | uniq -c | sort -nr

# Вывод:
#   3200 200
#    800 404
#    250 403
#    ...
```

### 4. Проверка threat database

```bash
# Loop (единственное место где нужен bash):
while read -r ip; do
    [[ "$ip" =~ ^#.*$ || -z "$ip" ]] && continue
    count=$(grep -c "$ip" access.log)
    [[ $count -gt 0 ]] && echo "FOUND: $ip ($count requests)"
done < suspicious_ips.txt
```

### 5. TOP-5 User-Agents

```bash
# Разделитель = кавычка, поле #6:
grep "03:47" access.log | awk -F'"' '{print $6}' | sort | uniq -c | sort -nr | head -5

# Вывод:
#    523 nmap NSE
#    234 sqlmap/1.5.2
#    156 curl/7.58.0
#    ...
```

### 6. TOP-10 запрашиваемых путей

```bash
# Поле #7 = path (URL):
awk '{print $7}' access.log | sort | uniq -c | sort -nr | head -10

# Вывод:
#    523 /admin
#    234 /wp-admin
#    156 /login
#    ...
```

---

## 🚀 Использование

### Вариант 1: Построй свой скрипт

```bash
cd ~/kernel-shadows/season-1-shell-foundations/episode-03-text-processing

# Открой starter.sh и заполни TODO секции:
nano starter.sh

# Запусти:
chmod +x starter.sh
./starter.sh artifacts/access.log

# Проверь результат:
cat final_report.txt
cat top_attackers.txt

# Запусти тесты:
./tests/test.sh
```

### Вариант 2: Интерактивный анализ

Используй ONE-LINERS напрямую в терминале:

```bash
cd artifacts/

# TOP-10 атакующих:
grep "03:47" access.log | awk '{print $1}' | sort | uniq -c | sort -nr | head -10

# HTTP статусы:
awk '{print $9}' access.log | sort | uniq -c | sort -nr

# Проверка threats:
while read ip; do [[ "$ip" =~ ^#.*$ ]] || grep -c "$ip" access.log; done < suspicious_ips.txt

# User-Agents:
grep "03:47" access.log | awk -F'"' '{print $6}' | sort | uniq -c | sort -nr | head -5
```

---

## 🧪 Тестирование

```bash
# Запуск автоматических тестов:
cd ~/kernel-shadows/season-1-shell-foundations/episode-03-text-processing
./tests/test.sh

# Тесты проверяют:
#   ✅ Существование final_report.txt
#   ✅ Существование top_attackers.txt
#   ✅ Формат TOP-10 (count + IP)
#   ✅ Наличие ключевых IP (185.220.101.47, etc.)
#   ✅ Наличие секций в отчёте
```

---

## 📚 Справка: Основные команды

| Команда | Назначение | Пример |
|---------|------------|--------|
| `grep "pattern" file` | Найти строки | `grep "03:47" access.log` |
| `grep -c "pattern" file` | Посчитать совпадения | `grep -c "404" access.log` |
| `awk '{print $N}' file` | Извлечь N-е поле | `awk '{print $1}' access.log` |
| `awk -F'X' '{print $N}'` | Кастомный разделитель | `awk -F'"' '{print $6}'` |
| `sort` | Сортировать | `sort file.txt` |
| `sort -n` | Числовая сортировка | `sort -n numbers.txt` |
| `sort -r` | Обратный порядок | `sort -r file.txt` |
| `sort -u` | Уникальные строки | `sort -u file.txt` |
| `uniq` | Убрать дубликаты | `sort file \| uniq` |
| `uniq -c` | Подсчитать повторения | `sort file \| uniq -c` |
| `head -N` | Первые N строк | `head -10 file.txt` |
| `tail -N` | Последние N строк | `tail -10 file.txt` |
| `wc -l` | Посчитать строки | `wc -l file.txt` |

---

## 💡 Подсказки

### Проблема: Не можешь извлечь User-Agent

**Решение:** Используй `-F'"'` (разделитель = кавычка)

```bash
# Лог-строка:
# IP - - [timestamp] "GET /path HTTP/1.1" 404 0 "-" "nmap NSE"
#                     ^1^                        ^2^ ^3^

# При разделителе = кавычка:
# $1 = всё до первой кавычки
# $2 = GET /path HTTP/1.1  (между 1-й и 2-й кавычками)
# $4 = -  (между 3-й и 4-й)
# $6 = nmap NSE  (между 5-й и 6-й) ← User-Agent!

awk -F'"' '{print $6}' access.log
```

### Проблема: `sort | uniq -c` показывает дубликаты

**Причина:** `uniq` требует предварительную сортировку!

```bash
# ❌ Неправильно:
awk '{print $1}' file | uniq -c

# ✅ Правильно:
awk '{print $1}' file | sort | uniq -c
```

### Проблема: `sort` неправильно сортирует числа

**Причина:** Лексикографическая сортировка (9 > 100)

```bash
# ❌ Неправильно:
uniq -c file | sort -r

# ✅ Правильно:
uniq -c file | sort -nr   # -n = numeric
```

### Проблема: Тесты падают

**Проверь:**

1. Файл `final_report.txt` создан?
2. Файл `top_attackers.txt` создан?
3. Формат TOP-10: `количество IP` (через пробел)
4. Запускал из корректной директории?

```bash
# Правильная директория:
cd ~/kernel-shadows/season-1-shell-foundations/episode-03-text-processing
./starter.sh artifacts/access.log
```

---

## 🎓 Философия Type B

> **LILITH:**
> *"Эти логи — 4,400 строк. Вручную = 12 часов.*
>
> *С инструментами = 2 секунды.*
>
> *grep, awk, pipes — не просто команды. Это оружие Linux администратора.*
>
> *Bash — клей между инструментами, не замена инструментов.*
>
> *Построй ONE-LINERS. Автоматизируй минимальным wrapper. Это Type B."*

---

**Удачи!** — Anna Kovaleva & Dmitry Orlov

---

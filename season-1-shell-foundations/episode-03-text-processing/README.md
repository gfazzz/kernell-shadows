# Episode 03: Text Processing Masters

```
ОПЕРАЦИЯ: KERNEL SHADOWS
СЕЗОН: 1 — Shell & Foundations
ЭПИЗОД: 03 — Text Processing Masters
СЛОЖНОСТЬ: ⭐⭐☆☆☆
ВРЕМЯ: 3-4 часа
```

---

## 📅 04 октября 2025, 03:52 — ALERT

Телефон взрывается звонком. Viktor.

> **Viktor:**
> *"Максим. Нас атаковали. Прямо сейчас."*

Голос жёсткий, без паники. Но слышно напряжение.

> **Viktor:**
> *"Анна ждёт тебя. Офис на Тверской. Кофейня закрыта — иди через чёрный ход."*

---

## 04:15 — Офис на Тверской, подвальный уровень

Сервак гудит. Мониторы везде. Anna Kovaleva уже здесь — чёрная толстовка, кофе, усталые глаза.

> **Anna:**
> *"Ты Max? Хорошо. Слушай быстро."*

Она поворачивает монитор к вам:

```
[04/Oct/2025:03:47:23 +0000] - 2,847 requests/sec
[04/Oct/2025:03:47:24 +0000] - 3,124 requests/sec
[04/Oct/2025:03:47:25 +0000] - 4,582 requests/sec ⚠️
SERVER OVERLOAD WARNING
```

> **Anna:**
> *"DDoS началась в 03:47. Сервер Viktor под ударом. Логи огромные — 4,400+ строк. Мне нужны IP атакующих. Срочно."*

Она передаёт USB-флешку:

> **Anna:**
> *"Здесь access.log за последние 24 часа. База известных угроз — suspicious_ips.txt. Найди кто атаковал."*

Пауза.

> **Anna:**
> *"Krylov уже знает где мы. Это его почерк. Найди доказательства."*

---

## 04:20 — Ваш ноутбук

Терминал открыт. USB вставлена.

Экран мигает:

```
┌─────────────────────────────────────────────────────────────┐
│                                                               │
│   LILITH здесь.                                               │
│                                                               │
│   Атака идёт. Логи не врут.                                   │
│   Найди patterns. Найди IP. Найди правду.                     │
│                                                               │
│   grep, awk, sed — твоё оружие.                               │
│   Pipes и redirects — твоя тактика.                           │
│                                                               │
│   4,400 строк логов. 10 минут на анализ.                      │
│   Anna ждёт отчёт.                                            │
│                                                               │
│   Начинаем.                                                   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 Подготовка

**Шаг 1: Перейдите в директорию эпизода**
```bash
cd ~/kernel-shadows/season-1-shell-foundations/episode-03-text-processing
```

**Шаг 2: Скопируйте артефакты**
```bash
mkdir -p ~/log_analysis
cp artifacts/access.log ~/log_analysis/
cp artifacts/suspicious_ips.txt ~/log_analysis/
cp artifacts/report_template.txt ~/log_analysis/
cd ~/log_analysis/
```

> 💡 **Погружение:** Представьте, что Anna дала вам доступ к серверу Viktor. Логи уже скопированы. Атака идёт прямо сейчас.

---

## 🎯 Задание 1: Первый взгляд на логи

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ 4,400+ строк. Не читай вручную. Ты не человек-парсер.        │
│ Начни с базовых команд просмотра.                            │
└─────────────────────────────────────────────────────────────┘
```

### Команды для разведки:

**Посмотреть первые 10 строк:**
```bash
head access.log
```

**Посмотреть последние 10 строк:**
```bash
tail access.log
```

**Сколько всего строк?**
```bash
wc -l access.log
```

**Постраничный просмотр (выход: q):**
```bash
less access.log
```

### Формат Apache Combined Log:
```
IP - - [timestamp] "METHOD /path HTTP/1.1" status size "referer" "user-agent"
```

Пример:
```
192.168.1.100 - - [04/Oct/2025:10:23:45 +0000] "GET /index.html HTTP/1.1" 200 1024 "-" "Mozilla/5.0"
```

### 📝 Ваша задача:
1. Откройте `access.log`
2. Изучите формат записей
3. Найдите timestamp атаки: **03:47**

<details>
<summary>💡 LILITH: "Не понял формат? Открой."</summary>

**Разбор строки лога:**
```
185.220.101.47 - - [04/Oct/2025:03:47:23 +0000] "GET /admin HTTP/1.1" 404 0 "-" "nmap NSE"
│              │ │  │                            │                    │   │  │    │
│              │ │  │                            │                    │   │  │    └─ User-Agent (программа)
│              │ │  │                            │                    │   │  └─ Referer (откуда пришёл)
│              │ │  │                            │                    │   └─ Размер ответа (bytes)
│              │ │  │                            │                    └─ HTTP status code
│              │ │  │                            └─ Метод и путь запроса
│              │ │  └─ Timestamp (дата/время)
│              │ └─ Аутентификация (- = нет)
│              └─ Remote logname (- = нет)
└─ IP адрес клиента
```

**HTTP Status Codes:**
- `200` — OK (успешно)
- `401` — Unauthorized (требуется аутентификация)
- `403` — Forbidden (доступ запрещён)
- `404` — Not Found (страница не найдена)
- `500` — Internal Server Error
- `503` — Service Unavailable (сервер перегружен)

</details>

---

## 🎯 Задание 2: grep — Поиск patterns

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ Атака была в 03:47. grep покажет только строки с этим         │
│ timestamp. Остальное — шум.                                   │
└─────────────────────────────────────────────────────────────┘
```

### Основы grep:

**Синтаксис:**
```bash
grep "pattern" file.txt
```

**Найти строки содержащие "03:47":**
```bash
grep "03:47" access.log
```

**Посчитать сколько раз встречается:**
```bash
grep "03:47" access.log | wc -l
```

**Case-insensitive поиск:**
```bash
grep -i "ERROR" access.log
```

**Инвертировать поиск (строки БЕЗ pattern):**
```bash
grep -v "200" access.log
```

### 📝 Ваша задача:
1. Найдите все запросы в **03:47** (timestamp атаки)
2. Посчитайте сколько их
3. Сохраните результат в файл `attack_window.txt`:
   ```bash
   grep "03:47" access.log > attack_window.txt
   ```

<details>
<summary>💡 LILITH: "Не только 03:47. Атака могла длиться дольше."</summary>

**Найти несколько timestamps:**
```bash
grep -E "03:47|03:48|03:49" access.log
```

`-E` = extended regex (regular expressions)

**Regex pattern для диапазона часов (03:00 - 04:59):**
```bash
grep -E "03:[0-9]{2}|04:[0-9]{2}" access.log
```

**Найти все 4xx и 5xx ошибки:**
```bash
grep -E "HTTP/1\.[01]\" [45][0-9]{2}" access.log
```

</details>

---

## 🎯 Задание 3: Pipes — Соединяем команды

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ Pipe (|) — твой лучший друг. Вывод одной команды →           │
│ → вход следующей. Конвейер обработки данных.                 │
└─────────────────────────────────────────────────────────────┘
```

### Основы pipes:

**Концепция:**
```
команда1 | команда2 | команда3
```

Output команды1 → Input команды2 → Output команды2 → Input команды3

**Пример — TOP-10 самых частых строк:**
```bash
cat access.log | sort | uniq -c | sort -nr | head -10
│               │      │          │          └─ Первые 10
│               │      │          └─ Сортировка по числу (reverse)
│               │      └─ Подсчёт уникальных (-c = count)
│               └─ Сортировка (для uniq)
└─ Читаем файл
```

### Полезные команды для pipes:

**`sort`** — сортировка строк
```bash
sort file.txt
sort -r file.txt          # reverse (по убыванию)
sort -n file.txt          # numeric sort
```

**`uniq`** — уникальные строки (требует sort перед!)
```bash
sort file.txt | uniq       # только уникальные
sort file.txt | uniq -c    # с подсчётом повторений
sort file.txt | uniq -d    # только дубликаты
```

**`wc`** — подсчёт (word count)
```bash
wc -l file.txt            # количество строк
wc -w file.txt            # количество слов
wc -c file.txt            # количество байт
```

**`head / tail`** — первые/последние N строк
```bash
head -20 file.txt         # первые 20 строк
tail -20 file.txt         # последние 20 строк
```

### 📝 Ваша задача:
Найдите TOP-10 самых частых User-Agent во время атаки (03:47-04:00):

1. Отфильтруйте логи атаки
2. Извлеките User-Agent (последнее поле в строке)
3. Отсортируйте и посчитайте
4. Выведите TOP-10

<details>
<summary>💡 LILITH: "User-Agent между последними кавычками."</summary>

**Подсказка:**

User-Agent — это последнее поле в кавычках:
```
"... ... " "User-Agent здесь"
```

Можно использовать `awk` (следующее задание) или `grep` с regex.

**Упрощённый подход (если User-Agent содержит "nmap"):**
```bash
grep "03:47" access.log | grep "nmap" | wc -l
```

**TOP атакующих по User-Agent:**
```bash
grep -E "03:4[7-9]|04:0" access.log | \
  awk -F'"' '{print $6}' | \
  sort | uniq -c | sort -nr | head -10
```

</details>

---

## 🎯 Задание 4: awk — Обработка колонок

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ awk — язык программирования для обработки текста.             │
│ Разбивает строки на поля. Ты берёшь нужное. Просто.          │
└─────────────────────────────────────────────────────────────┘
```

### Основы awk:

**Синтаксис:**
```bash
awk '{print $1}' file.txt      # Вывести первое поле (колонку)
```

**Поля (fields) разделяются пробелами по умолчанию:**
```
192.168.1.100 - - [04/Oct/2025:10:23:45 +0000] "GET /index.html HTTP/1.1" 200
│             │ │  │                            │
$1            $2$3 $4                           $6
```

**Примеры:**

**Вывести только IP адреса:**
```bash
awk '{print $1}' access.log
```

**Вывести IP и HTTP status:**
```bash
awk '{print $1, $9}' access.log
```

**Вывести IP и timestamp:**
```bash
awk '{print $1, $4}' access.log
```

**Изменить разделитель (-F):**

Для работы с кавычками:
```bash
awk -F'"' '{print $2}' access.log    # HTTP request (между первыми кавычками)
awk -F'"' '{print $6}' access.log    # User-Agent (между третьими кавычками)
```

**Условная фильтрация:**
```bash
awk '$9 == 404 {print $1}' access.log          # Только 404 ошибки
awk '$9 >= 400 {print $1, $9}' access.log      # Все ошибки 4xx и 5xx
```

**Подсчёт:**
```bash
awk '{count[$1]++} END {for (ip in count) print count[ip], ip}' access.log
# Подсчитывает количество запросов с каждого IP
```

### 📝 Ваша задача:
Извлеките все IP адреса из логов атаки и найдите TOP-10 атакующих.

**План:**
1. Отфильтровать логи атаки (grep "03:4")
2. Извлечь только IP (awk '{print $1}')
3. Отсортировать и подсчитать (sort | uniq -c | sort -nr)
4. Взять TOP-10 (head -10)
5. Сохранить в `top_attackers.txt`

<details>
<summary>💡 LILITH: "Четыре команды через pipe. Элегантно."</summary>

**Полная команда:**
```bash
grep -E "03:4[7-9]|04:0" access.log | \
  awk '{print $1}' | \
  sort | \
  uniq -c | \
  sort -nr | \
  head -10 > top_attackers.txt
```

**Что делает:**
1. `grep` — фильтрует логи атаки (03:47-04:09)
2. `awk` — извлекает IP адреса (первое поле)
3. `sort` — сортирует для uniq
4. `uniq -c` — подсчитывает повторения
5. `sort -nr` — сортирует по количеству (больше → меньше)
6. `head -10` — берёт TOP-10
7. `>` — сохраняет в файл

**Результат будет:**
```
    523 185.220.101.47
    156 91.234.56.78
    134 45.155.205.67
    ...
```

Первая колонка — количество запросов, вторая — IP адрес.

</details>

---

## 🎯 Задание 5: sed — Замена текста

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ sed — stream editor. Находит и заменяет текст на лету.       │
│ Не для этой задачи критично, но знать нужно.                 │
└─────────────────────────────────────────────────────────────┘
```

### Основы sed:

**Синтаксис замены:**
```bash
sed 's/old/new/' file.txt              # Первое вхождение в строке
sed 's/old/new/g' file.txt             # Все вхождения (global)
sed 's/old/new/gi' file.txt            # Case-insensitive + global
```

**Примеры:**

**Заменить "ERROR" на "WARNING":**
```bash
sed 's/ERROR/WARNING/' log.txt
```

**Удалить IP адреса (заменить на "[REDACTED]"):**
```bash
sed 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/[REDACTED]/' access.log
```

**Удалить пустые строки:**
```bash
sed '/^$/d' file.txt
```

**Удалить строки содержащие "bot":**
```bash
sed '/bot/d' access.log
```

**Изменить файл напрямую (-i):**
```bash
sed -i 's/old/new/g' file.txt    # ⚠️ Осторожно! Изменяет файл!
```

### 📝 Ваша задача:
Создайте анонимизированную версию `top_attackers.txt` → `top_attackers_redacted.txt`, где IP заменены на `[ATTACKER-XX]`:

**Ожидаемый результат:**
```
    523 [ATTACKER-01]
    156 [ATTACKER-02]
    134 [ATTACKER-03]
    ...
```

<details>
<summary>💡 LILITH: "sed + regex. Либо проще — вручную для 10 строк."</summary>

**Вариант 1: Вручную (проще для малого объёма)**
```bash
cat top_attackers.txt | sed 's/185\.220\.101\.47/[ATTACKER-01 (Tor)]/' > top_attackers_redacted.txt
```

Точки экранируются `\.` в regex.

**Вариант 2: Автоматически (продвинутый)**

sed не умеет нумеровать замены напрямую, но можно через awk:
```bash
awk '{gsub(/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/, "[ATTACKER-" NR "]"); print}' top_attackers.txt > top_attackers_redacted.txt
```

**Для задания — достаточно просто понимать sed. Можете пропустить анонимизацию или сделать частично.**

</details>

---

## 🎯 Задание 6: Сверка с базой угроз

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ Anna дала базу известных угроз — suspicious_ips.txt.          │
│ Сколько из них в наших логах? grep + while read loop.        │
└─────────────────────────────────────────────────────────────┘
```

### Задача:
Проверить, сколько IP из `suspicious_ips.txt` присутствуют в `access.log` во время атаки.

### Подход 1: Один grep на строку
```bash
grep "185.220.101.47" access.log | wc -l
grep "91.234.56.78" access.log | wc -l
# ... вручную для каждого
```

❌ Неэффективно.

### Подход 2: while read loop
```bash
while read ip; do
  count=$(grep "$ip" access.log | wc -l)
  if [[ $count -gt 0 ]]; then
    echo "$ip: $count запросов"
  fi
done < suspicious_ips.txt
```

✅ Автоматизация!

### 📝 Ваша задача:
Создайте скрипт `check_threats.sh`:

```bash
#!/bin/bash

echo "Проверка базы угроз..."
echo "────────────────────────────────────"

found=0
while read -r ip; do
  # Пропустить комментарии и пустые строки
  [[ "$ip" =~ ^#.*$ || -z "$ip" ]] && continue

  count=$(grep -c "$ip" access.log 2>/dev/null)

  if [[ $count -gt 0 ]]; then
    echo "⚠️  $ip: $count запросов"
    ((found++))
  fi
done < suspicious_ips.txt

echo "────────────────────────────────────"
echo "Найдено угроз: $found"
```

**Запустите:**
```bash
chmod +x check_threats.sh
./check_threats.sh
```

<details>
<summary>💡 LILITH: "Разбор скрипта — открой если не понял."</summary>

**Построчный разбор:**

```bash
while read -r ip; do
```
- Читает файл построчно
- `-r` = не обрабатывать backslash экранирование
- Каждая строка → переменная `$ip`

```bash
[[ "$ip" =~ ^#.*$ || -z "$ip" ]] && continue
```
- Regex: `^#.*$` = строка начинается с #
- `-z "$ip"` = строка пустая
- `||` = логическое ИЛИ
- `&& continue` = если true, пропустить итерацию

```bash
count=$(grep -c "$ip" access.log 2>/dev/null)
```
- `$()` = command substitution (результат команды → переменная)
- `grep -c` = count matches (только число, не строки)
- `2>/dev/null` = подавить ошибки (redirect stderr в /dev/null)

```bash
if [[ $count -gt 0 ]]; then
```
- `-gt` = greater than (больше чем)
- Условие: если найдено > 0

```bash
((found++))
```
- Арифметика: увеличить счётчик на 1

```bash
done < suspicious_ips.txt
```
- `<` = redirect stdin из файла
- Файл подаётся в while loop

</details>

---

## 🎯 Задание 7: Финальный проект — Автоматический анализатор логов

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ Всё что ты выучил → один скрипт. log_analyzer.sh             │
│ Anna нужен полный отчёт. Автоматизируй всё.                  │
└─────────────────────────────────────────────────────────────┘
```

### Требования:

**Скрипт `log_analyzer.sh` должен:**

1. **Принимать аргументы:**
   - `./log_analyzer.sh <access.log> <suspicious_ips.txt> <output_report.txt>`

2. **Анализировать логи и выводить:**
   - Общее количество запросов
   - Количество уникальных IP
   - Запросы во время атаки (03:00-05:00)
   - TOP-10 атакующих IP
   - Совпадения с базой угроз
   - HTTP статусы (200, 404, 403, 500, 503)
   - TOP-5 User-Agents атакующих

3. **Создавать отчёт** на основе `report_template.txt`

4. **Цветной вывод** в терминал (опционально)

### Шаблон стартера:

Скопируйте `starter.sh` и доработайте:

```bash
cp ~/kernel-shadows/season-1-shell-foundations/episode-03-text-processing/starter.sh log_analyzer.sh
chmod +x log_analyzer.sh
nano log_analyzer.sh
```

### 📝 Структура скрипта:

```bash
#!/bin/bash

# Проверка аргументов
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <access.log> <suspicious_ips.txt> <output_report>"
  exit 1
fi

LOG_FILE="$1"
THREATS_FILE="$2"
REPORT_FILE="$3"

# Проверка существования файлов
[[ ! -f "$LOG_FILE" ]] && { echo "Error: $LOG_FILE not found"; exit 1; }
[[ ! -f "$THREATS_FILE" ]] && { echo "Error: $THREATS_FILE not found"; exit 1; }

echo "Analyzing $LOG_FILE..."

# Анализ 1: Общая статистика
total_requests=$(wc -l < "$LOG_FILE")
unique_ips=$(awk '{print $1}' "$LOG_FILE" | sort -u | wc -l)

echo "Total requests: $total_requests"
echo "Unique IPs: $unique_ips"

# Анализ 2: Запросы во время атаки (03:00-05:00)
attack_window=$(grep -E "03:[0-9]{2}|04:[0-9]{2}" "$LOG_FILE" | wc -l)
echo "Requests during attack window (03:00-05:00): $attack_window"

# Анализ 3: TOP-10 атакующих IP
echo "Extracting TOP-10 attackers..."
grep -E "03:[0-9]{2}|04:[0-9]{2}" "$LOG_FILE" | \
  awk '{print $1}' | \
  sort | \
  uniq -c | \
  sort -nr | \
  head -10 > top_attackers.txt

cat top_attackers.txt

# Анализ 4: Проверка базы угроз
echo "Checking threat intelligence..."
# TODO: Ваш код здесь

# Анализ 5: HTTP статусы
echo "HTTP status codes:"
# TODO: Ваш код здесь

# Анализ 6: User-Agents атакующих
echo "TOP-5 Attack User-Agents:"
# TODO: Ваш код здесь

# Создание отчёта
echo "Generating report: $REPORT_FILE"
# TODO: Ваш код здесь

echo "Analysis complete!"
```

<details>
<summary>🔓 Решение (референс)</summary>

См. `solution/log_analyzer.sh` для полного рабочего решения.

**Не смотрите до тех пор, пока не попробовали сами!**

</details>

---

## 🎯 Задание 8: Запуск и тестирование

### Запустите ваш анализатор:

```bash
./log_analyzer.sh access.log suspicious_ips.txt final_report.txt
```

### Ожидаемый вывод:

```
Analyzing access.log...
Total requests: 4400
Unique IPs: 15
Requests during attack window (03:00-05:00): 1400

TOP-10 Attackers:
    523 185.220.101.47
    156 91.234.56.78
    ...

Checking threat intelligence...
⚠️  185.220.101.47: 523 запросов (Tor exit node)
⚠️  91.234.56.78: 156 запросов
Found 10 known threats in logs

HTTP Status Codes:
  200: 3200
  404: 800
  403: 250
  500: 100
  503: 50

TOP-5 Attack User-Agents:
    523 nmap NSE
    400 curl/7.58.0 (scanner)
    300 sqlmap/1.5.2
    156 Nikto/2.1.6
    100 masscan/1.0

Generating report: final_report.txt
✓ Analysis complete!
```

### Проверьте отчёт:

```bash
cat final_report.txt
```

Должен содержать все найденные данные в структурированном виде.

---

## 🎯 Задание 9: Автотесты

Запустите официальные тесты:

```bash
cd ~/kernel-shadows/season-1-shell-foundations/episode-03-text-processing/tests
./test.sh
```

### Тесты проверяют:
1. ✅ Структура скрипта (shebang, функции)
2. ✅ Обработка аргументов
3. ✅ Извлечение TOP-10 IP
4. ✅ Проверка базы угроз
5. ✅ Создание отчёта
6. ✅ Exit codes

---

## 05:30 — Офис на Тверской

Вы отправляете `final_report.txt` Anna.

30 секунд. Она читает.

> **Anna:**
> *"Хорошая работа. 185.220.101.47 — Tor exit node. Krylov любит прятаться там."*

Она поворачивается к другому монитору:

> **Anna:**
> *"Я заблокировала все IP из твоего отчёта. Firewall обновлён."*

Пауза.

> **Anna:**
> *"Viktor сказал ты справился с двумя тестами. Третий будет сложнее."*

Она передаёт визитку:

```
Anna Kovaleva
Lead Forensics Expert
KERNEL SHADOWS Operation
Signal: +7-XXX-XXX-XXXX (encrypted)
```

> **Anna:**
> *"Добро пожаловать в команду, Max."*

Терминал мигает:

```
┌─────────────────────────────────────────────────────────────┐
│                                                               │
│   LILITH:                                                     │
│   Неплохо. Ты умеешь находить patterns в хаосе.               │
│                                                               │
│   grep, awk, sed, pipes — твоё оружие теперь.                 │
│   Логи больше не пугают тебя.                                 │
│                                                               │
│   Но это только начало.                                       │
│   Krylov знает что мы его видим. Он адаптируется.             │
│                                                               │
│   Следующий эпизод: Package Management.                       │
│   Нам нужны инструменты. Настоящие инструменты.               │
│                                                               │
│   До встречи в тенях.                                         │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 📚 Теория: Справочник команд

<details>
<summary>📖 grep — Поиск текста</summary>

**Основы:**
```bash
grep "pattern" file           # Поиск pattern
grep -i "pattern" file        # Case-insensitive
grep -v "pattern" file        # Инверт (строки БЕЗ pattern)
grep -c "pattern" file        # Только подсчёт
grep -n "pattern" file        # С номерами строк
grep -r "pattern" dir/        # Рекурсивно в директории
```

**Regex:**
```bash
grep -E "pattern1|pattern2" file    # ИЛИ
grep -E "^start" file               # Начало строки
grep -E "end$" file                 # Конец строки
grep -E "[0-9]+" file               # Цифры
```

**Полезные опции:**
- `-A 5` — показать 5 строк ПОСЛЕ совпадения
- `-B 5` — показать 5 строк ДО совпадения
- `-C 5` — показать 5 строк ДО и ПОСЛЕ
- `-o` — вывести только совпадающую часть (не всю строку)
- `-l` — вывести только имена файлов

</details>

<details>
<summary>📖 awk — Обработка колонок</summary>

**Основы:**
```bash
awk '{print $1}' file              # Первая колонка
awk '{print $1, $3}' file          # 1-я и 3-я колонки
awk '{print $NF}' file             # Последняя колонка
awk '{print NR, $0}' file          # Номер строки + вся строка
```

**Разделители:**
```bash
awk -F: '{print $1}' /etc/passwd   # Разделитель :
awk -F'"' '{print $2}' file        # Разделитель "
```

**Условия:**
```bash
awk '$3 > 100' file                # 3-я колонка > 100
awk '$1 == "ERROR"' file           # 1-я колонка == "ERROR"
awk '/pattern/' file               # Строки содержащие pattern
```

**Подсчёт:**
```bash
awk '{sum += $1} END {print sum}' file           # Сумма 1-й колонки
awk '{count[$1]++} END {for (i in count) print i, count[i]}' file   # Подсчёт уникальных
```

**Встроенные переменные:**
- `$0` — вся строка
- `$1, $2, ...` — поля (колонки)
- `NF` — количество полей
- `NR` — номер текущей строки
- `FS` — field separator (разделитель)

</details>

<details>
<summary>📖 sed — Замена текста</summary>

**Основы:**
```bash
sed 's/old/new/' file              # Первое вхождение
sed 's/old/new/g' file             # Все вхождения (global)
sed 's/old/new/gi' file            # Case-insensitive + global
sed -i 's/old/new/g' file          # Изменить файл напрямую
```

**Удаление:**
```bash
sed '/pattern/d' file              # Удалить строки с pattern
sed '/^$/d' file                   # Удалить пустые строки
sed '1d' file                      # Удалить первую строку
sed '1,5d' file                    # Удалить строки 1-5
```

**Вставка:**
```bash
sed '1i\text' file                 # Вставить "text" перед строкой 1
sed '1a\text' file                 # Вставить "text" после строки 1
```

**Regex:**
```bash
sed 's/[0-9]\+/NUMBER/g' file      # Заменить цифры на "NUMBER"
sed 's/^/PREFIX/' file             # Добавить PREFIX в начало каждой строки
sed 's/$/SUFFIX/' file             # Добавить SUFFIX в конец каждой строки
```

</details>

<details>
<summary>📖 Pipes & Redirects</summary>

**Pipes (|):**
```bash
command1 | command2                # Output cmd1 → Input cmd2
cat file | grep "pattern"          # Эквивалентно: grep "pattern" file
ps aux | grep "process"            # Найти процесс
```

**Redirects:**
```bash
command > file.txt                 # Вывод → file (перезапись)
command >> file.txt                # Вывод → file (добавление)
command < file.txt                 # Ввод из file
command 2> errors.txt              # stderr → errors.txt
command &> all_output.txt          # stdout + stderr → all_output.txt
command 2>/dev/null                # Подавить ошибки
```

**Комбинации:**
```bash
command1 | command2 > output.txt   # Pipe + redirect
cat file | grep "pattern" | sort | uniq > result.txt
```

</details>

<details>
<summary>📖 Полезные утилиты</summary>

**`sort` — Сортировка:**
```bash
sort file.txt                      # Алфавитная сортировка
sort -r file.txt                   # Reverse (по убыванию)
sort -n file.txt                   # Numeric sort
sort -k2 file.txt                  # Сортировка по 2-й колонке
sort -u file.txt                   # Уникальные + сортировка
```

**`uniq` — Уникальные:**
```bash
sort file | uniq                   # Уникальные строки
sort file | uniq -c                # С подсчётом
sort file | uniq -d                # Только дубликаты
sort file | uniq -u                # Только уникальные (не повторяющиеся)
```

**`cut` — Вырезать колонки:**
```bash
cut -d: -f1 /etc/passwd            # 1-я колонка (разделитель :)
cut -c1-10 file.txt                # Символы 1-10
cut -f1,3 file.txt                 # 1-я и 3-я колонки (разделитель TAB)
```

**`tr` — Замена символов:**
```bash
echo "HELLO" | tr 'A-Z' 'a-z'      # Uppercase → lowercase
tr -d '[:digit:]' < file.txt       # Удалить цифры
```

**`wc` — Подсчёт:**
```bash
wc -l file.txt                     # Количество строк
wc -w file.txt                     # Количество слов
wc -c file.txt                     # Количество байт
```

**`head / tail`:**
```bash
head -20 file.txt                  # Первые 20 строк
tail -20 file.txt                  # Последние 20 строк
tail -f log.txt                    # Follow (мониторинг в реальном времени)
```

</details>

---

## 🎓 Что вы изучили

### Команды:
- ✅ `grep` — поиск текста, regex, фильтрация
- ✅ `awk` — обработка колонок, подсчёт, условия
- ✅ `sed` — замена текста, stream editing
- ✅ `sort`, `uniq`, `wc` — сортировка, уникальность, подсчёт
- ✅ `head`, `tail` — просмотр начала/конца файлов
- ✅ `cut`, `tr` — обработка текста
- ✅ Pipes (`|`) и redirects (`>`, `>>`, `<`)

### Навыки:
- ✅ Анализ больших логов (4000+ строк)
- ✅ Извлечение patterns из данных
- ✅ Построение конвейеров обработки (pipes)
- ✅ Автоматизация анализа через скрипты
- ✅ Создание структурированных отчётов

### Сюжет:
- ✅ Первая DDoS атака от Krylov (03:47, 4 октября)
- ✅ Знакомство с Anna Kovaleva (forensics expert)
- ✅ Найден Tor exit node: 185.220.101.47
- ✅ Вы официально в команде KERNEL SHADOWS

---

## 🔗 Дополнительные ресурсы

**Online инструменты:**
- **regex101.com** — тестирование регулярных выражений
- **explainshell.com** — объяснение shell команд
- **awk.js.org** — интерактивный awk tutorial

**Man pages:**
```bash
man grep
man awk
man sed
```

**Книги:**
- "Sed & Awk" by Dale Dougherty (классика)
- "The AWK Programming Language" by Aho, Kernighan, Weinberger

---

## ➡️ Следующий эпизод

**Episode 04: Package Management**
- APT, DPKG, Snap
- Установка инструментов для операции
- Dependencies hell
- Автоматизация через скрипты

> *"Инструменты решают. Без nmap и tcpdump ты слепой."* — LILITH

---

## 📊 Ваш прогресс

```
Season 1: Shell & Foundations
├── ✅ Episode 01: Terminal Awakening
├── ✅ Episode 02: Shell Scripting Basics
├── ✅ Episode 03: Text Processing Masters ← Вы здесь
└── 🔒 Episode 04: Package Management
```

**Процент завершения Season 1:** 75%

---

<div align="center">

**KERNEL SHADOWS**
*Episode 03 — Text Processing Masters*

*"Логи не врут. Люди — врут."* — LILITH

[⬆ К началу](#episode-03-text-processing-masters)

</div>


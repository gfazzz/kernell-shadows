# Episode 02: Artifacts — Тестовые данные от Дмитрия

```
┌─────────────────────────────────────────────────────────────┐
│ DMITRY ORLOV:                                                 │
│                                                               │
│ "Max, вот тестовое окружение. Всё что нужно для работы.     │
│  50 серверов. Проверяй доступность. Логируй результаты.      │
│  Deadline — 18:00. Покажи на что способен."                   │
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 Файлы

### `servers.txt`
Список серверов операции KERNEL SHADOWS для мониторинга.

**Формат:**
```
SERVER_NAME IP_ADDRESS
```

**Пример:**
```
shadow-server-01 185.192.45.118
shadow-server-02 185.192.45.119
test-server-01 8.8.8.8
```

**Структура файла:**
- Строки начинающиеся с `#` — комментарии (пропускаются)
- Пустые строки — игнорируются
- Первое слово — имя сервера
- Второе слово — IP адрес

---

## 🔧 Как использовать

### Вариант 1: Работа в директории episode

```bash
cd ~/kernel-shadows/season-1-shell-foundations/episode-02-shell-scripting

# Создай свой скрипт
nano server_monitor.sh

# Скрипт будет использовать artifacts/servers.txt
```

### Вариант 2: Работа в artifacts/

```bash
cd ~/kernel-shadows/season-1-shell-foundations/episode-02-shell-scripting/artifacts

# Создай скрипт здесь
nano server_monitor.sh

# Используй servers.txt напрямую
```

### Вариант 3: Отдельная рабочая директория

```bash
mkdir ~/server_monitoring
cd ~/server_monitoring

# Копируй тестовые данные
cp ~/kernel-shadows/season-1-shell-foundations/episode-02-shell-scripting/artifacts/servers.txt .

# Работай здесь
nano server_monitor.sh
```

---

## 🧪 Тестовые серверы

Файл `servers.txt` содержит несколько типов серверов для тестирования:

### ✅ Онлайн (должны быть доступны):
- **8.8.8.8** — Google DNS (публичный, всегда online)
- **1.1.1.1** — Cloudflare DNS (публичный, всегда online)
- **127.0.0.1** — localhost (локальный, online если система работает)

### ❌ Оффлайн (для тестирования алертов):
- **192.168.255.255** — несуществующий IP (всегда offline)

### 🌐 Операция KERNEL SHADOWS:
- **shadow-server-XX** — серверы операции (симуляция, скорее всего offline)
- **backup-server-XX** — backup инфраструктура
- **db-server-XX** — базы данных
- **monitor-01** — мониторинг сервер

---

## 📝 Ожидаемые результаты

После запуска твоего `server_monitor.sh` должны создаться:

### 1. `monitor.log` — полный лог всех проверок

**Формат:**
```
[2025-10-04 16:30:15] === Monitoring started ===
[2025-10-04 16:30:15] test-server-01 (8.8.8.8) — ONLINE
[2025-10-04 16:30:16] test-server-02 (1.1.1.1) — ONLINE
[2025-10-04 16:30:18] shadow-server-01 (185.192.45.118) — OFFLINE
[2025-10-04 16:30:25] === Monitoring completed | Online: 3/10 ===
```

**Что должно быть:**
- ✅ Timestamp в формате `[YYYY-MM-DD HH:MM:SS]`
- ✅ Имя сервера и IP
- ✅ Статус (ONLINE / OFFLINE)
- ✅ Начало и конец проверки

### 2. `alerts.txt` — только проблемные серверы

**Формат:**
```
[2025-10-04 16:30:18] ALERT: shadow-server-01 (185.192.45.118) is OFFLINE
[2025-10-04 16:30:22] ALERT: shadow-server-02 (185.192.45.119) is OFFLINE
```

**Что должно быть:**
- ✅ Timestamp
- ✅ Префикс `ALERT:`
- ✅ Только offline серверы
- ✅ Файл пустой если все серверы online

---

## 🎯 Требования к скрипту

**Dmitry ожидает:**

1. **Функциональность:**
   - ✅ Проверка всех серверов из `servers.txt`
   - ✅ Пропуск комментариев и пустых строк
   - ✅ Логирование с timestamps
   - ✅ Алерты для offline серверов
   - ✅ Статистика (total / online / offline)

2. **Exit codes:**
   - ✅ `0` — все серверы online
   - ✅ `1` — есть проблемы (хотя бы один offline)

3. **Code quality:**
   - ✅ Shebang: `#!/bin/bash`
   - ✅ Строгий режим: `set -euo pipefail`
   - ✅ Функции с `local` переменными
   - ✅ Комментарии для сложной логики
   - ✅ Цветной вывод (бонус)

---

## 🔍 Отладка

### Проблема: "файл не найден"

```bash
# Проверь путь к servers.txt
ls -la servers.txt
ls -la artifacts/servers.txt

# В скрипте используй правильный путь:
SERVERS_FILE="artifacts/servers.txt"  # если запускаешь из episode-02/
# или
SERVERS_FILE="servers.txt"            # если запускаешь из artifacts/
```

### Проблема: "ping не работает"

```bash
# Проверь доступность ping
which ping

# Тестируй вручную
ping -c 1 -W 2 8.8.8.8

# Проверь firewall (если на сервере)
sudo iptables -L | grep ICMP
```

### Проблема: "permission denied"

```bash
# Сделай скрипт исполняемым
chmod +x server_monitor.sh

# Проверь permissions
ls -l server_monitor.sh
# Должно быть: -rwxr-xr-x
```

---

## 📊 Пример запуска

```bash
$ cd ~/kernel-shadows/season-1-shell-foundations/episode-02-shell-scripting
$ chmod +x server_monitor.sh
$ ./server_monitor.sh

╔════════════════════════════════════════════════╗
║    KERNEL SHADOWS - Server Monitoring         ║
╚════════════════════════════════════════════════╝

✅ test-server-01 (8.8.8.8) — ONLINE
✅ test-server-02 (1.1.1.1) — ONLINE
✅ test-server-03 (127.0.0.1) — ONLINE
❌ test-server-04 (192.168.255.255) — OFFLINE
❌ shadow-server-01 (185.192.45.118) — OFFLINE

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Статистика:
   Всего серверов: 5
   Онлайн: 3
   Оффлайн: 2

⚠️  Обнаружены проблемы! Проверь alerts.txt

📝 Логи: monitor.log
⚠️  Алерты: alerts.txt
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$ echo $?
1

$ cat monitor.log
[2025-10-04 16:45:12] === Monitoring started ===
[2025-10-04 16:45:12] test-server-01 (8.8.8.8) — ONLINE
[2025-10-04 16:45:13] test-server-02 (1.1.1.1) — ONLINE
...

$ cat alerts.txt
[2025-10-04 16:45:15] ALERT: test-server-04 (192.168.255.255) is OFFLINE
[2025-10-04 16:45:18] ALERT: shadow-server-01 (185.192.45.118) is OFFLINE
```

---

## 💡 Подсказки от LILITH

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│                                                               │
│ "Всё что нужно для работы — здесь. Дмитрий подготовил       │
│  тестовое окружение.                                          │
│                                                               │
│  Подсказки:                                                   │
│  • Читай файл через while IFS= read -r line                  │
│  • Пропускай комментарии: [[ "$line" =~ ^# ]]                │
│  • Используй awk для парсинга: awk '{print $1}'              │
│  • Логируй с timestamp: [$(date '+%Y-%m-%d %H:%M:%S')]        │
│  • Кавычки вокруг переменных: "$variable"                    │
│                                                               │
│  Справишься. Покажи что ты способен мыслить алгоритмически." │
└─────────────────────────────────────────────────────────────┘
```

---

<div align="center">

**OPERATION KERNEL SHADOWS**
*Episode 02 — Server Monitoring & Bash Automation*

*"Дмитрий ждёт результатов. Deadline — 18:00. Покажи на что способен."*

**[← README.md](../README.md) | [Tests →](../tests/test.sh) | [Solution (не смотри!) →](../solution/)**

</div>

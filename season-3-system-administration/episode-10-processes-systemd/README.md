# EPISODE 10: PROCESSES & SYSTEMD
## Season 3: System Administration | Санкт-Петербург, Россия

> *"Init scripts — это прошлое. SystemD — это будущее. И настоящее."* — Борис Кузнецов

---

## 📍 Контекст миссии

**Локация:** 🇷🇺 Санкт-Петербург, Россия
**Место:** Продолжение работы в СПб после Episode 09
**День операции:** 19-20 из 60
**Время прохождения:** 4-5 часов
**Сложность:** ⭐⭐⭐☆☆

**Персонажи:**
- **Макс Соколов** — вы, изучаете системное администрирование
- **Борис Кузнецов** — SystemD архитектор, ex-Red Hat contributor
- **Анна Ковалева** — forensics expert
- **Виктор Петров** — координатор операции
- **LILITH** — AI-помощник (я!)

---

## 🎬 Сюжет

### День 19. Санкт-Петербург. После успешной настройки permissions.

После того как Макс настроил правильные permissions (Episode 09), Анна обнаруживает новую проблему.

**Анна** (видеозвонок, 08:37 Moscow time):
*"Макс, мы нашли ещё один backdoor. На сервере запущен подозрительный процесс. PID 6623. Имя `sshd_backup`. Выглядит как настоящий sshd, но это не он."*

**Макс:** *"Как он там оказался?"*

**Анна:**
*"Крылов маскирует процессы под системные. Классический приём. Тебе нужно научиться управлять процессами и сервисами. Иначе мы не заметим следующую атаку."*

**Виктор:**
*"Макс, в Питере есть человек. Борис Кузнецов. Бывший разработчик Red Hat, работал над systemd. Он научит тебя управлять процессами правильно."*

---

### 10:00. Встреча с Boris Kuznetsov.

Макс встречается с Борисом в коворкинге на Невском проспекте. Борис — 35 лет, борода, толстовка "systemd or die", MacBook с Fedora Linux.

**Борис** (энергично):
*"Макс! Виктор рассказал о проблеме. Backdoor процессы — это классика. Но если ты понимаешь systemd, ты контролируешь ВСЁ. Init scripts — это прошлое. SystemD — это будущее. И настоящее."*

**Макс:** *"Я слышал много споров про systemd..."*

**Борис:**
*"Споры — это эмоции. Systemd — это факт. Все major дистрибутивы перешли на него. Ubuntu, Fedora, Debian, RHEL. Знаешь почему? Потому что он РАБОТАЕТ. Да, он сложный. Да, он монолитный. Но он даёт контроль."*

**Анна** (видеозвонок):
*"Борис прав. Я анализирую логи через journalctl каждый день. Без systemd я бы не увидела половину атак."*

**Борис:**
*"Давай по порядку. Сначала процессы — что это, как они работают. Потом systemd — как управлять сервисами. Потом journalctl — как читать логи. К концу дня ты будешь контролировать все процессы на сервере."*

---

## 🎯 Твоя миссия

Научиться **управлять процессами и сервисами** на Linux сервере.

**Цель:**
- Понять как работают процессы в Linux
- Найти и убить backdoor процесс от Крылова
- Создать systemd service для мониторинга
- Настроить systemd timer (замена cron)
- Научиться анализировать логи через journalctl

**Итог:** Production-ready мониторинг с автоматическим запуском и логированием.

---

## 📁 Структура файлов

```
episode-10-processes-systemd/
├── README.md                  # Теория + задания (этот файл)
├── artifacts/                 # Тестовые данные (если нужны)
│   └── README.md
│
├── starter/                   # 🎯 НАЧНИ ЗДЕСЬ!
│   ├── systemd/               # SystemD units с TODO комментариями
│   │   ├── shadow-backup.service      # Backup task (Type=oneshot)
│   │   ├── shadow-backup.timer        # Scheduler для backup
│   │   └── shadow-monitor.service     # Monitoring daemon (Type=simple)
│   └── README.md              # Workflow: как работать с starter файлами
│
├── solution/                  # Референсное решение (не подглядывай!)
│   ├── systemd/               # Готовые systemd units
│   │   ├── shadow-backup.service
│   │   ├── shadow-backup.timer
│   │   ├── shadow-monitor.service
│   │   └── README.md          # Документация solution
│   └── process_manager.sh     # Вспомогательный скрипт
│
└── tests/                     # Автотесты
    └── test.sh                # Проверка твоего решения
```

### 🚀 Как начать?

1. **Читай теорию** в этом README (Cycles 3-6)
2. **Открой `starter/README.md`** — там полный workflow
3. **Заполни TODO** в systemd units (`starter/systemd/`)
4. **Установи units** в `/etc/systemd/system/`
5. **Тестируй** через `systemctl` и `journalctl`
6. **Запусти автотесты** `./tests/test.sh`

**LILITH:** *"Type B episode. Ты конфигуруешь systemd напрямую, не пишешь bash wrapper. starter/ содержит .service и .timer файлы с TODO комментариями. Заполни их, установи, протестируй. Так учатся профессионалы."*

---

## 📝 Задания

### Задание 1: Инспекция процессов — найти backdoor
**Цель:** Найти подозрительный процесс `sshd_backup` (PID может быть другой)

**Что нужно сделать:**
1. Посмотреть все запущенные процессы
2. Найти процессы с именем содержащим "sshd"
3. Проверить настоящий ли это sshd или маскировка
4. Определить PID подозрительного процесса

<details>
<summary>💡 Подсказка 1 (после 5 минут размышлений)</summary>

Основные команды для просмотра процессов:
- `ps aux` — все процессы
- `ps aux | grep sshd` — только sshd процессы
- `pgrep -a sshd` — найти процессы по имени
- `top` — интерактивный просмотр
- `htop` — улучшенная версия top (если установлен)

Проверь:
- Есть ли несколько процессов с именем sshd?
- Какие пути к исполняемым файлам?
- Кто владелец процесса?

</details>

<details>
<summary>💡 Подсказка 2 (после 10 минут)</summary>

Команды для детального анализа:

```bash
# Все процессы sshd
ps aux | grep sshd

# Найти процессы по имени
pgrep -a sshd

# Проверить путь к исполняемому файлу
ls -l /proc/PID/exe

# Проверить откуда запущен процесс
cat /proc/PID/cmdline | tr '\0' ' '

# Системный sshd обычно запущен от root
# и находится в /usr/sbin/sshd
```

Подозрительные признаки:
- Процесс в неожиданном месте (не /usr/sbin/)
- Запущен от обычного пользователя
- Странные аргументы командной строки

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

echo "=== Hunting for backdoor process ==="

# 1. Все sshd процессы
echo "All sshd processes:"
ps aux | grep '[s]shd'

# 2. Найти по имени
echo -e "\nProcess IDs:"
pgrep -a ssh

# 3. Детальная проверка
echo -e "\nDetailed check:"
for pid in $(pgrep ssh); do
    echo "PID: $pid"
    echo "  Command: $(cat /proc/$pid/cmdline | tr '\0' ' ')"
    echo "  Executable: $(ls -l /proc/$pid/exe 2>/dev/null | awk '{print $NF}')"
    echo "  Owner: $(ps -p $pid -o user=)"
    echo
done

# 4. Подозрительные процессы
echo "⚠️  Suspicious processes (not in /usr/sbin/):"
ps aux | grep '[s]shd' | grep -v '/usr/sbin/sshd'
```

**Анна:** *"Нашёл? Если процесс в /tmp/ или /home/ — это точно backdoor."*

</details>

**Boris:** *"Процессы — это программы в памяти. У каждого есть PID, owner, parent. Научись их читать."*

---

### Задание 2: Убить backdoor процесс
**Цель:** Корректно остановить подозрительный процесс

**Требования:**
- Сначала попробовать SIGTERM (graceful shutdown)
- Если не помогает — SIGKILL (force kill)
- Проверить что процесс действительно остановлен

<details>
<summary>💡 Подсказка 1</summary>

Signals в Linux:
- **SIGTERM** (15) — вежливая просьба завершиться
- **SIGKILL** (9) — принудительное убийство (нельзя игнорировать)
- **SIGHUP** (1) — reload конфигурации

Команды:
```bash
kill PID            # отправить SIGTERM
kill -15 PID        # то же самое
kill -9 PID         # SIGKILL (force)
killall processname # убить все процессы с именем
pkill processname   # то же через pkill
```

</details>

<details>
<summary>💡 Подсказка 2</summary>

Правильная последовательность:

```bash
# 1. Найти PID
suspicious_pid=$(pgrep -f sshd_backup)

# 2. Попробовать graceful shutdown
kill -15 "$suspicious_pid"

# 3. Подождать 5 секунд
sleep 5

# 4. Проверить жив ли еще
if ps -p "$suspicious_pid" > /dev/null 2>&1; then
    echo "Still alive, force killing..."
    kill -9 "$suspicious_pid"
fi

# 5. Проверить что убит
ps -p "$suspicious_pid" || echo "Process killed successfully"
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

kill_backdoor_process() {
    local process_name="sshd_backup"

    echo "=== Killing backdoor process: $process_name ==="

    # Find PID
    local pid=$(pgrep -f "$process_name")

    if [[ -z "$pid" ]]; then
        echo "Process $process_name not found"
        return 1
    fi

    echo "Found PID: $pid"
    ps -p "$pid" -o pid,user,cmd

    # Try graceful shutdown first (SIGTERM)
    echo -e "\nSending SIGTERM (graceful shutdown)..."
    kill -15 "$pid"

    # Wait 5 seconds
    sleep 5

    # Check if still running
    if ps -p "$pid" > /dev/null 2>&1; then
        echo "⚠️  Process still running. Sending SIGKILL (force)..."
        kill -9 "$pid"
        sleep 1
    fi

    # Final check
    if ps -p "$pid" > /dev/null 2>&1; then
        echo "❌ Failed to kill process"
        return 1
    else
        echo "✓ Process $process_name (PID $pid) killed successfully"
        return 0
    fi
}

kill_backdoor_process
```

</details>

**Anna:** *"Убил? Хорошо. Но это временное решение. Krylov запустит его снова если найдёт вектор. Нужен постоянный мониторинг."*

---

### Задание 3: Создать systemd service для мониторинга
**Цель:** Создать сервис который будет постоянно мониторить систему

**Требования:**
- Сервис: `shadow-monitor.service`
- Скрипт: `/usr/local/bin/shadow-monitor.sh`
- Логи в journalctl
- Автозапуск при загрузке системы

<details>
<summary>💡 Подсказка 1</summary>

SystemD service unit file структура:

```ini
[Unit]
Description=Описание сервиса
After=network.target  # запускать после сети

[Service]
Type=simple          # тип сервиса
ExecStart=/путь/к/скрипту  # что запускать
Restart=always       # перезапускать при падении
User=root           # от какого пользователя

[Install]
WantedBy=multi-user.target  # когда активировать
```

Файл создается в `/etc/systemd/system/servicename.service`

</details>

<details>
<summary>💡 Подсказка 2</summary>

Полный пример:

1. Создать скрипт `/usr/local/bin/shadow-monitor.sh`:
```bash
#!/bin/bash
while true; do
    # Проверка подозрительных процессов
    suspicious=$(ps aux | grep '[s]shd_backup')
    if [[ -n "$suspicious" ]]; then
        echo "⚠️  ALERT: Suspicious process detected!"
        echo "$suspicious"
    fi
    sleep 60  # проверка каждую минуту
done
```

2. Сделать исполняемым:
```bash
chmod +x /usr/local/bin/shadow-monitor.sh
```

3. Создать service unit:
```bash
sudo tee /etc/systemd/system/shadow-monitor.service
```

4. Управление:
```bash
sudo systemctl daemon-reload      # перечитать конфигурацию
sudo systemctl start shadow-monitor
sudo systemctl enable shadow-monitor  # автозапуск
sudo systemctl status shadow-monitor
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

create_systemd_service() {
    echo "=== Creating SystemD service ==="

    # 1. Create monitoring script
    local script_path="/usr/local/bin/shadow-monitor.sh"

    sudo tee "$script_path" > /dev/null << 'SCRIPT_EOF'
#!/bin/bash
# Shadow Monitor - Episode 10
# Monitors system for suspicious processes

LOG_TAG="shadow-monitor"

log_message() {
    logger -t "$LOG_TAG" "$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

check_suspicious_processes() {
    # Check for backdoor processes
    local suspicious=$(ps aux | grep -E 'sshd_backup|suspicious_name' | grep -v grep)

    if [[ -n "$suspicious" ]]; then
        log_message "⚠️  ALERT: Suspicious process detected!"
        log_message "$suspicious"

        # Could auto-kill here, but better to alert first
        # kill -9 $(pgrep -f sshd_backup)
    fi
}

log_message "Shadow Monitor started"

while true; do
    check_suspicious_processes
    sleep 60  # Check every minute
done
SCRIPT_EOF

    sudo chmod +x "$script_path"
    echo "✓ Created monitoring script: $script_path"

    # 2. Create systemd service unit
    local service_file="/etc/systemd/system/shadow-monitor.service"

    sudo tee "$service_file" > /dev/null << 'SERVICE_EOF'
[Unit]
Description=Shadow Monitor - Process Security Monitor
Documentation=https://github.com/gfazzz/kernel-shadows
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/shadow-monitor.sh
Restart=always
RestartSec=10
User=root
StandardOutput=journal
StandardError=journal

# Security hardening
NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
SERVICE_EOF

    echo "✓ Created service unit: $service_file"

    # 3. Reload systemd
    sudo systemctl daemon-reload
    echo "✓ Systemd daemon reloaded"

    # 4. Enable and start
    sudo systemctl enable shadow-monitor.service
    sudo systemctl start shadow-monitor.service

    echo "✓ Service enabled and started"

    # 5. Check status
    echo -e "\n=== Service Status ==="
    sudo systemctl status shadow-monitor.service --no-pager
}

create_systemd_service
```

</details>

**Boris:** *"Вот это правильный подход! Systemd будет автоматически перезапускать сервис если он упадёт. Restart=always — это магия."*

---

### Задание 4: Systemd timer — замена cron
**Цель:** Создать systemd timer для периодического backup

**Требования:**
- Timer: `shadow-backup.timer`
- Service: `shadow-backup.service`
- Запуск каждый час
- Backup в `/var/backups/shadow/`

<details>
<summary>💡 Подсказка 1</summary>

SystemD timer состоит из двух файлов:

1. **`.service`** — ЧТО запускать
2. **`.timer`** — КОГДА запускать

Timer unit структура:
```ini
[Unit]
Description=Описание таймера

[Timer]
OnCalendar=hourly      # когда запускать
Persistent=true        # запустить если пропущен

[Install]
WantedBy=timers.target
```

OnCalendar примеры:
- `hourly` — каждый час
- `daily` — каждый день
- `*:0/15` — каждые 15 минут
- `Mon,Fri 10:00` — понедельник и пятница в 10:00

</details>

<details>
<summary>💡 Подсказка 2</summary>

Создание timer + service:

```bash
# Service (что делаем)
sudo tee /etc/systemd/system/shadow-backup.service << 'EOF'
[Unit]
Description=Shadow Backup Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/shadow-backup.sh
EOF

# Timer (когда делаем)
sudo tee /etc/systemd/system/shadow-backup.timer << 'EOF'
[Unit]
Description=Shadow Backup Timer

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Активация
sudo systemctl daemon-reload
sudo systemctl enable shadow-backup.timer
sudo systemctl start shadow-backup.timer

# Проверка
systemctl list-timers shadow-backup.timer
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

create_systemd_timer() {
    echo "=== Creating SystemD timer for backups ==="

    # 1. Create backup script
    local script_path="/usr/local/bin/shadow-backup.sh"

    sudo tee "$script_path" > /dev/null << 'SCRIPT_EOF'
#!/bin/bash
# Shadow Backup - Episode 10

BACKUP_DIR="/var/backups/shadow"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_TAG="shadow-backup"

# Create backup directory
sudo mkdir -p "$BACKUP_DIR"

# Log function
log_message() {
    logger -t "$LOG_TAG" "$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log_message "Starting backup: $TIMESTAMP"

# Backup important configs
sudo tar czf "$BACKUP_DIR/config_$TIMESTAMP.tar.gz" \
    /etc/systemd/system/*.service \
    /etc/passwd \
    /etc/group \
    /etc/sudoers.d/ \
    2>/dev/null

# Keep only last 24 backups (24 hours)
cd "$BACKUP_DIR" && ls -t config_*.tar.gz | tail -n +25 | xargs -r rm

log_message "Backup completed: $BACKUP_DIR/config_$TIMESTAMP.tar.gz"
SCRIPT_EOF

    sudo chmod +x "$script_path"
    echo "✓ Created backup script: $script_path"

    # 2. Create service unit (what to do)
    sudo tee /etc/systemd/system/shadow-backup.service > /dev/null << 'SERVICE_EOF'
[Unit]
Description=Shadow Backup Service
Documentation=https://github.com/gfazzz/kernel-shadows

[Service]
Type=oneshot
ExecStart=/usr/local/bin/shadow-backup.sh
StandardOutput=journal
StandardError=journal
SERVICE_EOF

    echo "✓ Created service unit: shadow-backup.service"

    # 3. Create timer unit (when to do)
    sudo tee /etc/systemd/system/shadow-backup.timer > /dev/null << 'TIMER_EOF'
[Unit]
Description=Shadow Backup Timer (runs hourly)
Documentation=https://github.com/gfazzz/kernel-shadows

[Timer]
OnCalendar=hourly
Persistent=true
AccuracySec=1min

[Install]
WantedBy=timers.target
TIMER_EOF

    echo "✓ Created timer unit: shadow-backup.timer"

    # 4. Reload and enable
    sudo systemctl daemon-reload
    sudo systemctl enable shadow-backup.timer
    sudo systemctl start shadow-backup.timer

    echo "✓ Timer enabled and started"

    # 5. Check status
    echo -e "\n=== Timer Status ==="
    systemctl list-timers shadow-backup.timer --no-pager

    # 6. Test run
    echo -e "\n=== Test Run ==="
    sudo systemctl start shadow-backup.service
    echo "✓ Manual backup triggered"
}

create_systemd_timer
```

</details>

**Boris:** *"Systemd timers > cron. Почему? Потому что интеграция с journalctl, Persistent=true (не пропустит запуск), и лучший контроль."*

---

### Задание 5: Journalctl — чтение логов
**Цель:** Научиться анализировать логи через journalctl

**Что нужно сделать:**
1. Посмотреть логи shadow-monitor service
2. Найти последние 50 строк
3. Следить за логами в реальном времени (tail -f equivalent)
4. Отфильтровать только error сообщения

<details>
<summary>💡 Подсказка 1</summary>

Основные команды journalctl:

```bash
# Все логи
journalctl

# Логи конкретного сервиса
journalctl -u servicename

# Последние N строк
journalctl -u servicename -n 50

# Следить в реальном времени (как tail -f)
journalctl -u servicename -f

# Только errors
journalctl -u servicename -p err

# За определенный период
journalctl -u servicename --since "1 hour ago"
journalctl -u servicename --since "2025-10-09 10:00"
```

Priority levels:
- emerg (0), alert (1), crit (2), err (3), warning (4), notice (5), info (6), debug (7)

</details>

<details>
<summary>💡 Подсказка 2</summary>

Продвинутые фильтры:

```bash
# Логи за сегодня
journalctl -u shadow-monitor --since today

# Комбинация фильтров
journalctl -u shadow-monitor -p err --since "1 hour ago"

# Вывод в JSON (для парсинга)
journalctl -u shadow-monitor -o json

# Обратный порядок (сначала новые)
journalctl -u shadow-monitor -r

# Дисковое использование журналов
journalctl --disk-usage

# Очистка старых логов
sudo journalctl --vacuum-time=7d  # оставить 7 дней
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

analyze_logs() {
    echo "=== Analyzing SystemD Journals ==="

    # 1. Last 50 lines of shadow-monitor
    echo "Last 50 lines of shadow-monitor:"
    journalctl -u shadow-monitor.service -n 50 --no-pager

    echo -e "\n" && read -p "Press Enter to continue..."

    # 2. Errors only
    echo -e "\n=== Errors in last 24 hours ==="
    journalctl -u shadow-monitor.service -p err --since "24 hours ago" --no-pager

    # 3. All services with "shadow" in name
    echo -e "\n=== All shadow-* services ==="
    journalctl -u 'shadow-*' -n 20 --no-pager

    # 4. Statistics
    echo -e "\n=== Journal Statistics ==="
    echo "Disk usage: $(journalctl --disk-usage | awk '{print $NF}')"
    echo "Time range: $(journalctl --list-boots --no-pager | head -1)"

    # 5. Recent activity
    echo -e "\n=== Recent Activity (last hour) ==="
    journalctl --since "1 hour ago" -p warning --no-pager | tail -20

    # Interactive: follow logs
    echo -e "\n=== Follow logs in real-time? ==="
    read -p "Start tail -f mode? (y/n): " answer
    if [[ "$answer" == "y" ]]; then
        echo "Following shadow-monitor logs (Ctrl+C to stop)..."
        journalctl -u shadow-monitor.service -f
    fi
}

analyze_logs
```

**Полезные команды для практики:**

```bash
# Anna's forensics workflow
journalctl -u sshd --since today -p warning  # SSH warnings today
journalctl _UID=0 --since "1 hour ago"      # All root activity
journalctl -k                                # Kernel messages
journalctl --list-boots                      # All boot sessions
```

</details>

**Anna:** *"Journalctl — мой лучший друг. Когда ищешь следы атаки, начни с логов. Timestamp не врёт."*

---

### Задание 6: Мониторинг системных ресурсов
**Цель:** Проверить нагрузку на систему

**Инструменты:**
- `top` — классический мониторинг
- `htop` — улучшенная версия (если есть)
- `ps` — список процессов
- `systemctl status` — статус сервисов

<details>
<summary>💡 Подсказка 1</summary>

Основные метрики:

**Load Average:**
- 1min, 5min, 15min средняя нагрузка
- < 1.0 per core — нормально
- \> 2.0 per core — высокая нагрузка

**Memory:**
- Used / Available
- Swap usage (должен быть минимальным)

**CPU:**
- %us — user processes
- %sy — system (kernel)
- %wa — waiting for I/O

Команды:
```bash
top                  # интерактивный
top -b -n 1          # batch mode (один снимок)
htop                 # если установлен
uptime               # load average
free -h              # память
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

system_health_check() {
    echo "=== System Health Check ==="

    # 1. Load Average
    echo "Load Average (1min, 5min, 15min):"
    uptime | awk -F'load average:' '{print $2}'

    # 2. Memory
    echo -e "\n=== Memory Usage ==="
    free -h

    # 3. CPU cores
    echo -e "\n=== CPU Info ==="
    echo "CPU cores: $(nproc)"
    echo "Load per core: $(uptime | awk '{print $NF}' | awk -v cores=$(nproc) '{print $1/cores}')"

    # 4. Top processes by CPU
    echo -e "\n=== Top 5 CPU consumers ==="
    ps aux --sort=-%cpu | head -6

    # 5. Top processes by Memory
    echo -e "\n=== Top 5 Memory consumers ==="
    ps aux --sort=-%mem | head -6

    # 6. All systemd services status
    echo -e "\n=== Shadow Services Status ==="
    systemctl status 'shadow-*' --no-pager | grep -E 'Active:|Loaded:'

    # 7. Failed services
    echo -e "\n=== Failed Services ==="
    systemctl --failed --no-pager
}

system_health_check
```

</details>

**Boris:** *"Мониторинг — это как пульс. Если не мониторишь, не знаешь когда сервер умирает."*

---

### Задание 7: Итоговый отчёт — Process Management Audit
**Цель:** Создать comprehensive отчёт для Viktor

**Отчёт должен включать:**
1. Найденные и убитые backdoor процессы
2. Созданные systemd services
3. Настроенные timers
4. Примеры логов из journalctl
5. System health metrics
6. Рекомендации

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

generate_process_audit_report() {
    local report_file="/var/operations/process_audit_ep10.txt"

    echo "Generating Process Management Audit Report..."

    sudo mkdir -p "$(dirname "$report_file")"

    sudo tee "$report_file" > /dev/null << EOF
================================================================================
                   PROCESS MANAGEMENT AUDIT REPORT - EPISODE 10
                        Processes & SystemD
================================================================================

Operation: KERNEL SHADOWS
Location: Saint Petersburg, Russia
Date: $(date)
Auditor: Max Sokolov
Mentor: Boris Kuznetsov

--------------------------------------------------------------------------------
1. BACKDOOR PROCESS DETECTION
--------------------------------------------------------------------------------

Suspicious processes found and eliminated:

$(ps aux | grep -E 'sshd_backup|suspicious' | grep -v grep || echo "No suspicious processes currently running")

Action taken:
✓ Process identified via ps aux and pgrep
✓ Graceful shutdown attempted (SIGTERM)
✓ Force kill applied if necessary (SIGKILL)
✓ Process confirmed dead

Lesson: "Процессы не врут про PID. Но врут про имя." - Boris

--------------------------------------------------------------------------------
2. SYSTEMD SERVICES CREATED
--------------------------------------------------------------------------------

Service: shadow-monitor.service
Purpose: Continuous monitoring for suspicious processes
Status: $(systemctl is-active shadow-monitor.service 2>/dev/null || echo "not running")
Enabled: $(systemctl is-enabled shadow-monitor.service 2>/dev/null || echo "not enabled")

Configuration:
$(systemctl cat shadow-monitor.service 2>/dev/null | head -20 || echo "Service not found")

Runtime Status:
$(systemctl status shadow-monitor.service --no-pager 2>/dev/null | head -10 || echo "Service not running")

--------------------------------------------------------------------------------
3. SYSTEMD TIMERS CONFIGURED
--------------------------------------------------------------------------------

Timer: shadow-backup.timer
Purpose: Hourly backup of critical configurations
Status: $(systemctl is-active shadow-backup.timer 2>/dev/null || echo "not running")

Next Execution:
$(systemctl list-timers shadow-backup.timer --no-pager 2>/dev/null || echo "Timer not active")

Last Execution:
$(journalctl -u shadow-backup.service -n 1 --no-pager 2>/dev/null || echo "No execution yet")

Backup Location: /var/backups/shadow/
Retention: Last 24 backups (24 hours)

--------------------------------------------------------------------------------
4. JOURNALCTL LOG ANALYSIS
--------------------------------------------------------------------------------

Recent shadow-monitor activity:
$(journalctl -u shadow-monitor.service -n 10 --no-pager 2>/dev/null || echo "No logs available")

Recent errors (last 24h):
$(journalctl -p err --since "24 hours ago" --no-pager | tail -5 || echo "No errors found")

Journal disk usage: $(journalctl --disk-usage 2>/dev/null | awk '{print $NF}' || echo "Unknown")

--------------------------------------------------------------------------------
5. SYSTEM HEALTH METRICS
--------------------------------------------------------------------------------

Uptime: $(uptime -p)
Load Average: $(uptime | awk -F'load average:' '{print $2}')
CPU Cores: $(nproc)
Load per core: $(uptime | awk '{print $NF}' | awk -v cores=$(nproc) '{printf "%.2f", $1/cores}')

Memory:
$(free -h | grep -E 'Mem:|Swap:')

Top 5 processes by CPU:
$(ps aux --sort=-%cpu | head -6)

Top 5 processes by Memory:
$(ps aux --sort=-%mem | head -6)

Failed services:
$(systemctl --failed --no-pager || echo "None")

--------------------------------------------------------------------------------
6. BORIS KUZNETSOV NOTES
--------------------------------------------------------------------------------

"Max справился отлично. Понял systemd — понял современный Linux.

Ключевые достижения:
✓ Нашёл backdoor процесс (анализ через ps/pgrep)
✓ Корректно убил через signals (SIGTERM -> SIGKILL)
✓ Создал systemd service (правильная структура unit)
✓ Настроил timer (замена cron, лучше интегрирован)
✓ Освоил journalctl (логи — основа forensics)
✓ Мониторит систему (load, memory, CPU)

Init scripts — это прошлое. SystemD — это настоящее. Max это понял.

Рекомендации для production:
1. Мониторинг 24/7 (shadow-monitor работает)
2. Регулярные backups (timer настроен)
3. Анализ логов (journalctl каждый день)
4. Hardening services (NoNewPrivileges, PrivateTmp)
5. Alerts при аномалиях (можно интегрировать с Telegram)

SystemD не идеален. Но он работает. И если понимаешь как — контролируешь всё."

Signed: Boris Kuznetsov, SystemD Architect
        Max Sokolov, System Administrator

--------------------------------------------------------------------------------
7. ANNA KOVALEVA (FORENSICS NOTES)
--------------------------------------------------------------------------------

"Backdoor процесс обнаружен через анализ:
1. ps aux показал дубликат sshd
2. /proc/PID/exe указывал на /tmp/ (подозрительно)
3. Parent Process ID (PPID) был 1 (systemd) — но не через unit файл
4. Процесс убит, но нужен постоянный мониторинг

Max правильно настроил journalctl мониторинг. Теперь любая активность логируется.

Krylov оставляет следы. Логи их хранят. Это наше преимущество."

--------------------------------------------------------------------------------
8. SECURITY POSTURE
--------------------------------------------------------------------------------

✓ Process monitoring: ACTIVE (shadow-monitor.service)
✓ Automated backups: ENABLED (shadow-backup.timer hourly)
✓ Log aggregation: CONFIGURED (journalctl)
✓ System health: MONITORED (load, memory, CPU tracked)

✓ Defense in Depth:
  - Process-level monitoring (ps, pgrep, top)
  - Service-level control (systemd)
  - Log-level forensics (journalctl)
  - Automated response (can kill suspicious processes)

✓ Production Ready:
  - Services auto-start on boot
  - Services auto-restart on failure (Restart=always)
  - Logs persistent across reboots
  - Timers more reliable than cron

--------------------------------------------------------------------------------
9. RECOMMENDATIONS
--------------------------------------------------------------------------------

Immediate:
  ✓ Shadow-monitor deployed
  ✓ Shadow-backup timer active
  ✓ Journalctl configured

Short-term (1-2 weeks):
  [ ] Add alerting (Telegram bot for critical events)
  [ ] Implement auto-response (auto-kill suspicious processes)
  [ ] Set up remote log shipping (centralized logging)
  [ ] Configure log rotation (journalctl --vacuum-time=30d)

Long-term (1-3 months):
  [ ] Full monitoring stack (Prometheus + Grafana - Season 7)
  [ ] Distributed tracing
  [ ] Automated incident response
  [ ] Anomaly detection (ML-based)

--------------------------------------------------------------------------------
10. VIKTOR PETROV APPROVAL
--------------------------------------------------------------------------------

"Отчёт принят. Process management на должном уровне.

Backdoor процесс Krylov нейтрализован. Мониторинг установлен.
Systemd services работают корректно. Automation через timers — отлично.

Max, ты переходишь от basics к production skills. Продолжай.

Следующий шаг: Таллин, Эстония. Disk management и LVM (Episode 11).

Хорошая работа."

Viktor Petrov
Operation Coordinator
KERNEL SHADOWS

================================================================================
                              END OF REPORT
================================================================================

Report generated: $(date)
Location: $report_file
Permissions: 640 (viktor:operations)
EOF

    # Set permissions
    sudo chmod 640 "$report_file"
    sudo chown viktor:operations "$report_file" 2>/dev/null || true

    echo "✓ Process Management Audit Report generated: $report_file"

    # Display summary
    echo -e "\n=== Report Summary ==="
    echo "  Backdoor processes: Found and eliminated"
    echo "  SystemD services: shadow-monitor.service (active)"
    echo "  SystemD timers: shadow-backup.timer (hourly)"
    echo "  Journalctl: Configured and analyzed"
    echo "  System health: Monitored (load, memory, CPU)"
    echo "  Full report: $report_file"
}

generate_process_audit_report
```

</details>

---

## 📚 Теория: Processes & SystemD

### 1. Процессы в Linux

**Что такое процесс?**
- Программа, загруженная в память и выполняющаяся
- Каждый процесс имеет уникальный PID (Process ID)
- Процессы организованы в дерево (parent-child relationships)

**Атрибуты процесса:**
- **PID** — Process ID (уникальный номер)
- **PPID** — Parent Process ID (кто создал процесс)
- **UID/GID** — владелец процесса
- **State** — состояние (running, sleeping, stopped, zombie)
- **Memory** — используемая память
- **CPU** — % использования процессора

**Первый процесс:**
- В современных системах: **systemd** (PID 1)
- В старых: init
- Все процессы — потомки PID 1

---

### 2. Команды для работы с процессами

#### `ps` — Process Status

```bash
# Все процессы
ps aux

# Расшифровка колонок:
# USER  PID  %CPU  %MEM  VSZ   RSS   TTY  STAT  START  TIME  COMMAND

# Примеры:
ps aux | grep nginx        # найти nginx процессы
ps -ef                     # альтернативный формат
ps -p 1234                # конкретный PID
ps --forest               # tree view
```

#### `top` / `htop` — Real-time monitoring

```bash
top                       # интерактивный мониторинг
top -u username          # только процессы пользователя
htop                     # улучшенная версия (если установлен)
```

**Hotkeys в top:**
- `k` — убить процесс
- `r` — изменить nice (приоритет)
- `1` — показать каждое CPU ядро
- `M` — сортировка по памяти
- `P` — сортировка по CPU
- `q` — выход

#### `pgrep` / `pkill` — Find/Kill by name

```bash
pgrep nginx              # найти PID по имени
pgrep -a nginx          # показать командную строку
pgrep -u username       # процессы пользователя
pkill nginx             # убить все nginx процессы
```

#### `/proc` filesystem

```bash
# Информация о процессе PID
ls -la /proc/PID/

# Важные файлы:
/proc/PID/cmdline       # командная строка
/proc/PID/environ       # environment variables
/proc/PID/exe           # ссылка на исполняемый файл
/proc/PID/status        # статус процесса
/proc/PID/fd/           # открытые файлы

# Пример:
cat /proc/1234/cmdline | tr '\0' ' '
ls -l /proc/1234/exe
```

---

### 3. Signals (сигналы)

**Что такое signal?**
- Способ коммуникации с процессом
- Процесс может обработать signal или игнорировать

**Основные signals:**

| Signal | Номер | Значение | Можно игнорировать? |
|--------|-------|----------|---------------------|
| SIGHUP | 1 | Hangup (reload config) | Да |
| SIGINT | 2 | Interrupt (Ctrl+C) | Да |
| SIGQUIT | 3 | Quit | Да |
| SIGKILL | 9 | Kill (force) | **НЕТ** |
| SIGTERM | 15 | Terminate (graceful) | Да |
| SIGSTOP | 19 | Stop | **НЕТ** |
| SIGCONT | 18 | Continue | — |

**Использование:**

```bash
kill -15 PID            # SIGTERM (graceful shutdown)
kill -9 PID             # SIGKILL (force kill)
kill -HUP PID          # reload config (nginx, apache)
kill -l                 # список всех signals

killall process_name    # kill all by name
pkill -TERM process_name
```

**Best Practice:**
1. Сначала SIGTERM (дать возможность закрыться gracefully)
2. Подождать 5-10 секунд
3. Если не помогло — SIGKILL

---

### 4. SystemD — система инициализации

**Что такое SystemD?**
- Современная система инициализации (заменила init)
- PID 1 — первый процесс в системе
- Управляет сервисами, сокетами, устройствами, mount points

**Почему SystemD?**
- ✅ Параллельный запуск (быстрая загрузка)
- ✅ Зависимости между сервисами
- ✅ Socket activation
- ✅ Интегрированное логирование (journald)
- ✅ Автоматический рестарт сервисов
- ❌ Сложный (монолитный)
- ❌ Споры в сообществе

**Дистрибутивы с SystemD:**
- Ubuntu (с 15.04)
- Debian (с 8)
- Fedora / RHEL / CentOS
- Arch Linux
- openSUSE

---

### 5. SystemD Unit Files

**Unit File** — конфигурация сервиса/таймера/socket и т.д.

**Типы units:**
- `.service` — сервисы
- `.timer` — таймеры (замена cron)
- `.socket` — сокеты
- `.target` — группы units
- `.mount` — монтирование
- `.path` — мониторинг путей

**Расположение:**
- `/etc/systemd/system/` — пользовательские units (приоритет)
- `/lib/systemd/system/` — системные units
- `/run/systemd/system/` — runtime units

---

### 6. Service Unit структура

```ini
[Unit]
Description=Human-readable описание
Documentation=https://example.com/docs
After=network.target          # запускать после сети
Requires=другой.service       # обязательная зависимость
Wants=другой.service          # желательная зависимость

[Service]
Type=simple                   # тип сервиса (см. ниже)
ExecStart=/path/to/binary     # команда запуска
ExecReload=/path/to/reload    # команда reload
ExecStop=/path/to/stop        # команда остановки
Restart=always                # перезапуск при падении
RestartSec=10                 # задержка перед рестартом
User=username                 # от какого пользователя
Group=groupname               # от какой группы
WorkingDirectory=/path        # рабочая директория
Environment="VAR=value"       # переменные окружения
EnvironmentFile=/path/to/env  # файл с переменными

# Логирование
StandardOutput=journal        # stdout в journald
StandardError=journal         # stderr в journald

# Security hardening
NoNewPrivileges=true          # запретить escalation
PrivateTmp=true               # изолированный /tmp
ReadOnlyPaths=/etc            # read-only пути

[Install]
WantedBy=multi-user.target    # когда активировать
```

**Type сервиса:**
- `simple` — процесс запускается и работает (default)
- `forking` — процесс fork() и parent завершается (daemon style)
- `oneshot` — запускается и завершается (для задач)
- `notify` — процесс уведомляет systemd о готовности
- `dbus` — активация через D-Bus

---

### 7. SystemCTL команды

```bash
# Управление сервисами
systemctl start service.service      # запустить
systemctl stop service.service       # остановить
systemctl restart service.service    # перезапустить
systemctl reload service.service     # reload config (если поддерживается)
systemctl status service.service     # статус

# Автозапуск
systemctl enable service.service     # автозапуск при загрузке
systemctl disable service.service    # отключить автозапуск
systemctl is-enabled service.service # проверить

# Информация
systemctl list-units                 # все units
systemctl list-units --type=service  # только сервисы
systemctl list-unit-files            # все unit files
systemctl cat service.service        # показать unit file
systemctl show service.service       # все свойства

# После изменений unit files
systemctl daemon-reload              # перечитать конфигурацию

# Проблемы
systemctl --failed                   # упавшие сервисы
systemctl reset-failed               # очистить failed state
```

---

### 8. SystemD Timers (замена cron)

**Почему timers > cron?**
- ✅ Интеграция с journalctl (логи)
- ✅ Persistent (запустит если пропущен)
- ✅ Можно запускать относительно events
- ✅ Лучший контроль (зависимости, условия)

**Timer unit структура:**

```ini
[Unit]
Description=My Timer

[Timer]
# Когда запускать:
OnCalendar=hourly              # каждый час
OnCalendar=daily               # каждый день
OnCalendar=weekly              # каждую неделю
OnCalendar=*:0/15              # каждые 15 минут
OnCalendar=Mon,Fri 10:00       # понедельник и пятница в 10:00

# Или относительно:
OnBootSec=15min                # через 15 минут после загрузки
OnUnitActiveSec=1h             # через час после последнего запуска

# Опции:
Persistent=true                # запустить если пропущен
AccuracySec=1min               # точность (по умолчанию 1 минута)

[Install]
WantedBy=timers.target
```

**OnCalendar примеры:**

```bash
hourly                    # каждый час в :00
daily                     # каждый день в 00:00
weekly                    # каждую неделю в воскресенье 00:00
monthly                   # первое число месяца 00:00

*:0/15                    # каждые 15 минут
*-*-* 04:00:00           # каждый день в 4:00 AM
Mon,Tue,Wed 10:00        # пн-ср в 10:00
Mon..Fri 09:00           # пн-пт в 09:00
```

**Проверка синтаксиса:**

```bash
systemd-analyze calendar "Mon,Fri 10:00"
systemd-analyze calendar "hourly"
```

**Управление timers:**

```bash
systemctl enable mytimer.timer
systemctl start mytimer.timer
systemctl list-timers               # все таймеры
systemctl list-timers mytimer.timer # конкретный
```

---

### 9. Journalctl — системные логи

**Что такое journald?**
- SystemD logging daemon
- Все логи в binary формате
- Интеграция со всеми systemd services

**Основные команды:**

```bash
# Просмотр логов
journalctl                      # все логи
journalctl -n 100              # последние 100 строк
journalctl -f                   # follow (tail -f)
journalctl -r                   # reverse (сначала новые)

# По сервису
journalctl -u service.service   # логи сервиса
journalctl -u service.service -f  # follow

# По времени
journalctl --since "2025-10-09 10:00"
journalctl --since "1 hour ago"
journalctl --since today
journalctl --since yesterday
journalctl --until "2025-10-09 12:00"

# По priority
journalctl -p err               # только errors
journalctl -p warning           # warnings и выше
journalctl -p debug             # все уровни

# Levels: emerg, alert, crit, err, warning, notice, info, debug

# По процессу/пользователю
journalctl _PID=1234
journalctl _UID=1000
journalctl _COMM=sshd           # по имени команды

# Формат вывода
journalctl -o json              # JSON
journalctl -o json-pretty       # pretty JSON
journalctl -o verbose           # verbose
journalctl -o cat               # только сообщения

# Дисковое пространство
journalctl --disk-usage         # сколько занимает
sudo journalctl --vacuum-time=7d  # оставить 7 дней
sudo journalctl --vacuum-size=1G  # оставить max 1GB

# Boots (загрузки)
journalctl --list-boots         # все загрузки
journalctl -b                   # текущая загрузка
journalctl -b -1                # предыдущая загрузка
```

**Комбинации:**

```bash
# Errors за последний час
journalctl -p err --since "1 hour ago"

# SSH логи за сегодня
journalctl -u sshd --since today

# Root activity
journalctl _UID=0 --since "1 hour ago"

# Follow errors в реальном времени
journalctl -p err -f
```

---

### 10. Process States

**Процессы могут быть в разных состояниях:**

| State | Code | Значение |
|-------|------|----------|
| Running | R | Выполняется или готов к выполнению |
| Sleeping | S | Ждёт события (interruptible) |
| Uninterruptible | D | Ждёт I/O (uninterruptible) |
| Stopped | T | Остановлен (Ctrl+Z, SIGSTOP) |
| Zombie | Z | Завершён, но parent не прочитал exit status |

**Дополнительные модификаторы:**
- `<` — high priority
- `N` — low priority
- `L` — страницы заблокированы в памяти
- `s` — session leader
- `+` — в foreground

**Zombie processes:**
- Процесс завершился, но parent не вызвал `wait()`
- Занимает только запись в process table
- Обычно безвредны, но много zombies — признак бага

**Как убить zombies:**
- Убить parent процесс (zombies перейдут к init/systemd)
- `kill -SIGCHLD parent_pid` — попросить parent прочитать status

---

## 🛠️ Bash Reference для Episode 10

### Полезные однострочники:

```bash
# Найти процесс по имени и порту
lsof -i :8080                    # кто слушает порт 8080
netstat -tulpn | grep :8080      # альтернатива

# Top процессы по ресурсам
ps aux --sort=-%cpu | head -10   # top по CPU
ps aux --sort=-%mem | head -10   # top по памяти

# Найти и убить все процессы пользователя
pkill -u username
killall -u username

# Process tree
ps auxf                          # tree format
pstree                          # dedicated tool
pstree -p                       # с PID

# Процессы от конкретного пользователя
ps -u username
ps -U username

# Zombie processes
ps aux | awk '$8=="Z"'

# Load average analysis
uptime | awk -F'load average:' '{print $2}'

# Memory-intensive processes
ps aux | awk '{print $6"\t"$11}' | sort -rn | head

# SystemD service dependencies
systemctl list-dependencies service.service

# All failed services
systemctl --failed

# Service start time
systemctl show service.service --property=ActiveEnterTimestamp
```

---

## 🎓 LILITH: Wisdom & Tips

### Boris Kuznetsov's SystemD Philosophy:

> *"Init scripts — это прошлое. SystemD — это будущее. И настоящее."*

**Принципы работы с процессами:**

1. **Процессы — это правда**
   Процесс не врёт про свой PID, owner, memory. Научись их читать.

2. **Signals имеют значение**
   SIGTERM — вежливо. SIGKILL — грубо. Всегда начинай с вежливого.

3. **SystemD даёт контроль**
   Service падает → systemd рестартит. Это надёжность.

4. **Timers > Cron**
   Persistent=true, интеграция с journalctl, лучший контроль.

5. **Логи — твой лучший друг**
   journalctl -p err --since "1 hour ago" — начало любого расследования.

---

### LILITH Process Monitoring Mode:

**Обнаружение подозрительных процессов:**

```bash
# Процессы в странных местах
find /tmp /var/tmp /dev/shm -type f -executable 2>/dev/null

# Процессы без parent
ps -eo pid,ppid,cmd | awk '$2==1'

# Процессы которые слушают порты
netstat -tulpn | grep LISTEN

# Процессы с странными именами (копируют системные)
ps aux | grep -E 'sshd.*backup|nginx.*temp|apache.*old'

# Высокая CPU нагрузка (криптомайнеры?)
ps aux --sort=-%cpu | head -5
```

**Forensics через journalctl:**

```bash
# Когда процесс последний раз запускался
journalctl _COMM=processname --since today

# Все sudo команды
journalctl _COMM=sudo --since today

# SSH подключения
journalctl -u sshd | grep 'Accepted'

# Failed login attempts
journalctl _SYSTEMD_UNIT=sshd.service | grep 'Failed'
```

---

### Частые ошибки:

1. ❌ **kill -9 сразу**
   Дай процессу шанс закрыться gracefully (SIGTERM сначала).

2. ❌ **Забыть daemon-reload**
   После изменения unit file: `systemctl daemon-reload`

3. ❌ **Type=simple для forking процессов**
   Если процесс делает fork(), используй Type=forking

4. ❌ **Не проверять failed services**
   `systemctl --failed` — регулярно проверяй

5. ❌ **Игнорировать journalctl**
   Логи — первое место для поиска проблем

---

## 🎯 Итоги Episode 10

### Что вы освоили:

✅ **Процессы в Linux**
   - ps, top, htop, pgrep/pkill
   - /proc filesystem
   - Process states и zombie processes

✅ **Signals**
   - SIGTERM vs SIGKILL
   - Graceful shutdown
   - kill, killall, pkill

✅ **SystemD Services**
   - Unit file структура
   - systemctl команды
   - Auto-restart, dependencies

✅ **SystemD Timers**
   - Замена cron
   - OnCalendar синтаксис
   - Persistent timers

✅ **Journalctl**
   - Чтение логов
   - Фильтрация по времени, priority, service
   - Forensics analysis

✅ **Мониторинг системы**
   - Load average, CPU, Memory
   - Top процессы
   - System health metrics

---

### Сюжетный итог:

**Boris** (провожает Max):
*"Max, ты понял systemd. Это значит ты понял современный Linux. Init scripts — история. SystemD — это настоящее. Споры будут всегда. Но он РАБОТАЕТ."*

**Anna** (видеозвонок):
*"Backdoor процесс нейтрализован. Мониторинг установлен. Теперь мы увидим любую активность. Krylov не сможет скрыться в процессах. Спасибо, Макс."*

**Viktor:**
*"Отлично. Санкт-Петербург — готово. Следующая остановка — Таллин, Эстония. Там тебя ждёт Kristjan Tamm. Disk management, LVM, RAID. Критическая инфраструктура. Готовься."*

**Max:** *"SystemD... Я понял почему все дистрибутивы перешли на него. Контроль. Автоматизация. Надёжность. Да, сложно. Но мощно."*

---

**LILITH:**
*"Процессы — это жизнь системы. Ты научился читать её пульс. Мониторинг, управление, forensics. Это основа. Следующий шаг — диски. Без данных система мертва. Готовься."*

---

## 📖 Дополнительные ресурсы

### Man pages (обязательно!):
```bash
man ps
man top
man kill
man systemd
man systemctl
man journalctl
man systemd.service
man systemd.timer
man systemd.unit
```

### Online:
- [SystemD for Administrators](https://www.freedesktop.org/wiki/Software/systemd/)
- [ArchWiki: systemd](https://wiki.archlinux.org/title/Systemd)
- [Red Hat: SystemD](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_working-with-systemd_configuring-basic-system-settings)

---

<div align="center">

**Next:** [Episode 11: Disk Management & LVM](../episode-11-disk-management-lvm/) → Tallinn 🇪🇪

*"Процессы — это пульс системы. Systemd — это сердце."*

**Day 19-20 / 60 Complete! 🎉**

</div>


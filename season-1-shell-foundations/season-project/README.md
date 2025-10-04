# Season 1: Integration Project
## SYSTEM SETUP MASTER SCRIPT

```
ОПЕРАЦИЯ: KERNEL SHADOWS
СЕЗОН: 1 — Shell & Foundations
ПРОЕКТ: Season Integration Project
СТАТУС: FINAL PROJECT
СЛОЖНОСТЬ: ⭐⭐⭐⭐☆
ВРЕМЯ: 4-6 часов
ТРЕБОВАНИЯ: Episodes 01-04 завершены
```

---

## 📖 Миссия

**От:** Viktor Petrov
**Кому:** Max Sokolov
**Тема:** Финальное задание Season 1
**Дата:** 12 октября 2025, 14:30 MSK

---

### BRIEFING

Max,

Отличная работа за эти 10 дней. Ты освоил основы:
- ✅ **Terminal navigation** (Episode 01)
- ✅ **Shell scripting** (Episode 02)
- ✅ **Text processing** (Episode 03)
- ✅ **Package management** (Episode 04)

Теперь финальный тест.

**Задача:** Нам нужно развернуть **ещё 20 серверов** для операции. Быстро. Одинаково. Без ошибок.

Создай **master script** `system_setup.sh`, который автоматизирует:
1. **Проверку системы** (filesystem, permissions, configuration)
2. **Мониторинг** (CPU, memory, disk, load average)
3. **Анализ безопасности** (логи, suspicious activity, threats)
4. **Установку инструментов** (security tools, networking tools)
5. **Генерацию отчёта** (полный аудит сервера)

Это **интеграция всех твоих навыков**. Один скрипт. Всё автоматизировано.

**Deadline:** 24 часа.

**P.S.** LILITH поможет. Но скрипт должен быть **твой**.

— Viktor

---

## 🎯 Цель проекта

Создать **production-ready** скрипт `system_setup.sh`, который:

### Функциональность:
1. **System Check** (Episode 01 навыки):
   - Проверка структуры файловой системы
   - Поиск критических файлов
   - Проверка permissions
   - Disk space анализ

2. **System Monitoring** (Episode 02 навыки):
   - CPU load, memory usage
   - Disk I/O
   - Running processes
   - System uptime
   - Critical services status

3. **Security Analysis** (Episode 03 навыки):
   - Анализ auth.log (failed logins)
   - Suspicious IP detection
   - Brute-force attempts
   - TOP failed login attempts
   - Threat reporting

4. **Package Installation** (Episode 04 навыки):
   - Проверка установленных пакетов
   - Установка недостающих инструментов
   - Dependency resolution
   - Installation logging

5. **Reporting**:
   - Генерация полного отчёта
   - HTML report (опционально)
   - Summary для команды

---

## 🛠️ Технические требования

### Входные данные:
- `artifacts/required_packages.txt` — список необходимых пакетов
- `artifacts/threat_database.txt` — база известных угроз (IP)
- `artifacts/critical_paths.txt` — критические пути для проверки

### Выходные данные:
- `system_report.txt` — текстовый отчёт
- `security_analysis.txt` — анализ безопасности
- `install.log` — лог установки пакетов
- `setup.log` — общий лог выполнения

### Скрипт должен:
- ✅ Работать в non-interactive режиме
- ✅ Обрабатывать ошибки gracefully
- ✅ Логировать все действия
- ✅ Поддерживать dry-run mode (--dry-run)
- ✅ Выводить цветной прогресс
- ✅ Генерировать читаемый отчёт
- ✅ Проверять root права (для установки)
- ✅ Создавать backup перед изменениями

---

## 📋 Пошаговое задание

### Задание 1: Изучить структуру проекта (10 мин)

```bash
cd season-1-shell-foundations/episode-05-season-project/

# Изучить файлы
ls -la
cat artifacts/README.md
cat artifacts/required_packages.txt
cat artifacts/threat_database.txt
cat artifacts/critical_paths.txt
```

**Вопросы для LILITH:**
- Какие разделы должны быть в скрипте?
- Какие функции нужно создать?
- Как организовать код?

<details>
<summary>💡 Подсказка: Структура скрипта</summary>

```bash
#!/bin/bash
# system_setup.sh — Season 1 Integration Project

# 1. Configuration (colors, paths, variables)
# 2. Helper Functions (logging, colors, checks)
# 3. System Check Functions (Episode 01)
# 4. Monitoring Functions (Episode 02)
# 5. Security Analysis Functions (Episode 03)
# 6. Package Management Functions (Episode 04)
# 7. Reporting Functions
# 8. Main Function (orchestration)
# 9. Main execution
```

</details>

---

### Задание 2: Начать с шаблона (15 мин)

```bash
# Скопировать шаблон
cp starter.sh system_setup.sh
chmod +x system_setup.sh

# Открыть в редакторе
nano system_setup.sh
# или
code system_setup.sh
```

**Что делать:**
- Изучить TODO комментарии
- Понять структуру шаблона
- Заполнить базовые функции (log_message, print_status)

<details>
<summary>💡 Подсказка: Цветной вывод</summary>

```bash
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    local status="$1"
    local message="$2"

    case "$status" in
        "ok")
            echo -e "${GREEN}[✓]${NC} $message"
            ;;
        "error")
            echo -e "${RED}[✗]${NC} $message"
            ;;
        "info")
            echo -e "${BLUE}[i]${NC} $message"
            ;;
        "warn")
            echo -e "${YELLOW}[!]${NC} $message"
            ;;
    esac
}
```

</details>

---

### Задание 3: System Check Module (30 мин)

**Функция:** `check_system()`

**Что проверить:**
- Filesystem structure (/, /home, /var, /etc)
- Critical files из `artifacts/critical_paths.txt`
- Disk space (warning если < 20%)
- File permissions (важные конфиги)

**Навыки из Episode 01:**
- `ls -la`, `find`, `test -f`, `test -d`
- Path navigation
- File permissions checking

<details>
<summary>💡 Подсказка: Проверка диска</summary>

```bash
check_disk_space() {
    log_message "INFO" "Checking disk space..."

    local usage
    usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

    if [[ $usage -gt 80 ]]; then
        print_status "warn" "Disk usage: ${usage}% (WARNING)"
        echo "Disk usage: ${usage}% (WARNING)" >> "$SYSTEM_REPORT"
    else
        print_status "ok" "Disk usage: ${usage}%"
        echo "Disk usage: ${usage}% (OK)" >> "$SYSTEM_REPORT"
    fi
}
```

</details>

---

### Задание 4: System Monitoring Module (30 мин)

**Функция:** `monitor_system()`

**Что мониторить:**
- CPU load average (1, 5, 15 минут)
- Memory usage (total, used, free)
- Disk I/O
- Running processes count
- System uptime

**Навыки из Episode 02:**
- Переменные, условия, циклы
- Exit codes
- Функции
- Логирование

<details>
<summary>💡 Подсказка: CPU и Memory</summary>

```bash
monitor_resources() {
    log_message "INFO" "Monitoring system resources..."

    # CPU load average
    local load_avg
    load_avg=$(uptime | awk -F'load average:' '{print $2}')
    print_status "info" "Load average:$load_avg"
    echo "Load average:$load_avg" >> "$SYSTEM_REPORT"

    # Memory
    local mem_total mem_used mem_free
    mem_total=$(free -h | awk 'NR==2 {print $2}')
    mem_used=$(free -h | awk 'NR==2 {print $3}')
    mem_free=$(free -h | awk 'NR==2 {print $4}')

    print_status "info" "Memory: $mem_used / $mem_total used"
    echo "Memory: $mem_used / $mem_total (Free: $mem_free)" >> "$SYSTEM_REPORT"

    # Process count
    local proc_count
    proc_count=$(ps aux | wc -l)
    print_status "info" "Running processes: $proc_count"
}
```

</details>

---

### Задание 5: Security Analysis Module (45 мин)

**Функция:** `analyze_security()`

**Что анализировать:**
- `/var/log/auth.log` — failed login attempts
- Suspicious IPs (сравнение с threat_database.txt)
- Brute-force detection (> 5 попыток с одного IP)
- TOP-10 failed logins by IP

**Навыки из Episode 03:**
- `grep`, `awk`, `sed`
- Pipes и redirects
- Text processing
- TOP-N analysis

<details>
<summary>💡 Подсказка: Failed logins</summary>

```bash
analyze_failed_logins() {
    log_message "INFO" "Analyzing failed login attempts..."

    if [[ ! -f /var/log/auth.log ]]; then
        print_status "warn" "auth.log not found, skipping"
        return
    fi

    # Извлечь failed logins
    local failed_count
    failed_count=$(grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l)

    print_status "info" "Failed login attempts: $failed_count"
    echo "Failed login attempts: $failed_count" >> "$SECURITY_ANALYSIS"

    # TOP-10 attacking IPs
    if [[ $failed_count -gt 0 ]]; then
        echo "" >> "$SECURITY_ANALYSIS"
        echo "TOP-10 Attacking IPs:" >> "$SECURITY_ANALYSIS"
        grep "Failed password" /var/log/auth.log 2>/dev/null | \
            awk '{print $(NF-3)}' | \
            sort | uniq -c | sort -rn | head -10 >> "$SECURITY_ANALYSIS"
    fi
}
```

</details>

---

### Задание 6: Package Management Module (30 мин)

**Функция:** `install_packages()`

**Что делать:**
- Прочитать `artifacts/required_packages.txt`
- Проверить установленные пакеты (dpkg -l)
- Установить недостающие (apt install)
- Логировать результаты

**Навыки из Episode 04:**
- APT commands
- Non-interactive installation
- Dependency resolution
- Error handling

<details>
<summary>💡 Подсказка: Check и Install</summary>

```bash
install_required_packages() {
    log_message "INFO" "Checking required packages..."

    if [[ $EUID -ne 0 ]]; then
        print_status "warn" "Not running as root, skipping package installation"
        return
    fi

    local packages_file="$ARTIFACTS_DIR/required_packages.txt"
    if [[ ! -f "$packages_file" ]]; then
        print_status "error" "Packages file not found: $packages_file"
        return 1
    fi

    while IFS= read -r package || [[ -n "$package" ]]; do
        # Skip comments and empty lines
        [[ "$package" =~ ^#.*$ || -z "$package" ]] && continue

        if dpkg -l | grep -q "^ii  $package "; then
            print_status "ok" "$package (already installed)"
        else
            print_status "info" "Installing $package..."
            apt-get install -y "$package" >> "$INSTALL_LOG" 2>&1
            if [[ $? -eq 0 ]]; then
                print_status "ok" "$package (installed)"
            else
                print_status "error" "$package (failed)"
            fi
        fi
    done < "$packages_file"
}
```

</details>

---

### Задание 7: Reporting Module (30 мин)

**Функция:** `generate_report()`

**Что включить в отчёт:**
- System information (hostname, OS, kernel)
- Disk space summary
- Resource usage summary
- Security analysis summary
- Installed packages count
- Recommendations

<details>
<summary>💡 Подсказка: Header отчёта</summary>

```bash
generate_report_header() {
    cat >> "$SYSTEM_REPORT" << EOF
================================================================================
SYSTEM SETUP REPORT
================================================================================
Generated: $(date '+%Y-%m-%d %H:%M:%S')
Hostname: $(hostname)
OS: $(lsb_release -d | cut -f2)
Kernel: $(uname -r)
Uptime: $(uptime -p)
================================================================================

EOF
}
```

</details>

---

### Задание 8: Main Function — Orchestration (20 мин)

**Функция:** `main()`

**Что делать:**
- Проверить аргументы (--dry-run флаг)
- Инициализировать логи
- Последовательно вызвать модули:
  1. System Check
  2. Monitoring
  3. Security Analysis
  4. Package Installation
  5. Report Generation
- Показать summary

<details>
<summary>💡 Подсказка: Main structure</summary>

```bash
main() {
    # Parse arguments
    local dry_run=false
    if [[ "$1" == "--dry-run" ]]; then
        dry_run=true
        print_status "info" "Running in DRY-RUN mode (no changes will be made)"
    fi

    # Initialize
    initialize_logs

    # Header
    print_header "KERNEL SHADOWS — System Setup"

    # Modules
    echo ""
    print_header "MODULE 1: System Check"
    check_system

    echo ""
    print_header "MODULE 2: System Monitoring"
    monitor_system

    echo ""
    print_header "MODULE 3: Security Analysis"
    analyze_security

    if [[ "$dry_run" == false ]]; then
        echo ""
        print_header "MODULE 4: Package Installation"
        install_packages
    else
        print_status "info" "Skipping package installation (dry-run mode)"
    fi

    echo ""
    print_header "MODULE 5: Report Generation"
    generate_report

    # Summary
    echo ""
    print_header "SETUP COMPLETE"
    print_status "ok" "Reports generated:"
    echo "  - $SYSTEM_REPORT"
    echo "  - $SECURITY_ANALYSIS"
    echo "  - $SETUP_LOG"
}

main "$@"
```

</details>

---

### Задание 9: Тестирование (30 мин)

```bash
# 1. Dry-run (без установки пакетов)
./system_setup.sh --dry-run

# 2. Проверить созданные файлы
ls -la *.txt *.log
cat system_report.txt
cat security_analysis.txt

# 3. С установкой пакетов (если есть sudo)
sudo ./system_setup.sh

# 4. Запустить автотесты
cd tests/
./test.sh
```

**Что проверить:**
- ✅ Скрипт запускается без ошибок
- ✅ Все модули выполняются
- ✅ Генерируются все отчёты
- ✅ Логи содержат детальную информацию
- ✅ Цветной вывод работает
- ✅ Dry-run mode работает
- ✅ Error handling корректен

---

### Задание 10: Запустить на "production" (опционально)

Если у вас есть доступ к тестовому серверу:

```bash
# Скопировать скрипт на сервер
scp system_setup.sh user@server:/tmp/
scp -r artifacts/ user@server:/tmp/

# Подключиться и запустить
ssh user@server
cd /tmp
sudo ./system_setup.sh

# Проверить результаты
cat system_report.txt
```

---

## 🧪 Автотесты

```bash
cd tests/
./test.sh
```

**Что тестируется:**
- ✅ Структура скрипта (shebang, functions)
- ✅ Наличие всех модулей
- ✅ Dry-run mode
- ✅ Генерация отчётов
- ✅ Логирование
- ✅ Error handling
- ✅ Exit codes

**Ожидаемый результат:**
```
[✓] Structure tests: PASSED
[✓] Functional tests: PASSED
[✓] Dry-run tests: PASSED
[✓] Report generation: PASSED
[✓] Error handling: PASSED

All tests passed! (15/15)
```

---

## 📚 Справочник

### Команды из Episode 01 (System Check):
```bash
# Проверка файлов
test -f /path/to/file && echo "exists"
ls -la /path
find / -name "filename"

# Диск
df -h
du -sh /path
```

### Команды из Episode 02 (Monitoring):
```bash
# Ресурсы
uptime
free -h
top -bn1 | head -20
ps aux

# Процессы
pgrep -c process_name
systemctl status service_name
```

### Команды из Episode 03 (Security):
```bash
# Логи
grep "pattern" /var/log/auth.log
awk '{print $NF}' file.log
sed 's/old/new/g' file

# Анализ
sort | uniq -c | sort -rn | head -10
```

### Команды из Episode 04 (Packages):
```bash
# APT
apt update
apt install -y package
dpkg -l | grep package

# Проверка
which command
command --version
```

---

## 🎓 Критерии успеха

### Минимальные требования (проходной балл):
- ✅ Скрипт запускается без ошибок
- ✅ Все 4 модуля реализованы
- ✅ Генерируется отчёт
- ✅ Есть логирование
- ✅ Проходит базовые тесты (10/15)

### Хорошее решение:
- ✅ + Цветной вывод
- ✅ + Dry-run mode
- ✅ + Error handling
- ✅ + Проходит все тесты (15/15)

### Отличное решение:
- ✅ + Модульная структура (чистый код)
- ✅ + Comprehensive logging
- ✅ + Красивый отчёт
- ✅ + HTML report (бонус)
- ✅ + Работает на production сервере

---

## 🤖 LILITH — Советы

> *"Это твой выпускной экзамен Season 1. Покажи, чему научился."*

### Стратегия:
1. **Начни с малого:** Реализуй по одному модулю, тестируй
2. **Используй шаблон:** starter.sh уже имеет структуру
3. **Переиспользуй код:** Посмотри на свои решения Episodes 01-04
4. **Не копируй напрямую:** Адаптируй под новую задачу
5. **Тестируй часто:** ./system_setup.sh --dry-run после каждого модуля

### Если застрял:
- **Episode 01 проблемы?** → `man find`, `man test`
- **Episode 02 проблемы?** → Посмотри server_monitor.sh
- **Episode 03 проблемы?** → Посмотри log_analyzer.sh
- **Episode 04 проблемы?** → Посмотри install_toolkit.sh

> *"Интеграция — это не просто объединение кода. Это создание системы, где части работают вместе."*

### Best Practices:
```bash
# 1. Всегда проверяй существование файлов
if [[ ! -f "$file" ]]; then
    echo "Error: File not found: $file"
    return 1
fi

# 2. Логируй все важные действия
log_message "INFO" "Starting module: $module_name"

# 3. Обрабатывай ошибки
some_command || {
    echo "Error: Command failed"
    return 1
}

# 4. Используй функции для переиспользования
print_status "ok" "Operation successful"

# 5. Кавычки вокруг переменных
echo "$variable"
```

> *"Root access для этого проекта опционален. Большинство проверок работают без sudo. Только package installation требует root."*

---

## 📁 Структура файлов

```
episode-05-season-project/
├── README.md                  # Этот файл
├── starter.sh                 # Шаблон скрипта
├── system_setup.sh            # Твоё решение
│
├── solution/
│   └── system_setup.sh        # Референсное решение
│
├── artifacts/
│   ├── README.md              # Инструкции
│   ├── required_packages.txt  # Список пакетов
│   ├── threat_database.txt    # База угроз
│   └── critical_paths.txt     # Критические пути
│
├── tests/
│   └── test.sh                # Автотесты
│
├── system_report.txt          # Генерируется скриптом
├── security_analysis.txt      # Генерируется скриптом
├── setup.log                  # Генерируется скриптом
└── install.log                # Генерируется скриптом
```

---

## 🎬 Сюжет: Что дальше?

После успешного завершения Season 1 Integration Project:

**Viktor Petrov:**
> *"Отличная работа, Max. 20 серверов настроены и готовы. Ты прошёл Season 1."*

**LILITH:**
> *"Shell mastery: ✓. Scripting: ✓. Text processing: ✓. Package management: ✓. Ты готов к Season 2."*

**Alex Sokolov:**
> *"Следующий уровень — networking. Я научу тебя видеть packets. Понимать protocols. Защищать периметр."*

**Anna Kovaleva:**
> *"И анализировать трафик. Krylov не остановится. Нам нужна сетевая защита."*

**Dmitry Orlov:**
> *"А ещё настроим мониторинг. Prometheus, Grafana. Видеть всё. В реальном времени."*

**Viktor:**
> *"Но это потом. Сейчас — отдохни. Завтра начнём Season 2: Networking."*

---

## 🔄 Следующие шаги

### После завершения Integration Project:
1. ✅ Завершил все модули скрипта
2. ✅ Прошёл все тесты (15/15)
3. ✅ Скрипт работает на реальном сервере
4. ✅ Отчёты генерируются корректно
5. ✅ **Season 1 Complete!** 🎉

### Переход к Season 2:
```bash
cd ../../season-2-networking/episode-06-tcp-ip-fundamentals/
less README.md
```

**Что ждёт в Season 2:**
- TCP/IP протоколы
- DNS и резолюция имён
- Firewalls (iptables, ufw)
- VPN и SSH tunneling
- Сетевая безопасность
- Первая настоящая атака от Krylov

---

## 💡 Дополнительные задачи (опционально)

Если хочешь бросить себе вызов:

### Задача 1: HTML Report
Генерировать HTML версию отчёта с CSS стилями.

### Задача 2: Email Notifications
Отправлять summary по email после завершения.

### Задача 3: Telegram Bot Integration
Интегрировать с Telegram bot для алертов.

### Задача 4: Ansible Playbook
Конвертировать скрипт в Ansible playbook для mass deployment.

### Задача 5: Systemd Service
Создать systemd service для регулярного запуска (раз в день).

---

## 🏆 Достижения

После завершения этого проекта ты получишь:

**Technical Skills:**
- ✅ Bash scripting mastery
- ✅ System administration basics
- ✅ Security analysis fundamentals
- ✅ Automation mindset

**Soft Skills:**
- ✅ Problem decomposition
- ✅ Code organization
- ✅ Production thinking
- ✅ Integration skills

**Certification:**
🎓 **KERNEL SHADOWS — Season 1 Complete**

---

<div align="center">

**OPERATION KERNEL SHADOWS**
*Season 1 — Integration Project*

*"Ты видел тени. Ты понял shell. Ты готов к Season 2."* — LILITH

**Version:** v0.1.6
**Status:** Season 1 Complete

[⬆ К началу](#season-1-integration-project)

</div>


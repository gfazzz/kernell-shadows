# Episode 04: Package Management

```
ОПЕРАЦИЯ: KERNEL SHADOWS
СЕЗОН: 1 — Shell & Foundations
ЭПИЗОД: 04 — Package Management
ЛОКАЦИЯ: 🇷🇺 Новосибирск, Россия (Академгородок)
ДНИ ОПЕРАЦИИ: 7-8 (из 60)
СЛОЖНОСТЬ: ⭐☆☆☆☆
ВРЕМЯ: 2-3 часа
```

---

## 🎬 BRIEFING: Инструменты войны

### 📅 День 7 (07 октября 2025): Новое задание

**Время:** 10:00
**Локация:** Квартира Макса, Академгородок
**Участники:** Макс Соколов (вы), Виктор Петров (видеозвонок), LILITH

Утро. Кофе. Снег за окном. Домашний сервер гудит в углу.

Видеозвонок от Виктора:

**Виктор Петров (видео):**
> *"Макс, хорошая работа с логами. Ты нашёл Tor exit node за 4 часа. Анна впечатлена."*

На экране появляется документ.

> *"Теперь настоящая работа. Вот список инструментов для операции. Nmap, tcpdump, fail2ban, Docker... 15+ пакетов. Нам нужно всё это на 50 серверах. Завтра."*

**Макс:**
> *"50 серверов? Вручную это займёт недели."*

**Виктор:**
> *"Поэтому ты автоматизируешь. Скрипт. Один запуск — всё установлено. Без ошибок. Без конфликтов. Отправлю список на email."*

**LILITH (терминал мигает):**
> *"Ah, package management. Где 'dependency hell' встречается с 'it worked on my machine'. Готовься к боли, Макс."*

**Виктор:**
> *"У тебя до конца дня. Начни с тестового сервера. Когда скрипт будет готов — я дам доступ к остальным. Не подведи."*

Звонок обрывается.

---

### 10:30 — Email от Виктора

Макс открывает почту. Вложение: `required_tools.txt`

```
# OPERATION KERNEL SHADOWS
# Required Tools for Infrastructure
# Viktor Petrov, 07 Oct 2025

# Security & Networking
nmap
tcpdump
wireshark
fail2ban
ufw

# Docker
docker.io
docker-compose

# Monitoring
htop
iotop
nethogs

... (15+ tools total)
```

**LILITH:**
> *"Package managers. Твои новые лучшие друзья и худшие враги. APT для Ubuntu, DPKG под капотом, Snap для современных пакетов. Каждый со своими причудами."*

> *"Dependencies как семья. Не выбираешь их, но приходится с ними жить."*

> *"У тебя до конца дня. Начинай. Я буду наблюдать."*

**Атмосфера:** Тишина квартиры. Гудение сервера. Снег за окном тяжелеет. Макс открывает терминал.

---

## 🎯 МИССИЯ

### Основная задача:
Создать автоматизированный скрипт `install_toolkit.sh` для установки security & networking инструментов на Ubuntu серверах.

### Требования:
1. ✅ Читать список пакетов из `required_tools.txt`
2. ✅ Автоматически устанавливать все пакеты через APT
3. ✅ Логировать весь процесс установки
4. ✅ Создавать backup `/etc/apt/sources.list` перед изменениями
5. ✅ Генерировать отчёт об установке (успешные, пропущенные, failed)
6. ✅ Проверять права root (sudo)
7. ✅ Обрабатывать ошибки (dependency conflicts, missing packages)
8. ✅ Проверять работоспособность установленных пакетов

### Критерии успеха:
- Скрипт работает без ручного вмешательства (non-interactive)
- Создаёт детальный лог всех действий
- Генерирует читаемый отчёт для Viktor
- Обрабатывает ошибки gracefully (не падает при первой проблеме)

---

## 📚 ЗАДАНИЯ (Learn by Doing)

### ЗАДАНИЕ 1: Знакомство с APT

**LILITH:**
> *"Начнём с основ. APT (Advanced Package Tool) — твой главный инструмент. Это high-level интерфейс над dpkg."*

**Попробуйте:**

```bash
# 1. Обновить списки пакетов (всегда первый шаг!)
sudo apt update

# 2. Посмотреть доступные обновления
apt list --upgradable

# 3. Поиск пакета
apt search nmap

# 4. Информация о пакете
apt show nmap

# 5. Установить пакет
sudo apt install -y nmap
# Флаг -y: автоматическое "yes" на все вопросы

# 6. Проверить установку
which nmap
nmap --version
```

**LILITH:**
> *"apt update — это как 'обновить адресную книгу'. apt install — 'позвони и закажи доставку'. Просто, пока не встретишь dependency hell."*

<details>
<summary>📖 Теория: APT vs DPKG</summary>

### APT (Advanced Package Tool)

**High-level интерфейс:**
- Автоматически разрешает зависимости
- Скачивает пакеты из репозиториев
- Обновляет систему
- Удобен для пользователей

**Основные команды:**
```bash
apt update              # Обновить списки пакетов
apt upgrade             # Обновить все установленные пакеты
apt full-upgrade        # Обновить + удалить конфликтующие

apt install <package>   # Установить пакет
apt remove <package>    # Удалить пакет (оставить конфиги)
apt purge <package>     # Удалить пакет + конфиги
apt autoremove          # Удалить неиспользуемые зависимости

apt search <keyword>    # Поиск пакета
apt show <package>      # Информация о пакете
apt list --installed    # Список установленных пакетов
```

### DPKG (Debian Package Manager)

**Low-level инструмент:**
- Работает с .deb файлами напрямую
- НЕ разрешает зависимости автоматически
- Используется APT под капотом

**Основные команды:**
```bash
dpkg -i package.deb     # Установить .deb файл
dpkg -r package         # Удалить пакет
dpkg -l                 # Список всех пакетов
dpkg -l | grep package  # Найти пакет
dpkg -L package         # Список файлов пакета
dpkg -S /path/to/file   # Какой пакет установил этот файл
```

### Когда использовать что?

**APT:** 99% случаев (автоматизация, зависимости)
**DPKG:** Когда нужно установить локальный .deb файл или проверить детали

</details>

**Вопрос для проверки:**
Какая разница между `apt remove` и `apt purge`?

<details>
<summary>Ответ</summary>

- `apt remove` — удаляет пакет, но оставляет конфигурационные файлы (в `/etc/`)
- `apt purge` — удаляет пакет И все конфигурационные файлы

Пример: если удалить `apache2` через `remove`, файлы в `/etc/apache2/` останутся.

</details>

---

### ЗАДАНИЕ 2: Репозитории и sources.list

**LILITH:**
> *"Пакеты живут в репозиториях. Ubuntu знает, где искать, через /etc/apt/sources.list. Изменяй его с умом — можно сломать систему."*

**Попробуйте:**

```bash
# 1. Посмотреть текущие репозитории
cat /etc/apt/sources.list

# 2. Backup (ВСЕГДА делай backup!)
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

# 3. Посмотреть дополнительные репозитории
ls /etc/apt/sources.list.d/

# 4. Добавить репозиторий вручную (пример: Docker)
# НЕ ЗАПУСКАЙТЕ ПОКА, это только пример!
# echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
```

**LILITH:**
> *"Сторонние репозитории — как незнакомцы в интернете. Некоторые надёжные (Docker, MongoDB), некоторые — вирусы. Проверяй GPG ключи. Всегда."*

<details>
<summary>📖 Теория: Репозитории Ubuntu</summary>

### Структура sources.list

```
deb http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse
│   │                                  │      │
│   │                                  │      └─ Компоненты
│   │                                  └─ Кодовое имя релиза (jammy = 22.04)
│   └─ URL репозитория
└─ Тип (deb = бинарные пакеты, deb-src = исходники)
```

### Компоненты Ubuntu:

- **main** — Официально поддерживаемое free/open-source ПО
- **restricted** — Проприетарные драйверы (NVIDIA, etc)
- **universe** — Community-maintained free/open-source
- **multiverse** — ПО с ограничениями (патенты, лицензии)

### Безопасное добавление репозитория:

```bash
# 1. Добавить GPG ключ (подтверждение подлинности)
curl -fsSL https://example.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/example-keyring.gpg

# 2. Добавить репозиторий с привязкой к ключу
echo "deb [signed-by=/usr/share/keyrings/example-keyring.gpg] https://example.com/repo $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/example.list

# 3. Обновить списки
sudo apt update
```

### PPA (Personal Package Archives)

Удобный способ для Launchpad репозиториев:

```bash
# Добавить PPA
sudo add-apt-repository ppa:user/ppa-name

# Удалить PPA
sudo add-apt-repository --remove ppa:user/ppa-name
```

**Безопасность:** Используйте только проверенные PPAs!

</details>

---

### ЗАДАНИЕ 3: Проверка установленных пакетов

**LILITH:**
> *"Перед установкой проверь, что уже есть. Не переустанавливай без причины."*

**Попробуйте:**

```bash
# 1. Список всех установленных пакетов
dpkg -l

# 2. Поиск конкретного пакета
dpkg -l | grep nmap

# 3. Статус пакета (через dpkg-query)
dpkg-query -W -f='${Status}\n' nmap

# 4. Проверка через APT
apt list --installed | grep nmap

# 5. Версия пакета
dpkg -l nmap | grep ^ii | awk '{print $3}'
```

**Задача:** Напишите команду, которая проверяет, установлен ли `git`, и выводит "YES" или "NO".

<details>
<summary>Решение</summary>

```bash
if dpkg -l | grep -q "^ii  git "; then
    echo "YES"
else
    echo "NO"
fi
```

Или более короткий вариант:
```bash
dpkg -l | grep -q "^ii  git " && echo "YES" || echo "NO"
```

**Объяснение:**
- `dpkg -l` — список пакетов
- `^ii  git ` — regex для установленного пакета git
- `-q` — quiet mode (не выводить найденные строки)
- `&&` — если успешно (exit code 0), выполнить следующую команду
- `||` — если неуспешно (exit code 1), выполнить эту команду

</details>

---

### ЗАДАНИЕ 4: Парсинг списка инструментов

**LILITH:**
> *"Смотри на required_tools.txt. Там комментарии, пустые строки, мусор. Твоя задача — извлечь только названия пакетов."*

**Откройте файл:**

```bash
cd /home/fazzz/kernel-shadows/season-1-shell-foundations/episode-04-package-management/
cat artifacts/required_tools.txt
```

**Задача:** Написать команду, которая извлекает только названия пакетов (без комментариев и пустых строк).

**Подсказки:**
- `grep -v '^#'` — исключить строки, начинающиеся с #
- `grep -v '^$'` — исключить пустые строки
- `awk '{print $1}'` — взять первое слово

<details>
<summary>Решение</summary>

```bash
grep -v '^#' artifacts/required_tools.txt | \
grep -v '^$' | \
awk '{print $1}' | \
grep -v '^$'
```

**Объяснение:**
1. `grep -v '^#'` — убрать комментарии
2. `grep -v '^$'` — убрать пустые строки
3. `awk '{print $1}'` — взять первое слово (название пакета до пробела/комментария)
4. `grep -v '^$'` — убрать возможные пустые строки после awk

**Результат:**
```
nmap
netcat
tcpdump
wireshark
fail2ban
ufw
...
```

**Сохранить в переменную:**
```bash
tools=$(grep -v '^#' artifacts/required_tools.txt | grep -v '^$' | awk '{print $1}' | grep -v '^$')
echo "$tools"
```

</details>

---

### ЗАДАНИЕ 5: Автоматическая установка

**LILITH:**
> *"Теперь установи пакеты автоматически. Non-interactive. Как на production."*

**Попробуйте (на тестовой системе):**

```bash
# Тестовый список (безопасные пакеты)
echo "htop" > /tmp/test_packages.txt
echo "curl" >> /tmp/test_packages.txt
echo "wget" >> /tmp/test_packages.txt

# Цикл установки
while IFS= read -r package; do
    echo "Installing: $package"
    sudo apt install -y "$package"

    if [[ $? -eq 0 ]]; then
        echo "  ✓ Success: $package"
    else
        echo "  ✗ Failed: $package"
    fi
done < /tmp/test_packages.txt
```

**LILITH:**
> *"DEBIAN_FRONTEND=noninteractive отключает интерактивные вопросы. Используй в production скриптах."*

```bash
DEBIAN_FRONTEND=noninteractive sudo apt install -y package_name
```

<details>
<summary>📖 Теория: Non-Interactive Installation</summary>

### Проблема: Интерактивные вопросы

При установке некоторых пакетов APT может задавать вопросы:
- "Do you want to continue? [Y/n]"
- "Configuration file changed. What do you want to do?"
- "Restart services during package upgrades?"

В автоматизированных скриптах это **недопустимо** — скрипт зависнет.

### Решение 1: Флаг -y

```bash
sudo apt install -y package_name
```

Автоматически отвечает "yes" на вопрос "Do you want to continue?"

### Решение 2: DEBIAN_FRONTEND=noninteractive

```bash
DEBIAN_FRONTEND=noninteractive sudo apt install -y package_name
```

Отключает **все** интерактивные вопросы. Использует значения по умолчанию.

### Решение 3: apt-get с дополнительными флагами

```bash
sudo apt-get install -y -qq package_name
```

- `-y`: автоматическое "yes"
- `-qq`: quiet mode (минимум вывода)

### Решение 4: Preseed конфигурация

Для сложных случаев (например, установка MySQL с паролями):

```bash
echo "mysql-server mysql-server/root_password password your_password" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password your_password" | sudo debconf-set-selections
sudo apt install -y mysql-server
```

### Best Practice для автоматизации:

```bash
#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq package_name
```

</details>

---

### ЗАДАНИЕ 6: Логирование установки

**LILITH:**
> *"Логи — твой чёрный ящик. Когда Viktor спросит 'что пошло не так?', у тебя должен быть ответ."*

**Попробуйте:**

```bash
# Простое логирование
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Installing nmap" >> install.log
sudo apt install -y nmap >> install.log 2>&1

# Логирование с выводом на экран (tee)
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Installing git" | tee -a install.log
sudo apt install -y git 2>&1 | tee -a install.log
```

**Функция для логирования:**

```bash
log_message() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | tee -a install.log
}

log_message "Starting installation..."
log_message "Installing nmap..."
```

<details>
<summary>📖 Теория: Логирование в Bash</summary>

### Перенаправление вывода

```bash
command > file            # Перенаправить stdout в файл (перезапись)
command >> file           # Перенаправить stdout в файл (append)
command 2> file           # Перенаправить stderr в файл
command 2>&1 > file       # Перенаправить stderr и stdout
command &> file           # Короткая запись для stderr + stdout
```

### tee — вывод и в файл, и на экран

```bash
command | tee file        # Stdout → экран + файл
command | tee -a file     # Append вместо перезаписи
command 2>&1 | tee file   # stderr + stdout → экран + файл
```

### Timestamp в логах

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Message"
# Output: [2025-10-05 14:23:45] Message
```

### Функция для логирования

```bash
LOG_FILE="install.log"

log_message() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" | tee -a "$LOG_FILE"
}

# Использование
log_message "Installation started"
log_message "Installing package: nmap"
```

### Цветной вывод (опционально)

```bash
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_RESET="\033[0m"

echo -e "${COLOR_GREEN}Success!${COLOR_RESET}"
echo -e "${COLOR_RED}Error!${COLOR_RESET}"
```

**Примечание:** Цветные коды не сохраняются в лог-файлы (они отображаются как escape последовательности). Используйте их только для терминала.

</details>

---

### ЗАДАНИЕ 7: Обработка ошибок

**LILITH:**
> *"Dependency conflicts. Package not found. Permission denied. Disk full. Ошибки неизбежны. Твоя задача — не падать."*

**Попробуйте:**

```bash
# Попытка установить несуществующий пакет
sudo apt install -y nonexistent_package_12345

# Проверка exit code
if [[ $? -ne 0 ]]; then
    echo "Installation failed!"
fi
```

**Функция с обработкой ошибок:**

```bash
install_package() {
    local package="$1"

    echo "Installing: $package"

    if sudo apt install -y "$package" >> install.log 2>&1; then
        echo "  ✓ Success: $package"
        return 0
    else
        echo "  ✗ Failed: $package (check install.log)"
        return 1
    fi
}

# Использование
install_package "nmap" && echo "OK" || echo "FAILED, but continuing..."
```

<details>
<summary>📖 Теория: Exit Codes и обработка ошибок</summary>

### Exit Codes

Каждая команда в Linux возвращает exit code:
- `0` — успешно
- `1-255` — ошибка

Проверка через `$?`:

```bash
command
if [[ $? -eq 0 ]]; then
    echo "Success"
else
    echo "Failed"
fi
```

### set -e (Exit on Error)

```bash
#!/bin/bash
set -e  # Остановить скрипт при первой ошибке

apt update
apt install -y nmap  # Если failed — скрипт остановится
echo "This will not run if apt install failed"
```

**Проблема:** Иногда вы НЕ хотите останавливаться (например, если один пакет failed, продолжить с остальными).

### set +e (Отключить exit on error)

```bash
#!/bin/bash
set -e  # Включено по умолчанию

set +e  # Временно отключить
apt install -y maybe_failing_package
set -e  # Включить обратно
```

### Обработка ошибок без set -e

```bash
if apt install -y package; then
    echo "Success"
else
    echo "Failed, but continuing"
fi
```

### || оператор (OR)

```bash
command || echo "Failed!"
# Если command вернул non-zero, выполнить echo
```

### && оператор (AND)

```bash
command && echo "Success!"
# Если command вернул 0, выполнить echo
```

### Комбинация:

```bash
apt install -y nmap && echo "✓ nmap" || echo "✗ nmap failed"
```

### Exit codes для apt/dpkg:

- `0` — успех
- `100` — пакет не найден
- `1` — общая ошибка
- `2` — неверные аргументы

Проверка конкретного кода:

```bash
apt install -y nonexistent_package
exit_code=$?

if [[ $exit_code -eq 100 ]]; then
    echo "Package not found"
elif [[ $exit_code -eq 1 ]]; then
    echo "General error"
fi
```

</details>

---

### ЗАДАНИЕ 8: Генерация отчёта

**LILITH:**
> *"Viktor не будет читать 10,000 строк логов. Сделай ему TL;DR: что установлено, что failed, статистика."*

**Попробуйте создать простой отчёт:**

```bash
cat > install_report.txt << 'EOF'
========================================
KERNEL SHADOWS - Installation Report
========================================

Date: $(date '+%Y-%m-%d %H:%M:%S')

--- INSTALLED PACKAGES ---
✓ nmap (version 7.92)
✓ git (version 2.34.1)
✓ htop (version 3.2.0)

--- FAILED PACKAGES ---
✗ nonexistent_package (not found)

--- SUMMARY ---
Total: 4
Installed: 3
Failed: 1

Status: PARTIAL SUCCESS
========================================
EOF
```

**Автоматизированная генерация:**

```bash
generate_report() {
    {
        echo "========================================"
        echo "KERNEL SHADOWS - Installation Report"
        echo "========================================"
        echo ""
        echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
        echo ""

        echo "--- INSTALLED PACKAGES ---"
        for pkg in "${INSTALLED_PACKAGES[@]}"; do
            echo "  ✓ $pkg"
        done
        echo ""

        echo "--- FAILED PACKAGES ---"
        for pkg in "${FAILED_PACKAGES[@]}"; do
            echo "  ✗ $pkg"
        done
        echo ""

        echo "--- SUMMARY ---"
        echo "  Installed: ${#INSTALLED_PACKAGES[@]}"
        echo "  Failed: ${#FAILED_PACKAGES[@]}"
        echo ""
        echo "========================================"

    } > install_report.txt
}
```

---

### ЗАДАНИЕ 9: Финальный проект — install_toolkit.sh

**LILITH:**
> *"Всё вместе. Скрипт, который Viktor может запустить одной командой и получить working инфраструктуру."*

**Требования к скрипту:**

1. ✅ Shebang `#!/bin/bash`
2. ✅ Строгий режим: `set -e`, `set -u`, `set -o pipefail`
3. ✅ Функции:
   - `check_root()` — проверка sudo
   - `backup_sources_list()` — backup перед изменениями
   - `update_package_lists()` — `apt update`
   - `parse_tools_list()` — парсинг required_tools.txt
   - `install_package()` — установка с обработкой ошибок
   - `generate_report()` — создание отчёта
   - `log_message()` — логирование с timestamp
4. ✅ Массивы для отслеживания:
   - `INSTALLED_PACKAGES`
   - `FAILED_PACKAGES`
   - `SKIPPED_PACKAGES` (если уже установлены)
5. ✅ Файлы:
   - `install.log` — детальный лог
   - `install_report.txt` — краткий отчёт для Viktor

**Начните со starter.sh:**

```bash
cp starter.sh install_toolkit.sh
chmod +x install_toolkit.sh
nano install_toolkit.sh  # или vim/code
```

**Заполните TODO комментарии один за другим.**

**Тестирование (БЕЗ sudo сначала):**

```bash
# Проверка структуры
bash -n install_toolkit.sh  # Синтаксис OK?

# Проверка функций (dry run)
bash install_toolkit.sh  # Должна вывестись ошибка "need root"
```

**Тестирование (с sudo, на тестовом списке):**

```bash
# Создайте минимальный test_tools.txt
echo "htop" > test_tools.txt
echo "curl" >> test_tools.txt

# Запустите скрипт
sudo ./install_toolkit.sh test_tools.txt

# Проверьте результаты
cat install_report.txt
cat install.log
```

**Когда готовы — полный тест:**

```bash
sudo ./install_toolkit.sh artifacts/required_tools.txt
```

---

## 🧪 ТЕСТИРОВАНИЕ

### Автоматические тесты

```bash
cd tests/
chmod +x test.sh
./test.sh
```

**Тесты проверяют:**
1. ✅ Структуру скрипта (shebang, функции, переменные)
2. ✅ Парсинг required_tools.txt
3. ✅ Проверку root
4. ✅ Логирование
5. ✅ Генерацию отчёта
6. ✅ (Если root) Реальную установку

### Ручное тестирование

```bash
# 1. Проверка без root (должна выдать ошибку)
./install_toolkit.sh artifacts/required_tools.txt

# 2. Проверка парсинга
grep -v '^#' artifacts/required_tools.txt | grep -v '^$' | awk '{print $1}'

# 3. Проверка с sudo (на тестовом списке)
sudo ./install_toolkit.sh test_tools.txt

# 4. Проверка отчёта
cat install_report.txt

# 5. Проверка логов
less install.log

# 6. Проверка установленных пакетов
dpkg -l | grep nmap
which nmap
nmap --version
```

---

## 📖 ТЕОРИЯ: Package Management Deep Dive

<details>
<summary>🔍 Dependency Resolution</summary>

### Как APT разрешает зависимости

Когда вы устанавливаете пакет, APT:

1. Читает metadata пакета (зависимости из `Depends:`, `Recommends:`, `Suggests:`)
2. Проверяет, установлены ли зависимости
3. Если нет — добавляет их в очередь установки
4. Рекурсивно проверяет зависимости зависимостей
5. Скачивает все пакеты
6. Устанавливает в правильном порядке

### Dependency Hell

**Проблема:** Пакет A требует libfoo >= 2.0, пакет B требует libfoo < 2.0.

**Решение APT:**
- Попытка найти компромиссную версию
- Если невозможно — откажет в установке

**Ручное решение:**
```bash
# Проверить зависимости
apt-cache depends package_name

# Попытаться исправить
sudo apt --fix-broken install

# Если не помогает — удалить конфликтующий пакет
sudo apt remove conflicting_package
```

### Виртуальные пакеты

Некоторые зависимости — "виртуальные":
- `mail-transport-agent` (может быть `postfix`, `exim4`, `sendmail`)
- `www-browser` (может быть `firefox`, `chromium`)

Любой пакет, предоставляющий виртуальный пакет, удовлетворяет зависимость.

</details>

<details>
<summary>🔍 Snap Packages</summary>

### Что такое Snap?

**Современная альтернатива APT:**
- Самодостаточные пакеты (bundled dependencies)
- Автоматические обновления
- Изолированное окружение (sandboxing)
- Crossplatform (Ubuntu, Debian, Fedora, Arch)

### Основные команды:

```bash
snap install package_name     # Установить
snap list                      # Список установленных
snap refresh package_name      # Обновить
snap remove package_name       # Удалить
snap info package_name         # Информация
snap find keyword              # Поиск
```

### Snap vs APT

| Критерий | APT | Snap |
|----------|-----|------|
| Зависимости | Общие библиотеки | Bundled |
| Размер пакета | Меньше | Больше |
| Безопасность | Менее изолировано | Sandboxed |
| Обновления | Ручные/автоматические | Автоматические |
| Скорость установки | Быстрее | Медленнее |

### Когда использовать Snap?

- Нужна последняя версия (APT часто содержит устаревшие пакеты)
- Нужна изоляция (безопасность)
- Crossplatform (один пакет для всех дистрибутивов)

### Пример: Docker через Snap

```bash
# Snap (проще, но может быть медленнее)
sudo snap install docker

# APT (сложнее, но production-ready)
# (см. artifacts/README.md для полной инструкции)
```

</details>

<details>
<summary>🔍 Docker Installation (Special Case)</summary>

### Почему Docker особенный?

Docker не в стандартных репозиториях Ubuntu. Нужно добавить официальный репозиторий Docker.

### Полная процедура:

```bash
# 1. Удалить старые версии (если есть)
sudo apt remove docker docker-engine docker.io containerd runc

# 2. Установить зависимости
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 3. Добавить GPG ключ Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 4. Добавить репозиторий
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Обновить списки
sudo apt update

# 6. Установить Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 7. Проверить
sudo docker run hello-world
```

### Автоматизация в скрипте

Можно добавить функцию `install_docker()` в ваш `install_toolkit.sh`:

```bash
install_docker() {
    log_message "Installing Docker (requires custom repo)..."

    # Add Docker GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Add Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update and install
    apt update >> "$LOG_FILE" 2>&1
    apt install -y docker-ce docker-ce-cli containerd.io >> "$LOG_FILE" 2>&1

    if [[ $? -eq 0 ]]; then
        log_message "✓ Docker installed"
        INSTALLED_PACKAGES+=("docker-ce")
    else
        log_message "✗ Docker failed"
        FAILED_PACKAGES+=("docker-ce")
    fi
}
```

</details>

---

## 💡 СПРАВОЧНИК: APT Commands

### Основные команды

```bash
# === ОБНОВЛЕНИЕ ===
sudo apt update                    # Обновить списки пакетов
sudo apt upgrade                   # Обновить все пакеты (безопасно)
sudo apt full-upgrade              # Обновить + удалить конфликты
sudo apt dist-upgrade              # То же, что full-upgrade

# === УСТАНОВКА ===
sudo apt install package           # Установить пакет
sudo apt install package1 package2 # Установить несколько
sudo apt install -y package        # Без подтверждения
sudo apt install --no-install-recommends package  # Без рекомендованных
sudo apt reinstall package         # Переустановить

# === УДАЛЕНИЕ ===
sudo apt remove package            # Удалить (оставить конфиги)
sudo apt purge package             # Удалить + конфиги
sudo apt autoremove                # Удалить ненужные зависимости
sudo apt autoclean                 # Очистить кэш старых пакетов
sudo apt clean                     # Полностью очистить кэш

# === ПОИСК И ИНФОРМАЦИЯ ===
apt search keyword                 # Поиск пакета
apt show package                   # Детальная информация
apt list                           # Список всех пакетов
apt list --installed               # Только установленные
apt list --upgradable              # Доступные обновления
apt-cache depends package          # Зависимости
apt-cache rdepends package         # Обратные зависимости

# === РЕПОЗИТОРИИ ===
sudo add-apt-repository ppa:name   # Добавить PPA
sudo add-apt-repository --remove ppa:name  # Удалить PPA

# === TROUBLESHOOTING ===
sudo apt --fix-broken install      # Исправить сломанные зависимости
sudo apt --fix-missing install     # Установить недостающие пакеты
sudo dpkg --configure -a           # Настроить незавершённые установки
```

### DPKG Commands

```bash
# === УСТАНОВКА ===
sudo dpkg -i package.deb           # Установить .deb файл
sudo dpkg -r package               # Удалить пакет
sudo dpkg -P package               # Удалить + конфиги (Purge)

# === ИНФОРМАЦИЯ ===
dpkg -l                            # Список всех пакетов
dpkg -l | grep package             # Поиск пакета
dpkg -L package                    # Список файлов пакета
dpkg -S /path/to/file              # Какой пакет установил файл
dpkg -s package                    # Статус пакета
dpkg-query -W -f='${Status}' package  # Короткий статус

# === TROUBLESHOOTING ===
sudo dpkg --configure -a           # Завершить незавершённые установки
sudo dpkg --force-all -i package.deb  # Принудительная установка (ОПАСНО!)
```

---

## 🎓 БОНУС: Best Practices

### 1. Всегда делайте backup

```bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%Y%m%d)
```

### 2. apt update перед apt install

```bash
sudo apt update && sudo apt install -y package
```

### 3. Проверка перед установкой

```bash
if ! dpkg -l | grep -q "^ii  $package "; then
    sudo apt install -y "$package"
fi
```

### 4. Логирование всех изменений

```bash
sudo apt install -y package 2>&1 | tee -a /var/log/custom_installs.log
```

### 5. Non-interactive для автоматизации

```bash
DEBIAN_FRONTEND=noninteractive sudo apt install -y package
```

### 6. Проверка успешности

```bash
if sudo apt install -y package; then
    echo "Success"
else
    echo "Failed"
    exit 1
fi
```

### 7. Регулярные обновления

```bash
# Cron job: каждую субботу в 3:00
0 3 * * 6 apt update && apt upgrade -y >> /var/log/auto_upgrade.log 2>&1
```

### 8. Мониторинг безопасности

```bash
# Проверка обновлений безопасности
sudo apt list --upgradable | grep -i security

# Автоматическая установка security updates
sudo apt install unattended-upgrades
```

---

## 🎬 DEBRIEFING: Что вы изучили

После завершения Episode 04 вы освоили:

### Технические навыки:
- ✅ **APT** — установка, обновление, удаление пакетов
- ✅ **DPKG** — низкоуровневое управление .deb файлами
- ✅ **Репозитории** — добавление, удаление, GPG ключи
- ✅ **Зависимости** — понимание dependency resolution
- ✅ **Snap** — альтернативный package manager
- ✅ **Docker** — установка из стороннего репозитория
- ✅ **Автоматизация** — non-interactive installation
- ✅ **Логирование** — детальные логи установки
- ✅ **Отчёты** — генерация summary для операции
- ✅ **Обработка ошибок** — graceful handling

### Практические результаты:
- 🚀 **install_toolkit.sh** — production-ready скрипт для 50 серверов
- 📊 **install_report.txt** — отчёт для Viktor
- 📝 **install.log** — детальные логи
- 🛡️ **Backup** — sources.list сохранён

---

## 🎬 CLIFFHANGER: Конец Season 1, переход к Season 2

### 📅 День 8 (08 октября 2025): Результаты

**Время:** 18:00
**Локация:** Квартира Макса, Академгородок

Max отправляет отчёт Viktor. Все 15 пакетов установлены на тестовом сервере. `install_toolkit.sh` работает без ошибок.

Видеозвонок от Viktor:

**Виктор:**
> *"Отлично, Макс. Скрипт работает. Завтра запускаем на всех 50 серверах."*

Пауза.

> *"Хорошая работа за неделю. Ты справился с базовыми тестами. Но настоящая операция начинается сейчас."*

**Max:**
> *"Что дальше?"*

**Viktor:**
> *"Приезжай в Москву. Встретишься с командой. Настоящие серверы, настоящие угрозы. Билет уже куплен. Отправил на email."*

**Max:**
> *"Когда?"*

**Viktor:**
> *"Завтра утром. Рейс в 07:30. Не опоздай."*

Звонок обрывается.

---

### 20:00 — Пакуем вещи

Max собирает рюкзак. Ноутбук, зарядки, тёплая куртка (в Москве теплее, но не намного).

Прощальный взгляд на домашний сервер. Dell PowerEdge гудит в углу. Raspberry Pi мигают зелёными лампочками.

Max: *"Неделя назад я настраивал корпоративные серверы. Теперь... Москва. Viktor. Настоящая операция. Как я здесь оказался?"*

Телефон звонит. Alex Sokolov (двоюродный брат).

**Alex (голос напряжённый):**
> *"Макс, у нас проблема. Krylov знает о нас. Приезжай быстрее. Завтра встретимся в Москве. Будь осторожен."*

> *"И Макс... спасибо, что согласился. Знаю, это опасно. Но ты нужен нам."*

Звонок обрывается.

Max смотрит в окно. Снег падает. Сибирская ночь. Последняя ночь в Новосибирске (пока).

**LILITH (терминал мигает):**
> *"Season 1 завершён, Max. Ты прошёл основы: terminal, scripting, text processing, package management."*

> *"Но это была разминка. Новосибирск — comfort zone. Москва — враждебная территория. Krylov знает о вас."*

> *"Season 2: Networking, firewalls, VPN, SSH. И первая реальная угроза."*

> *"Welcome to the shadows, Max. Настоящие тени начинаются сейчас."*

Экран гаснет.

---

### 📅 День 9 (09 октября 2025, 07:30): Новосибирск → Москва

Аэропорт Толмачёво. Рейс S7 1201. Max садится в самолёт.

За окном — Новосибирск исчезает в облаках. Сибирь остаётся внизу.

Впереди — Москва. Команда Viktor. Alex. Anna. Dmitry.

И где-то в тенях — полковник Krylov.

**Season 1 завершён. Season 2 начинается.**

---

## 🌍 Следующая остановка: Season 2

**Локации:** 🇷🇺 Москва → 🇸🇪 Стокгольм, Швеция
**Тема:** Networking (TCP/IP, DNS, Firewalls, VPN, SSH)
**Дни операции:** 9-16 (из 60)
**Новые персонажи:**
- Alex Sokolov (лично) — security expert, ex-FSB
- Anna Kovaleva (лично) — forensics expert
- Erik Johansson (Стокгольм) — network engineer, Bahnhof
- Katarina Lindström (Стокгольм) — cryptography expert

**Новая угроза:** Полковник Krylov (ФСБ Управление "К")

**First Episode S2:** Episode 05 — TCP/IP Fundamentals (Москва, ЦОД "Москва-1")

**→ Continue: [Season 2 README](../../season-2-networking/README.md)** (в разработке)

---

## 📝 Чеклист завершения

Перед переходом к следующему эпизоду убедитесь:

- [ ] Создан рабочий `install_toolkit.sh`
- [ ] Скрипт успешно устанавливает пакеты из `required_tools.txt`
- [ ] Генерируется `install_report.txt`
- [ ] Создаётся детальный `install.log`
- [ ] Скрипт проверяет права root
- [ ] Создаётся backup `/etc/apt/sources.list`
- [ ] Обрабатываются ошибки (failed packages не останавливают скрипт)
- [ ] Все тесты пройдены (`./tests/test.sh`)
- [ ] Понимаете разницу между APT и DPKG
- [ ] Знаете, как добавлять репозитории безопасно

---

## 🔗 Ресурсы

### Официальная документация:
- Ubuntu Packages: https://packages.ubuntu.com/
- APT User's Guide: https://www.debian.org/doc/manuals/apt-guide/
- Docker Installation: https://docs.docker.com/engine/install/ubuntu/

### Man pages:
```bash
man apt
man apt-get
man dpkg
man sources.list
```

### Полезные инструменты:
- `aptitude` — альтернативный интерфейс для APT (TUI)
- `synaptic` — GUI для APT
- `apt-file` — поиск файлов в пакетах

---

<div align="center">

**KERNEL SHADOWS — Episode 04: Package Management**

*🇷🇺 Новосибирск, Россия (Академгородок) • Дни 7-8 из 60*

---

*"Dependencies как семья. Не выбираешь их, но приходится с ними жить."* — LILITH

---

**Season 1 завершён!** 🎉

**Пройдено:** Terminal, Scripting, Text Processing, Package Management
**Локация:** Новосибирск (Академгородок)
**Персонажи:** Viktor, LILITH, Sergey Ivanov, Olga Petrova, Dmitry Orlov

---

**Следующая остановка:**
**Season 2 → Москва 🇷🇺 → Стокгольм 🇸🇪**

*Путешествие продолжается...*

**[← Season 1 README](../README.md)** • **[Season 2 README →](../../season-2-networking/README.md)** (в разработке)

</div>


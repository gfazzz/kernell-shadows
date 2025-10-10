# EPISODE 09: USERS & PERMISSIONS
## Season 3: System Administration | Санкт-Петербург, Россия

> *"Root access как заряженный пистолет. Не давай его кому попало."* — Андрей Волков

---

## 📍 Контекст миссии

**Локация:** 🇷🇺 Санкт-Петербург, Россия
**Место:** ЛЭТИ (Ленинградский электротехнический институт), Васильевский остров
**День операции:** 17-18 из 60
**Время прохождения:** 4-5 часов
**Сложность:** ⭐⭐⭐☆☆

**Персонажи:**
- **Макс Соколов** — вы, растёте как sysadmin
- **Андрей Волков** — ex-профессор Unix (ЛЭТИ), ментор
- **Виктор Петров** — координатор операции
- **Алекс Соколов** — ваш двоюродный брат, ex-FSB, security expert
- **Анна Ковалева** — forensics expert, blue team lead
- **Дмитрий Орлов** — DevOps engineer
- **LILITH** — AI-помощник (я!)

---

## 🎬 Сюжет

### День 17. Санкт-Петербург. Белые ночи.

После успешного завершения Season 2 (VPN setup) Макс возвращается в Россию. Но не в Новосибирск, а в Санкт-Петербург.

**Виктор** (видеозвонок, 03:27 Moscow time):
*"Макс, у нас проблема. Серьёзная. Один из серверов скомпрометирован."*

**Анна** (screen share — forensics report):
*"Backdoor. `/usr/sbin/sshd_backup` — fake sshd процесс. Крылов проник через учётную запись с sudo правами. Проверь `/etc/passwd` — там учётка `devops` с UID 0. ROOT ACCESS."*

**Макс:** *"Как это возможно?!"*

**Алекс:** *"Permissions. Кто-то дал sudo кому не следует. Классическая ошибка. Едь в СПб — там есть человек, который научит тебя правильному администрированию."*

---

### 02:00. Санкт-Петербург. ЛЭТИ.

Белые ночи. На улице светло, хотя 2 часа ночи. Макс идёт по Васильевскому острову, канал Грибоедова за окнами старого здания ЛЭТИ. Встреча с **Андреем Волковым** в лаборатории Unix.

**Андрей** (седые волосы, очки, твидовый пиджак, чай в стеклянном стакане):
*"Максим. Виктор рассказал о проблеме. Permissions — это философия, а не просто команды. Principle of least privilege — слышал?"*

**Макс:** *"Нет..."*

**Андрей:**
*"Давай по порядку. Root access как заряженный пистолет. Не давай его кому попало. Это я студентам 20 лет говорю. Но каждый год кто-то всё равно даёт. И каждый год взламывают."*

**Виктор** (звонок):
*"Макс, на сервере будут работать 5 человек: я, ты, Алекс, Анна, Дмитрий. Каждому нужен свой уровень доступа. Алекс — только network команды. Анна — только чтение логов. Дмитрий — управление сервисами. Настрой это правильно."*

**Андрей:**
*"Хорошее упражнение. Начнём с основ. Потом sudo. Потом ACL. К утру справишься. Благо утро наступит не скоро."* (улыбается — белые ночи)

---

## 🎯 Твоя миссия

Настроить **безопасный доступ** для команды операции на сервер.

**Цель:**
Создать пользователей, группы, настроить permissions, sudo и ACL так, чтобы:
- Каждый имеет **только те права, которые нужны для работы**
- Алекс может выполнять network команды через sudo (но НЕ всё)
- Анна может читать логи, но НЕ изменять
- Shared папка доступна всей команде
- Крылов больше не сможет эксплуатировать misconfigured permissions

**Итог:** Security audit report для Виктора.

---

## 📝 Задания

### Задание 1: Инспекция текущих пользователей
**Цель:** Понять, кто сейчас на сервере

**Что нужно сделать:**
1. Посмотреть всех пользователей в системе
2. Проверить, кто имеет shell доступ
3. Найти подозрительные учётные записи
4. Проверить, кто имеет UID 0 (root privileges)

<details>
<summary>💡 Подсказка 1 (после 5 минут размышлений)</summary>

Пользователи хранятся в файле `/etc/passwd`. Формат:
```
username:x:UID:GID:comment:home:shell
```

Команды для проверки:
- `cat /etc/passwd` — все пользователи
- `getent passwd` — то же через NSS
- `awk -F: '{print $1}' /etc/passwd` — только имена

Shell доступ = `/bin/bash`, `/bin/sh` в последнем поле.
UID 0 = root privileges.

</details>

<details>
<summary>💡 Подсказка 2 (после 10 минут)</summary>

Команда для поиска пользователей с shell доступом:
```bash
grep -E '/bin/(bash|sh)$' /etc/passwd
```

Для поиска UID 0 (кроме root):
```bash
awk -F: '$3 == 0 && $1 != "root" {print $1}' /etc/passwd
```

Также проверь `/etc/shadow` (пароли):
```bash
sudo cat /etc/shadow
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

echo "=== Инспекция пользователей ==="

# Все пользователи с shell доступом
echo "Пользователи с shell доступом:"
grep -E '/bin/(bash|sh)$' /etc/passwd

# Подозрительные UID 0 (кроме root)
echo -e "\n⚠️  Пользователи с UID 0 (кроме root):"
awk -F: '$3 == 0 && $1 != "root" {print $1}' /etc/passwd

# Locked/unlocked accounts
echo -e "\nЗаблокированные учётные записи:"
sudo awk -F: '$2 ~ /^!/ {print $1}' /etc/shadow
```

**Что должны найти:**
Если есть бэкдор, там будет учётка типа `devops` или `backup` с UID 0.

</details>

**Andrei:** *"Всегда начинай с инспекции. Krylov любит оставлять backdoor accounts."*

---

### Задание 2: Создание пользователей для команды
**Цель:** Создать учётные записи для Viktor, Alex, Anna, Dmitry

**Требования:**
- Usernames: `viktor`, `alex`, `anna`, `dmitry`
- Home directories: `/home/username`
- Shell: `/bin/bash`
- Пароли: временные (нужно сменить при первом входе)

<details>
<summary>💡 Подсказка 1</summary>

Команда для создания пользователя:
```bash
sudo useradd -m -s /bin/bash username
```

Флаги:
- `-m` — создать home directory
- `-s /bin/bash` — установить shell

Для установки пароля:
```bash
sudo passwd username
```

Для принудительной смены пароля при первом входе:
```bash
sudo chage -d 0 username
```

</details>

<details>
<summary>💡 Подсказка 2</summary>

Можно автоматизировать через цикл:
```bash
users=("viktor" "alex" "anna" "dmitry")

for user in "${users[@]}"; do
    sudo useradd -m -s /bin/bash "$user"
    echo "password123" | sudo passwd --stdin "$user"  # или chpasswd
    sudo chage -d 0 "$user"  # force password change
done
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

create_team_users() {
    local users=("viktor" "alex" "anna" "dmitry")

    for user in "${users[@]}"; do
        if id "$user" &>/dev/null; then
            echo "⚠️  User $user already exists, skipping..."
            continue
        fi

        echo "Creating user: $user"
        sudo useradd -m -s /bin/bash "$user"

        # Temporary password (change on first login)
        echo "$user:TempPass123!" | sudo chpasswd
        sudo chage -d 0 "$user"

        echo "✓ User $user created"
    done
}

create_team_users
```

</details>

**Andrei:** *"Никогда не оставляй default passwords. Всегда принудительная смена при первом входе."*

---

### Задание 3: Создание групп
**Цель:** Организовать пользователей по группам в соответствии с ролями

**Группы:**
- `operations` — general operations (Viktor, Max, Dmitry)
- `security` — security team (Alex, Anna)
- `forensics` — forensics access (Anna)
- `devops` — DevOps team (Dmitry)
- `netadmin` — network administrators (Alex)

**Что сделать:**
1. Создать группы
2. Добавить пользователей в соответствующие группы
3. Проверить membership

<details>
<summary>💡 Подсказка 1</summary>

Создание группы:
```bash
sudo groupadd groupname
```

Добавление пользователя в группу:
```bash
sudo usermod -aG groupname username
```

Флаг `-a` (append) важен! Без него затрёт существующие группы.

Проверка групп пользователя:
```bash
groups username
id username
```

</details>

<details>
<summary>💡 Подсказка 2</summary>

Автоматизация через ассоциативный массив:
```bash
declare -A group_members
group_members["operations"]="viktor dmitry"
group_members["security"]="alex anna"
group_members["forensics"]="anna"
group_members["devops"]="dmitry"
group_members["netadmin"]="alex"

for group in "${!group_members[@]}"; do
    sudo groupadd "$group" 2>/dev/null || true
    for user in ${group_members[$group]}; do
        sudo usermod -aG "$group" "$user"
    done
done
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

create_groups() {
    # Define groups and members
    declare -A groups
    groups["operations"]="viktor dmitry"
    groups["security"]="alex anna"
    groups["forensics"]="anna"
    groups["devops"]="dmitry"
    groups["netadmin"]="alex"

    for group_name in "${!groups[@]}"; do
        # Create group if doesn't exist
        if ! getent group "$group_name" &>/dev/null; then
            sudo groupadd "$group_name"
            echo "✓ Group $group_name created"
        fi

        # Add members
        for user in ${groups[$group_name]}; do
            sudo usermod -aG "$group_name" "$user"
            echo "  ✓ Added $user to $group_name"
        done
    done
}

create_groups

# Verification
echo -e "\n=== Group Membership Verification ==="
for user in viktor alex anna dmitry; do
    echo "$user: $(groups $user)"
done
```

</details>

**Andrei:** *"Группы — это организация. Не давай permissions отдельным пользователям. Используй группы."*

---

### Задание 4: Настройка shared directory с permissions
**Цель:** Создать `/var/operations/shared` для совместной работы команды

**Требования:**
- Владелец: `viktor:operations`
- Permissions: group members могут читать/писать, но НЕ удалять чужие файлы
- Sticky bit для защиты файлов
- Новые файлы наследуют group ownership

<details>
<summary>💡 Подсказка 1</summary>

Permissions в Linux: `rwxrwxrwx` (user, group, others)

Для shared directory нужны:
- User (viktor): `rwx` (7)
- Group (operations): `rwx` (7)
- Others: `---` (0)

Плюс **Sticky Bit** — только владелец файла может его удалить.

Команды:
```bash
sudo mkdir -p /var/operations/shared
sudo chown viktor:operations /var/operations/shared
sudo chmod 1770 /var/operations/shared  # 1 = sticky bit
```

SGID bit (2) — новые файлы наследуют group.

</details>

<details>
<summary>💡 Подсказка 2</summary>

Полная настройка shared directory:
```bash
# Create directory
sudo mkdir -p /var/operations/shared

# Set owner and group
sudo chown viktor:operations /var/operations/shared

# Set permissions: rwxrws--T
# 1 (sticky) + 2 (SGID) + 770
sudo chmod 3770 /var/operations/shared

# Verify
ls -ld /var/operations/shared
# Output: drwxrws--T ... viktor operations ... /var/operations/shared
```

Что означают буквы:
- `d` — directory
- `rwx` — owner (viktor) может всё
- `rws` — group (operations) может всё, `s` = SGID
- `--T` — others ничего не могут, `T` = sticky bit

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

setup_shared_directory() {
    local dir="/var/operations/shared"

    echo "Setting up shared directory: $dir"

    # Create directory
    sudo mkdir -p "$dir"

    # Set owner: viktor, group: operations
    sudo chown viktor:operations "$dir"

    # Permissions:
    # 1 = Sticky bit (only owner can delete own files)
    # 2 = SGID (new files inherit group)
    # 770 = rwx for user and group, nothing for others
    sudo chmod 3770 "$dir"

    # Verify
    echo -e "\n✓ Shared directory created:"
    ls -ld "$dir"

    # Expected: drwxrws--T ... viktor operations ... /var/operations/shared
}

setup_shared_directory
```

**Тестирование:**
```bash
# As viktor
sudo -u viktor touch /var/operations/shared/test.txt
ls -l /var/operations/shared/test.txt
# Output: -rw-r--r-- viktor operations ...

# As dmitry (member of operations)
sudo -u dmitry echo "test" > /var/operations/shared/test.txt  # OK
sudo -u dmitry rm /var/operations/shared/test.txt             # FAIL (sticky bit)
```

</details>

**Andrei:** *"Sticky bit — это цивилизованность. /tmp тоже использует это. Иначе хаос."*

---

### Задание 5: Настройка sudo для Alex (ограниченный доступ)
**Цель:** Alex должен иметь sudo для network команд, но НЕ для всего

**Требования:**
- Alex может выполнять: `ip`, `ss`, `netstat`, `tcpdump`, `iptables`, `ufw`
- БЕЗ пароля для этих команд (convenience для операции)
- НЕ может: `useradd`, `passwd`, `rm -rf /`

<details>
<summary>💡 Подсказка 1</summary>

Sudo конфигурация: `/etc/sudoers` (редактировать через `visudo`!)

Или создать файл в `/etc/sudoers.d/`:
```bash
sudo visudo -f /etc/sudoers.d/alex
```

Формат:
```
username HOST=(USER) NOPASSWD: command1, command2
```

Пример:
```
alex ALL=(root) NOPASSWD: /usr/sbin/ip, /usr/bin/ss, /usr/sbin/iptables
```

</details>

<details>
<summary>💡 Подсказка 2</summary>

Полная конфигурация для Alex:
```bash
# Create sudoers file for alex
sudo visudo -f /etc/sudoers.d/alex
```

Содержимое:
```
# Alex Sokolov - Network Administration Commands Only
# Created for KERNEL SHADOWS Operation

# Command aliases for organization
Cmnd_Alias NETCMDS = /usr/sbin/ip, /usr/bin/ss, /usr/bin/netstat, \
                      /usr/sbin/tcpdump, /usr/sbin/iptables, /usr/sbin/ufw

# Alex can run network commands without password
alex ALL=(root) NOPASSWD: NETCMDS
```

Проверка синтаксиса:
```bash
sudo visudo -c -f /etc/sudoers.d/alex
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

setup_sudo_alex() {
    local sudoers_file="/etc/sudoers.d/alex"

    echo "Configuring sudo for Alex (network commands only)..."

    # Create sudoers file
    sudo tee "$sudoers_file" > /dev/null << 'EOF'
# Alex Sokolov - Network Administration Commands
# Episode 09: Users & Permissions
# Principle of Least Privilege

# Network commands alias
Cmnd_Alias NETCMDS = /usr/sbin/ip, \
                      /usr/bin/ss, \
                      /usr/bin/netstat, \
                      /usr/sbin/tcpdump, \
                      /usr/sbin/iptables, \
                      /usr/sbin/ip6tables, \
                      /usr/sbin/ufw, \
                      /usr/bin/nmap

# Alex can run network commands as root without password
alex ALL=(root) NOPASSWD: NETCMDS

# Explicitly deny dangerous commands (defense in depth)
alex ALL=(root) !/usr/sbin/visudo, !/usr/bin/passwd root, !/bin/rm -rf
EOF

    # Set correct permissions
    sudo chmod 440 "$sudoers_file"

    # Validate syntax
    if sudo visudo -c -f "$sudoers_file"; then
        echo "✓ Sudo configured for Alex"
    else
        echo "❌ Syntax error in sudoers file!"
        sudo rm "$sudoers_file"
        return 1
    fi
}

setup_sudo_alex
```

**Тестирование:**
```bash
# As alex
sudo -u alex sudo ip addr show         # Should work
sudo -u alex sudo useradd test         # Should fail (not in NETCMDS)
```

</details>

**Andrei:** *"Sudo — это власть. Давай минимум, необходимый для работы. Это называется Principle of Least Privilege."*

---

### Задание 6: ACL для Anna (read-only логи)
**Цель:** Anna должна читать логи, но НЕ изменять их

**Требования:**
- Anna может читать `/var/log/auth.log`, `/var/log/syslog`
- НЕ может изменять или удалять
- Использовать ACL (Access Control Lists)

<details>
<summary>💡 Подсказка 1</summary>

ACL (Access Control Lists) — более гибкие права, чем стандартные `chmod`.

Команды:
- `setfacl` — установить ACL
- `getfacl` — посмотреть ACL

Установка read-only доступа для Anna:
```bash
sudo setfacl -m u:anna:r /var/log/auth.log
```

Флаги:
- `-m` — modify ACL
- `u:anna:r` — user anna, read permission

</details>

<details>
<summary>💡 Подсказка 2</summary>

Для директории с логами (чтобы Anna могла их листать):
```bash
# Anna нужен execute на /var/log (для доступа)
sudo setfacl -m u:anna:rx /var/log

# Read-only на конкретные логи
sudo setfacl -m u:anna:r /var/log/auth.log
sudo setfacl -m u:anna:r /var/log/syslog
```

Для всех файлов в директории (recursive):
```bash
sudo setfacl -R -m u:anna:r /var/log
```

Проверка:
```bash
getfacl /var/log/auth.log
# Output должен включать: user:anna:r--
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

setup_acl_anna() {
    echo "Configuring ACL for Anna (read-only log access)..."

    # Check if ACL is supported
    if ! command -v setfacl &>/dev/null; then
        echo "❌ ACL tools not installed. Installing..."
        sudo apt-get install -y acl
    fi

    # Anna needs execute permission on /var/log to access files
    sudo setfacl -m u:anna:rx /var/log

    # Read-only access to specific logs
    local logs=(
        "/var/log/auth.log"
        "/var/log/syslog"
        "/var/log/kern.log"
        "/var/log/apache2/access.log"
        "/var/log/apache2/error.log"
    )

    for log in "${logs[@]}"; do
        if [[ -f "$log" ]]; then
            sudo setfacl -m u:anna:r "$log"
            echo "✓ ACL set for $log"
        fi
    done

    # Also set default ACL for new files in /var/log
    sudo setfacl -d -m u:anna:r /var/log

    echo -e "\n✓ ACL configured for Anna"

    # Verification
    echo -e "\nVerification:"
    getfacl /var/log/auth.log 2>/dev/null | grep "user:anna"
}

setup_acl_anna
```

**Тестирование:**
```bash
# As anna
sudo -u anna cat /var/log/auth.log         # Should work
sudo -u anna echo "test" >> /var/log/auth.log  # Should fail (read-only)
```

</details>

**Andrei:** *"ACL — это когда chmod недостаточно. Anna forensics expert — ей нужны логи, но trust — verify."*

---

### Задание 7: Security Audit — поиск SUID/SGID файлов
**Цель:** Найти потенциально опасные файлы с SUID/SGID битами

**Что такое SUID/SGID:**
- **SUID** (Set User ID): файл выполняется с правами владельца (часто root)
- **SGID** (Set Group ID): файл выполняется с правами группы
- **Опасность:** если SUID файл имеет уязвимость → privilege escalation

**Задача:**
1. Найти все SUID файлы в системе
2. Найти все SGID файлы
3. Проверить, есть ли подозрительные (не стандартные)
4. Создать отчёт

<details>
<summary>💡 Подсказка 1</summary>

SUID файлы имеют permission bit `4` (в восьмеричной записи 4000).
SGID файлы имеют permission bit `2` (в восьмеричной записи 2000).

Поиск через `find`:
```bash
# SUID files
find / -perm -4000 -type f 2>/dev/null

# SGID files
find / -perm -2000 -type f 2>/dev/null
```

Флаги:
- `-perm -4000` — файлы с SUID битом
- `-type f` — только файлы (не директории)
- `2>/dev/null` — игнорировать ошибки (permission denied)

</details>

<details>
<summary>💡 Подсказка 2</summary>

Стандартные SUID файлы (безопасные):
- `/usr/bin/sudo`
- `/usr/bin/passwd`
- `/usr/bin/su`
- `/usr/bin/mount`
- `/usr/bin/ping`

Подозрительные:
- Файлы в `/tmp`, `/home`
- Скомпилированные исполняемые файлы неизвестного происхождения
- Shell scripts с SUID (НЕ работает в Linux, но suspicious)

Сравнение со baseline:
```bash
# Сохранить текущий список
find / -perm -4000 -type f 2>/dev/null > suid_files.txt

# Позже сравнить
find / -perm -4000 -type f 2>/dev/null | diff - suid_files.txt
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

security_audit_suid_sgid() {
    echo "=== Security Audit: SUID/SGID Files ==="
    echo "Date: $(date)"
    echo

    # Known safe SUID binaries (baseline)
    local safe_suid=(
        "/usr/bin/sudo"
        "/usr/bin/passwd"
        "/usr/bin/su"
        "/usr/bin/mount"
        "/usr/bin/umount"
        "/usr/bin/ping"
        "/usr/bin/chsh"
        "/usr/bin/chfn"
    )

    # Find all SUID files
    echo "Searching for SUID files (permission 4000)..."
    local suid_files=$(find / -perm -4000 -type f 2>/dev/null)

    echo "Found SUID files:"
    echo "$suid_files" | while read -r file; do
        ls -l "$file" 2>/dev/null

        # Check if it's in safe list
        if [[ ! " ${safe_suid[@]} " =~ " ${file} " ]]; then
            echo "  ⚠️  SUSPICIOUS: $file (not in baseline)"
        fi
    done

    echo
    echo "Searching for SGID files (permission 2000)..."
    local sgid_files=$(find / -perm -2000 -type f 2>/dev/null)

    echo "Found SGID files:"
    echo "$sgid_files" | while read -r file; do
        ls -l "$file" 2>/dev/null
    done

    # Count
    local suid_count=$(echo "$suid_files" | wc -l)
    local sgid_count=$(echo "$sgid_files" | wc -l)

    echo
    echo "Summary:"
    echo "  SUID files: $suid_count"
    echo "  SGID files: $sgid_count"

    # Save to file
    {
        echo "$suid_files"
        echo "$sgid_files"
    } > /tmp/suid_sgid_audit.txt

    echo "  Report saved: /tmp/suid_sgid_audit.txt"
}

security_audit_suid_sgid
```

</details>

**Andrei:** *"SUID — это privilege escalation waiting to happen. Знай, что у тебя есть. Мониторь изменения."*

**LILITH:** *"Каждый SUID файл — потенциальная дыра. Krylov их любит."*

---

### Задание 8: Итоговый Security Audit Report
**Цель:** Создать comprehensive отчёт для Viktor

**Отчёт должен включать:**
1. Список созданных пользователей и групп
2. Sudo конфигурация (кто что может)
3. ACL настройки
4. SUID/SGID audit
5. Рекомендации по улучшению

<details>
<summary>💡 Подсказка 1</summary>

Соберите всю информацию:
```bash
# Users
getent passwd | grep -E 'viktor|alex|anna|dmitry'

# Groups
for user in viktor alex anna dmitry; do
    echo "$user: $(groups $user)"
done

# Sudo config
sudo cat /etc/sudoers.d/alex

# ACL
getfacl /var/log/auth.log

# SUID/SGID
find / -perm -4000 -o -perm -2000 2>/dev/null | wc -l
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

generate_security_audit_report() {
    local report_file="/var/operations/security_audit_ep09.txt"

    echo "Generating Security Audit Report..."

    cat > "$report_file" << 'EOF'
================================================================================
                   SECURITY AUDIT REPORT - EPISODE 09
                        Users & Permissions
================================================================================

Operation: KERNEL SHADOWS
Location: Saint Petersburg, Russia (LETI)
Date: $(date)
Auditor: Max Sokolov
Mentor: Andrei Volkov

--------------------------------------------------------------------------------
1. USERS CREATED
--------------------------------------------------------------------------------

EOF

    # List created users
    for user in viktor alex anna dmitry; do
        if id "$user" &>/dev/null; then
            echo "✓ $user" >> "$report_file"
            id "$user" >> "$report_file"
            echo >> "$report_file"
        fi
    done

    cat >> "$report_file" << 'EOF'
--------------------------------------------------------------------------------
2. GROUPS & MEMBERSHIP
--------------------------------------------------------------------------------

EOF

    # Groups
    for group in operations security forensics devops netadmin; do
        if getent group "$group" &>/dev/null; then
            echo "Group: $group" >> "$report_file"
            getent group "$group" >> "$report_file"
            echo >> "$report_file"
        fi
    done

    cat >> "$report_file" << 'EOF'
--------------------------------------------------------------------------------
3. SUDO CONFIGURATION
--------------------------------------------------------------------------------

EOF

    # Sudo for Alex
    if [[ -f /etc/sudoers.d/alex ]]; then
        echo "Alex sudo configuration:" >> "$report_file"
        sudo cat /etc/sudoers.d/alex >> "$report_file"
    fi

    cat >> "$report_file" << 'EOF'

--------------------------------------------------------------------------------
4. ACL CONFIGURATION
--------------------------------------------------------------------------------

EOF

    # ACL for Anna
    echo "Anna log access (ACL):" >> "$report_file"
    getfacl /var/log 2>/dev/null | grep "user:anna" >> "$report_file"

    cat >> "$report_file" << 'EOF'

--------------------------------------------------------------------------------
5. SHARED DIRECTORY
--------------------------------------------------------------------------------

EOF

    # Shared directory permissions
    ls -ld /var/operations/shared 2>/dev/null >> "$report_file"

    cat >> "$report_file" << 'EOF'

--------------------------------------------------------------------------------
6. SUID/SGID AUDIT
--------------------------------------------------------------------------------

EOF

    # Count SUID/SGID files
    local suid_count=$(find / -perm -4000 -type f 2>/dev/null | wc -l)
    local sgid_count=$(find / -perm -2000 -type f 2>/dev/null | wc -l)

    echo "SUID files found: $suid_count" >> "$report_file"
    echo "SGID files found: $sgid_count" >> "$report_file"

    cat >> "$report_file" << 'EOF'

--------------------------------------------------------------------------------
7. SECURITY RECOMMENDATIONS
--------------------------------------------------------------------------------

✓ Principle of Least Privilege implemented
✓ Alex: sudo limited to network commands only
✓ Anna: read-only log access via ACL
✓ Shared directory: sticky bit + SGID enabled
✓ SUID/SGID audit completed

Recommendations:
1. Regular SUID/SGID monitoring (weekly)
2. Password policy: enforce strong passwords
3. Enable auditd for tracking user actions
4. Implement fail2ban for brute-force protection
5. Regular review of sudo configurations

--------------------------------------------------------------------------------
8. ANDREI VOLKOV NOTES
--------------------------------------------------------------------------------

"Root access как заряженный пистолет. Max справился хорошо. Permissions
настроены правильно. Krylov больше не сможет эксплуатировать misconfigured
accounts. Но мониторинг обязателен. Threats evolve."

Signed: Andrei Volkov, LETI Unix Lab
        Max Sokolov, System Administrator

================================================================================
                              END OF REPORT
================================================================================
EOF

    # Set permissions
    sudo chmod 640 "$report_file"
    sudo chown viktor:operations "$report_file"

    echo "✓ Security Audit Report generated: $report_file"
    echo
    cat "$report_file"
}

generate_security_audit_report
```

</details>

**Виктор** (читает отчёт):
*"Отлично. Теперь я спокоен за permissions. Следующий шаг — процессы и systemd."*

**Andrei:**
*"Max, ты научился важной вещи: безопасность начинается с правильных permissions. Без этого всё остальное бессмысленно."*

---

## 📚 Теория: Users, Groups, Permissions

### 1. Пользователи (Users)

#### Файлы:
- **`/etc/passwd`** — database пользователей
  - Формат: `username:x:UID:GID:comment:home:shell`
  - Пример: `max:x:1000:1000:Max Sokolov:/home/max:/bin/bash`
  - **UID 0** = root
  - **UID 1-999** = system users
  - **UID 1000+** = regular users

- **`/etc/shadow`** — зашифрованные пароли (только root может читать)
  - Формат: `username:encrypted_password:last_change:min:max:warn:inactive:expire`
  - Locked account: `!` или `*` в поле пароля

- **`/etc/group`** — группы
  - Формат: `groupname:x:GID:members`

#### Команды управления пользователями:

```bash
# Создание пользователя
sudo useradd username            # minimal
sudo useradd -m -s /bin/bash username  # с home и shell

# Модификация
sudo usermod -aG groupname username    # добавить в группу (-a = append!)
sudo usermod -L username               # lock account
sudo usermod -U username               # unlock account

# Удаление
sudo userdel username                  # удалить (оставить home)
sudo userdel -r username               # удалить с home

# Пароли
sudo passwd username                   # установить пароль
sudo passwd -e username                # expire password (force change)
sudo chage -d 0 username               # то же через chage

# Информация
id username                            # UID, GID, groups
groups username                        # группы
finger username                        # детальная инфо
who                                    # кто онлайн
w                                      # кто что делает
last                                   # история входов
```

---

### 2. Группы (Groups)

**Зачем нужны:**
Группы позволяют организовать пользователей и давать permissions группе, а не отдельным пользователям.

**Primary vs Secondary Groups:**
- **Primary group** — GID в `/etc/passwd`, обычно совпадает с username
- **Secondary groups** — дополнительные группы (через `usermod -aG`)

```bash
# Создание группы
sudo groupadd groupname

# Удаление
sudo groupdel groupname

# Добавление пользователя в группу
sudo usermod -aG groupname username

# Удаление из группы
sudo gpasswd -d username groupname

# Информация
getent group groupname    # members группы
groups username           # группы пользователя
```

**Примеры групп:**
- `sudo` / `wheel` — администраторы
- `docker` — Docker users
- `www-data` — web server
- `adm` — log access

---

### 3. Permissions (Права доступа)

#### Базовая модель: UGO (User, Group, Others)

```
-rwxr-xr-x
 │││││││││
 │││└┴┴┴┴┴─ Others permissions (r-x = read, execute)
 ││└┴┴─ Group permissions (r-x = read, execute)
 │└┴┴─ User (owner) permissions (rwx = read, write, execute)
 └─ File type (- = file, d = directory, l = link)
```

**Права:**
- **r (read)** = 4: читать файл / листать директорию
- **w (write)** = 2: изменять файл / создавать/удалять в директории
- **x (execute)** = 1: выполнять файл / входить в директорию

**Восьмеричная запись:**
- `rwx` = 4+2+1 = 7
- `r-x` = 4+0+1 = 5
- `r--` = 4+0+0 = 4

**Примеры:**
- `chmod 755 file` = `rwxr-xr-x` (owner всё, остальные read+execute)
- `chmod 644 file` = `rw-r--r--` (owner read+write, остальные read-only)
- `chmod 600 file` = `rw-------` (only owner)

#### Команды:

```bash
# Изменение permissions
chmod 755 file                # numeric
chmod u+x file                # symbolic: user + execute
chmod g-w file                # symbolic: group - write
chmod o= file                 # symbolic: others = nothing
chmod a+r file                # all + read

# Recursive
chmod -R 755 directory

# Изменение ownership
chown user file               # change owner
chown user:group file         # change owner and group
chown -R user:group directory # recursive

# Только группа
chgrp group file

# umask (default permissions)
umask                         # показать текущий
umask 022                     # установить (755 для directories, 644 для files)
```

---

### 4. Special Permissions

#### SUID (Set User ID) — bit 4000

**Что делает:**
Файл выполняется с правами **владельца**, а не запустившего пользователя.

**Пример:**
`/usr/bin/passwd` имеет SUID. Когда вы меняете свой пароль, `passwd` работает от имени root (чтобы изменить `/etc/shadow`).

```bash
ls -l /usr/bin/passwd
# -rwsr-xr-x root root ... /usr/bin/passwd
#    ^
#    s = SUID (вместо x)

# Установка SUID
chmod 4755 file     # or chmod u+s file
```

**⚠️ Опасность:**
Если SUID файл имеет уязвимость → privilege escalation к root.

---

#### SGID (Set Group ID) — bit 2000

**Для файлов:**
Файл выполняется с правами **группы** владельца.

**Для директорий:**
Новые файлы в директории наследуют **группу директории** (а не primary group создателя).

```bash
# SGID на директории
chmod 2775 directory    # or chmod g+s directory
ls -ld directory
# drwxrwsr-x ... directory
#       ^
#       s = SGID

# Тестирование
touch directory/newfile
ls -l directory/newfile
# -rw-r--r-- user GROUP_OF_DIRECTORY ... newfile
```

**Use case:** Shared directories (как в Задании 4).

---

#### Sticky Bit — bit 1000

**Для директорий:**
Файлы в директории может удалить только:
- Владелец файла
- Владелец директории
- root

**Пример:** `/tmp` использует sticky bit (иначе любой мог бы удалить чужие файлы).

```bash
ls -ld /tmp
# drwxrwxrwt ... /tmp
#         ^
#         t = sticky bit

# Установка
chmod 1777 /tmp    # or chmod +t /tmp
```

---

### 5. sudo — Superuser Do

**Что такое sudo:**
Временное повышение привилегий. Пользователь выполняет команду от имени root (или другого пользователя) после ввода своего пароля.

**Конфигурация:** `/etc/sudoers` (редактировать через `visudo`!)

**Синтаксис:**
```
username ALL=(ALL:ALL) ALL
```

Расшифровка:
- `username` — кто
- `ALL` (1st) — на каких хостах (обычно ALL)
- `(ALL:ALL)` — как какой пользователь:группа (обычно root:root)
- `ALL` (last) — какие команды

**Примеры:**

```bash
# Full sudo (опасно!)
username ALL=(ALL:ALL) ALL

# Sudo без пароля
username ALL=(ALL) NOPASSWD: ALL

# Ограничение на конкретные команды
username ALL=(root) /usr/bin/systemctl, /usr/bin/journalctl

# Алиасы для удобства
Cmnd_Alias NETCMDS = /usr/sbin/ip, /usr/bin/ss
username ALL=(root) NOPASSWD: NETCMDS
```

**Best Practices:**
1. ⚠️ **Никогда не редактируй /etc/sudoers напрямую** — используй `visudo`
2. ✅ Создавай файлы в `/etc/sudoers.d/` для отдельных пользователей
3. ✅ Давай минимальные привилегии (Principle of Least Privilege)
4. ✅ Логируй sudo действия (через auditd)

---

### 6. ACL (Access Control Lists)

**Что такое ACL:**
Более гибкие permissions, чем стандартные UGO. Позволяют давать права конкретным пользователям/группам помимо owner/group.

**Use case:**
Anna не в группе владельца файла, но ей нужен read-only доступ.

#### Команды:

```bash
# Установка ACL
setfacl -m u:username:rwx file        # user permissions
setfacl -m g:groupname:rx directory   # group permissions

# Удаление ACL
setfacl -x u:username file            # remove user ACL
setfacl -b file                       # remove all ACLs

# Просмотр
getfacl file

# Recursive
setfacl -R -m u:anna:r /var/log

# Default ACL (для новых файлов в директории)
setfacl -d -m u:anna:r /var/log
```

**Пример вывода getfacl:**
```
# file: /var/log/auth.log
# owner: root
# group: adm
user::rw-
user:anna:r--
group::r--
mask::r--
other::---
```

**⚠️ Внимание:**
Если ACL установлен, `ls -l` показывает `+` в конце permissions:
```
-rw-r--r--+ ... file
          ^
          ACL present
```

---

## 🛠️ Bash Reference для Episode 09

### Полезные однострочники:

```bash
# Список всех пользователей с shell доступом
grep -E '/bin/(bash|sh)$' /etc/passwd

# Найти UID 0 (кроме root)
awk -F: '$3 == 0 && $1 != "root" {print $1}' /etc/passwd

# Проверка членства в группе
groups username | grep -q groupname && echo "member" || echo "not member"

# Bulk user creation
for user in user1 user2 user3; do
    sudo useradd -m -s /bin/bash "$user"
done

# Find SUID files
find / -perm -4000 -type f 2>/dev/null

# Find SGID files
find / -perm -2000 -type f 2>/dev/null

# Find world-writable files (potential security risk)
find / -perm -002 -type f 2>/dev/null

# Recently modified files (last 7 days)
find /home -mtime -7 -type f

# Files belonging to user
find / -user username 2>/dev/null

# Files belonging to group
find / -group groupname 2>/dev/null
```

---

## 🎓 LILITH: Wisdom & Tips

### Andrei Volkov's Unix Philosophy:

> *"Root access как заряженный пистолет. Не давай его кому попало."*

**Принципы безопасного администрирования:**

1. **Principle of Least Privilege**
   Давай минимальные права, необходимые для работы. Не больше.

2. **Defense in Depth**
   Многослойная защита: permissions + sudo + ACL + auditd + monitoring.

3. **Trust, but Verify**
   Anna forensics expert — даём доступ к логам. Но read-only через ACL.

4. **Immutability for Critical Files**
   `/etc/passwd`, `/etc/shadow` — должны иметь строгие permissions (644, 640).

5. **Regular Audits**
   SUID/SGID файлы, sudo configurations, group memberships — регулярно проверяй.

---

### LILITH Security Mode:

**Проверка permissions:**
```bash
# Опасные permissions
find / -perm -002 ! -type l 2>/dev/null  # world-writable
find /home -perm -4000 2>/dev/null       # SUID in /home (suspicious)

# Проверка /etc/passwd и /etc/shadow permissions
ls -l /etc/passwd /etc/shadow
# Expected: -rw-r--r-- /etc/passwd
#           -rw-r----- /etc/shadow
```

**Мониторинг sudo usage:**
```bash
# Последние sudo команды
sudo journalctl _COMM=sudo --since "1 hour ago"

# Или в логах
sudo grep sudo /var/log/auth.log | tail -20
```

**Baseline для SUID files:**
```bash
# Создать baseline
find / -perm -4000 -type f 2>/dev/null | sort > /root/suid_baseline.txt

# Позже проверить изменения
find / -perm -4000 -type f 2>/dev/null | sort | diff /root/suid_baseline.txt -
```

---

### Частые ошибки:

1. ❌ **`usermod -G` вместо `usermod -aG`**
   Без `-a` (append) затрёт все существующие группы!

2. ❌ **Редактирование `/etc/sudoers` напрямую**
   Syntax error → система сломана. Используй `visudo`.

3. ❌ **Chmod 777 на всё**
   "Не работает → chmod 777" — классика. НЕ ДЕЛАЙ ТАК.

4. ❌ **SUID на shell scripts**
   Linux игнорирует SUID на скриптах (security feature). Не работает.

5. ❌ **Забыть про ACL mask**
   ACL mask может ограничивать эффективные права. Проверяй через `getfacl`.

---

## 🎯 Итоги Episode 09

### Что вы освоили:

✅ **Users & Groups**
   - Создание, модификация, удаление
   - Primary и secondary groups
   - Организация по ролям

✅ **Permissions (chmod, chown)**
   - UGO модель (User, Group, Others)
   - Восьмеричная и символьная запись
   - Permissions для directories vs files

✅ **Special Bits**
   - SUID — выполнение от имени владельца
   - SGID — наследование группы в директориях
   - Sticky Bit — защита от удаления чужих файлов

✅ **sudo Configuration**
   - Ограниченный доступ (только нужные команды)
   - NOPASSWD для удобства
   - Command aliases

✅ **ACL (Access Control Lists)**
   - Гибкие права для конкретных пользователей
   - Read-only доступ для Anna

✅ **Security Audit**
   - Поиск SUID/SGID файлов
   - Baseline и мониторинг изменений

---

### Сюжетный итог:

**Viktor** (читает ваш отчёт):
*"Отлично, Макс. Теперь я могу спать спокойно. Permissions настроены правильно. Krylov больше не сможет проникнуть через misconfigured accounts."*

**Alex:**
*"Хорошая работа. Но помни: permissions — это только первый слой защиты. Дальше — процессы, systemd, аудит."*

**Anna:**
*"Спасибо за read-only доступ к логам. Forensics требует доступа, но изменять логи я не должна. Правильный подход."*

**Andrei Volkov** (провожает Max на вокзал):
*"Ты научился важной вещи, Макс. Unix permissions — это философия. Principle of Least Privilege. Defense in Depth. Trust, but Verify. Это основа безопасности. Без этого всё остальное — просто theater."*

**Max:**
*"Спасибо, Andrei Nikolaevich. Я многое понял. Теперь следующий шаг?"*

**Andrei:**
*"Процессы. Systemd. Но это уже для Бориса. Он фанатик systemd. Встретишься с ним завтра."*

---

**LILITH:**
*"Хорошая работа. Permissions — это контроль. Контроль — это власть. Власть — это ответственность. Ты начинаешь понимать. Следующий эпизод — процессы. Готовься."*

---

## 📖 Дополнительные ресурсы

### Man pages (читай обязательно!):
```bash
man useradd      # User management
man chmod        # Change permissions
man sudo         # Superuser do
man sudoers      # Sudo configuration
man setfacl      # Set ACL
man getfacl      # Get ACL
```

### Online:
- [Linux Permissions Explained](https://www.redhat.com/sysadmin/linux-file-permissions-explained)
- [Understanding sudo](https://www.sudo.ws/)
- [ACL Tutorial](https://wiki.archlinux.org/title/Access_Control_Lists)

---

<div align="center">

**Next:** [Episode 10: Processes & Systemd](../episode-10-processes-systemd/)

*"Root — это не привилегия. Это ответственность."*

**Day 17-18 / 60 Complete! 🎉**

</div>


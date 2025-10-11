# Episode 07: Firewalls & iptables — Artifacts

**KERNEL SHADOWS — Season 2: Networking**

---

## 📁 Файлы в этой директории

### 1. `botnet_ips.txt`
**Описание:** Список IP адресов из ботнета Крылова (847 IPs в реальной атаке, 50 для тестирования).

**Формат:**
```
# Botnet IPs from Krylov's DDoS attack
185.220.101.52    # Tor exit node (Sweden)
45.142.120.10     # VPN provider (Netherlands)
...
```

**Использование (Type B):**
```bash
# Блокировка напрямую через ufw:
while read ip comment; do
    [[ "$ip" =~ ^# ]] && continue
    sudo ufw deny from "$ip"
done < botnet_ips.txt

# Проверка заблокированных:
sudo ufw status numbered | grep DENY
```

**Ожидаемый результат:** Все IP из списка заблокированы, атака снижена.

---

### 2. `firewall_audit_report.txt` (генерируется)
**Описание:** Итоговый отчёт firewall security audit.

**Генерируется командой:**
```bash
../solution/firewall_setup.sh
```

**Содержит:**
- UFW status (active/inactive)
- Firewall rules count (ALLOW/DENY)
- Critical ports status (SSH, HTTP, HTTPS)
- Blocked IPs count
- Rate limiting status
- Logging configuration
- Attack metrics (load, SYN_RECV, connections)
- Security score (X/7)
- Recommendations

---

## 🔧 UFW Commands Guide (Type B Approach)

### Базовые команды

**Статус:**
```bash
# Проверить статус UFW
sudo ufw status

# Детальный статус
sudo ufw status verbose

# Нумерованный список правил
sudo ufw status numbered
```

**Включение/Выключение:**
```bash
# Включить UFW
sudo ufw enable

# Выключить UFW
sudo ufw disable

# Перезагрузить правила
sudo ufw reload
```

**Default policies:**
```bash
# Запретить входящие по умолчанию
sudo ufw default deny incoming

# Разрешить исходящие по умолчанию
sudo ufw default allow outgoing

# Запретить forwarding
sudo ufw default deny forward
```

---

### Управление правилами

**Разрешить порт:**
```bash
# Разрешить SSH
sudo ufw allow 22/tcp

# С комментарием (рекомендуется!)
sudo ufw allow 22/tcp comment 'SSH access'

# HTTP и HTTPS
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

# Диапазон портов
sudo ufw allow 6000:6010/tcp comment 'X11 forwarding'
```

**Запретить IP/порт:**
```bash
# Заблокировать конкретный IP
sudo ufw deny from 185.220.101.52

# Заблокировать подсеть
sudo ufw deny from 185.220.0.0/16

# Запретить порт
sudo ufw deny 23/tcp comment 'Telnet blocked'

# Блокировать IP только для определённого порта
sudo ufw deny from 185.220.101.52 to any port 80
```

**Rate limiting (защита от brute-force):**
```bash
# Ограничить SSH (max 6 connections per 30 seconds)
sudo ufw limit 22/tcp

# Эффект: защита от SYN flood и brute-force
```

**Удаление правил:**
```bash
# Показать нумерованные правила
sudo ufw status numbered

# Удалить правило по номеру
sudo ufw delete 3

# Удалить правило по содержимому
sudo ufw delete allow 80/tcp
```

---

### Логирование

**Включить/выключить:**
```bash
# Включить логирование
sudo ufw logging on

# Выключить
sudo ufw logging off

# Уровень логирования
sudo ufw logging low     # минимальный
sudo ufw logging medium  # средний
sudo ufw logging high    # детальный
sudo ufw logging full    # всё (для debugging)
```

**Просмотр логов:**
```bash
# Хвост лога (реал-тайм)
sudo tail -f /var/log/ufw.log

# Поиск блокированных попыток
sudo grep "\\[UFW BLOCK\\]" /var/log/ufw.log

# Топ заблокированных IP
sudo grep "\\[UFW BLOCK\\]" /var/log/ufw.log | \
    awk '{print $12}' | sort | uniq -c | sort -nr | head -10

# Последние 50 блокировок
sudo grep "\\[UFW BLOCK\\]" /var/log/ufw.log | tail -50
```

---

### Advanced UFW

**Специфичные правила:**
```bash
# Разрешить с конкретного IP
sudo ufw allow from 10.0.0.5 to any port 22

# Разрешить подсеть
sudo ufw allow from 10.0.0.0/24

# Разрешить конкретный интерфейс
sudo ufw allow in on eth0 to any port 80

# Разрешить OUTPUT (исходящие)
sudo ufw allow out 53/udp comment 'DNS queries'
```

**Application profiles:**
```bash
# Список доступных profiles
sudo ufw app list

# Информация о profile
sudo ufw app info "Apache Full"

# Разрешить application
sudo ufw allow "Apache Full"
sudo ufw allow "OpenSSH"
```

---

## 🛡️ iptables Basics (When UFW is not enough)

### Когда использовать iptables?

**UFW подходит для:**
- ✅ Простые правила (allow/deny ports)
- ✅ Базовая защита сервера
- ✅ Quick setup

**iptables нужен для:**
- ⚙️ Сложные правила (stateful filtering)
- ⚙️ NAT/Port forwarding
- ⚙️ Custom chains
- ⚙️ Advanced rate limiting
- ⚙️ Deep packet inspection

---

### iptables Commands

**Просмотр правил:**
```bash
# Все правила
sudo iptables -L

# С номерами строк
sudo iptables -L --line-numbers

# Детальная информация
sudo iptables -L -n -v

# Конкретная chain
sudo iptables -L INPUT -n -v
```

**Базовые правила:**
```bash
# Разрешить порт (INPUT chain)
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Заблокировать IP
sudo iptables -A INPUT -s 185.220.101.52 -j DROP

# Разрешить established connections
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Разрешить loopback
sudo iptables -A INPUT -i lo -j ACCEPT
```

**Rate limiting:**
```bash
# SYN flood protection (более детальный чем UFW)
sudo iptables -A INPUT -p tcp --syn -m limit --limit 10/s --limit-burst 20 -j ACCEPT
sudo iptables -A INPUT -p tcp --syn -j DROP

# Connection limit per IP
sudo iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 10 -j REJECT
```

**Удаление правил:**
```bash
# По номеру
sudo iptables -D INPUT 3

# По содержимому
sudo iptables -D INPUT -p tcp --dport 80 -j ACCEPT

# Очистить chain
sudo iptables -F INPUT

# Очистить всё
sudo iptables -F
```

**Сохранение правил:**
```bash
# Ubuntu/Debian
sudo iptables-save > /etc/iptables/rules.v4

# Или через пакет
sudo apt install iptables-persistent
sudo netfilter-persistent save
```

---

## 🚨 Troubleshooting Guide

### Problem: SSH lockout после enable UFW

**Symptoms:**
```bash
$ ssh user@server
Connection timed out
```

**Причина:** UFW заблокировал SSH (порт 22 не разрешён).

**Решение:**

**Локально/VM:**
```bash
# Физический доступ к консоли
sudo ufw disable
sudo ufw allow 22/tcp
sudo ufw enable
```

**Cloud (через web console):**
```bash
# AWS EC2 Serial Console / DigitalOcean Console
sudo ufw status
# Если SSH заблокирован:
sudo ufw allow 22/tcp
# Или временно:
sudo ufw disable
```

**Предотвращение:**
```bash
# ВСЕГДА делай так:
sudo ufw allow 22/tcp   # FIRST!
sudo ufw enable         # THEN!

# Используй screen/tmux
screen
# Внутри screen настраивай UFW
# Если потеряешь соединение → reattach
screen -r
```

---

### Problem: UFW и Docker конфликт

**Symptoms:**
```bash
# Docker containers доступны даже когда UFW deny
```

**Причина:** Docker изменяет iptables напрямую, обходя UFW.

**Решение:**
```bash
# Отредактировать /etc/ufw/after.rules
sudo nano /etc/ufw/after.rules

# Добавить в конец:
*filter
:ufw-user-forward - [0:0]
:DOCKER-USER - [0:0]
-A DOCKER-USER -j ufw-user-forward
-A DOCKER-USER -j RETURN
COMMIT

# Перезагрузить UFW
sudo ufw reload

# Или отключить iptables в Docker
# /etc/docker/daemon.json
{
  "iptables": false
}
sudo systemctl restart docker
```

---

### Problem: Медленное соединение после rate limiting

**Symptoms:**
```bash
# SSH подключение занимает 10-15 секунд
```

**Причина:** Слишком агрессивный rate limit.

**Решение:**
```bash
# Проверить текущие правила
sudo ufw status | grep LIMIT

# Удалить rate limit
sudo ufw delete limit 22/tcp

# Добавить allow вместо limit
sudo ufw allow 22/tcp

# Или настроить iptables более гибко
sudo iptables -A INPUT -p tcp --dport 22 -m limit --limit 10/minute -j ACCEPT
```

---

### Problem: Правила не работают

**Diagnosis:**
```bash
# 1. UFW активен?
sudo ufw status
# Если inactive → sudo ufw enable

# 2. Порядок правил правильный?
sudo ufw status numbered
# Первое совпадающее правило выполняется!

# 3. Конфликт с iptables?
sudo iptables -L -n -v
# UFW использует iptables, могут быть конфликты

# 4. Логи показывают блокировки?
sudo grep "\\[UFW BLOCK\\]" /var/log/ufw.log | tail
```

**Решение:**
```bash
# Reset UFW к defaults
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw enable
```

---

### Problem: Не могу найти логи UFW

**Locations:**
```bash
# Ubuntu/Debian
/var/log/ufw.log

# Если пустой или нет:
# 1. Логирование включено?
sudo ufw logging on

# 2. rsyslog работает?
sudo systemctl status rsyslog
sudo systemctl restart rsyslog

# 3. Проверить syslog
sudo grep UFW /var/log/syslog

# 4. journald (если systemd)
sudo journalctl -u ufw
```

---

## 📊 UFW vs iptables Comparison

| Feature | UFW | iptables |
|---------|-----|----------|
| **Ease of use** | ✅ Very simple | ⚠️ Complex |
| **Basic rules** | ✅ Excellent | ⚠️ Verbose |
| **Advanced rules** | ⚠️ Limited | ✅ Full control |
| **Learning curve** | ⭐☆☆☆☆ | ⭐⭐⭐⭐☆ |
| **For beginners** | ✅ Yes | ❌ No |
| **For production** | ✅ Yes (basic) | ✅ Yes (advanced) |
| **Persistence** | ✅ Automatic | ⚠️ Manual |
| **Application profiles** | ✅ Yes | ❌ No |
| **NAT/Forwarding** | ⚠️ Complex | ✅ Native |

**Recommendation:**
- **Start with UFW** (Episode 07) ✅
- **Learn iptables** for advanced scenarios (later episodes)

---

## 🔐 Security Best Practices

### 1. Default Deny Policy
```bash
# Запретить всё, разрешить только нужное
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

### 2. Minimal Open Ports
```bash
# Только необходимое:
sudo ufw allow 22/tcp    # SSH (обязательно!)
sudo ufw allow 80/tcp    # HTTP (если web server)
sudo ufw allow 443/tcp   # HTTPS (если web server)

# НЕ открывайте без необходимости:
# 23 (Telnet), 21 (FTP), 3306 (MySQL), 5432 (PostgreSQL)
```

### 3. Rate Limiting для критичных портов
```bash
# SSH защита от brute-force
sudo ufw limit 22/tcp

# Эффект: max 6 connections per 30 seconds per IP
```

### 4. Логирование
```bash
# Включить и мониторить
sudo ufw logging on

# Регулярная проверка
sudo tail -f /var/log/ufw.log

# Automated monitoring (cron job)
# /etc/cron.daily/ufw-check
#!/bin/bash
BLOCKED=$(grep "\\[UFW BLOCK\\]" /var/log/ufw.log | wc -l)
if [ "$BLOCKED" -gt 1000 ]; then
    echo "WARNING: $BLOCKED blocked attempts!" | mail -s "UFW Alert" admin@example.com
fi
```

### 5. Регулярные аудиты
```bash
# Еженедельная проверка
sudo ufw status numbered

# Удалить неиспользуемые правила
sudo ufw delete [number]

# Документировать изменения
echo "$(date): Added rule for X" >> /var/log/firewall-changes.log
```

### 6. fail2ban Integration
```bash
# Автоматическая блокировка после N failed attempts
sudo apt install fail2ban

# Конфигурация SSH protection
sudo nano /etc/fail2ban/jail.local

[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600

sudo systemctl restart fail2ban

# fail2ban автоматически добавит ufw rules
```

---

## 📖 Learning Resources

### Man pages:
```bash
man ufw
man iptables
man iptables-save
man netfilter-persistent
```

### Important files:
```
/etc/ufw/ufw.conf          # UFW configuration
/etc/ufw/user.rules        # User-defined rules
/etc/default/ufw           # UFW defaults
/var/log/ufw.log           # UFW logs
/etc/iptables/rules.v4     # iptables IPv4 rules
```

### Online resources:
- **UFW Documentation** — https://help.ubuntu.com/community/UFW
- **iptables Tutorial** — https://www.netfilter.org/documentation/
- **Digital Ocean UFW Guide** — https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands

---

**KERNEL SHADOWS — Episode 07: Firewalls & iptables**

*"ufw exists → use it, don't wrap it"* — Type B Philosophy

*"Firewall — последняя линия обороны. Если сервер падает — операция провалена."* — Алекс Соколов

# Episode 06: DNS & Name Resolution — Artifacts

**KERNEL SHADOWS — Season 2: Networking**

---

## 📁 Файлы в этой директории

### 1. `dns_zones.txt`
**Описание:** Список внутренних (private) доменов Shadow Ops infrastructure.

**Формат:**
```
# Internal domains (should NOT be in public DNS!)
shadow-server-01.ops.internal
shadow-server-02.ops.internal
...
```

**Назначение:** Проверка что internal домены НЕ утекли в public DNS.

**Использование:**
```bash
# Проверить каждый домен
while read domain; do
    [[ "$domain" =~ ^# ]] && continue
    result=$(dig +short "$domain")
    if [ -n "$result" ]; then
        echo "⚠️  LEAK: $domain is in public DNS!"
    else
        echo "✓ OK: $domain (not public)"
    fi
done < dns_zones.txt
```

**Ожидаемый результат:** ПУСТО (все internal домены должны быть недоступны через public DNS).

---

### 2. `suspicious_domains.txt`
**Описание:** Список доменов для проверки на DNS spoofing с их expected IP адресами.

**Формат:**
```
DOMAIN          EXPECTED_IP        COMMENT
facebook.com    157.240.1.35       # Social network
google.com      142.250.185.46     # Search engine
```

**Назначение:** Обнаружение DNS cache poisoning.

**Использование:**
```bash
# Проверить на spoofing
while read domain expected_ip comment; do
    [[ "$domain" =~ ^# ]] && continue
    actual=$(dig +short "$domain" | head -1)
    if [ "$actual" != "$expected_ip" ]; then
        echo "⚠️  SPOOFED: $domain"
        echo "   Expected: $expected_ip"
        echo "   Actual:   $actual"
    fi
done < suspicious_domains.txt
```

**Ожидаемый результат:** Все домены должны возвращать expected IP. Если нет → DNS spoofing!

---

### 3. `dns_security_report.txt` (генерируется)
**Описание:** Итоговый отчёт DNS security audit.

**Генерируется командой:**
```bash
../solution/dns_audit.sh
```

**Содержит:**
- DNS configuration status
- Shadow servers leaks check
- DNS spoofing detection
- DNSSEC validation
- Performance metrics
- Security recommendations

---

## 🔧 DNS Tools Guide (Type B Approach)

### dig — Основной DNS инструмент

**Базовый lookup:**
```bash
dig google.com
```

**Короткий вывод (только IP):**
```bash
dig +short google.com
```

**Указать DNS сервер:**
```bash
dig @8.8.8.8 google.com        # Google DNS
dig @1.1.1.1 google.com        # Cloudflare DNS
dig @208.67.222.222 google.com # OpenDNS
```

**Разные типы записей:**
```bash
dig A google.com       # IPv4
dig AAAA google.com    # IPv6
dig MX gmail.com       # Mail servers
dig NS google.com      # Name servers
dig TXT google.com     # Text records
dig ANY google.com     # All records
```

**Reverse DNS:**
```bash
dig -x 8.8.8.8         # IP → hostname
```

**DNSSEC validation:**
```bash
dig +dnssec google.com

# Искать в выводе:
# - RRSIG record (подпись)
# - ad flag (Authenticated Data)
```

**Трассировка резолюции:**
```bash
dig +trace google.com

# Показывает весь путь:
# Root → TLD (.com) → Authoritative DNS
```

---

### systemd-resolved — Ubuntu DNS Resolver

**Статус:**
```bash
resolvectl status

# Показывает:
# - DNS servers
# - Search domains
# - DNSSEC status
# - DNS over TLS config
```

**Query домена:**
```bash
resolvectl query google.com

# Output:
# google.com: 142.250.185.46
# -- Information acquired via protocol DNS in 23ms
```

**С указанием типа:**
```bash
resolvectl query --type=MX gmail.com
resolvectl query --type=TXT google.com
```

**Статистика cache:**
```bash
resolvectl statistics

# Current Cache Size: 147
# Cache Hits: 1523
# Cache Misses: 234
```

**Flush DNS cache:**
```bash
sudo resolvectl flush-caches

# Verify:
resolvectl statistics
# Current Cache Size: 0
```

**Конфигурация DNS servers:**
```bash
# Показать текущие
resolvectl dns

# Установить новые (per-interface)
sudo resolvectl dns eth0 8.8.8.8 1.1.1.1
```

---

### Configuration Files

**`/etc/hosts` — Локальный DNS (highest priority):**

```bash
# Просмотр
cat /etc/hosts

# Формат:
IP_ADDRESS    HOSTNAME    [ALIASES]

# Пример:
127.0.0.1       localhost
10.50.1.15      shadow-server-01.ops.internal shadow-01

# Редактирование (осторожно!)
sudo nano /etc/hosts

# Security check (поиск suspicious entries):
sudo cat /etc/hosts | grep -v "^#" | grep -v "^$" | grep -v "127.0"
```

**`/etc/resolv.conf` — DNS servers configuration:**

```bash
# Просмотр
cat /etc/resolv.conf

# Формат:
nameserver 8.8.8.8
nameserver 1.1.1.1
search ops.internal
options edns0 trust-ad

# На Ubuntu обычно managed by systemd-resolved:
nameserver 127.0.0.53  # systemd-resolved stub

# Для прямого редактирования (не рекомендуется):
sudo nano /etc/resolv.conf

# Правильный способ (через systemd-resolved):
sudo resolvectl dns eth0 8.8.8.8 1.1.1.1
```

**`/etc/systemd/resolved.conf` — systemd-resolved config:**

```bash
# Просмотр
cat /etc/systemd/resolved.conf

# Редактирование
sudo nano /etc/systemd/resolved.conf

[Resolve]
DNS=8.8.8.8 1.1.1.1
FallbackDNS=208.67.222.222
DNSSEC=allow-downgrade
DNSOverTLS=opportunistic

# После изменений:
sudo systemctl restart systemd-resolved
```

---

## 🛠️ Troubleshooting Guide

### Problem: DNS resolution fails

**Симптомы:**
```bash
$ dig google.com
;; connection timed out; no servers could be reached
```

**Диагностика:**

```bash
# 1. Проверить DNS servers в /etc/resolv.conf
cat /etc/resolv.conf

# 2. Проверить systemd-resolved
resolvectl status

# 3. Ping DNS server (проверить connectivity)
ping 8.8.8.8

# 4. Проверить если DNS port 53 открыт
sudo ss -tuln | grep :53
```

**Решение:**

```bash
# Установить working DNS servers
sudo resolvectl dns eth0 8.8.8.8 1.1.1.1

# Или flush cache
sudo resolvectl flush-caches

# Restart systemd-resolved
sudo systemctl restart systemd-resolved
```

---

### Problem: Slow DNS queries

**Симптомы:**
```bash
$ dig google.com
;; Query time: 523 msec    # Очень медленно!
```

**Диагностика:**

```bash
# Попробовать разные DNS servers
dig @8.8.8.8 google.com    # Google DNS
dig @1.1.1.1 google.com    # Cloudflare DNS

# Проверить network latency
ping 8.8.8.8
traceroute 8.8.8.8
```

**Решение:**

```bash
# Сменить DNS server на быстрый
sudo resolvectl dns eth0 1.1.1.1 8.8.8.8

# Cloudflare (1.1.1.1) обычно самый быстрый
```

---

### Problem: DNS spoofing detected

**Симптомы:**
```bash
$ dig google.com +short
185.220.101.52    # Неправильный IP!
```

**Диагностика:**

```bash
# Проверить через несколько DNS resolvers
dig @8.8.8.8 +short google.com
dig @1.1.1.1 +short google.com
dig @208.67.222.222 +short google.com

# Если результаты РАЗНЫЕ → один resolver скомпрометирован
```

**Решение:**

```bash
# 1. НЕМЕДЛЕННО flush DNS cache
sudo resolvectl flush-caches

# 2. Добавить правильный IP в /etc/hosts (temporary)
echo "142.250.185.46 google.com" | sudo tee -a /etc/hosts

# 3. Сменить DNS resolver
sudo resolvectl dns eth0 1.1.1.1 8.8.8.8

# 4. Проверить /etc/hosts на malware
sudo cat /etc/hosts | grep -v "^#" | grep -v "^$"

# 5. Уведомить команду о инциденте
```

---

### Problem: `/etc/hosts` malware entries

**Симптомы:**
```bash
# facebook.com не открывается или ведёт на suspicious site
```

**Диагностика:**

```bash
# Проверить /etc/hosts
sudo cat /etc/hosts | grep facebook

# Suspicious entry:
185.220.101.52  facebook.com  # ⚠️ MALWARE!
```

**Решение:**

```bash
# 1. Backup /etc/hosts
sudo cp /etc/hosts /etc/hosts.backup

# 2. Удалить suspicious entries
sudo nano /etc/hosts
# (удалить строки с attacker IPs)

# 3. Проверить permissions
ls -l /etc/hosts
# Должно быть: -rw-r--r-- root root

# 4. Сделать immutable (optional)
sudo chattr +i /etc/hosts
# (теперь даже root не может изменить без chattr -i)

# 5. Full system malware scan
sudo rkhunter --check
```

---

### Problem: DNSSEC validation fails

**Симптомы:**
```bash
$ dig +dnssec example.com
; ANSWER SECTION пустой или invalid signature
```

**Диагностика:**

```bash
# Проверить DNSSEC support
dig +dnssec google.com | grep "ad"
# ad flag должен быть present

# Check systemd-resolved DNSSEC config
cat /etc/systemd/resolved.conf | grep DNSSEC
```

**Решение:**

```bash
# Enable DNSSEC в systemd-resolved
sudo nano /etc/systemd/resolved.conf

[Resolve]
DNSSEC=yes

# Restart
sudo systemctl restart systemd-resolved

# Verify
resolvectl status | grep DNSSEC
```

---

## 📊 DNS Tools Comparison

| Tool | Use Case | Output Detail | Speed | Type B ✅ |
|------|----------|---------------|-------|---------|
| **dig** | Professional DNS queries | Very detailed | Fast | ✅ Primary |
| **host** | Quick lookups | Brief | Fast | ✅ OK |
| **nslookup** | Legacy support | Interactive | Fast | ⚠️ Deprecated |
| **resolvectl** | systemd-resolved control | System-level | Fast | ✅ Primary |
| **systemd-resolve** | Old name for resolvectl | Same | Fast | ⚠️ Use resolvectl |

**Type B Recommendation:**
- **Primary:** `dig` для queries, `resolvectl` для system config
- **Secondary:** `host` для быстрых проверок
- **Avoid:** bash wrappers вокруг dig (используй dig напрямую!)

---

## 🔐 Security Best Practices

### 1. DNS Configuration Hardening

```bash
# Use trusted DNS resolvers
8.8.8.8, 8.8.4.4          # Google Public DNS
1.1.1.1, 1.0.0.1          # Cloudflare DNS
208.67.222.222            # OpenDNS

# Enable DNSSEC
DNSSEC=yes в /etc/systemd/resolved.conf

# Enable DNS over TLS (encryption)
DNSOverTLS=yes
```

### 2. Regular Audits

```bash
# Weekly DNS audit checklist:
1. cat /etc/hosts — проверить на malware
2. resolvectl status — verify DNS servers
3. dig +dnssec google.com — DNSSEC working
4. Check query performance (< 100 ms)
5. Review DNS logs (if enabled)
```

### 3. Incident Response

```bash
# DNS spoofing detected:
1. sudo resolvectl flush-caches       # Immediate
2. Update /etc/hosts с correct IPs    # Temporary fix
3. Change DNS resolver                # Switch to trusted
4. Notify security team                # Escalate
5. Investigate how cache was poisoned # Forensics
```

---

## 📖 Дополнительные команды

### DNS cache management:

```bash
# systemd-resolved
sudo resolvectl flush-caches
resolvectl statistics

# dnsmasq (if used)
sudo systemctl restart dnsmasq

# nscd (if used)
sudo systemctl restart nscd
```

### DNS testing:

```bash
# Test different record types
for type in A AAAA MX NS TXT; do
    echo "=== $type ==="
    dig $type google.com +short
done

# Test multiple resolvers
for dns in 8.8.8.8 1.1.1.1 208.67.222.222; do
    echo "=== $dns ==="
    dig @$dns google.com +short
done
```

### DNS security tools:

```bash
# Install additional tools
sudo apt install bind9-dnsutils ldns-utils

# DNSSEC validation (detailed)
delv google.com
drill -D google.com

# DNS benchmarking
namebench  # (separate package)
```

---

## 🎓 Learning Resources

### Man pages:
```bash
man dig
man host
man systemd-resolved
man resolv.conf
```

### RFCs:
- **RFC 1035** — Domain Names (DNS specification)
- **RFC 4033-4035** — DNSSEC specifications
- **RFC 7858** — DNS over TLS
- **RFC 8484** — DNS over HTTPS

### Online tools:
- **DNSViz** — https://dnsviz.net (DNSSEC visualization)
- **DNS Leak Test** — https://dnsleaktest.com
- **MXToolbox** — https://mxtoolbox.com (DNS lookup tools)

---

**KERNEL SHADOWS — Episode 06: DNS & Name Resolution**

*"dig exists → use it, don't wrap it"* — Type B Philosophy

*"DNS — телефонная книга интернета. Если книга поддельная — весь трафик идёт не туда."* — Erik Johansson

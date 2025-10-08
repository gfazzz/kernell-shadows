# Episode 06: DNS & Name Resolution — Artifacts

**Bahnhof Pionen Datacenter, Stockholm, Sweden 🇸🇪**

---

## 📁 Files

### 1. `dns_zones.txt`

**Назначение:** Список internal доменов операции KERNEL SHADOWS.

**Формат:**
```
shadow-server-XX.ops.internal
```

**Что проверять:**
- Эти домены НЕ должны быть в публичном DNS
- Если `dig shadow-server-01.ops.internal` возвращает IP → утечка информации!
- Ожидаемый результат: `NXDOMAIN` (domain does not exist)

**Использование:**
```bash
# Проверить все домены
while read domain; do
    [[ "$domain" =~ ^# || -z "$domain" ]] && continue
    dig +short "$domain"
done < dns_zones.txt

# Ожидается: пустой вывод (домены не в DNS)
```

**Security note:**
Internal домены (`.ops.internal`) должны резолвиться только в private сети через internal DNS сервер. Если они видны в публичном DNS — это серьёзная утечка информации о инфраструктуре.

---

### 2. `suspicious_domains.txt`

**Назначение:** База данных для обнаружения DNS spoofing.

**Формат:**
```
domain expected_ip [comment]
```

**Что проверять:**
- Для каждого домена сравнить actual IP (из DNS) с expected IP
- Если не совпадают → DNS spoofing / cache poisoning!

**Использование:**
```bash
# Проверить на spoofing
while IFS=' ' read -r domain expected_ip comment; do
    [[ "$domain" =~ ^# || -z "$domain" ]] && continue

    actual_ip=$(dig +short "$domain" | head -n1)

    if [ -n "$actual_ip" ] && [ "$actual_ip" != "$expected_ip" ]; then
        echo "⚠️  SPOOFED: $domain"
        echo "    Expected: $expected_ip"
        echo "    Actual:   $actual_ip"
    fi
done < suspicious_domains.txt
```

**Krylov's Attack:**
Полковник Krylov использует cache poisoning для подмены DNS ответов. Когда вы запрашиваете `shadow-server-05.ops.internal`, поддельный DNS может вернуть IP под контролем Krylov → MITM attack.

---

### 3. `network_report.txt` (generated)

**Назначение:** Детальный отчёт о DNS security audit.

**Генерируется:** вашим скриптом `dns_audit.sh`

**Содержание:**
- Shadow servers check (утечки информации)
- DNS records analysis (A, AAAA, MX, TXT, NS)
- Reverse DNS check (PTR records)
- DNS spoofing detection (cache poisoning)
- DNSSEC validation (security)
- Security assessment (risk level)
- Recommendations

**Формат:**
```
═══════════════════════════════════════════════════════════════
           DNS SECURITY AUDIT REPORT
═══════════════════════════════════════════════════════════════

Date:       2025-10-11 14:00:00
Location:   Bahnhof Pionen, Stockholm, Sweden 🇸🇪
Operator:   Max Sokolov

[1] SHADOW SERVERS CHECK
    Total domains:      15
    Not in public DNS:  15 ✓
    Status:             ✓ SECURE

[2] DNS SPOOFING DETECTION
    Checked:            10 domains
    Spoofed:            0
    Status:             ✓ NO ATTACK

[3] DNSSEC VALIDATION
    Checked:            3 domains
    DNSSEC enabled:     2/3
    Protected:
      ✓ google.com
      ✓ cloudflare.com
      ✗ example.com

SECURITY ASSESSMENT:
  Overall Status: ✓ LOW RISK

  All checks passed. DNS infrastructure is secure.

═══════════════════════════════════════════════════════════════
```

---

## 🛠 Tools

### DNS Lookup Commands

```bash
# Basic lookup
dig google.com
host google.com

# Specific record types
dig google.com A      # IPv4
dig google.com AAAA   # IPv6
dig google.com MX     # Mail servers
dig google.com TXT    # Text records
dig google.com NS     # Name servers

# Short output
dig +short google.com

# Reverse DNS
dig -x 8.8.8.8

# DNSSEC check
dig +dnssec google.com
```

### DNS Security

```bash
# Check for DNSSEC
dig +dnssec google.com | grep RRSIG

# Check multiple DNS servers (detect inconsistency)
dig @8.8.8.8 google.com      # Google DNS
dig @1.1.1.1 google.com      # Cloudflare DNS
dig @9.9.9.9 google.com      # Quad9 DNS

# If results differ → possible DNS spoofing!
```

### Troubleshooting

```bash
# Flush DNS cache
sudo systemd-resolve --flush-caches

# Check current DNS servers
cat /etc/resolv.conf

# Test DNS resolution order
cat /etc/nsswitch.conf | grep hosts

# Local DNS override
cat /etc/hosts
```

---

## 🎯 Tasks

### Task 2: Shadow Servers Check
Проверьте что internal домены НЕ в публичном DNS.

**Expected:**
- Все 15 доменов должны возвращать NXDOMAIN
- Если какой-то домен резолвится → утечка!

### Task 6: DNS Spoofing Detection
Сравните actual DNS ответы с expected IP.

**Expected:**
- Internal домены: NXDOMAIN (не в публичном DNS)
- Если actual IP ≠ expected IP → spoofing!

### Task 7: DNSSEC Validation
Проверьте DNSSEC для известных доменов.

**Expected:**
- `google.com` — DNSSEC enabled ✓
- `cloudflare.com` — DNSSEC enabled ✓
- `example.com` — может не иметь DNSSEC

---

## 🔒 Security Notes

### DNS Spoofing Indicators:
- Unexpected IP addresses
- Different results from different DNS servers
- SSL certificate errors (wrong cert for domain)
- Sudden changes in DNS TTL

### Protection:
- ✓ Use trusted DNS (8.8.8.8, 1.1.1.1, 9.9.9.9)
- ✓ Enable DNSSEC validation
- ✓ Monitor DNS query logs
- ✓ Use DNS over TLS (DoT) or DNS over HTTPS (DoH)

### Krylov's Tactics:
- Cache poisoning на public DNS resolvers
- Rogue DNS servers в compromised networks
- `/etc/hosts` poisoning при root access
- DNS amplification для DDoS

**Defense:** DNSSEC + DoT + internal DNS + monitoring

---

## 📚 References

**Public DNS Servers:**
- **8.8.8.8** — Google Public DNS (DNSSEC, fast)
- **1.1.1.1** — Cloudflare (DNSSEC, privacy-focused)
- **9.9.9.9** — Quad9 (DNSSEC, malware blocking)

**DNS Security:**
- DNSSEC: digital signatures для DNS records
- DoT (DNS over TLS): шифрование на port 853
- DoH (DNS over HTTPS): шифрование на port 443

**Related Episodes:**
- Episode 05: TCP/IP Fundamentals (networking basics)
- Episode 07: Firewalls & iptables (блокировка malicious IPs)
- Episode 08: VPN & SSH Tunneling (encrypted DNS через VPN)

---

*"DNS — телефонная книга интернета. Если книга поддельная — весь трафик идёт не туда."* — Erik Johansson, Bahnhof Network Engineer

**Next:** Implement `dns_audit.sh` script!

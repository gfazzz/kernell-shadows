# Episode 06: DNS & Name Resolution

**KERNEL SHADOWS — Season 2: Networking**

```
╔═══════════════════════════════════════════════════════════════╗
║  Episode 06: DNS & Name Resolution                            ║
║                                                               ║
║  Location: Stockholm, Sweden 🇸🇪                              ║
║  Datacenter: Bahnhof Pionen (30 метров под землёй)           ║
║  Day: 10-12 of 60                                             ║
║  Difficulty: ⭐⭐☆☆☆                                          ║
║  Time: 3-4 hours                                              ║
╚═══════════════════════════════════════════════════════════════╝
```

---

## 🎬 Сюжет

### День 10, 08:00 — Arlanda Airport, Stockholm

Самолёт приземляется в Arlanda. Макс впервые за границей. Чувство нереальности — вчера был в Москве, сегодня в Швеции.

**Терминал Arrivals:**

Высокий швед в чёрной куртке с логотипом Bahnhof держит табличку: **"Max Sokolov — Shadow Ops"**.

**Erik Johansson** (38 лет, блондин, спокойный):
> *"Welcome to Sweden, Max. Viktor says you're good with Linux. We'll see. I'm Erik, network engineer at Bahnhof. Our car is outside."*

Макс (немного растерян):
> *"Uh... hi. My English is not perfect..."*

Erik (улыбается):
> *"Don't worry. Technology speaks a universal language. And I understand some Russian — my grandmother was from St. Petersburg."*

**По дороге в Bahnhof Pionen:**

Erik:
> *"You know what Pionen is? Cold War nuclear bunker, 30 meters underground. We converted it into datacenter in 2008. Privacy-first. After WikiLeaks, Swedish government wanted access to our servers. We refused. Privacy is not negotiable."*

Макс (впечатлён):
> *"Nuclear bunker? Serious?"*

Erik:
> *"Very serious. Rock walls, waterfall inside, submarine engine for backup power. James Bond movie, but real."*

---

### 10:30 — Bahnhof Pionen Datacenter

**Вход через скалу.**

Бетонный тоннель ведёт вниз. Холод. Звук воды. Неоновое освещение.

**Зона серверов:**

Футуристичный дизайн внутри скалы. Серверные стойки светятся синим. Искусственный водопад на стене. Температура +15°C.

Erik:
> *"Welcome to Pionen. Viktor rents 3 racks here. Geographically distributed infrastructure — Moscow, Stockholm, later Tallinn, Amsterdam, Beijing, Reykjavik. We are building something big."*

Макс:
> *"Why Sweden?"*

Erik:
> *"Privacy laws. No data retention mandatory. Sweden is neutral. And Bahnhof — we have backbone in our DNA. Literally — we run major internet exchange point."*

**На мониторе Grafana — алерты:**

```
⚠️ DNS Resolution Failures: 47%
⚠️ Suspicious DNS Queries: 1,247/hour
⚠️ Cache Poisoning Attempts: 23 detected
```

Erik (хмурится):
> *"Shit. DNS attacks again. Someone is poisoning cache, redirecting our queries. Probably FSB. Viktor mentioned — Крылов?"*

Max (кивает):
> *"Yes. He hunts us."*

Erik:
> *"Then we need to secure DNS. Now."*

**Видеозвонок с командой:**

**Viktor** (из Москвы):
> *"Max, glad you arrived. Erik will guide you through DNS. This is critical — DNS is phone book of internet. If attacker controls DNS, he controls where your traffic goes."*

**Anna** (из Москвы, на фоне серверная):
> *"I'm analyzing logs. Krylov's team is doing cache poisoning. They inject false DNS records. When we query shadow-server-05, we get THEIR server IP. Classic MITM."*

**Alex** (из Москвы):
> *"Max, trust Erik. He's one of best network engineers in Europe. Learn everything."*

Erik:
> *"Okay, Max. Let's start with DNS basics. Then we'll hunt Krylov's fake records."*

---

### LILITH активируется

**LILITH v2.0 (Networking Module):**
> *"DNS — Domain Name System. Humans remember names (google.com), computers need IP addresses (142.250.185.46). DNS translates. Simple concept, but CRITICAL — if DNS is compromised, entire network is vulnerable."*
>
> *"Krylov knows this. He attacks DNS because it's weakest link. Cache poisoning, spoofing, man-in-the-middle. We need to understand DNS deeply to defend."*
>
> *"Erik will teach you commands. I'll teach you concepts. Together — you become DNS expert."*

---

## 🎯 Миссия

**Цель:** Понять DNS, обнаружить DNS spoofing от Krylov, настроить защиту.

**Задачи:**
1. Понять как работает DNS (запросы, рекурсия, кэш)
2. Научиться использовать DNS инструменты (dig, nslookup, host)
3. Проверить DNS записи shadow серверов
4. Обнаружить поддельные DNS ответы (cache poisoning)
5. Настроить локальную резолюцию через `/etc/hosts`
6. Проверить DNSSEC (защита от spoofing)
7. Настроить DNS over TLS (шифрование DNS запросов)
8. Создать DNS security audit отчёт

**Результат:**
- Понимание DNS архитектуры
- Умение диагностировать DNS проблемы
- Навыки обнаружения DNS атак
- Защищённая DNS конфигурация

---

## 📚 Задания

### Задание 1: Базовый DNS lookup ⭐

**Контекст:**
Erik: *"First lesson — DNS lookup. We ask DNS server: 'what is IP of google.com?' Simple query, complex system behind it."*

**Задача:**
Выполните базовый DNS lookup для `google.com` и поймите структуру ответа.

**Попробуйте сами (3-5 минут):**

```bash
# Узнайте IP адрес google.com
# Ваша команда здесь
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**Erik:**
> *"`dig` — DNS lookup utility. Most powerful. Shows full DNS response."*

Попробуйте:
```bash
dig google.com
```

**Что искать в выводе:**
- `QUESTION SECTION` — что мы спросили
- `ANSWER SECTION` — ответ (IP адрес)
- `Query time` — сколько заняло
- `SERVER` — какой DNS сервер ответил

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Команды:**

```bash
# dig (самый детальный)
dig google.com

# Только IP (короткий вывод)
dig +short google.com

# host (простой вариант)
host google.com

# nslookup (старый, но работает)
nslookup google.com
```

**Сравнение:**
```bash
# dig — для профи (детали DNS протокола)
dig google.com

# host — для быстрой проверки
host google.com

# nslookup — deprecated, но все ещё используется
nslookup google.com
```

**Интерпретация dig вывода:**
```
;; QUESTION SECTION:
;google.com.			IN	A

;; ANSWER SECTION:
google.com.		82	IN	A	142.250.185.46

Query time: 23 msec
SERVER: 8.8.8.8#53(8.8.8.8)
```

- `google.com` — домен
- `IN` — Internet class
- `A` — тип записи (IPv4 адрес)
- `142.250.185.46` — результат
- `82` — TTL (time to live, секунды кэша)
- `8.8.8.8` — DNS сервер

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Команда для практики:**
```bash
# Самый детальный вывод
dig google.com

# Только IP (удобно для скриптов)
dig +short google.com

# С указанием конкретного DNS сервера
dig @8.8.8.8 google.com
```

**Объяснение:**
- `dig` — Domain Information Groper
- `@8.8.8.8` — использовать Google Public DNS
- `+short` — показать только результат (IP)
- По умолчанию dig использует DNS сервер из `/etc/resolv.conf`

**Пример вывода:**
```bash
$ dig google.com

; <<>> DiG 9.18.12-0ubuntu0.22.04.1-Ubuntu <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 12345
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; QUESTION SECTION:
;google.com.			IN	A

;; ANSWER SECTION:
google.com.		82	IN	A	142.250.185.46

;; Query time: 23 msec
;; SERVER: 8.8.8.8#53(8.8.8.8) (UDP)
;; WHEN: Wed Oct 11 11:30:00 CEST 2025
;; MSG SIZE  rcvd: 55
```

**Что это значит:**
- Query успешен (`status: NOERROR`)
- Ответ пришёл за 23ms
- IP адрес: `142.250.185.46`
- TTL: 82 секунды (можно кэшировать)

</details>

<details>
<summary>🔍 Что такое DNS? (теория)</summary>

### DNS (Domain Name System)

**Определение:**
DNS — распределённая система имён в сети. Переводит доменные имена (google.com) в IP адреса (142.250.185.46).

**Зачем нужен:**
- Люди плохо запоминают числа: `142.250.185.46`
- Люди хорошо запоминают слова: `google.com`
- DNS — "телефонная книга интернета"

**Как работает (упрощённо):**
```
1. Вы: "Браузер, открой google.com"
2. Браузер: "DNS сервер, какой IP у google.com?"
3. DNS сервер: "Вот: 142.250.185.46"
4. Браузер: "Спасибо!" → подключается к 142.250.185.46
```

**Иерархия DNS:**
```
                    . (root)
                   /    |    \
                 com   org   net
                /  |    \
            google microsoft amazon
             /
          www mail drive
```

**DNS Query Process (детально):**
```
1. Приложение → Resolver (local DNS cache)
2. Если в кэше нет:
   Resolver → Root Server ("где .com?")
   Root → "Спроси TLD сервер .com"
3. Resolver → TLD сервер .com ("где google.com?")
   TLD → "Спроси authoritative сервер google.com"
4. Resolver → Authoritative сервер google.com ("какой IP?")
   Authoritative → "Вот: 142.250.185.46"
5. Resolver → Приложение ("Держи IP")
6. Resolver кэширует ответ (TTL)
```

**Типы DNS записей:**
- **A** — IPv4 адрес (`google.com → 142.250.185.46`)
- **AAAA** — IPv6 адрес (`google.com → 2a00:1450:4001:801::200e`)
- **CNAME** — алиас (`www.google.com → google.com`)
- **MX** — mail server (`google.com → gmail-smtp-in.l.google.com`)
- **TXT** — текстовая информация (SPF, DKIM, verification)
- **NS** — name server (`google.com → ns1.google.com`)
- **SOA** — Start of Authority (информация о зоне)

**DNS Servers:**
- **Recursive Resolver** — делает всю работу за вас (8.8.8.8 — Google DNS)
- **Root Servers** — 13 корневых серверов (A-M.root-servers.net)
- **TLD Servers** — Top Level Domain (.com, .org, .ru)
- **Authoritative Servers** — конечные серверы с ответами

**Кэширование:**
- TTL (Time To Live) — сколько секунд кэшировать
- Ускоряет запросы
- Но создаёт проблему — если IP изменился, кэш ещё старый

**Команды:**
```bash
dig google.com      # Полная информация
host google.com     # Быстрая проверка
nslookup google.com # Старый способ
```

**Файлы конфигурации:**
- `/etc/hosts` — локальная резолюция (проверяется ДО DNS)
- `/etc/resolv.conf` — какие DNS серверы использовать
- `/etc/nsswitch.conf` — порядок резолюции (files → dns)

**Почему DNS критичен для безопасности:**
- Если атакующий контролирует DNS → он контролирует куда идёт трафик
- Cache poisoning — подмена записей в кэше
- DNS spoofing — поддельные ответы
- MITM через DNS — redirect на фишинговый сайт
- DDoS через DNS amplification

**Защита:**
- **DNSSEC** — цифровые подписи (проверка подлинности)
- **DNS over TLS (DoT)** — шифрование запросов (port 853)
- **DNS over HTTPS (DoH)** — DNS через HTTPS (port 443)
- Использовать доверенные DNS серверы

</details>

**Запишите результат:**
```bash
# IP адрес google.com:
GOOGLE_IP="???.???.???.???"
```

---

### Задание 2: DNS lookup для shadow серверов ⭐⭐

**Контекст:**
Erik: *"Now — real task. Check our shadow servers. Viktor's infrastructure uses custom domains: shadow-server-*.ops.internal. These should NOT be visible on public DNS. Let's check."*

**Задача:**
Проверьте DNS записи для серверов операции из `artifacts/dns_zones.txt`.

**Попробуйте сами (5 минут):**

```bash
# Проверьте файл artifacts/dns_zones.txt
# Выполните DNS lookup для первых 3 серверов
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**LILITH:**
> *"`artifacts/dns_zones.txt` содержит список доменов операции. Используй `dig` или `host` для проверки каждого."*

Попробуйте:
```bash
# Посмотреть список серверов
cat artifacts/dns_zones.txt

# Проверить один сервер
dig shadow-server-01.ops.internal

# Проверить с конкретным DNS сервером
dig @8.8.8.8 shadow-server-01.ops.internal
```

**Что ожидать:**
- Если домен `.ops.internal` не в публичном DNS → `NXDOMAIN` (не существует)
- Это нормально — internal домены не должны быть публичными
- В production они резолвятся только через internal DNS сервер

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Команды:**

```bash
# Прочитать список доменов
cat artifacts/dns_zones.txt

# Проверить все домены (цикл)
while read domain; do
    echo "Checking: $domain"
    dig +short "$domain" || echo "  → No DNS record (expected for internal domains)"
done < artifacts/dns_zones.txt
```

**Альтернатива — host:**
```bash
for domain in $(cat artifacts/dns_zones.txt); do
    echo -n "$domain: "
    host "$domain" 2>&1 | grep -q "NXDOMAIN" && echo "Not in public DNS ✓" || host "$domain"
done
```

**Что проверить:**
1. Домены `.ops.internal` НЕ должны быть в публичном DNS
2. Если они есть — это утечка информации!
3. Internal домены должны резолвиться только в private сети

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Скрипт для проверки:**
```bash
#!/bin/bash

dns_zones_file="artifacts/dns_zones.txt"

if [ ! -f "$dns_zones_file" ]; then
    echo "⚠ File not found: $dns_zones_file"
    exit 1
fi

echo "═══════════════════════════════════════════════════════════"
echo "  DNS Lookup: Shadow Servers"
echo "═══════════════════════════════════════════════════════════"
echo ""

count=0
not_found=0

while IFS= read -r domain; do
    # Skip empty lines and comments
    [[ -z "$domain" || "$domain" =~ ^# ]] && continue

    count=$((count + 1))
    echo "[$count] Checking: $domain"

    # Try to resolve
    result=$(dig +short "$domain" 2>/dev/null)

    if [ -z "$result" ]; then
        echo "    Status: NXDOMAIN (not in public DNS) ✓"
        not_found=$((not_found + 1))
    else
        echo "    IP: $result"
        echo "    ⚠️  WARNING: Internal domain is in public DNS!"
    fi
    echo ""
done < "$dns_zones_file"

echo "═══════════════════════════════════════════════════════════"
echo "Summary:"
echo "  Total domains checked: $count"
echo "  Not in public DNS: $not_found (good!)"
echo "  In public DNS: $((count - not_found)) ${((count - not_found > 0)) && echo '(⚠️  security issue!)' || echo '(good!)'}"
echo "═══════════════════════════════════════════════════════════"
```

**Объяснение:**
- `dig +short` — показать только IP (без деталей)
- Если результат пустой → домен не найден (NXDOMAIN)
- Internal домены (`.ops.internal`) НЕ должны быть в публичном DNS
- Если они там → утечка информации о инфраструктуре

**Security note:**
Internal домены должны:
- Резолвиться только в private сети
- Использовать internal DNS сервер
- НЕ быть видимыми из интернета

</details>

**Запишите результат:**
```bash
# Количество серверов без публичных DNS записей (expected):
INTERNAL_DOMAINS_COUNT=???
```

---

### Задание 3: Проверка разных типов DNS записей ⭐⭐

**Контекст:**
Erik: *"DNS is not only about A records (IP addresses). There are many types: MX for mail, TXT for verification, CNAME for aliases. Let's explore."*

**Задача:**
Проверьте различные типы DNS записей для `google.com`: A, AAAA, MX, TXT, NS.

**Попробуйте сами (5-7 минут):**

```bash
# Проверьте A, AAAA, MX, TXT, NS записи для google.com
# Ваши команды здесь
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**Erik:**
> *"`dig` can query specific record types. Use `-t TYPE` or just type name."*

Попробуйте:
```bash
# A record (IPv4)
dig google.com A

# AAAA record (IPv6)
dig google.com AAAA

# MX record (mail servers)
dig google.com MX

# TXT records
dig google.com TXT

# NS records (name servers)
dig google.com NS
```

**Что искать:**
- **A** — IPv4 адрес
- **AAAA** — IPv6 адрес (длинный hex)
- **MX** — mail server с приоритетом (число меньше = выше приоритет)
- **TXT** — текстовые данные (SPF, DKIM, verification tokens)
- **NS** — authoritative name servers для домена

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Команды (короткий вывод):**

```bash
# A records (IPv4)
dig +short google.com A

# AAAA records (IPv6)
dig +short google.com AAAA

# MX records (mail)
dig +short google.com MX

# TXT records
dig +short google.com TXT

# NS records (name servers)
dig +short google.com NS

# Все записи сразу
dig google.com ANY
```

**Интерпретация MX:**
```
10 smtp.google.com.
20 smtp2.google.com.
```
- `10` — приоритет (меньше = выше)
- `smtp.google.com.` — mail server hostname

**Интерпретация TXT:**
```
"v=spf1 include:_spf.google.com ~all"
```
- SPF record — разрешённые mail servers
- Защита от спама/фишинга

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Скрипт для проверки всех типов:**
```bash
#!/bin/bash

domain="google.com"

echo "═══════════════════════════════════════════════════════════"
echo "  DNS Records Check: $domain"
echo "═══════════════════════════════════════════════════════════"
echo ""

# A records (IPv4)
echo "[1] A Records (IPv4):"
dig +short "$domain" A | sed 's/^/    /'
echo ""

# AAAA records (IPv6)
echo "[2] AAAA Records (IPv6):"
dig +short "$domain" AAAA | sed 's/^/    /'
echo ""

# MX records (Mail)
echo "[3] MX Records (Mail Servers):"
dig +short "$domain" MX | sed 's/^/    /'
echo ""

# TXT records
echo "[4] TXT Records:"
dig +short "$domain" TXT | sed 's/^/    /'
echo ""

# NS records (Name Servers)
echo "[5] NS Records (Authoritative Name Servers):"
dig +short "$domain" NS | sed 's/^/    /'
echo ""

# CNAME (alias) — для subdomain
echo "[6] CNAME Check (www.$domain):"
dig +short "www.$domain" CNAME | sed 's/^/    /'
[ -z "$(dig +short "www.$domain" CNAME)" ] && echo "    (no CNAME, direct A record)"
echo ""

echo "═══════════════════════════════════════════════════════════"
```

**Объяснение типов записей:**

**A (Address):**
- IPv4 адрес
- Пример: `142.250.185.46`

**AAAA (IPv6 Address):**
- IPv6 адрес
- Пример: `2a00:1450:4001:801::200e`

**MX (Mail Exchange):**
- Mail servers для домена
- Формат: `приоритет hostname`
- Пример: `10 smtp.google.com.`
- Меньший приоритет = используется первым

**TXT (Text):**
- Произвольный текст
- Используется для:
  - SPF (защита от спама)
  - DKIM (цифровая подпись писем)
  - Domain verification (Google, etc)
  - DMARC (политика email безопасности)

**NS (Name Server):**
- Authoritative DNS серверы для домена
- Пример: `ns1.google.com.`

**CNAME (Canonical Name):**
- Алиас (псевдоним)
- Пример: `www.google.com → google.com`
- Перенаправление на другое доменное имя

</details>

<details>
<summary>🔍 Типы DNS записей (теория)</summary>

### DNS Record Types

**A (Address) Record:**
```
google.com.  IN  A  142.250.185.46
```
- Преобразует имя в IPv4 адрес
- Самый распространённый тип
- Может быть несколько A записей (round-robin load balancing)

**AAAA (IPv6 Address) Record:**
```
google.com.  IN  AAAA  2a00:1450:4001:801::200e
```
- Преобразует имя в IPv6 адрес
- AAAA = 4 раза по A (IPv6 в 4 раза длиннее IPv4)

**CNAME (Canonical Name) Record:**
```
www.google.com.  IN  CNAME  google.com.
```
- Алиас (псевдоним)
- `www.google.com` → `google.com` → IP
- CNAME НЕ может быть на root домене (google.com — нельзя, www.google.com — можно)

**MX (Mail Exchange) Record:**
```
google.com.  IN  MX  10 smtp.google.com.
google.com.  IN  MX  20 smtp2.google.com.
```
- Mail servers для домена
- Приоритет: меньше число = выше приоритет
- Пример: сначала пробуем `smtp.google.com` (10), если не работает → `smtp2.google.com` (20)

**TXT (Text) Record:**
```
google.com.  IN  TXT  "v=spf1 include:_spf.google.com ~all"
```
- Произвольный текст
- Используется для:
  - **SPF** (Sender Policy Framework): какие серверы могут отправлять почту от этого домена
  - **DKIM** (DomainKeys Identified Mail): цифровая подпись писем
  - **DMARC** (Domain-based Message Authentication): политика обработки спама
  - Domain verification (подтверждение владения доменом)

**NS (Name Server) Record:**
```
google.com.  IN  NS  ns1.google.com.
google.com.  IN  NS  ns2.google.com.
```
- Authoritative DNS серверы для домена
- Кто отвечает за этот домен?
- Обычно 2+ для redundancy

**SOA (Start of Authority) Record:**
```
google.com.  IN  SOA  ns1.google.com. dns-admin.google.com. (
    2025100801  ; Serial (версия зоны)
    7200        ; Refresh (как часто slave проверяет master)
    3600        ; Retry (как часто повторять если refresh failed)
    1209600     ; Expire (когда slave перестаёт отвечать)
    3600        ; Minimum TTL
)
```
- Информация о DNS зоне
- Primary name server
- Email администратора
- Параметры синхронизации

**PTR (Pointer) Record:**
```
46.185.250.142.in-addr.arpa.  IN  PTR  google.com.
```
- Reverse DNS lookup (IP → домен)
- Используется для:
  - Email (проверка легитимности mail server)
  - Логи (показывать hostname вместо IP)
  - Security (проверка что IP соответствует домену)

**SRV (Service) Record:**
```
_sip._tcp.example.com.  IN  SRV  10 60 5060 sipserver.example.com.
```
- Указывает hostname + port для сервиса
- Используется для SIP, XMPP, LDAP
- Формат: приоритет, вес, порт, hostname

**CAA (Certification Authority Authorization) Record:**
```
google.com.  IN  CAA  0 issue "pki.goog"
```
- Какие CA могут выдавать SSL сертификаты для домена
- Защита от неавторизованных сертификатов

**Команды проверки:**
```bash
dig google.com A       # IPv4
dig google.com AAAA    # IPv6
dig google.com MX      # Mail
dig google.com TXT     # Text records
dig google.com NS      # Name servers
dig google.com SOA     # Start of Authority
dig -x 142.250.185.46  # Reverse DNS (PTR)
dig google.com ANY     # All records (deprecated)
```

**Security implications:**
- **TXT records** — могут содержать sensitive информацию
- **NS records** — атакующий может узнать DNS провайдера
- **MX records** — информация о mail инфраструктуре
- **A records** — IP адреса серверов

**Best practices:**
- Не публиковать больше информации чем нужно
- Использовать DNSSEC для защиты от подделки
- Регулярно проверять DNS records на утечки
- Минимизировать TTL для critical records (быстрая смена в случае атаки)

</details>

**Запишите результаты:**
```bash
# A record (IPv4):
GOOGLE_A="???.???.???.???"

# MX record (первый mail server):
GOOGLE_MX="???"
```

---

### Задание 4: Reverse DNS Lookup ⭐⭐

**Контекст:**
Katarina Lindström (видеозвонок из Stockholm University):
> *"Erik, introduce me to Max. Hi Max, I'm Katarina, cryptography researcher. Reverse DNS is important — it proves that IP belongs to domain. Critical for email security and forensics."*

**Задача:**
Выполните reverse DNS lookup: по IP адресу узнать доменное имя.

**Попробуйте сами (3-5 минут):**

```bash
# Узнайте доменное имя для IP: 8.8.8.8 (Google DNS)
# Ваша команда здесь
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**Katarina:**
> *"Reverse DNS uses PTR records. IP in special format: reverse octets + `.in-addr.arpa`. For 8.8.8.8 → `8.8.8.8.in-addr.arpa`. But `dig -x` does this automatically."*

Попробуйте:
```bash
# Reverse DNS (автоматически)
dig -x 8.8.8.8

# Или host (проще)
host 8.8.8.8
```

**Что искать:**
- PTR record в ответе
- Hostname для этого IP

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Команды:**

```bash
# dig -x (самый надёжный)
dig -x 8.8.8.8

# Короткий вывод
dig -x 8.8.8.8 +short

# host (простой вариант)
host 8.8.8.8

# nslookup
nslookup 8.8.8.8
```

**Примеры reverse DNS:**
```bash
# Google DNS
dig -x 8.8.8.8
# → dns.google

# Cloudflare DNS
dig -x 1.1.1.1
# → one.one.one.one

# Ваш публичный IP (если есть)
curl -s ifconfig.me | xargs dig -x
```

**Когда reverse DNS важен:**
- **Email** — mail servers проверяют PTR record отправителя
- **Forensics** — по IP узнать откуда атака
- **Logging** — красивые имена в логах вместо IP

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Команда:**
```bash
# Reverse DNS для 8.8.8.8
dig -x 8.8.8.8

# Или короткий вывод
dig -x 8.8.8.8 +short
# Результат: dns.google
```

**Скрипт для проверки нескольких IP:**
```bash
#!/bin/bash

echo "═══════════════════════════════════════════════════════════"
echo "  Reverse DNS Lookup"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Список известных IP
declare -A known_ips=(
    ["8.8.8.8"]="Google DNS"
    ["1.1.1.1"]="Cloudflare DNS"
    ["9.9.9.9"]="Quad9 DNS"
    ["208.67.222.222"]="OpenDNS"
)

for ip in "${!known_ips[@]}"; do
    echo "[$ip] ${known_ips[$ip]}"
    hostname=$(dig -x "$ip" +short 2>/dev/null | head -n1)

    if [ -n "$hostname" ]; then
        echo "    Hostname: $hostname"
    else
        echo "    (no PTR record)"
    fi
    echo ""
done

echo "═══════════════════════════════════════════════════════════"
```

**Объяснение:**
- `dig -x IP` — reverse lookup
- Проверяет PTR record в зоне `.in-addr.arpa`
- Формат: `8.8.8.8` → `8.8.8.8.in-addr.arpa`
- Если PTR есть → возвращает hostname

**Как работает reverse DNS:**
```
Forward DNS:  google.com → 142.250.185.46
Reverse DNS:  142.250.185.46 → ???.google.com

PTR record: 46.185.250.142.in-addr.arpa → lhr25s34-in-f14.1e100.net
```

**Security implications:**
- Отсутствие PTR record — подозрительно для mail server
- Несоответствие forward/reverse — может указывать на spoofing
- Forensics — reverse DNS помогает идентифицировать источник атаки

**Проверка для любого IP:**
```bash
# Ваш публичный IP
my_ip=$(curl -s ifconfig.me)
echo "Your public IP: $my_ip"
echo "Reverse DNS:"
dig -x "$my_ip" +short
```

</details>

<details>
<summary>🔍 Reverse DNS (PTR Records) — теория</summary>

### Reverse DNS (PTR Records)

**Определение:**
Reverse DNS — преобразование IP адреса в доменное имя (обратное от обычного DNS).

**Forward vs Reverse:**
```
Forward:  example.com → 192.0.2.1     (A record)
Reverse:  192.0.2.1 → example.com     (PTR record)
```

**Как работает:**
```
IP: 192.0.2.1
Reverse format: 1.2.0.192.in-addr.arpa

Query: PTR 1.2.0.192.in-addr.arpa
Answer: example.com
```

**Зачем нужен:**

1. **Email Security:**
   - Mail servers проверяют PTR record отправителя
   - Если PTR отсутствует или не соответствует → спам
   - Forward/Reverse должны совпадать

2. **Logging:**
   - Показывать hostname в логах вместо IP
   - Удобнее читать
   - Forensics analysis

3. **Forensics:**
   - По IP атакующего узнать его провайдера
   - Traceback источника атаки
   - Identify malicious infrastructure

4. **Verification:**
   - Подтверждение что IP действительно принадлежит домену
   - Anti-spoofing

**Команды:**
```bash
# dig
dig -x 8.8.8.8

# host
host 8.8.8.8

# nslookup
nslookup 8.8.8.8
```

**Примеры:**
```bash
$ dig -x 8.8.8.8 +short
dns.google

$ dig -x 1.1.1.1 +short
one.one.one.one
```

**Forward-Reverse Match:**
```bash
# Forward
$ dig +short google.com
142.250.185.46

# Reverse
$ dig -x 142.250.185.46 +short
lhr25s34-in-f14.1e100.net

# Not exact match (Google uses different hostnames), but same domain zone
```

**Security implications:**
- **Missing PTR** — suspicious (особенно для mail servers)
- **Mismatched PTR** — возможен spoofing
- **Generic PTR** (192-0-2-1.example.com) — не настроен правильно

**Best practices:**
- Настроить PTR для всех публичных mail servers
- Forward и Reverse должны соответствовать
- Проверять PTR при forensics анализе
- Использовать в firewall rules (rate limit по hostname)

</details>

**Запишите результат:**
```bash
# Reverse DNS для 8.8.8.8:
GOOGLE_DNS_HOSTNAME="???"
```

---

### Задание 5: Локальная резолюция через /etc/hosts ⭐⭐

**Контекст:**
Erik: *"Sometimes we need to override DNS without waiting for propagation. `/etc/hosts` — local DNS. Checked BEFORE real DNS query. Very useful for testing and security."*

**Задача:**
Добавьте локальную DNS запись в `/etc/hosts` для тестового домена `shadow-test.local`.

**Попробуйте сами (5-7 минут):**

```bash
# 1. Сделайте backup /etc/hosts
# 2. Добавьте запись: shadow-test.local → 127.0.0.1
# 3. Проверьте что ping shadow-test.local работает
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**Erik:**
> *"`/etc/hosts` — простой текстовый файл. Формат: `IP hostname`. Проверяется ДО DNS запроса."*

Попробуйте:
```bash
# Backup (важно!)
sudo cp /etc/hosts /etc/hosts.backup

# Добавить запись
echo "127.0.0.1 shadow-test.local" | sudo tee -a /etc/hosts

# Проверить
ping -c 2 shadow-test.local
```

**Что происходит:**
1. OS читает `/etc/hosts`
2. Находит `shadow-test.local → 127.0.0.1`
3. НЕ делает DNS запрос
4. Возвращает 127.0.0.1

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Команды:**

```bash
# 1. Backup
sudo cp /etc/hosts /etc/hosts.backup

# 2. Проверить текущее содержимое
cat /etc/hosts

# 3. Добавить запись (несколько способов)

# Способ 1: echo + tee
echo "127.0.0.1 shadow-test.local" | sudo tee -a /etc/hosts

# Способ 2: sudo редактор
sudo nano /etc/hosts
# Добавить строку вручную: 127.0.0.1 shadow-test.local

# 4. Проверить что добавилось
grep "shadow-test" /etc/hosts

# 5. Тест
ping -c 2 shadow-test.local
host shadow-test.local  # не сработает (т.к. не в DNS)
```

**Формат /etc/hosts:**
```
# IP_ADDRESS    HOSTNAME    [ALIASES...]
127.0.0.1       localhost
127.0.1.1       your-hostname
192.168.1.100   myserver.local myserver
```

**Приоритет резолюции (по умолчанию):**
1. `/etc/hosts` — сначала локальный файл
2. DNS — если в hosts не найдено

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Скрипт:**
```bash
#!/bin/bash

hosts_file="/etc/hosts"
backup_file="/etc/hosts.backup"
test_domain="shadow-test.local"
test_ip="127.0.0.1"

echo "═══════════════════════════════════════════════════════════"
echo "  /etc/hosts Configuration"
echo "═══════════════════════════════════════════════════════════"
echo ""

# 1. Backup
echo "[1] Creating backup..."
sudo cp "$hosts_file" "$backup_file"
echo "    ✓ Backup saved: $backup_file"
echo ""

# 2. Check if entry already exists
if grep -q "$test_domain" "$hosts_file"; then
    echo "[2] Entry already exists in /etc/hosts"
    grep "$test_domain" "$hosts_file" | sed 's/^/    /'
else
    # 3. Add entry
    echo "[2] Adding entry: $test_ip $test_domain"
    echo "$test_ip $test_domain" | sudo tee -a "$hosts_file" > /dev/null
    echo "    ✓ Entry added"
fi
echo ""

# 4. Verify
echo "[3] Verifying /etc/hosts content:"
grep "$test_domain" "$hosts_file" | sed 's/^/    /'
echo ""

# 5. Test with ping
echo "[4] Testing with ping:"
if ping -c 2 -W 1 "$test_domain" &>/dev/null; then
    echo "    ✓ $test_domain resolves to $test_ip"
    echo "    (ping successful)"
else
    echo "    ✗ Ping failed (but resolution might still work)"
fi
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "Cleanup (when done):"
echo "  sudo cp $backup_file $hosts_file"
echo "═══════════════════════════════════════════════════════════"
```

**Объяснение:**
- `/etc/hosts` — локальная резолюция имён
- Проверяется ДО DNS запроса
- Не требует DNS сервера
- root права нужны для редактирования

**Как работает резолюция:**
```
1. Приложение: "Дай IP для shadow-test.local"
2. OS: Проверяю /etc/hosts... Есть! 127.0.0.1
3. OS → Приложение: "Держи 127.0.0.1"
4. (DNS запрос НЕ делается)
```

**Use cases:**
- **Testing** — тестировать до DNS propagation
- **Development** — локальные dev домены (myproject.local)
- **Security** — блокировать malware домены (redirect на 127.0.0.1)
- **Performance** — кэшировать часто используемые домены

**Security warning:**
- Если attacker получит root — он может изменить `/etc/hosts`
- Redirect на malicious IP
- MITM атака
- Проверяйте integrity регулярно

**Cleanup:**
```bash
# Restore from backup
sudo cp /etc/hosts.backup /etc/hosts
```

</details>

<details>
<summary>🔍 /etc/hosts — теория</summary>

### /etc/hosts — Local DNS Resolution

**Определение:**
`/etc/hosts` — текстовый файл для локальной резолюции имён (без DNS сервера).

**Формат:**
```
IP_ADDRESS    HOSTNAME    [ALIASES...]

# Примеры:
127.0.0.1     localhost
127.0.1.1     mycomputer
192.168.1.10  server.local server srv
```

**Как работает:**
```
1. Приложение запрашивает IP для hostname
2. OS читает /etc/nsswitch.conf → узнаёт порядок резолюции
3. По умолчанию: files dns (сначала files = /etc/hosts, потом dns)
4. OS читает /etc/hosts
5. Если hostname найден → возвращает IP (DNS НЕ вызывается)
6. Если не найден → DNS запрос
```

**Priority:**
```
/etc/nsswitch.conf:
  hosts: files dns

Означает:
  1. /etc/hosts (files)
  2. DNS
```

**Можно изменить:**
```
hosts: dns files  # Сначала DNS, потом /etc/hosts
```

**Use Cases:**

1. **Development:**
   ```
   127.0.0.1  myproject.local
   127.0.0.1  api.myproject.local
   ```

2. **Testing:**
   ```
   192.168.1.100  staging.example.com
   ```
   Тестировать до DNS propagation

3. **Security (Ad Blocking):**
   ```
   0.0.0.0  ads.doubleclick.net
   0.0.0.0  tracker.example.com
   ```
   Блокировать malware/ads домены

4. **Performance:**
   ```
   142.250.185.46  google.com
   ```
   Кэшировать часто используемые домены (но TTL = вечность)

**Security Implications:**

**Attack vector:**
- Если attacker получит root → может изменить `/etc/hosts`
- Redirect на malicious IP
- MITM (man-in-the-middle)
- Phishing (redirect bank.com на фишинговый сайт)

**Defense:**
- Мониторить changes в `/etc/hosts`
- File integrity monitoring (AIDE, Tripwire)
- Read-only filesystem (для critical systems)
- Регулярные проверки

**Best Practices:**
- Всегда делать backup перед изменением
- Документировать все custom entries
- Не использовать для production DNS
- Проверять integrity регулярно

**Команды:**
```bash
# Просмотр
cat /etc/hosts

# Backup
sudo cp /etc/hosts /etc/hosts.backup

# Добавить запись
echo "192.168.1.100 myserver.local" | sudo tee -a /etc/hosts

# Удалить запись
sudo sed -i '/myserver.local/d' /etc/hosts

# Restore
sudo cp /etc/hosts.backup /etc/hosts
```

**Related files:**
- `/etc/nsswitch.conf` — order of resolution
- `/etc/resolv.conf` — DNS servers
- `/etc/hostname` — hostname этой машины

</details>

**Проверка:**
```bash
# После добавления записи
ping -c 2 shadow-test.local
# Должно работать!
```

---

### Задание 6: Обнаружение DNS Spoofing ⭐⭐⭐

**Контекст:**
Anna (видеозвонок из Москвы):
> *"Max, I found evidence. Krylov's team is poisoning DNS cache. When we query shadow-server-05, sometimes we get WRONG IP. Cache poisoning attack. You need to detect this."*

**Задача:**
Проверьте `artifacts/suspicious_domains.txt` на DNS spoofing — сравните ожидаемые и фактические IP.

**Попробуйте сами (7-10 минут):**

```bash
# Файл artifacts/suspicious_domains.txt содержит список доменов
# Для каждого указан expected_ip
# Проверьте что DNS возвращает правильные IP
```

<details>
<summary>💡 Подсказка 1 (если застряли > 7 минут)</summary>

**LILITH:**
> *"DNS spoofing detection — сравнить expected IP с actual IP. Если не совпадают → атака. Проверь каждый домен из suspicious_domains.txt."*

Попробуйте:
```bash
# Прочитать файл
cat artifacts/suspicious_domains.txt

# Формат: domain expected_ip
# Пример: shadow-server-05.ops.internal 10.50.1.105

# Для каждого домена:
# 1. Узнать actual IP (dig)
# 2. Сравнить с expected
# 3. Если не совпадают → spoofing!
```

**Базовый алгоритм:**
```bash
while read domain expected_ip; do
    actual_ip=$(dig +short "$domain" | head -n1)
    if [ "$actual_ip" != "$expected_ip" ]; then
        echo "⚠️  SPOOFING DETECTED: $domain"
    fi
done < artifacts/suspicious_domains.txt
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 15 минут)</summary>

**Полный скрипт проверки:**

```bash
#!/bin/bash

file="artifacts/suspicious_domains.txt"

echo "Checking for DNS Spoofing..."
echo ""

spoofed=0
clean=0

while IFS=' ' read -r domain expected_ip; do
    # Skip comments and empty lines
    [[ "$domain" =~ ^# || -z "$domain" ]] && continue

    echo "Checking: $domain"
    echo "  Expected: $expected_ip"

    # Get actual IP
    actual_ip=$(dig +short "$domain" 2>/dev/null | grep -E "^[0-9]+" | head -n1)

    if [ -z "$actual_ip" ]; then
        echo "  Actual:   NXDOMAIN (not in DNS)"
        echo "  Status:   OK (internal domain)"
        clean=$((clean + 1))
    elif [ "$actual_ip" = "$expected_ip" ]; then
        echo "  Actual:   $actual_ip"
        echo "  Status:   ✓ OK"
        clean=$((clean + 1))
    else
        echo "  Actual:   $actual_ip"
        echo "  Status:   ⚠️  SPOOFED!"
        spoofed=$((spoofed + 1))
    fi
    echo ""
done < "$file"

echo "════════════════════════════════════════"
echo "Results:"
echo "  Clean domains:  $clean"
echo "  Spoofed:        $spoofed"
[ $spoofed -gt 0 ] && echo "  ⚠️  DNS ATTACK DETECTED!"
echo "════════════════════════════════════════"
```

**Что проверять:**
- Actual IP совпадает с Expected → OK
- Actual IP отличается → SPOOFED
- NXDOMAIN (не в DNS) → OK для internal доменов

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Production-ready скрипт:**
```bash
#!/bin/bash

suspicious_file="artifacts/suspicious_domains.txt"
report_file="artifacts/dns_spoofing_report.txt"

if [ ! -f "$suspicious_file" ]; then
    echo "⚠ File not found: $suspicious_file"
    exit 1
fi

echo "═══════════════════════════════════════════════════════════"
echo "  DNS Spoofing Detection"
echo "  File: $suspicious_file"
echo "  Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo "═══════════════════════════════════════════════════════════"
echo ""

spoofed=0
clean=0
declare -a spoofed_list

{
    echo "DNS SPOOFING DETECTION REPORT"
    echo "Generated: $(date)"
    echo "─────────────────────────────────────────────────────────────"
    echo ""
} > "$report_file"

while IFS=' ' read -r domain expected_ip comment; do
    # Skip comments and empty lines
    [[ "$domain" =~ ^# || -z "$domain" ]] && continue

    echo "[CHECK] $domain"
    echo "        Expected: $expected_ip"

    # Get actual IP (timeout 3 sec)
    actual_ip=$(timeout 3 dig +short +tries=2 +time=2 "$domain" 2>/dev/null | grep -E "^[0-9]+\." | head -n1)

    if [ -z "$actual_ip" ]; then
        echo "        Actual:   NXDOMAIN (not in public DNS)"
        echo "        Status:   ✓ OK (internal domain)"
        echo ""
        clean=$((clean + 1))

        {
            echo "$domain: OK (not in DNS)"
        } >> "$report_file"
    elif [ "$actual_ip" = "$expected_ip" ]; then
        echo "        Actual:   $actual_ip"
        echo "        Status:   ✓ OK"
        echo ""
        clean=$((clean + 1))

        {
            echo "$domain: OK ($actual_ip)"
        } >> "$report_file"
    else
        echo "        Actual:   $actual_ip"
        echo "        Status:   ⚠️  SPOOFED!"
        echo "        ⚠️  POSSIBLE CACHE POISONING!"
        echo ""
        spoofed=$((spoofed + 1))
        spoofed_list+=("$domain")

        {
            echo "⚠️  $domain: SPOOFED!"
            echo "    Expected: $expected_ip"
            echo "    Actual:   $actual_ip"
            echo ""
        } >> "$report_file"
    fi
done < "$suspicious_file"

# Summary
echo "═══════════════════════════════════════════════════════════"
echo "SUMMARY:"
echo "  Total domains checked:  $((clean + spoofed))"
echo "  Clean:                  $clean"
echo "  Spoofed:                $spoofed"
echo ""

if [ $spoofed -gt 0 ]; then
    echo "⚠️  DNS ATTACK DETECTED!"
    echo ""
    echo "Spoofed domains:"
    for d in "${spoofed_list[@]}"; do
        echo "  - $d"
    done
    echo ""
    echo "Recommended actions:"
    echo "  1. Flush DNS cache: sudo systemd-resolve --flush-caches"
    echo "  2. Use trusted DNS: 8.8.8.8 (Google), 1.1.1.1 (Cloudflare)"
    echo "  3. Enable DNSSEC"
    echo "  4. Report to Anna (forensics)"
else
    echo "✓ All domains clean. No spoofing detected."
fi

echo "═══════════════════════════════════════════════════════════"
echo "Report saved: $report_file"
```

**Объяснение:**
- Читаем список доменов с expected IP
- Для каждого делаем DNS lookup
- Сравниваем actual vs expected
- Если не совпадают → spoofing!
- Генерируем отчёт для Anna

**DNS Spoofing techniques:**
1. **Cache Poisoning** — inject false records в DNS cache
2. **MITM** — перехват DNS запросов, поддельные ответы
3. **Rogue DNS Server** — подменить `/etc/resolv.conf`

**Defense:**
- **DNSSEC** — проверка цифровых подписей
- **DNS over TLS/HTTPS** — шифрование запросов
- **Trusted DNS servers** — использовать проверенные (8.8.8.8, 1.1.1.1)
- **Monitoring** — детекция аномалий в DNS ответах

</details>

<details>
<summary>🔍 DNS Spoofing & Cache Poisoning — теория</summary>

### DNS Spoofing Attacks

**DNS Spoofing (DNS Hijacking):**
Атака где attacker подменяет DNS ответы, redirect жертву на malicious IP.

**Типы атак:**

**1. Cache Poisoning:**
```
1. Attacker: отправляет DNS query на resolver
2. Attacker: быстро отправляет поддельные ответы (guessing transaction ID)
3. Resolver: кэширует поддельный ответ
4. Жертвы: получают поддельный IP из кэша
```

**2. MITM (Man-in-the-Middle):**
```
1. Жертва → DNS query → Attacker (перехват)
2. Attacker → поддельный ответ → Жертва
3. Жертва подключается к malicious IP
```

**3. Rogue DNS Server:**
```
1. Attacker получает root на жертве
2. Изменяет /etc/resolv.conf → malicious DNS server
3. Все DNS запросы идут через attacker
```

**4. Local /etc/hosts Poisoning:**
```
1. Attacker получает root
2. Изменяет /etc/hosts:
   93.184.216.34  bank.com  # phishing site
3. Жертва заходит на bank.com → попадает на фишинг
```

**Real-world example (Kaminsky Attack, 2008):**
Dan Kaminsky нашёл способ массово отравить DNS cache. Если успешно — можно redirect весь трафик домена.

**Защита:**

**1. DNSSEC (DNS Security Extensions):**
- Цифровые подписи DNS records
- Проверка аутентичности
- Защита от cache poisoning

**Проверка DNSSEC:**
```bash
dig +dnssec google.com

# Ищите:
# - RRSIG records (подписи)
# - AD flag (Authenticated Data)
```

**2. DNS over TLS (DoT):**
- Port 853
- TLS encryption
- Защита от MITM

**3. DNS over HTTPS (DoH):**
- Port 443 (HTTPS)
- Невозможно отличить от обычного HTTPS трафика
- Privacy

**4. Trusted DNS Resolvers:**
- **8.8.8.8** — Google Public DNS (DNSSEC enabled)
- **1.1.1.1** — Cloudflare (privacy-focused)
- **9.9.9.9** — Quad9 (malware blocking)

**Detection:**

**Signs of DNS spoofing:**
- Unexpected IP addresses
- SSL certificate errors (HTTPS site, wrong cert)
- Redirect на незнакомые сайты
- Different results from different DNS servers

**Monitoring:**
```bash
# Проверить несколько DNS серверов
dig @8.8.8.8 example.com
dig @1.1.1.1 example.com
dig @9.9.9.9 example.com

# Если результаты разные → возможен spoofing
```

**Mitigation:**

**Для пользователя:**
- Использовать DNSSEC-validating resolver
- DNS over TLS/HTTPS
- Проверять SSL сертификаты
- VPN с trusted DNS

**Для администратора:**
- Включить DNSSEC на authoritative сервере
- Monitoring DNS responses
- Rate limiting
- Anomaly detection

**Krylov's Attack (сюжет):**
- Cache poisoning на public DNS resolvers
- Когда Max запрашивает shadow-server-05 → получает IP под контролем Krylov
- MITM → Krylov может читать весь трафик
- Defense: DNSSEC + DoT + internal DNS

</details>

**Результат:**
```bash
# Количество spoofed доменов (если есть):
SPOOFED_COUNT=???
```

---

### Задание 7: DNSSEC — проверка безопасности ⭐⭐⭐

**Контекст:**
Katarina (звонок из Stockholm University):
> *"Max, DNS spoofing is possible because DNS is not authenticated. DNSSEC adds digital signatures to DNS records. If domain has DNSSEC — we can verify authenticity. Check which domains are protected."*

**Задача:**
Проверьте DNSSEC (DNS Security Extensions) для нескольких доменов.

**Попробуйте сами (7-10 минут):**

```bash
# Проверьте DNSSEC для:
# - google.com
# - cloudflare.com
# - example.com
```

<details>
<summary>💡 Подсказка 1 (если застряли > 7 минут)</summary>

**Katarina:**
> *"`dig +dnssec` shows DNS security extensions. Look for RRSIG records (signatures) and AD flag (Authenticated Data)."*

Попробуйте:
```bash
# Проверка DNSSEC
dig +dnssec google.com

# Что искать:
# 1. RRSIG records — цифровые подписи
# 2. AD flag в header — Authenticated Data
# 3. DNSKEY records — публичные ключи
```

**Интерпретация:**
- Есть RRSIG + AD flag → DNSSEC работает ✓
- Нет RRSIG → DNSSEC не включён ✗

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 15 минут)</summary>

**Команды:**

```bash
# DNSSEC check (детальный)
dig +dnssec google.com

# DNSSEC validation check
dig +dnssec +multi google.com

# Проверить только наличие DNSSEC
dig +dnssec google.com | grep -E "(RRSIG|AD)"

# Проверить DNSKEY (публичные ключи)
dig DNSKEY google.com
```

**Скрипт для batch проверки:**
```bash
#!/bin/bash

domains=("google.com" "cloudflare.com" "example.com")

for domain in "${domains[@]}"; do
    echo "Checking DNSSEC for: $domain"

    # Check for RRSIG
    if dig +dnssec "$domain" | grep -q "RRSIG"; then
        echo "  ✓ DNSSEC enabled (RRSIG found)"
    else
        echo "  ✗ DNSSEC not enabled"
    fi

    # Check AD flag
    if dig +dnssec "$domain" | grep -q " ad;"; then
        echo "  ✓ AD flag set (Authenticated Data)"
    fi
    echo ""
done
```

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Production-ready DNSSEC checker:**
```bash
#!/bin/bash

echo "═══════════════════════════════════════════════════════════"
echo "  DNSSEC Security Check"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Test domains
declare -a test_domains=(
    "google.com"
    "cloudflare.com"
    "example.com"
    "github.com"
    "linux.org"
)

secure_count=0
insecure_count=0

for domain in "${test_domains[@]}"; do
    echo "[CHECK] $domain"

    # Get DNS response with DNSSEC
    response=$(dig +dnssec +noall +answer "$domain" A 2>/dev/null)
    header=$(dig +dnssec +noall +comments "$domain" A 2>/dev/null | head -5)

    # Check for RRSIG (signature)
    has_rrsig=false
    if echo "$response" | grep -q "RRSIG"; then
        has_rrsig=true
    fi

    # Check for AD flag (Authenticated Data)
    has_ad=false
    if echo "$header" | grep -q " ad;"; then
        has_ad=true
    fi

    # Verdict
    if $has_rrsig && $has_ad; then
        echo "        Status: ✓ DNSSEC ENABLED & VALIDATED"
        echo "        - RRSIG found (digital signatures)"
        echo "        - AD flag set (authenticated)"
        secure_count=$((secure_count + 1))
    elif $has_rrsig; then
        echo "        Status: ⚠️  DNSSEC ENABLED but not validated"
        echo "        - RRSIG found"
        echo "        - AD flag missing (resolver doesn't validate)"
        secure_count=$((secure_count + 1))
    else
        echo "        Status: ✗ DNSSEC NOT ENABLED"
        echo "        - No RRSIG (no signatures)"
        echo "        - Vulnerable to spoofing"
        insecure_count=$((insecure_count + 1))
    fi
    echo ""
done

# Summary
echo "═══════════════════════════════════════════════════════════"
echo "SUMMARY:"
echo "  Total domains checked:  ${#test_domains[@]}"
echo "  DNSSEC enabled:         $secure_count"
echo "  DNSSEC not enabled:     $insecure_count"
echo ""

if [ $insecure_count -gt 0 ]; then
    echo "⚠️  Some domains are vulnerable to DNS spoofing!"
    echo ""
    echo "Recommendation:"
    echo "  - Use DNSSEC-validating DNS resolver (8.8.8.8, 1.1.1.1)"
    echo "  - Enable DNSSEC on your own domains"
    echo "  - Consider DNS over TLS (DoT) or DNS over HTTPS (DoH)"
fi

echo "═══════════════════════════════════════════════════════════"
```

**Объяснение DNSSEC:**

**Что это:**
- Digital signatures для DNS records
- Проверка подлинности ответов
- Защита от cache poisoning

**Как работает:**
```
1. Domain owner подписывает DNS records приватным ключом
2. Публичный ключ публикуется в DNSKEY record
3. Resolver скачивает DNSKEY
4. Resolver проверяет подпись (RRSIG)
5. Если подпись валидна → устанавливает AD flag
```

**Проверка вручную:**
```bash
# 1. Проверить DNSSEC
dig +dnssec google.com

# 2. Искать в выводе:
# ;; flags: qr rd ra ad;  ← AD flag (Authenticated Data)
#
# ANSWER SECTION:
# google.com. 82 IN A 142.250.185.46
# google.com. 82 IN RRSIG ... ← подпись
```

**RRSIG record:**
```
google.com. 82 IN RRSIG A 8 2 300 20251108050000 20251016040000 12345 google.com. [base64-signature]
```
- `RRSIG` — подпись для A record
- `8` — алгоритм (RSA/SHA-256)
- `300` — original TTL
- `20251108...` — expiration
- `[base64...]` — цифровая подпись

**Security benefits:**
- ✓ Защита от cache poisoning
- ✓ Аутентичность DNS ответов
- ✓ Цепочка trust от root до домена
- ✗ Не шифрует запросы (используйте DoT/DoH)

</details>

<details>
<summary>🔍 DNSSEC — теория</summary>

### DNSSEC (DNS Security Extensions)

**Проблема:**
DNS изначально не аутентифицирован — любой может отправить поддельный ответ.

**Решение:**
DNSSEC добавляет цифровые подписи к DNS records.

**Как работает:**

**1. Zone Signing:**
```
Domain owner:
  1. Генерирует пару ключей (private/public)
  2. Подписывает все DNS records приватным ключом
  3. Публикует DNSKEY (публичный ключ) и RRSIG (подписи)
```

**2. Validation:**
```
Resolver:
  1. Запрашивает DNS record + DNSSEC data
  2. Получает RRSIG (подпись) и DNSKEY (публичный ключ)
  3. Проверяет подпись публичным ключом
  4. Если валидна → устанавливает AD flag (Authenticated Data)
  5. Если не валидна → SERVFAIL (блокирует ответ)
```

**3. Chain of Trust:**
```
Root (.)
  ↓ (подписывает)
.com
  ↓ (подписывает)
google.com
  ↓ (подписывает)
www.google.com
```

Каждый уровень подписывает следующий → цепочка доверия от root до конечного домена.

**DNS Security Records:**

**DNSKEY:**
- Публичный ключ домена
- Используется для проверки подписей
- Пример: `dig DNSKEY google.com`

**RRSIG:**
- Цифровая подпись DNS record
- Создаётся приватным ключом
- Проверяется публичным (DNSKEY)

**DS (Delegation Signer):**
- Hash публичного ключа
- Публикуется в parent зоне (.com для google.com)
- Связывает child зону с parent

**NSEC/NSEC3:**
- Proof of non-existence
- Доказывает что record НЕ существует
- NSEC3 — улучшенная версия (privacy)

**Пример валидации:**

```bash
$ dig +dnssec google.com

;; flags: qr rd ra ad;  ← AD flag = authenticated!

;; ANSWER SECTION:
google.com.  82  IN  A  142.250.185.46
google.com.  82  IN  RRSIG A 8 2 300 ... ← подпись A record
```

**Команды:**

```bash
# Проверить DNSSEC
dig +dnssec google.com

# Проверить только валидацию
dig +dnssec +cd google.com  # CD = Check Disabled

# DNSKEY
dig DNSKEY google.com

# DS record (в parent зоне)
dig DS google.com
```

**Advantages:**
- ✓ Защита от cache poisoning
- ✓ Аутентичность ответов
- ✓ Integrity (данные не изменены)

**Limitations:**
- ✗ НЕ шифрует запросы (DoT/DoH для privacy)
- ✗ Overhead (больше данных, медленнее)
- ✗ Complexity (сложнее настроить)
- ✗ Breaking changes (если key rotation сломан → домен down)

**Deployment:**
- ~40% top domains имеют DNSSEC (2025)
- Root zone подписана с 2010
- Все TLDs (.com, .org, etc) поддерживают

**Best Practices:**
- Включить DNSSEC на своих доменах
- Использовать DNSSEC-validating resolver
- Automated key rotation
- Мониторинг expiration dates
- Backup keys

**Related Technologies:**
- **DNS over TLS (DoT):** DNSSEC + шифрование (port 853)
- **DNS over HTTPS (DoH):** DNSSEC + HTTPS (port 443)

</details>

**Результат:**
```bash
# Количество доменов с DNSSEC:
DNSSEC_ENABLED=???
```

---

### Задание 8: Финальный DNS Security Audit ⭐⭐⭐

**Контекст:**
Erik: *"Max, good progress. Now — final task. Create comprehensive DNS security audit report. Viktor needs it for operation security assessment."*

**Задача:**
Создайте bash скрипт `dns_audit.sh`, который интегрирует все предыдущие 7 заданий и генерирует детальный DNS security audit отчёт.

**Попробуйте сами (20-30 минут):**

Интегрируйте всё что изучили:
1. DNS lookup для shadow servers (Задание 2)
2. Проверка разных типов records (Задание 3)
3. Reverse DNS (Задание 4)
4. /etc/hosts configuration (Задание 5)
5. DNS spoofing detection (Задание 6)
6. DNSSEC validation (Задание 7)
7. Генерация отчёта в `artifacts/dns_security_report.txt`

```bash
# Создайте скрипт dns_audit.sh
# Используйте starter.sh как шаблон
```

<details>
<summary>💡 Подсказка 1 (если застряли > 15 минут)</summary>

**LILITH:**
> *"Интеграция — это не просто копипаст. Создай функции для каждого задания, потом вызови их последовательно. Каждая функция должна return результат."*

**Структура:**
```bash
#!/bin/bash
set -e

# Global variables
REPORT_FILE="artifacts/dns_security_report.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Function 1: Check shadow servers (Task 2)
check_shadow_servers() {
    # Your code from Task 2
}

# Function 2: Check DNS records (Task 3)
check_dns_records() {
    # Your code from Task 3
}

# Function 3: Reverse DNS (Task 4)
check_reverse_dns() {
    # Your code from Task 4
}

# Function 4: DNS spoofing detection (Task 6)
detect_dns_spoofing() {
    # Your code from Task 6
}

# Function 5: DNSSEC check (Task 7)
check_dnssec() {
    # Your code from Task 7
}

# Function 6: Generate report
generate_report() {
    # Combine all results
}

# Main
main() {
    echo "DNS Security Audit..."

    result1=$(check_shadow_servers)
    result2=$(check_dns_records)
    # ...

    generate_report "$result1" "$result2" ...
}

main "$@"
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 30 минут)</summary>

**Конкретная реализация key functions:**

```bash
#!/bin/bash

# Check shadow servers
check_shadow_servers() {
    local file="artifacts/dns_zones.txt"
    local not_found=0

    while IFS= read -r domain; do
        [[ -z "$domain" || "$domain" =~ ^# ]] && continue

        result=$(dig +short "$domain" 2>/dev/null)
        if [ -z "$result" ]; then
            not_found=$((not_found + 1))
        fi
    done < "$file"

    echo "$not_found"  # Return count
}

# DNS spoofing detection
detect_dns_spoofing() {
    local file="artifacts/suspicious_domains.txt"
    local spoofed=0

    while IFS=' ' read -r domain expected_ip; do
        [[ "$domain" =~ ^# || -z "$domain" ]] && continue

        actual_ip=$(dig +short "$domain" 2>/dev/null | head -n1)
        if [ -n "$actual_ip" ] && [ "$actual_ip" != "$expected_ip" ]; then
            spoofed=$((spoofed + 1))
        fi
    done < "$file"

    echo "$spoofed"  # Return spoofed count
}

# DNSSEC check
check_dnssec() {
    local domains=("google.com" "cloudflare.com" "example.com")
    local secure=0

    for domain in "${domains[@]}"; do
        if dig +dnssec "$domain" 2>/dev/null | grep -q "RRSIG"; then
            secure=$((secure + 1))
        fi
    done

    echo "$secure"  # Return secure count
}

# Generate report
generate_report() {
    local shadow_ok=$1
    local spoofed=$2
    local dnssec_count=$3

    {
        echo "═══════════════════════════════════════════════════════════"
        echo "           DNS SECURITY AUDIT REPORT"
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        echo "Date:       $(date)"
        echo "Location:   Bahnhof Pionen, Stockholm, Sweden"
        echo "Operator:   Max Sokolov"
        echo ""
        echo "[1] Shadow Servers: $shadow_ok not in public DNS ✓"
        echo "[2] DNS Spoofing:   $spoofed domains spoofed"
        [ $spoofed -gt 0 ] && echo "    ⚠️  ATTACK DETECTED!"
        echo "[3] DNSSEC:         $dnssec_count/3 domains secured"
        echo ""
        echo "═══════════════════════════════════════════════════════════"
    } > "artifacts/dns_security_report.txt"
}

# Main
main() {
    echo "Running DNS Security Audit..."

    shadow_ok=$(check_shadow_servers)
    spoofed=$(detect_dns_spoofing)
    dnssec=$(check_dnssec)

    generate_report "$shadow_ok" "$spoofed" "$dnssec"

    echo "✓ Report: artifacts/dns_security_report.txt"
}

main "$@"
```

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Посмотрите референсное решение:**
```bash
cat solution/dns_audit.sh
```

Или запустите:
```bash
./solution/dns_audit.sh
```

**Ключевые моменты:**
1. **Модульность:** Каждая функция = одна задача
2. **Error handling:** Проверка exit codes
3. **Reporting:** Детальный и структурированный отчёт
4. **Security focus:** Приоритет на обнаружение угроз

**Формат отчёта (пример):**
```
═══════════════════════════════════════════════════════════════
           DNS SECURITY AUDIT REPORT
═══════════════════════════════════════════════════════════════

Date:       2025-10-11 14:00:00
Location:   Bahnhof Pionen, Stockholm, Sweden 🇸🇪
Operator:   Max Sokolov
Day:        11 of 60 (KERNEL SHADOWS Operation)

════════════════════════════════════════════════════════════════

[1] SHADOW SERVERS CHECK
    Total internal domains:  15
    Not in public DNS:       15 ✓
    Status:                  ✓ SECURE (no information leaks)

[2] DNS RECORDS ANALYSIS
    Domains checked:         3
    A records:               3/3 ✓
    AAAA records:            2/3
    MX records:              3/3 ✓
    TXT records:             3/3 ✓
    NS records:              3/3 ✓

[3] REVERSE DNS
    IPs checked:             4
    PTR records found:       4/4 ✓
    All reverse lookups valid

[4] DNS SPOOFING DETECTION
    Suspicious domains:      10
    Spoofed domains:         0 ✓
    Status:                  ✓ NO ATTACK DETECTED

    (or if attack detected:)
    Spoofed domains:         2 ⚠️
    Status:                  ⚠️ CACHE POISONING DETECTED!
    Affected:
      - shadow-server-05.ops.internal
      - shadow-server-08.ops.internal

[5] DNSSEC VALIDATION
    Domains checked:         3
    DNSSEC enabled:          2/3
    Protected:
      ✓ google.com
      ✓ cloudflare.com
      ✗ example.com (not protected)

[6] /ETC/HOSTS CONFIGURATION
    Local overrides:         1
    Test domain:             shadow-test.local → 127.0.0.1 ✓

════════════════════════════════════════════════════════════════

SECURITY ASSESSMENT:

Overall Status: ⚠️  MEDIUM RISK

Issues Found:
  - 2 domains affected by DNS spoofing (cache poisoning)
  - 1 domain without DNSSEC protection

Recommendations:
  1. URGENT: Flush DNS cache on all workstations
     sudo systemd-resolve --flush-caches

  2. Switch to trusted DNS resolvers:
     - 8.8.8.8 (Google Public DNS)
     - 1.1.1.1 (Cloudflare)

  3. Enable DNSSEC validation in /etc/resolv.conf

  4. Consider DNS over TLS (Episode 08)

  5. Report DNS spoofing to Anna (forensics analysis)

════════════════════════════════════════════════════════════════

Next Steps:
  - Episode 07: Firewalls & iptables (return to Moscow)
  - Configure firewall rules to block malicious IPs
  - Rate limiting for DDoS protection

Generated by: dns_audit.sh
Episode: 06 — DNS & Name Resolution
Location: Stockholm, Sweden 🇸🇪

END OF REPORT
```

**Что проверить в вашем решении:**
- ✅ Все 7 функций реализованы
- ✅ Отчёт генерируется в `artifacts/dns_security_report.txt`
- ✅ Детальная статистика по каждому разделу
- ✅ Security assessment с рекомендациями
- ✅ Error handling для missing files
- ✅ Красивое форматирование

</details>

**Требования к финальному скрипту:**
1. Интегрирует ВСЕ 7 предыдущих заданий
2. Генерирует детальный security audit report
3. Обрабатывает ошибки (fallback'ы)
4. Security assessment + recommendations
5. Красивое форматирование

---

## 🎬 Эпилог

### День 11, 18:00 — Bahnhof Pionen

Erik просматривает отчёт Max:
> *"Good work, Max. Your DNS audit is comprehensive. Krylov's cache poisoning is now documented. Anna can use this for forensics."*

**Видеозвонок с командой:**

**Anna** (из Москвы):
> *"Max, excellent report. I found Krylov's DNS server IP in dark web marketplace. He's renting botnet for cache poisoning. We need to block these IPs in firewall — that's Episode 07."*

**Viktor:**
> *"Max, stay in Stockholm for one more day. Erik will teach you firewalls. Then you return to Moscow — we'll implement iptables rules to protect our infrastructure."*

**Alex:**
> *"Little brother becoming professional. Proud of you. But be careful — Krylov knows you're in Sweden. He's watching."*

Katarina Lindström (в офисе Erik):
> *"Max, before you go — let me show you DNS over TLS. Privacy is not optional anymore. Episode 08, okay?"*

Erik:
> *"Max — welcome to Sweden anytime. You're good engineer. Viktor chose right person."*

**Max (думает):**
> *"Две недели назад я не знал что такое DNS. Сейчас я детектирую cache poisoning в международной инфраструктуре. LILITH была права — технология — универсальный язык."*

**LILITH:**
> *"DNS — телефонная книга интернета. Но если книга поддельная — весь интернет становится опасным. Ты научился проверять подлинность. Это критический навык. Следующий шаг — firewalls. Защита периметра."*

---

## 🎓 Чему вы научились

### DNS Fundamentals:
- Как работает DNS (recursive resolver, authoritative servers)
- DNS hierarchy (root → TLD → authoritative)
- DNS records (A, AAAA, CNAME, MX, TXT, NS, SOA, PTR)

### DNS Tools:
- `dig` — DNS lookup (детальный)
- `host` — простой lookup
- `nslookup` — legacy tool
- `dig +dnssec` — проверка DNSSEC

### DNS Configuration:
- `/etc/hosts` — локальная резолюция
- `/etc/resolv.conf` — DNS серверы
- `/etc/nsswitch.conf` — порядок резолюции

### DNS Security:
- DNS spoofing detection
- Cache poisoning атаки
- DNSSEC (цифровые подписи)
- DNS over TLS/HTTPS (шифрование)

### Практические навыки:
- DNS troubleshooting
- Security audit
- Forensics analysis
- Reporting

---

## 📖 Дополнительные материалы

### Команды DNS (справочник):

```bash
# Basic lookup
dig google.com
host google.com
nslookup google.com

# Specific record types
dig google.com A      # IPv4
dig google.com AAAA   # IPv6
dig google.com MX     # Mail
dig google.com TXT    # Text
dig google.com NS     # Name servers

# Reverse DNS
dig -x 8.8.8.8

# DNSSEC
dig +dnssec google.com
dig DNSKEY google.com
dig DS google.com

# Short output
dig +short google.com

# Specific DNS server
dig @8.8.8.8 google.com
dig @1.1.1.1 google.com

# Trace DNS resolution
dig +trace google.com
```

### Публичные DNS серверы:

```bash
# Google Public DNS
8.8.8.8 / 8.8.4.4  (IPv4)
2001:4860:4860::8888 / ::8844  (IPv6)
DNSSEC: Yes

# Cloudflare
1.1.1.1 / 1.0.0.1  (IPv4)
2606:4700:4700::1111 / ::1001  (IPv6)
DNSSEC: Yes, Privacy-focused

# Quad9
9.9.9.9 / 149.112.112.112  (IPv4)
2620:fe::fe / ::9  (IPv6)
DNSSEC: Yes, Malware blocking

# OpenDNS
208.67.222.222 / 208.67.220.220  (IPv4)
DNSSEC: Yes, Content filtering
```

### Следующие шаги:
- **Episode 07:** Firewalls & iptables (защита от атак)
- **Episode 08:** VPN & SSH Tunneling (шифрование трафика)
- Интеграция DNS + Firewall + VPN = secure infrastructure

---

## ✅ Проверка понимания

Прежде чем продолжать, убедитесь что вы понимаете:

1. ✅ Как работает DNS (query, recursion, caching)
2. ✅ Разницу между A, AAAA, CNAME, MX, TXT, NS records
3. ✅ Что такое reverse DNS и зачем он нужен
4. ✅ Как работает /etc/hosts и priority resolution
5. ✅ Что такое DNS spoofing и cache poisoning
6. ✅ Как DNSSEC защищает от подделки
7. ✅ Как обнаружить DNS атаки

**Тест:** Попробуйте объяснить:
- Почему DNS критичен для безопасности?
- Как работает DNSSEC chain of trust?
- Что делать если обнаружен DNS spoofing?

---

*"DNS — это не просто телефонная книга. Это фундамент доверия в интернете. Если DNS скомпрометирован — весь трафик под угрозой."* — Erik Johansson

**Episode 06 Complete!** ✓

**Next:** Episode 07 — Firewalls & iptables (return to Moscow) 🇷🇺

---

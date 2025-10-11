# Episode 06: DNS & Name Resolution

**KERNEL SHADOWS — Season 2: Networking**

```
╔═══════════════════════════════════════════════════════════════╗
║  Episode 06: DNS & Name Resolution                            ║
║                                                               ║
║  Location: Stockholm, Sweden 🇸🇪                              ║
║  Datacenter: Bahnhof Pionen (30 метров под землёй)           ║
║  Day: 10-12 of 60                                             ║
║  Type: Type B (Linux DNS Tools Configuration) 🔧              ║
║  Difficulty: ⭐⭐☆☆☆                                          ║
║  Time: 3-4 hours                                              ║
╚═══════════════════════════════════════════════════════════════╝
```

---

## 🎬 Пролог: Добро пожаловать в Стокгольм

### День 10, 08:00 — Arlanda Airport, Stockholm

Самолёт приземляется в Arlanda. Макс впервые за границей. Вчера — Москва, сегодня — Швеция.

**Терминал Arrivals:**

Высокий швед в чёрной куртке Bahnhof держит табличку: **"Max Sokolov — Shadow Ops"**.

**Erik Johansson** (38, блондин, спокойный):
> *"Welcome to Sweden, Max. Viktor says you're good with Linux. I'm Erik, network engineer at Bahnhof. Our car is outside."*

**По дороге в Bahnhof Pionen:**

Erik:
> *"You know what Pionen is? Cold War nuclear bunker, 30 meters underground. We converted it into datacenter in 2008. Privacy-first. After WikiLeaks, Swedish government wanted access to our servers. We refused. Privacy is not negotiable."*

Макс (впечатлён):
> *"Nuclear bunker? Serious?"*

Erik:
> *"Very serious. Rock walls, waterfall inside, submarine engine for backup power. James Bond movie, but real."*

---

### 10:30 — Bahnhof Pionen Datacenter

**Вход через скалу.** Бетонный тоннель вниз. Холод. Звук воды. Неоновое освещение.

**Зона серверов:** Футуристичный дизайн внутри скалы. Серверные стойки светятся синим. Искусственный водопад. +15°C.

**На мониторе Grafana — алерты:**

```
⚠️ DNS Resolution Failures: 47%
⚠️ Suspicious DNS Queries: 1,247/hour
⚠️ Cache Poisoning Attempts: 23 detected
```

Erik (хмурится):
> *"Shit. DNS attacks again. Someone is poisoning cache. Probably FSB. Viktor mentioned — Крылов?"*

Max (кивает):
> *"Yes. He hunts us."*

Erik:
> *"Then we need to secure DNS. Now."*

**Видеозвонок с командой:**

**Виктор** (из Москвы):
> *"Макс, Эрик проведёт тебя через DNS. Это критично — DNS это телефонная книга интернета. Если атакующий контролирует DNS, он контролирует куда идёт твой трафик."*

**Анна** (forensics):
> *"Я анализирую логи. Команда Крылова делает cache poisoning. Классический MITM."*

**LILITH v2.0 активируется:**
> *"DNS — Domain Name System. Humans remember names, computers need IP addresses. DNS translates. Simple concept, CRITICAL vulnerability. Krylov knows this."*

---

## 🎯 Миссия: Type B Episode (DNS Tools Configuration)

**Философия Type B:**
```
Episode 04 (Package Management):  apt exists → use it, don't wrap it ✅
Episode 06 (DNS Resolution):      dig exists → use it, don't wrap it ✅
```

**Вы будете:**
- ✅ Использовать DNS инструменты напрямую (dig, host, systemd-resolved)
- ✅ Конфигурировать DNS (/etc/resolv.conf, /etc/hosts, systemd)
- ✅ Анализировать DNS ответы руками
- ❌ НЕ писать bash wrapper вокруг dig (это Type A — неправильно для DNS!)

**Type B vs Type A:**

| Task | Type A ❌ | Type B ✅ |
|------|----------|----------|
| Package install | bash wrapper для apt | `apt install` напрямую |
| DNS lookup | bash wrapper для dig | `dig` напрямую |
| DNS config | bash парсит /etc/resolv.conf | Редактируешь /etc/resolv.conf |
| Report | bash генерирует отчёт | bash генерирует отчёт (OK!) |

**В этом эпизоде:** Linux SysAdmin конфигурирует DNS, не оборачивает dig в bash. 🔧

---

## Цикл 1: DNS Basics — Телефонная книга интернета (10-15 мин)

### 🎬 Сюжет (2 мин)

Erik садится за терминал:
> *"First lesson — DNS lookup. We ask DNS server: 'what is IP of google.com?' Simple query, complex system behind it."*

### 📚 Теория: DNS как телефонная книга (5-7 мин)

#### Метафора: DNS = Телефонная книга интернета 📖☎️

**Представь:**
- У тебя есть телефонная книга (DNS)
- В ней имена → номера телефонов
- Хочешь позвонить "Пицца Марио" → смотришь в книгу → получаешь номер 8-800-123-45-67

**В интернете:**
```
Ты вводишь:     google.com
DNS переводит:  142.250.185.46
Браузер идёт:   на IP адрес
```

**Без DNS:**
```bash
# Нужно было бы помнить IP всех сайтов
http://142.250.185.46    # google.com
http://31.13.71.36       # facebook.com
http://104.244.42.193    # twitter.com
```

Невозможно запомнить! DNS решает эту проблему.

#### ASCII: DNS Translation Process

```
┌─────────────┐
│  Browser    │ "Хочу на google.com"
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ DNS Resolver│ "Ищу IP для google.com..."
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ DNS Server  │ "google.com = 142.250.185.46"
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Browser    │ Подключается к 142.250.185.46
└─────────────┘
```

#### LILITH комментирует:

> **LILITH:** *"DNS — это не просто команда. Это trust system всего интернета. Если DNS врёт — весь трафик идёт куда угодно. Крылов это знает."*

#### Основные понятия:

**1. DNS Query (запрос):**
```bash
Вопрос: "Что такое google.com?"
Ответ:  "142.250.185.46"
```

**2. DNS Record (запись):**
```
google.com.  300  IN  A  142.250.185.46
│            │    │   │  │
│            │    │   │  └─ IP адрес
│            │    │   └──── Тип записи (A = Address)
│            │    └──────── Class (IN = Internet)
│            └───────────── TTL (Time To Live, 300 секунд)
└────────────────────────── Имя домена
```

**3. DNS Tools в Ubuntu:**
```bash
dig              # Самый детальный (для профи) ✅
host             # Быстрая проверка
nslookup         # Старый, но работает
systemd-resolved # Ubuntu default resolver (важно!) ✅
```

> **LILITH:** *"`dig` — твой основной инструмент. Всё остальное — для ленивых. Учи `dig`."*

### 💻 Практика: Первый DNS lookup (3-5 мин)

Erik:
> *"Try this. Query google.com. Observe response."*

#### Задание:

```bash
# 1. Базовый dig
dig google.com

# Что искать в выводе:
# - QUESTION SECTION  → что мы спросили
# - ANSWER SECTION    → ответ (IP адрес)
# - Query time        → скорость ответа
# - SERVER            → кто ответил
```

**Разбор вывода:**

```bash
$ dig google.com

;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             240     IN      A       142.250.185.46

;; Query time: 23 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
```

**Что это значит:**
- `240` — TTL (кеш на 240 секунд)
- `A` — Address record (IPv4)
- `23 msec` — быстро (< 100 мс = хорошо)
- `8.8.8.8` — Google Public DNS

#### Варианты использования dig:

```bash
# Короткий вывод (только IP)
dig +short google.com

# Трассировка (как DNS резолвит)
dig +trace google.com

# Указать конкретный DNS сервер
dig @8.8.8.8 google.com
dig @1.1.1.1 google.com         # Cloudflare DNS
```

> **LILITH:** *"Быстрый DNS = < 50 мс. Медленный = 100+ мс. Если видишь 500+ мс — либо проблемы, либо атака. Запомни."*

### 🤔 Проверка понимания (1 мин)

**Erik спрашивает:** *"What is TTL? Why does it matter?"*

<details>
<summary>🤔 Думай 30 секунд перед проверкой</summary>

**Ответ:**

**TTL (Time To Live)** — время жизни DNS записи в кеше.

**Пример:**
```
google.com.  300  IN  A  142.250.185.46
             ^^^
             TTL = 300 секунд = 5 минут
```

**Что происходит:**
1. Первый запрос → DNS сервер → ответ → кеш на 300 секунд
2. Следующие запросы (5 минут) → берутся из кеша (быстро!)
3. Через 5 минут → кеш устаревает → новый запрос к DNS серверу

**Почему важно:**
- **Низкий TTL (60):** Быстрые обновления, но больше нагрузка на DNS
- **Высокий TTL (86400 = 24ч):** Меньше запросов, но медленные изменения

> **LILITH:** *"Крылов любит cache poisoning. Подделывает один ответ → TTL 3600 = 1 час × 10,000 пользователей = катастрофа. Вот почему TTL критичен."*

</details>

---

## Цикл 2: Shadow Servers Check — Скрытые домены (10-15 мин)

### 🎬 Сюжет (2 мин)

Erik:
> *"Our infrastructure uses internal domains: shadow-server-01.ops.internal. They should NOT be in public DNS. If public DNS knows them — information leak. Or worse — Krylov replaced records."*

### 📚 Теория: Public vs Private DNS (5-7 мин)

#### Метафора: Unlisted Phone Numbers 🔒

**Представь:**
- **Public DNS** = Телефонная книга в библиотеке (все видят)
- **Private DNS** = Твой личный блокнот (только ты знаешь)

**Shadow infrastructure:**
```
Public:   shadow-ops.com          → 203.0.113.42   (OK, видят все)
Private:  shadow-server-01.internal → 10.50.1.15   (НЕ должно быть публично!)
```

**Если shadow-server-01.internal в PUBLIC DNS:**
- ❌ Информационная утечка
- ❌ Крылов узнаёт структуру инфраструктуры
- ❌ Возможны атаки на internal домены

#### DNS Zones типы:

```
.com, .org, .net     → Public TLD (Top Level Domain)
.internal, .local    → Private (RFC 6762, должны быть только внутри сети)
.ops.internal        → Ваш internal zone
```

> **LILITH:** *"`.internal` домены в публичном DNS = как номер твоей банковской карты в телефонной книге. Глупо. Опасно."*

#### Проверка shadow серверов:

**Цель:** Убедиться что shadow-server-*.ops.internal НЕ в public DNS.

**Ожидаемый результат:**
```bash
$ dig shadow-server-01.ops.internal

;; ANSWER SECTION:
# ПУСТО — это хорошо! Нет ответа = не утечка
```

**Плохой результат:**
```bash
;; ANSWER SECTION:
shadow-server-01.ops.internal. 300 IN A 10.50.1.15

# ⚠️ УТЕЧКА! Private IP в public DNS!
```

#### systemd-resolved (Ubuntu default):

Ubuntu использует **systemd-resolved** как default DNS resolver.

```bash
# Проверить статус
resolvectl status

# Query через systemd-resolved
resolvectl query google.com

# Flush cache (если нужно)
resolvectl flush-caches
```

> **LILITH:** *"`systemd-resolved` — стандарт Ubuntu. Не игнорируй его. Учи."*

### 💻 Практика: Проверка shadow domains (3-5 мин)

#### Задание:

```bash
# 1. Проверить shadow servers из списка
cd artifacts/
cat dns_zones.txt

# 2. Для каждого домена проверить PUBLIC DNS
dig shadow-server-01.ops.internal
dig shadow-server-02.ops.internal
# ... продолжить для всех

# 3. Убедиться что ANSWER SECTION пустой (хорошо!)
#    Если есть ответ → УТЕЧКА! → сообщить команде

# 4. Использовать systemd-resolved тоже
resolvectl query shadow-server-01.ops.internal
```

**Erik:**
> *"If you see answer — we have problem. Internal domains must stay internal."*

#### Автоматизация проверки (bash OK для такого!):

```bash
# Простой loop для проверки списка
while read domain; do
    [[ "$domain" =~ ^# ]] && continue  # Skip comments
    result=$(dig +short "$domain" 2>/dev/null)
    if [ -n "$result" ]; then
        echo "⚠️  LEAK: $domain → $result"
    else
        echo "✓ OK: $domain (not in public DNS)"
    fi
done < artifacts/dns_zones.txt
```

> **LILITH:** *"Bash loop для автоматизации повторяющихся команд — ОК. Но не пиши bash wrapper для замены dig. Понял разницу?"*

### 🤔 Проверка понимания (1 мин)

**Katarina** (криптограф, подходит):
> *"Max, why `.internal` domains dangerous in public DNS?"*

<details>
<summary>🤔 Думай перед ответом</summary>

**Ответ:**

**3 причины:**

1. **Information Disclosure:**
   - Крылов видит структуру инфраструктуры
   - Знает количество серверов
   - Видит naming conventions

2. **Attack Surface:**
   - Public DNS → можно атаковать через DNS
   - Cache poisoning становится возможным
   - DNS amplification attacks

3. **Trust Violation:**
   - `.internal` означает "только для нас"
   - Если в public DNS → кто-то слил данные
   - Или misconfiguration (плохо!)

**Erik:**
> *"In security, information is power. Every leaked detail helps attacker. Keep internal internal."*

> **LILITH:** *"Крылов собирает информацию как пазл. Одна утечка DNS = один кусочек. 100 утечек = полная картина. Zero tolerance для утечек."*

</details>

---

## Цикл 3: DNS Record Types — Различные типы записей (10-15 мин)

### 🎬 Сюжет (2 мин)

Erik открывает whiteboard:
> *"DNS is not just IP addresses. Many record types — A, AAAA, MX, NS, TXT, CNAME. Each has purpose. Let me show you."*

### 📚 Теория: DNS Record Types (5-7 мин)

#### Метафора: Разные страницы в справочнике 📔

**Представь телефонную книгу компании:**
- **A record** = Основной номер офиса
- **MX record** = Номер почтового отделения (mail)
- **NS record** = Номер справочной службы
- **TXT record** = Заметки и пометки

#### ASCII: DNS Record Types Structure

```
┌────────────────────────────────────────┐
│         DNS Record Types               │
├────────┬───────────────────────────────┤
│ A      │ IPv4 Address                  │
│ AAAA   │ IPv6 Address                  │
│ MX     │ Mail Exchange (почта)         │
│ NS     │ Name Server (DNS сервер)      │
│ CNAME  │ Canonical Name (алиас)        │
│ TXT    │ Text (любая информация)       │
│ PTR    │ Pointer (reverse DNS)         │
│ SOA    │ Start of Authority            │
└────────┴───────────────────────────────┘
```

#### Детальный разбор:

**1. A Record (Address) — IPv4:**
```bash
$ dig A google.com +short
142.250.185.46
```

**2. AAAA Record — IPv6:**
```bash
$ dig AAAA google.com +short
2a00:1450:4001:830::200e
```

> **LILITH:** *"IPv6 — будущее. IPv4 адреса закончились в 2011. Учи оба."*

**3. MX Record (Mail Exchange):**

Указывает куда слать email.

```bash
$ dig MX gmail.com +short
5 gmail-smtp-in.l.google.com.
10 alt1.gmail-smtp-in.l.google.com.
20 alt2.gmail-smtp-in.l.google.com.
```

**Цифра = приоритет:**
- `5` = первый (lowest number = highest priority!)
- `10` = backup
- `20` = второй backup

#### "Aha!" момент: MX Priority counterintuitive! 💡

```
❌ Думаешь: "10 > 5, значит 10 важнее"
✅ Reality: "10 > 5, значит 10 МЕНЕЕ важен"

Правило: LOWER number = HIGHER priority

5  = PRIMARY mail server   (попробуй сначала)
10 = BACKUP                (если 5 недоступен)
20 = LAST RESORT           (если 5 и 10 не работают)
```

> **LILITH:** *"Я знаю, counterintuitive. Почему так? Historical reasons. Просто запомни: меньше = важнее."*

**4. NS Record (Name Server):**

Кто отвечает за DNS этого домена.

```bash
$ dig NS google.com +short
ns1.google.com.
ns2.google.com.
ns3.google.com.
ns4.google.com.
```

**5. CNAME (Canonical Name) — Alias:**

```bash
$ dig CNAME www.github.com +short
github.com.

# www.github.com → алиас для github.com
```

**6. TXT Record — Любая текстовая информация:**

```bash
$ dig TXT google.com +short
"v=spf1 include:_spf.google.com ~all"
"docusign=05958488-4752-4ef2-95eb-aa7ba8a3bd0e"
```

**Используется для:**
- SPF (защита от спама)
- DKIM (подпись email)
- Domain verification (доказать владение доменом)
- Site verification

> **LILITH:** *"TXT records = metadata. Спамеры и хакеры читают их. Не пиши там секреты."*

### 💻 Практика: Проверка разных типов (3-5 мин)

Erik:
> *"Try different record types. Understand what each tells you."*

#### Задание:

```bash
# 1. A record (IPv4)
dig A google.com

# 2. AAAA record (IPv6)
dig AAAA google.com

# 3. MX records (mail)
dig MX gmail.com

# 4. NS records (DNS servers)
dig NS google.com

# 5. TXT records (metadata)
dig TXT google.com

# 6. Для shadow servers (если есть internal DNS)
dig A shadow-server-01.ops.internal
dig MX ops.internal
```

#### Специальный query: ALL records

```bash
# Показать все типы сразу
dig ANY google.com

# (Deprecated в новых версиях DNS, но работает)
```

#### systemd-resolved syntax:

```bash
# Через systemd-resolved (Ubuntu way)
resolvectl query google.com
resolvectl query --type=MX gmail.com
resolvectl query --type=TXT google.com
```

> **LILITH:** *"В реальной работе 90% времени используешь A и AAAA records. Остальные — для специальных задач. Но знать все типы обязательно."*

### 🤔 Проверка понимания (1 мин)

**Erik:** *"I give you MX records with priorities 10, 20, 5. Which server gets mail first?"*

<details>
<summary>🤔 Думай перед ответом</summary>

**Ответ:**

**Сервер с приоритетом 5!**

```
Приоритеты: 10, 20, 5

Порядок попыток:
1. Приоритет 5  (lowest = first)
2. Приоритет 10 (backup)
3. Приоритет 20 (last resort)
```

**Правило:** Lower number = Higher priority (контринтуитивно, но так работает!)

**Реальный пример:**
```bash
$ dig MX gmail.com +short
5 gmail-smtp-in.l.google.com.          # PRIMARY
10 alt1.gmail-smtp-in.l.google.com.    # BACKUP 1
20 alt2.gmail-smtp-in.l.google.com.    # BACKUP 2
```

**Erik:**
> *"Good. Historical design — lower number tried first. Like queue number at doctor — 1 goes before 2."*

> **LILITH:** *"Если MX records перепутаны — письма идут на backup, а primary простаивает. Performance падает. Будь внимателен."*

</details>

---

## Цикл 4: Reverse DNS & PTR Records — Обратный lookup (10-15 мин)

### 🎬 Сюжет (2 мин)

Анна (в видеозвонке):
> *"Макс, я нашла подозрительный IP в логах: 185.220.101.52. Нужно идентифицировать. Сделай reverse DNS lookup — IP → hostname. Возможно, это Крылов."*

### 📚 Теория: Reverse DNS (PTR Records) (5-7 мин)

#### Метафора: Обратный поиск в телефонной книге 🔄

**Normal DNS (Forward):**
```
Имя → Номер
"Пицца Марио" → 8-800-123-45-67
```

**Reverse DNS:**
```
Номер → Имя
8-800-123-45-67 → "Пицца Марио"
```

**В интернете:**
```bash
Forward:  google.com        → 142.250.185.46
Reverse:  142.250.185.46    → google.com
```

#### PTR Record (Pointer):

**Специальный тип DNS записи для reverse lookup.**

```bash
# Forward DNS
dig google.com
→ 142.250.185.46

# Reverse DNS
dig -x 142.250.185.46
→ lhr25s34-in-f14.1e100.net.  # Google's PTR record
```

#### Зачем нужен Reverse DNS?

**1. Email серверы проверяют PTR:**
```
Сервер Gmail получает email от IP 203.0.113.50
→ Делает reverse DNS: 203.0.113.50 → ???
→ Если PTR отсутствует → подозрительно → SPAM
→ Если PTR = mail.example.com → легитимно → OK
```

> **LILITH:** *"Почтовые серверы без правильного PTR = автоматически спам. Настраивай PTR для любого mail server."*

**2. Forensics & Security:**
```bash
# Подозрительный IP в логах
185.220.101.52

# Reverse DNS → узнаем hostname
dig -x 185.220.101.52
→ tor-exit-node.example.com

# Aha! Это Tor exit node (анонимизация)
# Высокая вероятность что Крылов использует Tor
```

**3. Network troubleshooting:**
```bash
# Ping неизвестного IP
ping 8.8.8.8

# Что это за сервер?
dig -x 8.8.8.8
→ dns.google.

# Aha! Google Public DNS
```

#### ASCII: Reverse DNS Structure

```
Normal DNS:    example.com      →  93.184.216.34
                      ↓               ↓
Reverse DNS:   34.216.184.93.in-addr.arpa  →  example.com
                      ↑
               IP в обратном порядке!
```

#### Синтаксис Reverse DNS:

```bash
# dig -x (автоматически преобразует)
dig -x 93.184.216.34

# Или вручную (редко нужно):
dig PTR 34.216.184.93.in-addr.arpa
```

> **LILITH:** *"`-x` = удобно. Используй его. Вручную PTR queries — для мазохистов."*

### 💻 Практика: Reverse DNS для подозрительного IP (3-5 мин)

Анна:
> *"Проверь этот IP: 185.220.101.52. Нашла в логах атаки."*

#### Задание:

```bash
# 1. Reverse DNS для подозрительного IP
dig -x 185.220.101.52

# 2. Что получаешь в ANSWER SECTION?
# Если hostname содержит "tor", "exit", "proxy" → подозрительно

# 3. Forward DNS для проверки
# Если PTR вернул hostname → проверь обратно
dig <hostname_from_ptr>

# 4. Должны совпадать (forward = reverse)
```

**Реальный пример:**

```bash
$ dig -x 185.220.101.52

;; ANSWER SECTION:
52.101.220.185.in-addr.arpa. 3600 IN PTR tor-exit-5-readme.dfri.se.

# Aha! Tor exit node из Швеции!
```

**Анна:**
> *"Tor exit node. Крылов использует Tor для анонимности. Умный ублюдок."*

#### Проверка shadow servers:

```bash
# Reverse DNS для shadow servers
dig -x 10.50.1.15    # shadow-server-01
dig -x 10.50.1.16    # shadow-server-02

# Должны вернуть internal hostnames
```

> **LILITH:** *"Forward DNS и Reverse DNS должны совпадать. Если не совпадают — misconfiguration или подозрительная активность."*

### 🤔 Проверка понимания (1 мин)

**Erik:** *"You see IP 203.0.113.42 in logs. How to find what server it is?"*

<details>
<summary>🤔 Думай перед ответом</summary>

**Ответ:**

**Reverse DNS lookup с помощью dig -x:**

```bash
dig -x 203.0.113.42
```

**Вывод покажет PTR record:**
```
;; ANSWER SECTION:
42.113.0.203.in-addr.arpa. 3600 IN PTR server42.ops.internal.
```

**Hostname = `server42.ops.internal`**

**Дополнительная проверка:**
```bash
# Forward DNS для проверки совпадения
dig A server42.ops.internal
→ 203.0.113.42

# Если совпадает → всё правильно ✓
```

**Erik:**
> *"Correct. Reverse DNS = forensics tool. Always check unknown IPs in logs."*

> **LILITH:** *"В реальной работе 50% IP не имеют PTR records. Это нормально для клиентских машин. Но для серверов PTR обязателен."*

</details>

---

## Цикл 5: /etc/hosts & /etc/resolv.conf — Локальная DNS конфигурация (10-15 мин)

### 🎬 Сюжет (2 мин)

Erik:
> *"Sometimes DNS is slow. Or compromised. Local `/etc/hosts` file overrides DNS. Fast. Reliable. But dangerous — malware loves it."*

### 📚 Теория: Local DNS Configuration (5-7 мин)

#### Метафора: Личный блокнот vs Телефонная книга 📓

**Представь:**
- **Телефонная книга в библиотеке** = DNS сервер (общедоступно)
- **Твой личный блокнот** = /etc/hosts (только у тебя)

**Когда ты ищешь номер:**
1. Сначала смотришь в СВОЙ блокнот (/etc/hosts)
2. Если нет → идёшь в библиотеку (DNS)

**Твой блокнот всегда сильнее книги!**

#### Priority Order в Linux:

```bash
1. /etc/hosts           # Локальный файл (highest priority!)
2. systemd-resolved     # Ubuntu DNS resolver
3. /etc/resolv.conf     # DNS servers configuration
4. DNS servers          # External (8.8.8.8, 1.1.1.1, etc.)
```

#### ASCII: DNS Resolution Priority

```
┌─────────────────┐
│  Application    │ "Нужен IP для google.com"
└────────┬────────┘
         ▼
┌─────────────────┐
│  /etc/hosts     │ Есть google.com здесь?
└────────┬────────┘
         │ Да → вернуть IP (STOP!)
         │ Нет → дальше
         ▼
┌─────────────────┐
│systemd-resolved │ Query DNS server
└────────┬────────┘
         ▼
┌─────────────────┐
│ /etc/resolv.conf│ Какой DNS server?
│ nameserver 8.8.8.8
└────────┬────────┘
         ▼
┌─────────────────┐
│  DNS Server     │ 8.8.8.8 → ответ
│  (8.8.8.8)      │
└─────────────────┘
```

#### /etc/hosts — Static DNS

**Формат:**
```
IP_ADDRESS    HOSTNAME    [ALIASES]
```

**Пример:**
```bash
$ cat /etc/hosts

127.0.0.1       localhost
127.0.1.1       maxlaptop

# Shadow servers (internal)
10.50.1.15      shadow-server-01.ops.internal shadow-01
10.50.1.16      shadow-server-02.ops.internal shadow-02
10.50.1.17      shadow-server-03.ops.internal shadow-03
```

**Использование:**
```bash
# Вместо IP можно использовать hostname
ssh shadow-server-01.ops.internal
# или alias
ssh shadow-01

# Resolve через /etc/hosts (не DNS!)
ping shadow-01
```

> **LILITH:** *"`/etc/hosts` = корень доступ к DNS. Malware это знает. Проверяй этот файл регулярно."*

#### "Aha!" момент: /etc/hosts Malware Priority! 💡

```
Malware тактика:

1. Проникает в систему
2. Редактирует /etc/hosts:

   185.220.101.52  facebook.com
   185.220.101.52  gmail.com
   185.220.101.52  banking.com

3. Теперь ВСЕ запросы к этим сайтам идут на IP атакующего!
4. DNS не проверяется (hosts имеет приоритет)
5. Пользователь видит "facebook.com" но подключается к фишинг-сайту
```

**Защита:**
```bash
# Проверить /etc/hosts на подозрительные записи
sudo cat /etc/hosts | grep -v "^#" | grep -v "^$"

# Сделать immutable (только root может менять)
sudo chattr +i /etc/hosts

# Проверить permissions (должен быть 644, owner root)
ls -l /etc/hosts
```

> **LILITH:** *"DNS poisoning через /etc/hosts = старая атака, но работает до сих пор. Проверяй этот файл при любой аномалии."*

#### /etc/resolv.conf — DNS Configuration

**Конфигурирует какие DNS серверы использовать.**

**Пример:**
```bash
$ cat /etc/resolv.conf

# Ubuntu systemd-resolved
nameserver 127.0.0.53           # systemd-resolved stub
options edns0 trust-ad

# Или напрямую external DNS:
nameserver 8.8.8.8              # Google Public DNS
nameserver 1.1.1.1              # Cloudflare DNS
nameserver 208.67.222.222       # OpenDNS

search ops.internal example.com  # Search domains
```

**Параметры:**
- `nameserver` — DNS сервер для запросов
- `search` — домены для автодополнения
- `options` — дополнительные опции

#### systemd-resolved (Ubuntu default):

**Ubuntu использует systemd-resolved как DNS resolver.**

```bash
# Статус
resolvectl status

# Query
resolvectl query google.com

# Статистика
resolvectl statistics

# Flush DNS cache
resolvectl flush-caches

# Конфигурация DNS servers
resolvectl dns eth0 8.8.8.8 1.1.1.1
```

**Конфигурация файл:**
```bash
/etc/systemd/resolved.conf

[Resolve]
DNS=8.8.8.8 1.1.1.1
FallbackDNS=208.67.222.222
DNSOverTLS=opportunistic
```

> **LILITH:** *"`systemd-resolved` — Ubuntu standard. Не борись с ним, используй его. DNSOverTLS = шифрование DNS queries (защита от прослушки)."*

### 💻 Практика: Конфигурирование локального DNS (3-5 мин)

Erik:
> *"Add shadow servers to /etc/hosts. Bypass DNS. Faster. More control."*

#### Задание:

```bash
# 1. Backup /etc/hosts
sudo cp /etc/hosts /etc/hosts.backup

# 2. Добавить shadow servers
sudo nano /etc/hosts

# Добавить строки:
10.50.1.15   shadow-server-01.ops.internal shadow-01
10.50.1.16   shadow-server-02.ops.internal shadow-02
10.50.1.17   shadow-server-03.ops.internal shadow-03

# 3. Проверить
cat /etc/hosts | grep shadow

# 4. Тест (должен работать БЕЗ DNS!)
ping shadow-01
ssh shadow-01  # (если есть доступ)

# 5. Проверить /etc/resolv.conf
cat /etc/resolv.conf

# 6. systemd-resolved статус
resolvectl status
```

#### Security check /etc/hosts:

```bash
# Проверить permissions
ls -l /etc/hosts
# Должно быть: -rw-r--r-- root root

# Проверить на подозрительные записи
sudo cat /etc/hosts | grep -v "^#" | grep -v "^$" | grep -v "127.0"

# Если видишь записи типа:
# 185.220.101.52  facebook.com
# ⚠️ MALWARE! Удалить немедленно!
```

> **LILITH:** *"Настроил `/etc/hosts` — проверь через 5 минут что там. Malware любит этот файл."*

### 🤔 Проверка понимания (1 мин)

**Katarina:** *"If I add `google.com 127.0.0.1` to /etc/hosts, what happens when I ping google.com?"*

<details>
<summary>🤔 Думай перед ответом</summary>

**Ответ:**

**Ping будет идти на 127.0.0.1 (localhost), НЕ на настоящий Google!**

```bash
# В /etc/hosts:
127.0.0.1  google.com

# Когда ты делаешь:
ping google.com

# Система:
1. Смотрит в /etc/hosts СНАЧАЛА
2. Находит google.com → 127.0.0.1
3. Не делает DNS query!
4. Ping идёт на 127.0.0.1 (твоя машина)
```

**Результат:**
```bash
$ ping google.com
PING google.com (127.0.0.1) 56(84) bytes of data.
64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.045 ms
```

**Это полезно для:**
- Блокирования сайтов (adblock через /etc/hosts)
- Тестирования (redirect production → localhost)

**Это опасно когда:**
- Malware делает это для phishing
- Случайно сломал конфигурацию

> **LILITH:** *"`/etc/hosts` = мощный инструмент. С great power comes great responsibility. Или great fuckup. Будь осторожен."*

</details>

---

## Цикл 6: DNS Spoofing Detection — Обнаружение подделок (10-15 мин)

### 🎬 Сюжет (2 мин)

Анна (urgent):
> *"Макс, я нашла доказательства. Крылов делает DNS cache poisoning. Некоторые наши запросы возвращают ЕГО серверы, не наши. Нужно определить какие домены скомпрометированы."*

### 📚 Теория: DNS Spoofing & Cache Poisoning (5-7 мин)

#### Метафора: Подменённая телефонная книга 📖🔀

**Представь:**
1. Ты хочешь номер "Банк Надёжный"
2. Смотришь в телефонную книгу
3. НО! Мошенник ночью подменил страницу
4. Вместо настоящего банка записан НОМЕР МОШЕННИКА
5. Ты звонишь думая что в банк, но на самом деле мошеннику!

**DNS Cache Poisoning аналогично:**

```
Normal:
dig shadow-server-05.ops.internal
→ 10.50.1.20 (правильный IP)

After Poisoning:
dig shadow-server-05.ops.internal
→ 185.220.101.52 (IP Крылова!) ⚠️
```

#### ASCII: DNS Cache Poisoning Attack

```
Step 1: Normal DNS
┌─────────┐         ┌─────────┐         ┌─────────────┐
│ Client  │ Query   │   DNS   │ Query   │Authoritative│
│         ├────────>│ Resolver├────────>│ DNS Server  │
│         │<────────┤         │<────────┤             │
└─────────┘ Answer  └─────────┘ Answer  └─────────────┘
              ↓
           Cache: shadow-05 → 10.50.1.20 (correct)

Step 2: Attacker injects FAKE response
┌─────────┐
│Attacker │ Fake Answer (faster than real!)
│(Krylov) ├───────────────────────┐
└─────────┘                       ▼
┌─────────┐                   ┌─────────┐
│ Client  │                   │   DNS   │
│         │                   │ Resolver│
└─────────┘                   └─────────┘
                                  ↓
              Cache: shadow-05 → 185.220.101.52 (FAKE!)
                                  ↓
                            TTL 3600 = 1 hour!

Step 3: All clients get FAKE IP for 1 hour!
┌─────────┐         ┌─────────┐
│ Client  │ Query   │   DNS   │
│         ├────────>│ Resolver│ Returns 185.220.101.52
│         │<────────┤ (cached)│ (Attacker IP!)
└─────────┘         └─────────┘
    │
    └──> Connects to ATTACKER, not real server! ⚠️
```

#### Amplification Effect:

```
1 cache poisoning = 10,000 victims

Пример:
- Resolver обслуживает 10,000 клиентов
- Крылов успешно poisoning cache
- TTL = 3600 (1 час)
- 10,000 × 1 hour = 10,000 victim-hours!
```

> **LILITH:** *"Вот почему DNS атаки эффективны. Одна атака — тысячи жертв. Понял почему Крылов выбрал DNS?"*

#### Как обнаружить DNS Spoofing:

**1. Сравнение с authoritative DNS:**

```bash
# Query через local resolver
dig shadow-server-05.ops.internal

# Query напрямую authoritative DNS (bypass cache)
dig @ns1.ops.internal shadow-server-05.ops.internal

# Если ответы РАЗНЫЕ → cache poisoning!
```

**2. Multiple DNS resolvers comparison:**

```bash
# Google DNS
dig @8.8.8.8 example.com

# Cloudflare DNS
dig @1.1.1.1 example.com

# OpenDNS
dig @208.67.222.222 example.com

# Если РАЗНЫЕ ответы → один из resolver скомпрометирован
```

**3. Performance metrics:**

```bash
# Suspicious: очень медленный DNS
dig google.com
;; Query time: 523 msec    # ⚠️ Слишком медленно!

# Normal:
;; Query time: 23 msec     # ✓ Хорошо
```

> **LILITH:** *"DNS > 200 мс = либо проблема, либо атака. Проверяй."*

**4. Проверка известных good/bad domains:**

```bash
# Из списка suspicious_domains.txt
# Формат: domain expected_ip

facebook.com 157.240.1.35
# Если dig возвращает другой IP → spoofing!
```

### 💻 Практика: Обнаружение spoofing (3-5 мин)

Анна:
> *"Проверь suspicious_domains.txt. Сравни реальные DNS ответы с ожидаемыми. Доложи о любых несовпадениях."*

#### Задание:

```bash
# 1. Проверить suspicious domains
cd artifacts/
cat suspicious_domains.txt

# Формат: domain expected_ip comment
# facebook.com 157.240.1.35 # Social network
# google.com 142.250.185.46 # Search engine

# 2. Для каждого домена проверить actual IP
dig +short facebook.com
dig +short google.com

# 3. Сравнить с expected_ip
# Если НЕ совпадает → ⚠️ SPOOFING!

# 4. Проверить через разные DNS resolvers
dig @8.8.8.8 +short facebook.com
dig @1.1.1.1 +short facebook.com
dig @208.67.222.222 +short facebook.com

# Если ответы РАЗНЫЕ → один resolver скомпрометирован
```

#### Bash для автоматизации (OK для такого!):

```bash
#!/bin/bash
# Простая проверка списка domains

while read domain expected_ip comment; do
    # Skip comments
    [[ "$domain" =~ ^# ]] && continue

    # Actual IP от DNS
    actual_ip=$(dig +short "$domain" | head -1)

    if [ "$actual_ip" != "$expected_ip" ]; then
        echo "⚠️  SPOOFING: $domain"
        echo "   Expected: $expected_ip"
        echo "   Actual:   $actual_ip"
    else
        echo "✓ OK: $domain → $actual_ip"
    fi
done < artifacts/suspicious_domains.txt
```

> **LILITH:** *"Bash loop для проверки списка — правильное использование. Но сама проверка = dig. Не пиши bash wrapper для dig парсинга. Ясно?"*

#### Flush DNS cache если нужно:

```bash
# Ubuntu systemd-resolved
sudo resolvectl flush-caches

# Verify
resolvectl statistics
# Current Cache Size: 0 (empty)
```

### 🤔 Проверка понимания (1 мин)

**Анна:** *"Почему cache poisoning опаснее чем простой DNS spoofing?"*

<details>
<summary>🤔 Думай перед ответом</summary>

**Ответ:**

**Cache Poisoning = Amplification Attack**

**Simple DNS Spoofing:**
```
Атака 1 клиента = 1 жертва
Нужно атаковать КАЖДОГО клиента отдельно
```

**Cache Poisoning:**
```
Атака 1 DNS resolver = 10,000 жертв
Все клиенты этого resolver получают fake IP
TTL 3600 = эффект длится 1 час
```

**Математика:**
```
Simple Spoofing:  1 attack = 1 victim
Cache Poisoning:  1 attack = N victims × TTL seconds

Пример:
- Resolver: 10,000 clients
- TTL: 3600 seconds (1 hour)
- Impact: 10,000 × 1 hour = 10,000 victim-hours

Если TTL = 86400 (24 hours):
- Impact: 10,000 × 24 hours = 240,000 victim-hours!
```

**Анна:**
> *"Точно. Крылов умный — он атакует resolvers, не клиентов. Эффективнее. Вот почему DNSSEC важен."*

> **LILITH:** *"Эффективность атаки = жертвы × время. Cache poisoning максимизирует оба параметра. Вот почему это критичная уязвимость."*

</details>

---

## Цикл 7: DNSSEC — DNS Security Extensions (10-15 мин)

### 🎬 Сюжет (2 мин)

Katarina (криптограф, подходит):
> *"DNSSEC — cryptographic signatures for DNS. Like digital signature on document. Prevents spoofing. Let me show you."*

### 📚 Теория: DNSSEC (5-7 мин)

#### Метафора: Цифровая подпись в справочнике ✍️🔐

**Представь телефонную книгу где:**
- Каждая страница заверена нотариусом
- Печать нотариуса = невозможно подделать
- Если кто-то пытается изменить номер → печать не совпадает

**DNSSEC аналогично:**
```
DNS Record:        google.com → 142.250.185.46
DNSSEC Signature:  [cryptographic signature]
Public Key:        [to verify signature]

Если запись изменена → signature invalid → reject!
```

#### ASCII: DNSSEC Chain of Trust

```
┌────────────────┐
│   Root DNS     │ Подписано Root Key
│   (.)          ├──────────┐
└────────┬───────┘          │
         │                  ├─> Trust Chain
         ▼                  │
┌────────────────┐          │
│   TLD DNS      │ Подписано TLD Key
│   (.com)       ├──────────┤
└────────┬───────┘          │
         │                  │
         ▼                  │
┌────────────────┐          │
│  Domain DNS    │ Подписано Domain Key
│ (google.com)   ├──────────┘
└────────────────┘

Каждый уровень подписывает следующий
Если подпись неверна → reject response
```

#### DNSSEC Record Types:

```
RRSIG  - Resource Record Signature (подпись)
DNSKEY - Public key для проверки подписи
DS     - Delegation Signer (связь между уровнями)
NSEC   - Next Secure (proof of non-existence)
```

**Пример DNSSEC query:**

```bash
$ dig +dnssec google.com

;; ANSWER SECTION:
google.com.     240  IN  A       142.250.185.46
google.com.     240  IN  RRSIG   A 8 2 300 ...
                          ↑
                     DNSSEC signature!
```

#### Как работает DNSSEC:

```
1. Resolver запрашивает google.com
2. DNS сервер возвращает:
   - A record (IP адрес)
   - RRSIG (подпись для A record)
3. Resolver проверяет подпись с DNSKEY
4. Если подпись valid → ответ легитимный ✓
5. Если signature invalid → reject ⚠️
```

> **Katarina:** *"DNSSEC is like HTTPS for DNS. Encryption + Authentication. Without it — man in the middle possible."*

#### DNSSEC adoption (2025):

```
✅ Enabled:
- .com, .net, .org (TLDs)
- google.com, cloudflare.com (major sites)
- Government domains (.gov)

❌ Not enabled:
- Many small websites (~40% domains)
- Some TLDs (развивающиеся страны)
```

> **LILITH:** *"DNSSEC не universal. Проверяй поддержку для критичных доменов. Без DNSSEC — уязвим к cache poisoning."*

#### "Aha!" момент: DNSSEC ≠ Encryption! 💡

```
❌ Думаешь: "DNSSEC шифрует DNS запросы"
✅ Reality:  "DNSSEC ПОДПИСЫВАЕТ ответы, НЕ шифрует"

DNSSEC:    Authentication ✓  Encryption ✗
DNS over TLS:  Authentication ✓  Encryption ✓

Для полной защиты нужны ОБА:
- DNSSEC (подпись ответов)
- DNS over TLS (шифрование запросов)
```

> **Katarina:** *"Think of it: DNSSEC = signature on letter (integrity). DoT = envelope (privacy). Both needed."*

### 💻 Практика: Проверка DNSSEC (3-5 мин)

#### Задание:

```bash
# 1. Проверить DNSSEC для major domains
dig +dnssec google.com
dig +dnssec cloudflare.com

# Искать в выводе:
# - RRSIG record (подпись)
# - ad flag (Authentic Data)

# 2. Проверить домены БЕЗ DNSSEC
dig +dnssec example.org
# Если нет RRSIG → DNSSEC not enabled

# 3. Проверить shadow domains (если DNSSEC настроен)
dig +dnssec shadow-server-01.ops.internal

# 4. Validate DNSSEC chain (advanced)
delv google.com
# (если установлен bind9-dnsutils)

# Или через drill:
drill -D google.com
# (если установлен ldns-utils)
```

#### Интерпретация вывода:

```bash
$ dig +dnssec google.com

;; flags: qr rd ra ad;
                    ^^
                    ad = Authentic Data (DNSSEC valid!)

;; ANSWER SECTION:
google.com.     240  IN  A       142.250.185.46
google.com.     240  IN  RRSIG   A 8 2 300 ...
                        ^^^^^^
                        DNSSEC signature present ✓
```

**Если нет RRSIG:**
```bash
# DNSSEC не настроен для этого домена
# Уязвим к cache poisoning
```

> **LILITH:** *"DNSSEC проверка = обязательна для критичных доменов. Банки, правительство, платёжные системы должны иметь DNSSEC. Если нет — не доверяй."*

### 🤔 Проверка понимания (1 мин)

**Katarina:** *"Max, client says 'I have DNSSEC, DNS is encrypted now.' Is this correct?"*

<details>
<summary>🤔 Думай перед ответом</summary>

**Ответ:**

**НЕТ! DNSSEC ≠ Encryption!**

```
DNSSEC provides:
✅ Authentication (подпись)
✅ Integrity (проверка что ответ не изменён)
✗ Confidentiality (НЕТ шифрования!)

DNS queries всё ещё VISIBLE для сниффера!
```

**Правильно:**
```
DNSSEC:        Подпись ответов (prevents spoofing)
DNS over TLS:  Шифрование запросов (prevents sniffing)
DNS over HTTPS: То же + использует HTTPS (port 443)

Для полной защиты:
DNSSEC + DoT/DoH
```

**Пример:**

```
Без DNSSEC:
ISP видит: "query google.com"
Атакующий может: подменить ответ ⚠️

С DNSSEC:
ISP видит: "query google.com"
Атакующий НЕ может подменить (подпись неверна) ✓

С DNSSEC + DoT:
ISP видит: "encrypted TLS traffic to 1.1.1.1"
ISP НЕ видит: что именно ты запрашиваешь ✓
Атакующий НЕ может подменить ✓
```

**Katarina:**
> *"Correct. DNSSEC = integrity, not privacy. For privacy — use DNS over TLS. Two different problems, two solutions."*

> **LILITH:** *"Криптография = много инструментов для разных задач. DNSSEC, DoT, DoH, HTTPS — каждый решает свою проблему. Понимай разницу."*

</details>

---

## Цикл 8: DNS Security Audit — Итоговая проверка (10-15 мин)

### 🎬 Сюжет (2 мин)

Erik:
> *"Now you understand DNS. Time for final task — comprehensive DNS security audit. Check everything we learned. Document findings. This goes to Viktor."*

### 📚 Теория: DNS Security Best Practices (5-7 мин)

#### Checklist для DNS Security Audit:

**1. Configuration:**
```bash
✅ /etc/hosts — no suspicious entries
✅ /etc/resolv.conf — correct nameservers
✅ systemd-resolved — status OK
✅ DNS servers — trusted (not attacker's)
```

**2. Resolution:**
```bash
✅ Shadow domains — NOT in public DNS
✅ Critical domains — resolve correctly
✅ Suspicious domains — checked for spoofing
```

**3. Security:**
```bash
✅ DNSSEC — enabled for critical domains
✅ DNS over TLS — configured (optional but recommended)
✅ Cache — flushed if suspicious activity
✅ Performance — query time < 100ms
```

**4. Monitoring:**
```bash
✅ DNS failures — < 5%
✅ Query latency — monitored
✅ Suspicious queries — logged
```

#### Type B Reminder:

> **LILITH:** *"Финальная задача = написать ОТЧЁТ, НЕ bash wrapper для dig! Ты УЖЕ выполнил все проверки вручную (Циклы 1-7). Теперь просто документируй результаты."*

**Что делать:**
```bash
✅ Использовать dig, resolvectl, cat напрямую
✅ Собрать результаты в отчёт
✅ Минимальный bash для генерации отчёта (100-150 строк)
❌ НЕ писать bash wrapper для всех DNS команд
```

**Как Episode 04:**
```
Episode 04: apt commands → generate report ✅
Episode 06: dig commands → generate report ✅
```

> **Erik:** *"Good sysadmin documents everything. Report is proof of work. Viktor needs it."*

### 💻 Практика: Финальный DNS Security Audit (3-5 мин)

#### Задание:

**Выполнить все проверки вручную:**

```bash
# 1. Configuration Check
cat /etc/hosts | grep -v "^#" | grep -v "^$"
cat /etc/resolv.conf
resolvectl status

# 2. Shadow Servers Check
while read domain; do
    [[ "$domain" =~ ^# ]] && continue
    result=$(dig +short "$domain")
    if [ -n "$result" ]; then
        echo "⚠️  LEAK: $domain"
    fi
done < artifacts/dns_zones.txt

# 3. Spoofing Detection
while read domain expected_ip; do
    [[ "$domain" =~ ^# ]] && continue
    actual=$(dig +short "$domain" | head -1)
    [ "$actual" != "$expected_ip" ] && echo "⚠️  SPOOF: $domain"
done < artifacts/suspicious_domains.txt

# 4. DNSSEC Check
for domain in google.com cloudflare.com; do
    dig +dnssec "$domain" | grep -q RRSIG && echo "✓ $domain DNSSEC"
done

# 5. Performance Check
dig google.com | grep "Query time"
```

**Теперь сгенерировать отчёт:**

```bash
# Используй starter.sh template или напиши свой minimal script
./generate_dns_audit_report.sh

# Результат: artifacts/dns_security_report.txt
```

#### Что должно быть в отчёте:

```
═══════════════════════════════════════════════════
          DNS SECURITY AUDIT REPORT
═══════════════════════════════════════════════════

Date:       2025-10-11 14:30:00
Location:   Bahnhof Pionen, Stockholm 🇸🇪
Operator:   Max Sokolov
Audited by: Erik Johansson

[1] CONFIGURATION
    /etc/hosts:       OK (no suspicious entries)
    /etc/resolv.conf: OK (nameservers: 8.8.8.8, 1.1.1.1)
    systemd-resolved: ACTIVE (127.0.0.53)

[2] SHADOW SERVERS
    Checked: 15 internal domains
    Public leaks: 0
    Status: ✓ SECURE

[3] DNS SPOOFING
    Checked: 23 suspicious domains
    Spoofed: 0
    Status: ✓ CLEAN

[4] DNSSEC
    google.com:      ENABLED ✓
    cloudflare.com:  ENABLED ✓
    ops.internal:    NOT ENABLED (internal zone)

[5] PERFORMANCE
    Average query time: 28 ms
    Status: ✓ GOOD (< 50 ms)

[6] SECURITY RECOMMENDATIONS
    - Enable DNSSEC for ops.internal zone
    - Configure DNS over TLS (DoT)
    - Monitor DNS query logs for anomalies
    - Regular /etc/hosts audits

═══════════════════════════════════════════════════
END OF REPORT
```

> **LILITH:** *"Отчёт = твоё доказательство работы. Viktor читает это. Крылов может читать это (если перехватит). Пиши профессионально."*

### 🤔 Проверка понимания (1 мин)

**Erik:** *"You finished audit. Found 3 spoofed domains. What is your next action?"*

<details>
<summary>🤔 Думай перед ответом</summary>

**Ответ:**

**Порядок действий при обнаружении DNS spoofing:**

**1. НЕМЕДЛЕННО:**
```bash
# Flush DNS cache (remove poisoned entries)
sudo resolvectl flush-caches

# Или если не systemd-resolved:
sudo systemd-resolve --flush-caches
```

**2. ИЗОЛИРОВАТЬ:**
```bash
# Добавить правильные записи в /etc/hosts (temporary fix)
echo "10.50.1.20 shadow-server-05.ops.internal" | sudo tee -a /etc/hosts

# Теперь queries будут использовать /etc/hosts (bypass DNS)
```

**3. СООБЩИТЬ КОМАНДЕ:**
```bash
# Urgent notification
# Viktor, Anna, Alex должны знать

"⚠️ DNS SPOOFING DETECTED
 Domains affected: 3
 Attacker IP: 185.220.101.52 (Tor exit node)
 Action taken: Cache flushed, /etc/hosts updated
 Recommendation: Switch to DoT + DNSSEC"
```

**4. РАССЛЕДОВАНИЕ:**
```bash
# Анна (forensics) анализирует:
# - Когда началось?
# - Сколько clients affected?
# - Как Крылов получил доступ к resolver?
```

**5. ДОЛГОСРОЧНОЕ РЕШЕНИЕ:**
```bash
# Configure DNS over TLS (encrypted)
# Enable DNSSEC validation
# Monitor DNS logs continuously
# Rotate DNS resolvers
```

**Erik:**
> *"Perfect response. Speed matters in security. Flush cache first, then investigate. Minutes can save hours of damage."*

> **LILITH:** *"DNS инциденты = время критично. Каждая минута poisoned cache = 100+ жертв. Действуй быстро, думай потом."*

</details>

---

## 🎬 Эпилог: Миссия завершена

### День 11, 18:00 — Bahnhof Pionen

Erik проверяет отчёт:
> *"Excellent work, Max. You found DNS issues we didn't even know about. Viktor will be impressed."*

**Видеозвонок с командой:**

**Виктор:**
> *"Макс, Эрик прислал хороший отчёт. Ты быстро освоил DNS. Это знание спасёт нас много раз. DNS — фундамент интернета, теперь ты понимаешь фундамент."*

**Анна:**
> *"DNS аудит нашёл отпечатки Крылова. 3 отравленных домена, все указывают на Tor exit nodes. Он становится изощрённее. Но мы поймали это благодаря твоему аудиту."*

**Алекс:**
> *"Хорошая работа, братан. DNS security = невидимая работа. Никто не замечает пока всё работает. Но когда ломается — катастрофа."*

**LILITH:**
> *"DNS Module complete. You learned: dig, systemd-resolved, /etc/hosts, DNSSEC. Next — firewalls. Episode 07 — iptables, attack mitigation. Prepare."*

Erik провожает до выхода из бункера:
> *"Remember — DNS is trust system. Every query is act of trust. Krylov attacks trust. You defend it. Welcome to security mindset."*

**Notificiation на телефоне:**

```
[Viktor]: Episode 07 briefing tomorrow
[Viktor]: Flight to Moscow 08:00
[Viktor]: New threat detected
[Viktor]: Be ready
```

---

## 🎓 Что вы изучили

### DNS Fundamentals:
- ✅ DNS = Телефонная книга интернета (name → IP)
- ✅ DNS Query process (resolver → DNS server → answer)
- ✅ TTL (Time To Live) и DNS caching
- ✅ Public vs Private DNS zones

### DNS Record Types:
- ✅ **A** — IPv4 address
- ✅ **AAAA** — IPv6 address
- ✅ **MX** — Mail exchange (lower = higher priority!)
- ✅ **NS** — Name server
- ✅ **CNAME** — Canonical name (alias)
- ✅ **TXT** — Text metadata
- ✅ **PTR** — Pointer (reverse DNS)

### DNS Tools (Type B Focus!):
- ✅ **dig** — Основной DNS tool (детальный) 🔧
- ✅ **host** — Быстрая проверка
- ✅ **nslookup** — Legacy но работает
- ✅ **systemd-resolved** — Ubuntu DNS resolver 🔧
- ✅ **resolvectl** — systemd-resolved control 🔧

### DNS Configuration:
- ✅ **/etc/hosts** — Local DNS (highest priority!)
- ✅ **/etc/resolv.conf** — DNS servers config
- ✅ **systemd-resolved** — Ubuntu default resolver
- ✅ Priority order: hosts → systemd → resolv.conf → DNS

### DNS Security:
- ✅ **DNS Spoofing** — Поддельные DNS ответы
- ✅ **Cache Poisoning** — Подделка DNS cache (amplification!)
- ✅ **DNSSEC** — Криптографические подписи (authentication)
- ✅ **DNS over TLS (DoT)** — Шифрование DNS queries
- ✅ **/etc/hosts malware** — Локальная подделка DNS

### Type B Philosophy:
- ✅ **dig exists → use it, don't wrap it**
- ✅ Configuration > Scripting (настраивай системы, не переписывай)
- ✅ Bash для отчётов, НЕ для замены dig
- ✅ Linux SysAdmin конфигурирует DNS, не оборачивает команды

### Практические навыки:
- ✅ DNS lookup с dig (A, MX, NS, TXT records)
- ✅ Reverse DNS проверка (dig -x)
- ✅ Конфигурирование /etc/hosts для bypass DNS
- ✅ Конфигурирование /etc/resolv.conf
- ✅ systemd-resolved управление
- ✅ Обнаружение DNS spoofing
- ✅ DNSSEC валидация
- ✅ DNS security audit

---

## 📖 Самопроверка

**Ответь на вопросы (не подсматривай!):**

1. Что делает команда `dig +short google.com`?
2. Что такое TTL и зачем он нужен?
3. MX record с приоритетом 5 или 10 используется первым?
4. Что такое Reverse DNS (PTR record)?
5. Какой файл имеет приоритет: /etc/hosts или DNS?
6. Почему /etc/hosts опасен для malware?
7. Что такое DNS cache poisoning?
8. DNSSEC шифрует DNS queries? (Да/Нет)
9. Как flush DNS cache в Ubuntu?
10. В чём разница между dig и systemd-resolved?

<details>
<summary>Проверить ответы</summary>

1. **Короткий DNS lookup** — возвращает только IP адрес (без деталей)
2. **TTL = Time To Live** — время хранения DNS записи в cache
3. **5 используется первым** (lower number = higher priority!)
4. **IP → hostname** (обратная резолюция)
5. **/etc/hosts** (всегда проверяется ПЕРВЫМ)
6. **Malware может добавить fake записи** (facebook.com → attacker IP)
7. **Подделка DNS cache** — 1 атака, тысячи жертв (amplification)
8. **НЕТ!** DNSSEC = подпись, НЕ шифрование (DoT = шифрование)
9. **`sudo resolvectl flush-caches`**
10. **dig = manual queries, systemd-resolved = system resolver** (Ubuntu default)

</details>

---

## ✅ Проверка выполнения

**Ты готов к следующему эпизоду если:**

- ✅ Понимаешь как работает DNS (name → IP translation)
- ✅ Умеешь использовать dig для всех типов DNS records
- ✅ Знаешь разницу между Public и Private DNS
- ✅ Понимаешь /etc/hosts priority over DNS
- ✅ Можешь обнаружить DNS spoofing
- ✅ Знаешь что такое DNSSEC (authentication, не encryption!)
- ✅ Понимаешь Type B philosophy (dig > bash wrapper)
- ✅ Можешь настроить systemd-resolved
- ✅ Сгенерировал DNS security audit report

**Тест:**
```bash
# Выполни за 5 минут:
dig A google.com
dig MX gmail.com
dig -x 8.8.8.8
cat /etc/hosts
resolvectl status
dig +dnssec cloudflare.com

# Если все команды понятны → готов! ✅
```

---

## 📚 Следующий эпизод

**Episode 07: Firewalls & iptables** 🔥
- Локация: Москва 🇷🇺 (возврат из Стокгольма)
- DDoS атака в реальном времени (03:47)
- UFW и iptables под давлением
- Rate limiting и attack mitigation
- Сообщение от Крылова в TCP payload

**LILITH:**
> *"DNS — это доверие. Firewall — это недоверие. Следующий урок — как не доверять НИКОМУ. Включая себя."*

---

## 📖 Дополнительные материалы

### DNS Commands Cheat Sheet:

```bash
# dig
dig domain.com              # Full DNS query
dig +short domain.com       # Only IP
dig +trace domain.com       # Full resolution path
dig @8.8.8.8 domain.com     # Specific DNS server
dig MX domain.com           # Mail exchange
dig -x IP_ADDRESS           # Reverse DNS
dig +dnssec domain.com      # DNSSEC validation

# systemd-resolved
resolvectl status           # DNS configuration
resolvectl query domain     # Query domain
resolvectl flush-caches     # Clear cache
resolvectl statistics       # Cache stats

# Configuration
cat /etc/hosts              # Local DNS
cat /etc/resolv.conf        # DNS servers
```

### External Resources:

- **RFC 1035** — DNS specification
- **RFC 4033-4035** — DNSSEC
- **DNSViz** — https://dnsviz.net (DNSSEC visualization)
- **dig manual** — `man dig`
- **systemd-resolved** — `man systemd-resolved`

---

**KERNEL SHADOWS — Episode 06 Complete! 🇸🇪✅**

*"DNS — телефонная книга интернета. Если книга поддельная — весь трафик идёт не туда."* — Erik Johansson

**Next Stop:** Москва → Episode 07 → Firewalls! 🔥

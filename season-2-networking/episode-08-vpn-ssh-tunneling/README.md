# Episode 08: VPN & SSH Tunneling

**KERNEL SHADOWS — Season 2: Networking (FINALE)**

```
╔═══════════════════════════════════════════════════════════════╗
║  Episode 08: VPN & SSH Tunneling                             ║
║  Season 2 Finale: Secure Communication                       ║
║                                                               ║
║  Location: Moscow 🇷🇺 → Stockholm 🇸🇪 → Zürich 🇨🇭            ║
║  Day: 15-16 of 60                                             ║
║  Difficulty: ⭐⭐⭐⭐☆                                         ║
║  Time: 6-7 hours (8 micro-cycles)                            ║
║  Status: 🔒 SECURE CHANNEL REQUIRED                          ║
╚═══════════════════════════════════════════════════════════════╝
```

---

## 🎯 Type A Episode: "Workflow Automation is OK!"

**Философия:**
```
Episode 05 (Network Audit):  Bash combines tools (ip, ss, netstat) ✅ Type A
Episode 06 (DNS):            dig exists → use dig напрямую ✅ Type B
Episode 07 (Firewall):       ufw exists → use ufw напрямую ✅ Type B
Episode 08 (VPN Setup):      Bash automates WORKFLOW ✅ Type A
```

**Type A vs Type B — когда что использовать:**

| Задача | Тип | Approach |
|--------|-----|----------|
| **Один инструмент** | Type B | Используй напрямую: `ufw allow 80/tcp` |
| **Комбинация инструментов** | Type A | Bash автоматизирует: `ssh-keygen` × 5 + config gen |
| **Workflow** | Type A | Multi-step процесс: generate keys → config → deploy |
| **Отчёт** | Both | Bash для report generation — всегда OK! |

**Episode 08 = Type A, потому что:**

1. **Workflow automation:** Generate SSH keys для 5 членов команды
2. **Complex setup:** SSH config + WireGuard server + 5 clients
3. **Orchestration:** Координация нескольких инструментов
4. **NOT replacing tool:** НЕ пишем свой `ssh-keygen`, используем его!

**LILITH:**
> *"Type A ≠ плохо. Type A = автоматизация workflow. Выполнить ssh-keygen 5 раз руками? Можно. Глупо. Bash loop — умно. Type B = когда есть ГОТОВЫЙ инструмент для всей задачи."*

---

## 💻 Setup: Как выполнять задания

### Варианты выполнения:

**1. Локально (рекомендуется) ⭐**

SSH часть — полностью практика:
```bash
ssh-keygen -t ed25519 -C "user@example.com"
nano ~/.ssh/config
ssh -L 8080:localhost:80 user@server
```

VPN часть — изучение конфигурации (requires root):
```bash
# Чтение конфигов, понимание принципов
# Реальный VPN setup требует sudo + может конфликтовать с сетью
```

**2. Docker (для VPN hands-on) ⭐⭐⭐**

WireGuard в изоляции:
```bash
docker run -d --name wireguard \
    --cap-add=NET_ADMIN \
    -p 51820:51820/udp \
    linuxserver/wireguard
```

**3. Cloud VMs (production-like) ⭐⭐⭐⭐**

Реальный VPN между серверами (требует 2 VMs + публичные IP).

---

## 🎬 Сюжет: День 15, 08:00 — Secure Channel Required

### Zürich, Switzerland 🇨🇭

**Виктор собрал всех на экстренное совещание. Экран показывает карту Европы.**

**Виктор:**
> *"После сообщения Крылова в логах (День 14) — ситуация критическая. Он не просто атакует серверы. Он угрожает лично Алексу и Максу."*

**Анна** (forensics):
> *"Я проанализировала его методы. DDoS — это отвлечение. Настоящая цель — перехват коммуникаций. Deep Packet Inspection. Он читает наш трафик."*

**Макс:**
> *"Firewall же держит?"*

**Алекс:**
> *"Firewall блокирует атаки. Но НЕ шифрует трафик. Крылов может читать что мы передаём. Пароли, планы, координаты."*

**Дмитрий:**
> *"Нужен VPN. Весь трафик команды — через зашифрованный туннель. Крылов увидит только encrypted data."*

**Виктор:**
> *"Макс, твоя задача — настроить VPN сервер. Локация — Цюрих, Швейцария. Нейтральная территория, строгие privacy законы, Крылов не достанет."*

**Макс:**
> *"VPN... я только читал про это..."*

**Алекс:**
> *"Сейчас научишься. По шагам. Сначала SSH ключи для команды — 5 человек. Потом SSH config — автоматизация. Потом VPN. У нас 8 часов."*

---

### LILITH активируется — Secure Mode

**LILITH v2.5 (синий режим — security):**
> *"THREAT ESCALATION DETECTED."*
>
> *"Krylov capabilities: DDoS ✓, DPI (Deep Packet Inspection) ✓, Traffic analysis ✓"*
>
> *"Current status: Firewall active, но traffic UNENCRYPTED."*
>
> *"Solution: End-to-end encryption. VPN для всей команды."*
>
> *"Episode 08 objectives:"*
> *- SSH keys (ed25519, no passwords)"*
> *- SSH config (automation)"*
> *- SSH tunneling (practice encryption)"*
> *- VPN setup (WireGuard, ChaCha20-Poly1305)"*
> *- Security audit (DNS leaks, IP leaks)"*
>
> *"Time limit: 8 hours. Team safety depends on encryption."*

**Текущее время:** 08:00
**Deadline:** 16:00
**Team:** 5 members (Viktor, Alex, Anna, Dmitry, Max)

---

## 📚 Micro-Cycles: 8 циклов × 12-15 минут

### Цикл 1: SSH Keys Basics (12 минут) 🔑

#### 🎬 Сюжет (2 мин)

**Алекс:**
> *"Первое — SSH ключи. Для каждого члена команды. ed25519 алгоритм."*

**Макс:**
> *"А пароли? Я всегда использовал пароли..."*

**Алекс:**
> *"Пароли взламывают. Brute-force, dictionary attacks, keyloggers. Ключи — математика. Взломать невозможно за разумное время."*

**LILITH:**
> *"Passwords: humans are weak. 'password123', '12345678', 'qwerty'. Top 3 passwords in 2024. SSH keys: cryptography. 256-bit ed25519 = 2^256 combinations. Sun dies before brute-force succeeds."*

---

#### 📚 Теория: SSH Keys (6 мин)

**🎭 МЕТАФОРА #1: SSH Keys = Дом + Замок + Ключ**

```
Дом (Server):
  🚪 [Замок] ← Публичный ключ (висит на двери)

Ты:
  🔑 Приватный ключ (в кармане)

Процесс:
  1. Ты подходишь к двери с ключом
  2. Ключ подходит к замку? → Да → заходишь
  3. Ключ не подходит? → Нет доступа
```

**Важно:**
- **Публичный ключ** = замок (можно показывать всем, ставить на сервера)
- **Приватный ключ** = ключ (НИКОМУ не показывать, хранить в безопасности!)

**Аналогия:**
- Публичный ключ = email адрес (можешь давать кому угодно)
- Приватный ключ = пароль от email (СЕКРЕТ!)

---

**SSH Key Pair Generation:**

```
                ssh-keygen
                     ↓
        ┌────────────┴────────────┐
        ↓                         ↓
  Private Key              Public Key
  ~/.ssh/id_ed25519       ~/.ssh/id_ed25519.pub
        ↓                         ↓
  🔒 СЕКРЕТ!              📤 Копируешь на сервер
  Permissions: 600        Добавляешь в ~/.ssh/authorized_keys
  НИКОМУ не показывать!   Теперь можешь подключаться!
```

**ed25519 vs RSA:**

| Feature | ed25519 | RSA (4096-bit) |
|---------|---------|----------------|
| **Key size** | 256-bit (68 байт) | 4096-bit (800 байт) |
| **Speed** | 🚀 Очень быстро | 🐢 Медленно |
| **Security** | 🛡️ 128-bit security level | 🛡️ 128-bit security level |
| **Год** | 2011 (modern) | 1977 (legacy) |
| **Recommendation** | ✅ Use this! | ⚠️ Legacy only |

**LILITH:**
> *"ed25519 — стандарт 2024. Короче, быстрее, безопаснее. RSA — legacy, для старых серверов. Если сервер поддерживает ed25519 (а он поддерживает) — всегда ed25519."*

---

**💡 AHA Moment: Почему ключи безопаснее паролей?**

**Password authentication:**
```
You → пароль по сети → Server
          ↓
  Krylov перехватывает (DPI)
          ↓
  Теперь у него твой пароль!
```

**Key authentication:**
```
You → challenge-response (crypto) → Server
          ↓
  Krylov перехватывает
          ↓
  Видит только encrypted data
  Приватный ключ НЕ передаётся по сети!
  Взломать невозможно
```

**Ключ НЕ передаётся!** Server проверяет что у тебя ЕСТЬ приватный ключ (challenge-response), но ключ остаётся у тебя на машине.

---

#### 💻 Практика: Generate SSH Keys (3 мин)

**Задание:** Создайте SSH key pair для себя.

```bash
# Generate ed25519 key
ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/kernel_shadows_key

# Параметры:
#   -t ed25519    : тип ключа (algorithm)
#   -C "email"    : комментарий (для идентификации)
#   -f filename   : имя файла (по умолчанию: id_ed25519)

# Будет спрашивать passphrase (опционально):
#   Enter passphrase: [нажми Enter для no passphrase]
#
# Passphrase = extra security:
#   Даже если кто-то украдёт файл ключа,
#   не сможет использовать без passphrase

# Проверка
ls -la ~/.ssh/kernel_shadows_key*
# Должно быть 2 файла:
#   kernel_shadows_key       (private, 600 permissions)
#   kernel_shadows_key.pub   (public, 644 permissions)

# Посмотреть публичный ключ
cat ~/.ssh/kernel_shadows_key.pub

# Посмотреть fingerprint (отпечаток)
ssh-keygen -lf ~/.ssh/kernel_shadows_key.pub
# SHA256:XxXxXxXx... (уникальный ID ключа)
```

**Ожидаемый результат:**
```
Generating public/private ed25519 key pair.
Your identification has been saved in ~/.ssh/kernel_shadows_key
Your public key has been saved in ~/.ssh/kernel_shadows_key.pub
The key fingerprint is:
SHA256:AbC123... your_email@example.com
The key's randomart image is:
+--[ED25519 256]--+
|      .o=*+      |
|     . =+*.      |
|    . + * . .    |
|   o + = = E     |
|    + o S =      |
|     o + *       |
|      . o        |
+----[SHA256]-----+
```

**LILITH:**
> *"Randomart image — визуальный fingerprint. Люди плохо запоминают хэши, но картинки — легко. Видишь эту картинку → знаешь что это твой ключ."*

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** Можно ли безопасно отправить публичный ключ по email?

a) Да, публичный ключ не секрет
b) Нет, это угроза безопасности
c) Только через зашифрованный email

<details>
<summary>💡 Думай 30 секунд перед проверкой</summary>

**Ответ: a) Да, публичный ключ не секрет!**

Публичный ключ = замок. Можешь показывать кому угодно!

**Аналогия:**
- Публичный ключ = адрес твоего дома (все знают)
- Приватный ключ = ключ от дома (СЕКРЕТ!)

**Можно:**
- ✅ Отправлять публичный ключ по email
- ✅ Выкладывать на GitHub
- ✅ Размещать на сайте
- ✅ Давать админам серверов

**НЕЛЬЗЯ:**
- ❌ Показывать приватный ключ НИКОМУ!
- ❌ Коммитить приватный ключ в git
- ❌ Отправлять приватный ключ по email
- ❌ Хранить приватный ключ на сервере

**LILITH:**
> *"Public key — public. Private key — private. Просто как названия говорят. Путаешь — проигрываешь root access."*

</details>

---

### Цикл 2: SSH Config Advanced (12 минут) 📝

#### 🎬 Сюжет (2 мин)

**Дмитрий:**
> *"Теперь SSH config. У нас 5 серверов: Москва, Стокгольм, Цюрих, плюс backup серверы. Каждый раз вводить `ssh -i ~/.ssh/key user@195.123.456.789 -p 2222` — безумие."*

**Макс:**
> *"А как проще?"*

**Дмитрий:**
> *"SSH config. Файл ~/.ssh/config. Пишешь один раз конфигурацию, потом просто `ssh zurich` — и подключаешься. Имя вместо IP, автоматический ключ, автоматический порт."*

**LILITH:**
> *"SSH config — автоматизация. Альтернатива: запоминать 10+ IP адресов, пути к ключам, порты, username. Или писать всё в config один раз. Choose automation."*

---

#### 📚 Теория: SSH Config (6 мин)

**🎭 МЕТАФОРА #2: SSH Config = Телефонная книга**

```
Без SSH config (hard way):
  Позвонить Алексу:
    +7 (495) 123-45-67, добавочный 1234
    Каждый раз набирать ВЕСЬ номер
    Ошибся в одной цифре → неправильный номер

С SSH config (smart way):
  Позвонить Алексу:
    Нажать "Alex" в контактах
    Телефон сам набирает номер
    Быстро, без ошибок
```

---

**SSH Config Structure:**

```bash
# ~/.ssh/config

Host zurich
    HostName 185.123.45.67
    User max
    Port 22
    IdentityFile ~/.ssh/kernel_shadows_key

Host moscow
    HostName 195.234.56.78
    User admin
    Port 2222
    IdentityFile ~/.ssh/moscow_key
```

**Использование:**
```bash
# Вместо:
ssh -i ~/.ssh/kernel_shadows_key -p 22 max@185.123.45.67

# Просто:
ssh zurich
```

**Config автоматически:**
- Подставляет IP (HostName)
- Подставляет username (User)
- Подставляет порт (Port)
- Выбирает ключ (IdentityFile)

---

**Advanced SSH Config Options:**

```bash
# Jump Host (Bastion)
Host production-server
    HostName 10.0.0.100
    ProxyJump bastion-server
    # Сначала подключается к bastion, потом к production

# Wildcard patterns
Host *.kernel-shadows.com
    User admin
    IdentityFile ~/.ssh/team_key
    # Применяется ко всем серверам домена

# Connection multiplexing (faster)
Host *
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h:%p
    ControlPersist 10m
    # Переиспользует существующие connections

# Security settings
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    # Keep-alive: если нет ответа 3×60 sec → disconnect
```

**LILITH:**
> *"ProxyJump = jump host. Bastion сервер — единственная точка входа в private network. Подключаешься к bastion, потом через него к production. Один вход — легче защищать."*

---

**💡 AHA Moment: SSH Config Inheritance**

Правила применяются **сверху вниз, первое совпадение!**

```bash
# ПЛОХО (НЕ работает как ожидается):
Host *
    User admin

Host zurich
    User max        # ← НЕ применится! Host * выше!

# ПРАВИЛЬНО:
Host zurich
    User max        # ← Конкретное правило СНАЧАЛА

Host *
    User admin      # ← Generic правило ПОТОМ
```

**Порядок важен!** Специфичные правила → сначала. Generic (`Host *`) → в конце.

---

#### 💻 Практика: Create SSH Config (3 мин)

**Задание:** Создайте SSH config для команды серверов.

```bash
# Create config file
nano ~/.ssh/config

# Add configuration:

# ═══════════════════════════════════════════════════════════
# KERNEL SHADOWS Operation — SSH Config
# ═══════════════════════════════════════════════════════════

# Zürich VPN Server (Switzerland)
Host zurich vpn
    HostName vpn-zurich.kernel-shadows.com
    User max
    Port 22
    IdentityFile ~/.ssh/kernel_shadows_key
    ServerAliveInterval 60

# Moscow Operations Center (Russia)
Host moscow ops
    HostName shadow-server-02.ops.internal
    User admin
    Port 2222
    IdentityFile ~/.ssh/kernel_shadows_key

# Stockholm Development Server (Sweden)
Host stockholm dev
    HostName dev-stockholm.kernel-shadows.com
    User max
    Port 22
    IdentityFile ~/.ssh/kernel_shadows_key

# Global settings (apply to all)
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    Compression yes
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h:%p
    ControlPersist 10m

# Save and exit (Ctrl+O, Enter, Ctrl+X)

# Set permissions (important!)
chmod 600 ~/.ssh/config

# Test
ssh zurich
# Должно подключиться без дополнительных параметров!
```

**LILITH:**
> *"chmod 600 — обязательно! SSH отказывается использовать config если permissions слишком открыты. Security first."*

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** Что произойдёт если запустить `ssh vpn` с этим конфигом?

```bash
Host zurich vpn
    HostName vpn-zurich.kernel-shadows.com
```

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ:** Подключится к vpn-zurich.kernel-shadows.com!

**Почему:** `Host zurich vpn` = два алиаса для одного сервера.

```bash
ssh zurich  # работает
ssh vpn     # тоже работает!
```

Оба имени ведут к `HostName vpn-zurich.kernel-shadows.com`.

**Use case:** Разные имена для одного сервера:
- `ssh zurich` — понятно что это Цюрих
- `ssh vpn` — понятно что это VPN сервер
- Оба подключаются к одному месту!

**LILITH:**
> *"Aliases = удобство. `ssh prod`, `ssh production`, `ssh prod-server` — все к одному серверу. Называй как тебе удобно."*

</details>

---

### Цикл 3: SSH Local Forward (15 минут) 🔀

#### 🎬 Сюжет (3 мин)

**Анна:**
> *"Хорошо. Ключи есть, config настроен. Теперь SSH tunneling. Макс, представь: на Москва-сервере крутится база данных PostgreSQL, порт 5432. Доступ только с localhost. Как подключиться с твоей машины?"*

**Макс:**
> *"Открыть порт в firewall?"*

**Анна:**
> *"❌ Нет! Открыл порт — Крылов атакует базу напрямую. SQL injection, brute-force. Firewall сказал deny для 5432 — так и оставляем."*

**Алекс:**
> *"SSH Local Forward. Туннель через SSH. База думает что ты подключаешься с localhost, но реально — через зашифрованный SSH туннель с твоей машины."*

**Макс:**
> *"Туннель... как метро?"*

**Алекс:**
> *"Да. Секретный подземный ход. Снаружи — стена (firewall). Внутри — туннель через который ты заходишь."*

---

#### 📚 Теория: SSH Local Forward (7 мин)

**🎭 МЕТАФОРА #3: SSH Tunnel = Секретный подземный ход**

```
        🏰 Firewall (стена)
        ╔═══════════════════════╗
        ║  🚪 22 (SSH) OPEN     ║
        ║  🚫 5432 (DB) CLOSED  ║
        ╚═══════════════════════╝
               ↑
               │ SSH tunnel (underground)
               │ (encrypted!)
               ↓
        💻 Your Machine
```

**Без туннеля:**
- Ты → 5432 → Firewall → ❌ BLOCKED

**С туннелем:**
- Ты → SSH → 22 → ✅ ALLOWED → туннель внутри → 5432 localhost → ✅ База!

Firewall видит только SSH трафик (разрешён). Не видит что внутри SSH ты подключаешься к базе!

---

**SSH Local Forward Syntax:**

```bash
ssh -L [local_port]:[target_host]:[target_port] [ssh_server]
```

**Пример:**
```bash
ssh -L 5432:localhost:5432 moscow

# Расшифровка:
#   5432          : твой локальный порт (где слушать)
#   localhost     : с точки зрения moscow-сервера (где цель)
#   5432          : порт цели (PostgreSQL)
#   moscow        : SSH сервер (через какой подключаемся)
```

**Что происходит:**
```
Your Machine:                      Moscow Server:

localhost:5432 ←─────┐             ┌──→ localhost:5432
                     │             │    (PostgreSQL)
        Your App     │             │
                     │             │
         SSH Client ─┴─[encrypted]─┴─ SSH Server
                        tunnel

Flow:
  1. Your app connects to localhost:5432
  2. SSH client catches connection
  3. Sends через SSH tunnel to moscow
  4. Moscow SSH server connects to localhost:5432
  5. Database responds → tunnel → your app
```

**С точки зрения базы:** подключение с localhost (разрешено!)
**На самом деле:** ты подключаешься удалённо через туннель!

---

**💡 AHA Moment: localhost = from server perspective!**

```bash
# Это РАЗНОЕ!

# 1. Target: localhost (база на том же сервере что SSH)
ssh -L 5432:localhost:5432 moscow
# moscow → localhost = сам moscow

# 2. Target: другой сервер (база на отдельном сервере)
ssh -L 5432:db-server.internal:5432 moscow
# moscow → db-server.internal = другая машина
# moscow делает connect to db-server
```

`localhost` = с точки зрения SSH сервера, не твоей машины!

**LILITH:**
> *"Путаница в 'localhost' — классика. Запомни: localhost = там где SSH сервер. Не там где ты."*

---

**Real-world examples:**

```bash
# PostgreSQL database
ssh -L 5432:localhost:5432 moscow
psql -h localhost -p 5432 -U admin production_db

# Web admin panel (internal only)
ssh -L 8080:localhost:80 moscow
# Открываешь в браузере: http://localhost:8080

# Redis cache
ssh -L 6379:localhost:6379 moscow
redis-cli -p 6379

# Multiple tunnels одновременно!
ssh -L 5432:localhost:5432 \
    -L 6379:localhost:6379 \
    -L 8080:localhost:80 \
    moscow
# Три туннеля в одном SSH соединении
```

---

#### 💻 Практика: Setup Local Forward (4 мин)

**Задание:** Создайте SSH туннель к web сервису.

```bash
# Scenario: На удалённом сервере крутится web admin (порт 8080)
# Доступ только с localhost (firewall блокирует)

# Setup tunnel
ssh -L 8080:localhost:8080 moscow -N

# Параметры:
#   -L 8080:localhost:8080  : Local forward
#   -N                      : No command (только туннель, no shell)

# Держи это окно открытым! (туннель активен пока SSH соединение живёт)

# В новом окне/браузере:
curl http://localhost:8080
# Или открой в браузере: http://localhost:8080

# Success! Ты подключился к удалённому сервису через туннель!

# Alternative: Background mode
ssh -L 8080:localhost:8080 moscow -N -f
# -f = fork to background

# Check tunnel
ps aux | grep "ssh -L"

# Kill tunnel
pkill -f "ssh -L 8080"
```

**LILITH:**
> *"-N flag = no shell. Зачем shell если нужен только туннель? -N = эффективнее. -f = background. Вместе -N -f = туннель в фоне, терминал свободен."*

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** Что делает эта команда?

```bash
ssh -L 9000:db-internal.company.com:5432 bastion-server
```

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ:** Туннель к базе данных через bastion.

**Подробно:**
1. Подключаешься к `bastion-server` через SSH
2. Создаёшь локальный порт `9000` на твоей машине
3. Когда подключаешься к `localhost:9000`:
   - Трафик идёт через SSH tunnel к bastion
   - Bastion подключается к `db-internal.company.com:5432`
   - Ответ возвращается обратно через туннель

**Use case:** Bastion = jump host. База во внутренней сети, недоступна снаружи. Bastion имеет доступ. Через него делаешь туннель.

**Теперь можешь:**
```bash
psql -h localhost -p 9000 -U user database
```

База думает что bastion подключается. Реально — ты через туннель!

**LILITH:**
> *"Jump host pattern. Один сервер (bastion) с доступом снаружи. Всё остальное — internal network. Туннель через bastion → доступ к любому internal сервису. Security через single entry point."*

</details>

---

### Цикл 4: SSH Remote Forward (12 минут) 🔄

#### 🎬 Сюжет (2 мин)

**Дмитрий:**
> *"Local forward понятен. Теперь обратный случай. Макс, ты разрабатываешь webhook локально на своей машине. Нужно чтобы GitHub отправлял события на твой локальный сервер. Как?"*

**Макс:**
> *"Открыть порт в роутере?"*

**Дмитрий:**
> *"Можно, но: 1) нет статического IP, 2) небезопасно, 3) админ роутера не даст. Remote Forward. Обратный туннель."*

**Алекс:**
> *"Local Forward: remote service → local. Remote Forward: local service → remote. Противоположное направление."*

---

#### 📚 Теория: SSH Remote Forward (6 мин)

**🎭 МЕТАФОРА #4: Local vs Remote Forward**

```
Local Forward = Туннель К ТЕБЕ:
  Remote service ─[tunnel]→ Your machine
  Ты достаёшь удалённый сервис

Remote Forward = Туннель ОТ ТЕБЯ:
  Your service ─[tunnel]→ Remote world
  Мир достаёт твой сервис
```

---

**Сравнение:**

| Direction | Local Forward | Remote Forward |
|-----------|---------------|----------------|
| **Flow** | Remote → You | You → Remote |
| **Use case** | Access internal service | Expose local service |
| **Command** | `-L` | `-R` |
| **Example** | Access DB через firewall | Webhook to localhost |

---

**SSH Remote Forward Syntax:**

```bash
ssh -R [remote_port]:[local_host]:[local_port] [ssh_server]
```

**Пример:**
```bash
ssh -R 8080:localhost:3000 moscow

# Расшифровка:
#   8080        : порт на moscow-сервере (где слушать)
#   localhost   : твоя машина (где цель)
#   3000        : твой локальный порт (твой app)
#   moscow      : SSH сервер
```

**Что происходит:**
```
Your Machine:                  Moscow Server:

localhost:3000 ←───────────────┐
(Your webhook app)             │
                               │
SSH Client ─[encrypted tunnel]─┴─ SSH Server listening on 0.0.0.0:8080

Flow:
  1. Someone connects to moscow:8080
  2. Moscow SSH forwards через tunnel to you
  3. Your localhost:3000 responds
  4. Response goes back через tunnel

Result: Your local app доступен на moscow:8080!
```

---

**Real-world use cases:**

```bash
# 1. Webhook development
ssh -R 8080:localhost:3000 moscow
# GitHub webhook → moscow:8080 → your localhost:3000

# 2. Demo local app
ssh -R 80:localhost:4000 demo-server
# Client: http://demo-server → your localhost:4000

# 3. Temporary service exposure
ssh -R 5000:localhost:5000 moscow
# Team member: curl moscow:5000 → your Flask app
```

**⚠️ Security warning:**

По умолчанию remote port слушает только на `localhost` сервера!

```bash
# Default (secure):
ssh -R 8080:localhost:3000 moscow
# moscow: только localhost:8080

# Public (DANGEROUS!):
ssh -R 0.0.0.0:8080:localhost:3000 moscow
# moscow: 0.0.0.0:8080 (весь интернет может подключиться!)
```

Для public нужно: `GatewayPorts yes` в `/etc/ssh/sshd_config` на сервере.

**LILITH:**
> *"Remote Forward = двусторонний меч. Удобно для development. Опасно для production. Открываешь локальный сервис миру — убедись что он secure. Лучше: только для testing, временно."*

---

#### 💻 Практика: Setup Remote Forward (3 мин)

**Задание:** Expose локальный web сервер через туннель.

```bash
# 1. Start local web server
python3 -m http.server 8000
# Serving HTTP on 0.0.0.0 port 8000...

# 2. In new terminal: Setup remote forward
ssh -R 9000:localhost:8000 moscow -N

# Now:
# - Your local server: localhost:8000
# - Accessible on moscow: moscow:9000 (from moscow's localhost)

# 3. Test from moscow
ssh moscow "curl http://localhost:9000"
# Should see your local files!

# Alternative: ngrok-like (if GatewayPorts enabled on server)
ssh -R 0.0.0.0:9000:localhost:8000 moscow -N
# Now anyone can: curl http://moscow-ip:9000
```

**LILITH:**
> *"Это типа ngrok, только через SSH. ngrok = SaaS, стоит денег, третья сторона. SSH Remote Forward = бесплатно, твой сервер, твой контроль."*

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** В чём разница?

```bash
# A)
ssh -L 8080:localhost:80 moscow

# B)
ssh -R 8080:localhost:80 moscow
```

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ:**

**A) Local Forward (-L):**
```
Moscow server port 80 → tunnel → Your localhost:8080

You access: http://localhost:8080
Actually connecting to: moscow:80 (через tunnel)
```

**Use case:** Доступ к web серверу на moscow с твоей машины.

---

**B) Remote Forward (-R):**
```
Your localhost:80 → tunnel → Moscow server port 8080

Someone on moscow accesses: http://localhost:8080
Actually connecting to: your machine port 80 (через tunnel)
```

**Use case:** Твой локальный web сервер доступен на moscow.

---

**Направление:**
- **-L** (Local): Remote → You (ты достаёшь remote)
- **-R** (Remote): You → Remote (remote достаёт тебя)

**LILITH:**
> *"L = Local = туннель к тебе (ты клиент). R = Remote = туннель от тебя (ты сервер). Путаешь — неправильный трафик летит."*

</details>

---

### Цикл 5: Dynamic Forward (SOCKS Proxy) (12 минут) 🌐

#### 🎬 Сюжет (2 мин)

**Виктор:**
> *"Макс, следующая задача. Тебе нужно зайти на internal wiki команды. Доступ только из корпоративной сети. Ты дома. Как?"*

**Макс:**
> *"Local Forward?"*

**Виктор:**
> *"Можно, но wiki ссылается на десятки других internal ресурсов — базы, API, файлы. Делать туннель для каждого? 50 туннелей?"*

**Дмитрий:**
> *"Dynamic Forward. SOCKS proxy. ОДИН туннель для ВСЕГО трафика. Браузер отправляет весь трафик через SSH. Как будто ты физически в офисе."*

**LILITH:**
> *"Local Forward = один порт. Dynamic Forward = все порты. Universal tunnel."*

---

#### 📚 Теория: Dynamic Forward (SOCKS Proxy) (6 мин)

**🎭 МЕТАФОРА #5: SOCKS Proxy = Универсальный переводчик**

```
Без SOCKS (Local Forward):
  English speaker → English translator
  French speaker → French translator
  German speaker → German translator
  (Нужен переводчик для каждого языка!)

С SOCKS (Dynamic Forward):
  Any speaker → Universal translator
  (Один переводчик для всех языков!)
```

---

**Сравнение forwarding types:**

| Type | Ports | Use case |
|------|-------|----------|
| **Local (-L)** | ONE port | Single service (DB, API) |
| **Remote (-R)** | ONE port | Expose local service |
| **Dynamic (-D)** | ALL ports | Browser, all traffic |

---

**Dynamic Forward Syntax:**

```bash
ssh -D [local_port] [ssh_server]
```

**Пример:**
```bash
ssh -D 1080 moscow

# Расшифровка:
#   1080    : локальный SOCKS proxy port (стандарт)
#   moscow  : SSH сервер
```

**Что происходит:**
```
Your Machine:                      Moscow Server:

Browser/App                        Corporate Network:
    ↓                              ↓
SOCKS Proxy (localhost:1080)       wiki.internal
    ↓                              db.internal
SSH Client ─[encrypted tunnel]───→ SSH Server ───→ api.internal
                                              ↓
                                         ANY internal resource!
```

**Flow:**
1. Браузер подключается к SOCKS proxy (localhost:1080)
2. Браузер говорит proxy: "Хочу wiki.internal:80"
3. Proxy передаёт через SSH tunnel в moscow
4. Moscow подключается к wiki.internal:80
5. Ответ возвращается через tunnel в браузер

**Результат:** Браузер думает что все сайты в corporate network!

---

**💡 AHA Moment: Dynamic = автоматический Local Forward для любого порта!**

```bash
# Вместо:
ssh -L 80:wiki.internal:80 \
    -L 443:wiki.internal:443 \
    -L 5432:db.internal:5432 \
    -L 8080:api.internal:8080 \
    moscow

# Просто:
ssh -D 1080 moscow
# + Configure browser to use SOCKS proxy localhost:1080

# Browser automatically tunnels ALL connections!
```

---

**Browser configuration:**

**Firefox:**
```
Settings → Network Settings → Manual proxy configuration
  SOCKS Host: localhost
  Port: 1080
  ☑ SOCKS v5
  ☑ Proxy DNS when using SOCKS v5 (важно!)
```

**Chrome (через command line):**
```bash
google-chrome --proxy-server="socks5://localhost:1080"
```

**System-wide (Linux):**
```bash
export ALL_PROXY=socks5://localhost:1080
```

**⚠️ DNS Leak warning:**

Без "Proxy DNS" опции:
```
DNS query → ISP (unencrypted)
→ ISP видит что ты запрашиваешь wiki.internal!
```

С "Proxy DNS":
```
DNS query → SOCKS proxy → SSH tunnel → moscow DNS
→ ISP видит только SSH, не DNS queries!
```

**LILITH:**
> *"'Proxy DNS' = критично для privacy. Без этого DNS queries утекают. ISP видит какие сайты ты открываешь. С proxy DNS — всё через tunnel."*

---

#### 💻 Практика: Setup SOCKS Proxy (3 мин)

**Задание:** Настройте SOCKS proxy через SSH.

```bash
# 1. Start SOCKS proxy
ssh -D 1080 moscow -N

# 2. Configure browser (Firefox):
#    Settings → Network → Manual proxy
#    SOCKS Host: localhost
#    Port: 1080
#    SOCKS v5: ☑
#    Proxy DNS: ☑

# 3. Test: Open browser
firefox &

# Visit: https://ifconfig.me
# Should show: moscow server IP (не твой!)

# 4. Test DNS:
curl --socks5-hostname localhost:1080 http://internal-wiki.local
# Works! (без SOCKS → would fail)

# Alternative: curl with SOCKS
curl --socks5 localhost:1080 https://example.com

# Git через SOCKS
git config --global http.proxy socks5://localhost:1080

# npm через SOCKS
npm config set proxy socks5://localhost:1080
```

**LILITH:**
> *"SOCKS proxy = универсальный. Работает с: browser, curl, git, npm, apt, docker. Any TCP traffic. Один туннель — всё закрыто."*

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** Что лучше для browsing corporate network?

a) `ssh -L 80:wiki:80 -L 443:api:443 -L ...` (Local Forward для каждого)
b) `ssh -D 1080` (Dynamic Forward SOCKS)

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ: b) Dynamic Forward!**

**Почему:**

**Local Forward проблемы:**
- ❌ Нужен туннель для КАЖДОГО сервиса
- ❌ Не знаешь заранее какие порты понадобятся
- ❌ Wiki ссылается на images/css/js с других серверов
- ❌ 50+ туннелей = nightmare management

**Dynamic Forward преимущества:**
- ✅ ОДИН туннель для ВСЕГО
- ✅ Браузер сам решает что туннелировать
- ✅ Работает с любыми ссылками автоматически
- ✅ Простота: `ssh -D 1080` + browser config

**Когда Local Forward:**
- Один конкретный сервис (DB, API)
- Нужен точный контроль
- Специфичное приложение (не браузер)

**Когда Dynamic Forward:**
- Browsing multiple sites
- Corporate network access
- VPN-like experience
- Universal proxy

**LILITH:**
> *"Local Forward = снайперская винтовка (точность). Dynamic Forward = дробовик (широкий охват). Browsing network? Дробовик."*

</details>

---

### Цикл 6: VPN Concepts (WireGuard vs OpenVPN) (12 минут) 🔐

#### 🎬 Сюжет (3 мин)

**Анна:**
> *"SSH tunneling — хорошо для разового доступа. Но команде из 5 человек нужно постоянное соединение. 24/7. VPN."*

**Макс:**
> *"VPN... типа как в фильмах? 'Используй VPN чтобы спрятаться от хакеров'?"*

**Анна:**
> *"Не совсем. VPN для приватности (скрыть IP) — это потребительский VPN (NordVPN, ExpressVPN). Мы делаем корпоративный VPN — защищённая сеть для команды. Приватный туннель между серверами."*

**Алекс:**
> *"OpenVPN vs WireGuard. OpenVPN — старый, сложный, медленный, но повсеместный. WireGuard — новый, простой, быстрый, современный. Выбираем WireGuard."*

**Виктор:**
> *"Сервер в Цюрихе. Швейцария — нейтральная территория, строгие privacy законы. Если Крылов попытается запросить данные — Swiss court откажет."*

---

#### 📚 Теория: VPN Concepts (6 мин)

**🎭 МЕТАФОРА #6: VPN = Частная дорога**

```
Без VPN (публичный интернет):

  You ──────[открытая дорога]──────→ Server
      🚗💨                  👀 ISP видит всё
      Любой может подслушать         👀 Krylov sniffing

С VPN:

  You ──[зашифрованный туннель]──→ VPN Server ──→ Internet
      🚗🔒
      ISP видит только VPN connection
      Крылов видит encrypted data
      Реальные данные скрыты
```

---

**VPN vs SSH Tunneling:**

| Feature | SSH Tunneling | VPN |
|---------|---------------|-----|
| **Установка** | Простой (одна команда) | Сложнее (конфиги, ключи) |
| **Сценарий** | Разовый, временный | Постоянный, всегда включён |
| **Производительность** | Медленнее (overhead) | Быстрее (kernel-level) |
| **Весь трафик** | Нет (только конфигурированное) | Да (весь трафик автоматом) |
| **Переносимость** | Любая OS с SSH | Нужен VPN client |
| **Когда** | Быстрый доступ, dev | Production, команда |

**SSH Tunneling:**
- ✅ Для: Быстрый доступ к БД, emergency, разработка
- ✅ Просто: `ssh -D 1080 server`

**VPN:**
- ✅ Для: Постоянная работа, вся команда, production
- ✅ Автоматически: Весь трафик через VPN без настройки

---

**OpenVPN vs WireGuard:**

| Параметр | OpenVPN | WireGuard |
|---------|---------|-----------|
| **Год** | 2001 | 2019 |
| **Размер кода** | ~400,000 строк C | ~4,000 строк C |
| **Скорость** | 🐢 Медленно (userspace) | 🚀 Быстро (kernel) |
| **Установка** | 😫 Сложно (сертификаты, конфиги) | 😊 Просто (только ключи) |
| **Шифрование** | AES-256-CBC | ChaCha20-Poly1305 |
| **Мобильные** | ⚠️ Плохо для батареи | ✅ Отлично для батареи |
| **Статус** | Устаревший (но широко используется) | Современный (новый стандарт) |

**LILITH:**
> *"OpenVPN = 400K lines. WireGuard = 4K lines. 100× меньше кода. Меньше кода = меньше bugs, faster audit, harder to backdoor. WireGuard выиграл. 2024 — WireGuard год."*

---

**WireGuard Key Concepts:**

```
1. Public/Private Key Pairs
   (как SSH, но для VPN)

2. Peer-to-peer
   НЕТ "client/server" — только "peers"
   Любой peer может инициировать connection

3. Simple Config
   ~10 строк конфига per peer

4. UDP-based
   Port: 51820 (default)

5. Stateless
   No handshake daemon running
   Minimal overhead
```

**Example WireGuard Config:**

```ini
[Interface]
PrivateKey = <your-private-key>
Address = 10.8.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = <server-public-key>
Endpoint = vpn-server.com:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
```

**Расшифровка:**
- `PrivateKey`: Твой приватный ключ (secret!)
- `Address`: Твой IP в VPN сети (10.8.0.x)
- `PublicKey`: Публичный ключ VPN сервера
- `Endpoint`: Адрес VPN сервера
- `AllowedIPs`: Какой трафик через VPN (0.0.0.0/0 = всё)

---

**💡 AHA Moment: WireGuard = stateless firewall!**

Традиционный VPN:
```
1. Client → Server: Hello
2. Server → Client: Challenge
3. Client → Server: Response
4. Server: OK, connected
... постоянный daemon держит connection
```

WireGuard:
```
Packet приходит → есть valid signature? → forward
No "connection", no "state", no daemon
Just cryptography + routing
```

**Результат:**
- Быстрее (no handshake overhead)
- Меньше battery (no keep-alive daemon)
- Надёжнее (connection невозможно "dropped")

---

#### 💻 Практика: Understanding WireGuard (2 мин)

**Задание:** Изучите WireGuard конфиг (no real setup yet).

```bash
# В Episode 08 мы focus на ПОНИМАНИИ VPN
# Реальный setup требует root + может конфликтовать с сетью

# Посмотрите пример конфига server:

# /etc/wireguard/wg0.conf (server)
[Interface]
PrivateKey = <server-priv-key>
Address = 10.8.0.1/24      # Server IP в VPN
ListenPort = 51820         # UDP port
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT

[Peer]                     # Client 1: Max
PublicKey = <max-pub-key>
AllowedIPs = 10.8.0.2/32   # Max IP в VPN

[Peer]                     # Client 2: Alex
PublicKey = <alex-pub-key>
AllowedIPs = 10.8.0.3/32   # Alex IP в VPN

# Client config:
[Interface]
PrivateKey = <max-priv-key>
Address = 10.8.0.2/24      # My IP в VPN
DNS = 1.1.1.1

[Peer]                     # VPN Server
PublicKey = <server-pub-key>
Endpoint = vpn-zurich.kernel-shadows.com:51820
AllowedIPs = 0.0.0.0/0     # All traffic через VPN
PersistentKeepalive = 25   # Keep NAT alive

# Commands (for reference, NOT running now):
# wg-quick up wg0       # Start VPN
# wg-quick down wg0     # Stop VPN
# wg show               # Status
```

**LILITH:**
> *"WireGuard конфиги = симметричны. Server config содержит client public keys. Client config содержит server public key. Public keys = safe to share. Exchange через email — норма."*

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** Почему WireGuard быстрее OpenVPN?

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ:** Kernel space + stateless + меньше кода.

**OpenVPN:**
- Работает в userspace (не kernel)
- Каждый packet: kernel → userspace → process → encrypt → kernel
- Context switching = slow

**WireGuard:**
- Работает В kernel (kernel module)
- Packets обрабатываются без выхода из kernel
- Прямо в network stack = fast

**Плюс:**
- Stateless (no connection tracking overhead)
- Меньше кода (4K vs 400K lines)
- Modern crypto (ChaCha20 оптимизирован для speed)

**Benchmark:**
```
OpenVPN:   ~100-200 Mbps
WireGuard: ~1000+ Mbps (wire speed!)
```

**LILITH:**
> *"Kernel space vs userspace — разница между Ferrari и велосипедом. Kernel = прямой доступ к hardware. Userspace = через посредников. WireGuard in kernel = максимальная скорость."*

</details>

---

### Цикл 7: WireGuard Setup (Automated Workflow) (15 минут) ⚙️

#### 🎬 Сюжет (3 мин)

**Дмитрий:**
> *"Хорошо, теория понятна. Практика: нужно настроить WireGuard для команды. 5 человек. Сервер в Цюрихе. Каждому — ключи, конфиги, подключение. Вручную?"*

**Макс:**
> *"Ключи для 5 человек, конфиги... это же много шагов?"*

**Дмитрий:**
> *"Да. Именно поэтому — Type A episode! Bash автоматизирует workflow:"*
> *"1. Generate ключи для server + 5 clients"*
> *"2. Create конфиги (server знает про всех clients, clients знают про server)"*
> *"3. Deploy configs"*
> *"4. Test connections"*

**Алекс:**
> *"Руками — 2 часа work + ошибки. Bash скрипт — 5 минут + no errors. Автоматизация."*

**LILITH:**
> *"Это Type A. НЕ пишем свой WireGuard. Используем wg, wg-quick команды. Bash АВТОМАТИЗИРУЕТ workflow. Generate keys × 6, create configs × 6, координация. Multi-step process = Type A territory."*

---

#### 📚 Теория: WireGuard Workflow (7 мин)

**Type A Explicit: Почему это Type A?**

```
Type B: Один инструмент существует
  apt exists → sudo apt install nginx ✅
  dig exists → dig example.com ✅
  ufw exists → sudo ufw allow 80/tcp ✅

Type A: Workflow из нескольких инструментов
  Network audit = ip + ss + netstat + routes analysis ✅
  VPN setup = wg genkey × 6 + config gen × 6 + coordination ✅
```

**VPN Setup Workflow (manual):**

```bash
# Step 1: Generate server keys
wg genkey > server_private.key
wg pubkey < server_private.key > server_public.key

# Step 2: Generate client keys (× 5)
wg genkey > max_private.key
wg pubkey < max_private.key > max_public.key
# ... repeat 4 more times

# Step 3: Create server config
nano /etc/wireguard/wg0.conf
# Add each client as [Peer] with their public key

# Step 4: Create client configs (× 5)
# Each needs server public key + their own private key

# Step 5: Distribute configs to clients
# Email? USB? Secure channel?

# Step 6: Start server
wg-quick up wg0

# Step 7: Each client starts their connection
# ... instructions for each person
```

**Проблемы manual approach:**
- ❌ Repetitive (6 key generations)
- ❌ Error-prone (copy-paste public keys)
- ❌ Time-consuming (2+ hours)
- ❌ Hard to scale (10 clients? 20?)

---

**Type A Solution: Bash Automation**

```bash
#!/bin/bash
# generate_wireguard_configs.sh

TEAM=("max" "alex" "anna" "dmitry" "viktor")
VPN_NET="10.8.0"

# Generate server keys
wg genkey > server.key
wg pubkey < server.key > server.pub

# Generate client keys (loop!)
for member in "${TEAM[@]}"; do
    wg genkey > "${member}.key"
    wg pubkey < "${member}.key" > "${member}.pub"
done

# Create server config (with all clients)
cat > wg0-server.conf << EOF
[Interface]
PrivateKey = $(cat server.key)
Address = ${VPN_NET}.1/24
ListenPort = 51820

EOF

# Add each client as peer
ip_suffix=2
for member in "${TEAM[@]}"; do
    cat >> wg0-server.conf << EOF
[Peer]  # ${member}
PublicKey = $(cat ${member}.pub)
AllowedIPs = ${VPN_NET}.${ip_suffix}/32

EOF
    ((ip_suffix++))
done

# Create client configs (loop!)
ip_suffix=2
for member in "${TEAM[@]}"; do
    cat > "wg0-${member}.conf" << EOF
[Interface]
PrivateKey = $(cat ${member}.key)
Address = ${VPN_NET}.${ip_suffix}/24
DNS = 1.1.1.1

[Peer]
PublicKey = $(cat server.pub)
Endpoint = vpn-zurich.kernel-shadows.com:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF
    ((ip_suffix++))
done

echo "✓ Generated configs for server + ${#TEAM[@]} clients"
ls -1 wg0-*.conf
```

**Результат:** 5 минут работы bash → все конфиги готовы!

---

**💡 AHA Moment: Type A = координация, не замена**

```
НЕ Type A (плохо):
  #!/bin/bash
  # Переписываем WireGuard в bash
  function my_wireguard() {
      # 1000 строк кода пытаясь заменить wg
  }

Type A (правильно):
  #!/bin/bash
  # Используем wg, автоматизируем workflow
  wg genkey > key1       # Используем wg!
  wg genkey > key2       # Используем wg!
  # Create config из keys
  # Deploy configs
  # Start с wg-quick    # Используем wg-quick!
```

**Type A = orchestration, NOT replacement!**

**LILITH:**
> *"Путаница: Type A ≠ 'писать всё в bash'. Type A = 'bash координирует инструменты'. Используешь wg, ssh-keygen, config files. Bash просто автоматизирует их выполнение. Type B = когда УЖЕ ЕСТЬ инструмент для всего workflow."*

---

#### 💻 Практика: Generate WireGuard Configs (4 мин)

**Задание:** Используйте solution script для генерации конфигов.

```bash
# Navigate to episode directory
cd artifacts/

# Run solution script (это Type A!)
../solution/vpn_setup.sh

# Script will:
# 1. Generate SSH keys для team
# 2. Create SSH config
# 3. Generate WireGuard keys для server + 5 clients
# 4. Create WireGuard configs (server + clients)
# 5. Generate final audit report

# Check generated files
ls -la wireguard/
# Should see:
#   wg0-server.conf
#   wg0-max.conf
#   wg0-alex.conf
#   wg0-anna.conf
#   wg0-dmitry.conf
#   wg0-viktor.conf

# Inspect server config
cat wireguard/wg0-server.conf

# Inspect client config
cat wireguard/wg0-max.conf

# Note: реальный deployment требует:
# 1. Copy wg0-server.conf → /etc/wireguard/wg0.conf (на сервере)
# 2. sudo wg-quick up wg0 (на сервере)
# 3. Distribute client configs to each team member
# 4. Each member: wg-quick up wg0-<name>

# For this episode: понимание workflow важнее actual deployment
```

**LILITH:**
> *"Solution script = 695 строк. Type A appropriate. Не пытается заменить wg. Просто автоматизирует: generate × 6, config × 6, distribute, test. Workflow automation = умно."*

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** Почему WireGuard setup = Type A, а firewall setup = Type B?

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ:** Firewall = готовый инструмент. VPN = workflow из шагов.

**Episode 07 (Firewall = Type B):**
```bash
# UFW существует для ВСЕЙ задачи firewall
sudo ufw default deny incoming
sudo ufw allow 22/tcp
sudo ufw enable

# Один инструмент (ufw) делает ВСЁ
# Bash wrapper не нужен → используй ufw напрямую
```

**Episode 08 (VPN = Type A):**
```bash
# НЕТ одного инструмента для "setup VPN for team"
# Нужен workflow:

1. wg genkey (× 6)               # Generate keys
2. Create configs (× 6)          # Manual файлы
3. Coordinate (server ↔ clients) # Public keys exchange
4. Distribute configs            # Send to team
5. wg-quick up (× 6)            # Start на каждой машине
6. Test connections              # Verify

# Bash автоматизирует workflow
# НЕ заменяет wg, использует его!
```

**Критерий:**
- **Type B:** Готовый инструмент для задачи → используй напрямую
- **Type A:** Multi-step workflow → bash автоматизирует

**LILITH:**
> *"Type classification не про 'хорошо/плохо'. Про 'когда bash appropriate'. Firewall = ufw готов. VPN setup = нет готового для 'configure team of 5'. Bash fills gap."*

</details>

---

### Цикл 8: Final Audit + Season 2 Summary (15 минут) 📊

#### 🎬 Сюжет: Season 2 Finale (5 мин)

**23:00 — Zürich Office, День 16**

**VPN работает. Все 5 членов команды подключены. Зелёные индикаторы на мониторе.**

**Виктор:**
> *"Отлично. VPN работает. Весь трафик команды зашифрован. Крылов видит только зашифрованные данные. Операция защищена."*

**Анна** (анализирует логи):
> *"Я проверила за последние 2 часа. Крылов пытался DPI (Deep Packet Inspection). Увидел только ChaCha20 шифротекст. Ничего полезного."*

**Алекс:**
> *"Load average стабилен на 0.8. Задержка через VPN — 15ms overhead. Приемлемо. DNS leaks — ноль. IP leaks — ноль. Firewall + VPN = двойная защита."*

**Дмитрий:**
> *"Season 2 завершён. 4 эпизода:"*
> *"- Episode 05: Основы сетей, аудит"*
> *"- Episode 06: Безопасность DNS, DNSSEC"*
> *"- Episode 07: Firewall, защита от DDoS"*
> *"- Episode 08: VPN, зашифрованная коммуникация"*

**Макс** (смотрит на экран):
> *"16 дней назад я не знал что такое TCP. Сегодня я настроил VPN для команды. Под угрозой Крылова."*

**Виктор:**
> *"Ты справился. Все справились. Но Крылов не сдастся. Он будет эскалировать. Season 3 — System Administration. Санкт-Петербург, Таллин. Новые вызовы."*

---

**LILITH** (финальное сообщение):
```
╔═══════════════════════════════════════════════════════════╗
║         SEASON 2: NETWORKING — COMPLETE! ✓               ║
╚═══════════════════════════════════════════════════════════╝

Episodes: 4/4 ✓
  Episode 05: TCP/IP Fundamentals ✓
  Episode 06: DNS & Name Resolution ✓
  Episode 07: Firewalls & iptables ✓
  Episode 08: VPN & SSH Tunneling ✓

Прогресс: 26.7% (16/60 дней)
Статус: Компетентный системный администратор

Приобретённые навыки:
  ✓ Основы сетей (TCP/IP, модель OSI, маршрутизация)
  ✓ Безопасность DNS (DNSSEC, DoT, защита от спуфинга)
  ✓ Усиление firewall (UFW, iptables, ограничение частоты)
  ✓ Защита от DDoS (время реакции 20 минут)
  ✓ VPN шифрование (WireGuard, ChaCha20-Poly1305)
  ✓ SSH туннелирование (Local, Remote, Dynamic forward)
  ✓ Реагирование на инциденты (под давлением, реальные угрозы)

Статус инфраструктуры:
  ✓ 5 серверов работают
  ✓ Firewall развёрнут (заблокировано 847 botnet IP)
  ✓ VPN работает (подключено 5 клиентов)
  ✓ Весь трафик зашифрован (end-to-end)
  ✓ DNS защищён (DNSSEC включён)
  ✓ Мониторинг активен (24/7 логи)

Статус угроз:
  ⚠️ Крылов активен (но защита держится)
  ⚠️ Попытки DDoS: провалены
  ⚠️ Попытки DPI: провалены (шифрование)
  ⚠️ Личная угроза: усиливается

Развитие персонажа:
  Макс Соколов: Junior → Компетентный (16 дней)
  Уверенность: 35% → 78%
  Доверие команды: получено
  Цель Крылова: подтверждена

Далее: Season 3 — Системное администрирование
Локация: Санкт-Петербург → Таллин 🇪🇪
Дни: 17-24 из 60
Тема: Пользователи, Процессы, Сервисы, Резервное копирование

Готовься к новым вызовам.
Будь острым. Будь зашифрованным. Оставайся в живых.

Конец Season 2.
```

---

#### 📚 Теория: Season 2 Summary (5 мин)

**Что изучили за Season 2:**

**Episode 05: TCP/IP & Networking**
- OSI 7 layers, TCP/IP 4 layers
- IP addressing, subnetting, CIDR
- Routing tables, default gateway
- Network tools: `ip`, `ss`, `netstat`, `ping`, `traceroute`
- Port scanning, service identification

**Episode 06: DNS & Name Resolution**
- DNS hierarchy (Root → TLD → Authoritative)
- Record types: A, AAAA, CNAME, MX, TXT, NS, PTR
- DNS tools: `dig`, `host`, `nslookup`
- DNS spoofing & cache poisoning
- DNSSEC (digital signatures)
- DNS over TLS/HTTPS (DoT/DoH)

**Episode 07: Firewalls & iptables**
- UFW (Uncomplicated Firewall)
- iptables (chains, targets, rules)
- Rate limiting (connlimit, recent, hashlimit)
- SYN flood protection
- Attack logging (rsyslog)
- DDoS mitigation (real-time incident, 20 min response)

**Episode 08: VPN & SSH Tunneling**
- SSH keys (ed25519, generation, security)
- SSH config (~/.ssh/config, automation)
- SSH Local Forward (remote → local)
- SSH Remote Forward (local → remote)
- SSH Dynamic Forward (SOCKS proxy, all traffic)
- VPN concepts (OpenVPN vs WireGuard)
- WireGuard setup (server + clients, ChaCha20)
- Security testing (DNS leaks, IP leaks)

---

**Type A vs Type B — Season 2 Balance:**

```
Episode 05: Type A (network audit — combining tools) ✅
Episode 06: Type B (DNS tools — dig exists) ✅
Episode 07: Type B (firewall — ufw exists) ✅
Episode 08: Type A (VPN setup — workflow automation) ✅

2 Type A / 2 Type B = 50/50 Balance ✅
```

**Философия:**
- **Type B:** Используй готовые инструменты напрямую (эффективность)
- **Type A:** Автоматизируй workflows через bash (координация)
- **Both valid!** Зависит от задачи, не от предпочтений.

---

**Security Posture:**

**Before Season 2:**
- ⚠️ No firewall
- ⚠️ Unencrypted communications
- ⚠️ Password-based SSH
- ⚠️ No DNS security
- ⚠️ Vulnerable to DDoS
- **Risk: CRITICAL**

**After Season 2:**
- ✓ Multi-layer firewall (UFW + iptables + rate limiting)
- ✓ End-to-end encryption (VPN, WireGuard, ChaCha20)
- ✓ Key-based authentication (SSH ed25519)
- ✓ DNS protection (DNSSEC, DoT)
- ✓ DDoS mitigation (connlimit, hashlimit)
- ✓ 24/7 monitoring & logging
- **Risk: MEDIUM** (Krylov active, но defenses strong)

---

#### 💻 Практика: Final Audit (4 мин)

**Задание:** Запустите финальный security audit.

```bash
# Генерация финального отчёта
../solution/vpn_setup.sh

# Отчёт сохранён в:
cat artifacts/season2_final_audit.txt

# Должен включать:
# - Сводка Season 2 (4 эпизода)
# - Статус инфраструктуры (5 серверов, VPN, firewall)
# - Метрики безопасности (заблокированные атаки, статус шифрования)
# - Анализ угроз (таймлайн Крылова)
# - Приобретённые навыки (технические + софт скиллы)
# - Развитие персонажа (прогресс Макса)
# - Предпросмотр Season 3

# Проверка конфигов VPN
ls artifacts/wireguard/

# Проверка конфигов SSH
cat artifacts/ssh_config

# Проверка всех сгенерированных файлов
tree artifacts/
```

**LILITH:**
> *"Season 2 завершён. От junior к competent за 16 дней. Firewall развёрнут, VPN работает, команда защищена. Криптография работает. Крылов разочарован. Хорошая работа. Season 3 — сложнее. Готовься."*

---

#### 🤔 Final Quiz (1 мин)

**Вопрос:** Назовите основное отличие SSH Dynamic Forward от Local Forward.

<details>
<summary>💡 Ответ</summary>

**Local Forward (-L):**
- Туннель для ОДНОГО порта/сервиса
- Нужен для каждого сервиса отдельно
- Use case: DB, API, specific service

**Dynamic Forward (-D):**
- SOCKS proxy для ВСЕХ портов
- Универсальный туннель
- Use case: Browser, multiple services, network access

**Аналогия:**
- Local = снайпер (одна цель)
- Dynamic = дробовик (много целей)

</details>

---

## ✅ Что вы изучили в Episode 08

### Технические навыки:
- ✅ **SSH ключи** — генерация ed25519, концепция публичный/приватный
- ✅ **SSH конфиг** — автоматизация ~/.ssh/config, алиасы
- ✅ **SSH Local Forward** — доступ к удалённым сервисам через туннель
- ✅ **SSH Remote Forward** — публикация локальных сервисов удалённо
- ✅ **SSH Dynamic Forward** — SOCKS proxy для всего трафика
- ✅ **VPN концепции** — сравнение OpenVPN vs WireGuard
- ✅ **WireGuard** — конфигурация, развёртывание, мониторинг
- ✅ **Шифрование** — ChaCha20-Poly1305, сквозная безопасность
- ✅ **Type A workflow** — автоматизация bash для сложных настроек

### Софт скиллы:
- ✅ **Координация** — настройка VPN для 5 членов команды
- ✅ **Мышление безопасности** — шифрование, управление ключами, утечки DNS
- ✅ **Автоматизация рабочих процессов** — понимание когда bash уместен
- ✅ **Завершение сезона** — 4 эпизода, комплексный проект

### Развитие персонажа:
- ✅ **Макс:** Junior → Компетентный системный администратор (16 дней)
- ✅ **Уверенность** выросла под реальной угрозой
- ✅ **Команда** защищена через VPN
- ✅ **Крылов** разочарован (атаки проваливаются)

---

## 📖 Ресурсы

**Man pages:**
```bash
man ssh
man ssh_config
man ssh-keygen
man wg
man wg-quick
```

**Файлы:**
```
~/.ssh/config          # SSH configuration
~/.ssh/id_ed25519      # SSH private key
~/.ssh/id_ed25519.pub  # SSH public key
/etc/wireguard/wg0.conf # WireGuard config
```

**Online:**
- SSH Tunneling Guide: https://www.ssh.com/academy/ssh/tunneling
- WireGuard Documentation: https://www.wireguard.com/quickstart/
- SOCKS Proxy: https://en.wikipedia.org/wiki/SOCKS

---

*"VPN — не для того чтобы скрыть IP от Netflix. VPN — чтобы Крылов не читал что мы планируем. Encryption спасает операции."* — Виктор Петров

**Episode 08 Complete!** ✓
**Season 2: Networking — COMPLETE!** ✓✓✓

**Next:** Season 3 — System Administration (Episodes 09-12) 🔧

---

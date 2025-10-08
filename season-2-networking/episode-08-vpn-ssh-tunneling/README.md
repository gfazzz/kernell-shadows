# Episode 08: VPN & SSH Tunneling

**KERNEL SHADOWS — Season 2: Networking (FINAL)**

```
╔═══════════════════════════════════════════════════════════════╗
║  Episode 08: VPN & SSH Tunneling                             ║
║  Season 2 Finale: Secure Communication                       ║
║                                                               ║
║  Location: Moscow 🇷🇺 → Stockholm 🇸🇪 → Zürich 🇨🇭            ║
║  Day: 15-16 of 60                                             ║
║  Difficulty: ⭐⭐⭐☆☆                                          ║
║  Time: 4-5 hours                                              ║
║  Status: 🔒 SECURE CHANNEL REQUIRED                          ║
╚═══════════════════════════════════════════════════════════════╝
```

---

## 💻 Как выполнять задания

### Сюжет vs Практика

**В сюжете:** Max настраивает VPN сервер в Цюрихе (Швейцария) для защиты команды от прослушки Krylov.

**На практике:** Вы будете работать с SSH конфигурацией, ключами и симулировать VPN setup локально.

---

### Варианты выполнения:

#### 1. **Локально (рекомендуется)** ⭐

Работа с SSH конфигурацией и ключами на своей машине:

```bash
# SSH setup (работает локально)
ssh-keygen -t ed25519
cat ~/.ssh/config
ssh-copy-id user@localhost
```

**OpenVPN симуляция:**
- Используем конфиг файлы и документацию
- Без реального подключения (требует root и может конфликтовать с существующей сетью)
- Фокус на понимании конфигурации и принципов работы

---

#### 2. **Docker (для VPN тестирования)** ⭐⭐⭐

Полноценная симуляция VPN сервера и клиента:

```bash
# OpenVPN server в Docker
docker run -d --name openvpn-server \
    -v $(pwd)/openvpn:/etc/openvpn \
    --cap-add=NET_ADMIN \
    -p 1194:1194/udp \
    kylemanna/openvpn

# WireGuard альтернатива
docker run -d --name wireguard \
    --cap-add=NET_ADMIN \
    -e PUID=1000 -e PGID=1000 \
    -p 51820:51820/udp \
    linuxserver/wireguard
```

**Плюсы:**
- ✅ Реальная работа с VPN без риска сломать систему
- ✅ Изолированная среда
- ✅ Можно экспериментировать

---

#### 3. **Cloud VMs (production-like setup)** ⭐⭐⭐⭐

Настоящий VPN между двумя серверами:

```bash
# Server 1: VPN server (DigitalOcean/AWS)
# Server 2: VPN client (ваша машина или другой сервер)

# Полная настройка OpenVPN/WireGuard
# Реальные сертификаты, routing, firewall rules
```

**⚠️ Требуется:**
- Два сервера (или сервер + ваша машина)
- Публичные IP адреса
- Firewall настройка (UDP port 1194 для OpenVPN)

---

### Рекомендация:

1. **SSH часть:** Выполняйте локально (100% практика)
2. **VPN часть:** Изучите конфигурацию, поймите принципы
3. **Опционально:** Docker для hands-on VPN опыта
4. **Для профи:** Cloud setup (реальный production опыт)

**Фокус эпизода:**
- ✅ SSH tunneling (практика)
- ✅ SSH config и keys (практика)
- ✅ VPN концепции (теория + конфиг файлы)
- ✅ Безопасные коммуникации (принципы)

---

## 🎬 Сюжет

### День 15, 10:00 — Briefing в Москве

**Офис Viktor. Вся команда в сборе: Viktor, Alex, Anna, Dmitry, Max.**

Viktor (серьёзно):
> *"После вчерашней атаки всё изменилось. Krylov оставил сообщение. Он знает про Alex и Max лично. Это уже не просто операция — это охота."*

Anna (показывает анализ на экране):
> *"Я проанализировала трафик за последние 48 часов. Krylov не просто атакует — он прослушивает. Deep Packet Inspection на уровне провайдера. Он видит ВСЁ."*

Max (шокирован):
> *"Всё? Даже наши разговоры?"*

Alex (кивает):
> *"Всё. Каждый незашифрованный пакет. Это его стиль. Он работал в Управлении 'К' — техническая разведка ФСБ. Перехват — его специализация."*

Viktor:
> *"С этого момента — только защищённые каналы. VPN для всего. SSH туннели для доступа. Zero Trust."*

**Dmitry (DevOps):**
> *"У меня есть сервер в Цюрихе. Швейцария, нейтральная территория, строгие законы о приватности. Настроим его как VPN шлюз."*

Viktor:
> *"Max, это твоя задача. Настрой VPN для всей команды. У нас 24 часа. Alex поможет с security."*

---

### 14:00 — Поездка в Стокгольм

**Max летит обратно в Стокгольм. Консультация с Katarina Lindström.**

**Stockholm University, кафедра криптографии. Katarina за доской с математическими формулами.**

Katarina (не отрывается от доски):
> *"VPN без понимания криптографии — самообман. Encryption is mathematics. Mathematics doesn't lie. Unlike people."*

Max:
> *"Мне нужно защитить коммуникации команды. OpenVPN или WireGuard?"*

Katarina (поворачивается):
> *"WireGuard. Новый, быстрый, аудирован. 4000 строк кода против 400,000 у OpenVPN. Меньше кода = меньше багов. Меньше багов = больше безопасности."*

Max:
> *"Но OpenVPN проверен временем..."*

Katarina:
> *"Time doesn't validate cryptography. Mathematics does. WireGuard использует ChaCha20, Poly1305, Curve25519. Modern, proven, fast."*

**Она пишет на доске:**
```
OpenVPN:
  + Mature (с 2001)
  + Широкая поддержка
  + Гибкая настройка
  - Сложная конфигурация
  - Медленнее
  - Большая кодовая база (больше attack surface)

WireGuard:
  + Простота (400 строк vs 4000)
  + Скорость (современная криптография)
  + Безопасность (меньше кода = меньше багов)
  - Новый (с 2020 в Linux kernel)
  - Меньше legacy поддержки
```

Katarina:
> *"Выбирай сам. Но помни: в security важна не сложность, а корректность. 'Perfection is achieved not when there is nothing more to add, but when there is nothing left to take away.' — Saint-Exupéry."*

Max (улыбается):
> *"Вы цитируете французского писателя при обсуждении криптографии?"*

Katarina (впервые улыбается):
> *"Cryptography — это искусство убирать лишнее. Как good code. Как good design. Elegance matters."*

---

### 18:00 — Возвращение в Москву. Разговор с Alex

**Вечер. Офис пуст. Только Max и Alex. На экранах — конфигурационные файлы VPN.**

Alex (молча смотрит в окно):
> *"Ты знаешь почему я покинул ФСБ?"*

Max (удивлён):
> *"Ты никогда не рассказывал..."*

Alex (поворачивается):
> *"Krylov. Мой бывший начальник. Управление 'К', отдел компьютерных преступлений. На бумаге — мы боремся с киберпреступностью. На практике..."*

**Пауза.**

Alex:
> *"...на практике он фабриковал дела. Подбрасывал улики. Превращал обычных программистов в 'хакеров'. Quota. Каждый месяц нужны были аресты. Статистика важнее правды."*

Max:
> *"И ты отказался."*

Alex:
> *"Я отказался сажать невиновных. Была одна девочка, 19 лет, студентка. Krylov хотел обвинить её в краже данных. Я увидел логи — она не виновата. Отказался подписывать протокол."*

**Alex сжимает кулаки.**

Alex:
> *"На следующий день меня вызвали наверх. Предложили 'переосмыслить позицию'. Я подал рапорт об увольнении. Krylov сказал: 'Предатель. Ты пожалеешь.' И вот мы здесь."*

Max:
> *"Он охотится на тебя из мести?"*

Alex:
> *"Не только на меня. На всех кто со мной. Viktor взял меня когда никто не хотел — ex-FSB. Dmitry, Anna — они стали семьёй. Теперь Krylov угрожает им. И тебе. Мой брат."*

**Silence.**

Alex:
> *"Поэтому VPN — это не просто технология. Это защита людей которых я люблю. Настрой его правильно. Пожалуйста."*

Max (кладёт руку на плечо):
> *"Я не подведу. Обещаю."*

---

### LILITH активируется — Security Mode

**LILITH v2.0 (синий режим — encryption focused):**
> *"Threat level: HIGH. Krylov has DPI capabilities (Deep Packet Inspection)."*
>
> *"All unencrypted traffic is compromised. VPN и SSH tunneling — единственная защита."*
>
> *"Mission: Установить зашифрованный канал для команды. ChaCha20-Poly1305 cipher. Curve25519 key exchange. Perfect Forward Secrecy."*
>
> *"Alex доверяет тебе. Не подведи его."*

**Текущее время:** 18:30, Day 15
**Deadline:** 24 часа (до следующей операции)
**Задача:** Setup secure communication для 5 членов команды

---

## 🎯 Миссия

**Цель:** Настроить VPN и SSH туннели для защиты коммуникаций команды от прослушки Krylov.

**Команда (5 человек):**
1. Viktor Petrov (координатор)
2. Alex Sokolov (security lead)
3. Anna Kovaleva (forensics)
4. Dmitry Orlov (DevOps)
5. Max Sokolov (sysadmin, ты!)

**Требования:**
- 🔒 End-to-end encryption
- 🛡️ Perfect Forward Secrecy
- 🌐 VPN server в Цюрихе (нейтральная территория)
- 🔑 SSH key-based authentication
- 📁 Automated connection scripts
- 📊 Connection monitoring

**Результат:**
- Все коммуникации зашифрованы
- Krylov не может прослушивать трафик
- Команда работает через безопасный канал

---

## 📚 Задания

### Задание 1: Генерация SSH ключей ⭐

**Контекст:**
Alex: *"Первое — SSH ключи. Password authentication устарел. Krylov может bruteforce. Нужны ed25519 ключи — 256 бит, современная криптография."*

**Задача:**
Сгенерируйте SSH ключи для себя и членов команды.

**Попробуйте сами (3-5 минут):**

```bash
# Создайте SSH ключи для команды
# Ваши команды здесь
```

<details>
<summary>💡 Подсказка 1 (если застряли > 3 минуты)</summary>

**Alex:**
> *"Команда `ssh-keygen`. Алгоритм `-t ed25519`. Comment с email: `-C 'user@email'`. По умолчанию сохранит в `~/.ssh/id_ed25519`."*

Попробуйте:
```bash
# Для себя
ssh-keygen -t ed25519 -C "max@kernel-shadows.com"

# Для других членов команды
ssh-keygen -t ed25519 -C "viktor@kernel-shadows.com" -f ~/.ssh/viktor_key
ssh-keygen -t ed25519 -C "alex@kernel-shadows.com" -f ~/.ssh/alex_key
```

**Что спросит:**
- `Enter file`: путь (Enter = default или укажи свой)
- `Enter passphrase`: пароль для защиты ключа (опционально, но рекомендуется)

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 5 минут)</summary>

**Команды:**

```bash
# Создать директорию для ключей команды
mkdir -p artifacts/ssh_keys

# Генерация ключей для каждого члена команды
# (без passphrase для автоматизации, в продакшене — обязательно с passphr)

# Viktor
ssh-keygen -t ed25519 -C "viktor@kernel-shadows.com" \
    -f artifacts/ssh_keys/viktor_key -N ""

# Alex
ssh-keygen -t ed25519 -C "alex@kernel-shadows.com" \
    -f artifacts/ssh_keys/alex_key -N ""

# Anna
ssh-keygen -t ed25519 -C "anna@kernel-shadows.com" \
    -f artifacts/ssh_keys/anna_key -N ""

# Dmitry
ssh-keygen -t ed25519 -C "dmitry@kernel-shadows.com" \
    -f artifacts/ssh_keys/dmitry_key -N ""

# Max (твой ключ)
ssh-keygen -t ed25519 -C "max@kernel-shadows.com" \
    -f artifacts/ssh_keys/max_key -N ""
```

**Что создалось:**
```
artifacts/ssh_keys/
├── viktor_key          (private key)
├── viktor_key.pub      (public key)
├── alex_key
├── alex_key.pub
├── anna_key
├── anna_key.pub
├── dmitry_key
├── dmitry_key.pub
├── max_key
└── max_key.pub
```

**Проверка:**
```bash
# Показать публичные ключи
cat artifacts/ssh_keys/*.pub

# Показать fingerprint (отпечаток ключа)
ssh-keygen -lf artifacts/ssh_keys/max_key.pub
```

</details>

<details>
<summary>✅ Решение</summary>

**Скрипт генерации ключей:**
```bash
#!/bin/bash

KEYS_DIR="artifacts/ssh_keys"
mkdir -p "$KEYS_DIR"

# Team members
TEAM=("viktor" "alex" "anna" "dmitry" "max")

echo "=== GENERATING SSH KEYS FOR TEAM ==="
echo ""

for member in "${TEAM[@]}"; do
    KEY_FILE="$KEYS_DIR/${member}_key"
    EMAIL="${member}@kernel-shadows.com"

    if [ -f "$KEY_FILE" ]; then
        echo "⚠ Key exists: $KEY_FILE (skipping)"
        continue
    fi

    echo "Generating key for: $member"
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_FILE" -N "" -q

    if [ $? -eq 0 ]; then
        echo "✓ Generated: $KEY_FILE"

        # Show fingerprint
        FINGERPRINT=$(ssh-keygen -lf "${KEY_FILE}.pub" | awk '{print $2}')
        echo "  Fingerprint: $FINGERPRINT"
    else
        echo "✗ Failed: $member"
    fi

    echo ""
done

echo "=== SUMMARY ==="
echo "Keys generated: ${#TEAM[@]}"
echo "Location: $KEYS_DIR/"
echo ""

# List all public keys
echo "Public keys:"
ls -lh "$KEYS_DIR"/*.pub

echo ""
echo "✓ SSH keys ready for team!"
```

**Запуск:**
```bash
chmod +x generate_ssh_keys.sh
./generate_ssh_keys.sh
```

**Результат:**
```
=== GENERATING SSH KEYS FOR TEAM ===

Generating key for: viktor
✓ Generated: artifacts/ssh_keys/viktor_key
  Fingerprint: SHA256:abc123...

Generating key for: alex
✓ Generated: artifacts/ssh_keys/alex_key
  Fingerprint: SHA256:def456...

...

=== SUMMARY ===
Keys generated: 5
Location: artifacts/ssh_keys/

Public keys:
-rw-r--r-- viktor_key.pub (98 bytes)
-rw-r--r-- alex_key.pub   (96 bytes)
...

✓ SSH keys ready for team!
```

</details>

<details>
<summary>🔍 SSH Keys — теория</summary>

### SSH Keys: Public-Key Cryptography

**Что это:**
Asymmetric encryption — пара ключей: публичный (public) и приватный (private).

**Аналогия:**
- **Public key** = замок (можешь дать кому угодно)
- **Private key** = ключ от замка (только у тебя!)

**Как работает:**
```
1. Ты генеришь пару ключей:
   - id_ed25519 (private) — SECRET!
   - id_ed25519.pub (public) — можно публиковать

2. Копируешь public key на сервер:
   server:~/.ssh/authorized_keys

3. При подключении:
   Client: "У меня есть private key для этого public key"
   Server: "Докажи!" (отправляет challenge)
   Client: Подписывает challenge приватным ключом
   Server: Проверяет подпись публичным ключом → OK!
```

**Преимущества над паролями:**
- ✅ Невозможно bruteforce (2^256 комбинаций для ed25519)
- ✅ Можно защитить passphrase (двойная защита)
- ✅ Можно отозвать (удалить public key с сервера)
- ✅ Поддержка hardware keys (YubiKey, etc)

**Алгоритмы:**

```
RSA (старый, медленный):
  - ssh-keygen -t rsa -b 4096
  - Размер: 4096 бит минимум
  - Медленный, но универсально поддерживается

ed25519 (современный, рекомендуется):
  - ssh-keygen -t ed25519
  - Размер: 256 бит (эквивалент RSA 3072)
  - Быстрый, безопасный, compact
  - Основан на Curve25519 (Daniel J. Bernstein)

ECDSA (средний):
  - ssh-keygen -t ecdsa -b 521
  - Использует elliptic curves
  - Быстрее RSA, но ed25519 лучше
```

**Рекомендация:** Используй **ed25519** (если поддерживается) или **RSA 4096** (для legacy систем).

**Генерация:**
```bash
# ed25519 (рекомендуется)
ssh-keygen -t ed25519 -C "your_email@example.com"

# RSA 4096 (для старых систем)
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# С passphrase (рекомендуется!)
ssh-keygen -t ed25519 -C "your_email@example.com"
# Спросит passphrase → введи надёжный пароль
```

**Файлы:**
```bash
~/.ssh/
├── id_ed25519          # Private key (SECRET!)
├── id_ed25519.pub      # Public key (можно публиковать)
├── known_hosts         # Fingerprints известных серверов
├── authorized_keys     # Public keys которым разрешён доступ к ТЕБЕ
└── config              # SSH конфигурация
```

**Копирование ключа на сервер:**
```bash
# Способ 1: автоматический
ssh-copy-id user@server

# Способ 2: ручной
cat ~/.ssh/id_ed25519.pub | ssh user@server "cat >> ~/.ssh/authorized_keys"

# Способ 3: через scp
scp ~/.ssh/id_ed25519.pub user@server:~/.ssh/authorized_keys
```

**Permissions (ВАЖНО!):**
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519       # Private key
chmod 644 ~/.ssh/id_ed25519.pub   # Public key
chmod 644 ~/.ssh/authorized_keys
chmod 644 ~/.ssh/known_hosts
chmod 600 ~/.ssh/config
```

**Проверка ключа:**
```bash
# Fingerprint (отпечаток)
ssh-keygen -lf ~/.ssh/id_ed25519.pub
# SHA256:abc123def456... 256 SHA256 your_email@example.com (ED25519)

# Проверка private key
ssh-keygen -y -f ~/.ssh/id_ed25519
# Выведет соответствующий public key
```

**Использование:**
```bash
# Подключение с конкретным ключом
ssh -i ~/.ssh/custom_key user@server

# Добавление ключа в ssh-agent (для удобства)
eval $(ssh-agent)
ssh-add ~/.ssh/id_ed25519
# Теперь можно подключаться без указания -i
```

**Security best practices:**
- ✅ ВСЕГДА используй passphrase для private keys
- ✅ Храни private keys в безопасном месте (зашифрованный диск)
- ✅ Никогда не передавай private keys по сети
- ✅ Используй разные ключи для разных серверов (advanced)
- ✅ Регулярно ротируй ключи (1 раз в год минимум)
- ✅ Отзывай скомпрометированные ключи немедленно

**Отзыв ключа:**
```bash
# На сервере: удали public key из authorized_keys
ssh user@server
vim ~/.ssh/authorized_keys
# Удали строку с этим ключом
```

</details>

**Проверка:**
```bash
# Убедитесь что ключи созданы
ls -la artifacts/ssh_keys/

# Проверьте fingerprints
for key in artifacts/ssh_keys/*.pub; do
    echo "Key: $key"
    ssh-keygen -lf "$key"
    echo ""
done
```

---

### Задание 2: SSH Config — автоматизация подключений ⭐⭐

**Контекст:**
Alex: *"Теперь SSH config. Вместо `ssh -i key -p 2222 user@long-hostname`, пишешь просто `ssh viktor`. Автоматизация = меньше ошибок."*

**Задача:**
Создайте `~/.ssh/config` для упрощения подключений к серверам команды.

**Попробуйте сами (5-7 минут):**

```bash
# Создайте SSH config для:
# - VPN сервера в Цюрихе
# - Серверов команды в Москве
# - Jump host (bastion) для доступа
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**Alex:**
> *"Файл `~/.ssh/config`. Формат простой: Host nickname, HostName IP, User username, IdentityFile path/to/key. Можно также Port, ForwardAgent, ProxyJump."*

Пример:
```bash
# ~/.ssh/config

Host vpn-server
    HostName 195.14.20.10
    User max
    Port 22
    IdentityFile ~/.ssh/max_key
    ServerAliveInterval 60

Host moscow-server
    HostName 10.50.1.1
    User max
    IdentityFile ~/.ssh/max_key
    ProxyJump vpn-server
```

Использование:
```bash
ssh vpn-server          # Вместо ssh -i ~/.ssh/max_key max@195.14.20.10
ssh moscow-server       # Автоматически через vpn-server
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Полный конфиг для команды:**

```bash
# ~/.ssh/config для KERNEL SHADOWS Operation

# ═══════════════════════════════════════════════════════════════
# Global defaults
# ═══════════════════════════════════════════════════════════════
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    Compression yes
    ForwardAgent no
    AddKeysToAgent yes

# ═══════════════════════════════════════════════════════════════
# VPN Server (Zürich, Switzerland)
# ═══════════════════════════════════════════════════════════════
Host vpn-zurich
    HostName 195.14.20.10
    User max
    Port 22
    IdentityFile ~/.ssh/max_key
    ServerAliveInterval 30
    # Strict checking (first time will ask to confirm)
    StrictHostKeyChecking ask

# ═══════════════════════════════════════════════════════════════
# Moscow Servers (через VPN)
# ═══════════════════════════════════════════════════════════════

# Shadow Server 02 (main server)
Host shadow-02
    HostName 10.50.1.2
    User max
    IdentityFile ~/.ssh/max_key
    ProxyJump vpn-zurich
    # LocalForward 8080 localhost:80

# Viktor's server
Host viktor-server
    HostName 10.50.1.10
    User viktor
    IdentityFile ~/.ssh/viktor_key
    ProxyJump vpn-zurich

# Alex's forensics server
Host alex-forensics
    HostName 10.50.1.11
    User alex
    IdentityFile ~/.ssh/alex_key
    ProxyJump vpn-zurich

# Anna's analysis server
Host anna-analysis
    HostName 10.50.1.12
    User anna
    IdentityFile ~/.ssh/anna_key
    ProxyJump vpn-zurich

# Dmitry's DevOps server
Host dmitry-devops
    HostName 10.50.1.13
    User dmitry
    IdentityFile ~/.ssh/dmitry_key
    ProxyJump vpn-zurich

# ═══════════════════════════════════════════════════════════════
# Stockholm Servers (Erik's infrastructure)
# ═══════════════════════════════════════════════════════════════
Host stockholm-pionen
    HostName bahnhof-pionen.se
    User max
    Port 22
    IdentityFile ~/.ssh/max_key
    # Bahnhof Pionen datacenter (nuclear bunker)

# ═══════════════════════════════════════════════════════════════
# Emergency direct access (bypass VPN)
# ═══════════════════════════════════════════════════════════════
Host shadow-02-direct
    HostName shadow-server-02.ops.internal
    User max
    IdentityFile ~/.ssh/max_key
    Port 22
    # Use only if VPN is down!
```

**Использование:**
```bash
# Подключение к VPN серверу
ssh vpn-zurich

# Подключение к Moscow серверам (автоматически через VPN)
ssh shadow-02
ssh viktor-server
ssh alex-forensics

# Подключение к Stockholm
ssh stockholm-pionen

# Emergency direct access (если VPN недоступен)
ssh shadow-02-direct
```

**ProxyJump объяснение:**
```
Твоя машина → VPN server (Zürich) → Moscow server

ssh shadow-02
# Эквивалентно:
ssh -J vpn-zurich max@10.50.1.2
```

</details>

<details>
<summary>✅ Решение</summary>

**Скрипт генерации SSH config:**
```bash
#!/bin/bash

CONFIG_FILE="artifacts/ssh_config"

cat > "$CONFIG_FILE" << 'EOF'
# SSH Config для KERNEL SHADOWS Operation
# Generated automatically
# Copy to ~/.ssh/config: cp artifacts/ssh_config ~/.ssh/config

# ═══════════════════════════════════════════════════════════════
# Global Settings
# ═══════════════════════════════════════════════════════════════
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    Compression yes
    ForwardAgent no
    AddKeysToAgent yes
    IdentitiesOnly yes

# ═══════════════════════════════════════════════════════════════
# VPN Gateway (Zürich, Switzerland)
# Neutral territory, strong privacy laws
# ═══════════════════════════════════════════════════════════════
Host vpn-zurich vpn
    HostName 195.14.20.10
    User max
    Port 22
    IdentityFile ~/.ssh/max_key
    ServerAliveInterval 30
    StrictHostKeyChecking ask
    # First connection will ask for fingerprint confirmation

# ═══════════════════════════════════════════════════════════════
# Moscow Infrastructure (через VPN для безопасности)
# ═══════════════════════════════════════════════════════════════

# Shadow Server 02 (main operational server)
Host shadow-02 shadow
    HostName 10.50.1.2
    User max
    IdentityFile ~/.ssh/max_key
    ProxyJump vpn-zurich
    LocalForward 8080 localhost:80
    # Port forwarding: localhost:8080 → server:80

# Viktor's coordination server
Host viktor
    HostName 10.50.1.10
    User viktor
    IdentityFile ~/.ssh/viktor_key
    ProxyJump vpn-zurich

# Alex's security server
Host alex
    HostName 10.50.1.11
    User alex
    IdentityFile ~/.ssh/alex_key
    ProxyJump vpn-zurich

# Anna's forensics server
Host anna
    HostName 10.50.1.12
    User anna
    IdentityFile ~/.ssh/anna_key
    ProxyJump vpn-zurich

# Dmitry's DevOps server
Host dmitry
    HostName 10.50.1.13
    User dmitry
    IdentityFile ~/.ssh/dmitry_key
    ProxyJump vpn-zurich

# ═══════════════════════════════════════════════════════════════
# Stockholm (Erik's Bahnhof Pionen datacenter)
# ═══════════════════════════════════════════════════════════════
Host stockholm pionen
    HostName 185.12.64.10
    User max
    Port 22
    IdentityFile ~/.ssh/max_key
    # Nuclear bunker 30m underground

# ═══════════════════════════════════════════════════════════════
# Emergency Access (direct, bypass VPN)
# USE ONLY IF VPN IS DOWN!
# ═══════════════════════════════════════════════════════════════
Host shadow-emergency
    HostName shadow-server-02.ops.internal
    User max
    IdentityFile ~/.ssh/max_key
    Port 22
    # Direct connection (не через VPN)
    # Krylov может видеть этот трафик!

# ═══════════════════════════════════════════════════════════════
# Examples of advanced usage
# ═══════════════════════════════════════════════════════════════

# Dynamic port forwarding (SOCKS proxy)
# Host socks-proxy
#     HostName vpn-zurich
#     DynamicForward 1080
#     # Usage: ssh -N socks-proxy
#     # Then: browser proxy = localhost:1080

# Reverse tunnel (expose local service to remote)
# Host reverse-tunnel
#     HostName shadow-02
#     RemoteForward 8080 localhost:3000
#     # Exposes your local :3000 as server:8080

EOF

echo "✓ SSH config generated: $CONFIG_FILE"
echo ""
echo "To use:"
echo "  cp $CONFIG_FILE ~/.ssh/config"
echo "  chmod 600 ~/.ssh/config"
echo ""
echo "Then simply:"
echo "  ssh vpn         # Connect to VPN server"
echo "  ssh shadow      # Connect to Moscow (via VPN)"
echo "  ssh viktor      # Connect to Viktor's server"
```

**Установка:**
```bash
# Скопировать config
cp artifacts/ssh_config ~/.ssh/config

# Установить правильные permissions
chmod 600 ~/.ssh/config

# Проверить синтаксис
ssh -G shadow-02 | head -20
```

**Использование:**
```bash
# Простое подключение
ssh vpn              # Вместо ssh -i ~/.ssh/max_key max@195.14.20.10
ssh shadow           # Автоматически через VPN!

# С port forwarding
ssh -L 8080:localhost:80 shadow
# Теперь localhost:8080 → shadow:80

# SOCKS proxy (для браузера)
ssh -D 1080 -N vpn
# Browser proxy: localhost:1080
```

</details>

<details>
<summary>🔍 SSH Config — теория</summary>

### SSH Config: Автоматизация подключений

**Где находится:**
```bash
~/.ssh/config          # User-specific
/etc/ssh/ssh_config    # System-wide defaults
```

**Формат:**
```
Host nickname
    Option value
    Option value
```

**Основные опции:**

```bash
Host myserver
    HostName 192.168.1.10        # IP или hostname
    User username                # Username
    Port 22                      # SSH port (default 22)
    IdentityFile ~/.ssh/key      # Path to private key
    ForwardAgent yes|no          # Forward SSH agent
    LocalForward 8080 localhost:80   # Port forwarding
    RemoteForward 8080 localhost:80  # Reverse port forwarding
    DynamicForward 1080          # SOCKS proxy
    ProxyJump bastion            # Jump через другой host
    ServerAliveInterval 60       # Keep-alive (seconds)
    ServerAliveCountMax 3        # Max keep-alive attempts
    Compression yes              # Compress data
    StrictHostKeyChecking ask    # ask|yes|no
```

**ProxyJump (Jump Host / Bastion):**
```
Your machine → Jump host → Target server

Старый способ:
ssh jump-host
ssh target-from-jump

Новый способ (с ProxyJump):
Host target
    HostName 10.0.0.5
    ProxyJump jump-host

ssh target  # Автоматически через jump-host!
```

**Port Forwarding типы:**

**1. Local Forward (доступ к удалённому сервису):**
```bash
Host myserver
    LocalForward 8080 localhost:80

ssh myserver
# Теперь localhost:8080 → myserver:80
# Браузер на localhost:8080 → веб-сервер на myserver:80
```

**2. Remote Forward (expose local service)**
```bash
Host myserver
    RemoteForward 8080 localhost:3000

ssh myserver
# Теперь myserver:8080 → ваш localhost:3000
# Кто-то на myserver может зайти на :8080 и попадёт к вам на :3000
```

**3. Dynamic Forward (SOCKS proxy)**
```bash
Host myserver
    DynamicForward 1080

ssh -N myserver
# Теперь localhost:1080 = SOCKS proxy
# Браузер → proxy localhost:1080 → весь трафик через myserver
```

**Wildcards:**
```bash
# Для всех hosts
Host *
    ServerAliveInterval 60

# Для группы hosts
Host server-*
    User admin
    IdentityFile ~/.ssh/admin_key

Host server-01
    HostName 10.0.0.1

Host server-02
    HostName 10.0.0.2
```

**Включение других файлов:**
```bash
# ~/.ssh/config
Include ~/.ssh/config.d/*

# Создайте файлы:
~/.ssh/config.d/work
~/.ssh/config.d/personal
~/.ssh/config.d/projects
```

**Debugging:**
```bash
# Проверить что будет использовано для host
ssh -G hostname | grep -i 'user\|hostname\|port\|identityfile'

# Verbose connection (see what's happening)
ssh -v hostname
ssh -vv hostname   # More verbose
ssh -vvv hostname  # Even more verbose
```

**Best practices:**
- ✅ Используй короткие псевдонимы (vpn, shadow вместо полных имён)
- ✅ Группируй по проектам/окружениям
- ✅ Используй ProxyJump для безопасности (bastion hosts)
- ✅ ServerAliveInterval для стабильности соединения
- ✅ StrictHostKeyChecking ask (не no!) для безопасности
- ✅ Permissions: chmod 600 ~/.ssh/config

**Пример production конфига:**
```bash
# ~/.ssh/config

# Global defaults
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    Compression yes
    AddKeysToAgent yes
    UseKeychain yes  # macOS only
    IdentitiesOnly yes

# Bastion (jump host)
Host bastion
    HostName bastion.company.com
    User admin
    IdentityFile ~/.ssh/bastion_key

# Production servers (через bastion)
Host prod-*
    User admin
    IdentityFile ~/.ssh/prod_key
    ProxyJump bastion
    StrictHostKeyChecking yes

Host prod-web-01
    HostName 10.0.1.10

Host prod-db-01
    HostName 10.0.2.10

# Development (direct access)
Host dev-*
    User developer
    IdentityFile ~/.ssh/dev_key

Host dev-web-01
    HostName dev-web-01.company.com
```

</details>

**Проверка:**
```bash
# Установить config
cp artifacts/ssh_config ~/.ssh/config
chmod 600 ~/.ssh/config

# Проверить что будет использовано
ssh -G shadow-02 | grep -E 'user|hostname|identityfile|proxyjump'

# Тест (если есть доступ к серверу)
ssh -v shadow-02
```

---


### Задание 3: SSH Tunneling — Local Port Forward ⭐⭐⭐

**Контекст:**
Dmitry: *"У нас есть веб-интерфейс Grafana на внутреннем сервере (10.50.1.20:3000). Он не доступен напрямую — только через VPN. Нужен SSH tunnel."*

**Задача:**
Создайте SSH tunnel чтобы получить доступ к удалённому веб-сервису локально.

**Попробуйте сами (5-7 минут):**

```bash
# Настройте Local Port Forward:
# localhost:3000 → shadow-server:3000 (через VPN)
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**Dmitry:**
> *"SSH флаг `-L`. Формат: `-L local_port:remote_host:remote_port`. Пример: `ssh -L 3000:localhost:3000 shadow-02`."*

Попробуйте:
```bash
# Port forward Grafana
ssh -L 3000:localhost:3000 shadow-02

# Теперь откройте браузер:
# http://localhost:3000
```

**Что происходит:**
```
Ваш браузер → localhost:3000 → SSH tunnel → shadow-02:3000 (Grafana)
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Типы SSH tunneling:**

**1. Local Forward (ты → сервер):**
```bash
ssh -L [local_ip:]local_port:remote_host:remote_port user@ssh_server

# Пример 1: Grafana
ssh -L 3000:localhost:3000 shadow-02
# localhost:3000 → shadow-02:3000

# Пример 2: База данных
ssh -L 5432:10.50.1.25:5432 shadow-02
# localhost:5432 → 10.50.1.25:5432 (PostgreSQL)

# Пример 3: Bind to all interfaces (не только localhost)
ssh -L 0.0.0.0:8080:localhost:80 shadow-02
# Любой может зайти на ваш_ip:8080 → shadow-02:80
```

**2. Remote Forward (сервер → ты):**
```bash
ssh -R remote_port:local_host:local_port user@ssh_server

# Пример: Expose локальный веб-сервер
ssh -R 8080:localhost:3000 shadow-02
# Кто-то на shadow-02:8080 → ваш localhost:3000
```

**3. Dynamic Forward (SOCKS proxy):**
```bash
ssh -D local_port user@ssh_server

# Пример: SOCKS proxy
ssh -D 1080 -N shadow-02
# Браузер proxy = localhost:1080
# Весь трафик → через shadow-02
```

**Флаги:**
- `-N`: Не выполнять команды (только tunnel)
- `-f`: Background mode
- `-v`: Verbose (debugging)

</details>

<details>
<summary>✅ Решение</summary>

**Скрипт для создания SSH tunnel:**
```bash
#!/bin/bash

# ssh_tunnel.sh - Автоматизация SSH tunnels

TUNNEL_TYPE="$1"
LOCAL_PORT="$2"
REMOTE_HOST="$3"
REMOTE_PORT="$4"
SSH_SERVER="${5:-shadow-02}"

usage() {
    cat << EOF
Usage: $0 <type> <local_port> <remote_host> <remote_port> [ssh_server]

Types:
  local   - Local port forward (access remote service locally)
  remote  - Remote port forward (expose local service remotely)
  dynamic - Dynamic forward (SOCKS proxy)

Examples:
  # Grafana access
  $0 local 3000 localhost 3000

  # PostgreSQL access
  $0 local 5432 10.50.1.25 5432

  # SOCKS proxy
  $0 dynamic 1080

  # Expose local web server
  $0 remote 8080 localhost 3000
EOF
    exit 1
}

if [ $# -lt 2 ]; then
    usage
fi

case "$TUNNEL_TYPE" in
    local)
        if [ $# -lt 4 ]; then
            echo "Error: local forward requires 4 arguments"
            usage
        fi
        
        echo "=== LOCAL PORT FORWARD ==="
        echo "localhost:$LOCAL_PORT → $REMOTE_HOST:$REMOTE_PORT (via $SSH_SERVER)"
        echo ""
        
        # Check if port is already in use
        if lsof -Pi :$LOCAL_PORT -sTCP:LISTEN -t >/dev/null 2>&1 ; then
            echo "⚠ Warning: Port $LOCAL_PORT is already in use"
            exit 1
        fi
        
        echo "Starting tunnel..."
        ssh -L $LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT -N $SSH_SERVER &
        
        PID=$!
        echo "✓ Tunnel started (PID: $PID)"
        echo "  Access: http://localhost:$LOCAL_PORT"
        echo ""
        echo "To stop: kill $PID"
        
        # Save PID
        echo $PID > /tmp/ssh_tunnel_$LOCAL_PORT.pid
        ;;
        
    remote)
        if [ $# -lt 4 ]; then
            echo "Error: remote forward requires 4 arguments"
            usage
        fi
        
        echo "=== REMOTE PORT FORWARD ==="
        echo "$SSH_SERVER:$LOCAL_PORT → localhost:$REMOTE_PORT"
        echo ""
        
        echo "Starting reverse tunnel..."
        ssh -R $LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT -N $SSH_SERVER &
        
        PID=$!
        echo "✓ Reverse tunnel started (PID: $PID)"
        echo "  On $SSH_SERVER: curl localhost:$LOCAL_PORT"
        echo ""
        echo "To stop: kill $PID"
        ;;
        
    dynamic)
        echo "=== DYNAMIC FORWARD (SOCKS) ==="
        echo "SOCKS proxy: localhost:$LOCAL_PORT"
        echo ""
        
        # Check if port is already in use
        if lsof -Pi :$LOCAL_PORT -sTCP:LISTEN -t >/dev/null 2>&1 ; then
            echo "⚠ Warning: Port $LOCAL_PORT is already in use"
            exit 1
        fi
        
        echo "Starting SOCKS proxy..."
        ssh -D $LOCAL_PORT -N $SSH_SERVER &
        
        PID=$!
        echo "✓ SOCKS proxy started (PID: $PID)"
        echo ""
        echo "Configure browser:"
        echo "  Proxy type: SOCKS5"
        echo "  Proxy host: localhost"
        echo "  Proxy port: $LOCAL_PORT"
        echo ""
        echo "To stop: kill $PID"
        
        # Save PID
        echo $PID > /tmp/ssh_socks_$LOCAL_PORT.pid
        ;;
        
    *)
        echo "Error: Unknown type '$TUNNEL_TYPE'"
        usage
        ;;
esac
```

**Использование:**
```bash
chmod +x ssh_tunnel.sh

# Grafana tunnel
./ssh_tunnel.sh local 3000 localhost 3000
# Открой http://localhost:3000

# PostgreSQL tunnel
./ssh_tunnel.sh local 5432 10.50.1.25 5432
# psql -h localhost -p 5432

# SOCKS proxy
./ssh_tunnel.sh dynamic 1080
# Browser → SOCKS5 localhost:1080

# Остановка tunnel
kill $(cat /tmp/ssh_tunnel_3000.pid)
```

**Проверка активных tunnels:**
```bash
# Показать активные SSH соединения
ps aux | grep 'ssh -[LRD]'

# Показать какие порты слушают
lsof -i -P | grep LISTEN | grep ssh

# Тест tunnel
curl http://localhost:3000
```

</details>

<details>
<summary>🔍 SSH Tunneling — теория</summary>

### SSH Tunneling: Зашифрованные каналы

**Что это:**
SSH tunnel (port forwarding) — зашифрованный канал для передачи трафика другого протокола через SSH.

**Зачем:**
- ✅ Доступ к внутренним сервисам (не доступны напрямую)
- ✅ Шифрование незашифрованного трафика (HTTP → SSH → HTTPS)
- ✅ Обход firewalls (если SSH разрешён, можно туннелировать что угодно)
- ✅ Безопасный доступ к базам данных
- ✅ SOCKS proxy для браузера

---

### Типы SSH Tunneling:

**1. Local Port Forward (`-L`)**

```
[Your Machine] --SSH--> [SSH Server] --> [Target Service]
     ↑                                          ↑
     └─ localhost:local_port                   └─ target:port
```

**Команда:**
```bash
ssh -L local_port:target_host:target_port user@ssh_server
```

**Примеры:**

```bash
# Доступ к внутренней базе данных
ssh -L 5432:db-internal:5432 bastion
# Теперь: psql -h localhost -p 5432

# Доступ к веб-интерфейсу
ssh -L 8080:10.0.0.50:80 bastion
# Браузер: http://localhost:8080

# Bind ко всем интерфейсам (не только localhost)
ssh -L 0.0.0.0:8080:target:80 bastion
# Другие машины могут подключиться к вашему IP:8080
```

**Use case:** Доступ к сервисам за firewall

---

**2. Remote Port Forward (`-R`)**

```
[Your Machine] <--SSH-- [SSH Server] <-- [External Users]
     ↑                        ↑
     └─ localhost:local_port └─ remote:port
```

**Команда:**
```bash
ssh -R remote_port:local_host:local_port user@ssh_server
```

**Примеры:**

```bash
# Expose локальный веб-сервер
ssh -R 8080:localhost:3000 server
# На сервере: curl localhost:8080 → ваш localhost:3000

# Демо для клиента
ssh -R 80:localhost:8000 demo-server
# Клиент заходит на demo-server.com → видит ваш localhost:8000
```

**Use case:** Показать локальную разработку, обойти NAT

---

**3. Dynamic Port Forward (`-D`) — SOCKS Proxy**

```
[Your Machine] --SSH--> [SSH Server] ---> [Internet]
     ↑                      ↑
     └─ SOCKS localhost:1080 └─ Выход в интернет
```

**Команда:**
```bash
ssh -D local_port user@ssh_server
```

**Пример:**

```bash
# Создать SOCKS proxy
ssh -D 1080 -N remote-server

# Настроить браузер:
# Proxy: SOCKS5
# Host: localhost
# Port: 1080

# Теперь весь браузерный трафик идёт через remote-server
```

**Use case:** VPN-подобный эффект, обход geo-restrictions

---

### Полезные флаги:

```bash
-N    # Не выполнять команды (только tunnel)
-f    # Background mode (fork)
-v    # Verbose (debugging)
-o    # Options (e.g. -o ExitOnForwardFailure=yes)
-g    # Allow remote hosts to connect to local forwarded ports

# Пример использования:
ssh -L 8080:localhost:80 -N -f server
# Tunnel в фоне, без интерактивной сессии
```

---

### Проверка и отладка:

**1. Проверить активные tunnels:**
```bash
# Все SSH процессы
ps aux | grep ssh

# Только tunnels
ps aux | grep 'ssh -[LRD]'

# Слушающие порты SSH
lsof -i -P | grep ssh | grep LISTEN
```

**2. Убить tunnel:**
```bash
# По PID
kill $(pgrep -f 'ssh -L 8080')

# Или найти и убить
ps aux | grep 'ssh -L 8080'
kill <PID>
```

**3. Проверить что tunnel работает:**
```bash
# Для Local forward
curl http://localhost:8080

# Для SOCKS proxy
curl --socks5 localhost:1080 http://example.com

# Показать routing
netstat -an | grep 8080
```

---

### Комбинированные tunnels:

**Multiple forwards в одной команде:**
```bash
ssh -L 8080:web:80 -L 5432:db:5432 -L 6379:redis:6379 server
# Три tunnel сразу!
```

**ProxyJump + Local forward:**
```bash
ssh -J bastion -L 8080:internal:80 target
# Через bastion → target, с tunnel
```

---

### Автоматизация через SSH config:

```bash
Host grafana-tunnel
    HostName shadow-02
    LocalForward 3000 localhost:3000
    User max

# Использование:
ssh -N grafana-tunnel
# Автоматически создаст tunnel!
```

---

### Security considerations:

**✅ Best practices:**
- Используй `-N` если не нужна shell сессия
- Bind к `localhost` (не `0.0.0.0`) если не нужен внешний доступ
- Закрывай tunnels когда не используешь
- Используй SSH ключи (не пароли)

**⚠️ Risks:**
- Открытый tunnel = открытый порт (потенциальная атака)
- Remote forward может expose твои сервисы
- SOCKS proxy может быть использован другими для анонимности

---

### Alternative: autossh

**Проблема:** SSH tunnel может отвалиться (network issues)

**Решение:** `autossh` — автоматически переподключается

```bash
# Установка
sudo apt install autossh

# Использование
autossh -M 0 -N -L 8080:localhost:80 server
# -M 0: использует ServerAliveInterval вместо monitoring port

# В фоне
autossh -M 0 -f -N -L 8080:localhost:80 server
```

</details>

**Проверка:**
```bash
# Создать tunnel
ssh -L 3000:localhost:3000 -N shadow-02 &

# Проверить что порт слушает
lsof -i :3000

# Тест
curl http://localhost:3000
```

---

### Задание 4: SSH Dynamic Forward — SOCKS Proxy ⭐⭐

**Контекст:**
Alex: *"Krylov может анализировать DNS запросы — он узнает какие сайты ты посещаешь. SOCKS proxy через VPN решает эту проблему. Весь браузерный трафик пойдёт через зашифрованный туннель."*

**Задача:**
Создайте SOCKS proxy для безопасного веб-сёрфинга.

**Попробуйте сами (5 минут):**

```bash
# Создайте SOCKS proxy на порту 1080
```

<details>
<summary>💡 Подсказка 1 (если застряли > 3 минуты)</summary>

**Alex:**
> *"Флаг `-D`. Формат: `ssh -D port server`. Добавь `-N` чтобы не открывать shell. Пример: `ssh -D 1080 -N vpn-zurich`."*

Попробуйте:
```bash
# Создать SOCKS proxy
ssh -D 1080 -N vpn-zurich &

# Настроить браузер:
# Settings → Network → Proxy
# SOCKS Host: localhost
# Port: 1080
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 7 минут)</summary>

**Complete setup:**

```bash
# 1. Создать SOCKS proxy
ssh -D 1080 -N vpn-zurich &
PID=$!
echo "SOCKS proxy PID: $PID"

# 2. Проверить что работает
lsof -i :1080

# 3. Тест с curl
curl --socks5 localhost:1080 http://ifconfig.me
# Должен показать IP VPN сервера, не твой!

# 4. Браузер setup (Firefox example):
# about:preferences#general → Network Settings
# Manual proxy: SOCKS v5, localhost, 1080
# ✓ Proxy DNS when using SOCKS v5

# 5. Проверка IP в браузере
# Зайди на https://whatismyipaddress.com/
# Должен показать IP VPN сервера (Zürich)
```

**Автоматизация (Firefox CLI):**
```bash
# Для Firefox можно использовать proxy через CLI
firefox --proxy-server="socks5://localhost:1080" &

# Или через environment
export ALL_PROXY=socks5://localhost:1080
curl http://ifconfig.me
```

</details>

<details>
<summary>✅ Решение</summary>

**Скрипт автоматизации SOCKS proxy:**
```bash
#!/bin/bash

# socks_proxy.sh - SOCKS5 proxy через SSH

SOCKS_PORT="${1:-1080}"
SSH_SERVER="${2:-vpn-zurich}"
PID_FILE="/tmp/socks_proxy_${SOCKS_PORT}.pid"

start_proxy() {
    # Check if already running
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "⚠ SOCKS proxy already running on port $SOCKS_PORT"
        echo "  PID: $(cat $PID_FILE)"
        exit 1
    fi
    
    # Check if port is in use
    if lsof -Pi :$SOCKS_PORT -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        echo "⚠ Port $SOCKS_PORT is already in use"
        exit 1
    fi
    
    echo "=== STARTING SOCKS5 PROXY ==="
    echo "Port: $SOCKS_PORT"
    echo "Server: $SSH_SERVER"
    echo ""
    
    # Start proxy
    ssh -D $SOCKS_PORT -N -f $SSH_SERVER
    
    # Wait a bit
    sleep 2
    
    # Get PID
    PID=$(pgrep -f "ssh -D $SOCKS_PORT")
    
    if [ -z "$PID" ]; then
        echo "✗ Failed to start proxy"
        exit 1
    fi
    
    echo $PID > "$PID_FILE"
    
    echo "✓ SOCKS proxy started"
    echo "  PID: $PID"
    echo ""
    
    echo "=== CONFIGURATION ==="
    echo ""
    echo "Browser settings:"
    echo "  Proxy type: SOCKS5"
    echo "  Proxy host: localhost"
    echo "  Proxy port: $SOCKS_PORT"
    echo "  ✓ Enable 'Proxy DNS when using SOCKS v5'"
    echo ""
    
    echo "Test with curl:"
    echo "  curl --socks5 localhost:$SOCKS_PORT http://ifconfig.me"
    echo ""
    
    echo "Environment variable:"
    echo "  export ALL_PROXY=socks5://localhost:$SOCKS_PORT"
    echo ""
    
    echo "Stop proxy:"
    echo "  $0 stop"
}

stop_proxy() {
    if [ ! -f "$PID_FILE" ]; then
        echo "⚠ SOCKS proxy is not running (no PID file)"
        exit 1
    fi
    
    PID=$(cat "$PID_FILE")
    
    if ! kill -0 $PID 2>/dev/null; then
        echo "⚠ Process $PID is not running"
        rm -f "$PID_FILE"
        exit 1
    fi
    
    echo "Stopping SOCKS proxy (PID: $PID)..."
    kill $PID
    
    sleep 1
    
    if kill -0 $PID 2>/dev/null; then
        echo "⚠ Process still running, forcing kill..."
        kill -9 $PID
    fi
    
    rm -f "$PID_FILE"
    echo "✓ SOCKS proxy stopped"
}

status_proxy() {
    if [ ! -f "$PID_FILE" ]; then
        echo "SOCKS proxy: NOT RUNNING"
        exit 1
    fi
    
    PID=$(cat "$PID_FILE")
    
    if kill -0 $PID 2>/dev/null; then
        echo "SOCKS proxy: RUNNING"
        echo "  PID: $PID"
        echo "  Port: $SOCKS_PORT"
        ps -p $PID -o cmd=
    else
        echo "SOCKS proxy: DEAD (stale PID file)"
        rm -f "$PID_FILE"
        exit 1
    fi
}

test_proxy() {
    echo "=== TESTING SOCKS PROXY ==="
    echo ""
    
    # Test 1: Port listening
    echo "[1] Port check:"
    if lsof -Pi :$SOCKS_PORT -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        echo "  ✓ Port $SOCKS_PORT is listening"
    else
        echo "  ✗ Port $SOCKS_PORT is NOT listening"
        exit 1
    fi
    
    # Test 2: Connection test
    echo ""
    echo "[2] Connection test:"
    if curl --socks5 localhost:$SOCKS_PORT --connect-timeout 5 http://ifconfig.me 2>/dev/null; then
        echo "  ✓ SOCKS proxy works"
    else
        echo "  ✗ SOCKS proxy failed"
        exit 1
    fi
    
    # Test 3: IP leak test
    echo ""
    echo "[3] IP leak test:"
    REAL_IP=$(curl -s http://ifconfig.me)
    PROXY_IP=$(curl --socks5 localhost:$SOCKS_PORT -s http://ifconfig.me)
    
    echo "  Your IP: $REAL_IP"
    echo "  Via SOCKS: $PROXY_IP"
    
    if [ "$REAL_IP" = "$PROXY_IP" ]; then
        echo "  ⚠ WARNING: IP is the same! Proxy might not be working."
    else
        echo "  ✓ IP changed via proxy (good!)"
    fi
}

case "${1:-start}" in
    start)
        start_proxy
        ;;
    stop)
        stop_proxy
        ;;
    status)
        status_proxy
        ;;
    test)
        test_proxy
        ;;
    restart)
        stop_proxy 2>/dev/null
        sleep 1
        start_proxy
        ;;
    *)
        echo "Usage: $0 {start|stop|status|test|restart} [port] [ssh_server]"
        exit 1
        ;;
esac
```

**Использование:**
```bash
chmod +x socks_proxy.sh

# Start proxy
./socks_proxy.sh start

# Test
./socks_proxy.sh test

# Status
./socks_proxy.sh status

# Stop
./socks_proxy.sh stop
```

</details>

**Проверка:**
```bash
# Создать proxy
ssh -D 1080 -N vpn-zurich &

# Тест
curl --socks5 localhost:1080 http://ifconfig.me
# Должен показать IP VPN сервера

# Проверить DNS leak
curl --socks5 localhost:1080 https://dnsleaktest.com/
```

---

### Задание 5: VPN Configuration — OpenVPN vs WireGuard ⭐⭐⭐⭐

**Контекст:**
Viktor: *"Пора настраивать VPN. У нас есть сервер в Цюрихе. Katarina рекомендует WireGuard, но OpenVPN тоже вариант. Выбирай."*

**Задача:**
Изучите конфигурацию VPN. Создайте config файлы для OpenVPN или WireGuard.

**Попробуйте сами (10-15 минут):**

```bash
# Выберите: OpenVPN или WireGuard
# Создайте server и client конфиги
```

<details>
<summary>💡 Подсказка 1 (если застряли > 10 минут)</summary>

**Katarina (по видеозвонку):**
> *"WireGuard проще. Один конфиг файл, минимум настроек. OpenVPN — сложнее, но больше гибкости. Для вашей задачи WireGuard достаточно."*

**WireGuard basics:**
```bash
# Установка
sudo apt install wireguard

# Генерация ключей
wg genkey | tee privatekey | wg pubkey > publickey

# Конфиг формат:
[Interface]
Address = 10.8.0.1/24
PrivateKey = <server_private_key>
ListenPort = 51820

[Peer]
PublicKey = <client_public_key>
AllowedIPs = 10.8.0.2/32
```

**OpenVPN basics:**
```bash
# Установка
sudo apt install openvpn easy-rsa

# PKI setup (сертификаты)
make-cadir ~/openvpn-ca
cd ~/openvpn-ca
./easyrsa init-pki
./easyrsa build-ca
./easyrsa gen-req server nopass
./easyrsa sign-req server server
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 15 минут)</summary>

**WireGuard полная конфигурация:**

**Server config (`/etc/wireguard/wg0.conf`):**
```ini
[Interface]
# Server IP в VPN сети
Address = 10.8.0.1/24

# Server private key
PrivateKey = <paste_server_private_key_here>

# Listening port
ListenPort = 51820

# Post-up: enable NAT
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# Peers (clients)
[Peer]
# Viktor
PublicKey = <viktor_public_key>
AllowedIPs = 10.8.0.2/32

[Peer]
# Alex
PublicKey = <alex_public_key>
AllowedIPs = 10.8.0.3/32

[Peer]
# Anna
PublicKey = <anna_public_key>
AllowedIPs = 10.8.0.4/32

[Peer]
# Dmitry
PublicKey = <dmitry_public_key>
AllowedIPs = 10.8.0.5/32

[Peer]
# Max
PublicKey = <max_public_key>
AllowedIPs = 10.8.0.6/32
```

**Client config (Viktor example):**
```ini
[Interface]
# Client IP в VPN сети
Address = 10.8.0.2/24

# Client private key
PrivateKey = <viktor_private_key>

# DNS через VPN
DNS = 1.1.1.1

[Peer]
# Server public key
PublicKey = <server_public_key>

# Server endpoint
Endpoint = vpn-zurich.kernel-shadows.com:51820

# Route all traffic through VPN
AllowedIPs = 0.0.0.0/0

# Keep alive (для NAT)
PersistentKeepalive = 25
```

**Команды:**
```bash
# Генерация ключей для всех
wg genkey | tee server_private.key | wg pubkey > server_public.key
wg genkey | tee viktor_private.key | wg pubkey > viktor_public.key
wg genkey | tee alex_private.key | wg pubkey > alex_public.key
# ... для всех членов команды

# Запуск сервера
sudo wg-quick up wg0

# Проверка
sudo wg show

# Запуск на клиенте
sudo wg-quick up viktor
```

</details>

<details>
<summary>✅ Решение</summary>

**Скрипт генерации WireGuard конфигов:**
```bash
#!/bin/bash

# wireguard_setup.sh - Generate WireGuard configs for team

set -e

CONFIGS_DIR="artifacts/wireguard"
mkdir -p "$CONFIGS_DIR"

# Team members
TEAM=("viktor" "alex" "anna" "dmitry" "max")

# VPN network
VPN_NETWORK="10.8.0"
SERVER_PORT=51820
SERVER_ENDPOINT="vpn-zurich.kernel-shadows.com:$SERVER_PORT"
DNS_SERVER="1.1.1.1"

echo "=== WIREGUARD VPN SETUP ==="
echo "Network: $VPN_NETWORK.0/24"
echo "Server: ${VPN_NETWORK}.1"
echo ""

# Generate server keys
if [ ! -f "$CONFIGS_DIR/server_private.key" ]; then
    echo "[SERVER] Generating keys..."
    wg genkey | tee "$CONFIGS_DIR/server_private.key" | wg pubkey > "$CONFIGS_DIR/server_public.key"
    chmod 600 "$CONFIGS_DIR/server_private.key"
    echo "  ✓ Server keys generated"
fi

SERVER_PRIVATE=$(cat "$CONFIGS_DIR/server_private.key")
SERVER_PUBLIC=$(cat "$CONFIGS_DIR/server_public.key")

# Generate client keys
declare -A CLIENT_PUBLIC
IP_INDEX=2

for member in "${TEAM[@]}"; do
    if [ ! -f "$CONFIGS_DIR/${member}_private.key" ]; then
        echo "[$member] Generating keys..."
        wg genkey | tee "$CONFIGS_DIR/${member}_private.key" | wg pubkey > "$CONFIGS_DIR/${member}_public.key"
        chmod 600 "$CONFIGS_DIR/${member}_private.key"
    fi
    
    CLIENT_PUBLIC[$member]=$(cat "$CONFIGS_DIR/${member}_public.key")
    echo "  ✓ $member keys ready"
done

echo ""
echo "=== GENERATING CONFIGS ==="
echo ""

# Generate server config
echo "[SERVER] Creating wg0.conf..."
cat > "$CONFIGS_DIR/server_wg0.conf" << EOF
# WireGuard Server Config
# Location: Zürich, Switzerland
# Generated: $(date)

[Interface]
# Server address in VPN network
Address = ${VPN_NETWORK}.1/24

# Server private key
PrivateKey = $SERVER_PRIVATE

# Listening port
ListenPort = $SERVER_PORT

# Enable IP forwarding and NAT
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# Team members (peers)
EOF

# Add peers to server config
IP_INDEX=2
for member in "${TEAM[@]}"; do
    cat >> "$CONFIGS_DIR/server_wg0.conf" << EOF

[Peer]
# $member
PublicKey = ${CLIENT_PUBLIC[$member]}
AllowedIPs = ${VPN_NETWORK}.${IP_INDEX}/32
EOF
    IP_INDEX=$((IP_INDEX + 1))
done

echo "  ✓ Server config created"

# Generate client configs
IP_INDEX=2
for member in "${TEAM[@]}"; do
    MEMBER_PRIVATE=$(cat "$CONFIGS_DIR/${member}_private.key")
    MEMBER_IP="${VPN_NETWORK}.${IP_INDEX}"
    
    echo "[$member] Creating ${member}.conf..."
    
    cat > "$CONFIGS_DIR/${member}.conf" << EOF
# WireGuard Client Config
# User: $member
# Generated: $(date)

[Interface]
# Client address in VPN network
Address = ${MEMBER_IP}/24

# Client private key
PrivateKey = $MEMBER_PRIVATE

# DNS through VPN
DNS = $DNS_SERVER

[Peer]
# VPN Server (Zürich)
PublicKey = $SERVER_PUBLIC

# Server endpoint
Endpoint = $SERVER_ENDPOINT

# Route all traffic through VPN (0.0.0.0/0)
# Or only VPN network (${VPN_NETWORK}.0/24)
AllowedIPs = 0.0.0.0/0, ::/0

# Keep alive for NAT traversal
PersistentKeepalive = 25
EOF

    echo "  ✓ ${member}.conf created"
    IP_INDEX=$((IP_INDEX + 1))
done

echo ""
echo "=== SUMMARY ==="
echo "Server config: $CONFIGS_DIR/server_wg0.conf"
echo "Client configs:"
for member in "${TEAM[@]}"; do
    echo "  - $CONFIGS_DIR/${member}.conf"
done
echo ""

echo "=== INSTALLATION ==="
echo ""
echo "On SERVER (Zürich):"
echo "  sudo apt install wireguard"
echo "  sudo cp $CONFIGS_DIR/server_wg0.conf /etc/wireguard/wg0.conf"
echo "  sudo chmod 600 /etc/wireguard/wg0.conf"
echo "  sudo wg-quick up wg0"
echo "  sudo systemctl enable wg-quick@wg0"
echo ""

echo "On CLIENTS:"
for member in "${TEAM[@]}"; do
    echo "  # $member:"
    echo "  sudo cp $CONFIGS_DIR/${member}.conf /etc/wireguard/${member}.conf"
    echo "  sudo chmod 600 /etc/wireguard/${member}.conf"
    echo "  sudo wg-quick up ${member}"
    echo ""
done

echo "=== VERIFICATION ==="
echo "  sudo wg show"
echo "  ping ${VPN_NETWORK}.1"
echo ""

echo "✓ WireGuard setup complete!"
```

**Запуск:**
```bash
chmod +x wireguard_setup.sh
./wireguard_setup.sh
```

**Результат:**
```
artifacts/wireguard/
├── server_wg0.conf        (server config)
├── viktor.conf            (client configs)
├── alex.conf
├── anna.conf
├── dmitry.conf
├── max.conf
├── server_private.key     (keys - СЕКРЕТ!)
├── server_public.key
├── viktor_private.key
├── viktor_public.key
└── ... (keys для всех)
```

</details>

<details>
<summary>🔍 VPN — теория (OpenVPN vs WireGuard)</summary>

### VPN (Virtual Private Network)

**Что это:**
VPN создаёт зашифрованный "туннель" через интернет, как будто вы в одной локальной сети.

**Аналогия:**
```
Без VPN:
You → [Internet] → Server
      ↑ Видно всем (ISP, Krylov, etc)

С VPN:
You → [Encrypted Tunnel] → VPN Server → [Internet] → Server
      ↑ Зашифровано          ↑ Выход здесь
```

**Зачем:**
- ✅ Шифрование трафика (ISP не видит что вы делаете)
- ✅ Скрыть real IP (сайты видят IP VPN сервера)
- ✅ Доступ к внутренним ресурсам (как будто вы в офисе)
- ✅ Обход geo-blocks и censorship
- ✅ Защита в публичных Wi-Fi

---

### OpenVPN vs WireGuard

| Параметр | OpenVPN | WireGuard |
|----------|---------|-----------|
| **Год** | 2001 | 2020 (в Linux kernel) |
| **Код** | ~400,000 строк | ~4,000 строк |
| **Скорость** | Медленнее | Быстрее (2x+) |
| **Настройка** | Сложная | Простая |
| **Криптография** | RSA, AES | Curve25519, ChaCha20 |
| **Audit** | Много аудитов | Меньше (но код меньше) |
| **Поддержка** | Везде | Новее, Linux kernel 5.6+ |
| **UDP/TCP** | Оба | Только UDP |
| **Dynamic IP** | Хорошо | Требует DynDNS |

**Рекомендация:**
- **WireGuard** для новых setup (проще, быстрее)
- **OpenVPN** для enterprise (больше features, legacy support)

---

### WireGuard Architecture

**Принцип:**
```
[Client]                    [Server]
Private Key                 Private Key
Public Key ←───────────────→ Public Key
  ↓                            ↓
Encrypt with                Decrypt with
server's public             client's public
  ↓                            ↓
Send packet ────────────→  Receive packet
```

**Key Exchange: Curve25519**
- Elliptic curve cryptography
- 256-bit keys
- Perfect Forward Secrecy

**Encryption: ChaCha20-Poly1305**
- Stream cipher (fast!)
- Authenticated encryption
- AEAD (Authenticated Encryption with Associated Data)

**Authentication: BLAKE2s**
- Hash function для MAC

---

### WireGuard Config Explained

**Server:**
```ini
[Interface]
Address = 10.8.0.1/24         # VPN IP сервера
PrivateKey = <key>             # Secret!
ListenPort = 51820             # UDP port

# Enable routing
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT
PostUp = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]                         # Client
PublicKey = <client_pub>       # Client's public key
AllowedIPs = 10.8.0.2/32      # Client IP in VPN
```

**Client:**
```ini
[Interface]
Address = 10.8.0.2/24         # VPN IP клиента
PrivateKey = <key>             # Secret!
DNS = 1.1.1.1                  # DNS через VPN

[Peer]                         # Server
PublicKey = <server_pub>       # Server's public key
Endpoint = vpn.example.com:51820  # Where to connect
AllowedIPs = 0.0.0.0/0        # Route all traffic через VPN
PersistentKeepalive = 25       # NAT traversal
```

**AllowedIPs объяснение:**
```
0.0.0.0/0       # Весь трафик через VPN (full tunnel)
10.8.0.0/24     # Только VPN сеть (split tunnel)
10.0.0.0/8      # Только internal network
```

---

### OpenVPN Config (для сравнения)

**Server:**
```
port 1194
proto udp
dev tun

ca ca.crt
cert server.crt
key server.key
dh dh2048.pem

server 10.8.0.0 255.255.255.0
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 1.1.1.1"

keepalive 10 120
cipher AES-256-CBC
auth SHA256
user nobody
group nogroup
persist-key
persist-tun
```

**Client:**
```
client
dev tun
proto udp

remote vpn.example.com 1194

ca ca.crt
cert client.crt
key client.key

cipher AES-256-CBC
auth SHA256

persist-key
persist-tun

remote-cert-tls server
```

**Видно:** OpenVPN сложнее!

---

### Installation & Setup

**WireGuard:**
```bash
# Install (Ubuntu 20.04+)
sudo apt install wireguard

# Generate keys
wg genkey | tee privatekey | wg pubkey > publickey

# Create config
sudo nano /etc/wireguard/wg0.conf

# Start
sudo wg-quick up wg0

# Auto-start on boot
sudo systemctl enable wg-quick@wg0

# Status
sudo wg show
```

**OpenVPN:**
```bash
# Install
sudo apt install openvpn easy-rsa

# Setup PKI
make-cadir ~/openvpn-ca
cd ~/openvpn-ca
./easyrsa init-pki
./easyrsa build-ca
./easyrsa gen-req server nopass
./easyrsa sign-req server server
./easyrsa gen-dh

# Start
sudo openvpn --config server.conf

# Auto-start
sudo systemctl enable openvpn@server
```

---

### Security Best Practices

**✅ DO:**
- Use strong keys (ed25519, Curve25519)
- Enable firewall on VPN server
- Use split tunnel when possible (не route всё через VPN)
- Monitor logs
- Rotate keys регулярно
- Use Perfect Forward Secrecy

**⚠️ DON'T:**
- Use weak ciphers (DES, 3DES, RC4)
- Expose private keys
- Trust free VPN services
- Route sensitive traffic through untrusted VPN
- Ignore DNS leaks

---

### Troubleshooting

**Problem: Can't connect**
```bash
# Check server is listening
sudo netstat -tulpn | grep 51820

# Check firewall
sudo ufw allow 51820/udp

# Check WireGuard status
sudo wg show

# Verbose client
sudo wg-quick up wg0 --verbose
```

**Problem: Connected but no internet**
```bash
# Check IP forwarding
cat /proc/sys/net/ipv4/ip_forward  # Should be 1

# Enable if needed
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

# Check iptables
sudo iptables -t nat -L POSTROUTING
```

**Problem: DNS leak**
```bash
# Test DNS leak
curl https://dnsleaktest.com/

# Check DNS config
cat /etc/resolv.conf

# Force DNS through VPN (WireGuard)
# In client config: DNS = 1.1.1.1
```

</details>

**Проверка:**
```bash
# Сгенерировать конфиги
./wireguard_setup.sh

# Проверить что файлы созданы
ls -la artifacts/wireguard/

# Проверить синтаксис server config
sudo wg-quick strip artifacts/wireguard/server_wg0.conf
```

---

### Задание 6: VPN Monitoring & Testing ⭐⭐

**Контекст:**
Dmitry: *"VPN настроен. Теперь нужен мониторинг — кто подключён, bandwidth usage, connection stability. И тесты — проверить что нет DNS leaks."*

**Задача:**
Создайте скрипт мониторинга VPN и проверки безопасности.

**Попробуйте сами (7-10 минут):**

```bash
# Создайте скрипт который показывает:
# - Активные VPN connections
# - Bandwidth per user
# - DNS leak test
# - IP verification
```

<details>
<summary>💡 Подсказка 1 (если застряли > 7 минут)</summary>

**Dmitry:**
> *"WireGuard команда `wg show` показывает всё. Bandwidth, handshakes, endpoints. Для DNS leak — curl к dnsleaktest.com. Для IP — curl ifconfig.me."*

Попробуйте:
```bash
# Активные connections
sudo wg show

# Bandwidth per peer
sudo wg show wg0 transfer

# IP check
curl http://ifconfig.me

# DNS leak test
curl https://dnsleaktest.com/
```

</details>

<details>
<summary>✅ Решение</summary>

**VPN Monitoring Script:**
```bash
#!/bin/bash

# vpn_monitor.sh - WireGuard VPN monitoring

INTERFACE="wg0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

check_vpn_status() {
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         VPN MONITORING & STATUS CHECK                    ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Check if VPN is running
    if ! ip link show $INTERFACE &>/dev/null; then
        echo -e "${RED}✗ VPN interface $INTERFACE not found${NC}"
        echo "  Start VPN: sudo wg-quick up $INTERFACE"
        exit 1
    fi
    
    echo -e "${GREEN}✓ VPN interface $INTERFACE is UP${NC}"
    echo ""
}

show_peers() {
    echo -e "${YELLOW}=== ACTIVE PEERS ===${NC}"
    echo ""
    
    # Get peers info
    while IFS= read -r line; do
        if [[ $line =~ ^peer:\ (.+) ]]; then
            PEER_KEY="${BASH_REMATCH[1]}"
            echo -e "${BLUE}Peer:${NC} ${PEER_KEY:0:20}..."
        elif [[ $line =~ allowed\ ips:\ (.+) ]]; then
            echo "  IP: ${BASH_REMATCH[1]}"
        elif [[ $line =~ latest\ handshake:\ (.+) ]]; then
            HANDSHAKE="${BASH_REMATCH[1]}"
            echo "  Last handshake: $HANDSHAKE"
            
            # Check if peer is stale
            if [[ "$HANDSHAKE" == *"minute"* ]] || [[ "$HANDSHAKE" == *"hour"* ]] || [[ "$HANDSHAKE" == *"day"* ]]; then
                echo -e "  ${YELLOW}⚠ Peer might be inactive${NC}"
            else
                echo -e "  ${GREEN}✓ Active${NC}"
            fi
        elif [[ $line =~ transfer:\ (.+)\ received,\ (.+)\ sent ]]; then
            echo "  Traffic: ↓ ${BASH_REMATCH[1]} / ↑ ${BASH_REMATCH[2]}"
        elif [[ $line =~ endpoint:\ (.+) ]]; then
            echo "  Endpoint: ${BASH_REMATCH[1]}"
            echo ""
        fi
    done < <(sudo wg show $INTERFACE)
}

test_connectivity() {
    echo -e "${YELLOW}=== CONNECTIVITY TEST ===${NC}"
    echo ""
    
    # Ping VPN gateway
    VPN_GATEWAY=$(ip route | grep $INTERFACE | head -1 | awk '{print $1}' | cut -d'/' -f1)
    
    if [ -z "$VPN_GATEWAY" ]; then
        echo -e "${RED}✗ Can't determine VPN gateway${NC}"
    else
        echo "Testing VPN gateway: $VPN_GATEWAY"
        if ping -c 1 -W 2 $VPN_GATEWAY &>/dev/null; then
            echo -e "${GREEN}✓ VPN gateway reachable${NC}"
        else
            echo -e "${RED}✗ VPN gateway unreachable${NC}"
        fi
    fi
    echo ""
}

test_ip_leak() {
    echo -e "${YELLOW}=== IP LEAK TEST ===${NC}"
    echo ""
    
    echo "Your public IP:"
    PUBLIC_IP=$(curl -s --max-time 5 http://ifconfig.me)
    if [ -n "$PUBLIC_IP" ]; then
        echo "  $PUBLIC_IP"
        
        # Check if it's VPN server IP (would need to be configured)
        # For now, just show it
        echo ""
        echo "Expected: VPN server IP (Zürich)"
        echo "If different → ${RED}IP LEAK!${NC}"
    else
        echo -e "${RED}✗ Failed to get public IP${NC}"
    fi
    echo ""
}

test_dns_leak() {
    echo -e "${YELLOW}=== DNS LEAK TEST ===${NC}"
    echo ""
    
    echo "Current DNS servers:"
    if command -v resolvectl &>/dev/null; then
        resolvectl status | grep "DNS Servers" | head -3
    else
        cat /etc/resolv.conf | grep nameserver
    fi
    echo ""
    
    echo "Expected: VPN DNS (1.1.1.1 or VPN server)"
    echo "If showing ISP DNS → ${RED}DNS LEAK!${NC}"
    echo ""
    
    echo "Online test: https://dnsleaktest.com/"
}

show_bandwidth() {
    echo -e "${YELLOW}=== BANDWIDTH USAGE ===${NC}"
    echo ""
    
    sudo wg show $INTERFACE transfer | while read peer rx tx; do
        if [ "$peer" != "peer:" ]; then
            continue
        fi
        
        # Parse received/sent
        RX_BYTES=$(echo $rx | numfmt --from=iec)
        TX_BYTES=$(echo $tx | numfmt --from=iec)
        
        echo "Peer: ${peer:0:20}..."
        echo "  Downloaded: $(numfmt --to=iec-i --suffix=B $RX_BYTES)"
        echo "  Uploaded:   $(numfmt --to=iec-i --suffix=B $TX_BYTES)"
        echo ""
    done
}

generate_report() {
    REPORT_FILE="artifacts/vpn_status_report.txt"
    
    {
        echo "╔═══════════════════════════════════════════════════════════╗"
        echo "║         VPN STATUS REPORT                                ║"
        echo "╚═══════════════════════════════════════════════════════════╝"
        echo ""
        echo "Generated: $(date)"
        echo "Interface: $INTERFACE"
        echo ""
        
        echo "=== PEERS ==="
        sudo wg show $INTERFACE
        echo ""
        
        echo "=== ROUTING ==="
        ip route | grep $INTERFACE
        echo ""
        
        echo "=== FIREWALL ==="
        sudo iptables -t nat -L POSTROUTING | grep wg0
        echo ""
        
        echo "END OF REPORT"
    } > "$REPORT_FILE"
    
    echo -e "${GREEN}✓ Report saved: $REPORT_FILE${NC}"
}

# Main
case "${1:-status}" in
    status)
        check_vpn_status
        show_peers
        ;;
    test)
        check_vpn_status
        test_connectivity
        test_ip_leak
        test_dns_leak
        ;;
    bandwidth)
        check_vpn_status
        show_bandwidth
        ;;
    report)
        generate_report
        ;;
    monitor)
        # Continuous monitoring
        while true; do
            check_vpn_status
            show_peers
            show_bandwidth
            echo "Refreshing in 10s... (Ctrl+C to stop)"
            sleep 10
            clear
        done
        ;;
    *)
        echo "Usage: $0 {status|test|bandwidth|report|monitor}"
        exit 1
        ;;
esac
```

**Использование:**
```bash
chmod +x vpn_monitor.sh

# Status check
./vpn_monitor.sh status

# Security tests
./vpn_monitor.sh test

# Bandwidth stats
./vpn_monitor.sh bandwidth

# Generate report
./vpn_monitor.sh report

# Continuous monitoring
./vpn_monitor.sh monitor
```

</details>

**Проверка:**
```bash
# Если VPN запущен:
sudo wg show

# Проверить IP
curl http://ifconfig.me

# DNS check
cat /etc/resolv.conf
```

---

### Задание 7: Final Security Audit — Season 2 Complete ⭐⭐⭐⭐

**Контекст:**

**День 16, 22:00 — Финальная встреча команды**

**Офис Viktor. Вся команда собралась: Viktor, Alex, Anna, Dmitry, Max. На экранах — статистика VPN, графики мониторинга.**

Viktor (довольно):
> *"Два дня назад Krylov атаковал нас 50 тысячами пакетов в секунду. Сегодня — все коммуникации зашифрованы. Это победа."*

Anna (показывает анализ):
> *"За последние 24 часа — ни одной успешной прослушки. Krylov пытался DPI (Deep Packet Inspection), но видел только зашифрованный трафик. ChaCha20 работает."*

Dmitry:
> *"VPN стабилен. 5 членов команды, 100% uptime. Latency добавилась минимальная — 15ms через Цюрих. Приемлемо."*

Alex (смотрит на Max):
> *"Max, ты сделал это. За 16 дней ты прошёл путь от junior до... well, почти senior. Firewall, VPN, SSH tunneling — всё работает."*

**Max молчит. Смотрит на команду. Эти люди стали семьёй.**

**Задача:**
Создайте финальный security audit report — итог Season 2.

<details>
<summary>✅ Решение</summary>

**Final Security Audit Script:**
```bash
#!/bin/bash

# final_security_audit.sh - Season 2 Complete

REPORT_FILE="artifacts/season2_final_audit.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

generate_final_audit() {
    cat > "$REPORT_FILE" << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║         SEASON 2: NETWORKING — FINAL SECURITY AUDIT          ║
║         Episode 08: VPN & SSH Tunneling                      ║
╚═══════════════════════════════════════════════════════════════╝

Date:       $TIMESTAMP
Location:   Moscow, Russia 🇷🇺
Operator:   Max Sokolov
Duration:   16 days (Episode 05-08)
Status:     ✓ SEASON 2 COMPLETE

════════════════════════════════════════════════════════════════
[1] MISSION SUMMARY
════════════════════════════════════════════════════════════════

Objective: Build secure network infrastructure for KERNEL SHADOWS
          operation under threat from Polkovnik Krylov (FSB).

Challenges Faced:
  ✓ DDoS attack (50K pps, 847 botnet IPs) — MITIGATED
  ✓ DNS spoofing attempts — DETECTED & BLOCKED
  ✓ Deep Packet Inspection (DPI) — ENCRYPTED
  ✓ Traffic interception — PROTECTED (VPN)

Result: SUCCESSFUL
  - All communications encrypted (ChaCha20-Poly1305)
  - VPN operational (WireGuard, Zürich server)
  - SSH key-based authentication (ed25519)
  - Zero successful intrusions

════════════════════════════════════════════════════════════════
[2] INFRASTRUCTURE DEPLOYED
════════════════════════════════════════════════════════════════

Network Configuration:
  ✓ TCP/IP fundamentals implemented (Episode 05)
  ✓ DNS secured (DNSSEC, DoT) (Episode 06)
  ✓ Firewall deployed (UFW + iptables) (Episode 07)
  ✓ VPN established (WireGuard) (Episode 08)

Security Layers:
  1. Firewall (Layer 3-4)
     - Default deny policy
     - Rate limiting (20 conn/IP)
     - Botnet IP blocking (847 IPs)
     
  2. VPN (Layer 3)
     - WireGuard (Curve25519 + ChaCha20)
     - Server: Zürich, Switzerland (neutral)
     - Clients: 5 team members
     
  3. SSH (Layer 7)
     - Key-based authentication (ed25519)
     - Tunneling capabilities
     - SOCKS proxy ready

Servers Protected:
  - shadow-server-02 (10.50.1.2) — Main operational
  - viktor-server (10.50.1.10) — Coordination
  - alex-forensics (10.50.1.11) — Security analysis
  - anna-analysis (10.50.1.12) — Forensics
  - dmitry-devops (10.50.1.13) — DevOps

════════════════════════════════════════════════════════════════
[3] THREAT ACTOR: POLKOVNIK KRYLOV
════════════════════════════════════════════════════════════════

Profile:
  Name:        Polkovnik (Colonel) Krylov
  Organization: FSB, Управление "К" (Cybercrimes)
  Motivation:   Personal vendetta against Alex Sokolov
  Capabilities: DDoS, DPI, Botnet (847+ nodes), DNS spoofing

Attack Timeline:
  Day 2:  Initial reconnaissance
  Day 9:  TCP SYN flood attempts
  Day 10: DNS cache poisoning (detected)
  Day 13: Major DDoS attack (50K pps) — MITIGATED
  Day 14: Message in TCP payload: "Передай брату: я найду вас. Обоих."
  Day 15: DPI attempts (Deep Packet Inspection)
  Day 16: All attacks failed (encrypted traffic)

Current Status: ACTIVE THREAT
  - Krylov knows locations (Moscow, Stockholm, Zürich)
  - Personal threat to Alex and Max
  - Escalation expected

════════════════════════════════════════════════════════════════
[4] SECURITY METRICS
════════════════════════════════════════════════════════════════

Episode 05: TCP/IP Fundamentals
  - Network audit: 12 servers scanned
  - Ports analyzed: 65,535 range
  - Services identified: SSH, HTTP, HTTPS, PostgreSQL
  - Routing tables verified

Episode 06: DNS & Name Resolution
  - Internal domains: 15 (not in public DNS ✓)
  - DNS spoofing attempts: 0 successful
  - DNSSEC enabled: 100%
  - DoT (DNS over TLS): Recommended

Episode 07: Firewalls & iptables
  - DDoS attack mitigated: 20 minutes
  - Load Average: 47.82 → 1.92
  - IPs blocked: 847 (botnet)
  - SYN_RECV reduced: 847 → 12 (98.6%)
  - Rate limiting: 20 conn/IP, 4 SSH attempts/min
  - Attack logs: 500+ entries

Episode 08: VPN & SSH Tunneling
  - SSH keys generated: 5 (ed25519)
  - VPN clients: 5 (team members)
  - VPN uptime: 99.9%
  - Encryption: ChaCha20-Poly1305 (256-bit)
  - Latency overhead: 15ms (acceptable)
  - DNS leaks: 0

════════════════════════════════════════════════════════════════
[5] SKILLS ACQUIRED
════════════════════════════════════════════════════════════════

Technical Skills (Max Sokolov):
  ✓ TCP/IP model (7 layers)
  ✓ IP addressing & subnetting
  ✓ DNS (dig, DNSSEC, DoT)
  ✓ Network diagnostics (ping, traceroute, nmap, ss, netstat)
  ✓ Firewall (UFW, iptables)
  ✓ Rate limiting (connlimit, recent, hashlimit)
  ✓ VPN (WireGuard configuration)
  ✓ SSH (keys, config, tunneling, SOCKS proxy)
  ✓ Incident response (under pressure)
  ✓ Security audit & documentation

Soft Skills:
  ✓ Work under pressure (5-minute deadline, DDoS)
  ✓ Remote administration (SSH, high latency)
  ✓ Team collaboration (5 members)
  ✓ Decision making (OpenVPN vs WireGuard)
  ✓ Communication (technical reports)

Character Development:
  ✓ First international travel (Stockholm 🇸🇪)
  ✓ Trust building (Alex, Anna, Dmitry, Viktor)
  ✓ Responsibility (team safety depends on work)
  ✓ Confidence (junior → competent)

════════════════════════════════════════════════════════════════
[6] LESSONS LEARNED
════════════════════════════════════════════════════════════════

From Alex:
  "Security — это не продукт. Это процесс. Krylov не остановится.
   Мы должны быть всегда на шаг впереди."

From Katarina:
  "Encryption is mathematics. Mathematics doesn't lie.
   Trust the math, not the marketing."

From Episode 07 (DDoS):
  - Always allow SSH BEFORE enabling firewall
  - Rate limiting > IP blocking (IPs change)
  - Monitor logs (Krylov leaves messages)
  
From Episode 08 (VPN):
  - Simpler is better (WireGuard > OpenVPN for new setups)
  - Neutral location matters (Switzerland = privacy)
  - Test for leaks (DNS, IP)

════════════════════════════════════════════════════════════════
[7] SECURITY POSTURE
════════════════════════════════════════════════════════════════

Before Season 2:
  ⚠️ No firewall
  ⚠️ Unencrypted communications
  ⚠️ Password-based SSH
  ⚠️ No DNS security
  ⚠️ Vulnerable to DDoS
  Status: VULNERABLE

After Season 2:
  ✓ Multi-layer firewall
  ✓ End-to-end encryption (VPN)
  ✓ Key-based authentication
  ✓ DNS protection (DNSSEC)
  ✓ DDoS mitigation (rate limiting)
  ✓ Monitoring & logging
  Status: HARDENED

Risk Level:
  Before: CRITICAL
  After:  MEDIUM (Krylov still active, but defenses strong)

════════════════════════════════════════════════════════════════
[8] NEXT STEPS (Season 3 Preview)
════════════════════════════════════════════════════════════════

Location: Санкт-Петербург → Таллин 🇪🇪 (Days 17-24)
Theme:    System Administration

Upcoming Challenges:
  - User management (sudo, permissions, groups)
  - Process management (systemd, cron, monitoring)
  - Log analysis (rsyslog, journald, ELK stack)
  - Package management (apt, dpkg, repositories)
  - Backup & recovery
  - Performance tuning

New Threat:
  Krylov escalates. "Новая Эра" organization surfaces.
  Attacks become more sophisticated.

New Allies:
  - Andrei Volkov (Professor, St. Petersburg University)
  - Kristjan Tamm (e-Governance expert, Tallinn)
  - Liisa Kask (Backup specialist, Estonia)

════════════════════════════════════════════════════════════════
[9] TEAM STATUS
════════════════════════════════════════════════════════════════

Viktor Petrov:
  Role: Coordinator
  Status: Satisfied with progress
  Quote: "Max, ты оправдал доверие."

Alex Sokolov:
  Role: Security Lead, Max's cousin
  Status: Proud, but worried about Krylov
  Quote: "Спасибо, брат. Ты спас нас всех."

Anna Kovaleva:
  Role: Forensics Expert
  Status: Impressed with Max's growth
  Quote: "От junior до incident response за 16 дней. Impressive."

Dmitry Orlov:
  Role: DevOps Engineer
  Status: Happy with infrastructure
  Quote: "VPN работает как часы. Can't ask for more."

Max Sokolov:
  Role: System Administrator
  Status: Exhausted but accomplished
  Growth: Junior → Competent
  Quote: "Я не ожидал что будет настолько... intense."

════════════════════════════════════════════════════════════════
[10] FINAL ASSESSMENT
════════════════════════════════════════════════════════════════

Season 2 Objectives: ✓ ACHIEVED

Technical Implementation: 95/100
  - All systems deployed successfully
  - One minor DNS leak fixed
  - Firewall held under attack

Team Collaboration: 98/100
  - Excellent communication
  - Trust established
  - Roles clear

Crisis Management: 100/100
  - DDoS handled professionally
  - 5-minute deadline met
  - Zero downtime

Documentation: 90/100
  - All configs documented
  - Audit reports complete
  - Some automation scripts pending

Overall Season 2 Grade: A+ (96/100)

════════════════════════════════════════════════════════════════
SEASON 2: NETWORKING — COMPLETE ✓
════════════════════════════════════════════════════════════════

Episodes Completed: 4/4 (05, 06, 07, 08)
Duration: 16 days (Day 2-16 of 60)
Progress: 26.7% of operation

"In cryptography we trust. In firewall we verify."
  — Alex Sokolov

"The best security is the one you don't see, but always feel."
  — Katarina Lindström

"Krylov taught me one thing: never underestimate your enemy.
 But also never underestimate your team."
  — Max Sokolov

════════════════════════════════════════════════════════════════
END OF SEASON 2 AUDIT REPORT

Next: Season 3 — System Administration
Location: Санкт-Петербург → Таллин 🇪🇪
Start Date: Day 17
Theme: "Control the system, control the outcome."

Stay vigilant. Krylov is not defeated, only delayed.
════════════════════════════════════════════════════════════════
EOF

    # Replace $TIMESTAMP
    sed -i "s/\$TIMESTAMP/$TIMESTAMP/g" "$REPORT_FILE"
    
    echo "✓ Final audit report generated: $REPORT_FILE"
}

# Generate the report
generate_final_audit

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║         SEASON 2: NETWORKING — COMPLETE! ✓               ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Episodes completed: 4/4"
echo "  Episode 05: TCP/IP Fundamentals ✓"
echo "  Episode 06: DNS & Name Resolution ✓"
echo "  Episode 07: Firewalls & iptables ✓"
echo "  Episode 08: VPN & SSH Tunneling ✓"
echo ""
echo "Infrastructure status:"
echo "  ✓ Network configured"
echo "  ✓ Firewall deployed"
echo "  ✓ VPN operational"
echo "  ✓ SSH secured"
echo ""
echo "Threat status:"
echo "  ⚠️ Krylov active (but defenses holding)"
echo ""
echo "Next: Season 3 — System Administration"
echo "      Санкт-Петербург → Таллин 🇪🇪"
echo ""
```

</details>

---

## 🎬 Завершение эпизода — Season 2 Finale

### 23:00 — После meeting

**Max один в офисе. Смотрит на экраны. VPN работает. Firewall держит. SSH туннели активны.**

**LILITH (финальное сообщение):**
```
Episode 08 Complete.
Season 2: Networking — COMPLETE.

You've learned:
  ✓ TCP/IP model (7 layers)
  ✓ DNS security (DNSSEC, DoT)
  ✓ Firewall hardening (UFW, iptables)
  ✓ VPN encryption (WireGuard, ChaCha20)
  ✓ SSH tunneling (Local, Remote, Dynamic)
  ✓ Incident response (under pressure)

You've survived:
  ✓ DDoS attack (50K pps)
  ✓ DNS spoofing attempts
  ✓ Personal threat from Krylov

You've protected:
  ✓ 5 team members
  ✓ 5 servers
  ✓ Classified operation

Progress: 26.7% (16/60 days)
Status: Competent System Administrator

Next challenge: Season 3 — System Administration
Difficulty: ⭐⭐⭐⭐☆

Krylov is not defeated. Only delayed.
Stay sharp. Stay hidden. Stay alive.

— LILITH v2.0
```

**Max выключает свет. Идёт к выходу. Телефон вибрирует — SMS от Alex:**
```
Завтра выходной. Отдохни.
Через 2 дня — Санкт-Петербург.
Новая глава begins.

P.S. Спасибо за всё. Seriously.
— Alex
```

**Max улыбается. Первый раз за 16 дней.**

---

**ЭКРАН ЗАТЕМНЯЕТСЯ**

```
═══════════════════════════════════════════════════════════════

        SEASON 2: NETWORKING — COMPLETE ✓

          Episodes 05-08 (Days 2-16)

         "In cryptography we trust."

═══════════════════════════════════════════════════════════════

              SEASON 3: SYSTEM ADMINISTRATION
                   COMING SOON...

         Санкт-Петербург → Таллин 🇪🇪
                 Days 17-24

              "Control the system,
              control the outcome."

═══════════════════════════════════════════════════════════════
```

**TO BE CONTINUED...**

---

## ✅ Что вы изучили

### Season 2: Networking — Complete!

**Episode 05: TCP/IP Fundamentals**
- ✅ OSI и TCP/IP модели
- ✅ IP addressing (IPv4, IPv6, subnetting)
- ✅ Ports и services
- ✅ Network diagnostics (ping, traceroute, netstat, ss)
- ✅ MAC addresses & ARP

**Episode 06: DNS & Name Resolution**
- ✅ DNS hierarchy (Root → TLD → Authoritative)
- ✅ DNS record types (A, AAAA, CNAME, MX, TXT, NS, PTR)
- ✅ DNS lookup tools (dig, host, nslookup)
- ✅ DNS spoofing & cache poisoning
- ✅ DNSSEC (digital signatures)
- ✅ DNS over TLS/HTTPS (DoT/DoH)

**Episode 07: Firewalls & iptables**
- ✅ UFW (Uncomplicated Firewall)
- ✅ iptables (chains, targets, rules)
- ✅ Rate limiting (connlimit, recent, hashlimit)
- ✅ SYN flood protection
- ✅ Attack logging (rsyslog)
- ✅ DDoS mitigation (real-time incident response)
- ✅ fail2ban, nftables (advanced topics)

**Episode 08: VPN & SSH Tunneling** ⭐ CURRENT
- ✅ SSH keys (generation, ed25519, RSA)
- ✅ SSH config (~/.ssh/config, automation)
- ✅ SSH tunneling (Local, Remote, Dynamic forward)
- ✅ SOCKS proxy (browser через SSH)
- ✅ VPN concepts (OpenVPN vs WireGuard)
- ✅ WireGuard configuration (server/client)
- ✅ VPN monitoring & testing
- ✅ Security audit & documentation

---

### Технические навыки (Technical):
- ✅ **Network fundamentals** — TCP/IP, routing, subnetting
- ✅ **DNS** — resolution, security (DNSSEC), privacy (DoT/DoH)
- ✅ **Firewall** — UFW, iptables, rate limiting, DDoS protection
- ✅ **VPN** — WireGuard setup, encryption (ChaCha20), monitoring
- ✅ **SSH** — keys, config, tunneling (L/R/D forward), SOCKS proxy
- ✅ **Security** — authentication, encryption, incident response
- ✅ **Monitoring** — logs, metrics, real-time analysis
- ✅ **Documentation** — audit reports, configs, runbooks

### Soft Skills:
- ✅ **Crisis management** — DDoS response, 5-minute deadline
- ✅ **Remote work** — SSH через VPN, high latency
- ✅ **Team collaboration** — 5 members, distributed team
- ✅ **Decision making** — under pressure, incomplete information
- ✅ **Communication** — technical writing, clear explanations
- ✅ **Responsibility** — team safety depends on your work

### Character Development (Max Sokolov):
- ✅ **Confidence** — Junior → Competent in 16 days
- ✅ **Trust** — Built relationship with team (especially Alex)
- ✅ **International** — First trip abroad (Stockholm 🇸🇪)
- ✅ **Resilience** — Handled personal threat (Krylov's message)
- ✅ **Growth** — From scripts to incident response

---

## 🔍 Проверка понимания

Before moving to Season 3, ensure you understand:

### Networking Fundamentals:
1. ✅ Разница между TCP и UDP
2. ✅ Что такое subnetting и CIDR notation
3. ✅ Как работает DNS resolution (recursive query)
4. ✅ Что такое ARP и зачем он нужен

### Security:
1. ✅ Как работает symmetric vs asymmetric encryption
2. ✅ Что такое Perfect Forward Secrecy
3. ✅ Разница между DROP и REJECT в iptables
4. ✅ Как работает SYN flood атака

### SSH & VPN:
1. ✅ Разница между SSH Local и Remote forward
2. ✅ Что такое SOCKS proxy и как его использовать
3. ✅ Почему WireGuard быстрее OpenVPN
4. ✅ Что такое DNS leak и как его избежать

### Tools:
1. ✅ Команда для проверки открытых портов: `ss -tulpn`
2. ✅ Команда для DNS lookup: `dig domain.com`
3. ✅ Команда для просмотра iptables rules: `sudo iptables -L -n -v`
4. ✅ Команда для генерации SSH ключа: `ssh-keygen -t ed25519`

---

## 📖 Дополнительные материалы

<details>
<summary>📚 Recommended Reading</summary>

### Books:
- **"TCP/IP Illustrated"** by W. Richard Stevens (Volume 1-3)
- **"SSH, The Secure Shell"** by Daniel J. Barrett
- **"WireGuard: Fast, Modern, Secure VPN Tunnel"** (official docs)
- **"Linux Firewalls"** by Steve Suehring

### Online:
- [WireGuard Official Site](https://www.wireguard.com/)
- [iptables Tutorial](https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html)
- [SSH Academy](https://www.ssh.com/academy/ssh)
- [DNSSEC Guide](https://www.dnssec-tools.org/)

### Practice:
- [HackTheBox](https://www.hackthebox.eu/) — Networking challenges
- [TryHackMe](https://tryhackme.com/) — SSH/VPN rooms
- [OverTheWire: Bandit](https://overthewire.org/wargames/bandit/) — SSH practice

</details>

---

*"The best firewall is useless if the VPN leaks your IP.  
The best VPN is useless if your SSH key is compromised.  
Security is a chain. Every link must be strong."*  
— Alex Sokolov

**Season 2: Networking — COMPLETE!** ✓

**Next:** Season 3 — System Administration (Санкт-Петербург → Таллин 🇪🇪)

---

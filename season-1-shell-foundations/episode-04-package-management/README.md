# Episode 04: Package Management

```
ОПЕРАЦИЯ: KERNEL SHADOWS
СЕЗОН: 1 — Shell & Foundations
ЭПИЗОД: 04 — Package Management
ЛОКАЦИЯ: 🇷🇺 Новосибирск, Россия (Академгородок)
ДНИ ОПЕРАЦИИ: 7-8 (из 60)
СЛОЖНОСТЬ: ⭐⭐☆☆☆
ВРЕМЯ: 2-2.5 часа
```

---

## 🎬 Пролог: Инструменты войны

### 📅 День 7 (07 октября 2025) — 10:00

**Локация:** Квартира Макса, Академгородок
**Участники:** Макс Соколов, Виктор Петров (видеозвонок), LILITH

Утро. Кофе. Снег за окном. Домашний сервер гудит в углу.

Видеозвонок от Виктора:

> **Виктор:**
> *"Макс, хорошая работа с логами. Ты нашёл Tor exit node за 4 часа. Анна впечатлена."*

На экране появляется документ.

> **Виктор:**
> *"Теперь настоящая работа. Вот список инструментов для операции: nmap, tcpdump, fail2ban, Docker... 15+ пакетов. Нужно всё это установить на твою workstation. Завтра начинаем работать с серверами."*

**Макс:**
> *"Вручную устанавливать? Это долго..."*

**Виктор:**
> *"Вручную, но правильно. Понимать что делаешь. Для 50 серверов потом используем Ansible. Но сначала научись устанавливать пакеты правильно. Отправлю список на email."*

> **LILITH (терминал мигает):**
> *"Package management. Где 'dependency hell' встречается с 'it worked on my machine'. Добро пожаловать в реальность Linux администрирования."*

**Виктор:**
> *"У тебя до конца дня. Начни с workstation. Когда разберёшься — покажу Ansible для автоматизации на 50 серверов."*

Звонок обрывается.

---

## 10:30 — Email от Виктора

Макс открывает почту. Вложение: `required_tools.txt`

```
# OPERATION KERNEL SHADOWS
# Required Tools for Infrastructure
# Viktor Petrov, 07 Oct 2025

# Security & Networking
nmap           # Network scanner
tcpdump        # Packet capture
wireshark      # Network analyzer
fail2ban       # Intrusion prevention
ufw            # Firewall

# Monitoring
htop           # Process viewer
iotop          # Disk I/O monitor
nethogs        # Network bandwidth monitor

# Development
git            # Version control
curl           # HTTP client
jq             # JSON processor

# Docker (manual installation from official repo)
docker-ce      # Docker Engine
docker-compose # Multi-container orchestration
```

> **LILITH:**
> *"APT — Advanced Package Tool. Существует с 1998 года. Установил миллиарды пакетов.*
>
> *Ты будешь использовать apt. Не переписывать apt в bash. Использовать.*
>
> *Episode 04 = Type B. Учись администрировать систему, не программировать обёртки."*

---

## 🎯 Миссия Episode 04

### Задача:

Научиться **использовать apt/dpkg** для установки и управления пакетами на Ubuntu.

**НЕ создавать bash скрипт!** Это Type B episode.

### Что изучишь:

1. ✅ apt basics (update, search, install, remove)
2. ✅ dpkg низкоуровневый контроль (inspection, verification)
3. ✅ Repositories (sources.list, PPA, GPG keys)
4. ✅ Docker manual installation (custom repository)
5. ✅ Batch operations (xargs ONE-LINER)
6. ✅ Verification & cleanup
7. ✅ Generate report (minimal ONE-LINER)

**Финал:** ONE-LINER для генерации отчёта (15-20 строк максимум)

---

## Цикл 1: Зачем package manager? (10-12 минут)

### 🎬 Сюжет: До APT

**11:00 — Квартира Макса**

Макс смотрит на список. 15 пакетов.

**Макс (думает):**
> *"Можно скачать каждый вручную... Найти .tar.gz, распаковать, ./configure, make, make install..."*

Открывает браузер. Ищет "nmap download".

5 минут спустя:

- 10 сайтов с разными версиями
- Какая версия? 7.93? 7.94? Latest?
- Зависимости: libssl, libpcap, lua...
- Где их брать?

**LILITH:**
> *"Представь: ты вручную устанавливаешь 15 пакетов. Каждый со своими зависимостями. Nmap нужен libssl. libssl нужен zlib. zlib нужен... 50+ пакетов в итоге. 8 часов работы."*

> *"Или: `sudo apt install nmap`. 3 секунды."*

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│                                                               │
│ "Package manager = магазин приложений для серверов.          │
│                                                               │
│  Представь App Store на iPhone:                              │
│  1. Ищешь приложение → apt search                            │
│  2. Нажимаешь 'Установить' → apt install                     │
│  3. Получаешь обновления → apt upgrade                       │
│  4. Удаляешь → apt remove                                    │
│                                                               │
│  Но серьёзнее. С зависимостями. С проверкой безопасности.    │
│  С rollback. С контролем версий.                             │
│                                                               │
│  APT = App Store + DevOps + Security.                        │
│  Это не просто удобство. Это необходимость."                 │
└─────────────────────────────────────────────────────────────┘
```

---

### 📚 Теория: Package Managers в Linux

#### Зачем нужны?

**Без package manager (1990-е):**

```
1. Найти .tar.gz в интернете (какой сайт доверять?)
2. Скачать (какая версия?)
3. Распаковать tar -xzf package.tar.gz
4. Прочитать README (инструкции разные у всех)
5. Установить зависимости (вручную, recursively!)
6. ./configure (может не найти библиотеки)
7. make (может упасть с ошибкой)
8. make install (куда установилось? /usr/local? /opt?)
9. Настроить PATH
10. Обновить? Начни сначала.
11. Удалить? Удачи найти все файлы.

Время: 1-8 часов на пакет
Риск: вирусы, конфликты версий, "dependency hell"
```

**С package manager (APT):**

```
1. sudo apt install nmap

Время: 3-30 секунд
Риск: минимальный (официальные репозитории, GPG подписи)
```

**Разница:** 8 часов vs 30 секунд = **960x быстрее!**

#### Ubuntu Package Management Stack

```
┌─────────────────────────────────────────────────────────────┐
│              UBUNTU PACKAGE MANAGEMENT LAYERS                 │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  👤 User Commands (что ты используешь):                      │
│      ┌──────────────────────────────────────┐                │
│      │  apt install nmap                    │ ← HIGH LEVEL  │
│      │  apt search tcpdump                  │               │
│      │  apt update                          │               │
│      └──────────────────────────────────────┘                │
│                      ▼                                        │
│  🔧 APT (Advanced Package Tool):                             │
│      ┌──────────────────────────────────────┐                │
│      │  • Dependency resolution             │               │
│      │  • Repository management             │               │
│      │  • Caching, downloads                │               │
│      │  • Upgrade strategies                │               │
│      └──────────────────────────────────────┘                │
│                      ▼                                        │
│  ⚙️  DPKG (Debian Package):                                  │
│      ┌──────────────────────────────────────┐                │
│      │  • Install .deb files                │ ← LOW LEVEL   │
│      │  • Database (/var/lib/dpkg)          │               │
│      │  • File extraction                   │               │
│      │  • Scripts (preinst, postinst)       │               │
│      └──────────────────────────────────────┘                │
│                      ▼                                        │
│  💾 File System:                                              │
│      ┌──────────────────────────────────────┐                │
│      │  /usr/bin/nmap      ← binaries       │               │
│      │  /etc/nmap/         ← configs        │               │
│      │  /usr/share/nmap/   ← data           │               │
│      └──────────────────────────────────────┘                │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

**Аналогия:**
- **apt** = магазин (UI, каталог, корзина, оплата)
- **dpkg** = склад (инвентарь, упаковка, доставка)
- **Файловая система** = ваш дом (где всё хранится)

#### APT vs DPKG

| Команда | Уровень | Использование | Зависимости |
|---------|---------|---------------|-------------|
| **apt** | HIGH | Ежедневно | ✅ Автоматически |
| **dpkg** | LOW | Редко (inspection) | ❌ Вручную |

**Правило:** Используй **apt** для установки. Используй **dpkg** для inspection.

> **LILITH:** *"apt = водить машину. dpkg = чинить двигатель. Для 95% задач нужен apt. dpkg — когда что-то сломалось и нужно разобраться."*

---

### 💻 Практика: Первое знакомство с apt (5 минут)

**Задание 1:** Проверь версию apt

```bash
apt --version
# Вывод: apt 2.4.11 (amd64)
```

**Задание 2:** Обнови индекс пакетов

```bash
sudo apt update

# Вывод:
# Hit:1 http://archive.ubuntu.com/ubuntu jammy InRelease
# Get:2 http://security.ubuntu.com/ubuntu jammy-security InRelease [110 kB]
# Fetched 450 kB in 2s
# Reading package lists... Done
# Building dependency tree... Done
# 15 packages can be upgraded. Run 'apt list --upgradable'
```

**Что произошло:**
- apt подключился к репозиториям (servers с пакетами)
- Скачал списки доступных пакетов (metadata)
- Проверил что можно обновить

**Задание 3:** Посчитай сколько пакетов доступно

```bash
apt list | wc -l
# Вывод: ~73,000 пакетов!
```

**73,000 пакетов!** Вручную управлять этим невозможно.

---

### 🤔 Проверка понимания

**LILITH:** *"Математика эффективности. Проверка."*

**Вопрос:** У тебя список из 15 пакетов. Каждый имеет в среднем 5 зависимостей. Сколько всего пакетов нужно установить?

a) 15
b) 75 (15 × 5)
c) ~100+ (зависимости имеют свои зависимости)
d) Невозможно посчитать вручную

<details>
<summary>🤔 Думай 30 секунд</summary>

**Ответ: c) ~100+ пакетов (и d) тоже верно)**

**Реальный пример:**

```bash
# Попробуй (не устанавливая):
apt-cache depends nmap | grep "Depends:"
# Зависимости nmap:
#   Depends: libc6
#   Depends: libgcc-s1
#   Depends: liblinear4
#   Depends: liblua5.3-0
#   Depends: libpcap0.8
#   Depends: libpcre3
#   Depends: libssl3
#   Depends: libstdc++6
#   Depends: zlib1g

# 9 прямых зависимостей!
# Каждая из них имеет свои зависимости...

# Посчитать ВСЕ (рекурсивно):
apt-cache depends nmap --recurse --no-recommends | wc -l
# Вывод: ~200+ строк!
```

**15 пакетов × ~200 зависимостей каждый = 3,000+ пакетов!**

Но apt умный: многие зависимости общие (libc6, libssl3).
Итого: **~100-150 уникальных пакетов**.

**Вручную установить 150 пакетов в правильном порядке? Невозможно.**

**APT делает это за 30 секунд.**

**LILITH:** *"Вот почему apt существует. Вот почему ты НЕ пишешь bash скрипт на 355 строк чтобы его заменить. Ты используешь apt."*

</details>

---

## Цикл 2: apt basics — установка и поиск (12-15 минут)

### 🎬 Сюжет: Первая установка

**11:30 — Квартира Макса**

Макс смотрит на список. Первый пакет: `nmap`.

> **Макс:**
> *"Хорошо. Начнём с nmap. Сканер сети. Нужен для разведки."*

```bash
sudo apt install nmap
```

Терминал оживает:

```
Reading package lists... Done
Building dependency tree... Done
The following additional packages will be installed:
  liblua5.3-0 libpcap0.8 liblinear4 lua-lpeg nmap-common
Suggested packages:
  ncat ndiff zenmap
The following NEW packages will be installed:
  liblua5.3-0 liblinear4 libpcap0.8 lua-lpeg nmap nmap-common
0 upgraded, 6 newly installed, 0 to remove
Need to get 6,048 kB of archives.
After this operation, 26.7 MB of additional disk space will be used.
Do you want to continue? [Y/n]
```

**Макс видит:**
- 6 пакетов (nmap + 5 зависимостей)
- 6 MB download
- 26 MB на диске

**LILITH:**
> *"Видишь? apt автоматически нашёл 5 зависимостей. Посчитал размер. Спросил подтверждение. Сам скачает. Сам установит в правильном порядке."*

> *"Вручную это заняло бы 2 часа. apt — 30 секунд."*

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│                                                               │
│ "apt install = магия? Нет. Алгоритм.                         │
│                                                               │
│  Шаги apt install nmap:                                      │
│  1. Читает /var/lib/apt/lists (индекс пакетов)              │
│  2. Находит nmap в репозитории                               │
│  3. Парсит зависимости (Depends: liblua5.3, libpcap...)     │
│  4. Рекурсивно находит зависимости зависимостей              │
│  5. Строит dependency graph (DAG)                            │
│  6. Топологическая сортировка (порядок установки)            │
│  7. Скачивает .deb файлы с mirrors                           │
│  8. Проверяет GPG signatures (безопасность)                  │
│  9. Распаковывает через dpkg (в правильном порядке!)         │
│  10. Запускает post-install scripts                          │
│                                                               │
│  30 секунд. 200+ строк кода внутри apt. Ты просто пишешь:   │
│  sudo apt install nmap                                       │
│                                                               │
│  Это не лень. Это делегирование проверенному инструменту."  │
└─────────────────────────────────────────────────────────────┘
```

---

### 📚 Теория: apt — основные команды

#### Базовый workflow

```bash
# 1. Обновить индекс пакетов (делать регулярно!)
sudo apt update

# 2. Найти пакет
apt search nmap
apt-cache search nmap  # альтернатива

# 3. Посмотреть информацию
apt show nmap
apt-cache show nmap  # больше деталей

# 4. Установить
sudo apt install nmap

# 5. Проверить установлен ли
apt list --installed | grep nmap
dpkg -l | grep nmap

# 6. Обновить все пакеты
sudo apt upgrade

# 7. Удалить
sudo apt remove nmap         # удалить пакет, оставить конфиги
sudo apt purge nmap          # удалить всё
sudo apt autoremove          # удалить неиспользуемые зависимости
```

#### Ключевые команды

| Команда | Sudo? | Что делает | Частота |
|---------|-------|------------|---------|
| `apt update` | ✅ | Обновить индекс пакетов | Ежедневно |
| `apt upgrade` | ✅ | Обновить установленные пакеты | Еженедельно |
| `apt search <name>` | ❌ | Найти пакет | Часто |
| `apt show <name>` | ❌ | Информация о пакете | Часто |
| `apt install <name>` | ✅ | Установить | Часто |
| `apt remove <name>` | ✅ | Удалить (оставить configs) | Редко |
| `apt purge <name>` | ✅ | Удалить полностью | Редко |
| `apt autoremove` | ✅ | Очистить неиспользуемые | После remove |
| `apt list --installed` | ❌ | Список установленного | Редко |
| `apt list --upgradable` | ❌ | Что можно обновить | Перед upgrade |

#### apt vs apt-get/apt-cache

**Есть старые команды:**
- `apt-get install` = `apt install`
- `apt-cache search` = `apt search`
- `apt-get update` = `apt update`

**Разница:**
- **apt** — современный, user-friendly (progress bar, colors)
- **apt-get/apt-cache** — старый, для скриптов (stable output)

**Используй:**
- **Интерактивно (терминал):** `apt` ✅
- **В скриптах:** `apt-get` (но мы не пишем скрипты! Type B!) ✅

> **LILITH:** *"`apt` появился в 2014. Объединил `apt-get` и `apt-cache`. Удобнее для людей. В скриптах используй `apt-get` (stable interface). Но помни: Type B = используй apt напрямую, не пиши обёртки."*

---

### 💻 Практика: Установка пакетов (7 минут)

**Задание 1:** Найди пакет tcpdump

```bash
apt search tcpdump

# Вывод:
# tcpdump/jammy 4.99.1-3build2 amd64
#   command-line network traffic analyzer
```

**Задание 2:** Посмотри информацию о tcpdump

```bash
apt show tcpdump

# Вывод:
# Package: tcpdump
# Version: 4.99.1-3build2
# Priority: optional
# Section: net
# Origin: Ubuntu
# Maintainer: Ubuntu Developers
# Installed-Size: 1,519 kB
# Depends: libc6, libpcap0.8, libssl3
# Homepage: https://www.tcpdump.org/
# Description: command-line network traffic analyzer
#  This program allows you to dump the traffic on a network...
```

**Обрати внимание:**
- **Depends:** libc6, libpcap0.8, libssl3 — зависимости
- **Installed-Size:** 1.5 MB — сколько займёт
- **Homepage:** официальный сайт

**Задание 3:** Установи tcpdump

```bash
sudo apt install -y tcpdump
# -y = автоматически отвечать Yes (для автоматизации)
```

**Задание 4:** Проверь что установлено

```bash
# Вариант 1: через apt
apt list --installed | grep tcpdump

# Вариант 2: через dpkg
dpkg -l | grep tcpdump

# Вариант 3: проверь команду
which tcpdump
# Вывод: /usr/bin/tcpdump

tcpdump --version
# Вывод: tcpdump version 4.99.1
```

**Задание 5:** Установи несколько пакетов одной командой

```bash
sudo apt install -y htop iotop nethogs
```

**Задание 6:** Посмотри что можно обновить

```bash
apt list --upgradable

# Если есть обновления:
sudo apt upgrade -y
```

---

### 🤔 Проверка понимания

**LILITH:** *"apt basics. Проверка."*

**Вопрос 1:** В чём разница между `apt update` и `apt upgrade`?

<details>
<summary>Ответ</summary>

**Разные действия:**

**`apt update`:**
- Обновляет **списки пакетов** (metadata)
- Подключается к репозиториям
- Скачивает индексы (что доступно, какие версии)
- НЕ устанавливает и не обновляет пакеты
- Быстро (несколько секунд)
- **Делать часто** (каждый день)

**`apt upgrade`:**
- Обновляет **установленные пакеты** до новых версий
- Использует списки из `apt update`
- Скачивает и устанавливает обновления
- Может занять время (минуты)
- **Делать реже** (раз в неделю, после `apt update`)

**Правильный порядок:**
```bash
sudo apt update    # Сначала обновить списки
apt list --upgradable  # Посмотреть что обновится
sudo apt upgrade -y    # Потом обновить пакеты
```

**Аналогия:**
- `apt update` = открыть каталог магазина (что есть в продаже?)
- `apt upgrade` = купить новые версии того что у тебя уже есть

**LILITH:** *"`update` = узнать что нового. `upgrade` = установить новое. Всегда `update` перед `upgrade`."*

</details>

**Вопрос 2:** Что делает флаг `-y` в `apt install -y nmap`?

<details>
<summary>Ответ</summary>

**`-y` = assume yes** (автоматически отвечать Yes на все вопросы)

**Без `-y`:**
```bash
sudo apt install nmap
# apt спросит:
# Do you want to continue? [Y/n]
# Нужно ввести Y вручную
```

**С `-y`:**
```bash
sudo apt install -y nmap
# apt автоматически продолжит, не спрашивая
```

**Когда использовать:**
- ✅ **В скриптах** (automation, CI/CD)
- ✅ **Когда уверен** (повторная установка)
- ⚠️ **Осторожно на production** (можешь установить что-то неожиданное)

**Альтернативы:**
```bash
# Вариант 1: -y флаг
sudo apt install -y nmap

# Вариант 2: yes команда
yes | sudo apt install nmap

# Вариант 3: DEBIAN_FRONTEND (для скриптов)
sudo DEBIAN_FRONTEND=noninteractive apt install -y nmap
```

**LILITH:** *"`-y` = автоматизация. Но помни: автоматизация без понимания = опасно. Type B = сначала понять команду, потом автоматизировать."*

</details>

---

## Цикл 3: dpkg — низкий уровень (10-12 минут)

### 🎬 Сюжет: Под капотом

**12:30 — Квартира Макса**

Макс установил несколько пакетов через apt. Работает.

**LILITH:**
> *"apt — магазин. Красиво, удобно. Но под капотом — dpkg. Давай посмотрим что внутри."*

> *"dpkg = Debian Package. Существует с 1993. apt построен поверх dpkg. Как UI поверх базы данных."*

```bash
dpkg -l | head -20
```

Экран заполняется таблицей:

```
ii  adduser         3.118    all    add and remove users
ii  apt             2.4.11   amd64  commandline package manager
ii  base-files      12.2     amd64  Debian base system files
ii  bash            5.1-6    amd64  GNU Bourne Again SHell
ii  nmap            7.93     amd64  The Network Mapper
...
```

**LILITH:**
> *"Это база данных всех установленных пакетов. /var/lib/dpkg/status — 10,000+ строк. Каждый пакет записан. Каждый файл отслеживается."*

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│                                                               │
│ "dpkg = инвентарь склада. Учёт всего.                        │
│                                                               │
│  Представь склад Amazon:                                     │
│  • Каждая коробка = пакет (.deb file)                        │
│  • Штрих-код = package name + version                        │
│  • База данных = /var/lib/dpkg/status                        │
│  • Каждый товар внутри коробки = файл пакета                │
│                                                               │
│  dpkg знает:                                                 │
│  1. Что установлено (dpkg -l)                                │
│  2. Какие файлы принадлежат пакету (dpkg -L nmap)           │
│  3. Какой пакет установил файл (dpkg -S /usr/bin/nmap)      │
│  4. Статус пакета (installed, removed, purged)               │
│                                                               │
│  apt использует dpkg. Ты используешь apt. Но знать dpkg     │
│  полезно для troubleshooting."                               │
└─────────────────────────────────────────────────────────────┘
```

---

### 📚 Теория: dpkg — Debian Package Manager

#### Что такое .deb файл?

**.deb** = архив (как .zip) с метаданными + файлами пакета

**Структура:**

```
nmap_7.93-1_amd64.deb
│
├── control.tar.gz (metadata)
│   ├── control          # Имя, версия, зависимости
│   ├── preinst          # Script ДО установки
│   ├── postinst         # Script ПОСЛЕ установки
│   ├── prerm            # Script ДО удаления
│   └── postrm           # Script ПОСЛЕ удаления
│
└── data.tar.xz (actual files)
    ├── usr/bin/nmap           # Binary
    ├── usr/share/man/man1/nmap.1.gz  # Man page
    └── etc/nmap/nmap-services # Config
```

**dpkg распаковывает .deb и копирует файлы в систему.**

#### Основные команды dpkg

| Команда | Что делает | Частота |
|---------|------------|---------|
| `dpkg -l` | Список установленных пакетов | Часто |
| `dpkg -l <pattern>` | Список с фильтром | Часто |
| `dpkg -s <package>` | Статус и info конкретного пакета | Часто |
| `dpkg -L <package>` | Список файлов в пакете | Troubleshooting |
| `dpkg -S <file>` | Какой пакет установил файл | Troubleshooting |
| `dpkg -i <file.deb>` | Установить .deb файл | Редко |
| `dpkg -r <package>` | Удалить (оставить configs) | Редко (используй apt!) |
| `dpkg -P <package>` | Purge (удалить всё) | Редко (используй apt!) |

**Правило:** Используй **apt** для install/remove. Используй **dpkg** для **inspection**.

#### dpkg -l output format

```bash
dpkg -l | grep nmap
# Вывод:
# ii  nmap  7.93-1  amd64  The Network Mapper
# │   │     │       │      │
# │   │     │       │      └─ Description
# │   │     │       └─ Architecture (amd64, i386, all)
# │   │     └─ Version
# │   └─ Package name
# └─ Status
```

**Status codes:**
- **ii** = installed (правильно установлен)
- **rc** = removed, config files remain
- **un** = unknown (не установлен)
- **iU** = installed, but not configured

> **LILITH:** *"`ii` = good. `rc` = был установлен, удалён, configs остались. `un` = не установлен. Ищи `ii` в production."*

---

### 💻 Практика: Inspection с dpkg (7 минут)

**Задание 1:** Список всех установленных пакетов

```bash
dpkg -l | wc -l
# Вывод: ~800 пакетов на типичной Ubuntu
```

**Задание 2:** Информация о конкретном пакете

```bash
dpkg -s nmap

# Вывод:
# Package: nmap
# Status: install ok installed
# Priority: optional
# Section: net
# Installed-Size: 7024
# Version: 7.93-1
# Depends: libc6, libgcc-s1, liblinear4, liblua5.3-0, libpcap0.8, ...
# Description: The Network Mapper
#  Nmap is a utility for network exploration or security auditing...
```

**Задание 3:** Какие файлы установил nmap?

```bash
dpkg -L nmap

# Вывод (частично):
# /usr/bin/nmap
# /usr/bin/nping
# /usr/share/nmap/nmap-services
# /usr/share/nmap/nmap-os-db
# /usr/share/man/man1/nmap.1.gz
# ... ~200 файлов
```

**Задание 4:** Какой пакет установил команду `tcpdump`?

```bash
which tcpdump
# /usr/bin/tcpdump

dpkg -S /usr/bin/tcpdump
# Вывод: tcpdump: /usr/bin/tcpdump
```

**Задание 5:** Проверь что пакет правильно установлен

```bash
dpkg -l | grep "^ii" | grep nmap
# ii  nmap  7.93-1  amd64  The Network Mapper

# Статус "ii" = installed, всё ок
```

**Задание 6:** Найди все пакеты связанные с сетью

```bash
dpkg -l | grep "^ii" | grep -E "net-tools|iproute2|tcpdump|nmap"
```

---

### 🤔 Проверка понимания

**LILITH:** *"dpkg inspection. Проверка."*

**Вопрос:** Команда `dpkg -L nmap` показала 200 файлов. Где они физически находятся?

<details>
<summary>Ответ</summary>

**В разных директориях файловой системы:**

```bash
dpkg -L nmap | head -20
# /usr/bin/nmap               ← Binary (executable)
# /usr/bin/nping              ← Еще один binary
# /usr/share/nmap/            ← Data files
# /usr/share/man/man1/        ← Man pages
# /etc/nmap/                  ← Configs (если есть)
```

**Linux Filesystem Hierarchy Standard (FHS):**

| Директория | Содержит | Пример |
|------------|----------|--------|
| `/usr/bin/` | Executables | `/usr/bin/nmap` |
| `/usr/sbin/` | System executables (admin) | `/usr/sbin/sshd` |
| `/etc/` | Configs | `/etc/nmap/nmap-services` |
| `/usr/share/` | Shared data (docs, examples) | `/usr/share/nmap/scripts/` |
| `/usr/lib/` | Libraries | `/usr/lib/x86_64-linux-gnu/libpcap.so` |
| `/var/lib/` | Variable data | `/var/lib/dpkg/status` |

**dpkg отслеживает каждый файл:**

```bash
# Полный список:
dpkg -L nmap > nmap_files.txt

# Где configs:
dpkg -L nmap | grep "^/etc"

# Где binaries:
dpkg -L nmap | grep "^/usr/bin"

# Где man pages:
dpkg -L nmap | grep "/man/"
```

**Удаление:**

```bash
# Когда ты делаешь:
sudo apt remove nmap

# dpkg знает какие файлы удалить (все из списка dpkg -L)
# Configs в /etc/ остаются (если не используешь purge)
```

**LILITH:** *"dpkg = database всех файлов. Знает где каждый байт. Удаление пакета = удаление всех файлов из списка. Чисто. Без мусора."*

</details>

---

## Цикл 4: Repositories — откуда берутся пакеты (12-15 минут)

### 🎬 Сюжет: Официальные источники

**13:00 — Квартира Макса**

Макс смотрит на список Виктора. Следующий: Docker.

```bash
apt search docker
```

Находит `docker.io`.

```bash
sudo apt install docker.io
```

**LILITH:**
> *"Стоп. docker.io — это Ubuntu package. Старая версия. Docker официальный сайт рекомендует устанавливать из их репозитория. Новее, стабильнее."*

**Макс:**
> *"Репозиторий? Что это?"*

**LILITH:**
> *"Repository = сервер с пакетами. Ubuntu использует несколько mirrors. archive.ubuntu.com, security.ubuntu.com..."*

> *"Но Docker — компания. У них свой репозиторий: download.docker.com. Более свежие версии."*

> *"Сейчас покажу как добавить сторонний репозиторий. Правильно. С проверкой GPG."*

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│                                                               │
│ "Repositories = магазины пакетов.                            │
│                                                               │
│  По умолчанию Ubuntu подключен к:                            │
│  • archive.ubuntu.com (main, universe, multiverse)           │
│  • security.ubuntu.com (security updates)                    │
│                                                               │
│  Это как App Store от Apple. Официальный, проверенный.       │
│                                                               │
│  Но можешь добавить сторонние:                               │
│  • Docker: download.docker.com                               │
│  • Google Chrome: dl.google.com                              │
│  • PostgreSQL: apt.postgresql.org                            │
│                                                               │
│  Зачем?                                                      │
│  • Новее версии (Docker в Ubuntu repo = старый)             │
│  • Специализированные пакеты                                 │
│  • Прямо от разработчиков                                    │
│                                                               │
│  Безопасность: GPG keys проверяют подлинность. Без GPG =     │
│  можешь установить backdoor."                                │
└─────────────────────────────────────────────────────────────┘
```

---

### 📚 Теория: Repositories и /etc/apt/sources.list

#### Что такое repository?

**Repository** = HTTP(S) сервер с пакетами (.deb files) + metadata.

**Примеры:**
- `http://archive.ubuntu.com/ubuntu/` — официальный Ubuntu
- `http://security.ubuntu.com/ubuntu/` — security updates
- `https://download.docker.com/linux/ubuntu` — Docker official
- `http://ppa.launchpad.net/` — Personal Package Archives (PPA)

#### Конфигурация: /etc/apt/sources.list

```bash
cat /etc/apt/sources.list
```

**Формат:**

```
deb http://archive.ubuntu.com/ubuntu/ jammy main restricted
│   │                                  │      │
│   │                                  │      └─ Components (main, universe, multiverse, restricted)
│   │                                  └─ Release (jammy = Ubuntu 22.04)
│   └─ Repository URL
└─ Type (deb = binary packages, deb-src = source code)
```

**Основные компоненты Ubuntu:**

| Component | Лицензия | Поддержка | Содержит |
|-----------|----------|-----------|----------|
| **main** | Free, Open Source | ✅ Official | Core packages |
| **universe** | Free, Open Source | ❌ Community | Community-maintained |
| **multiverse** | Restricted licenses | ❌ No support | Non-free software |
| **restricted** | Proprietary drivers | ✅ Limited | Nvidia, etc. |

**Пример полного sources.list:**

```
# Main repositories
deb http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse

# Security updates
deb http://security.ubuntu.com/ubuntu jammy-security main restricted universe multiverse
```

#### Добавление стороннего репозитория (Docker example)

**Шаги:**

```bash
# 1. Install prerequisites
sudo apt install -y ca-certificates curl gnupg lsb-release

# 2. Add Docker GPG key (для проверки подписей)
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 3. Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 4. Update package index
sudo apt update

# 5. Install Docker from official repo
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

**Важно:**
- **GPG key** — цифровая подпись для проверки что пакеты от Docker, не от хакеров
- **/etc/apt/sources.list.d/** — директория для дополнительных репозиториев
- **Без GPG key** — apt откажется устанавливать (unsafe!)

> **LILITH:** *"GPG keys = цифровые подписи. Как подпись на чеке. Без неё — можешь купить подделку. В Linux — можешь установить backdoor. ВСЕГДА проверяй GPG при добавлении репозитория."*

---

### 💻 Практика: Repositories (10 минут)

**Задание 1:** Посмотри текущие репозитории

```bash
cat /etc/apt/sources.list | grep -v "^#" | grep -v "^$"

# Вывод:
# deb http://archive.ubuntu.com/ubuntu/ jammy main restricted
# deb http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted
# deb http://security.ubuntu.com/ubuntu jammy-security main restricted
```

**Задание 2:** Посмотри дополнительные репозитории

```bash
ls /etc/apt/sources.list.d/
# Здесь файлы сторонних репозиториев (Docker, Chrome, PostgreSQL...)
```

**Задание 3:** Проверь GPG keys

```bash
sudo apt-key list
# Список GPG ключей для проверки пакетов

# Или (новый способ):
ls /etc/apt/keyrings/
```

**Задание 4:** Добавь Docker repository (manual)

```bash
# Шаг 1: Установи зависимости
sudo apt install -y ca-certificates curl gnupg lsb-release

# Шаг 2: Добавь GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Шаг 3: Добавь repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Шаг 4: Обнови индекс
sudo apt update

# Шаг 5: Проверь что Docker доступен
apt search docker-ce
```

**Задание 5:** Установи Docker из official repo

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Проверь
docker --version
# Docker version 24.0.5, build ced0996
```

**Задание 6:** Проверь откуда установлен пакет

```bash
apt-cache policy docker-ce

# Вывод:
# docker-ce:
#   Installed: 5:24.0.5-1~ubuntu.22.04~jammy
#   Candidate: 5:24.0.5-1~ubuntu.22.04~jammy
#   Version table:
#  *** 5:24.0.5-1~ubuntu.22.04~jammy 500
#         500 https://download.docker.com/linux/ubuntu jammy/stable amd64 Packages
#         100 /var/lib/dpkg/status
```

**Видишь:** `https://download.docker.com` — Docker official repo, НЕ Ubuntu!

---

### 🤔 Проверка понимания

**LILITH:** *"Repositories и security. Проверка."*

**Вопрос:** Зачем нужны GPG keys при добавлении репозитория?

<details>
<summary>Ответ</summary>

**GPG keys = цифровые подписи для проверки подлинности пакетов.**

**Проблема без GPG:**

```
1. Ты добавляешь репозиторий: http://evil-hacker.com/ubuntu
2. apt скачивает пакеты с этого сайта
3. Хакер подменил nmap на backdoored версию
4. Ты устанавливаешь: sudo apt install nmap
5. Установлен backdoor! 🚨
```

**С GPG keys:**

```
1. Docker подписывает свои пакеты приватным ключом
2. Ты добавляешь публичный ключ Docker: curl ... | gpg --dearmor
3. apt скачивает пакет docker-ce
4. apt проверяет подпись с помощью публичного ключа
5. Если подпись неверная — apt откажется устанавливать!
```

**Как работает:**

```bash
# Docker подписывает (на их сервере):
docker-ce.deb + Docker_Private_Key = Signature

# apt проверяет (на твоей машине):
docker-ce.deb + Signature + Docker_Public_Key = Valid? ✅ или ❌

# Если Valid ✅ → install
# Если Invalid ❌ → WARNING: Package signature verification failed!
```

**Практика:**

```bash
# Добавить репозиторий БЕЗ GPG key:
echo "deb https://download.docker.com/linux/ubuntu jammy stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list

sudo apt update
# Вывод:
# W: GPG error: https://download.docker.com/linux/ubuntu jammy InRelease
# E: The repository is not signed.

# apt ОТКАЖЕТСЯ устанавливать! Безопасность.
```

**LILITH:** *"GPG = безопасность. Без GPG = можешь установить что угодно с любого сайта. Всегда добавляй GPG key при добавлении репозитория. Всегда."*

</details>

---

## Цикл 5: Batch operations — установка списка (10-12 минут)

### 🎬 Сюжет: Массовая установка

**14:00 — Квартира Макса**

Макс смотрит на список. 15 пакетов. Уже установил: nmap, tcpdump, htop, iotop, Docker.

Остались: wireshark, fail2ban, ufw, nethogs, git, curl, jq, еще 8 пакетов.

**Макс:**
> *"Устанавливать каждый по отдельности? Долго..."*

**LILITH:**
> *"Помнишь Episode 03? Text processing? ONE-LINERS? Пришло время применить."*

> *"Viktor дал тебе файл `required_tools.txt`. В нём список пакетов. По одному на строку."*

> *"Задача: установить ВСЕ одной командой. Без bash скрипта. Только apt + pipes."*

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│                                                               │
│ "Batch операции = массовая обработка. Unix way.              │
│                                                               │
│  У тебя файл со списком:                                     │
│  required_tools.txt:                                         │
│    nmap                                                      │
│    tcpdump                                                   │
│    wireshark                                                 │
│    ...                                                       │
│                                                               │
│  Вручную:                                                    │
│    sudo apt install nmap                                     │
│    sudo apt install tcpdump                                  │
│    sudo apt install wireshark                                │
│    ... (15 команд)                                           │
│                                                               │
│  ONE-LINER:                                                  │
│    cat required_tools.txt | grep -v '^#' | xargs sudo apt install -y│
│                                                               │
│  1 команда. 15 пакетов. 30 секунд. Это Type B."            │
└─────────────────────────────────────────────────────────────┘
```

---

### 📚 Теория: xargs — batch processing

#### Что такое xargs?

**xargs** — читает stdin, передаёт в аргументы команды.

**Проблема:**

```bash
# Хочу установить пакеты из файла:
cat required_tools.txt
# nmap
# tcpdump
# htop

# Попытка 1 (НЕ работает):
cat required_tools.txt | sudo apt install
# Ошибка! apt не читает из stdin!

# Попытка 2 (работает):
cat required_tools.txt | xargs sudo apt install -y
# xargs передаёт каждую строку как аргумент apt
# Эквивалентно: sudo apt install -y nmap tcpdump htop
```

#### xargs синтаксис

```bash
# Базовый
cat file.txt | xargs command

# С опциями
xargs -n 1 command    # По одному аргументу за раз
xargs -I {} command {} # Заменить {} на input
xargs -P 4 command    # Параллельно (4 процесса)
```

#### Примеры использования

**Установка пакетов из файла:**

```bash
cat required_tools.txt | xargs sudo apt install -y
```

**Установка по одному (с логированием):**

```bash
cat required_tools.txt | xargs -n 1 sudo apt install -y
# -n 1 = по одному пакету
```

**С фильтрацией комментариев:**

```bash
cat required_tools.txt | grep -v '^#' | grep -v '^$' | xargs sudo apt install -y
# grep -v '^#' = убрать строки начинающиеся с #
# grep -v '^$' = убрать пустые строки
```

**Альтернатива — while read:**

```bash
while read package; do
  [[ "$package" =~ ^# ]] && continue  # Skip comments
  [[ -z "$package" ]] && continue     # Skip empty lines
  sudo apt install -y "$package"
done < required_tools.txt
```

**Но xargs проще!** Type B = ONE-LINER.

> **LILITH:** *"xargs = массовая обработка. 15 пакетов → 1 команда. Используй для batch операций. Но помни: если один пакет сломается — могут сломаться все. Для production лучше по одному с логированием. Но мы Type B — используем инструменты, не пишем обёртки."*

---

### 💻 Практика: Batch installation (7 минут)

**Задание 1:** Посмотри содержимое required_tools.txt

```bash
cd artifacts/
cat required_tools.txt

# # OPERATION KERNEL SHADOWS
# # Required Tools for Infrastructure
#
# # Security & Networking
# nmap
# tcpdump
# wireshark
# fail2ban
# ufw
#
# # Monitoring
# htop
# iotop
# nethogs
#
# # Development
# git
# curl
# jq
```

**Задание 2:** Убери комментарии и пустые строки

```bash
grep -v '^#' required_tools.txt | grep -v '^$'
# Вывод:
# nmap
# tcpdump
# wireshark
# fail2ban
# ufw
# htop
# iotop
# nethogs
# git
# curl
# jq
```

**Задание 3:** Установи ВСЕ одной командой (ONE-LINER!)

```bash
grep -v '^#' required_tools.txt | grep -v '^$' | xargs sudo apt install -y
```

**Что происходит:**
1. grep убирает комментарии
2. grep убирает пустые строки
3. xargs передаёт список в `apt install`
4. apt устанавливает все пакеты разом

**Задание 4:** Проверь что установлено

```bash
# ONE-LINER для проверки:
while read pkg; do
  [[ "$pkg" =~ ^# || -z "$pkg" ]] && continue
  dpkg -l "$pkg" 2>/dev/null | grep "^ii" && echo "✓ $pkg" || echo "✗ $pkg"
done < required_tools.txt
```

**Задание 5:** Посчитай сколько установлено

```bash
while read pkg; do
  [[ "$pkg" =~ ^# || -z "$pkg" ]] && continue
  dpkg -l "$pkg" 2>/dev/null | grep -q "^ii" && echo "installed"
done < required_tools.txt | wc -l
```

---

### 🤔 Проверка понимания

**LILITH:** *"xargs и batch operations. Проверка."*

**Вопрос:** В чём разница между этими двумя командами?

```bash
# Вариант 1:
cat required_tools.txt | xargs sudo apt install -y

# Вариант 2:
cat required_tools.txt | xargs -n 1 sudo apt install -y
```

<details>
<summary>Ответ</summary>

**Разное поведение:**

**Вариант 1 (без `-n 1`):**
```bash
xargs sudo apt install -y
# Передаёт ВСЕ пакеты одной командой:
# sudo apt install -y nmap tcpdump wireshark fail2ban ufw htop iotop ...

# Плюсы:
#   ✅ Быстро (1 транзакция apt)
#   ✅ apt оптимизирует dependency resolution
# Минусы:
#   ❌ Если один пакет сломан → могут не установиться все
#   ❌ Трудно отследить какой именно пакет failed
```

**Вариант 2 (с `-n 1`):**
```bash
xargs -n 1 sudo apt install -y
# Передаёт по ОДНОМУ пакету за раз:
# sudo apt install -y nmap
# sudo apt install -y tcpdump
# sudo apt install -y wireshark
# ... (15 отдельных команд)

# Плюсы:
#   ✅ Если один failed → остальные установятся
#   ✅ Легко увидеть какой именно пакет failed
#   ✅ Можно логировать каждый отдельно
# Минусы:
#   ❌ Медленнее (15 транзакций apt)
#   ❌ apt повторно проверяет dependencies
```

**Когда что использовать:**

```bash
# Development/Testing (быстро):
cat list.txt | xargs sudo apt install -y

# Production (надёжно):
cat list.txt | xargs -n 1 sudo apt install -y

# Production с логированием:
cat list.txt | while read pkg; do
  echo "Installing $pkg..."
  sudo apt install -y "$pkg" && echo "✓ $pkg" || echo "✗ $pkg FAILED"
done
```

**LILITH:** *"`-n 1` = по одному. Медленнее, но надёжнее. Без `-n 1` = всё разом. Быстрее, но рискованнее. Для 50 серверов используй Ansible (Episode 16). Для workstation — xargs достаточно."*

</details>

---

## Цикл 6: Verification & Cleanup (8-10 минут)

### 🎬 Сюжет: Проверка результата

**15:00 — Квартира Макса**

Макс установил все пакеты. Терминал показывает "Done".

**Viktor (сообщение):**
> *"Статус?"*

**Макс:**
> *"Все установлено. Проверяю..."*

**LILITH:**
> *"Не доверяй 'Done'. Проверяй. Всегда."*

> *"Verification = убедиться что всё работает. Cleanup = убрать мусор."*

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│                                                               │
│ "Verification = проверка боеготовности.                      │
│                                                               │
│  После установки:                                            │
│  1. Проверь что пакеты установлены (dpkg -l)                │
│  2. Проверь что команды работают (which, --version)         │
│  3. Почисть неиспользуемые зависимости (autoremove)         │
│  4. Почисть cache (clean)                                   │
│  5. Сгенерируй отчёт (для Viktor)                           │
│                                                               │
│  'Done' на экране ≠ всё работает.                            │
│  Только verification даёт уверенность."                      │
└─────────────────────────────────────────────────────────────┘
```

---

### 📚 Теория: Verification и Cleanup

#### Verification commands

**Проверка установки:**

```bash
# Вариант 1: dpkg
dpkg -l package_name | grep "^ii"

# Вариант 2: apt
apt list --installed | grep package_name

# Вариант 3: which (проверка command)
which nmap
# /usr/bin/nmap = установлен

# Вариант 4: version
nmap --version
docker --version
```

**Проверка списка пакетов:**

```bash
# ONE-LINER:
while read pkg; do
  [[ "$pkg" =~ ^# || -z "$pkg" ]] && continue
  if dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
    version=$(dpkg -l "$pkg" | grep "^ii" | awk '{print $3}')
    echo "✓ $pkg ($version)"
  else
    echo "✗ $pkg (NOT INSTALLED)"
  fi
done < required_tools.txt
```

#### Cleanup commands

**Удаление неиспользуемых зависимостей:**

```bash
sudo apt autoremove
# Удаляет пакеты которые были установлены как зависимости,
# но больше не нужны (orphaned packages)
```

**Очистка cache:**

```bash
# Вариант 1: Удалить скачанные .deb files
sudo apt clean
# Удаляет /var/cache/apt/archives/*.deb (освобождает место)

# Вариант 2: Удалить только старые версии
sudo apt autoclean
# Удаляет только устаревшие .deb files
```

**Проверка использования места:**

```bash
# Сколько занимает apt cache:
du -sh /var/cache/apt/archives/
# 450 MB

# После apt clean:
sudo apt clean
du -sh /var/cache/apt/archives/
# 0 MB
```

#### Security: проверка updates

```bash
# Проверь security updates
sudo apt update
apt list --upgradable | grep -i security

# Если есть:
sudo apt upgrade -y
```

> **LILITH:** *"Cleanup = гигиена системы. autoremove = убрать мусор. clean = освободить место. Делай регулярно. Особенно на production с ограниченным диском."*

---

### 💻 Практика: Verification & Cleanup (7 минут)

**Задание 1:** Проверь что все пакеты установлены

```bash
cd artifacts/

# ONE-LINER для проверки:
echo "=== VERIFICATION REPORT ===" > verification_report.txt
echo "" >> verification_report.txt

while read pkg; do
  [[ "$pkg" =~ ^# || -z "$pkg" ]] && continue
  if dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
    version=$(dpkg -l "$pkg" | grep "^ii" | awk '{print $3}')
    echo "✓ $pkg ($version)" | tee -a verification_report.txt
  else
    echo "✗ $pkg (NOT INSTALLED)" | tee -a verification_report.txt
  fi
done < required_tools.txt

# Вывод в терминал И в файл
```

**Задание 2:** Проверь что команды работают

```bash
# Выборочно:
which nmap && echo "✓ nmap found"
which tcpdump && echo "✓ tcpdump found"
which docker && echo "✓ docker found"

# Версии:
nmap --version | head -1
docker --version
```

**Задание 3:** Проверь security updates

```bash
sudo apt update
apt list --upgradable

# Если есть:
sudo apt upgrade -y
```

**Задание 4:** Удали неиспользуемые зависимости

```bash
# Посмотри что будет удалено:
apt autoremove
# The following packages will be REMOVED:
#   libold1 libunused2 ...

# Удали:
sudo apt autoremove -y
```

**Задание 5:** Очисти cache

```bash
# Посмотри размер:
du -sh /var/cache/apt/archives/

# Очисти:
sudo apt clean

# Проверь снова:
du -sh /var/cache/apt/archives/
# Должно быть ~0 MB
```

**Задание 6:** Посчитай статистику

```bash
# Сколько установлено всего:
dpkg -l | grep "^ii" | wc -l

# Сколько из твоего списка:
while read pkg; do
  [[ "$pkg" =~ ^# || -z "$pkg" ]] && continue
  dpkg -l "$pkg" 2>/dev/null | grep -q "^ii" && echo "ok"
done < required_tools.txt | wc -l
```

---

## Цикл 7: Generate report — финальный ONE-LINER (10 минут)

### 🎬 Сюжет: Отчёт для Viktor

**16:00 — Квартира Макса**

**Viktor (звонок):**
> *"Максим, статус? Все инструменты установлены?"*

**Макс:**
> *"Да. Проверил. Все работает."*

**Viktor:**
> *"Отлично. Отправь отчёт. Что установлено, какие версии. Мне нужно для документации."*

**LILITH:**
> *"Отчёт. Финальный штрих. ONE-LINER для генерации."*

> *"НЕ bash скрипт на 355 строк. Просто команда. Type B."*

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│                                                               │
│ "Отчёт = proof of work.                                      │
│                                                               │
│  Viktor нужно знать:                                         │
│  1. Что установлено                                          │
│  2. Какие версии                                             │
│  3. Откуда (repository)                                      │
│  4. Когда (timestamp)                                        │
│                                                               │
│  Bash скрипт на 355 строк с функциями, массивами, цветами?  │
│  НЕТ.                                                        │
│                                                               │
│  ONE-LINER на 15-20 строк с командами apt/dpkg?             │
│  ДА. Type B."                                                │
└─────────────────────────────────────────────────────────────┘
```

---

### 📚 Финальное задание: Generate Installation Report

#### Требования Viktor:

1. ✅ Список установленных пакетов из required_tools.txt
2. ✅ Версии каждого пакета
3. ✅ Статус (installed или failed)
4. ✅ System info (Ubuntu version, date)
5. ✅ Сохранить в install_report.txt

#### Type B решение: ONE-LINER!

**БЕЗ bash скрипта. Просто команда:**

```bash
{
  echo "═══════════════════════════════════════════════════════════════"
  echo "           PACKAGE INSTALLATION REPORT"
  echo "═══════════════════════════════════════════════════════════════"
  echo ""
  echo "Date: $(date '+%d %B %Y, %H:%M')"
  echo "System: $(lsb_release -ds)"
  echo "Kernel: $(uname -r)"
  echo "Architecture: $(dpkg --print-architecture)"
  echo ""
  echo "───────────────────────────────────────────────────────────────"
  echo "INSTALLED PACKAGES FROM required_tools.txt"
  echo "───────────────────────────────────────────────────────────────"
  echo ""

  while read pkg; do
    [[ "$pkg" =~ ^#.*$ || -z "$pkg" ]] && continue
    if dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
      version=$(dpkg -l "$pkg" | grep "^ii" | awk '{print $3}')
      repo=$(apt-cache policy "$pkg" | grep -A 1 "Installed:" | tail -1 | awk '{print $2}')
      echo "  ✓ $pkg"
      echo "    Version: $version"
      echo "    Repository: $repo"
      echo ""
    else
      echo "  ✗ $pkg — NOT INSTALLED"
      echo ""
    fi
  done < artifacts/required_tools.txt

  echo "───────────────────────────────────────────────────────────────"
  echo "STATISTICS"
  echo "───────────────────────────────────────────────────────────────"
  echo ""
  echo "Total packages in system: $(dpkg -l | grep "^ii" | wc -l)"
  echo "Packages from required list: $(while read p; do [[ "$p" =~ ^# || -z "$p" ]] && continue; dpkg -l "$p" 2>/dev/null | grep -q "^ii" && echo "1"; done < artifacts/required_tools.txt | wc -l)"
  echo "Disk usage (apt cache): $(du -sh /var/cache/apt/archives/ | awk '{print $1}')"
  echo ""
  echo "═══════════════════════════════════════════════════════════════"
  echo "                      END OF REPORT"
  echo "═══════════════════════════════════════════════════════════════"
  echo ""
  echo "Generated by: Max Sokolov"
  echo "For: Viktor Petrov (OPERATION KERNEL SHADOWS)"

} > install_report.txt

echo "✓ Report saved: install_report.txt"
cat install_report.txt
```

**Это ~40 строк. НЕ 355!** Type B! ✅

---

### 💻 Практика: Финальный отчёт (10 минут)

**Задание 1:** Сгенерируй отчёт (скопируй команду выше)

```bash
# Скопируй полный ONE-LINER из теории выше
# Запусти в терминале
```

**Задание 2:** Проверь содержимое

```bash
cat install_report.txt

# Должен увидеть:
# - Header с датой и system info
# - Список пакетов с версиями
# - Statistics
# - Footer
```

**Задание 3:** Отправь Viktor (симуляция)

```bash
# В реальности:
# scp install_report.txt viktor@server:/reports/

# Симуляция:
echo "📧 Sending report to Viktor..."
echo "✓ Report sent!"
```

---

### 🤔 Финальная проверка

**LILITH:** *"Episode 04 завершён. Type B validation."*

**Вопрос:** Почему этот episode Type B, а не Type A?

<details>
<summary>Ответ</summary>

**Type A vs Type B:**

**Type A (что было бы):**
- 355 строк bash скрипт `install_toolkit.sh`
- 7 bash функций (log_message, check_root, install_package...)
- Массивы (INSTALLED, FAILED, SKIPPED)
- Цветной вывод (COLOR_RED, COLOR_GREEN...)
- Backup system
- Error handling
- **Фокус: 80% bash / 20% apt** ❌

**Type B (что сделали):**
- 0 строк bash скрипт (или 40 строк ONE-LINER для отчёта)
- Все задания = прямые команды apt/dpkg
- Batch operations через xargs (ONE-LINER)
- Финальный отчёт = 40 строк команд (НЕ функции!)
- **Фокус: 95% apt/dpkg / 5% bash** ✅

**Философия Type B:**

```
apt существует с 1998 года.
Установлен на миллионах серверов.
Оптимизирован.
Протестирован.

Переписывать apt в bash = переизобретение велосипеда.

Для 1 machine: команды apt
Для 50 machines: Ansible (Episode 16)

Bash wrapper на 355 строк = костыль между ними.
Не нужен.
```

**Episode 04 = Type B reference:**
- Научились использовать apt как инструмент
- НЕ писать обёртки
- Для автоматизации на 50 серверов — Ansible (Season 4)
- Package management ≠ bash programming

**LILITH:** *"Episode 04 = Type B. Используй инструменты. Не переписывай инструменты. apt/dpkg существуют 30 лет не просто так. Доверяй. Используй. Автоматизируй минимально."*

</details>

---

## 🎬 Эпилог: Готовность к Season 2

**17:00 — Квартира Макса**

Viktor звонит:

> **Viktor:**
> *"Отчёт получил. Хорошая работа. Все инструменты установлены. Workstation готова."*

> **Viktor:**
> *"Завтра — Season 2. Networking. Москва. Встретишься с командой лично. Алекс, Анна, Дмитрий. Будем строить инфраструктуру."*

**Макс:**
> *"Готов. Workstation настроена. Все инструменты работают."*

> **Viktor:**
> *"Отлично. Один момент: для 50 серверов не используй apt вручную. Season 4 научу тебя Ansible. Автоматизация на уровне инфраструктуры."*

> *"Но понимать apt нужно. Ты понимаешь. Молодец."*

**LILITH:**
> *"Episode 04 завершён. Ты научился использовать package manager. Правильно.*
>
> *apt = инструмент администратора. Не bash скрипты. Инструмент.*
>
> *Season 1 Complete! Shell → Scripting → Text Processing → Package Management.*
>
> *Season 2: Networking. Москва. Команда. Инфраструктура."*

```
┌─────────────────────────────────────────────────────────────┐
│ SEASON 1 COMPLETE! 🎉                                        │
│                                                               │
│ Episode 01: Terminal basics       ✓                          │
│ Episode 02: Bash scripting         ✓                          │
│ Episode 03: Text processing        ✓                          │
│ Episode 04: Package management     ✓                          │
│                                                               │
│ Next: Season 2 — Networking (Moscow → Stockholm)             │
│ Episode 05: TCP/IP Fundamentals                              │
│                                                               │
│ Location: Москва, Россия 🇷🇺                                 │
│ Day: 9 (of 60)                                               │
│ Characters: Viktor, Alex, Anna, Dmitry (in person!)          │
│                                                               │
│ Skills unlocked:                                             │
│ • Shell navigation                                           │
│ • Bash automation                                            │
│ • Log analysis (grep/awk/pipes)                              │
│ • Package management (apt/dpkg)                              │
│                                                               │
│ Ready for infrastructure work! 🚀                            │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 Итоги Episode 04

### Что ты освоил:

#### Package Management (95%):
- ✅ **apt** — установка, поиск, обновление, удаление
- ✅ **dpkg** — inspection, verification, файловая база данных
- ✅ **Repositories** — sources.list, GPG keys, Docker repo
- ✅ **Batch operations** — xargs для массовой установки
- ✅ **Verification** — проверка установки, версий
- ✅ **Cleanup** — autoremove, clean, автообслуживание

#### Minimal Bash (5%):
- ✅ ONE-LINER для проверки списка пакетов
- ✅ ONE-LINER для генерации отчёта
- ✅ while read для обработки файлов

#### Концепции:
- ✅ Type B episode: инструменты first, bash second
- ✅ "apt exists for a reason — use it, don't rewrite it"
- ✅ Package manager = инструмент администратора
- ✅ Для 1 machine: apt. Для 50: Ansible.

---

## 📈 Статистика

**Время прохождения:** 2-2.5 часа
**Циклов:** 7 (по 10-15 минут)
**Метафор:** 5 (App Store, Магазин+склад, Инвентарь, Доверие GPG)
**ASCII диаграмм:** 3 (Package layers, Repositories)
**"Aha!" моментов:** 4
**LILITH цитат:** 15+
**Упражнений:** 7

**Баланс контента:**
- Package Management (apt/dpkg): **95%** ✅
- Bash (minimal ONE-LINERS): **5%** ✅
- Type B Episode: ✅

---

## 🎯 Следующие шаги

1. **Практика (опционально):**
   - Установи еще пакеты на workstation
   - Экспериментируй с PPA
   - Изучи Docker containers

2. **Season 2: Networking**
   - Episode 05: TCP/IP Fundamentals
   - Episode 06: DNS & Name Resolution
   - Episode 07: Firewalls & iptables
   - Episode 08: VPN & SSH Tunneling

3. **Season 4: DevOps (preview)**
   - Episode 16: Ansible — автоматизация для 50 серверов
   - Infrastructure as Code
   - Идемпотентность

---

## 💡 Шпаргалка: Основные команды

```bash
# APT basics
sudo apt update              # Обновить индекс пакетов
sudo apt upgrade             # Обновить установленные пакеты
apt search <name>            # Найти пакет
apt show <name>              # Информация о пакете
sudo apt install <name>      # Установить
sudo apt remove <name>       # Удалить (оставить configs)
sudo apt purge <name>        # Удалить полностью
sudo apt autoremove          # Очистить orphaned dependencies
sudo apt clean               # Очистить cache

# DPKG inspection
dpkg -l                      # Список установленных
dpkg -l <name>               # Статус пакета
dpkg -s <name>               # Детальная информация
dpkg -L <name>               # Файлы пакета
dpkg -S <file>               # Какой пакет установил файл

# Repositories
cat /etc/apt/sources.list    # Основные репозитории
ls /etc/apt/sources.list.d/  # Дополнительные репозитории
sudo apt-add-repository ppa:xyz/ppa  # Добавить PPA

# Batch operations
cat list.txt | xargs sudo apt install -y  # Установить список
cat list.txt | xargs -n 1 sudo apt install -y  # По одному

# Verification
which <command>              # Проверка наличия команды
<command> --version          # Проверка версии
apt list --installed | grep <name>  # Проверка установки
```

---

**КОНЕЦ EPISODE 04** ✅
**SEASON 1 COMPLETE!** 🎉

---

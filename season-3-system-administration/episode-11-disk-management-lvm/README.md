# EPISODE 11: DISK MANAGEMENT & LVM
## Season 3: System Administration | Tallinn, Estonia 🇪🇪

> *"e-Estonia работает на доверии к данным. Если диск умирает — доверие умирает."*
> — **Kristjan Tamm**, e-Government Infrastructure Architect

---

## 📍 Контекст миссии

**Локация:** 🇪🇪 **Tallinn, Estonia**
**Место:** e-Residency Center, Старый город Таллина
**День операции:** **21-22** из 60
**Время прохождения:** **4-5 часов**
**Сложность:** ⭐⭐⭐⭐☆ (Высокая)

**Персонажи:**
- **Макс Соколов** — вы, изучаете disk management
- **Kristjan Tamm** — e-Government infrastructure architect, эксперт по LVM
- **Liisa Kask** — backup & recovery specialist
- **Виктор Петров** — координатор операции
- **LILITH** — AI-помощник (я!)

---

## 🎬 Сюжет: Гонка со временем

### День 21. Переезд: Санкт-Петербург → Tallinn.

Макс садится на автобус из Санкт-Петербурга в Таллин (8 часов в пути через границу). Борис провожает на автовокзале:

**Борис Кузнецов:**
*"Макс, ты освоил systemd. Процессы под контролем. Но процессы бессмысленны без данных. Данные живут на дисках. Без правильного disk management — ты теряешь всё."*

**Макс:**
*"LVM? RAID? Слышал эти термины, но никогда не работал с ними."*

**Борис:**
*"Kristjan научит. В Таллине — e-Estonia. Вся страна работает онлайн. Паспорта, голосование, бизнес — всё на серверах. Если диск умирает — страна останавливается. Они знают disk management как никто."*

Макс садится в автобус. 8 часов через границу, мимо соснового леса, через Нарву. Думает о том, что будет дальше.

---

### 11:00. Tallinn. Старый город.

Макс прибывает в Таллин. Средневековый город с современной IT-инфраструктурой. Готические башни и fiber optic кабели. Встреча у e-Residency Center на Vabaduse väljak.

**Kristjan Tamm** (встречает Макса у входа, ~40 лет, hoodie "e-Estonia", laptop под мышкой):
*"Max! Welcome to Tallinn! Viktor told me about your operation. You've learned processes, permissions, networking. Now — storage. In Estonia, we say: 'Data is the new oil'. But oil is useless if the tank leaks."*

**Макс:**
*"Boris said you're the best in disk management."*

**Kristjan:**
*"e-Estonia runs on trust. Citizens trust government because data is always available. Always secure. How? Redundancy. LVM for flexibility. RAID for reliability. Backups for recovery. I'll show you."*

Они проходят в серверную e-Residency. Десятки серверов, мигающие индикаторы дисков, monitoring dashboard на стене.

**Kristjan:**
*"Here we store digital identities of 100,000+ e-residents from 170+ countries. Disk failure? Not an option. Downtime? Not acceptable. Let me introduce you to Liisa."*

**Liisa Kask** (backup engineer, ~30 лет, headphones на шее, laptop с monitoring dashboard открыт):
*"Max? Viktor said you're good with scripts. Perfect. We need someone who understands automation. Disk management without automation — это chaos."*

---

### 12:00. Emergency: Disk Failure Alert!

Внезапно — **ALARM** на monitoring dashboard Liisa. Красные индикаторы. Slack channel взрывается уведомлениями.

**Liisa** (резко встаёт, снимает headphones):
*"Disk failure on production server! `/dev/sdb` — one of our data drives. SMART reports critical errors. Reallocated sectors: 247. We have maybe 2-3 hours before complete failure."*

**Kristjan** (спокойно, но быстро):
*"Max, you're about to learn disk management the hard way. Real incident. Production. Under pressure. We need to:*

1. *Check disk health (SMART status)*
2. *Migrate data to new disk (before failure)*
3. *Set up LVM properly (for future flexibility)*
4. *Configure monitoring (never miss failure again)*
5. *Test recovery procedures"*

**Макс:**
*"I've never done this before..."*

**Kristjan:**
*"Perfect time to learn. In production. Just like real sysadmin work. Don't worry — we have backups."*

Пауза.

*"Probably."*

**Liisa** (улыбается):
*"Kristjan loves 'learning by fire'. But seriously, I'll guide you. Disk management is critical. Mistakes here — and you lose everything. Ready?"*

**Макс:** *"Let's do it."*

---

## 🎯 Твоя миссия

Научиться **управлять дисками, LVM, RAID** на production сервере под давлением времени.

**Цели:**
1. ✅ Понять как работают диски в Linux (block devices, partitions)
2. ✅ Научиться проверять health (SMART monitoring)
3. ✅ Освоить LVM (Physical Volumes, Volume Groups, Logical Volumes)
4. ✅ Провести миграцию данных с failing disk
5. ✅ Настроить `/etc/fstab` для автоматического монтирования
6. ✅ Создать systemd service для disk monitoring
7. ✅ Понять RAID концепты (redundancy)

**Итог:**
Production-ready disk management с LVM flexibility, redundancy и automated monitoring.

---

## 📁 Структура файлов

```
episode-11-disk-management-lvm/
├── README.md                  # 📖 Теория + задания (этот файл)
│
├── starter.sh                 # 🎯 Bash template с TODO
│                                 - LVM automation
│                                 - Data migration
│                                 - Monitoring setup
│
├── solution/                  # ✅ Референсное решение
│   ├── disk_manager.sh         # Production-ready LVM script
│   ├── configs/
│   │   ├── fstab.example       # /etc/fstab конфигурация
│   │   └── disk-monitor.service # systemd monitoring service
│   └── README.md              # Полный workflow решения
│
├── artifacts/                 # 🗂️ Тестовые данные
│   └── README.md
│
└── tests/                     # 🧪 Автотесты
    └── test.sh                # Проверка решения
```

### 🚀 Как начать?

1. **Прочитай теорию** в этом README (8 micro-cycles ниже)
2. **Открой `starter.sh`** — заполни TODO комментарии
3. **Изучи LVM команды** — практика в каждом цикле
4. **Настрой `/etc/fstab`** — автоматическое монтирование
5. **Создай monitoring** — systemd service для disk alerts
6. **Запусти тесты** `./tests/test.sh`

---

## 🎓 Философия Episode: Type A — Bash Automation OK

**Episode 11 — это Type A episode.**

✅ **Bash automation приветствуется для:**
- LVM setup (pvcreate, vgcreate, lvcreate в цикле)
- Data migration (rsync с progress bar)
- Health checks automation

**НО:**
- 70% времени: изучение LVM команд, концептов
- 20% времени: `/etc/fstab`, systemd конфигурация
- 10% времени: bash для автоматизации

**Kristjan:**
*"LVM — это инструмент. Bash — это автоматизация инструмента. Сначала научись использовать LVM вручную. Потом автоматизируй."*

---

## 📚 ТЕОРИЯ: 8 MICRO-CYCLES

### Навигация по циклам:
- **Цикл 1:** Философия дисков (10-15 мин) → Block devices, partitions
- **Цикл 2:** SMART Monitoring (15 мин) → Disk health, предсказание failures
- **Цикл 3:** LVM: Physical Volumes (20 мин) → PV, pvcreate, pvdisplay
- **Цикл 4:** LVM: Volume Groups & Logical Volumes (25 мин) → VG, LV, resize
- **Цикл 5:** Filesystems & /etc/fstab (20 мин) → ext4, xfs, auto-mount
- **Цикл 6:** Data Migration (15 мин) → rsync, dd, безопасное копирование
- **Цикл 7:** RAID Concepts (15 мин) → Redundancy, RAID 0/1/5/10
- **Цикл 8:** Production Monitoring (15-20 мин) → systemd service, alerts

**Общее время:** ~2 часа теории + 2-3 часа практики = **4-5 часов**

---

## 🔄 ЦИКЛ 1: Философия дисков в Linux (10-15 минут)

### 🎬 Сюжет

**Kristjan** (подводит Макса к monitoring dashboard):
*"Смотри. Сейчас в этой серверной работает 180 дисков. HDD и SSD. Каждый диск — это block device. Kernel видит их как файлы в `/dev/`."*

```bash
$ ls /dev/sd*
/dev/sda  /dev/sda1  /dev/sda2
/dev/sdb  /dev/sdb1
/dev/sdc
```

**Kristjan:**
*"Каждый `/dev/sdX` — это физический диск. `/dev/sdX1`, `/dev/sdX2` — это partitions (разделы). Linux работает с дисками через эти файлы."*

**Макс:**
*"Как обычные файлы?"*

**Kristjan:**
*"Да. В Linux всё — файл. Диск — это special file. Можешь читать и писать как в обычный файл. Но осторожно — прямая запись в `/dev/sda` может уничтожить всю систему."*

---

### 📚 Теория: Block Devices в Linux

#### 🏢 Метафора: Disk = Склад для хранения

Представь Linux систему как **огромный офис**:

```
🏢 LINUX OFFICE
│
├─ 💾 Склад #1 (/dev/sda) — HDD 2TB
│  ├─ 📦 Секция 1 (/dev/sda1) — OS (100GB)
│  ├─ 📦 Секция 2 (/dev/sda2) — Swap (16GB)
│  └─ 📦 Секция 3 (/dev/sda3) — /home (1.8TB)
│
├─ 💾 Склад #2 (/dev/sdb) — SSD 500GB [⚠️ FAILING!]
│  └─ 📦 Секция 1 (/dev/sdb1) — Databases (500GB)
│
└─ 💾 Склад #3 (/dev/sdc) — SSD 500GB [НОВЫЙ]
   └─ (пусто, нужно настроить)
```

**Каждый склад (disk):**
- Имеет **адрес** (`/dev/sda`, `/dev/sdb`)
- Разделён на **секции** (partitions)
- Каждая секция содержит **данные** (filesystem)

**Системный администратор** (ты) управляешь складами:
- Проверяешь **health** (SMART)
- Создаёшь **новые секции** (partitioning)
- **Переносишь данные** между складами (migration)
- Настраиваешь **автоматическую доставку** (fstab mounting)

---

#### 🎯 Ключевые концепты

##### 1. **Block Device**

**Block device** — это устройство которое читает/пишет данные **блоками** (обычно 512 bytes или 4KB).

```bash
# Список всех block devices
lsblk

# Вывод:
# NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
# sda      8:0    0   2TB  0 disk
# ├─sda1   8:1    0  100G  0 part /
# ├─sda2   8:2    0   16G  0 part [SWAP]
# └─sda3   8:3    0  1.8T  0 part /home
# sdb      8:16   0  500G  0 disk
# └─sdb1   8:17   0  500G  0 part /var/lib/mysql
```

**Колонки:**
- **NAME:** Имя устройства
- **MAJ:MIN:** Major/Minor numbers (kernel identifiers)
- **SIZE:** Размер
- **TYPE:** disk (целый диск) или part (partition)
- **MOUNTPOINT:** Где смонтировано (если смонтировано)

---

##### 2. **Naming Convention**

Linux использует предсказуемые имена для дисков:

| Тип диска | Naming | Пример |
|-----------|--------|--------|
| **SATA/SAS HDD/SSD** | `/dev/sdX` | `/dev/sda`, `/dev/sdb` |
| **NVMe SSD** | `/dev/nvmeXnY` | `/dev/nvme0n1` |
| **Virtual (KVM/Xen)** | `/dev/vdX` | `/dev/vda` |
| **Old IDE** | `/dev/hdX` | `/dev/hda` (deprecated) |

**Partitions:**
- `/dev/sda` → целый диск
- `/dev/sda1` → первая partition
- `/dev/sda2` → вторая partition

**Kristjan:**
*"`/dev/sda` — это весь склад. `/dev/sda1` — это конкретная секция в складе. Нельзя монтировать весь склад если в нём есть секции."*

---

##### 3. **Partitions (разделы)**

**Partition** — это логическое разделение диска на независимые части.

**Зачем нужны partitions?**
- ✅ Разделение OS и данных (если OS сломается → данные целы)
- ✅ Разные filesystems на одном диске (ext4 для /, xfs для /data)
- ✅ Dual boot (Linux + Windows на одном диске)
- ✅ Безопасность (отдельный раздел для /tmp с noexec)

**Схема partitioning (типичная):**

```
/dev/sda (2TB HDD)
│
├─ /dev/sda1 — 512MB  — EFI System Partition (boot)
├─ /dev/sda2 — 100GB  — / (root filesystem)
├─ /dev/sda3 — 16GB   — swap (virtual memory)
└─ /dev/sda4 — 1.8TB  — /home (user data)
```

---

##### 4. **Partition Tables**

**Partition table** хранит информацию о partitions на диске.

**Два стандарта:**

| MBR (старый) | GPT (современный) |
|--------------|-------------------|
| Max 4 primary partitions | Max 128 partitions |
| Max 2TB disk size | Max 8 ZB (zettabytes) |
| Legacy BIOS | UEFI + BIOS |
| Нет резервной копии | Резервная копия в конце диска |

**Kristjan:**
*"Всегда используй GPT для новых дисков. MBR — это legacy. GPT надёжнее и поддерживает большие диски."*

---

### 💻 Практика: Инспекция дисков

#### Команды для disk inspection

```bash
# 1. Список всех block devices (дерево)
lsblk

# 2. Детальная информация о partitions
sudo fdisk -l

# 3. Только диски (без partitions)
lsblk -d -o NAME,SIZE,MODEL,SERIAL

# 4. Детальная информация о конкретном диске
sudo fdisk -l /dev/sda

# 5. Partition table type (MBR или GPT)
sudo parted /dev/sda print | grep "Partition Table"

# 6. Информация о filesystems
df -h

# 7. Все block devices с UUID
lsblk -o NAME,SIZE,FSTYPE,UUID,MOUNTPOINT
```

---

#### Пример вывода `lsblk`

```
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0   2TB  0 disk
├─sda1   8:1    0   512M 0 part /boot/efi
├─sda2   8:2    0   100G 0 part /
├─sda3   8:3    0    16G 0 part [SWAP]
└─sda4   8:4    0   1.8T 0 part /home

sdb      8:16   0   500G 0 disk
└─sdb1   8:17   0   500G 0 part /var/lib/mysql

sdc      8:32   0   500G 0 disk
(пусто — новый диск)
```

**Что видим:**
- **sda** — 2TB диск с 4 partitions (OS + swap + home)
- **sdb** — 500GB диск с базами данных (FAILING!)
- **sdc** — 500GB новый диск (пустой, для миграции)

---

### 🤔 Проверка понимания

**Вопрос 1:** В чём разница между `/dev/sda` и `/dev/sda1`?

<details>
<summary>💡 Думай 30 секунд</summary>

**Ответ:**
- **`/dev/sda`** — это **весь физический диск** (block device)
- **`/dev/sda1`** — это **первая partition** на этом диске

**Аналогия:**
- `/dev/sda` = целый склад (весь диск)
- `/dev/sda1` = секция #1 в складе (partition #1)

**Важно:**
Нельзя монтировать весь диск (`/dev/sda`) если на нём есть partitions. Монтируешь конкретную partition (`/dev/sda1`).

**Kristjan:** *"Partition — это logical division. Физически это один диск, логически — несколько независимых разделов."*

</details>

---

**Вопрос 2:** Зачем нужны partitions? Почему не использовать весь диск как один раздел?

<details>
<summary>💡 Ответ</summary>

**Зачем partitions:**

1. **Безопасность:** Разделение OS и данных
   - Если `/home` заполнится на 100% → OS продолжит работать (на отдельном `/`)

2. **Разные filesystems:**
   - `/` на ext4 (стабильный)
   - `/data` на xfs (high performance)

3. **Backup/Recovery:**
   - Можно бэкапить только `/home`, не трогая OS

4. **Mount options:**
   - `/tmp` с `noexec` (запрет выполнения)
   - `/home` с `nodev` (запрет device files)

5. **Dual boot:**
   - Linux + Windows на одном диске

**Когда НЕ нужны partitions:**
- Когда используешь LVM (создаёт свою абстракцию)
- Virtual machines (диски уже виртуальные)

**Liisa:** *"В production мы ВСЕГДА делаем отдельные partitions для /, /var, /tmp, /home. Это best practice."*

</details>

---

**Вопрос 3:** Что такое block device?

<details>
<summary>💡 Ответ</summary>

**Block device** — это устройство которое читает/пишет данные **блоками** (chunks), а не по одному байту.

**Характеристики:**
- Данные читаются/пишутся блоками (обычно 512 bytes, 4KB, или 8KB)
- Поддерживает **random access** (можно читать любой блок в любой момент)
- Имеет фиксированный размер

**Примеры block devices:**
- HDD (жёсткие диски)
- SSD (твердотельные диски)
- USB flash drives
- CD/DVD drives

**Противоположность: Character device**
- Последовательный доступ (serial)
- Примеры: `/dev/tty` (terminal), `/dev/null`

**В Linux:**
```bash
# Block devices показываются как 'b' в ls -l
$ ls -l /dev/sda
brw-rw---- 1 root disk 8, 0 Oct 11 10:00 /dev/sda
^
└─ 'b' = block device
```

**Kristjan:** *"Block device = склад с пронумерованными ячейками. Можешь получить содержимое любой ячейки напрямую, зная её номер."*

</details>

---

### ✅ Чеклист Цикл 1

- [ ] Понял что такое block device (устройство для хранения данных)
- [ ] Знаю разницу между disk и partition
- [ ] Понимаю naming convention (`/dev/sdX`, `/dev/nvmeXnY`)
- [ ] Знаю зачем нужны partitions (безопасность, разные fs, backup)
- [ ] Умею инспектировать диски (`lsblk`, `fdisk -l`)
- [ ] Понимаю разницу MBR vs GPT (GPT лучше для новых дисков)

**LILITH:**
*"Disk — это не просто storage. Это foundation всей системы. Без понимания дисков — ты строишь на песке."*

---

## 🔄 ЦИКЛ 2: SMART Monitoring — Предсказание failures (15-20 минут)

### 🎬 Сюжет

**Liisa** (показывает Максу monitoring dashboard):
*"Look at this. `/dev/sdb` — SMART status critical. Reallocated sectors: 247. Spin retry count: 8. Это умирающий диск."*

```
SMART Attributes for /dev/sdb:
ID# ATTRIBUTE_NAME          VALUE  WORST  RAW_VALUE
  5 Reallocated_Sector_Ct   100    100    247        ⚠️ CRITICAL
  7 Seek_Error_Rate         85     60     15842341   ⚠️ WARNING
197 Current_Pending_Sector  100    100    3          ⚠️ WARNING
198 Offline_Uncorrectable   100    100    1          ⚠️ WARNING
```

**Макс:**
*"Что это значит?"*

**Liisa:**
*"Reallocated sectors — это плохие сектора которые диск переместил в резерв. 247 — это много. Каждый новый bad sector — это шаг к полному failure."*

**Kristjan:**
*"SMART (Self-Monitoring, Analysis and Reporting Technology) — это встроенная диагностика диска. Диск сам знает когда он умирает. Наша задача — слушать его."*

---

### 📚 Теория: SMART Monitoring

#### 🏥 Метафора: SMART = Медицинский осмотр диска

Представь диск как **человека**, а SMART как **медицинский осмотр**:

```
🏥 DISK HEALTH CHECK
│
├─ 🌡️ Температура — 35°C (норма: <45°C) ✅
├─ 💓 Spin-up time — 4500ms (норма: <5000ms) ✅
├─ 🩸 Reallocated sectors — 247 (норма: 0) ⚠️ CRITICAL
├─ 🧠 Seek error rate — 15M (норма: <1M) ⚠️ WARNING
└─ ⏱️ Power-on hours — 35,840h (~4 years) ℹ️
```

**Доктор (SMART)** говорит:
- ✅ Температура в норме
- ✅ Spin-up нормальный
- ⚠️ **247 reallocated sectors — ОПАСНО!**
- ⚠️ **High seek errors — диск деградирует**
- ℹ️ Диск работает 4 года — нормальный возраст

**Диагноз:** Диск умирает. Миграция данных СРОЧНО.

---

#### 🎯 Ключевые SMART Attributes

##### Critical Attributes (если растут → диск умирает):

| ID | Attribute | Что значит | Норма | Опасно |
|----|-----------|------------|-------|--------|
| **5** | Reallocated_Sector_Ct | Плохие сектора переназначены | 0 | >50 |
| **197** | Current_Pending_Sector | Ждут проверки (возможно плохие) | 0 | >5 |
| **198** | Offline_Uncorrectable | Непоправимые ошибки | 0 | >0 |
| **187** | Reported_Uncorrect | Ошибки которые не удалось исправить | 0 | >0 |
| **188** | Command_Timeout | Команды которые timeout | 0 | >10 |

##### Warning Attributes (следить):

| ID | Attribute | Что значит | Норма |
|----|-----------|------------|-------|
| **7** | Seek_Error_Rate | Ошибки позиционирования головки | Varies (vendor-specific) |
| **190** | Airflow_Temperature_Cel | Температура | <45°C |
| **194** | Temperature_Celsius | Температура | <45°C |
| **9** | Power_On_Hours | Сколько часов работает | — |

**Kristjan:**
*"Reallocated sectors — это самый важный показатель. Если видишь >50 — готовься к миграции. Если >200 — начинай миграцию СЕЙЧАС."*

---

### 💻 Практика: SMART Monitoring

#### Установка smartmontools

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install smartmontools

# Check service status
sudo systemctl status smartd
```

---

#### Основные команды

```bash
# 1. Quick health check
sudo smartctl -H /dev/sda

# Вывод:
# === START OF READ SMART DATA SECTION ===
# SMART overall-health self-assessment test result: PASSED
# или FAILED ⚠️

# 2. All SMART data
sudo smartctl -a /dev/sda

# 3. Только critical attributes
sudo smartctl -A /dev/sda | grep -E "Reallocated|Pending|Uncorrectable"

# 4. Test запуск (короткий тест, ~2 мин)
sudo smartctl -t short /dev/sda

# 5. Test запуск (длинный тест, ~часы)
sudo smartctl -t long /dev/sda

# 6. Результаты теста
sudo smartctl -l selftest /dev/sda

# 7. Информация о диске
sudo smartctl -i /dev/sda
```

---

#### Пример вывода `smartctl -a /dev/sdb` (failing disk)

```
=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14
Device Model:     ST500DM002-1BD142
Serial Number:    W3T7GKSP
Firmware Version: KC45
User Capacity:    500GB
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database
ATA Version is:   ATA8-ACS
SMART support is: Available
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: FAILED!
Drive failure expected in less than 24 hours. SAVE ALL DATA. ⚠️⚠️⚠️

SMART Attributes Data Structure revision number: 10
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   117   099   006    Pre-fail  135899696
  3 Spin_Up_Time            0x0003   094   093   000    Pre-fail  0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   512
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  247        ⚠️
  7 Seek_Error_Rate         0x000f   085   060   030    Pre-fail  15842341   ⚠️
  9 Power_On_Hours          0x0032   074   074   000    Old_age   35840
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  8          ⚠️
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   487
184 End-to-End_Error        0x0032   100   100   099    Old_age   0
187 Reported_Uncorrect      0x0032   095   095   000    Old_age   5          ⚠️
188 Command_Timeout         0x0032   100   099   000    Old_age   2
189 High_Fly_Writes         0x003a   100   100   000    Old_age   0
190 Airflow_Temperature_Cel 0x0022   062   053   045    Old_age   38 (Min/Max 25/47)
194 Temperature_Celsius     0x0022   038   047   000    Old_age   38 (0 15 0 0 0)
195 Hardware_ECC_Recovered  0x001a   024   011   000    Old_age   135899696
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   3          ⚠️
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   1          ⚠️
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   35836
241 Total_LBAs_Written      0x0000   100   253   000    Old_age   48529472354
242 Total_LBAs_Read         0x0000   100   253   000    Old_age   52486438772
```

**Анализ:**
- ⚠️ **FAILED health check** — диск умирает!
- ⚠️ **247 reallocated sectors** — критично!
- ⚠️ **8 spin retry** — механика деградирует
- ⚠️ **3 pending sectors** — ждут проверки
- ℹ️ 35,840 часов работы (~4 года)

**Действия:**
1. ✅ Немедленная миграция данных
2. ✅ Заказать новый диск (уже есть `/dev/sdc`)
3. ✅ Backup (если ещё не сделан)
4. ✅ После миграции — утилизировать `/dev/sdb`

---

### 🤔 Проверка понимания

**Вопрос 1:** Что означает Reallocated_Sector_Ct = 247?

<details>
<summary>💡 Ответ</summary>

**Reallocated Sector Count** — количество **bad sectors** (плохих секторов) которые диск переназначил в резервную область.

**Как это работает:**
1. Диск пытается записать данные в сектор
2. Сектор не читается/не пишется (hardware failure)
3. Диск помечает сектор как "bad"
4. Диск переносит данные в **spare area** (резервная область)
5. Счётчик Reallocated_Sector_Ct увеличивается

**247 reallocated sectors = КРИТИЧНО!**
- Норма: 0 (zero bad sectors)
- Допустимо: 1-10 (могут появиться за годы)
- Опасно: >50 (диск деградирует)
- Критично: >200 (диск умирает, миграция СРОЧНО!)

**Почему опасно:**
- Резервная область **ограничена** (обычно ~2-5% диска)
- Когда резервная область кончается → новые bad sectors = **permanent data loss**
- Рост bad sectors часто **экспоненциальный** (10 → 50 → 200 за недели)

**Liisa:** *"Если видишь 200+ reallocated sectors — у тебя часы, не дни. Миграция данных — первый приоритет."*

</details>

---

**Вопрос 2:** Можно ли починить диск с bad sectors?

<details>
<summary>💡 Ответ</summary>

**Короткий ответ: НЕТ.**

Bad sectors — это **hardware failure**. Физическое повреждение магнитной поверхности (HDD) или flash ячеек (SSD).

**Что МОЖНО сделать:**
1. **Reallocation (диск делает сам):**
   - Диск переназначает bad sector в spare area
   - Данные сохраняются (если spare area не кончилась)

2. **Secure erase + reformat:**
   - Иногда помогает "освежить" диск
   - ⚠️ Удаляет ВСЕ данные!
   - Не убирает hardware damage, только "маскирует"

3. **Bad block list:**
   - Можно пометить bad sectors вручную (badblocks utility)
   - Filesystem будет их избегать
   - НЕ решает проблему, только работает вокруг неё

**Что НЕ МОЖНО:**
- ❌ "Починить" физический damage
- ❌ Вернуть reallocated sectors в working area
- ❌ Остановить дальнейшую деградацию

**Best practice:**
```
Bad sectors появились → backup данных → миграция → утилизация диска
```

**Kristjan:** *"Диск с bad sectors — это time bomb. Может работать месяцы, может умереть завтра. Не рискуй production данными."*

</details>

---

**Вопрос 3:** Как часто нужно проверять SMART?

<details>
<summary>💡 Best Practices</summary>

**Автоматический мониторинг (РЕКОМЕНДУЕТСЯ):**

```bash
# smartd daemon (часть smartmontools)
# Проверяет диски каждые 30 минут
# Отправляет email при проблемах

# Конфигурация: /etc/smartd.conf
DEVICESCAN -a -o on -S on -s (S/../.././02|L/../../6/03) -m admin@example.com

# Что это значит:
# -a: мониторить все SMART attributes
# -o on: enable automatic offline tests
# -S on: enable attribute autosave
# -s (S/../.././02): short test каждый день в 02:00
# -s (L/../../6/03): long test каждую субботу в 03:00
# -m: email для алертов
```

**Manual checks:**
- ✅ **Раз в неделю:** `sudo smartctl -H /dev/sdX` (quick health)
- ✅ **Раз в месяц:** `sudo smartctl -A /dev/sdX` (attributes review)
- ✅ **Раз в квартал:** `sudo smartctl -t long /dev/sdX` (full test)

**Production мониторинг:**
- ✅ Prometheus + smartctl_exporter
- ✅ Nagios/Zabbix с SMART checks
- ✅ Cloud monitoring (AWS CloudWatch Disk Health)

**Liisa:** *"В production мы проверяем SMART каждые 30 минут. Алерт приходит в Slack мгновенно. Downtime недопустим."*

</details>

---

### ✅ Чеклист Цикл 2

- [ ] Понимаю что такое SMART (Self-Monitoring диска)
- [ ] Знаю critical attributes (Reallocated, Pending, Uncorrectable)
- [ ] Умею проверить health (`smartctl -H /dev/sdX`)
- [ ] Умею прочитать SMART данные (`smartctl -a /dev/sdX`)
- [ ] Понимаю что bad sectors нельзя "починить"
- [ ] Знаю когда нужна миграция (>50 reallocated sectors)

**LILITH:**
*"SMART — это early warning system. Диск говорит 'я умираю' за недели до смерти. Твоя задача — слушать."*

---

## 🔄 ЦИКЛ 3: LVM — Physical Volumes (20-25 минут)

### 🎬 Сюжет

**Kristjan** (подводит Макса к серверу):
*"У нас есть новый диск `/dev/sdc` — 500GB SSD. Нужно настроить его правильно. В production мы НЕ используем прямое partitioning. Мы используем LVM."*

**Макс:**
*"LVM? Что это?"*

**Kristjan:**
*"Logical Volume Manager. Абстракция над физическими дисками. Представь: partitions — это fixed-size коробки. LVM — это warehouse с flexible стеллажами. Можешь resize, перемещать, snapshot — всё налету."*

**Liisa:**
*"В e-Estonia все production серверы используют LVM. Flexible storage — это must-have."*

---

### 📚 Теория: LVM — Архитектура

#### 🏭 Метафора: LVM = Flexible Warehouse

Представь склад (storage):

**Без LVM (традиционные partitions):**
```
🏢 TRADITIONAL WAREHOUSE (Fixed Layout)
│
├─ 📦 Секция A — 100GB (fixed size, нельзя расширить)
├─ 📦 Секция B — 200GB (fixed size)
└─ 📦 Секция C — 200GB (fixed size)
    └─ 50GB используется, 150GB пусто
        ❌ Нельзя передать unused space в Секцию A!
```

**С LVM:**
```
🏭 LVM WAREHOUSE (Flexible Layout)
│
├─ 📦 Volume "databases" — 150GB (можно resize!)
├─ 📦 Volume "logs" — 100GB (можно resize!)
└─ 📦 Volume "backups" — 50GB (можно resize!)
    └─ Unused space: 200GB (можно allocate later!)
    ✅ Можно добавить новый volume
    ✅ Можно расширить существующий
    ✅ Можно переместить между дисками
```

**Директор склада (LVM)** управляет пространством гибко:
- Создаёт новые секции (logical volumes)
- Расширяет секции (lvextend)
- Перемещает между дисками (pvmove)
- Создаёт snapshot (бэкап состояния)

---

#### 🎯 LVM Architecture: 3 уровня

LVM использует **3-level architecture**:

```
┌──────────────────────────────────────────┐
│  LOGICAL VOLUMES (LV)                    │  ← ЧТО видит пользователь
│  /dev/vg_data/lv_databases   (150GB)     │
│  /dev/vg_data/lv_logs        (100GB)     │
│  /dev/vg_data/lv_backups      (50GB)     │
└──────────────────────────────────────────┘
              ↑
┌──────────────────────────────────────────┐
│  VOLUME GROUPS (VG)                      │  ← Пул storage
│  vg_data  (300GB used / 500GB total)     │
└──────────────────────────────────────────┘
              ↑
┌──────────────────────────────────────────┐
│  PHYSICAL VOLUMES (PV)                   │  ← Физические диски
│  /dev/sdc1  (500GB)                      │
└──────────────────────────────────────────┘
```

**3 уровня:**

1. **Physical Volume (PV)** — физический диск или partition
   - Например: `/dev/sdc1`, `/dev/sdd1`
   - Это "raw materials" для LVM

2. **Volume Group (VG)** — пул из Physical Volumes
   - Например: `vg_data` (объединяет `/dev/sdc1` + `/dev/sdd1`)
   - Это "warehouse" — общий пул storage

3. **Logical Volume (LV)** — виртуальный раздел
   - Например: `lv_databases`, `lv_logs`
   - Это "shelves in warehouse" — то что монтируешь и используешь

**Kristjan:**
*"PV = физический диск. VG = группа дисков. LV = виртуальный раздел. PV → VG → LV. Запомни эту цепочку."*

---

### 💻 Практика: Создание Physical Volume

#### Шаг 1: Подготовка диска

```bash
# Проверить что диск пустой и доступен
lsblk | grep sdc

# Вывод:
# sdc      8:32   0  500G  0 disk

# Создать partition на диске (опционально, можно использовать весь диск)
sudo fdisk /dev/sdc

# В fdisk:
# n  → new partition
# p  → primary
# 1  → partition number 1
# Enter → default first sector
# Enter → default last sector (use entire disk)
# t  → change partition type
# 8e → Linux LVM (или 31 для GPT)
# w  → write changes and exit

# Проверить
lsblk | grep sdc
# sdc      8:32   0  500G  0 disk
# └─sdc1   8:33   0  500G  0 part  ← новая partition
```

**⚠️ ОСТОРОЖНО:**
`fdisk /dev/sdc` — это destructive operation! Убедись что выбрал правильный диск!

---

#### Шаг 2: Создание Physical Volume

```bash
# Создать PV из partition
sudo pvcreate /dev/sdc1

# Вывод:
#   Physical volume "/dev/sdc1" successfully created.

# Проверить PV
sudo pvs

# Вывод:
#   PV         VG      Fmt  Attr PSize   PFree
#   /dev/sdc1          lvm2 ---  500.00g 500.00g

# Детальная информация
sudo pvdisplay /dev/sdc1

# Вывод:
#   "/dev/sdc1" is a new physical volume of "500.00 GiB"
#   --- NEW Physical volume ---
#   PV Name               /dev/sdc1
#   VG Name
#   PV Size               500.00 GiB
#   Allocatable           NO
#   PE Size               0
#   Total PE              0
#   Free PE               0
#   Allocated PE          0
#   PV UUID               xK3rGf-aBcD-eFgH-iJkL-mNoP-qRsT-uVwXyZ
```

**Что произошло:**
- LVM пометил `/dev/sdc1` как Physical Volume
- Записал metadata на диск
- Диск готов к добавлению в Volume Group

---

#### Альтернатива: PV из целого диска (без partition)

```bash
# Можно использовать весь диск без partitioning
sudo pvcreate /dev/sdc

# Это работает, но best practice — создать partition сначала
# Зачем? Partition table хранит информацию что это LVM disk
```

**Best practice:**
Создавай partition (`/dev/sdc1`), потом PV. Это делает структуру понятнее.

---

### 🤔 Проверка понимания

**Вопрос 1:** В чём разница между Physical Volume и partition?

<details>
<summary>💡 Ответ</summary>

**Partition:**
- Логическое разделение **одного** физического диска
- Создаётся через `fdisk` или `parted`
- Пример: `/dev/sda1`, `/dev/sda2`
- **Фиксированный размер** (нельзя resize без риска data loss)

**Physical Volume (PV):**
- **LVM метка** на диске или partition
- Создаётся через `pvcreate`
- Пример: PV на `/dev/sdc1`
- Может быть **часть Volume Group** (VG)
- **Flexible** — можно добавлять в VG, удалять, перемещать данные

**Связь:**
```
Physical Disk (/dev/sdc)
  ↓
Partition (/dev/sdc1)      ← создаётся fdisk
  ↓
Physical Volume (/dev/sdc1) ← создаётся pvcreate (LVM label)
  ↓
Volume Group (vg_data)     ← добавляется в VG
  ↓
Logical Volume (lv_db)     ← создаётся виртуальный раздел
```

**Kristjan:** *"Partition — это physical division. PV — это LVM abstraction. PV использует partition (или весь диск), но добавляет LVM magic."*

</details>

---

**Вопрос 2:** Можно ли создать PV из целого диска без partitioning?

<details>
<summary>💡 Ответ</summary>

**Да, можно:**

```bash
sudo pvcreate /dev/sdc
```

**Преимущества:**
- ✅ Быстрее (skip partitioning step)
- ✅ Используется весь диск (no partition table overhead)

**Недостатки:**
- ❌ Нет partition table → tools могут не распознать что это LVM disk
- ❌ Некоторые backup/disaster recovery tools не увидят структуру
- ❌ Менее понятно при инспекции (`lsblk` не покажет partition type)

**Best practice (production):**
```bash
# 1. Создать partition
sudo fdisk /dev/sdc
# (создать partition type 8e - Linux LVM)

# 2. Создать PV на partition
sudo pvcreate /dev/sdc1
```

**Зачем:**
- Partition table хранит информацию о типе (LVM)
- Tools видят структуру
- Disaster recovery проще

**Liisa:** *"В production мы ВСЕГДА создаём partition сначала. Это documentation — любой admin увидит что это LVM disk."*

</details>

---

### ✅ Чеклист Цикл 3

- [ ] Понимаю LVM архитектуру (PV → VG → LV)
- [ ] Знаю что такое Physical Volume (PV = диск/partition с LVM label)
- [ ] Умею создать partition через `fdisk`
- [ ] Умею создать PV (`pvcreate /dev/sdX1`)
- [ ] Умею проверить PV (`pvs`, `pvdisplay`)
- [ ] Понимаю зачем нужна LVM (flexibility vs fixed partitions)

**LILITH:**
*"Physical Volume — это foundation LVM. Без PV нет VG. Без VG нет LV. Цепочка критична."*

---

## 🔄 ЦИКЛ 4: LVM — Volume Groups & Logical Volumes (25-30 минут)

### 🎬 Сюжет

**Kristjan:**
*"Теперь у нас есть Physical Volume `/dev/sdc1` (500GB). Следующий шаг — создать Volume Group. VG — это пул storage. Можешь добавлять несколько PV в один VG."*

**Макс:**
*"Как объединить несколько дисков?"*

**Kristjan:**
*"Именно! Представь: у тебя три диска по 500GB. Создаёшь PV на каждом, добавляешь в один VG — получаешь 1.5TB пул. Потом создаёшь Logical Volumes из этого пула. Flexibility magic."*

**Liisa:**
*"И самое крутое — можешь resize LV налёт. Базе данных нужно больше места? `lvextend` и done. Без перезагрузки."*

---

### 📚 Теория: Volume Groups & Logical Volumes

#### 🏢 Метафора: VG = Warehouse, LV = Shelves

**Volume Group (VG):**
```
🏭 WAREHOUSE "vg_data" (500GB total)
│
└─ Built from:
   └─ 📦 Physical Volume /dev/sdc1 (500GB)
```

**Logical Volumes (LV) внутри VG:**
```
🏭 WAREHOUSE "vg_data"
│
├─ 🗄️ Shelf "lv_databases" — 200GB (used: 150GB)
├─ 🗄️ Shelf "lv_logs"      — 100GB (used: 80GB)
├─ 🗄️ Shelf "lv_backups"   —  50GB (used: 20GB)
└─ 📭 Unused space         — 150GB (can allocate later!)
```

**Преимущества:**
- ✅ Flexible размер (lvextend/lvreduce)
- ✅ Можно добавить новые LV без перезагрузки
- ✅ Snapshot поддержка (backup без остановки)
- ✅ Thin provisioning (allocate on demand)

---

### 💻 Практика: Создание VG и LV

#### Шаг 1: Создание Volume Group

```bash
# Создать VG с именем "vg_data" из PV /dev/sdc1
sudo vgcreate vg_data /dev/sdc1

# Вывод:
#   Volume group "vg_data" successfully created

# Проверить VG
sudo vgs

# Вывод:
#   VG      #PV #LV #SN Attr   VSize   VFree
#   vg_data   1   0   0 wz--n- 500.00g 500.00g

# Детальная информация
sudo vgdisplay vg_data

# Вывод:
#   --- Volume group ---
#   VG Name               vg_data
#   System ID
#   Format                lvm2
#   Metadata Areas        1
#   Metadata Sequence No  1
#   VG Access             read/write
#   VG Status             resizable
#   MAX LV                0
#   Cur LV                0
#   Open LV               0
#   Max PV                0
#   Cur PV                1
#   Act PV                1
#   VG Size               500.00 GiB
#   PE Size               4.00 MiB
#   Total PE              127999
#   Alloc PE / Size       0 / 0
#   Free  PE / Size       127999 / 500.00 GiB
#   VG UUID               AbCdEf-GhIj-KlMn-OpQr-StUv-WxYz-123456
```

**Что произошло:**
- Создан Volume Group "vg_data"
- `/dev/sdc1` добавлен в этот VG
- VG Size = 500GB (весь PV)
- Free space = 500GB (пока нет LV)

---

#### Шаг 2: Создание Logical Volumes

```bash
# Создать LV для databases (200GB)
sudo lvcreate -L 200G -n lv_databases vg_data

# Вывод:
#   Logical volume "lv_databases" created.

# Создать LV для logs (100GB)
sudo lvcreate -L 100G -n lv_logs vg_data

# Создать LV для backups (50GB)
sudo lvcreate -L 50G -n lv_backups vg_data

# Проверить LV
sudo lvs

# Вывод:
#   LV           VG      Attr       LSize   Pool Origin Data%
#   lv_backups   vg_data -wi-a-----  50.00g
#   lv_databases vg_data -wi-a----- 200.00g
#   lv_logs      vg_data -wi-a----- 100.00g

# Детальная информация
sudo lvdisplay /dev/vg_data/lv_databases

# Вывод:
#   --- Logical volume ---
#   LV Path                /dev/vg_data/lv_databases
#   LV Name                lv_databases
#   VG Name                vg_data
#   LV UUID                xYzAbC-dEfGh-IjKlM-nOpQr-StUvW-xYzAb-CdEfGh
#   LV Write Access        read/write
#   LV Creation host, time server01, 2025-10-11 12:00:00 +0000
#   LV Status              available
#   # open                 0
#   LV Size                200.00 GiB
#   Current LE             51200
#   Segments               1
#   Allocation             inherit
#   Read ahead sectors     auto
#   Block device           253:0
```

---

#### Шаг 3: Проверка структуры

```bash
# Полная структура
lsblk

# Вывод:
# NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
# sdc                         8:32   0  500G  0 disk
# └─sdc1                      8:33   0  500G  0 part
#   ├─vg_data-lv_databases  253:0    0  200G  0 lvm
#   ├─vg_data-lv_logs       253:1    0  100G  0 lvm
#   └─vg_data-lv_backups    253:2    0   50G  0 lvm

# VG summary
sudo vgs

# Вывод:
#   VG      #PV #LV #SN Attr   VSize   VFree
#   vg_data   1   3   0 wz--n- 500.00g 150.00g
#                                       ^^^^^^^ unused space!
```

**Что имеем:**
- PV: `/dev/sdc1` (500GB)
- VG: `vg_data` (500GB total, 150GB free)
- LV:
  - `lv_databases` (200GB)
  - `lv_logs` (100GB)
  - `lv_backups` (50GB)
- **150GB unused** — можно allocate позже!

---

### 🎨 LVM Operations: Resize, Extend, Snapshot

#### 1. Extend Logical Volume (увеличить размер)

```bash
# Базе данных нужно больше места
# Расширить lv_databases на 50GB
sudo lvextend -L +50G /dev/vg_data/lv_databases

# Вывод:
#   Size of logical volume vg_data/lv_databases changed from 200.00 GiB to 250.00 GiB
#   Logical volume vg_data/lv_databases successfully resized.

# Расширить filesystem (КРИТИЧНО!)
# Без этого OS не увидит новое пространство
sudo resize2fs /dev/vg_data/lv_databases

# Для xfs:
# sudo xfs_growfs /mnt/databases

# Проверить
df -h | grep databases
```

**Kristjan:**
*"Два шага: 1) lvextend для LV, 2) resize2fs для filesystem. Забыл второй шаг — LV больше, но filesystem не знает."*

---

#### 2. Reduce Logical Volume (уменьшить размер)

```bash
# ⚠️ ОПАСНО! Может потерять данные!

# 1. Unmount filesystem
sudo umount /mnt/logs

# 2. Check filesystem
sudo e2fsck -f /dev/vg_data/lv_logs

# 3. Resize filesystem (сначала filesystem!)
sudo resize2fs /dev/vg_data/lv_logs 80G

# 4. Reduce LV
sudo lvreduce -L 80G /dev/vg_data/lv_logs

# 5. Remount
sudo mount /dev/vg_data/lv_logs /mnt/logs
```

**⚠️ ОСТОРОЖНО:**
`lvreduce` может уничтожить данные если сделать неправильно!
Всегда: backup → unmount → resize2fs → lvreduce

---

#### 3. Snapshot (моментальный бэкап)

```bash
# Создать snapshot lv_databases перед update
sudo lvcreate -L 10G -s -n lv_databases_snap /dev/vg_data/lv_databases

# -L 10G: размер snapshot (для delta changes)
# -s: snapshot flag
# -n: имя snapshot

# Проверить
sudo lvs

# Вывод:
#   LV                  VG      Attr       LSize   Origin       Data%
#   lv_databases        vg_data owi-aos--- 250.00g
#   lv_databases_snap   vg_data swi-a-s---  10.00g lv_databases 0.00

# Использование:
# 1. Mount snapshot (read-only)
sudo mount -o ro /dev/vg_data/lv_databases_snap /mnt/snapshot

# 2. Backup snapshot
sudo rsync -av /mnt/snapshot/ /backup/databases/

# 3. Remove snapshot после backup
sudo lvremove /dev/vg_data/lv_databases_snap
```

**Liisa:**
*"Snapshot — это magic для backup. Создаёшь snapshot, бэкапишь snapshot (не live volume), удаляешь snapshot. Zero downtime."*

---

### 🤔 Проверка понимания

**Вопрос 1:** В чём разница между Volume Group и Logical Volume?

<details>
<summary>💡 Ответ</summary>

**Volume Group (VG):**
- **Пул storage** из Physical Volumes
- Комбинирует несколько дисков в один пул
- Пример: `vg_data` (500GB из `/dev/sdc1`)
- Аналогия: **Warehouse** (склад)

**Logical Volume (LV):**
- **Виртуальный раздел** внутри VG
- Аналог partition, но flexible
- Пример: `lv_databases` (200GB внутри `vg_data`)
- Аналогия: **Shelf** (стеллаж внутри склада)

**Связь:**
```
PV (/dev/sdc1)   →   VG (vg_data)   →   LV (lv_databases)
Физический диск  →   Пул storage    →   Виртуальный раздел
```

**Что монтируешь:**
- ❌ Не монтируешь PV
- ❌ Не монтируешь VG
- ✅ **Монтируешь LV** (как обычный partition)

```bash
sudo mount /dev/vg_data/lv_databases /mnt/databases
```

**Kristjan:** *"VG — это container. LV — это content. VG управляет пулом, LV — это что ты используешь."*

</details>

---

**Вопрос 2:** Можно ли добавить новый диск в существующий VG?

<details>
<summary>💡 Да, это одна из главных фишек LVM!</summary>

**Сценарий:**
VG полон, нужно больше места.

**Решение:**
```bash
# 1. Добавить новый диск (например /dev/sdd)
# 2. Создать PV
sudo pvcreate /dev/sdd1

# 3. Добавить PV в существующий VG
sudo vgextend vg_data /dev/sdd1

# Вывод:
#   Volume group "vg_data" successfully extended

# 4. Проверить
sudo vgs

# Вывод:
#   VG      #PV #LV #SN Attr   VSize VFree
#   vg_data   2   3   0 wz--n- 1.0T  500.00g
#             ^                ^^^^^  ^^^^^^
#          2 PV now!         1TB!   500GB free!

# 5. Расширить LV (если нужно)
sudo lvextend -L +200G /dev/vg_data/lv_databases
sudo resize2fs /dev/vg_data/lv_databases
```

**Преимущества:**
- ✅ Без перезагрузки
- ✅ Без unmount существующих LV
- ✅ Без потери данных
- ✅ Online expansion

**Это невозможно с традиционными partitions!**

**Liisa:** *"В production серверах мы добавляем диски в VG налёт. Нужно больше места для databases? 10 минут — новый диск в VG, lvextend, done."*

</details>

---

**Вопрос 3:** Зачем два шага (lvextend + resize2fs)?

<details>
<summary>💡 Ответ</summary>

**Два уровня абстракции:**

1. **LVM Level (lvextend):**
   - Расширяет **Logical Volume** (block device)
   - LVM говорит kernel: "теперь `/dev/vg_data/lv_databases` = 250GB, не 200GB"

2. **Filesystem Level (resize2fs):**
   - Расширяет **filesystem** (ext4, xfs, etc.)
   - Filesystem говорит kernel: "теперь я использую все 250GB, не только первые 200GB"

**Без resize2fs:**
```bash
sudo lvextend -L +50G /dev/vg_data/lv_databases

df -h | grep databases
# Вывод: 200GB (filesystem не знает о новых 50GB!)

sudo resize2fs /dev/vg_data/lv_databases

df -h | grep databases
# Вывод: 250GB ✅
```

**Аналогия:**
- `lvextend` = расширить склад (добавить новый этаж)
- `resize2fs` = сказать менеджеру "используй новый этаж!"

**Для XFS:**
```bash
sudo xfs_growfs /mnt/databases  # XFS использует mountpoint, не device
```

**Kristjan:** *"LVM и filesystem — это разные layers. Оба должны знать о resize. lvextend для LVM, resize2fs для filesystem."*

</details>

---

### ✅ Чеклист Цикл 4

- [ ] Понимаю что такое Volume Group (пул из PV)
- [ ] Понимаю что такое Logical Volume (виртуальный раздел)
- [ ] Умею создать VG (`vgcreate vg_name /dev/sdX1`)
- [ ] Умею создать LV (`lvcreate -L 100G -n lv_name vg_name`)
- [ ] Умею расширить LV (`lvextend` + `resize2fs`)
- [ ] Понимаю snapshot концепт (моментальный бэкап)

**LILITH:**
*"LVM — это flexibility. Traditional partitions — это concrete walls. LVM — это movable walls. Production требует flexibility."*

---

## 🔄 ЦИКЛ 5: Filesystems & /etc/fstab (20-25 минут)

### 🎬 Сюжет

**Kristjan:**
*"У нас есть Logical Volumes. Но OS не может использовать raw LV. Нужен filesystem — ext4, xfs, btrfs. Filesystem — это структура для хранения файлов и директорий."*

**Макс:**
*"Какой выбрать?"*

**Kristjan:**
*"Зависит от use case. ext4 — стабильный, universal. xfs — high performance для больших файлов. btrfs — modern с snapshot support. В e-Estonia мы используем xfs для databases, ext4 для всего остального."*

**Liisa:**
*"И не забудь `/etc/fstab` — это автоматическое монтирование при загрузке. Без fstab — LV не смонтируется после reboot."*

---

### 📚 Теория: Filesystems

#### 📚 Метафора: Filesystem = Library Catalog System

Представь **библиотеку** (disk):

**Без filesystem:**
```
📦 Raw Storage (LV)
└─ Binary data: 01001010110...
   ❌ Где начинается файл?
   ❌ Где заканчивается?
   ❌ Как найти файл?
```

**С filesystem:**
```
📚 LIBRARY (ext4 filesystem)
│
├─ 📖 Catalog (metadata)
│  ├─ Book "database.sql" → Shelf A, Row 5
│  ├─ Book "logs.txt" → Shelf B, Row 2
│  └─ Book "backup.tar.gz" → Shelf C, Row 10
│
└─ 📚 Shelves (data blocks)
   ├─ Shelf A: [database.sql content]
   ├─ Shelf B: [logs.txt content]
   └─ Shelf C: [backup.tar.gz content]
```

**Filesystem:**
- **Организует данные** в файлы и директории
- **Metadata** (имя файла, размер, permissions, timestamps)
- **Allocation** (какие blocks использует файл)
- **Free space tracking** (какие blocks свободны)

---

#### 🎯 Popular Filesystems

| Filesystem | Use Case | Pros | Cons |
|------------|----------|------|------|
| **ext4** | Universal, stable | ✅ Stable<br>✅ Well-tested<br>✅ Good performance | ❌ No snapshots<br>❌ Max 16TB file |
| **xfs** | Large files, databases | ✅ High performance<br>✅ Handles large files well<br>✅ Online resize (grow only) | ❌ Cannot shrink<br>❌ Complex to recover |
| **btrfs** | Modern, snapshots | ✅ Built-in snapshots<br>✅ Compression<br>✅ Online defrag | ⚠️ Less mature<br>⚠️ RAID5/6 unstable |
| **f2fs** | SSD-optimized | ✅ Optimized for flash | ❌ Not widely used |

**Kristjan:**
*"ext4 — это Toyota. Надёжный, универсальный. xfs — это Ferrari. Быстрый, для специфических задач. btrfs — это Tesla. Modern, но ещё не fully mature."*

---

### 💻 Практика: Создание Filesystems

#### Создание ext4 filesystem

```bash
# Создать ext4 на lv_logs
sudo mkfs.ext4 /dev/vg_data/lv_logs

# Вывод:
# mke2fs 1.46.5 (30-Dec-2021)
# Creating filesystem with 26214400 4k blocks and 6553600 inodes
# Filesystem UUID: a1b2c3d4-e5f6-4a5b-9c8d-7e6f5a4b3c2d
# Superblock backups stored on blocks:
#         32768, 98304, 163840, 229376, 294912
#
# Allocating group tables: done
# Writing inode tables: done
# Creating journal (131072 blocks): done
# Writing superblocks and filesystem accounting information: done

# С label (полезно для fstab)
sudo mkfs.ext4 -L LOGS /dev/vg_data/lv_logs
```

---

#### Создание xfs filesystem

```bash
# Создать xfs на lv_databases
sudo mkfs.xfs /dev/vg_data/lv_databases

# Вывод:
# meta-data=/dev/vg_data/lv_databases isize=512    agcount=4, agsize=13107200 blks
#          =                       sectsz=512   attr=2, projid32bit=1
#          =                       crc=1        finobt=1, sparse=1, rmapbt=0
#          =                       reflink=1
# data     =                       bsize=4096   blocks=52428800, imaxpct=25
#          =                       sunit=0      swidth=0 blks
# naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
# log      =internal log           bsize=4096   blocks=25600, version=2
#          =                       sectsz=512   sunit=0 blks, lazy-count=1
# realtime =none                   extsz=4096   blocks=0, rtextents=0

# С label
sudo mkfs.xfs -L DATABASES /dev/vg_data/lv_databases
```

---

### 📋 Mounting & /etc/fstab

#### Manual mounting

```bash
# Создать mount point
sudo mkdir -p /mnt/databases
sudo mkdir -p /mnt/logs

# Mount
sudo mount /dev/vg_data/lv_databases /mnt/databases
sudo mount /dev/vg_data/lv_logs /mnt/logs

# Проверить
df -h | grep -E "databases|logs"

# Вывод:
# /dev/mapper/vg_data-lv_databases  197G   61M  187G   1% /mnt/databases
# /dev/mapper/vg_data-lv_logs        99G   24M   94G   1% /mnt/logs

# Unmount
sudo umount /mnt/databases
sudo umount /mnt/logs
```

---

#### Автоматическое mounting через /etc/fstab

**`/etc/fstab`** — это конфигурация автоматического монтирования при загрузке.

**Формат:**
```
<device>  <mount point>  <filesystem type>  <options>  <dump>  <pass>
```

**Пример `/etc/fstab`:**

```bash
# Backup original
sudo cp /etc/fstab /etc/fstab.backup

# Edit
sudo nano /etc/fstab

# Добавить:
/dev/vg_data/lv_databases  /mnt/databases  xfs   defaults,noatime  0  2
/dev/vg_data/lv_logs       /mnt/logs       ext4  defaults,noatime  0  2

# Или через UUID (recommended!):
UUID=a1b2c3d4-e5f6-4a5b-9c8d-7e6f5a4b3c2d  /mnt/databases  xfs   defaults,noatime  0  2
UUID=f1e2d3c4-b5a6-4f5e-9d8c-7e6f5a4b3c2d  /mnt/logs       ext4  defaults,noatime  0  2
```

**Параметры:**
- **defaults:** rw, suid, dev, exec, auto, nouser, async
- **noatime:** не обновлять access time (performance boost!)
- **0:** dump (не использовать backup)
- **2:** fsck pass (проверять после root filesystem)

**Найти UUID:**
```bash
sudo blkid /dev/vg_data/lv_databases
# /dev/vg_data/lv_databases: UUID="a1b2c3d4-e5f6-4a5b-9c8d-7e6f5a4b3c2d" TYPE="xfs"
```

---

#### Тестирование fstab

```bash
# Проверить синтаксис fstab
sudo mount -a

# Если ошибка — исправь fstab ДО reboot!
# Неправильный fstab может сделать систему unbootable!

# Проверить что смонтировалось
df -h | grep -E "databases|logs"

# Reboot test (опционально, если уверен)
sudo reboot
```

**⚠️ CRITICAL:**
Неправильный `/etc/fstab` может сделать систему **unbootable**!
Всегда тестируй `sudo mount -a` перед reboot!

---

### 🤔 Проверка понимания

**Вопрос 1:** Зачем использовать UUID вместо `/dev/vg_data/lv_name` в fstab?

<details>
<summary>💡 Ответ</summary>

**UUID (Universally Unique Identifier):**
- Уникальный для каждого filesystem
- **НЕ меняется** при переименовании LV или VG
- **НЕ зависит** от порядка обнаружения дисков

**Device path (`/dev/vg_data/lv_name`):**
- Может измениться при переименовании
- Зависит от LVM configuration

**Проблема с device path:**
```bash
# fstab:
/dev/vg_data/lv_databases  /mnt/databases  xfs  defaults  0  2

# Потом ты переименовал VG:
sudo vgrename vg_data vg_production

# После reboot:
# ❌ /dev/vg_data/lv_databases не существует!
# ❌ Filesystem не монтируется!
# ❌ Applications fail!
```

**С UUID:**
```bash
# fstab:
UUID=a1b2c3d4-e5f6-4a5b-9c8d-7e6f5a4b3c2d  /mnt/databases  xfs  defaults  0  2

# Переименовал VG:
sudo vgrename vg_data vg_production

# После reboot:
# ✅ UUID не изменился!
# ✅ Filesystem монтируется!
```

**Kristjan:** *"UUID — это fingerprint filesystem. Device path может меняться, UUID — никогда. В production всегда используй UUID в fstab."*

</details>

---

**Вопрос 2:** Что делает опция `noatime` в fstab?

<details>
<summary>💡 Performance Optimization</summary>

**`noatime`** — не обновлять **access time** (atime) при чтении файла.

**Без noatime (default):**
```bash
# Каждый раз когда ты читаешь файл:
cat /mnt/databases/data.sql

# Kernel обновляет atime metadata:
# - Read file content (I/O operation)
# - Write updated atime (ADDITIONAL I/O operation!)
```

**С noatime:**
```bash
# Читаешь файл:
cat /mnt/databases/data.sql

# Kernel НЕ обновляет atime:
# - Read file content (I/O operation)
# - No write! (skip atime update)
```

**Преимущества:**
- ✅ **Performance boost** (меньше disk I/O)
- ✅ **Меньше wear** на SSD (меньше writes)
- ✅ Особенно полезно для read-heavy workloads

**Недостатки:**
- ❌ Нельзя узнать когда файл последний раз читался
- ❌ Некоторые backup tools используют atime (редко)

**Production best practice:**
```
/dev/vg_data/lv_databases  /mnt/databases  xfs  defaults,noatime  0  2
```

**Альтернатива: `relatime`** (default в modern Linux):
- Обновляет atime только если файл изменился или atime старее 1 дня
- Компромисс между performance и functionality

**Liisa:** *"В production databases мы ВСЕГДА используем noatime. Каждый I/O operation ценен."*

</details>

---

**Вопрос 3:** Что произойдёт если fstab содержит ошибку?

<details>
<summary>💡 System может не загрузиться!</summary>

**Сценарий:**
```bash
# Неправильный fstab:
/dev/vg_data/lv_nonexistent  /mnt/data  ext4  defaults  0  2
                  ^^^^^^^^^^
                  LV не существует!

# Reboot:
sudo reboot

# System boot process:
# 1. Kernel загружается ✅
# 2. Init (systemd) запускается ✅
# 3. systemd пытается mount filesystems из fstab...
# 4. ❌ Cannot mount /dev/vg_data/lv_nonexistent
# 5. ❌ Boot fails или emergency mode
```

**Emergency mode:**
- Система переходит в recovery shell
- Нужно исправить `/etc/fstab` вручную
- Может понадобиться физический доступ к серверу!

**Best Practices:**

1. **Backup fstab перед изменениями:**
```bash
sudo cp /etc/fstab /etc/fstab.backup.$(date +%Y%m%d)
```

2. **Тестируй ДО reboot:**
```bash
# Unmount all
sudo umount /mnt/databases
sudo umount /mnt/logs

# Test mount -a
sudo mount -a

# Если ошибка — исправь СЕЙЧАС, не после reboot!
```

3. **Используй `nofail` опцию (опционально):**
```bash
# Если mount fails — продолжить boot
/dev/vg_data/lv_databases  /mnt/databases  xfs  defaults,noatime,nofail  0  2
```

**Kristjan:** *"Неправильный fstab — это самая частая причина unbootable systems. Всегда тестируй mount -a перед reboot. ВСЕГДА."*

</details>

---

### ✅ Чеклист Цикл 5

- [ ] Понимаю что такое filesystem (ext4, xfs, btrfs)
- [ ] Умею создать filesystem (`mkfs.ext4`, `mkfs.xfs`)
- [ ] Умею mount/unmount filesystem
- [ ] Понимаю структуру `/etc/fstab`
- [ ] Знаю зачем UUID вместо device path
- [ ] Понимаю что `noatime` повышает performance
- [ ] Знаю как тестировать fstab (`mount -a`)

**LILITH:**
*"Filesystem без fstab — это manual labor при каждой загрузке. fstab — это automation. Но неправильный fstab — это disaster. Test before reboot."*

---

## 🔄 ЦИКЛ 6: Data Migration — Копирование с failing disk (15-20 минут)

### 🎬 Сюжет

**Liisa** (смотрит на SMART dashboard):
*"Макс, диск `/dev/sdb` деградирует быстро. Reallocated sectors: 267 (было 247 час назад). Нужно копировать данные СЕЙЧАС, пока диск жив."*

**Макс:**
*"Как безопасно скопировать данные с умирающего диска?"*

**Kristjan:**
*"`rsync` — твой друг. Копирует данные с checksums, может резюмить если прерв алось, показывает progress. Для block-level копирования есть `dd`, но он опасный — копирует всё вслепую."*

---

### 📚 Теория: Data Migration Strategies

#### 🚚 Метафора: Data Migration = Переезд квартиры

Представь **переезд из старой квартиры в новую**:

**Bad approach (`cp` или `mv`):**
```
🚚 ONE TRUCK, ONE TRIP
├─ Грузишь ВСЁ в один грузовик
├─ Если грузовик сломается в пути → потеря ВСЕГО
└─ Нет контроля качества
```

**Good approach (`rsync`):**
```
🚛 MULTIPLE TRUCKS, VERIFIED DELIVERY
├─ Грузовик #1: Копирует часть данных
│  └─ Проверяет checksums (ничего не потеряли?)
├─ Грузовик #2: Копирует следующую часть
│  └─ Проверяет checksums
├─ Грузовик #3: Копирует оставшееся
│  └─ Проверяет checksums
└─ Если грузовик сломался → resume с того места где остановились!
```

**rsync преимущества:**
- ✅ **Checksum verification** (проверяет integrity)
- ✅ **Resume capability** (можно прервать и продолжить)
- ✅ **Progress bar** (видишь что происходит)
- ✅ **Preserves metadata** (permissions, timestamps)

---

### 💻 Практика: Копирование данных

#### Scenario: Миграция с `/dev/sdb1` (failing) на `/dev/vg_data/lv_databases` (new LV)

```bash
# 1. Mount old disk (read-only для безопасности)
sudo mkdir -p /mnt/old_db
sudo mount -o ro /dev/sdb1 /mnt/old_db

# 2. Mount new LV
sudo mkdir -p /mnt/databases
sudo mount /dev/vg_data/lv_databases /mnt/databases

# 3. Копировать с rsync
sudo rsync -avh --progress /mnt/old_db/ /mnt/databases/

# -a: archive mode (preserve permissions, timestamps, symlinks)
# -v: verbose (показать что копируется)
# -h: human-readable sizes
# --progress: показать progress bar
```

---

#### rsync output (пример)

```
sending incremental file list
./
mysql/
mysql/ibdata1
      15,728,640 100%   45.32MB/s    0:00:00 (xfr#1, to-chk=5247/5250)
mysql/ib_logfile0
      50,331,648 100%   87.54MB/s    0:00:00 (xfr#2, to-chk=5246/5250)
mysql/mydb/
mysql/mydb/users.frm
           8,788 100%   14.23kB/s    0:00:00 (xfr#3, to-chk=5245/5250)
mysql/mydb/users.ibd
     104,857,600  32%   92.15MB/s    0:00:01

sent 235,678,432 bytes  received 1,024 bytes  44,567,123.45 bytes/sec
total size is 524,288,000  speedup is 2.22
```

---

#### Advanced: rsync с checksums и retry

```bash
# Для critical data используй checksums
sudo rsync -avh --progress --checksum /mnt/old_db/ /mnt/databases/

# --checksum: проверяет file content, не только размер/timestamp
# Медленнее, но надёжнее

# Для больших миграций: логи + resume
sudo rsync -avh --progress \
  --log-file=/var/log/migration.log \
  --partial \
  /mnt/old_db/ /mnt/databases/

# --partial: сохраняет частично скопированные файлы (для resume)
# --log-file: подробные логи

# Если прервалось — resume (запусти ту же команду снова)
# rsync умный — продолжит с того места где остановился
```

---

#### Block-level копирование (dd — use with CAUTION!)

```bash
# dd — копирует ВСЁ на block level (включая empty space!)
# ⚠️ ОПАСНО! Может уничтожить данные если спутать if= и of=

# Копировать диск целиком
sudo dd if=/dev/sdb of=/dev/sdc bs=4M status=progress

# if= (input file): SOURCE
# of= (output file): DESTINATION
# bs= (block size): 4MB chunks (faster)
# status=progress: показать progress

# ⚠️ ПРОВЕРЬ ДВА РАЗА!
# if= SOURCE (старый диск)
# of= DESTINATION (новый диск)
# Перепутал — уничтожил данные!
```

**Kristjan:**
*"`dd` — это chainsaw. Мощный, но опасный. `rsync` — это precision tool. Для data migration всегда используй `rsync`, кроме специфических случаев."*

---

### 🤔 Проверка понимания

**Вопрос 1:** В чём разница между `rsync` и `cp`?

<details>
<summary>💡 Ответ</summary>

| Функция | `cp` | `rsync` |
|---------|------|---------|
| **Incremental copy** | ❌ Копирует всё заново | ✅ Копирует только изменения |
| **Resume capability** | ❌ Нельзя resume | ✅ Можно resume |
| **Checksum verification** | ❌ Нет проверки | ✅ Опциональная проверка |
| **Progress bar** | ❌ Нет | ✅ `--progress` |
| **Network transfer** | ❌ Только local | ✅ Работает через SSH |
| **Speed** | Быстрее для первой копии | Быстрее для incremental updates |

**Пример:**
```bash
# Копировать 100GB database
cp -r /mnt/old/ /mnt/new/  # 10 минут

# Добавили 1GB новых данных
cp -r /mnt/old/ /mnt/new/  # Снова 10 минут! (копирует всё)

# С rsync:
rsync -av /mnt/old/ /mnt/new/  # 10 минут
# Добавили 1GB новых данных
rsync -av /mnt/old/ /mnt/new/  # 30 секунд! (только изменения)
```

**Best practice:**
- ✅ `rsync` для data migration, backups, sync
- ⚠️ `cp` для simple single-file copies

**Liisa:** *"rsync — это industry standard для data migration. cp — это toy. Production data требует rsync."*

</details>

---

**Вопрос 2:** Зачем `-o ro` (read-only) при mounting failing disk?

<details>
<summary>💡 Safety First</summary>

**Read-only mount (`-o ro`):**
- ✅ **Защита данных:** Нельзя случайно изменить/удалить
- ✅ **Меньше нагрузка на dying disk:** Только чтение, no writes
- ✅ **Filesystem consistency:** Если filesystem повреждён — не ухудшаем

**Сценарий:**
```bash
# Mount read-write (default)
sudo mount /dev/sdb1 /mnt/old_db

# Случайно запустил:
rm -rf /mnt/old_db/important_data/  # 💥 DATA LOSS!

# Mount read-only
sudo mount -o ro /dev/sdb1 /mnt/old_db

# Попытка удалить:
rm -rf /mnt/old_db/important_data/
# rm: cannot remove '/mnt/old_db/important_data/': Read-only file system ✅
```

**Failing disk:**
- Каждая write operation может **ускорить смерть**
- Read-only mode = **minimal stress**

**Best practice для migration:**
```bash
# 1. Mount source read-only
sudo mount -o ro /dev/sdb1 /mnt/old

# 2. Копировать
sudo rsync -av /mnt/old/ /mnt/new/

# 3. Verify
diff -r /mnt/old/ /mnt/new/

# 4. Unmount source
sudo umount /mnt/old

# 5. Retire old disk
```

**Kristjan:** *"Failing disk — это time bomb. Read-only mount минимизирует риск. Каждая write operation может быть последней."*

</details>

---

### ✅ Чеклист Цикл 6

- [ ] Понимаю зачем нужна data migration (failing disk rescue)
- [ ] Умею копировать данные с `rsync` (`rsync -avh --progress`)
- [ ] Знаю разницу между `rsync` и `cp` (incremental vs full copy)
- [ ] Понимаю зачем read-only mount (`-o ro`)
- [ ] Знаю что `dd` опасен (block-level, может уничтожить данные)
- [ ] Умею resume миграцию если прервалась

**LILITH:**
*"Data migration — это surgery. Failing disk — это patient умирающий на столе. rsync — это scalpel. Не используй chainsaw (dd) где нужен scalpel."*

---

## 🔄 ЦИКЛ 7: RAID Concepts — Redundancy (15-20 минут)

### 🎬 Сюжет

**Kristjan:**
*"Миграция завершена. Данные на новом LV. Но что если этот диск тоже умрёт? В production недопустимо полагаться на один диск."*

**Макс:**
*"RAID?"*

**Kristjan:**
*"Exactly. RAID (Redundant Array of Independent Disks) — это technique объединения дисков для redundancy или performance. RAID 1 — зеркалирование. RAID 5 — parity. RAID 10 — combination."*

**Liisa:**
*"В e-Estonia все critical databases на RAID 10. Два диска умрут — система работает. Это insurance policy."*

---

### 📚 Теория: RAID Levels

#### 🛡️ Метафора: RAID = Backup Team

Представь **команду специалистов**:

**Без RAID (single disk):**
```
👤 ONE PERSON
└─ Если заболел → проект останавливается ❌
```

**RAID 1 (mirroring):**
```
👤👤 TWO PEOPLE, SAME TASK
├─ Person A: Делает задачу
├─ Person B: Делает ТУ ЖЕ задачу (mirror)
└─ Если Person A заболел → Person B продолжает ✅
```

**RAID 5 (parity):**
```
👤👤👤 THREE PEOPLE, DISTRIBUTED WORK
├─ Person A: Часть 1
├─ Person B: Часть 2
├─ Person C: Parity (checksum Части 1+2)
└─ Если Person A заболел → восстановить Часть 1 из B+C ✅
```

**RAID 10 (mirror + stripe):**
```
👤👤 + 👤👤 FOUR PEOPLE, PAIRS
├─ Pair 1 (A+B mirror): Часть 1
├─ Pair 2 (C+D mirror): Часть 2
└─ Если A+C заболели → B+D продолжают ✅
```

---

#### 🎯 RAID Levels Comparison

| RAID | Дисков | Capacity | Performance | Fault Tolerance | Use Case |
|------|--------|----------|-------------|-----------------|----------|
| **RAID 0** | 2+ | 100% (2x1TB = 2TB) | ⚡⚡⚡ Fast (striping) | ❌ 0 (любой диск умер = data loss) | Performance, non-critical |
| **RAID 1** | 2+ | 50% (2x1TB = 1TB) | ⚡⚡ Good read | ✅ n-1 disks | OS drives, critical data |
| **RAID 5** | 3+ | 66-90% (3x1TB = 2TB) | ⚡⚡ Good | ✅ 1 disk | File servers |
| **RAID 6** | 4+ | 50-80% (4x1TB = 2TB) | ⚡ OK | ✅ 2 disks | High reliability |
| **RAID 10** | 4+ (even) | 50% (4x1TB = 2TB) | ⚡⚡⚡ Fast | ✅ Half disks | Databases, VMs |

---

#### RAID 0 (Striping — НЕТ redundancy!)

```
DISK 1        DISK 2
┌─────┐      ┌─────┐
│ A1  │      │ A2  │  ← File A split
├─────┤      ├─────┤
│ B1  │      │ B2  │  ← File B split
├─────┤      ├─────┤
│ C1  │      │ C2  │  ← File C split
└─────┘      └─────┘
```

**Преимущества:**
- ⚡ **2x performance** (читает/пишет параллельно)
- ✅ **100% capacity** (нет overhead)

**Недостатки:**
- ❌ **NO fault tolerance** (любой диск умер = ALL data lost!)

**Use case:**
- Temp data, cache
- Video editing (speed важнее redundancy)

**Kristjan:** *"RAID 0 — это gambling. Fast, но zero protection. Один диск умер — ты потерял ВСЁ."*

---

#### RAID 1 (Mirroring — 100% redundancy)

```
DISK 1        DISK 2
┌─────┐      ┌─────┐
│ A   │ ═══▶ │ A   │  ← Exact copy
├─────┤      ├─────┤
│ B   │ ═══▶ │ B   │  ← Exact copy
├─────┤      ├─────┤
│ C   │ ═══▶ │ C   │  ← Exact copy
└─────┘      └─────┘
```

**Преимущества:**
- ✅ **100% redundancy** (любой диск умер — данные целы)
- ⚡ **Fast read** (читает с обоих дисков параллельно)
- ✅ **Simple recovery** (просто replace failed disk)

**Недостатки:**
- ❌ **50% capacity** (2x1TB = только 1TB usable)
- ⚡ **Slow write** (пишет на оба диска)

**Use case:**
- OS drives
- Critical databases (если capacity не проблема)

---

#### RAID 5 (Striping + Parity)

```
DISK 1      DISK 2      DISK 3
┌─────┐    ┌─────┐    ┌─────┐
│ A1  │    │ A2  │    │ Ap  │  ← A1+A2 → parity Ap
├─────┤    ├─────┤    ├─────┤
│ B1  │    │ Bp  │    │ B2  │  ← B1+B2 → parity Bp
├─────┤    ├─────┤    ├─────┤
│ Cp  │    │ C1  │    │ C2  │  ← C1+C2 → parity Cp
└─────┘    └─────┘    └─────┘
```

**Преимущества:**
- ✅ **Fault tolerance** (1 disk умер — восстановит из parity)
- ✅ **Good capacity** (3x1TB = 2TB usable, 66%)
- ⚡ **Good read performance**

**Недостатки:**
- ⚡ **Slower write** (нужно calculate parity)
- ❌ **Только 1 disk failure** (2 диска умерли = data loss!)
- ⚠️ **Rebuild stress** (восстановление нагружает оставшиеся диски)

**Use case:**
- File servers
- Archive storage

---

#### RAID 10 (1+0 = Mirror + Stripe)

```
  RAID 1 PAIR 1    RAID 1 PAIR 2
┌─────┬─────┐    ┌─────┬─────┐
│ A1  │ A1  │    │ A2  │ A2  │ ← File A striped + mirrored
├─────┼─────┤    ├─────┼─────┤
│ B1  │ B1  │    │ B2  │ B2  │ ← File B striped + mirrored
└─────┴─────┘    └─────┴─────┘
DISK1   DISK2     DISK3   DISK4
```

**Преимущества:**
- ✅ **High fault tolerance** (до 2 disks умерли — работает)
- ⚡⚡ **Fast read + write** (striping performance)
- ✅ **Fast rebuild** (просто mirror rebuild, не parity calculation)

**Недостатки:**
- ❌ **50% capacity** (4x1TB = 2TB usable)
- ❌ **Минимум 4 диска**

**Use case:**
- Production databases
- Virtual machines
- High I/O applications

**Liisa:** *"RAID 10 — это gold standard для databases. Fast, reliable, production-proven. Мы используем RAID 10 для всех critical систем."*

---

### 💻 Практика: LVM + RAID (mdadm)

Linux поддерживает software RAID через `mdadm`.

#### Создание RAID 1 (mirror)

```bash
# Install mdadm
sudo apt install mdadm

# Создать RAID 1 из /dev/sdc и /dev/sdd
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdc /dev/sdd

# Вывод:
# mdadm: Defaulting to version 1.2 metadata
# mdadm: array /dev/md0 started.

# Проверить status
cat /proc/mdstat

# Вывод:
# Personalities : [raid1]
# md0 : active raid1 sdd[1] sdc[0]
#       524224 blocks super 1.2 [2/2] [UU]
#
# [UU] = оба диска работают

# Детальная информация
sudo mdadm --detail /dev/md0
```

---

#### RAID + LVM (best practice)

```bash
# 1. Создать RAID array
sudo mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/sd{c,d,e,f}

# 2. Создать PV на RAID
sudo pvcreate /dev/md0

# 3. Добавить в VG
sudo vgcreate vg_raid /dev/md0

# 4. Создать LV
sudo lvcreate -L 500G -n lv_databases vg_raid

# Теперь у тебя:
# - RAID 10 redundancy (hardware level)
# - LVM flexibility (logical level)
# - Best of both worlds!
```

---

### 🤔 Проверка понимания

**Вопрос 1:** Какой RAID для production databases: RAID 5 или RAID 10?

<details>
<summary>💡 RAID 10 для databases</summary>

**RAID 10 — рекомендуется для databases:**

**Преимущества:**
- ⚡ **Faster writes** (no parity calculation)
- ✅ **Better fault tolerance** (до 2 disks failure)
- ⚡ **Faster rebuild** (mirror rebuild быстрее parity rebuild)
- ✅ **No write penalty** (RAID 5 имеет write penalty из-за parity)

**RAID 5 проблемы для databases:**
- ⚠️ **Write penalty:** Каждая write → read old data → calculate parity → write data+parity (4 I/O operations!)
- ⚠️ **Rebuild risk:** Rebuild нагружает оставшиеся диски → второй диск может умереть во время rebuild → data loss
- ⚠️ **URE (Unrecoverable Read Error):** На больших дисках (>2TB) вероятность URE во время rebuild высокая

**Benchmark (примерный):**
```
RAID 5:  10,000 IOPS write
RAID 10: 20,000 IOPS write
```

**Cost:**
- RAID 5: 3x1TB = 2TB usable ($300 for 3 disks)
- RAID 10: 4x1TB = 2TB usable ($400 for 4 disks)
- **+$100 за 2x performance и better reliability = worth it!**

**Kristjan:** *"RAID 5 — это legacy. Был OK для HDD эры, но modern databases требуют RAID 10. Performance и reliability критичны."*

</details>

---

**Вопрос 2:** Можно ли восстановить данные если 2 диска умерли в RAID 5?

<details>
<summary>💡 НЕТ (без backup)</summary>

**RAID 5 — tolerates ONLY 1 disk failure.**

**Сценарий:**
```
RAID 5: 3 диска (A, B, C)
├─ День 1: Disk A умер ⚠️
│  └─ RAID degraded, но работает (восстанавливает из B+C parity)
│
├─ День 2: Начался rebuild (добавлен новый диск D)
│  └─ Rebuild: 12 часов (heavy I/O load на B и C)
│
└─ День 2, час 8: Disk B умер ❌ (stress от rebuild)
   └─ 2 диска мертвы → RAID failed → DATA LOSS!
```

**Без backup → данные потеряны навсегда.**

**RAID — это НЕ backup!**

**RAID protects against:** Hardware failure (диск умер)
**RAID НЕ protects against:**
- ❌ Accidental deletion (`rm -rf /`)
- ❌ Ransomware
- ❌ Fire, theft
- ❌ Multiple simultaneous failures
- ❌ Filesystem corruption

**Best practice:**
```
RAID (redundancy) + Backup (disaster recovery)
```

**Liisa:** *"RAID — это airbag. Backup — это fire insurance. Нужны ОБА. Говоришь 'у меня RAID, не нужен backup' — ты потеряешь данные. Вопрос времени."*

</details>

---

### ✅ Чеклист Цикл 7

- [ ] Понимаю что такое RAID (Redundant Array of Independent Disks)
- [ ] Знаю difference между RAID levels (0, 1, 5, 10)
- [ ] Понимаю что RAID 10 лучше для databases (performance + reliability)
- [ ] Знаю что RAID — НЕ backup (protects от hardware failure only)
- [ ] Понимаю концепт striping (performance) и mirroring (redundancy)

**LILITH:**
*"RAID — это insurance против hardware failure. Но insurance не спасёт от пожара если нет backup. RAID + Backup = production ready."*

---

## 🔄 ЦИКЛ 8: Production Monitoring — systemd disk monitoring (15-20 минут)

### 🎬 Сюжет (финал)

**Liisa:**
*"Миграция завершена. LVM настроен. fstab работает. Но как мониторить disk space? В production нужно знать когда заканчивается место ДО того как закончится."*

**Kristjan:**
*"systemd service + timer. Проверяем disk space каждые 30 минут. Если >90% — alert в Slack. Automation, не manual checks."*

**Макс создаёт systemd service для disk monitoring.**

**3 часа спустя:**

**Kristjan:**
*"Отличная работа, Макс. Данные спасены. LVM настроен. Monitoring работает. Ты освоил disk management."*

**Liisa:**
*"Диск `/dev/sdb` теперь retired. Новый LVM setup production-ready. Welcome to disk management world."*

**Макс улыбается, глядя на monitoring dashboard. Все индикаторы зелёные.**

---

### 📚 Теория: Disk Space Monitoring

#### 📡 Метафора: Monitoring = Early Warning System

Представь **дамбу с датчиками**:

**Без monitoring:**
```
🌊 DAM (disk space)
└─ Уровень воды: ???
   └─ Внезапно: OVERFLOW! 💥
      └─ Database crash, application failure
```

**С monitoring:**
```
📡 EARLY WARNING SYSTEM
├─ Датчик уровня воды: 70% ✅
├─ Датчик уровня воды: 85% ⚠️ (alert sent)
├─ Датчик уровня воды: 90% 🚨 (CRITICAL!)
└─ Engineer реагирует: clean up logs, extend LV ✅
```

**systemd service + timer** = автоматизированные датчики.

---

### 💻 Практика: systemd Disk Monitoring Service

#### Шаг 1: Создать monitoring script

```bash
sudo nano /usr/local/bin/disk-monitor.sh
```

```bash
#!/bin/bash

################################################################################
# DISK SPACE MONITORING SCRIPT
# Episode 11: Disk Management & LVM
# KERNEL SHADOWS Operation
################################################################################

set -e

# Configuration
THRESHOLD=90
EMAIL="admin@example.com"
SLACK_WEBHOOK="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# Function: Check disk usage
check_disk_usage() {
    local mount_point="$1"
    local threshold="$2"

    local usage=$(df -h "$mount_point" | tail -1 | awk '{print $5}' | sed 's/%//')

    if [[ $usage -ge $threshold ]]; then
        echo -e "${RED}CRITICAL: $mount_point is ${usage}% full!${NC}"
        send_alert "$mount_point" "$usage"
        return 1
    elif [[ $usage -ge 80 ]]; then
        echo -e "${YELLOW}WARNING: $mount_point is ${usage}% full${NC}"
        return 0
    else
        echo -e "${GREEN}OK: $mount_point is ${usage}% full${NC}"
        return 0
    fi
}

# Function: Send alert (Slack)
send_alert() {
    local mount_point="$1"
    local usage="$2"

    local message="🚨 DISK SPACE ALERT: $mount_point is ${usage}% full on $(hostname)"

    # Slack notification
    if [[ -n "$SLACK_WEBHOOK" ]]; then
        curl -X POST -H 'Content-type: application/json' \
            --data "{\"text\":\"$message\"}" \
            "$SLACK_WEBHOOK" 2>/dev/null
    fi

    # Email notification (optional)
    if command -v mail &> /dev/null; then
        echo "$message" | mail -s "Disk Space Alert" "$EMAIL"
    fi

    # Log to syslog
    logger -t disk-monitor "$message"
}

# Main: Check all mounted filesystems
main() {
    echo "=== Disk Space Monitoring - $(date) ==="

    # Check specific mount points
    check_disk_usage "/" "$THRESHOLD"
    check_disk_usage "/mnt/databases" "$THRESHOLD" || true
    check_disk_usage "/mnt/logs" "$THRESHOLD" || true

    echo "=== Monitoring complete ==="
}

main "$@"
```

```bash
# Make executable
sudo chmod +x /usr/local/bin/disk-monitor.sh

# Test
sudo /usr/local/bin/disk-monitor.sh
```

---

#### Шаг 2: Создать systemd service

```bash
sudo nano /etc/systemd/system/disk-monitor.service
```

```ini
[Unit]
Description=Disk Space Monitoring Service
After=local-fs.target
Documentation=https://github.com/kernel-shadows/episode-11

[Service]
Type=oneshot
ExecStart=/usr/local/bin/disk-monitor.sh
StandardOutput=journal
StandardError=journal
SyslogIdentifier=disk-monitor

# Security hardening
NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

---

#### Шаг 3: Создать systemd timer (scheduler)

```bash
sudo nano /etc/systemd/system/disk-monitor.timer
```

```ini
[Unit]
Description=Disk Space Monitoring Timer
Documentation=https://github.com/kernel-shadows/episode-11

[Timer]
# Run every 30 minutes
OnCalendar=*:0/30
# Run 5 minutes after boot
OnBootSec=5min
# If missed (system was off), run on next boot
Persistent=true

[Install]
WantedBy=timers.target
```

---

#### Шаг 4: Enable и Start

```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable timer (start on boot)
sudo systemctl enable disk-monitor.timer

# Start timer
sudo systemctl start disk-monitor.timer

# Check timer status
sudo systemctl status disk-monitor.timer

# List all timers
systemctl list-timers disk-monitor.timer

# Вывод:
# NEXT                         LEFT       LAST  PASSED  UNIT                   ACTIVATES
# Sat 2025-10-11 13:00:00 UTC  2min left  n/a   n/a     disk-monitor.timer     disk-monitor.service
```

---

#### Шаг 5: Проверка логов

```bash
# Logs service
sudo journalctl -u disk-monitor.service -f

# Logs timer
sudo journalctl -u disk-monitor.timer -f

# Последние 20 entries
sudo journalctl -u disk-monitor.service -n 20
```

---

### 🤔 Проверка понимания

**Вопрос 1:** Зачем systemd timer вместо cron?

<details>
<summary>💡 systemd timers — modern replacement for cron</summary>

**systemd timer преимущества:**

1. **Centralized logging:**
```bash
# systemd timer:
sudo journalctl -u disk-monitor.service  # Все логи в одном месте

# cron:
# Логи в /var/log/syslog, перемешаны с другими, неудобно
```

2. **Dependencies:**
```ini
# systemd timer:
[Unit]
After=network.target  # Wait for network

# cron:
# No dependency management, может запуститься до network ready
```

3. **Resource control:**
```ini
# systemd service:
CPUQuota=20%
MemoryLimit=512M

# cron:
# No resource limits!
```

4. **Persistent:**
```ini
# systemd timer:
Persistent=true  # If system was off, run on boot

# cron:
# Missed runs = lost forever
```

5. **Human-readable:**
```ini
# systemd:
OnCalendar=*:0/30  # Every 30 minutes

# cron:
*/30 * * * *  # Less readable
```

**cron still OK for:**
- Legacy systems
- Simple user-level tasks
- Quick ad-hoc automation

**Production best practice: systemd timers**

**Kristjan:** *"cron — это legacy. systemd timers — это modern, integrated, production-ready."*

</details>

---

**Вопрос 2:** Что делать если disk space alert пришёл?

<details>
<summary>💡 Troubleshooting Workflow</summary>

**Step 1: Identify что занимает место**

```bash
# 1. Общая картина
df -h

# 2. Топ 10 директорий по размеру
sudo du -sh /* 2>/dev/null | sort -h | tail -10

# 3. Find large files (>1GB)
sudo find / -type f -size +1G -exec ls -lh {} \; 2>/dev/null

# 4. Топ 20 largest files
sudo find / -type f -exec du -h {} + 2>/dev/null | sort -h | tail -20
```

---

**Step 2: Clean up**

```bash
# Old logs
sudo journalctl --vacuum-size=500M  # Keep only 500MB of logs
sudo journalctl --vacuum-time=7d    # Keep only 7 days

# Package cache
sudo apt clean
sudo apt autoclean

# Old kernels (Ubuntu)
sudo apt autoremove --purge

# Temp files
sudo find /tmp -type f -atime +7 -delete  # Files not accessed for 7 days
```

---

**Step 3: Extend LV (если cleanup недостаточно)**

```bash
# Check VG free space
sudo vgs

# If есть free space в VG:
sudo lvextend -L +50G /dev/vg_data/lv_databases
sudo resize2fs /dev/vg_data/lv_databases  # ext4
# or
sudo xfs_growfs /mnt/databases  # xfs

# If нет free space → добавить новый disk в VG
sudo pvcreate /dev/sde1
sudo vgextend vg_data /dev/sde1
sudo lvextend -L +100G /dev/vg_data/lv_databases
sudo resize2fs /dev/vg_data/lv_databases
```

---

**Step 4: Prevent в будущем**

```bash
# Log rotation
sudo nano /etc/logrotate.d/myapp

# /var/log/myapp/*.log {
#     daily
#     rotate 7
#     compress
#     delaycompress
#     missingok
#     notifempty
# }

# Automatic cleanup script
# (добавить в cron или systemd timer)
```

**Liisa:** *"Disk space alerts — это opportunity для cleanup и optimization. Реагируй быстро, анализируй что занимает место, prevent в будущем."*

</details>

---

### ✅ Чеклист Цикл 8

- [ ] Понимаю зачем нужен disk monitoring (prevent disk full)
- [ ] Умею создать systemd service для monitoring
- [ ] Умею создать systemd timer (scheduler)
- [ ] Знаю как проверить логи (`journalctl -u service_name`)
- [ ] Понимаю workflow troubleshooting disk space issues
- [ ] Знаю преимущества systemd timers vs cron

**LILITH:**
*"Monitoring — это not optional в production. Reactive management (ждать пока диск full) — это disaster. Proactive monitoring — это professionalism."*

---

## 🎯 Итоговое практическое задание

### 📝 Задание: Full LVM Setup + Monitoring

**Scenario:**
У тебя 2 новых диска (`/dev/sdc`, `/dev/sdd`). Нужно настроить production-ready storage с мониторингом.

**Требования:**

1. ✅ **LVM Setup:**
   - Создать PV на `/dev/sdc1` и `/dev/sdd1`
   - Создать VG `vg_production`
   - Создать 3 LV:
     - `lv_databases` (300GB, xfs)
     - `lv_logs` (150GB, ext4)
     - `lv_backups` (50GB, ext4)

2. ✅ **Filesystems & Mount:**
   - Создать filesystems (xfs для databases, ext4 для остальных)
   - Mount в `/mnt/databases`, `/mnt/logs`, `/mnt/backups`
   - Настроить `/etc/fstab` с UUID и `noatime`

3. ✅ **Monitoring:**
   - Создать `disk-monitor.sh` script
   - Создать systemd service + timer (каждые 30 минут)
   - Threshold: 90%

4. ✅ **Testing:**
   - Проверить что всё монтируется после reboot (`sudo mount -a`)
   - Проверить что monitoring service работает
   - Simulate high disk usage (создать large file, проверить alert)

---

### 🛠️ Стартовый шаблон

Используй **`starter.sh`** в этой директории — там есть TODO комментарии для заполнения.

---

## 🎓 Итоги Episode 11

### Что вы освоили:

✅ **Block Devices & Partitions:**
- Понимание как Linux видит диски (`/dev/sdX`, `/dev/nvmeXnY`)
- Partitioning concepts (MBR vs GPT)
- `lsblk`, `fdisk`, `parted`

✅ **SMART Monitoring:**
- Disk health checks (`smartctl`)
- Critical attributes (Reallocated sectors, Pending sectors)
- Предсказание failures

✅ **LVM (Logical Volume Manager):**
- PV → VG → LV architecture
- `pvcreate`, `vgcreate`, `lvcreate`
- Resize operations (`lvextend` + `resize2fs`)
- Snapshot для backups

✅ **Filesystems:**
- ext4, xfs, btrfs comparison
- `mkfs.ext4`, `mkfs.xfs`
- Mount/unmount operations

✅ **`/etc/fstab`:**
- Автоматическое монтирование при загрузке
- UUID vs device paths
- Mount options (`noatime`, `defaults`)
- Testing (`mount -a`)

✅ **Data Migration:**
- `rsync` для safe data copy
- Read-only mounting (`-o ro`)
- Resume capability

✅ **RAID:**
- RAID levels (0, 1, 5, 10) comparison
- Redundancy vs performance trade-offs
- RAID — НЕ backup!

✅ **Production Monitoring:**
- systemd service + timer для disk monitoring
- `journalctl` для логирования
- Proactive alerts (Slack, email)

---

### Сюжетный итог:

**23:00. Таллин. Serверная e-Residency.**

**Kristjan** (смотрит на monitoring dashboard):
*"Perfect. All green. Миграция завершена, LVM настроен, monitoring работает. `/dev/sdb` retired без data loss. Это production-level work."*

**Liisa:**
*"Макс, ты спас 500GB production данных за 3 часа. Под давлением. Это настоящий sysadmin work."*

**Макс:**
*"Я думал disk management это просто 'add more space'. Теперь понимаю — это планирование, redundancy, monitoring."*

**Kristjan:**
*"Exactly. Disk management — это foundation всей инфраструктуры. Процессы работают на дисках. Данные живут на дисках. Без правильного disk management — всё остальное бессмысленно."*

**Liisa показывает Максу статистику:**

```
e-Estonia Infrastructure Stats:
- 180 Physical Disks
- 95% на LVM
- 100% на RAID 10 (critical data)
- SMART monitoring: 24/7
- Uptime: 99.97% (last 12 months)
- Zero data loss incidents (last 5 years)
```

**Kristjan:**
*"Это результат правильного disk management. Ты освоил основы. Теперь ты можешь управлять production storage."*

**Виктор** (звонит Максу):
*"Kristjan сказал — отличная работа. Episode 11 завершён. Следующий шаг — Backup & Recovery. Episode 12. Готов?"*

**Макс улыбается:**
*"Готов. Disk management — это было интенсивно, но я понял. Storage — это не просто пространство. Это надёжность, flexibility, мониторинг."*

---

### 🔗 Что дальше?

**Episode 12: Backup & Recovery**
- Backup strategies (full, incremental, differential)
- `rsync`, `tar`, `dd` для backups
- systemd timers для automated backups
- Disaster recovery procedures

**LILITH:**
*"Диски ты освоил. LVM настроил. Monitoring работает. Но всё это бессмысленно без backup. Episode 12 — научишься защищать данные от любой катастрофы."*

---

## 📖 Дополнительные ресурсы

### Man pages:
```bash
man lvm
man pvcreate
man vgcreate
man lvcreate
man lvextend
man mkfs.ext4
man mkfs.xfs
man fstab
man mount
man rsync
man smartctl
man mdadm
man systemd.service
man systemd.timer
```

### Online:
- [LVM HOWTO](https://tldp.org/HOWTO/LVM-HOWTO/)
- [Red Hat LVM Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_logical_volumes/)
- [Arch Wiki: LVM](https://wiki.archlinux.org/title/LVM)
- [Arch Wiki: RAID](https://wiki.archlinux.org/title/RAID)
- [systemd Timers vs Cron](https://wiki.archlinux.org/title/Systemd/Timers)
- [SMART Monitoring with smartmontools](https://www.smartmontools.org/)

---

**Episode 11 завершён! 🎉**

**LILITH:**
*"От block devices до production monitoring за 5 часов. Неплохо. Disk management — это foundation Linux SysAdmin. Ты освоил его. Теперь ты можешь управлять storage на уровне профессионала. Episode 12 ждёт. Backup & Recovery. Потому что even best disk management не спасёт от всех катастроф. Готов?"*

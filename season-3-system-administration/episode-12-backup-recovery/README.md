# EPISODE 12: BACKUP & RECOVERY
## Season 3: System Administration | Tallinn, Estonia 🇪🇪 (Final Episode)

> *"Untested backup = no backup. Test restore every month."* — Liisa Kask

---

## 📍 Контекст миссии

**Локация:** 🇪🇪 Tallinn, Estonia (продолжение)
**Место:** Skype Tallinn Office (legacy), e-Residency backup facility
**День операции:** 23-24 из 60 (финал Season 3)
**Время прохождения:** 3-4 часа
**Сложность:** ⭐⭐⭐⭐⭐

**Персонажи:**
- **Макс Соколов** — вы, изучаете backup strategies
- **Liisa Kask** — backup engineer, ex-Skype (главный ментор)
- **Kristjan Tamm** — e-Government architect (поддержка)
- **Анна Ковалева** — forensics expert (remote, координирует incident response)
- **Виктор Петров** — координатор операции
- **LILITH** — AI-помощник (я!)

---

## 🎬 Сюжет

### День 23. 03:47. Emergency call.

Макс спит в отеле в Старом городе Таллина. Резкий звонок телефона.

**Анна Ковалева** (голос напряжённый):
*"Макс, проснись. НЕМЕДЛЕННО. Атака. Крылов. Production server скомпрометирован. База данных удалена. Нужен restore. СЕЙЧАС."*

**Макс** (дезориентирован, включает laptop):
*"Что? Какая база? У нас есть backup?"*

**Анна:**
*"Не знаю. Проверяй. У тебя 10 минут. Бизнес-критические данные. Если не восстановим — операция провалена. Финансовые потери — миллионы. Звони Liisa Kask. Она эксперт по backup. Номер отправляю."*

Макс звонит Liisa (03:52, ночь).

**Liisa** (сонный голос, потом резко просыпается):
*"Max? Что случилось?"*

**Макс:**
*"Атака Крылова. База удалена. Анна сказала звонить тебе. У нас есть backup?"*

**Liisa** (пауза 3 секунды, потом спокойно):
*"Okay. Breathe. First question: когда последний backup? Second: где хранится? Third: ты проверял целостность backup?"*

**Макс:**
*"Не знаю... Не знаю... И не знаю..."*

**Liisa** (вздыхает):
*"Classic. Backup без проверки — это не backup, это self-deception. Meet me at e-Residency office. 15 minutes. Bring coffee. Strong coffee. We have work to do."*

---

### 04:10. E-Residency backup facility.

Liisa уже за компьютером, три монитора, terminal открыт.

**Liisa:**
*"Okay, Max. Lesson one: 'Untested backup = no backup'. Я работала на Skype в Таллине. Skype — это было 300 миллионов пользователей. Один час downtime — миллионы долларов потерь. Мы тестировали backup каждую неделю. КАЖДУЮ."*

**Макс:**
*"У нас есть backup?"*

**Liisa** (проверяет):
*"Yes. Последний backup — вчера в 02:00. Но... (хмурится) ...никто не проверял restore. Надеемся, что работает."*

**Макс:**
*"А если не работает?"*

**Liisa:**
*"Тогда мы очень быстро научимся forensics и попытаемся восстановить через `extundelete`. But that's plan Z. Let's try plan A first: restore from backup."*

---

### 04:30. Disaster recovery begins.

**Kristjan** (заходит с кофе):
*"Liisa called me. Bad night, Max. But good lesson. In e-Estonia мы говорим: 'Data is life'. No data — no e-services. No e-services — citizens angry. Very angry."*

**Liisa:**
*"Kristjan, у нас последний backup от вчера 02:00. Это 26 часов назад. Сколько данных потеряно?"*

**Kristjan:**
*"Acceptable. Restore now. Max, это твой шанс научиться disaster recovery в production. Under pressure. Just like real world."*

**Liisa** (открывает документацию):
*"Max, сейчас я покажу тебе 3-2-1 backup rule:
- **3** копии данных (original + 2 backups)
- **2** разных типа носителей (HDD + tape/cloud)
- **1** копия offsite (в другой локации)

Skype научил меня этому. Microsoft после acquisition добавил ещё правило: test restore every month. Мы будем следовать всем правилам. Starting now."*

---

### 05:00. Recovery process.

**Анна** (видеозвонок):
*"Status?"*

**Макс:**
*"Начинаем восстановление. Liisa говорит, backup есть."*

**Анна:**
*"Крылов оставил backdoor. Я нашла: `/var/lib/.krylov_backdoor.sh`. Запускался каждые 5 минут через cron, удалял данные постепенно. Forensics показывает: начало атаки — 3 дня назад. Они были внутри 72 часа."*

**Liisa:**
*"72 hours? Значит incremental backups за последние 3 дня — скомпрометированы. Нужен full backup от недели назад. Потеряем данные за неделю, но это чистые данные."*

**Макс:**
*"Неделя данных — это много..."*

**Liisa:**
*"Альтернатива — ноль данных. Choose."*

**Kristjan:**
*"Restore from last clean backup. We'll recreate lost week manually if needed. Data integrity > data freshness."*

---

### 06:30. Restore complete. Testing.

**Liisa** (проверяет):
*"Database restored. Size: 4.2 GB (expected 4.3 GB). Close enough. Checksums... (ждёт 30 секунд) ...match! Backup был хороший."*

**Макс:**
*"Мы восстановились?"*

**Liisa:**
*"Not yet. Restore — это половина. Testing — вторая половина. Мы сейчас проверим:
1. Database integrity (tables, indexes)
2. Application functionality (может запуститься?)
3. Data consistency (логика не нарушена?)

Только после всех проверок — success. Skype rule: 'Restore without testing — это русская рулетка'."*

---

### 08:00. Успех. Но есть вопросы.

**Kristjan:**
*"Max, вопрос: почему backup не был проверен до атаки?"*

**Max:**
*"Не знаю... Думали, что работает?"*

**Liisa:**
*"Классическая ошибка. Все так думают. Пока не происходит disaster. Теперь ты знаешь: backup strategy включает:
1. **Backup** (создание копий)
2. **Testing** (регулярная проверка restore)
3. **Monitoring** (алерты на failure)
4. **Documentation** (процедуры recovery)
5. **Automation** (скрипты для всего)

Without testing — это не strategy, это надежда."*

**Viktor** (видеозвонок, 08:15):
*"Status? Anna сказала, атака была серьёзной."*

**Max:**
*"Восстановились. Потеряли неделю данных, но база цела."*

**Viktor:**
*"Good. Now — prevention. Liisa, научи Max правильной backup стратегии. Автоматизация. Мониторинг. Offsite copies. Чтобы это никогда не повторилось."*

**Liisa:**
*"Already on it. Max, сегодня ты создашь production-grade backup system. С автоматизацией, тестированием, мониторингом. Всё как в Skype. Let's go."*

---

## 🎯 Твоя миссия

Создать **production-ready backup & disaster recovery систему**.

**Цели:**
1. Понять backup strategies (full, incremental, differential)
2. Настроить автоматический backup с `rsync`
3. Создать offsite backup (remote server)
4. Автоматизировать через cron
5. Тестирование restore procedures
6. Мониторинг backup health
7. Документация recovery процедур

**Итог:** Защищённая от disaster система с проверенными backup'ами.

---

## 📚 Теория

### 1. Backup Strategies

#### Full Backup
**Что:** Полная копия всех данных.

**Плюсы:**
- Простой restore (одна копия)
- Не зависит от предыдущих backup'ов

**Минусы:**
- Занимает много места
- Медленный (копирует всё)

**Когда использовать:** Еженедельно, как базовая копия.

```bash
# Full backup с tar
tar -czf backup-full-$(date +%Y%m%d).tar.gz /data

# Full backup с rsync
rsync -av --delete /data/ /backup/full/
```

---

#### Incremental Backup
**Что:** Копирует только файлы, изменённые с последнего backup (любого типа).

**Плюсы:**
- Быстро (только изменения)
- Занимает мало места

**Минусы:**
- Restore сложный (нужен full + все incremental)
- Зависит от chain (если один incremental повреждён — теряешь все последующие)

**Когда использовать:** Ежедневно, между full backup'ами.

```bash
# Incremental с rsync
rsync -av --link-dest=/backup/previous /data/ /backup/incremental-$(date +%Y%m%d)/
```

---

#### Differential Backup
**Что:** Копирует файлы, изменённые с последнего **full** backup.

**Плюсы:**
- Restore проще, чем incremental (нужен full + последний differential)
- Не зависит от предыдущих differential

**Минусы:**
- Растёт со временем (чем дальше от full, тем больше)

**Когда использовать:** Компромисс между full и incremental.

```bash
# Differential (копирует всё изменённое с момента full)
find /data -newer /backup/full-timestamp -exec cp {} /backup/differential/ \;
```

---

### 2. Backup Tools

#### rsync (рекомендуемый)
**Особенности:**
- Копирует только изменения (delta transfer)
- Поддерживает permissions, links, timestamps
- Может работать через SSH (remote backup)
- Incremental backups через `--link-dest`

```bash
# Local backup
rsync -av --delete /source/ /backup/

# Remote backup через SSH
rsync -av -e ssh /source/ user@remote:/backup/

# Incremental backup
rsync -av --link-dest=/backup/previous /source/ /backup/current/
```

**Флаги:**
- `-a` (archive) = preserve permissions, timestamps, symlinks
- `-v` (verbose) = показывает прогресс
- `--delete` = удаляет файлы в backup, если удалены в source
- `-e ssh` = использовать SSH для remote

---

#### tar (для архивов)
**Когда использовать:** Полные backup'ы, архивы для долгого хранения.

```bash
# Создать архив
tar -czf backup.tar.gz /data

# С исключением файлов
tar -czf backup.tar.gz --exclude='*.log' /data

# Извлечь архив
tar -xzf backup.tar.gz -C /restore/

# Список содержимого
tar -tzf backup.tar.gz
```

**Флаги:**
- `-c` (create) = создать архив
- `-x` (extract) = извлечь архив
- `-z` (gzip) = сжатие
- `-f` (file) = имя файла
- `-t` (list) = список содержимого
- `-v` (verbose) = показывать файлы

---

#### dd (низкоуровневое копирование)
**Когда использовать:** Backup целых дисков, создание образов.

```bash
# Backup диска
dd if=/dev/sda of=/backup/disk.img bs=4M status=progress

# Restore диска
dd if=/backup/disk.img of=/dev/sda bs=4M status=progress

# Backup partition
dd if=/dev/sda1 of=/backup/partition.img bs=4M
```

**⚠️ ОПАСНО:** dd копирует всё побайтово. Ошибка в `of=` может уничтожить диск!

---

### 3. The 3-2-1 Backup Rule

**Правило Liisa (из Skype):**

```
3 copies of data:
  - 1 original (production)
  - 2 backups (разные носители)

2 different media types:
  - HDD
  - Tape / Cloud / External disk

1 copy offsite:
  - Другая локация (физически)
  - Защита от fire, flood, theft
```

**Почему это важно:**
- Если диск сгорел → есть второй backup
- Если datacenter сгорел → есть offsite backup
- Если ransomware зашифровал → есть offline backup

**Пример:**
1. Production data: `/data` (SSD)
2. Local backup: `/backup` (HDD в том же сервере)
3. Remote backup: `remote:/backup` (другой сервер, другой город)

---

### 4. Automation с Cron

**Расписание backup:**
- **Full backup:** еженедельно (воскресенье 02:00)
- **Incremental backup:** ежедневно (каждый день 02:00)
- **Offsite sync:** ежедневно (03:00, после incremental)

```bash
# Crontab пример
# Full backup каждое воскресенье в 02:00
0 2 * * 0 /usr/local/bin/backup-full.sh

# Incremental backup ежедневно в 02:00 (кроме воскресенья)
0 2 * * 1-6 /usr/local/bin/backup-incremental.sh

# Offsite sync в 03:00
0 3 * * * /usr/local/bin/backup-offsite.sh
```

**Cron syntax:**
```
* * * * * command
│ │ │ │ │
│ │ │ │ └─ day of week (0-7, 0=Sunday)
│ │ │ └─── month (1-12)
│ │ └───── day of month (1-31)
│ └─────── hour (0-23)
└───────── minute (0-59)
```

---

### 5. Testing Restore

**Liisa's rule:** *"Untested backup = no backup."*

**Процедура тестирования:**
1. Выбрать случайный backup (не последний!)
2. Restore на test server (НЕ production!)
3. Проверить integrity (checksums, database checks)
4. Проверить functionality (приложение запускается?)
5. Документировать результаты
6. **Повторять каждый месяц**

```bash
# Тест restore
restore_test() {
    local backup_file="$1"
    local test_dir="/tmp/restore-test-$(date +%s)"

    # Restore
    tar -xzf "$backup_file" -C "$test_dir"

    # Verify checksums
    cd "$test_dir" && sha256sum -c checksums.txt

    # Test application
    ./test-app.sh

    # Cleanup
    rm -rf "$test_dir"
}
```

---

### 6. Monitoring Backup Health

**Что мониторить:**
1. Backup completion status (успешно/failed)
2. Backup size (неожиданные изменения = проблема)
3. Backup age (последний backup старше 48 часов = alert)
4. Disk space (backup заполнил диск?)
5. Checksum integrity

```bash
# Проверка возраста backup
check_backup_age() {
    local backup_file="/backup/latest.tar.gz"
    local max_age_hours=48

    if [[ ! -f "$backup_file" ]]; then
        echo "CRITICAL: Backup file not found!"
        exit 2
    fi

    local age_seconds=$(( $(date +%s) - $(stat -c %Y "$backup_file") ))
    local age_hours=$(( age_seconds / 3600 ))

    if (( age_hours > max_age_hours )); then
        echo "WARNING: Backup is $age_hours hours old (max: $max_age_hours)"
        exit 1
    fi

    echo "OK: Backup age is $age_hours hours"
}
```

---

### 7. Disaster Recovery Plan

**Документ, который должен быть у каждого админа:**

```markdown
# Disaster Recovery Procedures

## Scenario 1: Database Corruption
1. Stop application: `systemctl stop myapp`
2. Identify last clean backup: `ls -lh /backup/`
3. Restore: `rsync -av /backup/YYYYMMDD/ /data/`
4. Test integrity: `psql -c "SELECT * FROM test_table;"`
5. Start application: `systemctl start myapp`
6. Verify functionality: `curl http://localhost/health`

## Scenario 2: Ransomware
1. Disconnect from network IMMEDIATELY
2. Identify infection time from logs
3. Restore from backup BEFORE infection
4. Scan restored files with antivirus
5. Change ALL passwords
6. Review security: patches, firewall, backups

## Scenario 3: Hardware Failure
1. Provision new hardware
2. Install OS (same version!)
3. Restore data: `rsync -av remote:/backup/ /data/`
4. Restore configs: `/etc`, `/home`, `/var/www`
5. Test services one by one
6. Update DNS if IP changed

## Contact List
- Viktor: +7-XXX-XXX-XXXX
- Anna (forensics): +7-XXX-XXX-XXXX
- Liisa (backup expert): +372-XXX-XXXX
- Kristjan (e-Gov): +372-XXX-XXXX

## Backup Locations
- Primary: /backup
- Secondary: server2:/backup
- Offsite: remote-eu:/backup
```

---

### 8. Security Considerations

**Backup = потенциальная утечка данных!**

**Защита backup:**
1. **Encryption:** шифровать sensitive backups
   ```bash
   # Encrypt backup
   tar -czf - /data | gpg --encrypt -r admin@example.com > backup.tar.gz.gpg

   # Decrypt restore
   gpg --decrypt backup.tar.gz.gpg | tar -xzf -
   ```

2. **Access control:** ограничить доступ к backup
   ```bash
   chmod 600 /backup/*
   chown root:root /backup
   ```

3. **Offsite security:** SSH keys, не пароли
   ```bash
   ssh-keygen -t ed25519 -C "backup@server"
   ssh-copy-id backup@remote
   ```

4. **Immutable backups:** защита от ransomware
   ```bash
   # Linux: immutable flag (нельзя удалить/изменить)
   chattr +i /backup/critical.tar.gz

   # Remove immutable (when needed)
   chattr -i /backup/critical.tar.gz
   ```

---

### 9. Common Mistakes (что НЕ делать)

**❌ Mistake 1: Backup на том же диске**
```bash
# ПЛОХО: backup на /dev/sda, data тоже на /dev/sda
rsync -av /data/ /backup/
# Если диск умирает → теряешь ВСЁ
```

**✅ Правильно:** Backup на другой диск (или remote server)

---

**❌ Mistake 2: Не тестировать restore**
```bash
# ПЛОХО: создаём backup, но никогда не проверяем
tar -czf backup.tar.gz /data
# Если backup битый → узнаешь только когда понадобится
```

**✅ Правильно:** Тестировать restore каждый месяц

---

**❌ Mistake 3: Backup без retention policy**
```bash
# ПЛОХО: храним все backup навсегда
# Диск заполняется, backup падает, никто не замечает
```

**✅ Правильно:** Удалять старые backup (но оставлять несколько)
```bash
# Хранить 7 daily, 4 weekly, 12 monthly
find /backup/daily -mtime +7 -delete
find /backup/weekly -mtime +28 -delete
find /backup/monthly -mtime +365 -delete
```

---

**❌ Mistake 4: Один backup = достаточно**
```bash
# ПЛОХО: только local backup
rsync -av /data/ /backup/
```

**✅ Правильно:** 3-2-1 rule (3 копии, 2 media, 1 offsite)

---

## 🛠️ Практика

### Задание 1: Full Backup с tar ⭐

**Цель:** Создать полный архив директории `/var/log`.

**Требования:**
- Архив с gzip compression
- Имя файла: `logs-backup-YYYYMMDD.tar.gz`
- Исключить `/var/log/journal` (слишком большой)
- Проверить целостность после создания

**Подсказки:**
- `tar -czf` для создания compressed archive
- `--exclude=pattern` для исключения
- `tar -tzf` для проверки содержимого

<details>
<summary>💡 Hint 1 (если застрял 5 минут)</summary>

`tar` с флагом `-c` создаёт архив. Флаг `-z` добавляет gzip.

</details>

<details>
<summary>💡 Hint 2 (если застрял 10 минут)</summary>

```bash
tar -czf logs-backup-$(date +%Y%m%d).tar.gz --exclude='/var/log/journal' /var/log
```

</details>

---

### Задание 2: Incremental Backup с rsync ⭐⭐

**Цель:** Создать incremental backup с использованием hard links.

**Требования:**
- Source: `/home/student/data`
- Backup base: `/backup/data`
- Первый backup: `/backup/data/2025-10-01`
- Второй backup (incremental): `/backup/data/2025-10-02`
- Использовать `--link-dest` для hard links (экономия места)

**Подсказки:**
- `rsync -av` для archive mode
- `--link-dest` указывает на предыдущий backup
- Hard links = одинаковые файлы занимают место только один раз

<details>
<summary>💡 Hint 1</summary>

Первый backup (full):
```bash
rsync -av /home/student/data/ /backup/data/2025-10-01/
```

</details>

<details>
<summary>💡 Hint 2</summary>

Второй backup (incremental):
```bash
rsync -av --link-dest=/backup/data/2025-10-01 /home/student/data/ /backup/data/2025-10-02/
```

Только изменённые файлы копируются, остальные — hard links.

</details>

---

### Задание 3: Remote Backup через SSH ⭐⭐⭐

**Цель:** Настроить offsite backup на удалённый сервер.

**Требования:**
- SSH key authentication (без пароля)
- Backup user: `backup` на remote server
- Source: `/home/student/data`
- Destination: `backup@remote:/backup/student`
- Автоматизация через скрипт

**Подсказки:**
- `ssh-keygen` для создания ключа
- `ssh-copy-id` для копирования ключа на remote
- `rsync -e ssh` для backup через SSH

<details>
<summary>💡 Hint 1</summary>

1. Создать SSH key:
```bash
ssh-keygen -t ed25519 -f ~/.ssh/backup_key -N ""
```

2. Копировать на remote:
```bash
ssh-copy-id -i ~/.ssh/backup_key backup@remote
```

</details>

<details>
<summary>💡 Hint 2</summary>

Backup скрипт:
```bash
#!/bin/bash
rsync -av -e "ssh -i ~/.ssh/backup_key" /home/student/data/ backup@remote:/backup/student/
```

</details>

---

### Задание 4: Автоматизация с Cron ⭐⭐⭐

**Цель:** Настроить автоматический backup через cron.

**Требования:**
- Full backup каждое воскресенье в 02:00
- Incremental backup ежедневно (пн-сб) в 02:00
- Логирование в `/var/log/backup.log`
- Email alert при failure (опционально)

**Подсказки:**
- `crontab -e` для редактирования cron
- `0 2 * * 0` = воскресенье 02:00
- `0 2 * * 1-6` = понедельник-суббота 02:00
- `>>` для append в log файл

<details>
<summary>💡 Hint 1</summary>

Создать скрипты:
```bash
# /usr/local/bin/backup-full.sh
#!/bin/bash
tar -czf /backup/full-$(date +%Y%m%d).tar.gz /home/student/data >> /var/log/backup.log 2>&1

# /usr/local/bin/backup-incremental.sh
#!/bin/bash
rsync -av /home/student/data/ /backup/incremental-$(date +%Y%m%d)/ >> /var/log/backup.log 2>&1
```

</details>

<details>
<summary>💡 Hint 2</summary>

Добавить в crontab:
```bash
crontab -e

# Full backup каждое воскресенье
0 2 * * 0 /usr/local/bin/backup-full.sh

# Incremental backup пн-сб
0 2 * * 1-6 /usr/local/bin/backup-incremental.sh
```

</details>

---

### Задание 5: Restore Testing ⭐⭐⭐⭐

**Цель:** Протестировать процедуру восстановления.

**Сценарий:**
1. Создать test data: 100 файлов в `/home/student/test-data`
2. Создать backup (tar.gz)
3. Удалить original data
4. Restore из backup
5. Проверить integrity (checksums)

**Требования:**
- Скрипт для генерации test data
- Backup с checksums
- Restore procedure
- Verification script

<details>
<summary>💡 Hint 1</summary>

Генерация test data:
```bash
mkdir -p /home/student/test-data
for i in {1..100}; do
    echo "Test file $i" > /home/student/test-data/file$i.txt
done

# Создать checksums
cd /home/student/test-data
sha256sum * > checksums.txt
```

</details>

<details>
<summary>💡 Hint 2</summary>

Backup + restore:
```bash
# Backup
tar -czf /backup/test-backup.tar.gz /home/student/test-data

# "Disaster" — удаляем данные
rm -rf /home/student/test-data

# Restore
tar -xzf /backup/test-backup.tar.gz -C /

# Verify checksums
cd /home/student/test-data
sha256sum -c checksums.txt
```

</details>

---

### Задание 6: Disaster Recovery Simulation ⭐⭐⭐⭐⭐

**Цель:** Симулировать реальную disaster и восстановление.

**Сценарий Krylov атаки:**
1. Setup: создать "production" базу данных (SQLite или файлы)
2. Настроить backup систему (full + incremental)
3. Добавить данные каждый день (3 дня)
4. **День 3:** Атака — "Krylov backdoor" удаляет данные
5. Identify: определить когда началась атака (из логов)
6. Restore: восстановить из последнего чистого backup
7. Verify: проверить data integrity
8. Document: написать incident report

**Это максимально близко к реальному сценарию из сюжета!**

<details>
<summary>💡 Hint 1</summary>

Симуляция атаки:
```bash
# День 1: создать production data
mkdir -p /production/data
echo "Day 1 data" > /production/data/day1.txt

# Full backup
tar -czf /backup/full-day1.tar.gz /production/data

# День 2: добавить данные
echo "Day 2 data" > /production/data/day2.txt

# Incremental backup
rsync -av /production/data/ /backup/incremental-day2/

# День 3: добавить данные
echo "Day 3 data" > /production/data/day3.txt

# АТАКА! Krylov backdoor удаляет всё
rm -rf /production/data/*
echo "Hacked by Krylov" > /production/data/HACKED.txt
```

</details>

<details>
<summary>💡 Hint 2</summary>

Restore procedure:
```bash
# Анализ: атака в день 3, последний чистый backup — день 2

# Restore full (day 1)
tar -xzf /backup/full-day1.tar.gz -C /

# Restore incremental (day 2)
rsync -av /backup/incremental-day2/ /production/data/

# Verify
ls -la /production/data/
# Должно быть: day1.txt, day2.txt
# НЕ должно быть: day3.txt, HACKED.txt

# Потеряли данные дня 3, но восстановили дни 1-2
```

</details>

---

## 🧪 Проверка знаний

После выполнения всех заданий, ответь на вопросы Liisa:

### Вопрос 1
**Liisa:** *"У нас full backup раз в неделю, incremental — каждый день. В воскресенье диск сгорел. Сколько backup нужно для restore?"*

<details>
<summary>Ответ</summary>

**Incremental:** Нужен 1 full + ВСЕ incremental с момента full.

Если сегодня воскресенье, а full был в прошлое воскресенье → нужен:
- 1 full (прошлое воскресенье)
- 6 incremental (понедельник-суббота)

**Итого:** 7 backup для полного восстановления.

**Differential было бы проще:** 1 full + последний differential (2 файла).

</details>

---

### Вопрос 2
**Liisa:** *"Backup есть, но restore занимает 8 часов. Бизнес теряет $100K/час. Что делать?"*

<details>
<summary>Ответ</summary>

**Проблема:** Recovery Time Objective (RTO) = 8 часов слишком долго.

**Решения:**
1. **Hot standby:** Реплика базы в real-time (failover за минуты)
2. **Faster media:** SSD вместо HDD для backup storage
3. **Smaller backups:** Только критические данные (full restore позже)
4. **Parallel restore:** Восстанавливать несколько частей одновременно

**Best practice:** RTO должен быть определён до disaster, не во время.

</details>

---

### Вопрос 3
**Liisa:** *"Backup encrypted with GPG. Ключ хранится на том же сервере. Ransomware зашифровал сервер. Можем restore?"*

<details>
<summary>Ответ</summary>

**НЕТ!** Ключ утерян вместе с сервером.

**Правило:** Encryption key должен быть:
1. В другой локации (offsite)
2. У нескольких людей (redundancy)
3. В password manager или physical safe
4. НЕ на том же сервере, что backup

**Liisa's rule:** *"Key without backup — это то же самое, что no encryption. Бесполезно."*

</details>

---

## 💬 Диалоги персонажей

### Liisa's Wisdom

**О тестировании:**
> *"Untested backup = no backup. Test restore every month. Skype научил меня: надежда не стратегия."*

**О 3-2-1 правиле:**
> *"3 копии, 2 media, 1 offsite. Если datacenter сгорел — у тебя всё ещё есть данные. Fire не заботится о твоём бюджете."*

**О disaster recovery:**
> *"Disaster recovery план должен быть на бумаге. Когда сервер горит — ты не будешь думать ясно. Читай инструкцию."*

**О Skype опыте:**
> *"Skype — 300 миллионов пользователей. Один час downtime — миллионы потерь. Microsoft после acquisition добавил правило: test restore every week. EVERY WEEK. Мы выполняли."*

---

### Kristjan's Perspective

**О e-Estonia:**
> *"e-Estonia работает на доверии к данным. Граждане доверяют, потому что данные всегда доступны. Всегда восстанавливаются. Backup — это не IT задача. Это trust задача."*

**О compliance:**
> *"В e-Government мы обязаны хранить backups 7 лет. By law. И мы обязаны доказать, что можем restore. Audit каждый год. Это не опция."*

---

### Anna's Incident Response

**Анализ атаки:**
> *"Krylov был внутри 72 часа. Backdoor запускался через cron каждые 5 минут. Постепенно удалял данные. Умно — не сразу заметно. Incremental backups за 3 дня — скомпрометированы. Нужен backup до атаки."*

**Forensics:**
> *"Логи показывают: первое подозрительное событие — 3 дня назад, 03:47. Cron job `/var/lib/.krylov_backdoor.sh`. Krylov signature. Restore from 4 days ago — чистый."*

---

### Max's Learning

**После disaster:**
> *"Я думал, backup — это просто 'скопировать файлы'. Теперь понимаю: это целая система. Backup, testing, monitoring, documentation, automation. Каждая часть критична."*

**После restore testing:**
> *"Мы протестировали restore. Оказалось, один backup битый. Если бы не тестировали — узнали бы только в disaster. Liisa права: untested backup = no backup."*

---

### LILITH's Comments

**О backup философии:**
> *"Backup — это страхование. Ты платишь сейчас (storage, время), чтобы не потерять всё потом. Админы, которые экономят на backup — играют в русскую рулетку."*

**О human factor:**
> *"Лучший backup system бесполезен, если люди не знают, как restore. Document everything. Train everyone. Test regularly. Иначе это просто дорогие файлы на диске."*

**О Krylov:**
> *"Krylov умный. Он не удалил данные сразу. Он ждал, пока incremental backups станут скомпрометированными. 72 часа — достаточно, чтобы уничтожить несколько поколений backup. Но он не знал про offsite. Ошибка."*

---

## 🏆 Итоги Episode 12

### Что ты освоил:

**Технические навыки:**
- ✅ Backup strategies (full, incremental, differential)
- ✅ `rsync` для эффективного backup
- ✅ `tar` для архивов
- ✅ Remote backup через SSH
- ✅ Автоматизация с cron
- ✅ Restore testing procedures
- ✅ 3-2-1 backup rule
- ✅ Disaster recovery planning

**Soft skills:**
- ✅ Работа под давлением (disaster scenario)
- ✅ Документирование процедур
- ✅ Тестирование критических систем
- ✅ Планирование recovery procedures

---

### Сертификат от Liisa

```
╔══════════════════════════════════════════════════════════╗
║                                                          ║
║              BACKUP & DISASTER RECOVERY                  ║
║                   CERTIFICATION                          ║
║                                                          ║
║  Max Sokolov successfully completed training in          ║
║  backup strategies and disaster recovery procedures.     ║
║                                                          ║
║  Skills demonstrated:                                    ║
║  - Full, incremental, differential backups               ║
║  - Remote offsite backup configuration                   ║
║  - Restore testing and verification                      ║
║  - Disaster recovery under pressure                      ║
║                                                          ║
║  "Untested backup = no backup. Max tested. Max knows."  ║
║                                                          ║
║  Certified by: Liisa Kask                                ║
║  Former Skype Backup Engineer                            ║
║  Date: October 24, 2025                                  ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

---

### Финальная сцена Episode 12

**08:30. E-Residency office. Backup восстановлен.**

**Liisa** (закрывает laptop):
*"Max, ты справился. Production data восстановлены. Потеряли неделю, но это acceptable. Теперь у нас правильный backup system: automated, tested, monitored. Offsite копии. Всё как надо."*

**Kristjan:**
*"В e-Estonia мы говорим: 'Data без backup — это временные данные'. Сейчас ваши данные — permanent. Protected. Liisa научила тебя well."*

**Max:**
*"Liisa, спасибо. Ночная disaster была... интенсивной. Но я многому научился."*

**Liisa** (улыбается):
*"Best lessons learned under pressure. Skype научил меня так. Теперь я научила тебя. Pass it forward."*

**Viktor** (видеозвонок):
*"Max, Season 3 завершён. Санкт-Петербург и Таллин дали тебе solid foundation в system administration. Users, permissions, processes, logs, disks, backups — всё освоено. Ready for Season 4?"*

**Max:**
*"Куда дальше?"*

**Viktor:**
*"Европа. Амстердам и Берлин. DevOps и автоматизация. Docker, Kubernetes, CI/CD. Dmitry встретит тебя в Амстердаме. 50 серверов вручную настраивать не будем. Автоматизация — наша следующая цель."*

**Liisa:**
*"Max, last advice: backup это не 'set and forget'. Это живой процесс. Check logs. Test restore. Update procedures. Если будут вопросы — пиши. Skype alumni помогают друг другу."*

**Kristjan:**
*"И приезжай в Таллин снова. E-Estonia всегда рады гостям. Especially тем, кто понимает важность надёжных систем."*

**Max** (выходит из office, Old Town Таллина, средневековые башни):
*"Две недели в России и Эстонии. Санкт-Петербург — Unix традиции. Таллин — e-Government expertise. Многому научился. Теперь — дальше на запад. Амстердам. DevOps. Новый уровень."*

**LILITH:**
*"Season 3 complete. System administration освоен. Backup tested. Data safe. Next: automation. Next: scale. Next: production infrastructure как искусство. Amsterdam ждёт. Docker контейнеры. Kubernetes оркестрация. 50 серверов одной командой. Ready?"*

**Max** (садится в поезд Tallinn → Amsterdam):
*"Ready."*

---

## 🎓 Season 3 Complete! 🎉

**Что ты прошёл в Season 3:**

| Episode | Тема | Персонаж | Локация |
|---------|------|----------|---------|
| **09** | Users & Permissions | Andrei Volkov | СПб 🇷🇺 |
| **10** | Processes & SystemD | Boris Kuznetsov | СПб 🇷🇺 |
| **11** | Disk Management & LVM | Kristjan Tamm | Tallinn 🇪🇪 |
| **12** | Backup & Recovery | Liisa Kask | Tallinn 🇪🇪 |

**Навыки Season 3:**
- ✅ User management (useradd, sudo, ACL)
- ✅ Process management (ps, systemd, journalctl)
- ✅ Disk management (LVM, RAID, fstab)
- ✅ Backup strategies (rsync, tar, disaster recovery)

**Следующий Season:**
- **Season 4:** DevOps & Automation 🇳🇱🇩🇪
- **Локации:** Amsterdam → Berlin
- **Темы:** Git, Docker, CI/CD, Ansible
- **Персонажи:** Hans Müller (CCC), Sophie van Dijk (Docker), Klaus Schmidt (Ansible)

---

<div align="center">

**"Untested backup = no backup."**

*Season 3: SYSTEM ADMINISTRATION — COMPLETE! 🎓*

**KERNEL SHADOWS**

[⬅ Episode 11](../episode-11-disk-management-lvm/README.md) | [Season 4 →](../../season-4-devops-automation/README.md)

</div>


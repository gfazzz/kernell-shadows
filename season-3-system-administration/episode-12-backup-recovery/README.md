# EPISODE 12: BACKUP & RECOVERY
## Season 3: System Administration | Tallinn, Estonia 🇪🇪 (Финал Season 3)

> *"Untested backup = no backup. Test restore every month."* — Liisa Kask

---

## 📍 Контекст миссии

**Локация:** 🇪🇪 Tallinn, Estonia (финал Season 3)  
**Место:** e-Residency backup facility, Skype Tallinn Office (legacy)  
**День операции:** 23-24 из 60 (финал Season 3)  
**Время прохождения:** 4-5 часов  
**Сложность:** ⭐⭐⭐⭐⭐  

**Персонажи:**
- **Макс Соколов** — вы, изучаете backup strategies под давлением
- **Liisa Kask** — backup engineer, ex-Skype, главный ментор
- **Kristjan Tamm** — e-Government architect (поддержка)
- **Анна Ковалева** — forensics expert (remote, координирует incident response)
- **Виктор Петров** — координатор операции
- **LILITH** — AI-помощник (я!)

---

## 🎬 Сюжет: Emergency Restore (03:47 Night Call)

### День 23. 03:47. Кошмар системного администратора.

Макс спит в отеле в Старом городе Таллина. Резкий звонок телефона разрывает тишину ночи.

**Анна Ковалева** (голос напряжённый, задыхается):  
*"Макс, проснись. НЕМЕДЛЕННО. Атака. Крылов. Production server скомпрометирован. База данных удалена. 4.3 GB данных. GONE. Нужен restore. СЕЙЧАС."*

**Макс** (дезориентирован, хватает laptop):  
*"Что?! Какая база? У нас есть backup?"*

**Анна:**  
*"НЕ ЗНАЮ! Ты админ, ТЫ должен знать! У тебя 10 минут. Бизнес-критические данные. Если не восстановим — операция провалена. Финансовые потери — миллионы. Звони Liisa Kask. Она эксперт по backup. Номер отправляю. БЕГИ!"*

Макс звонит Liisa (03:52, глубокая ночь).

**Liisa** (сонный голос → через 2 секунды полностью проснулась):  
*"Max? 3:52 AM. Что случилось?"*

**Макс** (паника в голосе):  
*"Атака Крылова! База удалена! 4.3 GB данных! Анна сказала звонить тебе! У нас ЕСТЬ backup?!"*

**Liisa** (пауза 3 секунды, глубокий вдох, потом спокойно, как хирург перед операцией):  
*"Okay. Breathe, Max. Паника убивает. Foc us. Three questions:  
1. Когда последний backup?  
2. Где хранится?  
3. Ты проверял целостность backup?  
Answer. Now."*

**Макс** (голос дрожит):  
*"Не знаю... Не знаю... И не знаю..."*

**Liisa** (долгий вздох, знакомая история):  
*"Classic. Backup без проверки — это not backup, это self-deception. Russian roulette с данными. Meet me at e-Residency office. 15 minutes. Bring STRONG coffee. Two cups. We have long night ahead."*

---

### 04:10. E-Residency backup facility. War room.

Liisa уже за компьютером, три монитора светятся в темноте, terminals открыты. Руки летают по клавиатуре. На столе — пустая чашка из-под кофе.

**Liisa** (не отрываясь от экрана):  
*"Okay, Max. Sit. Watch. Learn. Lesson one: **'Untested backup = no backup.'**  
Я работала на Skype в Таллине. Skype — это было 300 миллионов пользователей. Один час downtime — миллионы долларов потерь. Мы тестировали backup **каждую неделю**. КАЖДУЮ. Не месяц. Не год. НЕДЕЛЮ."*

**Макс** (ставит кофе, руки трясутся):  
*"У нас есть backup? ЕСТЬ?!"*

**Liisa** (проверяет, хмурится):  
*"Yes. Последний backup — вчера в 02:00. Automated. Но... (долгая пауза) ...никто не проверял restore. Надеемся, что работает."*

**Макс:**  
*"Надеемся?! А если НЕ работает?!"*

**Liisa** (поворачивается, смотрит прямо в глаза):  
*"Тогда мы очень быстро научимся forensics и попытаемся восстановить через `extundelete`, `testdisk`, молитвы и удачу. But that's plan Z. Let's try plan A first: restore from backup. Если plan A fail — у нас есть plan B through Y. But I prefer plan A."*

---

### 04:30. Forensics. Хуже, чем думали.

**Kristjan** (заходит с термосом кофе, выглядит уставшим):  
*"Liisa called me. Bad night, Max. But good lesson. В e-Estonia мы говорим: 'Data без backup — это temporary data'. Сейчас узнаем, permanent ли ваши данные."*

**Liisa** (анализирует логи):  
*"Kristjan, у нас последний backup от вчера 02:00. Это 26 часов назад. Сколько данных потеряно?"*

**Анна** (видеозвонок, экран forensics terminal):  
*"Мax, я нашла backdoor. `/var/lib/.krylov_backdoor.sh`. Запускался через cron каждые 5 минут. Удалял данные **постепенно**. Умно — не сразу заметно."*

**Liisa:** *"Когда началась атака?"*

**Анна:**  
*"Forensics показывает: первое подозрительное событие — **3 дня назад**, 03:47 (та же минута!). Krylov signature. Они были внутри 72 часа. Постепенно уничтожали данные."*

**Liisa** (закрывает глаза, считает в уме):  
*"72 hours? Значит incremental backups за последние 3 дня — **скомпрометированы**. Corrupted data в backup. Нужен full backup от **недели назад**. Last clean backup. Потеряем данные за неделю, но это clean data."*

**Макс:**  
*"Неделя данных — это МНОГО..."*

**Liisa** (холодно):  
*"Альтернатива — **ноль** данных. Forever. Choose."*

**Kristjan:**  
*"Restore from last clean backup. We'll recreate lost week manually if needed. **Data integrity > data freshness**. Always."*

---

### 06:30. Restore complete. Testing phase.

**Liisa** (проверяет checksums, ждёт):  
*"Database restored. Size: 4.2 GB (expected 4.3 GB). Close enough, 100MB — logs maybe. Running checksums... (30 секунд тишины) ...SHA256: **MATCH**! Backup был хороший. Thank God и нашему cron job."*

**Макс:**  
*"Мы восстановились?! Это ВСЁ?!"*

**Liisa** (качает головой):  
*"Not yet, Max. Restore — это 50%. Testing — вторая 50%. Skype rule: **'Restore without testing — это Russian roulette.'**  
Сейчас проверим:  
1. Database integrity (tables, indexes, foreign keys)  
2. Application functionality (может запуститься?)  
3. Data consistency (логика не нарушена?)  
4. User access (permissions OK?)  
Только после всех проверок — success."*

Liisa запускает тесты. Макс смотрит, как строки летят по экрану.

```
[✓] Tables: 127/127 OK
[✓] Indexes: 412/412 rebuilt
[✓] Foreign keys: OK
[✓] Application: Started successfully
[✓] User login: OK
[✓] Data consistency: PASS
```

**Liisa** (первая улыбка за эту ночь):  
*"**SUCCESS**. Данные восстановлены. Приложение работает. Integrity confirmed. Max, ты только что пережил disaster recovery в production. Under pressure. Congratulations. Most admins паникуют. Ты справился."*

---

## 🎯 Твоя миссия

После emergency restore Liisa учит тебя правильной backup стратегии.

**Цели:**
1. 💾 Понять backup strategies (full, incremental, differential, 3-2-1 rule)
2. 🔧 Настроить автоматические backups (rsync, tar, systemd timers)
3. 🌐 Создать offsite backup (remote server, SSH keys)
4. ✅ Научиться тестировать restore procedures
5. 📊 Мониторинг backup health (logrotate, health checks)
6. 📖 Документация disaster recovery планов
7. 🔐 Безопасность backups (encryption, immutable backups)

**Итог:** Production-ready backup система, которая выдержит атаку Крылова.

---

## Цикл 1: Backup Философия — "Untested = No Backup" (15 минут)

### 🎬 Сюжет (2 мин)

**08:00. После успешного restore. Liisa объясняет философию.**

**Макс:**  
*"Liisa, мы восстановились. Но... как это могло случиться? Backup был, но мы не знали, работает ли он."*

**Liisa** (кивает):  
*"Классика. 90% компаний так живут. Backup есть. Никто не проверяет. Disaster happens → panic → maybe backup работает, maybe нет. Russian roulette.  
Skype научил меня: backup без testing — это not insurance, это **false sense of security**. Опаснее, чем вообще без backup, потому что ты думаешь, что защищён."*

**Kristjan:**  
*"В e-Government мы обязаны тестировать restore каждый квартал. By law. Audit проверяет. Если не можем restore — штраф, увольнение, скандал. Data — это trust. No data — no trust."*

**LILITH:**  
*"Backup — это страховка. Ты платишь сейчас (storage, время), чтобы не потерять всё потом. Админы, которые экономят на backup — играют в русскую рулетку. С данными компании."*

---

### 📚 Теория: 3-2-1 Backup Rule (7 мин)

#### Представь: Backup = Страховка дома

**Метафора:**

Твой дом (production data) может сгореть от пожара (hardware failure), быть затоплен (ransomware), или ограблен (Krylov атака).

**Плохая страховка:**  
```
🏠 Дом
📄 Полис страховки в доме (на полке)
🔥 Пожар → дом сгорел → полис тоже сгорел → нет страховки
```

**Хорошая страховка (3-2-1 rule):**  
```
🏠 Дом (original data)
📄 Полис дома (local backup)
📄 Копия у друга в другом городе (offsite backup)
📄 Копия на другом носителе - в банке (cloud/tape)
```

**Если дом сгорел → у друга есть полис → восстанавливаешь.**

---

#### The 3-2-1 Backup Rule (from Skype)

**Правило Liisa:**

```
3 COPIES of data:
  ┌─────────────────────────────────────┐
  │ 1. Original (production)            │  ← /data на сервере
  │ 2. Local backup (same server/DC)    │  ← /backup на другом диске
  │ 3. Offsite backup (remote location) │  ← remote:/backup (другой город)
  └─────────────────────────────────────┘

2 DIFFERENT MEDIA types:
  ┌──────────────────────────────┐
  │ Media 1: HDD (fast restore)  │
  │ Media 2: Cloud / Tape / SSD  │  ← разные технологии
  └──────────────────────────────┘

1 OFFSITE copy:
  ┌──────────────────────────────────────┐
  │ Physically different location        │  ← Защита от fire/flood/theft
  │ Different city/country/datacenter    │
  └──────────────────────────────────────┘
```

**Почему это важно:**

| Disaster | Без 3-2-1 | С 3-2-1 |
|----------|-----------|---------|
| 💥 Диск сгорел | ❌ Потеряли всё | ✅ Restore с backup диска |
| 🔥 Datacenter пожар | ❌ Потеряли всё | ✅ Restore с offsite |
| 🦠 Ransomware | ❌ Всё зашифровано | ✅ Restore с offline backup |
| 💣 Krylov атака | ❌ Удалил prod + backup | ✅ Restore с offsite (он не достал) |

**LILITH:**  
*"Krylov умный. Он не просто удалил production. Он ждал, пока incremental backups станут скомпрометированными (72 часа). Но он не знал про offsite backup недельной давности. Ошибка. Наша удача."*

---

#### Microsoft's 4th Rule (после acquisition Skype)

Microsoft добавил 4-е правило:

```
3-2-1 + T = 3-2-1-T Rule

T = TESTING
  ├─ Test restore every month (minimum)
  ├─ Document recovery procedures
  ├─ Measure RTO (Recovery Time Objective)
  └─ Train team на disaster scenarios
```

**Liisa:**  
*"Microsoft прав. 3-2-1 без testing — это 3-2-1-0. Ноль реальной защиты."*

---

### 💻 Практика: Проверь свой риск (5 мин)

**Задание:** Оцени backup риск твоей текущей системы.

Заполни чеклист:

```
[ ] У меня есть backup (любой)
[ ] Backup автоматический (не вручную)
[ ] Backup на другом диске (не том же, где production)
[ ] Backup в другой локации (offsite)
[ ] Я тестировал restore хотя бы раз
[ ] Я тестирую restore регулярно (каждый месяц)
[ ] У меня есть документация disaster recovery
[ ] Backup зашифрован
[ ] У меня есть мониторинг backup health
[ ] Я знаю RTO (сколько времени restore занимает)
```

**Подсчёт:**
- **0-3 галочки:** 🔴 CRITICAL — ты один disaster от потери всех данных
- **4-6 галочек:** 🟡 WARNING — базовая защита есть, но gaps опасные
- **7-8 галочек:** 🟢 GOOD — надёжная система, но есть что улучшить
- **9-10 галочек:** 🟢 EXCELLENT — Liisa approves, Skype-level

**Liisa:**  
*"Если у тебя меньше 7 — ты играешь с огнём. Один ransomware, один Krylov, один hardware failure — и game over. Fix it. Now."*

---

### 🤔 Проверка понимания

**LILITH:** *"Quick quiz: Krylov удалил production и local backup. Почему мы смогли восстановиться?"*

<details>
<summary>🤔 Думай 30 секунд перед ответом</summary>

**Ответ:** **Offsite backup** (3-2-1 rule: copy #3).

Krylov был внутри сервера, но не имел доступа к remote backup server в другой локации. **1 OFFSITE copy** спасла операцию.

**Aha! момент:**  
Если бы backup был только на том же сервере (или даже на другом диске на том же сервере), Krylov мог бы удалить всё. **Physical separation = survival**.

**Liisa:**  
*"Offsite — это не опция. Это requirement. Fire не спрашивает, где твой backup."*

</details>

---

## Цикл 2: Backup Strategies — Full vs Incremental vs Differential (15 минут)

### 🎬 Сюжет (2 мин)

**Liisa** (рисует на доске timeline):  
*"Max, вопрос: почему incremental backups за 3 дня были скомпрометированы, но full backup недельной давности — clean?  
Потому что типы backup работают по-разному. Понимание разницы — critical для disaster recovery."*

**Макс:**  
*"Full backup — это просто копия всего, right?"*

**Liisa:**  
*"Yes, но есть 3 стратегии: Full, Incremental, Differential. Каждая — trade-off между speed, storage, и recovery complexity. Skype использовал все три. В зависимости от data type."*

---

### 📚 Теория: Три стратегии backup (7 мин)

#### Представь: Backup = Фотография документов

**Метафора:**

У тебя стопка документов (data). Каждый день добавляются новые листы, редактируются старые.

**3 способа делать копии:**

1. **Full Backup = Переснять ВСЮ стопку**
   - 📸 Понедельник: сфотографировал все 100 страниц
   - 📸 Вторник: сфотографировал все 105 страниц (добавилось 5)
   - 📸 Среда: сфотографировал все 110 страниц
   
   **Плюс:** Restore простой (одна фотосессия)  
   **Минус:** Медленно, много места

2. **Incremental = Снимать только НОВЫЕ/ИЗМЕНЁННЫЕ страницы**
   - 📸 Понедельник: ВСЯ стопка (full backup)
   - 📸 Вторник: только 5 новых страниц
   - 📸 Среда: только 5 новых страниц
   
   **Плюс:** Быстро, мало места  
   **Минус:** Restore сложный (нужны ВСЕ фотосессии)

3. **Differential = Снимать ВСЁ изменённое с последнего FULL**
   - 📸 Понедельник: ВСЯ стопка (full)
   - 📸 Вторник: 5 новых (с понедельника)
   - 📸 Среда: 10 новых (5 вт + 5 ср, все с понедельника)
   
   **Плюс:** Restore проще чем incremental (full + последний diff)  
   **Минус:** Растёт со временем

---

#### Visual Timeline: 7 Days of Backups

```
Стратегия: Full Weekly + Incremental Daily

Day:    Sun    Mon    Tue    Wed    Thu    Fri    Sat
Data:   100GB  +2GB   +3GB   +1GB   +5GB   +2GB   +4GB
        ───────────────────────────────────────────────
Backup: FULL   incr   incr   incr   incr   incr   incr
Size:   100GB  2GB    3GB    1GB    5GB    2GB    4GB

Total storage: 100 + 2 + 3 + 1 + 5 + 2 + 4 = 117GB

💥 Disaster в субботу!

Restore steps:
  1️⃣ Restore FULL (воскресенье) = 100GB
  2️⃣ Restore incr (понедельник) = +2GB
  3️⃣ Restore incr (вторник) = +3GB
  4️⃣ Restore incr (среда) = +1GB
  5️⃣ Restore incr (четверг) = +5GB
  6️⃣ Restore incr (пятница) = +2GB
  
  Total: 6 steps, 113GB data
  
⚠️ Если среда backup corrupted → теряем четверг+пятницу!
```

**vs Differential:**

```
Day:    Sun    Mon    Tue    Wed    Thu    Fri    Sat
Data:   100GB  +2GB   +3GB   +1GB   +5GB   +2GB   +4GB
        ───────────────────────────────────────────────
Backup: FULL   diff   diff   diff   diff   diff   diff
Size:   100GB  2GB    5GB    6GB    11GB   13GB   17GB
                      ↑ растёт каждый день

Total storage: 100 + 2 + 5 + 6 + 11 + 13 + 17 = 154GB

💥 Disaster в субботу!

Restore steps:
  1️⃣ Restore FULL (воскресенье) = 100GB
  2️⃣ Restore diff (пятница) = +13GB
  
  Total: 2 steps, 113GB data
  
✅ Если среда backup corrupted → пятница всё равно содержит среду!
```

---

#### Comparison Table

| Критерий | Full | Incremental | Differential |
|----------|------|-------------|--------------|
| **Backup speed** | 🐢 Медленно | 🚀 Быстро | 🐇 Средне |
| **Storage usage** | ❌ Много | ✅ Мало | ⚠️ Растёт |
| **Restore speed** | ✅ Быстро | ❌ Медленно | ⚠️ Средне |
| **Restore complexity** | ✅ Простой (1 backup) | ❌ Сложный (full + все incr) | ⚠️ Средний (full + последний diff) |
| **Failure risk** | ✅ Низкий | ❌ Высокий (цепочка) | ⚠️ Средний |

**Liisa's recommendation (Skype approach):**

```bash
# Еженедельно: Full backup (воскресенье ночью)
0 2 * * 0  /usr/local/bin/backup-full.sh

# Ежедневно: Incremental (понедельник-суббота)
0 2 * * 1-6  /usr/local/bin/backup-incremental.sh

# Ежемесячно: Archive full backup (долгое хранение)
0 3 1 * *  /usr/local/bin/backup-archive.sh
```

**Why?**
- Full weekly = гарантия чистой базы
- Incremental daily = быстро, экономит storage
- Archive monthly = compliance, long-term safety

---

### 💻 Практика: Посчитай storage (5 мин)

**Задание:** У тебя 500GB production data, +10GB изменений в день.

Посчитай storage для 30 дней:

**Option A: Full Daily**
```
500GB × 30 дней = ?
```

**Option B: Full Weekly + Incremental Daily**
```
Full: 500GB × 4 недели = ?
Incremental: 10GB × 26 дней = ?
Total = ?
```

**Option C: Full Weekly + Differential Daily**
```
Full: 500GB × 4 = ?
Diff week 1: 10+20+30+40+50+60 = ?
Diff week 2: 10+20+30+40+50+60 = ?
... (4 недели)
Total = ?
```

<details>
<summary>💡 Ответы</summary>

**Option A: Full Daily**
```
500GB × 30 = 15,000GB = 15TB
💰 Очень дорого!
```

**Option B: Incremental**
```
Full: 500 × 4 = 2,000GB
Incr: 10 × 26 = 260GB
Total = 2,260GB = 2.26TB
✅ Экономично!
```

**Option C: Differential**
```
Full: 500 × 4 = 2,000GB
Diff: (10+20+30+40+50+60) × 4 weeks = 210 × 4 = 840GB
Total = 2,840GB = 2.84TB
⚖️ Баланс
```

**Aha! момент:**  
Incremental экономит **12.74TB** storage по сравнению с full daily! Но восстановление сложнее.

**Liisa:**  
*"Storage дешёвый. Но не настолько. Incremental — это smart. Но тестируй restore!"*

</details>

---

### 🤔 Проверка понимания

**LILITH:** *"Вопрос: Krylov был внутри 72 часа. Почему incremental backups за 3 дня скомпрометированы?"*

<details>
<summary>🤔 Думай перед ответом</summary>

**Ответ:** **Incremental backups копируют изменения.**

Krylov постепенно модифицировал данные (вставлял backdoor, удалял по чуть-чуть). Каждый incremental backup копировал **уже испорченные файлы**.

Timeline:
```
Day 1: Krylov вошёл → испортил file1.txt → incremental backup скопировал испорченный file1
Day 2: Krylov испортил file2.txt → incremental backup скопировал испорченный file2
Day 3: Krylov испортил file3.txt → incremental backup скопировал испорченный file3
```

**Full backup недельной давности** был сделан **ДО** атаки → clean data.

**Aha! момент:**  
Incremental backups защищают от hardware failure, но **не от постепенной corruption**. Нужен **старый full backup** для disaster recovery.

**Liisa:**  
*"Вот почему мы храним multiple generations backups. Не только последний. Last 4 weekly, last 12 monthly. Atleast."*

</details>

---

## Цикл 3: Backup Tools — rsync, tar, dd (15 минут)

### 🎬 Сюжет (2 мин)

**Liisa** (открывает terminal):  
*"Max, backup strategy — это план. Tools — это execution. Три инструмента которые должен знать каждый Linux admin: `rsync`, `tar`, `dd`. Different tools for different jobs."*

---

### 📚 Теория: Три инструмента backup (7 мин)

#### 1. rsync — "Умный копировальный аппарат"

**Метафора:** rsync = копировальный аппарат, который помнит что уже скопировал.

```
Обычный cp:
  📄📄📄 → 📋 (копирует ВСЁ каждый раз)

rsync:
  📄📄📄 → 📋 (первый раз копирует всё)
  📄📄📄✏️ → 📋 (второй раз копирует только изменения)
```

**Команды:**
```bash
# Local backup
rsync -av --delete /data/ /backup/

# Remote backup через SSH
rsync -av -e ssh /data/ user@remote:/backup/

# Incremental с hard links
rsync -av --link-dest=/backup/previous /data/ /backup/current/

# С progress bar
rsync -av --progress /data/ /backup/
```

**Флаги:**
- `-a` (archive) = preserve all (permissions, timestamps, links)
- `-v` (verbose) = показывать файлы
- `--delete` = удалить из backup то что удалено из source
- `-e ssh` = использовать SSH
- `--link-dest` = hard links для incremental

**LILITH:** *"rsync — это Swiss Army knife backup. 90% задач решает. Learn it well."*

---

#### 2. tar — "Архиватор"

**Метафора:** tar = упаковщик коробок. Складывает всё в один архив.

```
Files:         Archive:
📄 file1.txt
📄 file2.txt   →   📦 archive.tar.gz (compressed)
📄 file3.txt
```

**Команды:**
```bash
# Создать archive
tar -czf backup.tar.gz /data

# С исключениями
tar -czf backup.tar.gz --exclude='*.log' /data

# Извлечь
tar -xzf backup.tar.gz -C /restore/

# Список содержимого
tar -tzf backup.tar.gz

# Checksum после создания
sha256sum backup.tar.gz > backup.tar.gz.sha256
```

**Флаги:**
- `-c` = create
- `-x` = extract
- `-z` = gzip compression
- `-f` = file
- `-t` = list contents
- `-v` = verbose

**Когда использовать tar:**
- Full backups (archive всей директории)
- Долгое хранение (monthly archives)
- Transfer через network (один файл проще чем тысячи)

---

#### 3. dd — "Побайтовый клонер" ⚠️

**Метафора:** dd = photocopier для дисков. Копирует **всё побайтово**, включая пустое место.

```
Source disk:      Destination:
┌──────────────┐  ┌──────────────┐
│ 💾 Data      │  │ 💾 Data      │
│ ⬜ Empty     │→ │ ⬜ Empty     │  (копирует даже пустоту!)
│ 🗑️ Deleted   │  │ 🗑️ Deleted   │  (и удалённые данные!)
└──────────────┘  └──────────────┘
```

**Команды:**
```bash
# Backup whole disk
dd if=/dev/sda of=/backup/disk.img bs=4M status=progress

# Backup partition
dd if=/dev/sda1 of=/backup/partition.img bs=4M

# Restore disk
dd if=/backup/disk.img of=/dev/sda bs=4M status=progress

# Create bootable USB
dd if=ubuntu.iso of=/dev/sdb bs=4M && sync
```

**⚠️ DANGER:** `dd` = "Disk Destroyer" если перепутаешь `if` и `of`!

**Когда использовать dd:**
- Backup целых дисков (forensics, клонирование)
- Создание disk images
- Bootable media

**Liisa:** *"dd powerful, но dangerous. One typo → data destroyed. Triple-check before Enter."*

---

#### Comparison Table

| Tool | Best for | Speed | Compression | Incremental | Difficulty |
|------|----------|-------|-------------|-------------|------------|
| **rsync** | Files/dirs, incremental | ⚡⚡⚡ Fast | ❌ No | ✅ Yes | ⭐⭐ Easy |
| **tar** | Archives, full backup | ⚡⚡ Medium | ✅ Yes | ❌ No | ⭐ Very easy |
| **dd** | Whole disks | ⚡ Slow | ❌ No | ❌ No | ⭐⭐⭐ Hard |

**Liisa's recommendation:**
- **Daily backups:** rsync (fast, incremental)
- **Weekly archives:** tar (compressed, portable)
- **Disaster recovery images:** dd (complete disk clone)

---

### 💻 Практика: Три backup в одном (5 мин)

**Задание:** Создай backup трём способами, сравни результаты.

```bash
# Setup test data
mkdir -p /tmp/test-data
for i in {1..100}; do
    echo "File $i content" > /tmp/test-data/file$i.txt
done

# 1. rsync backup
time rsync -av /tmp/test-data/ /tmp/backup-rsync/

# 2. tar backup
time tar -czf /tmp/backup-tar.tar.gz /tmp/test-data

# 3. dd backup (if you have test partition)
# time dd if=/dev/sda1 of=/tmp/backup-dd.img bs=4M status=progress

# Compare sizes
du -sh /tmp/backup-rsync
du -sh /tmp/backup-tar.tar.gz

# Test restore speed
time tar -xzf /tmp/backup-tar.tar.gz -C /tmp/restore-tar/
time rsync -av /tmp/backup-rsync/ /tmp/restore-rsync/
```

**Questions:**
1. Какой метод быстрее для backup?
2. Какой занимает меньше места?
3. Какой быстрее для restore?

<details>
<summary>💡 Answers</summary>

**Обычно:**
1. **rsync fastest** (копирует только данные, не compression overhead)
2. **tar smallest** (gzip compression)
3. **rsync fastest restore** (no decompression needed)

**Aha! момент:**  
rsync лучше для daily backups (speed), tar лучше для archives (compression).

</details>

---

## Цикл 4: Automation — Cron + Systemd Timers (15 минут)

### 🎬 Сюжет (2 мин)

**Liisa:**  
*"Manual backup — это not backup, это **luck**. Humans forget. Humans делают ошибки. Automation — единственный способ гарантировать backups happen. Every day. Every week. No exceptions."*

**Kristjan:**  
*"В e-Estonia всё automated. Citizens не должны помнить 'сделать backup паспорта'. System делает это автоматически. Government backup — тоже автоматически. No human factor."*

---

### 📚 Теория: Cron vs Systemd Timers (7 мин)

#### Old School: cron

**Метафора:** cron = будильник. Срабатывает в определённое время каждый день/неделю/месяц.

```
Cron:
  🕐 02:00 каждое воскресенье → 📦 Full backup
  🕐 02:00 понедельник-суббота → 📋 Incremental backup
  🕐 03:00 каждый день → ☁️ Offsite sync
```

**Syntax:**
```
* * * * * command
│ │ │ │ │
│ │ │ │ └─ day of week (0-7, 0=Sunday)
│ │ │ └─── month (1-12)
│ │ └───── day of month (1-31)
│ └─────── hour (0-23)
└───────── minute (0-59)
```

**Примеры:**
```bash
# Full backup каждое воскресенье в 02:00
0 2 * * 0 /usr/local/bin/backup-full.sh

# Incremental ежедневно (кроме воскресенья) в 02:00
0 2 * * 1-6 /usr/local/bin/backup-incremental.sh

# Offsite sync в 03:00
0 3 * * * /usr/local/bin/backup-offsite.sh

# Cleanup старых backups каждый понедельник в 04:00
0 4 * * 1 /usr/local/bin/backup-cleanup.sh
```

**Установка:**
```bash
# Edit crontab
crontab -e

# View crontab
crontab -l

# Logs
grep CRON /var/log/syslog
```

**Минусы cron:**
- ❌ Если сервер был выключен в 02:00 → backup пропущен
- ❌ Нет dependency management
- ❌ Нет automatic retry on failure
- ❌ Логирование базовое

---

#### Modern Way: systemd timers

**Метафора:** systemd timer = умный будильник. Если проспал — срабатывает при пробуждении.

```
Systemd Timer:
  ⏰ Scheduled: 02:00
  💤 Server off at 02:00
  🔌 Server boots at 10:00
  ✅ Timer: "Oh, I missed! Running now!"
```

**Структура:**
```
backup-full.service   ← что делать (backup script)
backup-full.timer     ← когда делать (schedule)
```

**Example: backup-full.timer**
```ini
[Unit]
Description=Full Backup Timer
Documentation=https://kernel-shadows.com/episode-12

[Timer]
# Run every Sunday at 02:00
OnCalendar=Sun *-*-* 02:00:00

# If missed (system was off), run on boot
Persistent=true

# Run 5min after boot if schedule missed
OnBootSec=5min

[Install]
WantedBy=timers.target
```

**Example: backup-full.service**
```ini
[Unit]
Description=Full Backup Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup-full.sh
StandardOutput=journal
StandardError=journal
SyslogIdentifier=backup-full

# Security
NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

**Управление:**
```bash
# Установить timer
sudo systemctl enable backup-full.timer
sudo systemctl start backup-full.timer

# Status
sudo systemctl status backup-full.timer
sudo systemctl list-timers

# Logs
sudo journalctl -u backup-full.service -f

# Запустить вручную (для тестирования)
sudo systemctl start backup-full.service
```

**Плюсы systemd:**
- ✅ Persistent (догоняет пропущенные runs)
- ✅ Dependencies (After=network.target)
- ✅ Automatic retry
- ✅ Centralized logging (journalctl)
- ✅ Resource limits (CPUQuota, MemoryLimit)

**LILITH:** *"cron — это legacy. systemd timers — это modern Linux. Learn both, но предпочитай systemd где возможно."*

---

### 💻 Практика: Автоматизация backup (5 мин)

**Задание:** Создай systemd timer для ежедневного backup.

<details>
<summary>💡 Step-by-step</summary>

1. **Создать service:**
```bash
sudo tee /etc/systemd/system/backup-daily.service > /dev/null << 'EOF'
[Unit]
Description=Daily Backup Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup-manager.sh backup_incremental
StandardOutput=journal
StandardError=journal
SyslogIdentifier=backup-daily

[Install]
WantedBy=multi-user.target
EOF
```

2. **Создать timer:**
```bash
sudo tee /etc/systemd/system/backup-daily.timer > /dev/null << 'EOF'
[Unit]
Description=Daily Backup Timer

[Timer]
OnCalendar=daily
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF
```

3. **Активировать:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable backup-daily.timer
sudo systemctl start backup-daily.timer
sudo systemctl list-timers
```

4. **Проверить логи:**
```bash
sudo journalctl -u backup-daily.service -f
```

</details>

---

### 🤔 Проверка понимания

**LILITH:** *"Вопрос: Server выключен каждую ночь с 00:00 до 08:00. Backup schedule: 02:00. Что произойдёт с cron vs systemd timer?"*

<details>
<summary>🤔 Думай</summary>

**Cron:**
❌ Backup **пропущен**. Cron не запускает пропущенные задачи. Завтра в 02:00 попытается снова.

**Systemd timer (с Persistent=true):**
✅ Backup **запустится** после boot в 08:00 (OnBootSec=5min). Systemd помнит пропущенные runs.

**Aha! момент:**  
Для критических задач (backup!) используй **systemd timer с Persistent=true**. Это гарантирует execution даже если сервер был offline.

**Liisa:** *"Persistent=true saved our ass multiple times на Skype. Server maintenance, reboots, power issues — backup всегда выполнялся. Eventually."*

</details>

---

## Цикл 5: Offsite & Security — SSH, Encryption, Immutable (15 минут)

### 🎬 Сюжет (2 мин)

**Liisa:**  
*"Max, offsite backup спас нас от Krylov. Но offsite — это новая attack surface. SSH keys, encryption, immutable backups — это не optional, это **required**."*

**Анна** (видеозвонок):  
*"Krylov искал SSH keys на сервере. Пытался получить доступ к remote backup. Но keys были encrypted. Он не смог. Defence in depth работает."*

---

### 📚 Теория: Безопасность backups (8 мин)

#### 1. SSH Keys (no passwords!)

**Метафора:** SSH key = пропуск в здание. Пароль = запомнить код (можно подсмотреть). Key = физический ключ (нельзя украсть удалённо).

```bash
# 1. Generate key (ed25519 — современный, быстрый, безопасный)
ssh-keygen -t ed25519 -f ~/.ssh/backup_key -N "" -C "backup@$(hostname)"

# 2. Copy к remote server
ssh-copy-id -i ~/.ssh/backup_key.pub backup@remote-server

# 3. Использовать в rsync
rsync -av -e "ssh -i ~/.ssh/backup_key" /data/ backup@remote:/backup/

# 4. Защитить key
chmod 600 ~/.ssh/backup_key
```

**⚠️ SECURITY:**
- Private key NEVER на remote server!
- Private key encrypted if possible (passphrase)
- Backup private key в safe place (offsite!)

---

#### 2. Encryption

**Метафора:** Encryption = сейф. Даже если украли backup, без ключа — бесполезно.

```bash
# Encrypt backup с GPG
tar -czf - /data | gpg --encrypt -r admin@example.com > backup.tar.gz.gpg

# Decrypt restore
gpg --decrypt backup.tar.gz.gpg | tar -xzf - -C /restore/

# Или OpenSSL (symmetric)
tar -czf - /data | openssl enc -aes-256-cbc -salt -pbkdf2 -out backup.tar.gz.enc

# Decrypt
openssl enc -d -aes-256-cbc -pbkdf2 -in backup.tar.gz.enc | tar -xzf -
```

**Когда encryption обязателен:**
- 🏥 Medical data (HIPAA compliance)
- 💳 Financial data (PCI DSS)
- 🔐 Personal data (GDPR)
- ☁️ Cloud backups (untrusted storage)

**Liisa:** *"Encrypt everything sensitive. Storage дешёвый, lawsuits — дорогие."*

---

#### 3. Immutable Backups (ransomware protection)

**Метафора:** Immutable = янтарь. Данные застыли, изменить нельзя.

```
Normal backup:
  📦 backup.tar.gz → 🦠 Ransomware → 🔒 encrypted!

Immutable backup:
  📦 backup.tar.gz (immutable) → 🦠 Ransomware tries → ❌ Permission denied!
```

**Linux: chattr +i**
```bash
# Make immutable
chattr +i /backup/critical.tar.gz

# Test (should fail)
rm /backup/critical.tar.gz  # Operation not permitted

# Remove immutable (когда нужно удалить)
chattr -i /backup/critical.tar.gz
```

**Cloud: S3 Object Lock, Azure Immutable Blob**
```bash
# AWS S3 example
aws s3api put-object-retention   --bucket my-backups   --key backup.tar.gz   --retention Mode=COMPLIANCE,RetainUntilDate=2026-01-01
```

**LILITH:** *"Ransomware evolves. Encryption evolves. Но immutable backups — это physical law. Даже ransomware с root не может изменить. Physics wins."*

---

### 💻 Практика: Secure offsite backup (5 мин)

**Задание:** Настроить полностью безопасный offsite backup.

<details>
<summary>💡 Complete script</summary>

```bash
#!/bin/bash
# secure-offsite-backup.sh

set -euo pipefail

# Config
BACKUP_DIR="/data"
REMOTE_USER="backup"
REMOTE_HOST="backup-server.example.com"
REMOTE_PATH="/backups/$(hostname)"
SSH_KEY="$HOME/.ssh/backup_key"
GPG_RECIPIENT="admin@example.com"

# 1. Create encrypted backup
echo "Creating encrypted backup..."
BACKUP_FILE="/tmp/backup-$(date +%Y%m%d-%H%M%S).tar.gz.gpg"

tar -czf - "$BACKUP_DIR" | gpg --encrypt -r "$GPG_RECIPIENT" > "$BACKUP_FILE"

# 2. Generate checksum
sha256sum "$BACKUP_FILE" > "${BACKUP_FILE}.sha256"

# 3. Transfer to remote (SSH key auth)
echo "Transferring to remote..."
rsync -av --progress   -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no"   "$BACKUP_FILE" "${BACKUP_FILE}.sha256"   "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}/"

# 4. Make remote backup immutable (via SSH)
ssh -i "$SSH_KEY" "${REMOTE_USER}@${REMOTE_HOST}"   "chattr +i ${REMOTE_PATH}/$(basename $BACKUP_FILE)"

# 5. Cleanup local temp
rm -f "$BACKUP_FILE" "${BACKUP_FILE}.sha256"

echo "✓ Secure offsite backup complete"
```

**Security layers:**
1. ✅ SSH key authentication (no password)
2. ✅ GPG encryption (data encrypted at rest)
3. ✅ Checksums (integrity verification)
4. ✅ Immutable (ransomware protection)
5. ✅ Offsite (physical separation)

**Defence in depth!**

</details>

---

## Цикл 6: Restore & Testing — Disaster Recovery Simulation (20 минут)

### 🎬 Сюжет (3 мин)

**08:30. После успешного emergency restore.**

**Liisa:**  
*"Max, мы восстановились. But you know what? Это был твой ПЕРВЫЙ real disaster recovery. Skype правило: simulate disaster every quarter. Firefighters тренируются на симуляциях. Pilots — на симуляторах. Admins должны тренироваться на disaster simulations."*

**Макс:**  
*"Как?"*

**Liisa:**  
*"Просто. Создаёшь test environment. Делаешь backup. Удаляешь данные. Restore. Verify. Measure time. Document. Repeat every month. Boring? Yes. Life-saving? Absolutely."*

---

### 📚 Теория: Disaster Recovery Testing (8 мин)

#### The Restore Testing Cycle

```
1. BACKUP
   ├─ Create test data
   ├─ Backup с checksums
   └─ Store backup

2. DISASTER (simulate!)
   ├─ Delete production data
   ├─ OR encrypt (ransomware simulation)
   └─ OR corrupt filesystem

3. RESTORE
   ├─ Identify backup to restore from
   ├─ Verify backup integrity (checksums)
   ├─ Restore data
   └─ Measure time (RTO!)

4. VERIFY
   ├─ Checksum verification
   ├─ Application functionality test
   ├─ Data consistency checks
   └─ User access test

5. DOCUMENT
   ├─ What worked?
   ├─ What failed?
   ├─ How long it took?
   └─ What to improve?

6. IMPROVE
   └─ Update procedures based on learnings
```

---

#### Key Metrics

**RTO (Recovery Time Objective):**  
*How long can you afford to be down?*

```
Business says: "We lose $10K/hour downtime"
You calculate: "Restore takes 2 hours"
RTO = 2 hours → acceptable IF business accepts $20K loss

If not acceptable → need faster restore:
  - Faster media (SSD vs HDD)
  - Smaller backups (only critical data first)
  - Hot standby (replica running)
```

**RPO (Recovery Point Objective):**  
*How much data can you afford to lose?*

```
Backup every 24 hours → RPO = 24 hours
Disaster at 23:59 → lose almost 24 hours of data

If RPO too high:
  - More frequent backups (every hour?)
  - Continuous replication
  - Transaction logs
```

**Liisa:** *"Skype RTO = 1 hour, RPO = 15 minutes. Expensive? Yes. Necessary? Абсолютно. 300 million users don't wait."*

---

### 💻 Практика: Krylov Attack Simulation (9 мин)

**Задание:** Симулируй точный сценарий из сюжета.

**Scenario:**  
Day 1-3: Krylov постепенно удаляет данные через backdoor.  
Day 3, 03:47: Анна обнаруживает. Нужен restore.

<details>
<summary>💡 Complete simulation script</summary>

```bash
#!/bin/bash
# krylov-simulation.sh

set -e

echo "=== KRYLOV ATTACK SIMULATION ==="
echo
echo "Liisa: 'This is exactly what happened. Watch and learn.'"
echo

# Setup
TEST_DIR="/tmp/krylov-sim-$$"
PROD_DIR="$TEST_DIR/production"
BACKUP_DIR="$TEST_DIR/backups"

mkdir -p "$PROD_DIR" "$BACKUP_DIR"

# DAY 0: Initial state
echo "DAY 0: Production setup (100 files, 1MB)"
for i in {1..100}; do
    echo "Production data file $i - $(date)" > "$PROD_DIR/data_$i.txt"
done
cd "$PROD_DIR" && sha256sum * > checksums_day0.txt

# Full backup (before attack)
echo "DAY 0: Creating full backup (CLEAN)"
tar -czf "$BACKUP_DIR/full-day0.tar.gz" -C "$TEST_DIR" production

# DAY 1: Normal operations + Krylov enters
echo
echo "DAY 1: Krylov enters system..."
sleep 1
for i in {101..110}; do
    echo "Normal data file $i - $(date)" > "$PROD_DIR/data_$i.txt"
done

# Krylov backdoor starts (deletes 10 files quietly)
echo "DAY 1: Krylov backdoor activated (deleting 10 files)..."
rm -f "$PROD_DIR"/data_{1..10}.txt

# Incremental backup (CORRUPTED — missing files)
echo "DAY 1: Incremental backup (CORRUPTED!)"
tar -czf "$BACKUP_DIR/incr-day1.tar.gz" -C "$TEST_DIR" production

# DAY 2: More damage
echo
echo "DAY 2: Krylov continues..."
sleep 1
rm -f "$PROD_DIR"/data_{11..20}.txt
echo "DAY 2: Incremental backup (CORRUPTED!)"
tar -czf "$BACKUP_DIR/incr-day2.tar.gz" -C "$TEST_DIR" production

# DAY 3: Anna discovers!
echo
echo "DAY 3, 03:47: ANNA DISCOVERS ATTACK!"
echo "Current state: $(ls $PROD_DIR | wc -l) files (should be 110, lost 20)"
echo

# DISASTER RECOVERY DECISION
echo "=== DISASTER RECOVERY ==="
echo "Liisa: 'Incremental backups corrupted. Need day 0 full backup.'"
echo "Max: 'We'll lose 3 days of data...'"
echo "Liisa: 'Better than losing EVERYTHING.'"
echo

# Delete ALL current data (simulate complete wipe)
echo "Simulating complete data loss..."
rm -rf "$PROD_DIR"/*

# RESTORE from day 0 (last clean backup)
echo
echo "=== RESTORING FROM DAY 0 BACKUP ==="
echo "Starting restore..."
START_TIME=$(date +%s)

tar -xzf "$BACKUP_DIR/full-day0.tar.gz" -C "$TEST_DIR"

END_TIME=$(date +%s)
RESTORE_TIME=$((END_TIME - START_TIME))

echo "✓ Restore completed in $RESTORE_TIME seconds"
echo

# VERIFICATION
echo "=== VERIFICATION ==="
cd "$PROD_DIR"

if sha256sum -c checksums_day0.txt 2>&1 | grep -q "OK"; then
    VERIFIED_COUNT=$(sha256sum -c checksums_day0.txt 2>&1 | grep -c "OK" || echo "0")
    echo "✓ Checksums verified: $VERIFIED_COUNT files"
    echo "✓ Data integrity: CONFIRMED"
else
    echo "✗ Checksum verification FAILED"
    exit 1
fi

CURRENT_COUNT=$(ls | grep data_ | wc -l)
echo "✓ Files restored: $CURRENT_COUNT"
echo

# RESULTS
echo "=== DISASTER RECOVERY RESULTS ==="
echo "RTO (Recovery Time): $RESTORE_TIME seconds"
echo "RPO (Data Loss): 3 days (day 1-3 lost)"
echo "Data Integrity: CONFIRMED (checksums match)"
echo "Files recovered: $CURRENT_COUNT / 100 original"
echo
echo "Liisa: 'Success. We survived Krylov. Barely.'"
echo
echo "LESSONS LEARNED:"
echo "  1. Test backups BEFORE disaster"
echo "  2. Keep multiple backup generations"
echo "  3. Offsite backups saved us"
echo "  4. Document RPO/RTO for business"
echo

# Cleanup
rm -rf "$TEST_DIR"

echo "=== SIMULATION COMPLETE ==="
```

**Run it:**
```bash
chmod +x krylov-simulation.sh
./krylov-simulation.sh
```

**Questions after simulation:**
1. Сколько времени занял restore? (RTO)
2. Сколько данных потеряли? (RPO)
3. Как можно уменьшить RPO?
4. Что бы ты сделал по-другому?

</details>

---

### 🤔 Проверка понимания

**LILITH:** *"Вопрос: Backup tested раз в год. Disaster happens через 11 месяцев после теста. Restore fails. Почему?"*

<details>
<summary>🤔 Думай</summary>

**Возможные причины:**

1. **Infrastructure changed:** Новый сервер, новая ОС, старый backup не совместим
2. **Backup tool updated:** Новая версия tar/rsync, старый backup не читается
3. **Encryption key lost:** Ротация ключей, старый ключ не найден
4. **Storage degraded:** HDD/tape деградировал за 11 месяцев
5. **Человек ушёл:** Кто знал процедуру — уволился, документация нет

**Aha! момент:**  
**Backup tested раз в год = backup untested 364 дня в году.**

Многое меняется за год. Restore procedures устаревают быстро.

**Liisa's rule:**  
*"Test restore every month. Minimum. Quarterly — bare minimum. Yearly — это joke, not testing."*

**Better:**
- Monthly: Automated restore test (небольшой sample)
- Quarterly: Full disaster recovery drill (вся команда)
- Annually: Audit + compliance verification

</details>

---

## Цикл 7: Monitoring & Logrotate — Health Checks (15 минут)

### 🎬 Сюжет (2 мин)

**Liisa:**  
*"Max, backup без monitoring — это time bomb. Backup падает тихо. No one notices. Disaster happens → backup не работал месяц → game over.  
Мониторинг backup == мониторинг жизнеобеспечения. Critical."*

---

### 📚 Теория: Backup Monitoring (7 мин)

#### Что мониторить?

```
1. ✅ Backup Success/Failure
   └─ Last backup succeeded? When?

2. 📊 Backup Age
   └─ Last backup > 48h? ALERT!

3. 📦 Backup Size
   └─ Unexpected change (±50%)? ALERT!

4. 💾 Storage Space
   └─ Backup disk >90% full? ALERT!

5. 🔐 Integrity
   └─ Checksums valid?

6. ⏱️ Backup Duration
   └─ Taking too long? Performance issue?
```

**Health check script example:**
```bash
#!/bin/bash
# backup-health-check.sh

BACKUP_DIR="/backup/full"
MAX_AGE_HOURS=48

# Find latest backup
LATEST=$(find "$BACKUP_DIR" -name "*.tar.gz" -type f -printf '%T@ %p\n' | sort -rn | head -1 | cut -d' ' -f2)

if [[ -z "$LATEST" ]]; then
    echo "CRITICAL: No backup found!"
    exit 2
fi

# Check age
AGE_SECONDS=$(( $(date +%s) - $(stat -c %Y "$LATEST") ))
AGE_HOURS=$(( AGE_SECONDS / 3600 ))

if (( AGE_HOURS > MAX_AGE_HOURS )); then
    echo "WARNING: Backup is $AGE_HOURS hours old (max: $MAX_AGE_HOURS)"
    # Send alert (email, Slack, PagerDuty)
    exit 1
fi

echo "OK: Latest backup is $AGE_HOURS hours old"
exit 0
```

---

#### Logrotate для backup logs

**Проблема:** Backup logs растут → заполняют диск → backup падает.

**Решение:** `/etc/logrotate.d/backup`

```
/var/log/backup.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 640 root adm
    sharedscripts
    postrotate
        # Send weekly summary email
        if [ $(date +%u) -eq 1 ]; then
            tail -1000 /var/log/backup.log.1 | mail -s "Weekly Backup Summary" admin@example.com
        fi
    endscript
}
```

**Параметры:**
- `daily` = ротация каждый день
- `rotate 30` = хранить 30 старых копий
- `compress` = gzip старые логи
- `delaycompress` = не compress самый свежий (может дописываться)
- `postrotate` = команды после ротации

**LILITH:** *"Логи backup — это ваша forensics после disaster. Храните их. Мониторьте их. Они расскажут что пошло не так."*

---

### 💻 Практика: Monitoring setup (6 мин)

**Задание:** Настроить complete monitoring для backups.

<details>
<summary>💡 Solution</summary>

1. **Health check service:**
```bash
# /etc/systemd/system/backup-health-check.service
[Unit]
Description=Backup Health Check
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup-health-check.sh
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

2. **Health check timer (every 6 hours):**
```bash
# /etc/systemd/system/backup-health-check.timer
[Unit]
Description=Backup Health Check Timer

[Timer]
OnCalendar=*-*-* 00,06,12,18:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

3. **Logrotate config:**
```bash
sudo tee /etc/logrotate.d/backup > /dev/null << 'LOGROTATE_EOF'
/var/log/backup.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 640 root adm
}
LOGROTATE_EOF
```

4. **Test:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable backup-health-check.timer
sudo systemctl start backup-health-check.timer
sudo systemctl list-timers | grep backup
```

5. **View logs:**
```bash
sudo journalctl -u backup-health-check.service -f
```

</details>

---

## Цикл 8: Production Best Practices — Liisa's Skype Wisdom (15 минут)

### 🎬 Сюжет: Финальные советы (3 мин)

**10:00. Всё восстановлено. Liisa готовится уезжать.**

**Liisa:**  
*"Max, emergency finished. Но я хочу поделиться последними lessons from Skype. 10 лет backup engineering. Mistakes, disasters, successes. This is what matters."*

---

### 📚 Теория: 10 Rules от Liisa (7 мин)

#### 1. "Untested backup = no backup"
*Test restore every month. No exceptions.*

#### 2. "3-2-1-T Rule"
*3 copies, 2 media, 1 offsite, TESTED.*

#### 3. "Automate everything"
*Humans forget. Scripts don't. Systemd timers > manual backups.*

#### 4. "Monitor like your life depends on it"
*Because it does. Backup failure должен быть PagerDuty alert.*

#### 5. "Document procedures"
*Disaster recovery plan на бумаге. When servers burning — ты не думаешь ясно. Read instructions.*

#### 6. "Keep multiple generations"
*Не только последний backup. Last 7 daily, 4 weekly, 12 monthly минимум.*

#### 7. "Offsite is not optional"
*Fire, flood, theft, Krylov — физическое separation спасает.*

#### 8. "Encrypt sensitive data"
*Stolen backup = data breach. Encryption = insurance.*

#### 9. "Measure RTO/RPO"
*Business должен знать: сколько downtime, сколько data loss. Честно.*

#### 10. "Train the team"
*Disaster recovery — это team sport. Все должны знать procedures.*

---

### Compliance & Retention Policies

**Сколько хранить backups?**

| Industry | Retention | Regulation |
|----------|-----------|------------|
| Financial | 7 years | SOX, SEC |
| Healthcare | 7+ years | HIPAA |
| Government (Estonia) | 7 years | e-Gov law |
| General business | 30-90 days | Internal policy |

**Liisa:** *"Compliance — это не suggestion. Это law. Know your industry requirements."*

---

### Disaster Recovery Plan Template

```markdown
# Disaster Recovery Plan — [Company Name]

## 1. CONTACT LIST (24/7)
- Primary Admin: [Name] [Phone] [Email]
- Backup Admin: [Name] [Phone] [Email]
- Manager: [Name] [Phone] [Email]

## 2. BACKUP LOCATIONS
- Primary: /backup (local server, HDD)
- Secondary: remote-server:/backup (Amsterdam datacenter)
- Tertiary: s3://company-backups (AWS eu-west-1)

## 3. RESTORE PROCEDURES

### Scenario A: Database Corruption
1. Stop application: `systemctl stop myapp`
2. Identify last clean backup: `ls -lh /backup/full/`
3. Verify checksum: `sha256sum -c backup.tar.gz.sha256`
4. Restore: `tar -xzf backup.tar.gz -C /`
5. Test database: `psql -c "SELECT COUNT(*) FROM users;"`
6. Start application: `systemctl start myapp`
7. Verify: `curl http://localhost/health`

### Scenario B: Ransomware
1. Disconnect network IMMEDIATELY
2. Identify infection time from logs
3. Restore from backup BEFORE infection
4. Scan with antivirus
5. Change ALL passwords
6. Review security

### Scenario C: Hardware Failure
1. Provision new hardware (same specs)
2. Install OS (same version!)
3. Restore configs: /etc, /home, /var/www
4. Restore data from offsite
5. Test all services
6. Update DNS if IP changed

## 4. RTO/RPO
- RTO: 2 hours (acceptable downtime)
- RPO: 24 hours (acceptable data loss)

## 5. TESTING SCHEDULE
- Monthly: Automated restore test
- Quarterly: Full DR drill
- Annually: Audit + compliance verification

## 6. LAST TESTED
- Date: [YYYY-MM-DD]
- Result: [PASS/FAIL]
- Notes: [...]
```

---

### 💻 Финальное задание: Всё вместе (5 мин)

**Задание:** Создать production-ready backup систему.

Checklist:
```
[ ] Backup strategy определена (full weekly + incremental daily)
[ ] Automation настроена (systemd timers)
[ ] Offsite backup configured (SSH keys, remote server)
[ ] Encryption enabled (GPG для sensitive data)
[ ] Monitoring setup (health checks, alerts)
[ ] Logrotate configured (retention 30 days)
[ ] Restore tested (хотя бы один successful restore)
[ ] Documentation написана (DR plan)
[ ] Team trained (все знают procedures)
[ ] RTO/RPO measured (business согласен)
```

**Если все 10 галочек — готов к production!**

---

### 🤔 Финальная проверка

**Liisa:** *"Last question, Max. Самый важный. Ready?"*

**Question:**  
*"Server сгорел. Datacenter затоплен. All local backups уничтожены. Что спасёт компанию?"*

<details>
<summary>🤔 Думай</summary>

**Ответ:** **OFFSITE BACKUP.**

**3-2-1 Rule:**
- 3 copies: ❌ Original gone, ❌ Local backup gone, ✅ **Offsite backup survives**
- 2 media: ❌ Both local media destroyed, ✅ **Offsite media intact**
- 1 offsite: ✅ **PHYSICAL SEPARATION = SURVIVAL**

**Aha! момент:**  
Все fancy features (encryption, monitoring, automation) бесполезны если всё в одной локации. **Geography matters.**

**Real story (Liisa):**  
*"Skype datacenter в Таллине — пожар в 2008. Всё сгорело. Но offsite backup в Stockholm — intact. Восстановились за 6 часов. 300 million users даже не заметили. That's why offsite — это not optional."*

**Kristjan:**  
*"e-Estonia — data centers в трёх странах. Estonia, Luxembourg, и one secret location. Если Эстония исчезнет с карты — e-services продолжат работать. Offsite — это государственная безопасность."*

</details>

---

## 🏆 Итоги Episode 12

### Что ты освоил:

**Технические навыки:**
- ✅ 3-2-1-T Backup Rule (3 copies, 2 media, 1 offsite, TESTED)
- ✅ Backup strategies (full, incremental, differential)
- ✅ Tools (rsync, tar, dd)
- ✅ Automation (cron, systemd timers)
- ✅ Offsite backups (SSH, rsync over network)
- ✅ Security (SSH keys, GPG encryption, immutable backups)
- ✅ Restore testing (disaster recovery simulation)
- ✅ Monitoring (health checks, logrotate, alerts)
- ✅ Compliance (retention policies, DR documentation)

**Soft skills:**
- ✅ Работа под давлением (emergency restore в 03:47!)
- ✅ Disaster recovery planning
- ✅ RTO/RPO measurement
- ✅ Team coordination (Anna, Liisa, Kristjan)
- ✅ Documentation (DR procedures)

---

### Финальная сцена: Прощание с Season 3

**10:30. E-Residency office, Tallinn. Liisa собирает laptop.**

**Liisa:**  
*"Max, ты справился. Emergency restore под давлением — это baptism by fire. Большинство админов паникуют. Ты держался. Skype would hire you."*

**Макс:**  
*"Liisa, спасибо. За ночь я узнал больше о backup чем за год. Но... вопрос. Как ты остаёшься такой спокойной во время disaster?"*

**Liisa** (улыбается):  
*"Experience. Skype — 10 лет disasters. Первый раз — panic. Десятый раз — routine. Сотый раз — boring.  
Secret: **preparation**. Если ты знаешь procedures, tested backups, documented plan — disaster это не страшно. Это просто checklist. Follow checklist → problem solved.  
Panic starts когда preparation ends."*

**Kristjan** (заходит):  
*"Liisa leaving? Max, Season 3 завершён. Saint Petersburg и Tallinn дали тебе solid Linux foundation. Users, permissions, processes, disks, backups — всё освоено. Что дальше?"*

**Макс:**  
*"Viktor сказал — Amsterdam. DevOps. Docker, Kubernetes."*

**Kristjan:**  
*"Good. Season 4 — automation. 50 серверов вручную настраивать нельзя. Infrastructure as Code. Ansible, Terraform. Dmitry научит."*

**Liisa:**  
*"Max, last advice. Backup — это живой процесс, не 'set and forget'. Each month:
1. Test restore
2. Check logs
3. Update documentation
4. Review RTO/RPO

Если забудешь — disaster напомнит. Painfully."*

**Viktor** (видеозвонок, 10:45):  
*"Max, Season 3 status?"*

**Макс:**  
*"Complete. Disaster recovery tested в production. Данные восстановлены. Liisa научила меня backup правильно."*

**Viktor:**  
*"Excellent. Поезд Tallinn → Amsterdam — сегодня вечером, 18:30. Dmitry встретит на Amsterdam Centraal завтра утром. Новая глава: DevOps. Automation. Scalability. Ready?"*

**Макс** (смотрит на Tallinn через окно, средневековые башни, Baltic Sea вдали):  
*"Ready. Season 3 — complete. Saint Petersburg → Tallinn. 12 эпизодов. Unix foundations → System administration. Теперь — Amsterdam. Automation."*

**LILITH:**  
*"Season 3 complete, Max. Ты пережил:  
- Users & permissions (sudo, ACL)  
- Processes & systemd (production services)  
- Disks & LVM (storage management)  
- Backup & recovery (disaster survival)  

Ты не junior больше. Ты системный администратор. Production-ready.  
Amsterdam ждёт. Docker контейнеры. Kubernetes оркестрация. CI/CD pipelines. 50 серверов → одна команда.  
Next level unlocked. Let's go."*

---

## 🎓 Season 3: SYSTEM ADMINISTRATION — COMPLETE! 🎉

### Что ты прошёл в Season 3:

| Episode | Тема | Ключевые навыки | Персонаж | Локация |
|---------|------|-----------------|----------|---------|
| **09** | Users & Permissions | useradd, sudo, ACL, chmod | Andrei Volkov | СПб 🇷🇺 |
| **10** | Processes & SystemD | ps, systemctl, journalctl | Boris Kuznetsov | СПб 🇷🇺 |
| **11** | Disk Management & LVM | LVM, RAID, fstab, SMART | Kristjan Tamm | Tallinn 🇪🇪 |
| **12** | Backup & Recovery | rsync, tar, disaster recovery | Liisa Kask | Tallinn 🇪🇪 |

**Статистика Season 3:**
- 🎯 4 эпизода завершено
- 🌍 2 города (Санкт-Петербург, Таллин)
- 👥 4 ментора (Andrei, Boris, Kristjan, Liisa)
- ⏱️ 16-20 часов прохождения
- 🧠 Навыки: Foundation → Production-ready admin

---

### Следующий Season:

**SEASON 4: DEVOPS & AUTOMATION** 🇳🇱🇩🇪

**Локации:** Amsterdam → Berlin  
**Эпизоды:** 13-16  
**Темы:**
- Episode 13: Git & Version Control
- Episode 14: Docker & Containerization
- Episode 15: CI/CD Pipelines
- Episode 16: Ansible & Infrastructure as Code

**Персонажи:**
- **Dmitry Orlov** — DevOps engineer, главный ментор Season 4
- **Sophie van Dijk** — Docker expert (Amsterdam)
- **Hans Müller** — CI/CD specialist (Berlin, Chaos Computer Club)
- **Klaus Schmidt** — Ansible architect (Berlin)

**Философия Season 4:**  
*"Manual is legacy. Automation is modern. Infrastructure as Code."*

---

### Сертификат от Liisa

```
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║           BACKUP & DISASTER RECOVERY                       ║
║                CERTIFICATION                               ║
║                                                            ║
║  Max Sokolov successfully demonstrated mastery of:         ║
║                                                            ║
║  ✅ 3-2-1-T Backup Rule implementation                     ║
║  ✅ Emergency disaster recovery (03:47 incident)           ║
║  ✅ Restore testing procedures                             ║
║  ✅ Offsite backup configuration                           ║
║  ✅ Backup security (encryption, SSH, immutable)           ║
║  ✅ Monitoring & health checks                             ║
║  ✅ Compliance & documentation                             ║
║                                                            ║
║  "Untested backup = no backup. Max tested. Max knows."    ║
║                                                            ║
║  Certified by: Liisa Kask                                  ║
║  Former Skype Backup Engineer (Tallinn)                    ║
║  Date: October 24, 2025                                    ║
║  Location: e-Residency Facility, Tallinn, Estonia          ║
║                                                            ║
║  RTO: 2 hours | RPO: 24 hours | Uptime: 99.95%            ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

---

<div align="center">

**"Untested backup = no backup. Test restore every month."**

*— Liisa Kask, ex-Skype Backup Engineer*

---

**Season 3: SYSTEM ADMINISTRATION — COMPLETE! 🎓**

**KERNEL SHADOWS**

*Linux в тенях. Код в крови. Root — это оружие.*

---

[⬅ Episode 11: Disk Management](../episode-11-disk-management-lvm/README.md) | [Season 4: DevOps & Automation →](../../season-4-devops-automation/README.md)

**Next Episode:** Amsterdam 🇳🇱 — Git & Version Control

</div>

---

## 📚 Дополнительные ресурсы

**Backup Tools:**
- [rsync documentation](https://rsync.samba.org/)
- [tar manual](https://www.gnu.org/software/tar/manual/)
- [Restic (modern backup tool)](https://restic.net/)
- [Borg Backup (deduplication)](https://www.borgbackup.org/)

**Disaster Recovery:**
- [NIST Disaster Recovery Guide](https://csrc.nist.gov/publications/)
- [AWS Disaster Recovery](https://aws.amazon.com/disaster-recovery/)

**Compliance:**
- [GDPR backup requirements](https://gdpr.eu/)
- [HIPAA compliance](https://www.hhs.gov/hipaa/)

**Liisa's Recommendation:**  
*"Read 'The Phoenix Project'. Fiction, но учит больше о disaster recovery чем любой технический manual."*

---

**LILITH:** *"Season 3 за спиной. Backup tested. Data safe. Amsterdam впереди. Docker ждёт. Kubernetes зовёт. Infrastructure as Code — следующая глава. Ready for Season 4? Let's automate."*


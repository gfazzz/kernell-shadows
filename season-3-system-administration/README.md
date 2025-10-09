# SEASON 3: SYSTEM ADMINISTRATION
## Санкт-Петербург → Таллин, Эстония

> *"Root access как заряженный пистолет. Не давай его кому попало."* — Andrei Volkov

---

## 📍 География и контекст

**Локации:**
- 🇷🇺 **Санкт-Петербург** (Episodes 09-10, дни 17-20)
  - ЛЭТИ (Ленинградский электротехнический институт), Васильевский остров
  - Unix старая школа, академические традиции
  - Белые ночи — не спится, идеальное время для sysadmin работы
- 🇪🇪 **Таллин, Эстония** (Episodes 11-12, дни 21-24)
  - e-Estonia Briefing Centre
  - Средневековый Old Town + самая цифровая нация мира
  - X-Road infrastructure, государственные серверы

**Время:** Дни 17-24 операции (из 60), ~15-18 часов

**Сложность:** ⭐⭐⭐☆☆

---

## 🎭 Сюжетный контекст

### Кризис:
Один из серверов операции **взломан**. Anna Kovaleva обнаруживает backdoor от Krylov. Viktor в панике: *"Как они проникли? Проверь все системы!"*

**Проблема:** Permissions настроены неправильно. Некоторые учётные записи имеют больше прав, чем нужно. Krylov эксплуатировал это.

**Решение:** Max едет в Санкт-Петербург, чтобы научиться правильному администрированию систем. Затем в Таллин — изучить опыт e-Government (где безопасность критична).

### Персонажи:

**Core Team (постоянные):**
- **Max Sokolov** — главный герой, растёт как sysadmin
- **Viktor Petrov** — координатор, переживает за безопасность
- **Alex Sokolov** — security expert, двоюродный брат Max, ex-FSB
- **Anna Kovaleva** — forensics expert, blue team lead
- **Dmitry Orlov** — DevOps engineer
- **LILITH** — AI-помощник (ты!)

**Local Experts (Season 3):**

#### Санкт-Петербург:
- **Andrei Volkov** (Episode 09)
  - Ex-профессор Unix, ЛЭТИ
  - Возраст: ~60 лет, седые волосы, очки, твидовый пиджак
  - Стиль: Академический, методичный, "старая школа"
  - Цитата: *"Root access как заряженный пистолет. Не давай его кому попало. Это я студентам 20 лет говорю."*
  - Учит Max правильной настройке permissions, sudo, ACL

- **Boris Kuznetsov** (Episode 10)
  - SystemD архитектор, ex-Red Hat contributor
  - Возраст: ~35 лет, бородатый, толстовка "systemd or die"
  - Стиль: Fanatical про systemd, но знает своё дело
  - Цитата: *"Init scripts — это прошлое. SystemD — это будущее. И настоящее."*
  - Учит Max systemd, services, процессам

#### Таллин, Эстония:
- **Kristjan Tamm** (Episode 11)
  - IT-архитектор e-Government Estonia
  - Возраст: ~40 лет, строгий, профессиональный
  - Стиль: Эстонская эффективность, zero tolerance для ошибок
  - Цитата: *"В Эстонии всё цифровое. Вся страна работает на этих серверах. Если они падают — страна останавливается."*
  - Учит Max LVM, disk management, production reliability

- **Liisa Kask** (Episode 12)
  - Backup engineer, ex-Skype Estonia
  - Возраст: ~30 лет, энергичная, параноидальная про бэкапы
  - Стиль: "3-2-1 backup rule" фанатик
  - Цитата: *"Backup'ы как страховка. Надеешься, что не понадобятся, но рад, что есть."*
  - Учит Max backup strategies, disaster recovery

**Antagonist:**
- **Полковник Krylov** — ФСБ Управление "К", охотится за Alex, атакует инфраструктуру

---

## 📚 Содержание Season 3

### Episode 09: Users & Permissions
**Локация:** 🇷🇺 Санкт-Петербург, ЛЭТИ
**Дни:** 17-18
**Время:** 4-5 часов
**Персонаж:** Andrei Volkov

**Тема:** Пользователи, группы, права доступа
- Users: `useradd`, `usermod`, `userdel`, `/etc/passwd`, `/etc/shadow`
- Groups: `groupadd`, `usermod -aG`, `/etc/group`
- Permissions: `chmod`, `chown`, `umask`, rwx notation
- Special bits: SUID, SGID, Sticky bit
- `sudo` и `/etc/sudoers`
- ACL (Access Control Lists): `setfacl`, `getfacl`

**Практика:**
- Создать учётные записи для команды операции (Viktor, Alex, Anna, Dmitry)
- Настроить sudo для Alex (только network команды, НЕ всё)
- Ограничить доступ Anna к логам (read-only)
- Настроить ACL для shared папки

**Сюжет:**
Max встречается с Andrei Volkov в старом университете. Белые ночи, канал за окном, чай. Andrei рассказывает о Unix permissions philosophy: principle of least privilege. Viktor требует настроить доступы правильно после взлома.

---

### Episode 10: Processes & Systemd
**Локация:** 🇷🇺 Санкт-Петербург
**Дни:** 19-20
**Время:** 4-5 часов
**Персонаж:** Boris Kuznetsov

**Тема:** Процессы, сервисы, systemd, cron
- Процессы: `ps`, `top`, `htop`, `pgrep`, `pkill`
- Signals: `kill -SIGTERM`, `kill -9`, `killall`
- Systemd: `systemctl`, unit files, dependencies
- Services: `start`, `stop`, `restart`, `enable`, `disable`
- Timers: systemd.timer (замена cron)
- Journalctl: `journalctl -u service`, logging

**Практика:**
- Создать systemd service для мониторинга (`monitor.service`)
- Настроить systemd timer для backup
- Убить зависший процесс (симуляция атаки)
- Анализ логов через journalctl

**Сюжет:**
Anna: *"На сервере запущен подозрительный процесс. PID 6623."* Max с помощью Boris находит backdoor процесс `sshd_backdoor` (маскировка под sshd). Удаляют через systemd.

---

### Episode 11: Disk Management & LVM
**Локация:** 🇪🇪 Таллин, Эстония (e-Estonia Briefing Centre)
**Дни:** 21-22
**Время:** 4-5 часов
**Персонаж:** Kristjan Tamm

**Тема:** Управление дисками, LVM, RAID, fstab
- Диски: `df -h`, `du -sh`, `lsblk`, `fdisk`, `parted`
- Partitions: создание, форматирование (ext4, xfs)
- LVM: Physical Volume → Volume Group → Logical Volume
- `pvcreate`, `vgcreate`, `lvcreate`, `lvextend`, `resize2fs`
- `/etc/fstab`: автомонтирование
- (Bonus) RAID: типы (0, 1, 5, 10), `mdadm`

**Практика:**
- Добавить новый диск к серверу
- Создать LVM: расширяемый том для `/var/log`
- Настроить автомонтирование в fstab
- Расширить LVM без downtime (как в production)

**Сюжет:**
Max в Таллине. Средневековые башни + fiber optic. Kristjan показывает X-Road infrastructure. Anna: *"Логи заполнили диск. `/var/log` 95%. СРОЧНО."* Viktor добавляет 500GB диск. LVM решение без downtime.

---

### Episode 12: Backup & Recovery
**Локация:** 🇪🇪 Таллин
**Дни:** 23-24
**Время:** 3-4 часа
**Персонаж:** Liisa Kask

**Тема:** Резервное копирование и восстановление
- Стратегии backup: full, incremental, differential
- 3-2-1 rule: 3 copies, 2 media types, 1 offsite
- Инструменты: `rsync`, `tar`, `dd`, `borg`
- Remote backup: `rsync` через SSH
- Автоматизация: cron/systemd timer + rsync
- Восстановление: testing, disaster recovery

**Практика:**
- Настроить rsync backup на удалённый сервер
- Создать incremental backup скрипт
- Симуляция: "случайно удалили базу данных" — восстановление
- Тестирование восстановления (DR drill)

**Сюжет:**
**КАТАСТРОФА:** Атака Krylov — сервер скомпрометирован, база данных удалена. Паника. Liisa: *"У меня 3 копии всего. Skype научил параноидности."* Viktor: *"У нас есть backup с вчерашнего дня."* Успешное восстановление. Облегчение.

---

## 🎯 Навыки Season 3

После Season 3 вы сможете:

✅ **Управлять пользователями и группами**
✅ **Настраивать permissions (chmod/chown) и ACL**
✅ **Конфигурировать sudo безопасно**
✅ **Управлять процессами и signals**
✅ **Создавать и настраивать systemd services**
✅ **Работать с дисками, LVM, fstab**
✅ **Настраивать backup стратегии (rsync, incremental)**
✅ **Восстанавливать данные после инцидента**
✅ **Думать как sysadmin: least privilege, defense in depth**

---

## 🔗 Связь с другими сезонами

**From Season 1-2:**
- Bash scripting → automation для user management
- Text processing → анализ логов systemd
- Networking → rsync backup через SSH

**To Season 4-8:**
- Users/permissions → Docker containers, Kubernetes RBAC
- Systemd services → microservices orchestration
- LVM → cloud storage, Kubernetes persistent volumes
- Backup → CI/CD, disaster recovery в production

**Философия:** System Administration — это фундамент. Без понимания users, processes, disks невозможно администрировать cloud/containers/Kubernetes.

---

## 🌍 Атмосфера Season 3

### Санкт-Петербург:
- **Визуально:** Белые ночи (2:00 AM — светло), каналы, старые здания ЛЭТИ
- **Звуково:** Тишина ночи, редкие машины, гудение серверов в лаборатории
- **Эмоционально:** Академическая традиция, Unix wisdom, спокойная методичность
- **Цитата:** Andrei: *"В мои времена не было Google. Был man и мозг. Читай man pages."*

### Таллин:
- **Визуально:** Средневековый Old Town + современный tech hub, контраст
- **Звуково:** Туристы в Old Town днём, тишина в tech centre ночью
- **Эмоционально:** Эффективность, zero bullshit, работа state-level infrastructure
- **Цитата:** Kristjan: *"Эстония — beta test для цифрового государства. Ошибки недопустимы."*

---

## 🚀 Мотивация

**Почему Season 3 важен?**

System Administration — это **контроль над системой**. После взлома сервера Viktor понял: безопасность начинается с правильного администрирования.

**Andrei Volkov:** *"Можно знать все инструменты, но если не понимаешь принципы — ты просто нажимаешь кнопки. Sysadmin — это философия."*

Season 3 учит не просто командам, а **системному мышлению**:
- Принцип наименьших привилегий (least privilege)
- Глубокая защита (defense in depth)
- Надёжность через резервирование
- Автоматизация рутины
- Тестирование восстановления

**Max после Season 3:** *"Теперь я понимаю, почему Krylov смог проникнуть. И знаю, как это предотвратить."*

---

## 📖 Рекомендации по прохождению

### Для новичков:
1. **Читайте man pages:** `man useradd`, `man chmod`, `man systemctl`
2. **Тестируйте на VM/контейнере:** не на production!
3. **Делайте backup перед изменениями**
4. **Используйте LILITH для вопросов**

### Для опытных:
1. **Практикуйте production scenarios:** что если disk переполнен? что если база удалена?
2. **Изучайте security implications:** SUID exploits, sudo misconfigurations
3. **Автоматизируйте:** создайте Ansible playbooks для user management
4. **Читайте deeper:** systemd architecture, LVM internals

---

## ⚠️ Важные напоминания

### Security:
- ⚠️ **НИКОГДА не давайте полный sudo всем**
- ⚠️ **Проверяйте /etc/sudoers через visudo** (защита от syntax errors)
- ⚠️ **Permissions на /etc/shadow должны быть 640 или 600**
- ⚠️ **Тестируйте backup recovery, а не только backup creation**

### LILITH подход:
- "Root — это оружие. Используй мудро."
- "Процессы не врут про PID. Но врут про имя."
- "Диски как жизнь. Места всегда мало."
- "Backup'ы — это страховка. Надеешься, что не понадобятся, но рад, что есть."

---

## 🎓 Итог Season 3

После прохождения Season 3 Max:
- ✅ Понимает users/groups/permissions на глубоком уровне
- ✅ Может настроить systemd services для production
- ✅ Управляет дисками через LVM без downtime
- ✅ Настроил backup систему для всей операции
- ✅ Готов к DevOps (Season 4) и Security (Season 5)

Viktor: *"Хорошая работа. Теперь наши системы защищены. Едем в Амстердам — DevOps следующий шаг."*

**LILITH:** *"Ты научился контролировать систему. Но система — это лишь инструмент. Следующий шаг — автоматизация."*

---

<div align="center">

**Next:** [Season 4: DevOps & Automation](../season-4-devops-automation/) → Amsterdam 🇳🇱 + Berlin 🇩🇪

**"Root — это не привилегия. Это ответственность."** — Andrei Volkov

</div>


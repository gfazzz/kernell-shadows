# Настройки безопасности и ограничений ресурсов
## Episode 09: Пользователи и права доступа

> *"Resource limits — это защита от DoS атак изнутри. Один пользователь не должен съесть все ресурсы системы."*
> — Андрей Волков, ЛЭТИ

---

## 📁 Файлы в этой папке

### `limits.conf` — Ограничения ресурсов

Файл `/etc/security/limits.conf` определяет лимиты на системные ресурсы для пользователей и групп.

**Настроенные лимиты:**

| Пользователь | nproc (процессы) | nofile (файлы) | core dumps |
|--------------|------------------|----------------|------------|
| **Все (*)**  | 2048 / 4096      | 4096 / 65536   | 0 (выкл)   |
| **alex**     | 1500 / 3000      | 16384 / 65536  | 0          |
| **anna**     | 500 / 1000       | 4096 / 16384   | 0          |
| **dmitry**   | 2000 / 4000      | 16384 / 65536  | unlimited  |
| **viktor**   | 1500 / 3000      | 8192 / 65536   | 0          |

*Формат: soft / hard*

---

## 💡 Зачем нужны limits?

### 1. Защита от DoS атак изнутри

**Без лимитов:**
```bash
# Fork bomb — создаёт процессы рекурсивно
:(){ :|:& };:
# Результат: система зависнет (миллионы процессов)
```

**С лимитами:**
```bash
ulimit -u 100  # Максимум 100 процессов
:(){ :|:& };:
# Результат: остановится на 100 процессах, система работает
```

### 2. Стабильность многопользовательской системы

Один пользователь не может "съесть" все ресурсы:
- Процессы (nproc)
- Открытые файлы (nofile)
- CPU время
- Память

### 3. Безопасность

**Core dumps** содержат память процесса:
- Пароли в открытом виде
- SSH ключи
- Токены доступа
- Sensitive data

**Решение:** отключить core dumps (`core 0`)

---

## 🔧 Установка

### Шаг 1: Копирование конфига
```bash
# Бэкап оригинального файла
sudo cp /etc/security/limits.conf /etc/security/limits.conf.backup

# Копирование нового конфига
sudo cp limits.conf /etc/security/limits.conf

# Права 644 (read-only для пользователей)
sudo chmod 644 /etc/security/limits.conf
```

### Шаг 2: Проверка PAM настройки
```bash
# Проверить что PAM использует pam_limits.so
grep pam_limits.so /etc/pam.d/common-session

# Должна быть строка:
# session required pam_limits.so
```

Если строки нет — добавить:
```bash
echo "session required pam_limits.so" | sudo tee -a /etc/pam.d/common-session
```

### Шаг 3: Применение лимитов

**⚠️ ВАЖНО:** Лимиты применяются при **НОВОМ входе** пользователя!

Существующие сессии НЕ затронуты.

```bash
# Пользователь должен:
logout
# Или:
exit

# И войти заново:
ssh user@server
# Или:
sudo -i -u username
```

---

## ✅ Проверка лимитов

### Посмотреть свои текущие лимиты
```bash
ulimit -a
```

Вывод:
```
core file size          (blocks, -c) 0           # core dumps выключены
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 15594
max locked memory       (kbytes, -l) 65536
max memory size         (kbytes, -m) unlimited
open files                      (-n) 4096        # nofile (soft)
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 2048        # nproc (soft)
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
```

### Проверить конкретные лимиты
```bash
# Soft nproc limit (процессы)
ulimit -u

# Hard nproc limit
ulimit -H -u

# Soft nofile limit (файлы)
ulimit -n

# Hard nofile limit
ulimit -H -n

# Core dump size
ulimit -c    # 0 = выключено
```

### Проверить лимиты для конкретного пользователя
```bash
# Войти как пользователь
sudo -i -u alex

# Посмотреть лимиты
ulimit -a

# Ожидаем:
# open files (-n): 16384
# max user processes (-u): 1500
```

### Посмотреть лимиты конкретного процесса
```bash
# Найти PID процесса
ps aux | grep nginx

# Посмотреть лимиты процесса
cat /proc/<PID>/limits
```

---

## 🧪 Тестирование

### Тест 1: Проверка лимитов пользователей

**Алекс (сетевой админ):**
```bash
sudo -i -u alex
ulimit -n    # Ожидается: 16384
ulimit -u    # Ожидается: 1500
```

**Анна (forensics):**
```bash
sudo -i -u anna
ulimit -n    # Ожидается: 4096
ulimit -u    # Ожидается: 500 (меньше — меньше процессов нужно)
```

**Дмитрий (DevOps):**
```bash
sudo -i -u dmitry
ulimit -n    # Ожидается: 16384
ulimit -u    # Ожидается: 2000 (больше — Docker контейнеры)
```

### Тест 2: Симуляция превышения лимита процессов

**⚠️ Выполнять только в тестовой среде!**

```bash
# Установить низкий лимит для теста
ulimit -u 50

# Попытка запустить слишком много процессов
for i in {1..100}; do
  sleep 100 &
done

# Ожидается: ошибка после ~50 процессов
# bash: fork: retry: Resource temporarily unavailable
```

### Тест 3: Симуляция превышения лимита файлов

```bash
# Установить низкий лимит для теста
ulimit -n 100

# Попытка открыть слишком много файлов
for i in {1..200}; do
  exec 3<> /tmp/testfile_$i
done

# Ожидается: ошибка после ~100 файлов
# bash: /tmp/testfile_101: Too many open files
```

### Тест 4: Проверка что core dumps отключены

```bash
ulimit -c    # Ожидается: 0

# Попытка создать core dump
sleep 10 &
kill -SIGSEGV $!

# Core dump не должен создаться
ls -la core*   # Нет файла core
```

---

## 🔧 Изменение лимитов в runtime

### Временное изменение (только для текущей сессии)

```bash
# Увеличить soft limit (до hard limit)
ulimit -n 10000    # nofile
ulimit -u 3000     # nproc

# Проверить
ulimit -n
ulimit -u
```

**⚠️ НЕ МОЖЕШЬ превысить hard limit без root!**

```bash
# Если hard limit = 65536:
ulimit -n 100000   # Ошибка!
# bash: ulimit: open files: cannot modify limit: Operation not permitted
```

### Изменение как root

```bash
# Root может изменить hard limit
sudo bash

# Установить новый hard limit
ulimit -H -n 100000

# Установить soft limit
ulimit -n 100000

# Проверить
ulimit -H -n
ulimit -n
```

---

## 🐛 Troubleshooting

### Проблема: "Too many open files"

**Симптомы:**
```
nginx: [emerg] socket() failed (24: Too many open files)
```

**Причина:** Лимит nofile слишком низкий

**Решение:**
```bash
# Проверить текущий лимит
ulimit -n

# Проверить для сервисного пользователя (например, www-data)
sudo -u www-data bash -c 'ulimit -n'

# Увеличить в limits.conf:
www-data soft nofile 65536
www-data hard nofile 65536

# Перезапустить сервис
sudo systemctl restart nginx
```

### Проблема: "Cannot fork: Resource temporarily unavailable"

**Симптомы:**
```bash
bash: fork: retry: Resource temporarily unavailable
```

**Причина:** Лимит nproc исчерпан

**Решение:**
```bash
# Проверить текущие процессы
ps -u username | wc -l

# Проверить лимит
ulimit -u

# Если процессов больше чем лимит — убить лишние:
pkill -u username process_name

# Или увеличить лимит в limits.conf
```

### Проблема: Лимиты не применяются после изменения

**Причины:**
1. Не сделан logout/login
2. PAM не настроен (нет pam_limits.so)
3. Синтаксическая ошибка в limits.conf

**Проверка:**
```bash
# 1. Проверить PAM
grep pam_limits.so /etc/pam.d/common-session

# 2. Проверить синтаксис limits.conf
# (нет специальной команды, но можно попробовать войти)
sudo -i -u username
ulimit -a

# 3. Если лимиты старые — нужен logout/login
# НЕ помогает `ulimit` в текущей сессии!
exit
ssh username@server
ulimit -a  # Теперь новые лимиты
```

### Проблема: Сервис не запускается из-за лимитов

**Для systemd сервисов** лимиты из `limits.conf` НЕ применяются!

Нужно установить в `.service` файле:

```ini
[Service]
LimitNOFILE=65536
LimitNPROC=4096
```

Пример:
```bash
# Редактировать systemd unit
sudo systemctl edit nginx

# Добавить:
[Service]
LimitNOFILE=65536

# Перезагрузить systemd и перезапустить сервис
sudo systemctl daemon-reload
sudo systemctl restart nginx
```

---

## 🔒 Безопасность

### Баланс между безопасностью и юзабельностью

**Слишком низкие лимиты:**
- ❌ Легитимные процессы не могут работать
- ❌ Пользователь не может нормально работать
- ❌ Production сервисы падают

**Слишком высокие лимиты:**
- ❌ DoS атаки изнутри возможны
- ❌ Один пользователь "съедает" все ресурсы
- ❌ Система становится нестабильной

**Правильный подход:**
- ✅ Устанавливать лимиты исходя из **реальных потребностей**
- ✅ Мониторить использование ресурсов
- ✅ Увеличивать при необходимости
- ✅ Логировать превышение лимитов

### Core dumps безопасность

**Риски:**
```bash
# Программа с паролем в памяти
./app --password "SuperSecret123"

# Программа падает → создаётся core dump
ls -la core

# Атакующий может извлечь пароль из core dump!
strings core | grep -i password
# Output: SuperSecret123
```

**Защита:**
- Отключить core dumps по умолчанию (`ulimit -c 0`)
- Если нужны для отладки — включать временно
- Использовать `coredumpctl` (systemd) с ACL ограничениями

### Root без лимитов — это нормально?

**Да, root должен иметь unlimited лимиты:**
- Для критических операций восстановления
- Для emergency режима
- Для системных задач

**НО:**
- Защищай root аккаунт (SSH ключи, 2FA, sudo only)
- Если root скомпрометирован — лимиты не спасут
- Минимизируй использование root (используй sudo + least privilege)

---

## 📖 Дополнительные ресурсы

### Man pages
```bash
man limits.conf     # Документация по формату файла
man pam_limits      # Документация по PAM модулю
man ulimit          # Документация по команде ulimit
man getrlimit       # Системный вызов для получения/установки лимитов
```

### Online
- [Linux limits.conf man page](https://linux.die.net/man/5/limits.conf)
- [PAM limits module](https://linux.die.net/man/8/pam_limits)
- [Kernel resource limits](https://www.kernel.org/doc/Documentation/sysctl/kernel.txt)

### Связанные episode
- Episode 10: Processes & Systemd (лимиты для systemd сервисов)
- Episode 12: Backup & Recovery (защита от заполнения диска)

---

## 📝 История изменений

- **2025-10-11:** Созданы лимиты для операции KERNEL SHADOWS
  - Защита от fork bomb и DoS атак изнутри
  - Индивидуальные лимиты для каждого члена команды
  - Core dumps отключены для безопасности
  - Ментор: Андрей Волков, ЛЭТИ
  - Локация: Санкт-Петербург, белые ночи

---

<div align="center">

**"Resource limits — это не ограничение свободы, это защита стабильности."**

— Андрей Волков, профессор, ЛЭТИ

</div>


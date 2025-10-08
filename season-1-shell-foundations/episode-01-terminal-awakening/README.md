# Episode 01: Terminal Awakening

```
ОПЕРАЦИЯ: KERNEL SHADOWS
СЕЗОН: 1 — Shell & Foundations
ЭПИЗОД: 01 — Terminal Awakening
ЛОКАЦИЯ: 🇷🇺 Новосибирск, Россия (Академгородок)
ДЕНЬ ОПЕРАЦИИ: 2 (из 60)
СЛОЖНОСТЬ: ⭐☆☆☆☆
ВРЕМЯ: 3-4 часа
```

---

## 📅 День 1 (02 октября 2025): Встреча с Viktor

### 14:00 — Красная площадь, Москва

Viktor Petrov. Седые волосы, черный костюм, проницательный взгляд.

> **Viktor:**
> *"Максим Соколов. 28 лет. Системный администратор. 5 лет в ЦОД 'Сибирь-Телеком'. Твой брат Alex хорошо о тебе отзывается."*

Он знает о вас. Много.

> **Viktor:**
> *"У меня проект. 50 серверов. Военные стандарты безопасности. $50,000 за 2 месяца работы. $10,000 авансом."*

Пауза.

> **Viktor:**
> *"Начнём с основ. Работай удалённо из Новосибирска. У тебя 24 часа на тестовое задание. На сервере спрятаны файлы с координатами. Найди их."*

Он передает конверт. $10,000.

> **Viktor:**
> *"Справишься — продолжим. Вопросы?"*

Max: *"Нет. Я в деле."*

---

## 📅 День 2 (03 октября 2025): Первое задание

### 09:00 — Квартира Max, Академгородок, Новосибирск

**Локация:** 1-комнатная квартира в хрущёвке. Окно на снежный лес. Температура за окном: -20°C.

**Home lab:** Dell PowerEdge server (гудит в углу), 2 Raspberry Pi, белая доска для заметок.

Max садится за стол. Кофе. Открывает ноутбук. Получает email от Viktor:

```
From: v.petrov@secured.net
To: m.sokolov@sib-telecom.ru
Subject: MISSION 01 — Terminal Skills

SSH: shadow-server-01.ops.internal (симуляция: artifacts/test_environment)
User: max_test
Mission: Найти 3 скрытых файла

Координаты доступа в attachment.

У тебя 24 часа.

— V.
```

Max открывает терминал. Время начинать.

### 🔧 Подготовка

**Шаг 1: Перейдите в директорию эпизода**
```bash
cd ~/kernel-shadows/season-1-shell-foundations/episode-01-terminal-awakening
```

**Шаг 2: Запустите симуляцию**
```bash
chmod +x starter.sh
./starter.sh
```

**Шаг 3: "Подключитесь к серверу"**
```bash
cd artifacts/test_environment
```

> 💡 **Погружение:** Представьте, что вы подключились через SSH к `shadow-server-01`. Эта папка — его файловая система.

---

## 🎮 Начало миссии

### 09:30 — LILITH активируется

Экран терминала мигает. Звук гудения домашнего сервера. За окном падает снег. Появляется текст:

```
┌─────────────────────────────────────────────────────────────┐
│                                                               │
│   Я LILITH.                                                   │
│   Linux Infrastructure & Low-level Intelligence TH           │
│                                                               │
│   Приветствую, Max. Я твой проводник в тенях.                │
│   Viktor попросил меня оценить твои навыки.                   │
│                                                               │
│   Посмотрим, так ли ты хорош, как говорит Alex.              │
│                                                               │
│   На этом сервере 3 файла:                                    │
│   1. briefing.txt — брифинг от Viktor                         │
│   2. .secret_location — координаты встречи                    │
│   3. .next_server — IP следующего сервера                     │
│                                                               │
│   Найди их все. Покажи, на что ты способен.                   │
│                                                               │
│   Ты видишь shell. Я вижу тени.                               │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

**Атмосфера:** Тишина квартиры. Гудение сервера. Кофе остывает. Снег за окном. Сибирская зима. Первые шаги в операции Viktor.

---

## 🎯 Задание 1: Ориентация в пространстве

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Первый вопрос, Max. Где ты сейчас находишься?               │
│  Покажи мне полный путь."                                     │
└─────────────────────────────────────────────────────────────┘
```

### 🤔 Попробуй сам (3 минуты)

Задача: Узнай текущую директорию (полный путь).

**Подумай:**
- Как узнать где ты находишься в файловой системе?
- Есть ли команда для этого?

<details>
<summary>💡 Подсказка 1 (через 2 минуты)</summary>

Команда из 3 букв. Аббревиатура от "Print Working Directory".

</details>

<details>
<summary>💡 Подсказка 2 (через 5 минут)</summary>

```bash
pwd
```

Эта команда покажет полный путь к текущей директории.

</details>

<details>
<summary>📚 Теория: Навигация в Linux</summary>

### Команда `pwd`

**pwd** = Print Working Directory

Показывает полный путь к текущей директории.

```bash
$ pwd
/home/max_test/kernel-shadows/season-1-shell-foundations/episode-01-terminal-awakening/artifacts/test_environment
```

### Файловая система Linux

В Linux всё начинается с корня `/`:

```
/                           (корень)
├── home/                   (домашние папки пользователей)
│   ├── max_test/           (ваша домашняя папка)
│   └── viktor/
├── etc/                    (конфигурации)
├── var/log/                (логи)
└── tmp/                    (временные файлы)
```

**Абсолютный путь:** начинается с `/`
- `/home/max_test/documents`

**Относительный путь:** относительно текущей позиции
- `documents/` (если вы в `/home/max_test/`)

> **LILITH:** *"Путь говорит правду. Всегда знай где ты. `pwd` — первая команда на чужом сервере."*

</details>

<details>
<summary>✅ Решение</summary>

```bash
pwd
```

**Вывод:**
```
/home/yourusername/kernel-shadows/season-1-shell-foundations/episode-01-terminal-awakening/artifacts/test_environment
```

(Или путь зависит от вашей системы)

</details>

---

## 🎯 Задание 2: Что вокруг тебя?

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Хорошо. Теперь скажи: что находится в этой директории?      │
│  Какие файлы? Какие папки? Покажи."                           │
└─────────────────────────────────────────────────────────────┘
```

### 🤔 Попробуй сам (5 минут)

Задача: Посмотри содержимое текущей директории.

<details>
<summary>💡 Подсказка 1</summary>

Команда из 2 букв. Аббревиатура от "list".

</details>

<details>
<summary>💡 Подсказка 2</summary>

```bash
ls
```

Но этого недостаточно. Попробуй с флагом `-l` для детального просмотра.

</details>

<details>
<summary>📚 Теория: Команда `ls`</summary>

### Команда `ls`

**ls** = list (список)

Показывает содержимое директории.

#### Основные варианты:

```bash
ls              # Простой список
ls -l           # Детальный (long format)
ls -a           # Все файлы (включая скрытые)
ls -lh          # Детальный + размеры в читаемом виде
ls -la          # Всё вместе
```

#### Пример вывода `ls -l`:

```bash
$ ls -l
total 12
drwxr-xr-x 2 max max 4096 Oct  2 18:30 documents
-rw-r--r-- 1 max max  156 Oct  2 18:25 notes.txt
-rwxr-xr-x 1 max max 2145 Oct  2 18:28 script.sh
```

**Разбор строки:**
```
-rw-r--r-- 1 max max  156 Oct  2 18:25 notes.txt
│││││││││  │  │   │    │    │         │
│││││││││  │  │   │    │    │         └─ имя файла
│││││││││  │  │   │    │    └─────────── дата изменения
│││││││││  │  │   │    └──────────────── размер (байты)
│││││││││  │  │   └───────────────────── группа
│││││││││  │  └───────────────────────── владелец
│││││││││  └──────────────────────────── ссылки
│││││││││
│└┴┴┴┴┴┴┴─ права (r=read, w=write, x=execute)
└───────── тип (- = файл, d = директория)
```

> **LILITH:** *"`ls -l` покажет кто, что и когда. Permissions — это ключ. Запомни."*

</details>

<details>
<summary>✅ Решение</summary>

```bash
ls -l
```

**Вывод (примерный):**
```bash
total 4
drwxr-xr-x 2 max max 4096 Oct  2 18:30 documents
```

Видишь директорию `documents/`. Но где остальные файлы?

</details>

---

## 🎯 Задание 3: Скрытые файлы

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Ты видишь только то, что на поверхности.                    │
│  Но интересное всегда скрыто.                                 │
│  Файлы .secret_location и .next_server начинаются с точки.    │
│  Это значит — они невидимы для обычного ls.                   │
│  Покажи мне ВСЁ."                                             │
└─────────────────────────────────────────────────────────────┘
```

### 🤔 Попробуй сам (5 минут)

Задача: Покажи ВСЕ файлы, включая скрытые.

<details>
<summary>💡 Подсказка 1</summary>

У команды `ls` есть флаг для показа всех файлов (all). Буква `a`.

</details>

<details>
<summary>💡 Подсказка 2</summary>

```bash
ls -a
```

Или комбинируй с предыдущими флагами:
```bash
ls -la
```

</details>

<details>
<summary>📚 Теория: Скрытые файлы</summary>

### Скрытые файлы в Linux

**Правило:** Файлы и папки, начинающиеся с точки `.`, скрыты.

**Примеры:**
- `.bashrc` — конфигурация bash
- `.ssh/` — SSH ключи
- `.secret_location` — ваш секретный файл

### Как увидеть скрытые файлы:

```bash
ls -a       # Показать все (all)
ls -la      # Показать все + детали
```

**Пример:**
```bash
$ ls
documents

$ ls -a
.  ..  .bashrc  .secret_location  documents
```

**Обрати внимание:**
- `.` — текущая директория
- `..` — родительская директория (уровень выше)

> **LILITH:** *"Точка = невидимость. Но для тех, кто знает `ls -a` — нет секретов."*

### Почему скрывают файлы?

- **Конфигурации:** `.bashrc`, `.profile` — не мешают в повседневной работе
- **Секреты:** `.env` с паролями, `.ssh` с ключами
- **Скрытность:** Файлы, которые не хотят показывать обычным пользователям

</details>

<details>
<summary>✅ Решение</summary>

```bash
ls -la
```

**Вывод:**
```bash
total 20
drwxr-xr-x 3 max max 4096 Oct  2 18:30 .
drwxr-xr-x 5 max max 4096 Oct  2 18:00 ..
-rw-r--r-- 1 max max   89 Oct  2 18:30 .next_server
-rw-r--r-- 1 max max   67 Oct  2 18:30 .secret_location
drwxr-xr-x 2 max max 4096 Oct  2 18:30 documents
```

Видишь! Два скрытых файла появились:
- `.next_server`
- `.secret_location`

Но где `briefing.txt`?

</details>

---

## 🎯 Задание 4: Навигация вглубь

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Два файла нашёл. Неплохо.                                    │
│  Но briefing.txt не здесь. Он глубже.                         │
│  Посмотри в директорию documents/.                            │
│  Как ты туда попадёшь?"                                       │
└─────────────────────────────────────────────────────────────┘
```

### 🤔 Попробуй сам (5 минут)

Задача: Перейди в директорию `documents/` и посмотри что там.

<details>
<summary>💡 Подсказка 1</summary>

Команда для смены директории — `cd` (change directory).

</details>

<details>
<summary>💡 Подсказка 2</summary>

```bash
cd documents
ls -la
```

</details>

<details>
<summary>📚 Теория: Навигация с `cd`</summary>

### Команда `cd`

**cd** = change directory (сменить директорию)

#### Основные варианты:

```bash
cd documents            # Перейти в documents/ (относительный путь)
cd /home/max/docs       # Перейти по абсолютному пути
cd ..                   # На уровень выше
cd ../..                # На два уровня выше
cd ~                    # В домашнюю папку
cd /                    # В корень системы
cd -                    # Вернуться в предыдущую директорию
```

#### Примеры:

```bash
$ pwd
/home/max

$ cd documents
$ pwd
/home/max/documents

$ cd ..
$ pwd
/home/max

$ cd ~
$ pwd
/home/max
```

### Абсолютный vs Относительный путь

**Абсолютный** — от корня `/`:
```bash
cd /home/max/documents
```

**Относительный** — от текущей позиции:
```bash
cd documents           # если вы в /home/max
cd ../downloads        # перейти на уровень выше, потом в downloads
```

> **LILITH:** *"`cd` — твои ноги в этом мире. `..` — шаг назад. `.` — здесь. `~` — домой."*

</details>

<details>
<summary>✅ Решение</summary>

```bash
cd documents
ls -la
```

**Вывод:**
```bash
total 12
drwxr-xr-x 2 max max 4096 Oct  2 18:30 .
drwxr-xr-x 3 max max 4096 Oct  2 18:30 ..
-rw-r--r-- 1 max max  823 Oct  2 18:30 briefing.txt
```

Нашёл! `briefing.txt` здесь!

</details>

---

## 🎯 Задание 5: Чтение файлов

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Все три файла найдены. Молодец.                              │
│  Теперь прочитай их. Что внутри?                              │
│  Начни с briefing.txt."                                       │
└─────────────────────────────────────────────────────────────┘
```

### 🤔 Попробуй сам (5 минут)

Задача: Прочитай содержимое `briefing.txt`.

<details>
<summary>💡 Подсказка 1</summary>

Команда `cat` выводит содержимое файла.

</details>

<details>
<summary>💡 Подсказка 2</summary>

```bash
cat briefing.txt
```

</details>

<details>
<summary>📚 Теория: Чтение файлов</summary>

### Команды для чтения файлов

#### 1. `cat` — вывести весь файл

```bash
cat filename.txt
```

Выводит всё содержимое сразу.

**Когда использовать:** Маленькие файлы (< 100 строк).

#### 2. `less` — постраничный просмотр

```bash
less filename.txt
```

**Управление:**
- `Space` — следующая страница
- `b` — предыдущая страница
- `/текст` — поиск
- `q` — выход

**Когда использовать:** Большие файлы (логи, конфиги).

#### 3. `head` — первые N строк

```bash
head filename.txt          # Первые 10 строк
head -n 5 filename.txt     # Первые 5 строк
```

#### 4. `tail` — последние N строк

```bash
tail filename.txt          # Последние 10 строк
tail -n 20 filename.txt    # Последние 20 строк
tail -f /var/log/syslog    # Следить в реальном времени
```

> **LILITH:** *"`cat` для быстрого просмотра. `less` когда много. `tail -f` для логов в реальном времени. Выбирай инструмент по задаче."*

</details>

<details>
<summary>✅ Решение</summary>

```bash
cat briefing.txt
```

**Содержимое:**
```
═══════════════════════════════════════════════
OPERATION KERNEL SHADOWS - BRIEFING #001
═══════════════════════════════════════════════

FROM: Viktor Petrov
TO: Max Sokolov (Candidate)
DATE: 02 October 2025
CLASSIFICATION: CONFIDENTIAL

MISSION OBJECTIVE:
Build secure infrastructure for high-risk operation.
50 servers. Military-grade security. Full isolation.

PHASE 1 (TEST):
- Prove your skills
- Find hidden files on this server
- Demonstrate bash proficiency

FILES TO LOCATE:
1. This file (briefing.txt) ✓
2. .secret_location - coordinates for next meeting
3. .next_server - IP address of next server

TIMELINE:
24 hours from now.

If successful:
- Meeting tomorrow 14:00, same location
- Contract details discussion
- $10,000 advance payment

If failed:
- Keep the $2,000 for your time
- Return to your normal life

Choose wisely, Max.

— Viktor Petrov
═══════════════════════════════════════════════
```

Ясно. Теперь нужно прочитать два других файла.

</details>

---

## 🎯 Задание 6: Вернуться назад

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Briefing прочитан. Два других файла в родительской           │
│  директории. Вернись туда."                                   │
└─────────────────────────────────────────────────────────────┘
```

### 🤔 Попробуй сам (2 минуты)

Задача: Вернись на уровень выше (в `test_environment/`).

<details>
<summary>💡 Подсказка</summary>

```bash
cd ..
```

`..` = родительская директория (уровень выше)

</details>

<details>
<summary>✅ Решение</summary>

```bash
cd ..
pwd
```

**Вывод:**
```
/home/yourusername/kernel-shadows/.../test_environment
```

Ты снова в корневой директории симуляции.

</details>

---

## 🎯 Задание 7: Прочитать секретные файлы

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Прочитай .secret_location и .next_server.                    │
│  Запомни координаты и IP. Они понадобятся."                   │
└─────────────────────────────────────────────────────────────┘
```

### 🤔 Попробуй сам (5 минут)

Задача: Прочитай оба скрытых файла.

<details>
<summary>💡 Подсказка</summary>

```bash
cat .secret_location
cat .next_server
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
cat .secret_location
```

**Содержимое:**
```
55.7558°N, 37.6173°E
ГУМ, кофейня Bosco, третий этаж
Время: 14:00, 03 октября 2025
```

```bash
cat .next_server
```

**Содержимое:**
```
NEXT SERVER:
IP: 185.192.47.203
Port: 2222
User: shadow_op
Access: Будет предоставлен Viktor после встречи
```

Отлично! Все три файла найдены и прочитаны.

</details>

---

## 🎯 Задание 8: Автоматизация (финальная задача)

```
┌─────────────────────────────────────────────────────────────┐
│ LILITH:                                                       │
│ "Ты нашёл всё вручную. Хорошо.                                │
│  Но системный администратор не делает руками                  │
│  то, что можно автоматизировать.                              │
│                                                               │
│  Создай bash скрипт find_files.sh, который:                   │
│  1. Найдёт все три файла автоматически                        │
│  2. Выведет их содержимое                                     │
│  3. Сохранит результаты в report.txt                          │
│                                                               │
│  Покажи, что ты можешь больше чем просто вводить команды."    │
└─────────────────────────────────────────────────────────────┘
```

### 🤔 Попробуй сам (30-60 минут)

Это главное задание эпизода. Время применить всё что узнал.

**Что нужно:**
1. Создать файл `find_files.sh`
2. Сделать его исполняемым
3. Написать скрипт который находит и читает все файлы
4. Сохранить результаты в `report.txt`

<details>
<summary>💡 Подсказка 1: Структура скрипта</summary>

Любой bash скрипт начинается с:

```bash
#!/bin/bash

# Твой код здесь
```

Первая строка `#!/bin/bash` называется **shebang**. Она говорит системе: "Используй bash для выполнения".

</details>

<details>
<summary>💡 Подсказка 2: Поиск файлов</summary>

Команда `find` может найти файлы по имени:

```bash
find . -name "briefing.txt"
find . -name ".*" -type f      # Все скрытые файлы
```

</details>

<details>
<summary>💡 Подсказка 3: Сохранение в файл</summary>

Перенаправление вывода:

```bash
echo "текст" > file.txt        # Записать (перезапишет)
echo "текст" >> file.txt       # Добавить в конец
```

</details>

<details>
<summary>📚 Теория: Bash скрипты</summary>

### Что такое Bash скрипт?

**Bash скрипт** — файл с командами, которые выполняются последовательно.

### Структура:

```bash
#!/bin/bash
# Комментарий

# Команды
echo "Начинаю работу..."
pwd
ls -la
```

### Создание и запуск:

```bash
# 1. Создать файл
touch my_script.sh

# 2. Сделать исполняемым
chmod +x my_script.sh

# 3. Запустить
./my_script.sh
```

### Основные элементы:

#### 1. Shebang
```bash
#!/bin/bash
```
Обязательная первая строка.

#### 2. Комментарии
```bash
# Это комментарий
echo "Код"  # Комментарий после кода
```

#### 3. Переменные
```bash
name="Max"
echo "Привет, $name"
```

#### 4. Команды
```bash
pwd
ls -la
cat file.txt
```

#### 5. Перенаправление
```bash
echo "text" > file.txt     # Записать
echo "text" >> file.txt    # Добавить
cat file.txt | grep "word" # Pipe (передать вывод)
```

> **LILITH:** *"Скрипт — это твоя первая автоматизация. Не делай вручную то, что можно закодить."*

### Команда `find` — поиск файлов

```bash
# Найти файл по имени
find . -name "filename.txt"

# Найти все .txt файлы
find . -name "*.txt"

# Найти скрытые файлы
find . -name ".*" -type f

# Найти в конкретной директории
find ./documents -name "*.txt"
```

**Синтаксис:**
```bash
find [ГДЕ] [УСЛОВИЕ] [ЧТО]
```

**Примеры:**
```bash
find . -name "*.sh"              # Все .sh файлы
find /home -name "config"        # Файлы с именем config
find . -type d -name "test"      # Директории с именем test
find . -type f -name ".*"        # Скрытые файлы
```

</details>

<details>
<summary>📝 Шаблон скрипта</summary>

Используй этот шаблон как основу:

```bash
#!/bin/bash

echo "=== KERNEL SHADOWS: File Search Script ==="
echo ""

# TODO 1: Найти briefing.txt
echo "Searching for briefing.txt..."
# YOUR CODE HERE

echo ""

# TODO 2: Найти .secret_location
echo "Searching for .secret_location..."
# YOUR CODE HERE

echo ""

# TODO 3: Найти .next_server
echo "Searching for .next_server..."
# YOUR CODE HERE

echo ""

# TODO 4: Вывести содержимое всех файлов
echo "=== FILE CONTENTS ==="
echo ""

echo "--- briefing.txt ---"
# YOUR CODE HERE

echo ""
echo "--- .secret_location ---"
# YOUR CODE HERE

echo ""
echo "--- .next_server ---"
# YOUR CODE HERE

echo ""
echo "=== Search complete! ==="
```

Заполни `YOUR CODE HERE` нужными командами.

</details>

<details>
<summary>✅ Решение</summary>

**Файл `find_files.sh`:**

```bash
#!/bin/bash

################################################################################
# OPERATION KERNEL SHADOWS - Episode 01
# File Search Script
################################################################################

echo "=== KERNEL SHADOWS: Automated File Search ==="
echo "Starting search operation..."
echo ""

# Поиск всех трёх файлов
echo "=== LOCATING FILES ==="
echo ""

echo "1. Searching for briefing.txt..."
briefing_path=$(find . -name "briefing.txt" 2>/dev/null)
if [ -n "$briefing_path" ]; then
    echo "   Found: $briefing_path"
else
    echo "   Not found"
fi

echo ""

echo "2. Searching for .secret_location..."
secret_path=$(find . -name ".secret_location" 2>/dev/null)
if [ -n "$secret_path" ]; then
    echo "   Found: $secret_path"
else
    echo "   Not found"
fi

echo ""

echo "3. Searching for .next_server..."
server_path=$(find . -name ".next_server" 2>/dev/null)
if [ -n "$server_path" ]; then
    echo "   Found: $server_path"
else
    echo "   Not found"
fi

echo ""
echo "=== FILE CONTENTS ==="
echo ""

# Чтение содержимого
if [ -n "$briefing_path" ]; then
    echo "--- briefing.txt ---"
    cat "$briefing_path"
    echo ""
fi

if [ -n "$secret_path" ]; then
    echo "--- .secret_location ---"
    cat "$secret_path"
    echo ""
fi

if [ -n "$server_path" ]; then
    echo "--- .next_server ---"
    cat "$server_path"
    echo ""
fi

echo "=== OPERATION COMPLETE ==="
echo ""

# Сохранение в report.txt
{
    echo "KERNEL SHADOWS - Episode 01 Report"
    echo "Generated: $(date)"
    echo ""
    echo "=== FILES FOUND ==="
    echo "1. $briefing_path"
    echo "2. $secret_path"
    echo "3. $server_path"
    echo ""
    echo "=== CONTENTS ==="
    echo ""
    echo "--- briefing.txt ---"
    [ -n "$briefing_path" ] && cat "$briefing_path"
    echo ""
    echo "--- .secret_location ---"
    [ -n "$secret_path" ] && cat "$secret_path"
    echo ""
    echo "--- .next_server ---"
    [ -n "$server_path" ] && cat "$server_path"
} > report.txt

echo "Results saved to report.txt"
```

**Запуск:**

```bash
chmod +x find_files.sh
./find_files.sh
```

**Проверка отчёта:**

```bash
cat report.txt
```

</details>

<details>
<summary>🎓 Упрощённое решение (для новичков)</summary>

Если полное решение слишком сложное, вот упрощённая версия:

```bash
#!/bin/bash

echo "=== KERNEL SHADOWS: File Search ==="
echo ""

# Найти и показать briefing.txt
echo "--- briefing.txt ---"
find . -name "briefing.txt" -exec cat {} \;

echo ""

# Найти и показать .secret_location
echo "--- .secret_location ---"
find . -name ".secret_location" -exec cat {} \;

echo ""

# Найти и показать .next_server
echo "--- .next_server ---"
find . -name ".next_server" -exec cat {} \;

echo ""
echo "=== Complete ==="
```

> **LILITH:** *"Работает? Хорошо. Теперь изучи полное решение и пойми разницу."*

</details>

---

## 🎬 Финал: Оценка LILITH

После запуска скрипта, экран мигает:

```
┌─────────────────────────────────────────────────────────────┐
│                                                               │
│   LILITH: ASSESSMENT COMPLETE                                 │
│                                                               │
│   Время выполнения: [ВРЕМЯ]                                   │
│   Файлов найдено: 3/3 ✓                                       │
│   Скрипт создан: ✓                                            │
│   Автоматизация: ✓                                            │
│                                                               │
│   Оценка: PASSED                                              │
│                                                               │
│   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
│                                                               │
│   "Неплохо, Max. Ты не просто нашёл файлы.                    │
│    Ты автоматизировал поиск. Думаешь как сисадмин."           │
│                                                               │
│   Viktor получил отчёт. Он доволен.                           │
│                                                               │
│   Встреча подтверждена:                                       │
│   → 03 октября 2025, 14:00                                    │
│   → ГУМ, кофейня Bosco                                        │
│   → Координаты: 55.7558°N, 37.6173°E                          │
│                                                               │
│   Это был простой тест. Детская игра.                         │
│   Настоящая работа начнётся завтра.                           │
│                                                               │
│   Отдохни. Тебе понадобятся силы.                             │
│                                                               │
│   Я буду наблюдать. В тенях. Всегда.                          │
│                                                               │
│                                          — LILITH             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎓 Что ты узнал

### Команды Linux:
- ✅ `pwd` — где я нахожусь
- ✅ `ls`, `ls -l`, `ls -la` — просмотр файлов
- ✅ `cd` — навигация по директориям
- ✅ `cat` — чтение файлов
- ✅ `find` — поиск файлов

### Концепции:
- ✅ Файловая система Linux (структура `/`)
- ✅ Абсолютный vs относительный путь
- ✅ Скрытые файлы (начинаются с `.`)
- ✅ Bash скрипты (автоматизация)
- ✅ Shebang `#!/bin/bash`
- ✅ Права доступа (`chmod +x`)

### Навыки:
- ✅ Ориентация в незнакомой системе
- ✅ Систематический поиск файлов
- ✅ Создание и запуск bash скриптов
- ✅ Автоматизация повторяющихся задач

---

## 📊 Самопроверка

Ответь на эти вопросы без подглядывания:

1. **Как узнать где ты сейчас находишься?**
2. **Как увидеть все файлы включая скрытые?**
3. **Что означает `..` в контексте `cd`?**
4. **Как найти все .txt файлы в текущей директории и подпапках?**
5. **Что такое shebang и зачем он нужен?**

<details>
<summary>✅ Ответы</summary>

1. `pwd`
2. `ls -a` или `ls -la`
3. Родительская директория (уровень выше)
4. `find . -name "*.txt"`
5. `#!/bin/bash` — первая строка скрипта, указывает интерпретатор

</details>

---

## 🔧 Проверка выполнения

Запусти автотест:

```bash
cd ~/kernel-shadows/season-1-shell-foundations/episode-01-terminal-awakening
./tests/test.sh
```

Тесты проверят:
- ✓ Найдены ли все файлы
- ✓ Создан ли скрипт `find_files.sh`
- ✓ Исполняемый ли скрипт
- ✓ Создан ли `report.txt`

---

## 🎯 Следующий эпизод

**Episode 02: Shell Scripting Basics**

Viktor предлагает контракт. Но перед этим — второй тест. На этот раз нужно написать скрипт для автоматической настройки серверов.

> **LILITH:**
> *"Один скрипт ты написал. Но это была разминка. Теперь покажи на что способен по-настоящему."*

---

## 📚 Дополнительные материалы

### Man Pages
```bash
man bash
man find
man ls
man cd
```

### Полезные ресурсы
- [Explain Shell](https://explainshell.com/) — объяснение команд
- [ShellCheck](https://www.shellcheck.net/) — проверка bash скриптов
- [Linux Journey](https://linuxjourney.com/) — интерактивный курс

### Практика
- Попробуй найти все `.conf` файлы в `/etc/` (если есть доступ)
- Напиши скрипт который показывает системную информацию
- Автоматизируй backup важных файлов

---

<div align="center">

**OPERATION KERNEL SHADOWS**
*Episode 01 — Terminal Awakening*

*"Ты видишь shell. Я вижу тени."* — LILITH

**[← Season 1](../README.md) | [Episode 02 →](../episode-02-shell-scripting/mission.md)**

</div>


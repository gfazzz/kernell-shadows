# Contributing to KERNEL SHADOWS

Спасибо за интерес к проекту **KERNEL SHADOWS**! Мы приветствуем любой вклад — от исправления опечаток до создания целых эпизодов.

---

## 📋 Содержание

- [Кодекс поведения](#кодекс-поведения)
- [Как помочь проекту](#как-помочь-проекту)
- [Процесс разработки](#процесс-разработки)
- [Стандарты кода](#стандарты-кода)
- [Структура эпизода](#структура-эпизода)
- [Тестирование](#тестирование)
- [Документация](#документация)
- [Сюжет и персонажи](#сюжет-и-персонажи)
- [Лицензия](#лицензия)

---

## 🤝 Кодекс поведения

Мы придерживаемся философии открытого ПО и уважения к участникам:

- ✅ Будьте вежливы и уважительны
- ✅ Конструктивная критика приветствуется
- ✅ Помогайте новичкам
- ❌ Токсичность, оскорбления, дискриминация недопустимы

**Помните:** Мы все здесь, чтобы учиться и учить.

---

## 🎯 Как помочь проекту

### 1. 🐛 Баг-репорты

Нашли ошибку? Создайте issue с описанием:
- Что вы делали
- Что ожидали
- Что получили на самом деле
- Версия Ubuntu, bash, и т.д.

**Шаблон:**
```markdown
## Описание бага
Команда `find` в Episode 01 не находит скрытые файлы.

## Шаги воспроизведения
1. `cd ~/test_environment`
2. `find . -name ".*"`
3. Выводит только `.` и `..`

## Ожидаемое поведение
Должны найтись `.secret_location` и `.next_server`

## Реальное поведение
Находятся только директории `.` и `..`

## Окружение
- Ubuntu: 22.04 LTS
- Bash: 5.1.16
- Episode: 01
```

---

### 2. 💡 Предложения по улучшению

Есть идея? Создайте issue с тегом `enhancement`:
- Новые темы для эпизодов
- Улучшения сюжета
- Дополнительные задачи
- LILITH фразы и комментарии

---

### 3. 📝 Исправление документации

Опечатки, неясные объяснения, улучшения:
- Fork репозиторий
- Исправьте документацию
- Создайте Pull Request

**Важно:** README.md файлы — это теория для студентов, пишите понятно!

---

### 4. 🔧 Разработка эпизодов

Хотите создать эпизод? Отлично! Но сначала:
1. Создайте issue с описанием эпизода
2. Обсудите концепцию с maintainers
3. После одобрения — приступайте к разработке

**Почему обсуждение важно:**
- Эпизод должен вписываться в сюжет
- Сложность должна нарастать постепенно
- Не должно быть дублирования тем

---

### 5. 🎨 Визуализация

Умеете рисовать? Нужны:
- LILITH аватар (cyberpunk noir стиль)
- Визуализация концепций (файловая система, сети)
- ASCII-диаграммы для README

---

### 6. 🌍 Переводы

Английский, немецкий, испанский — любые языки приветствуются!
Хотя предпочтительное не перевод, а локализация вплоть до изменения сюжета.

**Структура:**
```
translations/
├── en/
│   ├── README.md
│   └── season-1/...
└── de/
    ├── README.md
    └── season-1/...
```

---

## 🔄 Процесс разработки

### Git Workflow

1. **Fork** репозиторий
2. **Clone** ваш fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/kernel-shadows.git
   cd kernel-shadows
   ```

3. **Создайте ветку** для вашей фичи:
   ```bash
   git checkout -b feature/episode-02-scripting
   ```

4. **Разработка:**
   - Следуйте структуре эпизода (см. ниже)
   - Пишите тесты
   - Проверяйте код через ShellCheck

5. **Commit:**
   ```bash
   git add .
   git commit -m "feat(s1e02): добавлен Episode 02 Shell Scripting"
   ```

   **Commit message format:**
   - `feat(s1e02):` — новая функциональность
   - `fix(s1e01):` — исправление бага
   - `docs(readme):` — документация
   - `test(s1e03):` — тесты
   - `refactor(s2):` — рефакторинг

6. **Push:**
   ```bash
   git push origin feature/episode-02-scripting
   ```

7. **Pull Request:**
   - Опишите что вы сделали
   - Ссылка на issue (если есть)
   - Скриншоты/примеры (если применимо)

---

## 📐 Стандарты кода

### Bash Script Style

**Основные правила:**

1. **Shebang обязателен:**
   ```bash
   #!/bin/bash
   ```

2. **Комментарии:**
   ```bash
   # Описание функции
   function find_hidden_files() {
       # TODO: Найти все скрытые файлы
       find . -name ".*" -type f
   }
   ```

3. **Переменные:**
   ```bash
   # Заглавные для констант
   readonly MAX_RETRIES=3

   # Маленькие для локальных переменных
   local file_count=0

   # Кавычки обязательны!
   echo "${file_count}"
   ```

4. **Проверка ошибок:**
   ```bash
   if [ ! -f "$file" ]; then
       echo "Error: File not found!" >&2
       exit 1
   fi
   ```

5. **Функции:**
   ```bash
   # Описание что функция делает
   # Arguments:
   #   $1 - path to directory
   # Returns:
   #   0 - success, 1 - error
   function check_directory() {
       local dir="$1"

       if [ -d "$dir" ]; then
           return 0
       else
           return 1
       fi
   }
   ```

6. **ShellCheck:**
   ```bash
   shellcheck script.sh
   ```
   Код должен проходить ShellCheck без ошибок (warnings допустимы, но объясните).

---

### Стиль документации

**README.md структура:**

```markdown
# Episode XX: Название

## 📚 Теория

### Основная тема
[Объяснение с примерами]

> **LILITH:**
> *"[Комментарий от LILITH]"*

## 🎯 Практика

### Задача 1
[Описание]

## 📊 Контрольные вопросы

### Вопрос 1
[Вопрос]

<details>
<summary>💡 Подсказка</summary>
[Подсказка]
</details>

<details>
<summary>✅ Ответ</summary>
[Ответ + LILITH комментарий]
</details>
```

**Требования:**
- Минимум 500 строк теории
- 5-10 контрольных вопросов
- LILITH комментарии в ключевых местах
- Примеры кода с объяснениями
- Ссылки на man pages

---

## 📦 Структура эпизода

Каждый эпизод **обязан** содержать:

```
episode-XX-название/
├── README.md           # Интегрированный: сюжет + теория + практика (1000-1500 строк)
├── starter.sh          # Шаблон с TODO (50-100 строк)
│
├── solution/
│   └── название.sh     # Полное решение (100-200 строк)
│
├── artifacts/
│   └── [файлы]         # Тестовые данные, конфиги, логи
│
└── tests/
    └── test.sh         # Автоматические тесты (100-200 строк)
```

### README.md — Интегрированный опыт (NEW! v0.1.3)

**Новый подход "Learn by Doing":**

**Структура:**
1. Краткий сюжет (20-40 строк) — мотивация и контекст
2. Подготовка окружения (инструкции setup)
3. 6-10 последовательных заданий:
   ```markdown
   ## 🎯 Задание X: Название

   [LILITH дает задачу]

   ### 🤔 Попробуй сам (время)
   [Описание что нужно сделать]

   <details>
   <summary>💡 Подсказка 1</summary>
   [Подсказка]
   </details>

   <details>
   <summary>📚 Теория</summary>
   [Теория именно по этой теме - just-in-time]
   </details>

   <details>
   <summary>✅ Решение</summary>
   [Решение с объяснением]
   </details>
   ```
4. Финальная задача (скрипт)
5. Оценка LILITH
6. Что узнал (чеклист)
7. Самопроверка

**Преимущества:**
- Сюжет → мотивация → задача → теория → практика (естественный поток)
- Теория появляется когда нужна (just-in-time learning)
- Меньше cognitive load (не 1000 строк теории сразу)
- LILITH как активный проводник, не просто комментарии

**Стиль:**
- Интерактивный
- Прогрессия сложности
- Понятно для новичков
- Технически точно
- LILITH tough love

---

### starter.sh — Шаблон

```bash
#!/bin/bash

################################################################################
# OPERATION KERNEL SHADOWS
# Episode XX: Название
#
# Задание: [краткое описание]
#
# TODO: Заполните TODO блоки ниже
################################################################################

echo "=== KERNEL SHADOWS: Episode XX ==="
echo ""

# TODO 1: [описание задачи]
# Подсказка: [как сделать]
# YOUR CODE HERE


# TODO 2: [следующая задача]
# YOUR CODE HERE


echo ""
echo "=== Mission complete! ==="
```

---

### solution/ — Референсное решение

**Требования:**
- Полностью рабочий код
- Комментарии к ключевым моментам
- Обработка ошибок
- Best practices bash
- Проходит ShellCheck
- Проходит все тесты

---

### artifacts/ — Тестовые данные

**Что включать:**
- Конфигурационные файлы
- Логи для анализа
- Тестовые данные
- README.md с инструкциями

**Требования:**
- Реалистичные данные (не lorem ipsum)
- Привязка к сюжету
- README объясняет как использовать

---

### tests/ — Автотесты

```bash
#!/bin/bash

# Test script template
# Проверяет правильность выполнения миссии

PASSED=0
FAILED=0

check_test() {
    local test_name="$1"
    local test_result=$2

    if [ $test_result -eq 0 ]; then
        echo "✓ $test_name"
        PASSED=$((PASSED + 1))
    else
        echo "✗ $test_name"
        FAILED=$((FAILED + 1))
    fi
}

# TEST 1: Check file exists
if [ -f "expected_file.txt" ]; then
    check_test "File exists" 0
else
    check_test "File exists" 1
fi

# ... больше тестов

# Summary
echo ""
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ $FAILED -eq 0 ]; then
    echo "✓✓✓ ALL TESTS PASSED! ✓✓✓"
    exit 0
else
    echo "✗✗✗ SOME TESTS FAILED ✗✗✗"
    exit 1
fi
```

**Требования:**
- Минимум 5 тестов
- Проверка файлов, output, exit codes
- Цветной output (опционально)
- Summary в конце

---

## 🧪 Тестирование

### Перед созданием Pull Request:

1. **Запустите тесты:**
   ```bash
   cd episode-XX/tests/
   ./test.sh
   ```

2. **ShellCheck:**
   ```bash
   shellcheck episode-XX/starter.sh
   shellcheck episode-XX/solution/*.sh
   shellcheck episode-XX/tests/test.sh
   ```

3. **Проверьте вручную:**
   - Скопируйте artifacts в чистую папку
   - Пройдите эпизод как студент
   - Засеките время (совпадает с заявленным?)
   - Проверьте все ссылки в документации

4. **Markdown lint:**
   ```bash
   markdownlint episode-XX/*.md
   ```

---

## 📖 Документация

### Обновление README.md

При добавлении эпизода обновите:

**season-X/README.md:**
```markdown
| Episode | Название | Сложность | Время | Статус |
|---------|----------|-----------|-------|--------|
| **XX** | Название | ⭐⭐☆☆☆ | 3-4ч | ✅ Ready |
```

**STATUS.md:**
```markdown
- [x] Episode XX — Complete (mission, README, artifacts, tests)
```

**CURRICULUM.md:**
- Обновите статус эпизода
- Проверьте что описание соответствует реализации

---

## 🎭 Сюжет и персонажи

### Консистентность сюжета

**Перед добавлением сюжетного контента:**

1. Прочитайте **SCENARIO.md** — основная сюжетная линия
2. Убедитесь что ваш эпизод вписывается в timeline
3. Персонажи должны вести себя консистентно
4. Проверьте факты (координаты, IP адреса, даты)

### Персонажи

**Макс Соколов:**
- Главный герой, сисадмин из Новосибирска
- Прагматичный, циничный, любит автоматизацию
- Растёт от новичка (S1) до профессионала (S8)

**LILITH:**
- AI-помощник, grey hat hacker
- Циничная, прямая, dark humor
- Билингвальный стиль (русский + английские термины)
- См. **LILITH.md** для фраз и стиля

**Виктор Петров:**
- Координатор операции
- Таинственный, строгий, военный стиль
- Ставит задачи, но не раскрывает всей картины

**Алекс Соколов:**
- Брат Макса, ex-FSB, grey hat hacker
- Ментор по security
- Защищает Макса, но втягивает в опасность

**Анна Ковалева, Дмитрий Орлов, Eva Zimmerman:**
- См. **SCENARIO.md** для деталей

### LILITH комментарии

**Стиль:**
- Русский язык + технические термины на английском
- Циничная, но конструктивная критика
- Примеры: *"Логи не врут. Люди — врут."*, *"Root — это оружие."*

**Частота:**
- После каждого теоретического блока
- В контрольных вопросах (ответы)
- При критических ошибках
- В критических ситуациях (миссия)

**НЕ делайте:**
- ❌ Слишком много LILITH (перегрузка)
- ❌ Слишком агрессивная (отпугнёт студентов)
- ❌ Чисто английский (только термины!)
- ❌ Inconsistent personality

---

## 📜 Лицензия

**GPL v3** — копилефт лицензия.

**Что это значит:**
- ✅ Ваш код остаётся вашим
- ✅ Но он должен быть открытым (GPL v3)
- ✅ Производные работы тоже GPL v3
- ✅ Коммерческое использование разрешено

**При создании Pull Request вы соглашаетесь:**
- Ваш вклад лицензирован под GPL v3
- Авторство будет указано в CREDITS.md

---

## 🎯 Приоритеты разработки

### Версия 0.4.4 (текущая) ✅
- [x] **Season 1: Shell & Foundations** (Episodes 01-04) — COMPLETE
  - [x] Episode 01: Terminal Awakening
  - [x] Episode 02: Shell Scripting Basics
  - [x] Episode 03: Text Processing Masters
  - [x] Episode 04: Package Management
- [x] **Season 2: Networking** (Episodes 05-08) — COMPLETE
  - [x] Episode 05: TCP/IP Fundamentals
  - [x] Episode 06: DNS & Name Resolution
  - [x] Episode 07: Firewalls & iptables
  - [x] Episode 08: VPN & SSH Tunneling
- [x] **Season 3: System Administration** (Episodes 09-12) — COMPLETE
  - [x] Episode 09: Users & Permissions (СПб 🇷🇺)
  - [x] Episode 10: Processes & Systemd
  - [x] Episode 11: Disk Management & LVM (Таллин 🇪🇪)
  - [x] Episode 12: Backup & Recovery
- [x] **Season 4: DevOps & Automation** (Episodes 13-16) — COMPLETE
  - [x] Episode 13: Git & Version Control (Берлин 🇩🇪)
  - [x] Episode 14: Docker Basics (Амстердам 🇳🇱)
  - [x] Episode 15: CI/CD Pipelines (Берлин 🇩🇪)
  - [x] Episode 16: Ansible & IaC (Амстердам → Берлин)
- [x] Глобальная концепция (8 стран, 27 персонажей, 60 дней)
- [x] "Learn by Doing" + Progressive hints (3-уровневая система)
- [x] LILITH как активный проводник
- [x] Интегрированная структура (теория just-in-time)
- [x] Гибридный подход именования (нарратив кириллица, техника translit)

### Версия 0.5.0 (следующая):
- [ ] **Season 5: Security & Pentesting** (Episodes 17-20)
  - [ ] Episode 17: Security Fundamentals (Цюрих 🇨🇭)
  - [ ] Episode 18: Penetration Testing Basics
  - [ ] Episode 19: Web Security (Женева 🇨🇭)
  - [ ] Episode 20: Incident Response & Forensics
- [ ] Локации: Цюрих → Женева
- [ ] Новые персонажи: Eva Zimmerman, Marcus Weber, Dr. Heinrich Bauer

### Версия 0.6.0 (планируется):
- [ ] Season 6: Embedded Linux (Шэньчжэнь 🇨🇳)
- [ ] LILITH CLI улучшения (интерактивный помощник)

### Что нужно сейчас:
1. **Season 5 Episodes 17-20** — начать разработку (Security & Pentesting)
2. **Community testing Seasons 1-4** — feedback от студентов
3. **LILITH визуализация** — аватар, иконки
4. **Переводы** — локализация курса на другие языки

---

## 📞 Контакты

- **GitHub Issues:** [github.com/gfazzz/kernel-shadows/issues](https://github.com/gfazzz/kernel-shadows/issues)
- **Discussions:** [github.com/gfazzz/kernel-shadows/discussions](https://github.com/gfazzz/kernel-shadows/discussions)

---

## 🙏 Благодарности

Спасибо всем, кто вносит вклад в **KERNEL SHADOWS**!

Ваши имена будут в **CREDITS.md**.

---

<div align="center">

**"We are ROOT. We are LILITH. We are the shadows of the kernel."**

---

**KERNEL SHADOWS v0.4.4** — Season 4: DevOps & Automation COMPLETE! 🎉🇳🇱🇩🇪

**Прогресс:** 50% (16/32 episodes) | **Следующая остановка:** Season 5 — Цюрих 🇨🇭

---

Сделано с ❤️ и lots of `sudo` commands

**Последнее обновление:** 10 октября 2025

[⬆ Наверх](#contributing-to-kernel-shadows)

</div>


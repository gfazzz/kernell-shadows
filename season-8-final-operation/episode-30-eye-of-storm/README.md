# ЭПИЗОД 30: ОКО БУРИ
**Сезон 8: Финальная операция** | День 58 из 60 | До финала: 3 дня

> *"Затишье перед бурей — самое опасное время. Именно тогда находишь то, что они прятали."* — Anna Kovaleva

---

## 📋 ОБЗОР

**Длительность:** 5-6 часов
**Сложность:** ⭐⭐⭐⭐⭐ (максимальная)
**Тип:** Глубокая криминалистика + расследование + экстренное усиление защиты
**Локация:** 🌐 Глобальная координация из 🇮🇸 Исландии

### Что происходит

**День 58. 06:00 UTC.** Атака отказа в обслуживании снизилась с 100 до 20 гигабит в секунду. 80% падение интенсивности за ночь. Слишком хорошо чтобы быть правдой.

**LILITH оповещение:** *"Интенсивность атаки снизилась на 80%. Либо они отступают, либо готовятся к чему-то большему. Анализирую..."*

**Anna Kovaleva (Санкт-Петербург):** *"Это не отступление. Это перегруппировка. У нас есть окно — несколько часов. Максимум сутки. Используй их правильно, Макс."*

**Макс:** *"Что делать?"*

**Anna:** *"Глубокая криминалистика. Найти ВСЁ: как они зашли, когда, через что. Один пропущенный бэкдор — и следующая атака будет хуже."*

**Вы научитесь:**
1. ✅ Восстанавливать временную шкалу атаки (криминалистика)
2. ✅ Обнаруживать атаки цепочки поставок (Docker, NPM, PyPI)
3. ✅ Анализировать ложные срабатывания (Marcus Weber case)
4. ✅ Экстренно усиливать защиту всех серверов (SELinux, auditd, fail2ban)
5. ✅ Собирать разведданные об угрозах (OSINT, TOR analysis)
6. ✅ Координировать глобальную команду под давлением

**Технологии:**
- 🔍 Цифровая криминалистика: auditd, aide, journalctl
- 🐳 Анализ Docker: проверка контрольных сумм образов, цепочка поставок
- 🔐 Экстренное усиление: SELinux, AppArmor, fail2ban
- 📊 Корреляция логов: сопоставление событий через 50 серверов
- 🌐 Разведка угроз: OSINT, анализ TOR
- 🐍 Python: агрегация данных разведки
- 🚀 Ansible: быстрое развёртывание исправлений

---

## 🎬 ПРОЛОГ: ЗАТИШЬЕ ПЕРЕД БУРЕЙ

**06:00 UTC, День 58**
**Verne Global датацентр, Исландия**

Макс сидит перед десятью мониторами. 16 часов без сна. Глаза красные, руки дрожат от кофеина. Но графики Grafana показывают то, чего он не ожидал.

**Макс (в чат команды):** *"Нагрузка упала. 20 гигабит. Что это значит?"*

**Erik (Стокгольм):** *"VPN серверы дышат. Первый раз за 14 часов."*

**Dmitry (Берлин):** *"Kubernetes scaled down. 500 → 150 подов."*

**Макс:** *"Они прекратили?"*

**LILITH (голосовое оповещение):** *"Отрицательно. Интенсивность снизилась, но атака не остановлена. Анализирую паттерны..."*

Тишина. Макс ждёт. LILITH анализирует петабайты логов за секунды.

**LILITH:** *"Вывод: тактическая перегруппировка. Предыдущая атака — разведка вашей защиты. Они тестировали пределы. Теперь адаптируются."*

**Макс (холодок по спине):** *"Сколько времени у нас?"*

**LILITH:** *"Минимум 6 часов. Максимум 24. Неопределённость высокая."*

В этот момент в видеочат подключается **Anna Kovaleva** из Санкт-Петербурга. Лицо серьёзное.

**Anna:** *"Макс. День 57 — это была разведка боем. Настоящая атака будет хуже. У нас есть окно. Время для глубокой криминалистики."*

**Макс:** *"Объясни."*

**Anna:** *"Вчера мы закрыли симптомы — остановили атаку отказа, изолировали контейнеры, удалили 5 бэкдоров. Но не нашли причину. КАК они зашли? КОГДА? ЧЕРЕЗ ЧТО? Один пропущенный бэкдор = следующая атака начнётся изнутри."*

**Макс:** *"Что конкретно искать?"*

**Anna:** *"Всё. Восстанавливаем полную временную шкалу атаки. От первого проникновения до вчерашнего дня. 50 серверов, 60 дней логов. Найдём первопричину."*

**Viktor (зашифрованное сообщение):** *"Макс. Anna права. Следующие 12 часов критичны. Координация: Anna ведёт расследование, ты — техническая поддержка. Используй всю команду."*

Макс глубоко вдыхает. Кофе остыл. Взгляд на часы: 06:15 UTC.

**Макс:** *"LILITH, готова к глубокому анализу?"*

**LILITH:** *"Все системы готовы. Начинаем."*

---

## ЧАСТЬ 1: ВОССТАНОВЛЕНИЕ ВРЕМЕННОЙ ШКАЛЫ (06:30-08:00 UTC)

### 🎬 Первый вопрос: Когда началось?

**Anna (через видеосвязь):** *"Макс, вопрос номер один криминалистики: когда началась атака? Не вчера. Вчера она проявилась. Но когда НАЧАЛАСЬ?"*

**Макс:** *"Бэкдоры вчера нашли. Значит тогда?"*

**Anna:** *"Нет. Бэкдоры обнаружены — не значит установлены. Профессиональные атакующие прячут бэкдоры недели, иногда месяцы, перед активацией. Нужно найти момент установки."*

**Макс:** *"Как?"*

**Anna:** *"Auditd логи. Они записывают ВСЁ: создание файлов, изменение разрешений, запуск процессов. Если бэкдор установлен — auditd видел это."*

**Макс:** *"У нас 50 серверов. 60 дней логов. Это терабайты."*

**LILITH:** *"Объясню метод. Слушай."*

### 📚 LILITH объясняет: Временная шкала криминалистики

**LILITH:** *"Криминалистика — это не поиск иглы в стоге сена. Это восстановление истории преступления.*

*Представь детективный фильм:*
- *Преступление произошло 22:00*
- *Свидетели видели подозрительного человека 21:45*
- *Камера зафиксировала машину 21:30*
- *Билет на парковку 21:15*

*Детектив идёт НАЗАД во времени. От преступления к первопричине.*

*В Linux то же самое:*

```
СЕЙЧАС (День 58):         Бэкдор АКТИВЕН
       ↑
День 57, 12:00:          Бэкдор обнаружен через AIDE
       ↑
День 57, 08:00:          Бэкдор впервые появился в процессах (ps aux)
       ↑
День ХХ, ХХ:ХХ:          Бэкдор файл создан (auditd) ← ЭТО ИЩЕМ!
       ↑
День YY, YY:YY:          Первое подозрительное соединение (netstat)
```

*Идём от известного (бэкдор активен) к неизвестному (когда установлен)."*

**Макс:** *"Понял. Ищем момент создания файла бэкдора."*

**LILITH:** *"Точно. Auditd команда:"*

```bash
ausearch -f /путь/к/бэкдору -i
```

*Флаг `-f` = файл, `-i` = интерпретировать (читаемый формат).*

*Покажет:*
- *Когда файл создан*
- *Кто создал (пользователь, процесс)*
- *Откуда запущен (IP, терминал)*

*Это первый шаг временной шкалы."*

### 💻 Макс применяет (немедленно)

**Макс:** *"Проверяем. Бэкдор от вчера: `/usr/lib/systemd/sshd_backup`"*

```bash
ssh server-27 "ausearch -f /usr/lib/systemd/sshd_backup -i"
```

**Вывод:**
```
type=PATH msg=audit(10/10/2025 14:23:47.112:98473)
  name=/usr/lib/systemd/sshd_backup
  inode=2785449 dev=08:01 mode=file,755
  ouid=root ogid=root

type=SYSCALL msg=audit(10/10/2025 14:23:47.112:98473)
  syscall=open arch=x86_64 success=yes
  exe=/usr/bin/docker
  uid=root gid=root
  auid=root
```

**Макс (вслух):** *"10 октября, 14:23. Это 14 дней назад. День 43!"*

**Anna:** *"День 43? Проверь календарь операции."*

**Макс (смотрит в CURRICULUM.md):** *"День 43... Season 6. Шэньчжэнь, Китай!"*

**Anna:** *"Интересно. Продолжай. Кто создал файл?"*

**Макс:** *"exe=/usr/bin/docker. Docker создал файл."*

**Anna:** *"Docker не создаёт файлы сам. Только через контейнеры. Значит контейнер установил бэкдор. Какой контейнер?"*

**LILITH:** *"Проверь Docker логи того времени."*

### 💻 Проверка Docker логов

**Макс:**
```bash
journalctl -u docker --since "2025-10-10 14:20" --until "2025-10-10 14:30" | grep container
```

**Вывод:**
```
Oct 10 14:22:15 server-27 dockerd: time="2025-10-10T14:22:15Z"
  level=info msg="Container started"
  container_id=a7f3d9e4c1b2
  image=viktor/crypto-toolkit:latest
```

**Макс (шок):** *"viktor/crypto-toolkit. Это наш образ! Я его устанавливал Episode 14!"*

**Anna:** *"Образ скомпрометирован. Атака цепочки поставок. Классика."*

**Макс:** *"Как это возможно? Мы проверяли образы!"*

**LILITH:** *"Объясню концепцию атаки цепочки поставок. Это важно."*

---

## ЧАСТЬ 2: АТАКА ЦЕПОЧКИ ПОСТАВОК (08:00-10:00 UTC)

### 📚 LILITH объясняет: Supply Chain Attack

**LILITH:** *"Атака цепочки поставок (supply chain attack) — это не взлом ТВОЕЙ системы. Это взлом того, КОМУ ТЫ ДОВЕРЯЕШЬ.*

*Метафора: Ты покупаешь хлеб в магазине.*
- *Обычный взлом: Вор врывается в твой дом, крадёт хлеб.*
- *Атака цепочки поставок: Вор подкупает пекаря. Пекарь кладёт яд в тесто. Ты покупаешь отравленный хлеб в НАДЁЖНОМ магазине.*

*Ты не виноват. Пекарь скомпрометирован.*

*В IT то же самое:*

```
Ты доверяешь:                    Атакующий компрометирует:
- Docker Hub                  →  Образ на Docker Hub
- NPM registry                →  Пакет на NPM
- PyPI                        →  Библиотеку на PyPI
- Ubuntu репозиторий          →  .deb пакет (редко, но бывает)
- GitHub                      →  Репозиторий через stolen credentials
```

*Результат: Ты устанавливаешь ОФИЦИАЛЬНЫЙ пакет. Но в нём бэкдор."*

**Макс:** *"Значит Docker Hub скомпрометирован?"*

**LILITH:** *"Не весь Docker Hub. Только ТВОЙ аккаунт. viktor/crypto-toolkit — это образ, который ТЫ загрузил. Не Docker Inc."*

**Макс:** *"Как они получили доступ к аккаунту?"*

**Anna:** *"Это выясним. Сначала проверим: образ действительно скомпрометирован?"*

**LILITH:** *"Покажу как проверить. Контрольные суммы (checksums)."*

### 📚 LILITH объясняет: Проверка целостности образов

**LILITH:** *"Каждый Docker образ имеет контрольную сумму (digest) — уникальный отпечаток содержимого.*

*Представь фотографию паспорта:*
- *Оригинал паспорта = Docker образ*
- *Фотография паспорта = Контрольная сумма (SHA256 hash)*

*Если кто-то изменит паспорт (добавит бэкдор) → фотография не совпадёт.*

*Docker команда:*

```bash
docker images --digests
```

*Покажет контрольные суммы всех образов.*

*Сравни с ОФИЦИАЛЬНОЙ контрольной суммой (из документации или Docker Hub).*

*Не совпадают = образ изменён после публикации."*

**Макс:** *"Проверяю."*

### 💻 Проверка контрольной суммы

**Макс:**
```bash
docker images --digests | grep crypto-toolkit
```

**Вывод:**
```
viktor/crypto-toolkit  latest  sha256:7f8a3d9e2c1b...  500MB
```

**Макс:** *"Контрольная сумма: `sha256:7f8a3d9e2c1b...`. Где официальная?"*

**Anna:** *"Проверь Docker Hub. Страница образа."*

**Макс (открывает браузер, hub.docker.com/r/viktor/crypto-toolkit):**

**Docker Hub показывает:**
```
Latest pushed: 15 days ago (Day 43!)
Digest: sha256:a2b3c4d5e6f7...
```

**Макс:** *"Не совпадает! Docker Hub: a2b3c4d5... Мой сервер: 7f8a3d9e..."*

**Anna:** *"Образ изменён ПОСЛЕ загрузки на Docker Hub."*

**Макс:** *"Как?!"*

**LILITH:** *"Анализирую историю образа..."*

```bash
docker history viktor/crypto-toolkit:latest
```

**Вывод:**
```
IMAGE          CREATED        CREATED BY                                      SIZE
7f8a3d9e2c1b   14 days ago    /bin/sh -c #(nop) COPY file:a7f... /usr/lib     15kB  ← SUSPICIOUS
a2b3c4d5e6f7   16 days ago    /bin/sh -c apt-get install -y ...              250MB
...
```

**LILITH:** *"Найден дополнительный слой. Создан 14 дней назад (День 43). Добавлен файл 15KB в /usr/lib."*

**Макс:** *"Это бэкдор."*

**Anna:** *"Точно. Теперь вопрос: КАК они добавили слой?"*

---

## ЧАСТЬ 3: РАССЛЕДОВАНИЕ МАРКУСА ВЕБЕРА (10:00-12:00 UTC)

### 🎬 Подозрение

**Anna:** *"Макс, кто имеет доступ к Docker Hub аккаунту viktor/crypto-toolkit?"*

**Макс (проверяет):** *"Только Viktor и... Dmitry. Dmitry помогал с Episode 14."*

**Anna:** *"Dmitry сейчас где?"*

**Макс:** *"Берлин."*

**Anna:** *"Проверь логи доступа Docker Hub. Когда образ изменён?"*

**Макс (Docker Hub → Settings → Access Logs):**

```
Oct 10, 2025 14:20 UTC - Image pushed - IP: 185.27.134.52 - User: marcus.weber
```

**Макс (шок):** *"Marcus Weber? Это не Dmitry. Marcus — инженер из Amsterdam (Episode 14)!"*

**Anna:** *"Marcus имел доступ к аккаунту?"*

**Макс:** *"Нет! Никогда!"*

**LILITH:** *"Анализирую IP адрес 185.27.134.52..."*

**Результат:**
```
IP: 185.27.134.52
Location: Amsterdam, Netherlands
ISP: KPN
Type: VPN exit node (NordVPN)
```

**LILITH:** *"VPN. Настоящий IP скрыт."*

**Anna:** *"Макс, у вас в команде есть VPN логи? Кто подключался через VPN Day 43?"*

**Макс (проверяет WireGuard логи Episode 08):**

```bash
grep "185.27.134.52" /var/log/wireguard/connections.log
```

**Вывод:**
```
2025-10-10 14:18:45 - Client connected
  Public key: xT7j...
  Assigned IP: 10.8.0.15
  Exit IP: 185.27.134.52
  User: marcus.weber
```

**Макс:** *"VPN логи подтверждают. Marcus подключался через VPN 14:18, за 2 минуты до push образа."*

**Anna:** *"Теперь главный вопрос: Marcus предатель или жертва?"*

**Макс:** *"Как узнать?"*

**LILITH:** *"Объясню методологию расследования инсайдерских угроз."*

### 📚 LILITH объясняет: Инсайдерская угроза vs Захваченные учётные данные

**LILITH:** *"Когда подозрительная активность от внутреннего пользователя, два сценария:*

*Сценарий 1: Инсайдерская угроза (Insider Threat)*
- *Пользователь сам атакующий*
- *Мотивация: деньги, месть, идеология*
- *Поведение: осторожное, скрывает следы*
- *Паттерн: постепенная эскалация действий*

*Сценарий 2: Захват учётных данных (Credential Theft)*
- *Пользователь жертва, атакующий использует его аккаунт*
- *Мотивация атакующего: маскировка*
- *Поведение: необычное для пользователя*
- *Паттерн: резкие изменения (внезапная активность)*

*Как различить?*

*Проверь:*
1. *Паттерн поведения: Типично ли это для пользователя?*
2. *Временные аномалии: Активность в необычное время?*
3. *Технические несоответствия: Необычные инструменты, IP, устройства?*
4. *Контекст: Пользователь знал ли о действиях?*

*Метафора: Твой друг вдруг продаёт твою машину.*
- *Инсайдер: Он сам решил продать (мотивация)*
- *Захват: Кто-то украл ключи, выдал себя за него (identity theft)"*

**Макс:** *"Понял. Проверяем паттерн поведения Marcus."*

### 💻 Анализ поведения

**Anna:** *"Макс, опроси Marcus. Прямо. Спроси что он делал Day 43, 14:20."*

**Макс (звонок по видеосвязи Marcus Weber, Amsterdam):**

**Marcus (удивлён):** *"Макс? Day 43? 14:20 UTC? Let me check my calendar... I was in meeting. 14:00-15:00. Weekly team sync."*

**Макс:** *"Ты уверен? Логи показывают ты подключался к VPN 14:18."*

**Marcus (смотрит в свои логи):** *"VPN... 14:18... Wait. My laptop did disconnect that time. VPN dropped. I reconnected 14:25. But between — no, I was in meeting room. No laptop."*

**Anna (в чате Макса):** *"Спроси: Кто-то ещё имел доступ к его laptop?"*

**Макс:** *"Marcus, кто мог использовать твой laptop 14:18-14:25?"*

**Marcus (думает):** *"No one. But... wait. My VPN session. It disconnected sudden. Like... kicked off. Then I reconnected manually."*

**LILITH (оповещение Максу):** *"Критично. Проверь VPN логи 14:18. Две сессии одновременно?"*

**Макс (проверяет WireGuard):**

```bash
grep "marcus.weber" /var/log/wireguard/connections.log | grep "2025-10-10 14:"
```

**Вывод:**
```
14:05:12 - marcus.weber connected (IP: 10.8.0.15) from 82.217.142.33 (Amsterdam)
14:18:45 - marcus.weber connected (IP: 10.8.0.15) from 185.27.134.52 (VPN)
14:18:46 - marcus.weber disconnected (IP from 82.217.142.33) - reason: duplicate_session
14:25:03 - marcus.weber connected (IP: 10.8.0.15) from 82.217.142.33 (Amsterdam)
```

**Макс (понимание):** *"Два подключения одновременно! 14:18 — новая сессия из 185.27.134.52 вытеснила настоящую сессию Marcus (82.217.142.33)."*

**Anna:** *"Session hijacking. Классика. Атакующий украл учётные данные Marcus, подключился, вытеснил настоящего пользователя."*

**Макс (Marcus):** *"Marcus, ты жертва. Кто-то украл твои учётные данные VPN."*

**Marcus (облегчение + страх):** *"I thought I was... traitor. Thank you for investigating. But... how did they steal my credentials?"*

**LILITH:** *"Анализирую методы кражи учётных данных. Наиболее вероятный: фишинг."*

### 📚 LILITH объясняет: Фишинг (Phishing)

**LILITH:** *"Фишинг (phishing, от 'fishing' = рыбалка) — техника кражи учётных данных через обман.*

*Метафора: Ты рыба.*
- *Атакующий = рыбак*
- *Фишинговое письмо = наживка на крючке*
- *Поддельный сайт = ловушка*

*Ты кусаешь наживку (открываешь ссылку) → попадаешь на крючок (вводишь пароль на поддельном сайте) → пойман.*

*Классический сценарий:*

```
1. Атакующий отправляет email:
   "Docker Hub Security Alert: Password reset required
    Click here: https://docker-hub-security.com/reset"

   ↓ Жертва кликает (ссылка выглядит легитимно)

2. Открывается поддельный сайт (идентичен Docker Hub)
   Форма: "Enter your Docker Hub credentials"

   ↓ Жертва вводит логин + пароль

3. Поддельный сайт:
   - Сохраняет учётные данные
   - Перенаправляет на настоящий Docker Hub

   ↓ Жертва не замечает проблемы

4. Атакующий получает:
   - Логин: marcus.weber
   - Пароль: ********

   ↓ Использует немедленно

5. Marcus теряет контроль над аккаунтом
```

*Признаки фишинга:*
- *Подозрительный домен (docker-hub-security.com ≠ hub.docker.com)*
- *Срочность (требует немедленного действия)*
- *Угрозы (аккаунт будет заблокирован)*
- *Грамматические ошибки (иногда)*
- *Подозрительный отправитель*

*Защита:*
1. *Проверяй URL перед вводом учётных данных*
2. *Используй password manager (автозаполнение только на настоящих сайтах)*
3. *Включи 2FA (two-factor authentication)*
4. *НЕ кликай ссылки в подозрительных письмах*"

**Макс (Marcus):** *"Marcus, ты получал подозрительные письма Day 42-43?"*

**Marcus (проверяет email архив):** *"Wait... yes. Day 42. Email from 'Docker Security Team'. Password reset link. I clicked... Oh no."*

**Anna:** *"Классический фишинг. Marcus, ты не виноват. Профессиональный фишинг обманывает даже экспертов."*

**Marcus:** *"I am so sorry..."*

**Viktor (подключается к видеочату):** *"Marcus, ты жертва, не виновный. Учётные данные сброшены. Ты в безопасности. Макс, продолжай расследование."*

**Макс:** *"Marcus cleared. Он жертва фишинга Day 42. Атакующие украли учётные данные, использовали Day 43 для компрометации Docker образа."*

**Anna:** *"Хорошо. Теперь главное: сколько серверов используют скомпрометированный образ?"*

---

## ЧАСТЬ 4: МАСШТАБ ЗАРАЖЕНИЯ (12:00-14:00 UTC)

### 🎬 Проверка всех серверов

**Макс:** *"LILITH, сканируй все 50 серверов. Ищи образ viktor/crypto-toolkit:latest."*

**LILITH:** *"Запускаю проверку..."*

```bash
ansible all -m shell -a "docker images | grep crypto-toolkit"
```

**Результат через 30 секунд:**

```
server-01: viktor/crypto-toolkit:latest
server-05: viktor/crypto-toolkit:latest
server-08: viktor/crypto-toolkit:latest
server-12: viktor/crypto-toolkit:latest
...
[47 серверов найдено]
```

**Dmitry (Берлин, видеочат):** *"47 из 50 серверов. Это катастрофа."*

**Anna:** *"47 серверов потенциально скомпрометированы. Каждый может содержать бэкдор."*

**Макс:** *"Что делать?"*

**Anna:** *"Проверить каждый. Искать признаки активации бэкдора."*

**LILITH:** *"Покажу как. Используем AIDE (Advanced Intrusion Detection Environment)."*

### 📚 LILITH объясняет: AIDE — Обнаружение изменений в системе

**LILITH:** *"AIDE (Advanced Intrusion Detection Environment) — инструмент обнаружения вторжений через мониторинг изменений файлов.*

*Концепция: Снимок системы (baseline) vs Текущее состояние*

*Представь фотографию комнаты:*
1. *Делаешь фото (AIDE инициализация) — это baseline*
2. *Через неделю делаешь новое фото*
3. *Сравниваешь: что изменилось?*
   - *Новая книга на столе? (Новый файл)*
   - *Картина криво висит? (Permissions изменились)*
   - *Ваза разбита? (Файл модифицирован)*

*AIDE делает то же с файловой системой:*

```
Baseline (инициализация):
  /usr/bin/sshd       - размер 950KB, SHA256 a3f7...
  /etc/passwd         - размер 2.1KB, SHA256 b8e4...
  /lib/systemd/...    - [не существовал]

Проверка (через неделю):
  /usr/bin/sshd       - размер 950KB, SHA256 a3f7... ✓ Не изменён
  /etc/passwd         - размер 2.3KB, SHA256 c9d2... ✗ ИЗМЕНЁН!
  /lib/systemd/sshd_backup - размер 15KB          ✗ НОВЫЙ ФАЙЛ!
```

*AIDE сообщит: 2 аномалии найдены.*

*Команды:*

```bash
# Инициализация (создать baseline)
aide --init
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Проверка (сравнить текущее состояние с baseline)
aide --check

# Обновление baseline (после легитимных изменений)
aide --update
```

*Использование: Запускать aide --check ежедневно (через cron).*"

**Макс:** *"Проверяем."*

### 💻 Проверка через AIDE

**Макс:**
```bash
ansible all -m shell -a "aide --check" > aide_report.txt
```

**Результат (после 2 минут):**

```
server-01: 3 files changed, 1 new file added
  Changed: /etc/shadow (passwords modified)
  Changed: /var/log/auth.log (normal activity)
  Changed: /usr/bin/curl (SUSPICIOUS!)
  New: /usr/lib/systemd/sshd_backup (BACKDOOR!)

server-05: 2 files changed, 1 new file added
  ...

[47 серверов с аномалиями]
```

**Макс:** *"47 серверов подтверждены скомпрометированными. Бэкдор активен на всех."*

**Dmitry (паника):** *"47 серверов. Как мы пропустили?"*

**Viktor:** *"Потому что атака была профессиональной. Docker supply chain — это advanced техника. Дмитрий, не вини себя."*

**Anna:** *"Макс, теперь главное: очистка."*

**Макс:** *"Как?"*

**Anna:** *"Rebuild всех образов из проверенного источника. Через Ansible. Быстро."*

---

## ЧАСТЬ 5: ЭКСТРЕННАЯ ОЧИСТКА (14:00-16:00 UTC)

### 📚 LILITH объясняет: Стратегия очистки после компрометации

**LILITH:** *"Когда система скомпрометирована, два подхода:*

*Подход 1: Точечная очистка (Targeted Cleanup)*
- *Найти и удалить конкретный бэкдор*
- *Плюсы: Быстро, не прерывает работу*
- *Минусы: Риск пропустить скрытые артефакты*
- *Когда использовать: Поверхностная компрометация, нет доступа root*

*Подход 2: Полная перестройка (Full Rebuild)*
- *Удалить ВСЁ скомпрометированное, rebuild из чистого источника*
- *Плюсы: Гарантия чистоты*
- *Минусы: Медленно, требует downtime*
- *Когда использовать: Глубокая компрометация, доступ root был*

*Метафора:*
- *Точечная: Найти крысу в доме, выгнать → Но могут быть ещё*
- *Полная: Снести дом, rebuild из кирпича → Гарантия нет крыс*

*В вашем случае: Supply chain attack, Docker образы = Полная перестройка единственный надёжный вариант.*

*План:*
1. *Скачать ЧИСТЫЙ базовый образ (ubuntu:22.04) из официального источника с проверенной контрольной суммой*
2. *Rebuild всех ваших образов из чистого базового*
3. *Redeploy контейнеры через Ansible (47 серверов)*
4. *Проверить через AIDE: бэкдоры исчезли*"

**Макс:** *"Это займёт часы."*

**Anna:** *"У нас нет выбора. Следующая атака может начаться через 12 часов. Нужно очистить ВСЁ до того."*

**Viktor:** *"Макс, Dmitry поможет. Он DevOps expert. Coordinate."*

**Dmitry:** *"Макс, я готов playbook Ansible для rebuild. Запускаем?"*

**Макс:** *"Да. Немедленно."*

### 💻 Ansible Playbook: Emergency Rebuild

**Dmitry (создаёт playbook через screen sharing):**

```yaml
---
# emergency_rebuild.yml
- name: Emergency Docker Image Rebuild
  hosts: all
  become: yes

  tasks:
    - name: Stop all compromised containers
      shell: docker stop $(docker ps -q --filter ancestor=viktor/crypto-toolkit)
      ignore_errors: yes

    - name: Remove compromised containers
      shell: docker rm $(docker ps -aq --filter ancestor=viktor/crypto-toolkit)
      ignore_errors: yes

    - name: Remove compromised image
      docker_image:
        name: viktor/crypto-toolkit
        tag: latest
        state: absent

    - name: Pull clean base image (verified digest)
      docker_image:
        name: ubuntu
        tag: "22.04"
        source: pull
        # Verified digest from Ubuntu official
        force_source: yes

    - name: Rebuild application image from clean source
      docker_image:
        name: viktor/crypto-toolkit-clean
        tag: latest
        build:
          path: /opt/rebuild/
          dockerfile: Dockerfile.clean
        source: build

    - name: Start containers from clean image
      docker_container:
        name: crypto-toolkit
        image: viktor/crypto-toolkit-clean:latest
        state: started
        restart_policy: always

    - name: Run AIDE check after rebuild
      command: aide --check
      register: aide_result

    - name: Report AIDE results
      debug:
        msg: "{{ aide_result.stdout }}"
```

**Dmitry:** *"Playbook готов. Запускаем на всех 47 серверах?"*

**Макс:** *"Запускай."*

### 💻 Выполнение Rebuild

**Dmitry:**
```bash
ansible-playbook emergency_rebuild.yml \
  --limit "server-01,server-05,server-08,..." \
  --forks 10
```

**Вывод (real-time):**

```
PLAY [Emergency Docker Image Rebuild] ****************************

TASK [Stop all compromised containers] ***************************
ok: [server-01]
ok: [server-05]
...
[10 серверов параллельно]

TASK [Remove compromised image] **********************************
changed: [server-01]
...

TASK [Pull clean base image] *************************************
ok: [server-01] (downloaded 250MB)
...

TASK [Rebuild application image] *********************************
changed: [server-01] (build time: 3m 42s)
...

TASK [Run AIDE check] ********************************************
ok: [server-01]
  AIDE check: 1 file removed (/usr/lib/systemd/sshd_backup)
  No new anomalies detected
...

PLAY RECAP *******************************************************
server-01  : ok=8  changed=3  unreachable=0  failed=0
server-05  : ok=8  changed=3  unreachable=0  failed=0
...

Total time: 1h 47m (47 servers, 10 parallel)
```

**Макс (облегчение):** *"47 серверов очищены. Бэкдоры удалены."*

**Dmitry:** *"AIDE подтверждает: аномалии исчезли."*

**Anna:** *"Хорошая работа. Но это только часть. Теперь усиление защиты."*

---

## ЧАСТЬ 6: ЭКСТРЕННОЕ УСИЛЕНИЕ ЗАЩИТЫ (16:00-18:00 UTC)

### 🎬 Укрепление периметра

**Anna:** *"Макс, rebuild завершён. Но атакующие знают нашу инфраструктуру. Они вернутся. Нужно усилить защиту ВСЕХ серверов. Немедленно."*

**Макс:** *"Что конкретно?"*

**Anna:** *"Три уровня:*
1. *SELinux в enforcing режим (принудительный контроль доступа)*
2. *Auditd максимальное логирование (запись всех подозрительных действий)*
3. *Fail2ban агрессивный режим (блокировка после 3 попыток вместо 5)*"

**LILITH:** *"Объясню каждый."*

### 📚 LILITH объясняет: SELinux (Security-Enhanced Linux)

**LILITH:** *"SELinux (Security-Enhanced Linux) — система обязательного контроля доступа (MAC = Mandatory Access Control).*

*Без SELinux (DAC = Discretionary Access Control):*
```
Пользователь root → Может делать ВСЁ
Процесс с UID 0 → Полный контроль системы
```

*С SELinux (MAC):*
```
Даже root ограничен политиками SELinux
Процесс nginx → Может читать /var/www/, НЕ может читать /home/
Процесс sshd → Может bind port 22, НЕ может bind port 80
```

*Метафора: Тюрьма с охраной*
- *DAC = Самоуправление заключённых (root = глава)*
- *MAC = Охранники контролируют ВСЕХ (даже главу)*

*SELinux режимы:*
1. *Disabled — выключен (НЕ рекомендуется)*
2. *Permissive — логирует нарушения, но НЕ блокирует (тестирование)*
3. *Enforcing — блокирует нарушения (production)*

*Команды:*
```bash
# Проверить текущий режим
getenforce

# Установить enforcing
setenforce 1

# Постоянно (после перезагрузки)
sed -i 's/SELINUX=permissive/SELINUX=enforcing/' /etc/selinux/config
```

*Почему важно СЕЙЧАС: Если бэкдор вернётся, SELinux ограничит его действия.*"

**Макс:** *"Применяем на всех серверах."*

### 💻 Применение SELinux

**Макс:**
```bash
ansible all -m command -a "setenforce 1"
```

**Вывод:**
```
server-01: changed
server-02: changed
...
[50/50 серверов успешно]
```

**LILITH:** *"SELinux enforcing активирован на всех 50 серверах."*

**Anna:** *"Хорошо. Теперь auditd."*

### 📚 LILITH объясняет: Auditd — Максимальное логирование

**LILITH:** *"Auditd (Linux Audit Daemon) — система аудита ядра Linux. Записывает все системные вызовы.*

*Представь камеры наблюдения в банке:*
- *Без auditd: Нет камер → Не знаешь кто зашёл*
- *С auditd: Камеры везде → Каждое действие записано*

*Auditd записывает:*
- *Создание/удаление файлов*
- *Изменение разрешений*
- *Вход пользователей*
- *Запуск процессов*
- *Сетевые соединения*
- *Изменения системных конфигураций*

*Для экстренного режима: максимальная детализация*

```bash
# /etc/audit/rules.d/emergency.rules

# Мониторить все изменения в /usr/bin, /usr/lib
-w /usr/bin -p wa -k binary_changes
-w /usr/lib -p wa -k library_changes

# Мониторить создание сетевых соединений
-a always,exit -F arch=b64 -S socket -k network_connections

# Мониторить запуск процессов
-a always,exit -F arch=b64 -S execve -k process_execution

# Мониторить изменения /etc/
-w /etc/ -p wa -k config_changes
```

*Применение:*
```bash
# Копировать правила
cp emergency.rules /etc/audit/rules.d/

# Перезагрузить auditd
service auditd restart

# Проверка
auditctl -l  # Покажет активные правила
```

*Результат: Любое подозрительное действие будет записано."*

**Макс:** *"Применяем."*

### 💻 Применение Auditd

**Макс создаёт playbook:**

```yaml
---
- name: Emergency Auditd Configuration
  hosts: all
  become: yes
  tasks:
    - name: Copy emergency audit rules
      copy:
        dest: /etc/audit/rules.d/emergency.rules
        content: |
          -w /usr/bin -p wa -k binary_changes
          -w /usr/lib -p wa -k library_changes
          -a always,exit -F arch=b64 -S socket -k network_connections
          -a always,exit -F arch=b64 -S execve -k process_execution
          -w /etc/ -p wa -k config_changes

    - name: Restart auditd
      systemd:
        name: auditd
        state: restarted
```

**Выполнение:**
```bash
ansible-playbook emergency_auditd.yml
```

**Результат:** *50/50 серверов: auditd максимальное логирование активно*

**Anna:** *"Отлично. Последнее: Fail2ban."*

### 📚 LILITH объясняет: Fail2ban — Агрессивная блокировка

**LILITH:** *"Fail2ban — инструмент блокировки IP после неудачных попыток входа.*

*Стандартный режим:*
```
5 неудачных попыток SSH → ban на 10 минут
```

*Агрессивный режим (для экстренной ситуации):*
```
3 неудачных попыток → ban на 24 часа
```

*Метафора: Охранник на входе*
- *Стандарт: 5 ошибок пароля → "Подождите 10 минут"*
- *Агрессивный: 3 ошибки → "Доступ закрыт на сутки"*

*Конфигурация:*

```ini
# /etc/fail2ban/jail.local
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3     # Было 5
bantime = 86400  # 24 часа (было 600 = 10 минут)
findtime = 600   # Окно поиска попыток
```

*Применение:*
```bash
# Скопировать конфигурацию
cp jail.local /etc/fail2ban/

# Перезагрузить
systemctl restart fail2ban

# Проверка
fail2ban-client status sshd
```"

**Макс:** *"Применяем на всех серверах."*

**Ansible playbook + выполнение → 50/50 успешно**

**Макс:** *"Завершено. Три уровня защиты активны:*
- *SELinux enforcing*
- *Auditd максимальное логирование*
- *Fail2ban агрессивный режим*

*Инфраструктура укреплена."*

**Anna:** *"Хорошая работа. Теперь последнее: The Architect."*

---

## ЧАСТЬ 7: СЛЕД АРХИТЕКТОРА (18:00-20:00 UTC)

### 🎬 Зашифрованное сообщение

**Anna:** *"Макс, пока ты восстанавливал серверы, я анализировала код бэкдора."*

**Макс:** *"Что нашла?"*

**Anna (шарит экран):** *"Зашифрованный комментарий в исходном коде бэкдора."*

```c
// backdoor.c (line 47)
// [ENCRYPTED] 4e6577206f72646572207468652074727574682068696465732069
```

**Anna:** *"Hex кодировка. Декодирую..."*

```bash
echo "4e6577206f72646572..." | xxd -r -p
```

**Результат:**
```
"New order: the truth hides in plain sight. Check Novosibirsk logs, Day 2. - Architect"
```

**Макс (шок):** *"Day 2? Это Episode 01! Новосибирск. Мой первый день операции."*

**Viktor (подключается):** *"Day 2 что значит?"*

**Anna:** *"Не знаю. Но Architect оставил след. Намеренно. Проверяем логи Day 2."*

**Макс:** *"LILITH, ищи логи Day 2."*

**LILITH:** *"Checking archived logs Season 1 Episode 01..."*

*(Пауза 10 секунд)*

**LILITH:** *"Найдено. Подозрительный IP в логах Day 2, 14:37 UTC."*

```
Oct 2, 2025 14:37:22 server-01 sshd[2847]: Accepted publickey for viktor from 10.0.1.47
```

**Макс:** *"IP 10.0.1.47. Внутренний IP. Чей?"*

**LILITH:** *"Анализирую сеть Day 2..."*

**Результат:**
```
IP: 10.0.1.47
Assigned to: viktor-workstation
Location: Novosibirsk (Day 2)
User: viktor
```

**Макс (шок):** *"Viktor workstation? Виктор?"*

**Viktor (спокойно):** *"Это не я."*

**Anna:** *"IP может быть подделан. Или workstation скомпрометирован."*

**LILITH:** *"Проверяю глубже... IP 10.0.1.47 = spoofed MAC address. Реальный пользователь: НЕИЗВЕСТЕН."*

**Макс:** *"Кто-то подделал IP Виктора Day 2?"*

**Anna:** *"Да. И оставил след намеренно. Architect играет с нами."*

**Viktor:** *"Макс, это расследуется. Но не сейчас. День 58 завершается. Команда exhausted. Отдых 4 часа. Завтра — продолжение."*

**Макс (усталость):** *"Понял."*

---

## 🎯 ИТОГИ ДНЯ 58 (20:00 UTC)

**LILITH генерирует отчёт:**

```
═══════════════════════════════════════════════════════════
 ДЕНЬ 58: ОКО БУРИ — СТАТУС
═══════════════════════════════════════════════════════════

РАССЛЕДОВАНИЕ ЗАВЕРШЕНО:
✅ Временная шкала атаки восстановлена (Day 43 → Day 57)
✅ Marcus Weber оправдан (жертва фишинга, НЕ предатель)
✅ Docker supply chain attack обнаружен (viktor/crypto-toolkit)
✅ Масштаб: 47 из 50 серверов были скомпрометированы

ОЧИСТКА ЗАВЕРШЕНА:
✅ Все 47 серверов очищены (rebuild Docker images)
✅ Бэкдоры удалены (AIDE confirmation)
✅ Контейнеры перезапущены из чистых образов

УСИЛЕНИЕ ЗАЩИТЫ ЗАВЕРШЕНО:
✅ SELinux enforcing на всех 50 серверах
✅ Auditd максимальное логирование активно
✅ Fail2ban агрессивный режим (3 попытки = ban 24h)

РАЗВЕДКА УГРОЗ:
⚠️  The Architect identity: НЕИЗВЕСТЕН
⚠️  След в логах Day 2 (Novosibirsk, Episode 01)
⚠️  IP 10.0.1.47 подделан (MAC spoofing)
⚠️  Расследование продолжается

КОМАНДА:
😴 Exhausted после 14 часов работы
✅ Инфраструктура стабильна
⏰ Следующая атака ожидается Day 59-60

РЕКОМЕНДАЦИЯ:
Отдых 4 часа обязателен. Day 59 — counterattack.

*"Вы выдержали око бури. Но буря не закончена."*
— LILITH v8.0
═══════════════════════════════════════════════════════════
```

**Viktor:** *"Отлично. Макс, Anna, Dmitry — 4 часа отдыха. Это приказ. Day 59 будет тяжелее."*

**Макс (закрывает laptop):** *"Понял. 4 часа."*

Экран гаснет. За окном исландская ночь (которая не наступает летом). Макс ложится на раскладушку в датацентре. Закрывает глаза.

**LILITH (тихо):** *"Sleep mode activated. Wake-up timer: 4 hours. Good night, Max."*

Макс засыпает впервые за 16 часов.

---

## 💻 ФИНАЛЬНОЕ ЗАДАНИЕ

Вы — Макс. День 58 завершён, но не всё проверено. Пока команда спит, вам нужно:

### Задание: Automated Security Audit Script

Создайте скрипт `security_audit_day58.sh` который выполняет:

**1. Docker Image Integrity Check (15 минут)**
```bash
# Проверить контрольные суммы ВСЕХ Docker образов
# Сравнить с официальными digests
# Вывести список подозрительных образов
```

**2. AIDE Full Scan (15 минут)**
```bash
# Запустить AIDE на всех 50 серверах через Ansible
# Собрать отчёты
# Выделить серверы с аномалиями
```

**3. SELinux Violations Check (10 минут)**
```bash
# Проверить логи SELinux (ausearch -m avc)
# Найти нарушения политик
# Определить: легитимные или подозрительные
```

**4. Fail2ban Statistics (10 минут)**
```bash
# Собрать статистику Fail2ban со всех серверов
# Сколько IP заблокировано?
# Какие страны источники атак?
# Топ-10 атакующих IP
```

**5. Threat Intelligence Aggregation (20 минут)**
```bash
# Собрать все подозрительные IP из логов
# Проверить через OSINT (AbuseIPDB, VirusTotal)
# Классифицировать: TOR exit nodes, VPN, botnet, etc.
# Создать threat intelligence report
```

**6. Final Report Generation (10 минут)**
```bash
# Агрегировать все данные
# Создать comprehensive security report
# Рекомендации для Day 59
```

**Требования:**
- Bash script с функциями (modularity)
- Error handling (set -e, проверка exit codes)
- Color output (red = suspicious, green = clean)
- Logging в `/var/log/security_audit_day58.log`
- Summary report в `reports/day58_security_audit.md`

**Подсказки:**
- Используй `ansible` для выполнения на всех серверах
- `ausearch`, `aide`, `docker images --digests`, `fail2ban-client`
- Для OSINT: `curl` к API (AbuseIPDB требует key, используй mock data)
- Функция `check_docker_integrity()`, `check_aide()`, `check_selinux()`, etc.

**Пример структуры:**

```bash
#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Logging
LOG_FILE="/var/log/security_audit_day58.log"
REPORT_FILE="reports/day58_security_audit.md"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_docker_integrity() {
    log "Checking Docker image integrity..."
    # Ваш код здесь
}

check_aide() {
    log "Running AIDE scans..."
    # Ваш код здесь
}

# ... остальные функции

main() {
    log "=== Security Audit Day 58 Started ==="
    check_docker_integrity
    check_aide
    check_selinux_violations
    check_fail2ban_stats
    aggregate_threat_intel
    generate_final_report
    log "=== Security Audit Complete ==="
}

main "$@"
```

**Критерии оценки:**
- ✅ Все 6 проверок реализованы
- ✅ Ansible integration (multi-server checks)
- ✅ Error handling и logging
- ✅ Читаемый отчёт (Markdown format)
- ✅ Рекомендации для Day 59 (actionable)

**Время на выполнение:** 1.5-2 часа

**Проверка:**
```bash
./tests/test.sh
```

---

## 📚 ПРИЛОЖЕНИЕ: СПРАВОЧНИК КОМАНД

### Docker Security

```bash
# Проверка контрольных сумм образов
docker images --digests

# История образа (слои)
docker history IMAGE_NAME

# Сканирование уязвимостей (trivy)
trivy image IMAGE_NAME

# Проверка запущенных контейнеров
docker ps -a

# Удаление скомпрометированного образа
docker rmi IMAGE_NAME --force
```

### AIDE (Advanced Intrusion Detection)

```bash
# Инициализация baseline
aide --init
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Проверка изменений
aide --check

# Обновление baseline
aide --update

# Конфигурация
nano /etc/aide/aide.conf
```

### SELinux

```bash
# Текущий режим
getenforce

# Установить enforcing
setenforce 1

# Постоянно
sed -i 's/SELINUX=permissive/SELINUX=enforcing/' /etc/selinux/config

# Проверка нарушений
ausearch -m avc -ts recent

# SELinux context файла
ls -Z /path/to/file

# Восстановление контекста
restorecon -Rv /path/
```

### Auditd

```bash
# Просмотр правил
auditctl -l

# Добавить правило (мониторинг файла)
auditctl -w /etc/passwd -p wa -k passwd_changes

# Поиск событий
ausearch -f /etc/passwd
ausearch -k passwd_changes
ausearch -m USER_LOGIN

# Отчёт
aureport --summary
```

### Fail2ban

```bash
# Статус сервиса
systemctl status fail2ban

# Статус jail
fail2ban-client status sshd

# Разблокировать IP
fail2ban-client set sshd unbanip 192.168.1.100

# Заблокировать IP вручную
fail2ban-client set sshd banip 192.168.1.100

# Логи
tail -f /var/log/fail2ban.log
```

### Ansible (Multi-Server Operations)

```bash
# Выполнить команду на всех серверах
ansible all -m command -a "COMMAND"

# Выполнить команду с sudo
ansible all -m command -a "COMMAND" --become

# Проверка доступности
ansible all -m ping

# Выполнить playbook
ansible-playbook playbook.yml

# Ограничить hosts
ansible-playbook playbook.yml --limit "server-01,server-02"

# Dry-run
ansible-playbook playbook.yml --check
```

### Threat Intelligence (OSINT)

```bash
# Проверка IP reputation (AbuseIPDB API)
curl -G https://api.abuseipdb.com/api/v2/check \
  --data-urlencode "ipAddress=192.168.1.100" \
  -H "Key: YOUR_API_KEY" \
  -H "Accept: application/json"

# Проверка через VirusTotal
curl --request GET \
  --url "https://www.virustotal.com/api/v3/ip_addresses/192.168.1.100" \
  --header "x-apikey: YOUR_API_KEY"

# TOR exit node check
curl -s https://check.torproject.org/cgi-bin/TorBulkExitList.py?ip=1.1.1.1

# Whois информация
whois 192.168.1.100

# DNS reverse lookup
dig -x 192.168.1.100
```

---

## 🎓 ЧТО ВЫ УЗНАЛИ

### Криминалистика:
✅ Восстановление временной шкалы атаки через auditd
✅ Анализ логов Docker для обнаружения компрометации
✅ Методология расследования инсайдерских угроз vs кража учётных данных
✅ Проверка целостности системы через AIDE

### Атаки цепочки поставок:
✅ Как работают supply chain attacks (Docker, NPM, PyPI)
✅ Проверка контрольных сумм образов (docker images --digests)
✅ Обнаружение модифицированных слоёв (docker history)
✅ Стратегия полной перестройки после компрометации

### Защита в глубину:
✅ SELinux enforcing режим (обязательный контроль доступа)
✅ Auditd максимальное логирование (запись всех действий)
✅ Fail2ban агрессивный режим (быстрая блокировка)
✅ Ansible для быстрого развёртывания защиты на 50+ серверах

### Разведка угроз:
✅ OSINT для проверки репутации IP
✅ Классификация источников атак (TOR, VPN, botnet)
✅ Анализ зашифрованных сообщений атакующих

### Координация команды:
✅ Распределение ролей под стрессом (Anna = forensics lead, Dmitry = DevOps)
✅ Оправдание невиновного (Marcus Weber cleared)
✅ Управление вину и ответственность (Dmitry чувство вины за Docker)

---

## 🎬 ЭПИЛОГ

**20:30 UTC. Макс просыпается.**

4 часа сна прошли мгновенно. Будильник LILITH.

**LILITH:** *"Доброе утро, Макс. Время: 00:30 UTC. День 59 начался."*

**Макс (сонно):** *"Статус?"*

**LILITH:** *"Инфраструктура стабильна. Атак не обнаружено последние 4 часа."*

**Макс:** *"Слишком тихо."*

**LILITH:** *"Да. Тишина подозрительна. Рекомендация: подготовка к контрнаступлению."*

**Viktor (сообщение):** *"Макс. Day 59 план: мы атакуем первыми. Alex ведёт операцию. Briefing в 02:00 UTC. Отдыхай ещё час."*

**Макс закрывает глаза. Но сон не идёт.**

Мысли о Day 2. IP 10.0.1.47. Viktor workstation. The Architect.

*"Кто ты, Architect? И почему оставил след в моём первом дне?"*

Ответ придёт Day 59.

---

## 📌 СЛЕДУЮЩИЙ ЭПИЗОД

**Episode 31: Контрнаступление** (День 59)
Offensive security. Ethical hacking. Alex ведёт операцию против "Новой Эры".
C2 server penetration. Botnet neutralization. The Architect identity revealed.

*"Лучшая защита — нападение."* — Alex Sokolov

**До встречи, системный администратор.** 🔍

---

*Episode 30 создан: 2025-10-14*
*KERNEL SHADOWS: Season 8*
*"В оке бури находишь то, что они прятали."* — Anna Kovaleva



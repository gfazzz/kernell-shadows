# Starter Files — Episode 14: Docker Basics

> **"Пиши Dockerfile напрямую, не оборачивай Docker в bash."**  
> — Философия Type B episodes

---

## 📁 Что здесь?

Эта директория содержит **шаблоны Docker конфигураций с TODO комментариями**.

Твоя задача — заполнить TODO, собрать образы, запустить контейнеры.

```
starter/
├── Dockerfile                  # Образ Nginx с TODO
├── docker-compose.yml          # Multi-service compose с TODO
├── configs/
│   ├── nginx.conf              # Nginx конфигурация с TODO
│   └── app.env                 # Environment переменные
├── html/
│   └── index.html              # Простая веб-страница
├── secrets/
│   ├── db_password.txt         # Пароль PostgreSQL (ИЗМЕНИТЬ!)
│   ├── grafana_password.txt    # Пароль Grafana (ИЗМЕНИТЬ!)
│   └── README.md               # Security guidelines
└── README.md                   # Этот файл
```

---

## 🎯 Цель задания

**Научиться писать production-ready Docker конфигурации:**
- ✅ Dockerfile — создание образов
- ✅ docker-compose.yml — оркестрация multi-service приложений
- ✅ Security best practices — non-root user, healthcheck, secrets
- ✅ Networking — контейнеры общаются по имени
- ✅ Volumes — persistent storage

**НЕ писать bash wrapper вокруг docker!**

---

## 🔄 Workflow студента

### Шаг 1: Проверь установку Docker

```bash
# Проверь версию Docker
docker --version
# Должно быть: Docker version 20.10+ или выше

# Проверь Docker Compose
docker-compose --version
# Должно быть: docker-compose version 1.29+ или docker compose version 2.0+

# Проверь что Docker daemon запущен
docker ps
# Должно вывести список контейнеров (может быть пустой)
```

**Если Docker не установлен:**
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER  # Добавить себя в группу docker
# Logout и login чтобы изменения применились
```

---

### Шаг 2: Заполни TODO в Dockerfile

```bash
# Открой файл в редакторе
nano starter/Dockerfile
# или
vim starter/Dockerfile
```

**Заполни TODO 1-10:**
- FROM — базовый образ (nginx:alpine)
- LABEL — метаданные
- RUN — установка пакетов (curl)
- COPY — копирование файлов
- USER — непривилегированный пользователь
- EXPOSE — порт
- HEALTHCHECK — проверка здоровья
- CMD — команда запуска

**Подсказки:**
- Каждый TODO содержит комментарий с hint
- Смотри примеры в `solution/Dockerfile` (но не копируй слепо!)
- Читай комментарии — они объясняют ЗАЧЕМ

**LILITH:** *"FROM — это фундамент. CMD — это крыша. Между ними — стены (COPY, RUN). Dockerfile — это чертёж здания."*

---

### Шаг 3: Заполни TODO в docker-compose.yml

```bash
nano starter/docker-compose.yml
```

**Заполни TODO 1-21:**
- version — версия Compose (3.8)
- build — как собирать образ
- ports — маппинг портов (8080:80)
- networks — изоляция контейнеров
- volumes — persistent storage
- environment — переменные
- healthcheck — проверка здоровья
- restart — политика перезапуска

**Структура:**
- **web service** — Nginx веб-сервер
- **db service** — PostgreSQL база данных
- **networks** — shadow-network для общения
- **volumes** — web-logs, db-data для persistence

---

### Шаг 4: Заполни TODO в configs/nginx.conf

```bash
nano starter/configs/nginx.conf
```

**Заполни TODO 1-17:**
- user, worker_processes
- error_log, access_log
- listen, server_name
- root, index
- location / — main endpoint
- location /health — healthcheck endpoint

---

### Шаг 5: Build Docker образ

```bash
# Перейди в starter/
cd /home/fazzz/kernel-shadows/season-4-devops-automation/episode-14-docker-basics/starter

# Build образ
docker build -t operation-shadow/web:latest .

# Проверь что образ создан
docker images | grep operation-shadow

# Должно показать:
# operation-shadow/web   latest   abc123def456   5MB
```

**LILITH:** *"Build образа = компиляция. Image = бинарник. Container = запущенный процесс."*

**Что происходит при build:**
1. Docker читает Dockerfile
2. Выполняет каждую инструкцию (FROM, RUN, COPY, ...)
3. Каждая инструкция создаёт новый layer
4. Layers кешируются (повторный build быстрее)
5. Финальный образ = stack of layers

---

### Шаг 6: Запусти контейнер вручную (тест Dockerfile)

```bash
# Запустить контейнер из образа
docker run -d \
  -p 8080:80 \
  --name shadow-web-test \
  operation-shadow/web:latest

# Проверить статус
docker ps

# Должно показать:
# CONTAINER ID   IMAGE                     STATUS         PORTS
# abc123         operation-shadow/web      Up 5 seconds   0.0.0.0:8080->80/tcp

# Проверить логи
docker logs shadow-web-test

# Тестировать веб-сервер
curl http://localhost:8080
# Должно вывести HTML страницу

# Тестировать healthcheck
curl http://localhost:8080/health
# Должно вывести: healthy

# Проверить healthcheck статус
docker inspect shadow-web-test | grep -A 10 Health

# Остановить и удалить тестовый контейнер
docker stop shadow-web-test
docker rm shadow-web-test
```

**LILITH:** *"docker run -d = daemonize (в фоне). -p 8080:80 = port mapping. --name = имя контейнера."*

---

### Шаг 7: Запусти multi-service через docker-compose

```bash
# Вернись в starter/
cd /home/fazzz/kernel-shadows/season-4-devops-automation/episode-14-docker-basics/starter

# Build и запуск всех сервисов
docker-compose up -d

# Что происходит:
# 1. Создаёт сеть shadow-network
# 2. Создаёт volumes (web-logs, db-data)
# 3. Build образ web (если изменился)
# 4. Pull образ db (postgres:15-alpine)
# 5. Запускает db контейнер
# 6. Запускает web контейнер

# Проверить статус
docker-compose ps

# Должно показать:
# NAME          IMAGE                     STATUS         PORTS
# shadow-web    operation-shadow/web      Up (healthy)   0.0.0.0:8080->80/tcp
# shadow-db     postgres:15-alpine        Up (healthy)   5432/tcp
```

---

### Шаг 8: Проверь работу сервисов

#### A. Проверка веб-сервера

```bash
# Открой в браузере:
http://localhost:8080

# Или через curl:
curl http://localhost:8080

# Healthcheck:
curl http://localhost:8080/health
```

#### B. Проверка базы данных

```bash
# Подключиться к PostgreSQL контейнеру
docker-compose exec db psql -U shadow_user -d operation_shadow

# Внутри psql:
\l                              # Список баз данных
\dt                             # Список таблиц
\q                              # Выход

# Или через docker exec:
docker exec -it shadow-db psql -U shadow_user -d operation_shadow
```

#### C. Проверка сети

```bash
# Проверить сеть
docker network ls | grep shadow

# Inspect сети
docker network inspect operation-shadow-network

# Ping между контейнерами (web → db)
docker-compose exec web ping -c 3 db

# Должно работать! Контейнеры общаются по имени через Docker DNS
```

#### D. Проверка volumes

```bash
# Список volumes
docker volume ls | grep shadow

# Inspect volume
docker volume inspect shadow-db-data

# Где хранятся данные:
sudo ls -la /var/lib/docker/volumes/shadow-db-data/_data
```

---

### Шаг 9: Проверь логи

```bash
# Логи всех сервисов
docker-compose logs

# Логи конкретного сервиса
docker-compose logs web
docker-compose logs db

# Follow logs (real-time)
docker-compose logs -f web

# Последние 50 строк
docker-compose logs --tail=50 web
```

---

### Шаг 10: Проверь healthcheck

```bash
# Статус healthcheck через docker inspect
docker inspect shadow-web | grep -A 15 Health

# Должно показать:
# "Health": {
#   "Status": "healthy",
#   "FailingStreak": 0,
#   "Log": [...]
# }

# Healthcheck для db
docker inspect shadow-db | grep -A 15 Health
```

**LILITH:** *"Healthcheck — это страховка. Контейнер работает, но приложение может быть мертво. Healthcheck это проверяет."*

---

### Шаг 11: Тестируй resource usage

```bash
# Real-time мониторинг
docker-compose stats

# Должно показать:
# NAME         CPU %   MEM USAGE / LIMIT     NET I/O       BLOCK I/O
# shadow-web   0.5%    10MB / 512MB          1kB / 2kB     0B / 0B
# shadow-db    2.0%    50MB / 1GB            5kB / 10kB    1MB / 2MB
```

---

### Шаг 12: Изменения и rebuild

```bash
# Изменил Dockerfile или docker-compose.yml?

# Rebuild и restart
docker-compose up -d --build

# --build заставляет пересобрать образы
```

---

### Шаг 13: Остановка и очистка

```bash
# Остановить все сервисы
docker-compose stop

# Остановить и удалить контейнеры
docker-compose down

# Удалить контейнеры + volumes (ОСТОРОЖНО: удалит все данные!)
docker-compose down -v

# Удалить неиспользуемые образы
docker image prune -a

# Полная очистка Docker
docker system prune -a --volumes
# ОСТОРОЖНО: удалит ВСЁ (образы, контейнеры, volumes, сети)
```

---

## ✅ Чеклист выполнения

Отметь когда выполнил:

- [ ] Проверил установку Docker и docker-compose
- [ ] Заполнил TODO в `Dockerfile`
- [ ] Заполнил TODO в `docker-compose.yml`
- [ ] Заполнил TODO в `configs/nginx.conf`
- [ ] Build образ (`docker build`)
- [ ] Протестировал контейнер вручную (`docker run`)
- [ ] Запустил multi-service через `docker-compose up -d`
- [ ] Проверил веб-сервер (curl http://localhost:8080)
- [ ] Проверил healthcheck (/health endpoint)
- [ ] Подключился к PostgreSQL (`docker-compose exec db psql`)
- [ ] Проверил сеть (ping между контейнерами)
- [ ] Проверил volumes (`docker volume ls`)
- [ ] Проверил логи (`docker-compose logs`)
- [ ] Проверил resource usage (`docker-compose stats`)
- [ ] Запустил автотесты (`tests/test.sh`)

---

## 🧪 Запуск автотестов

```bash
cd /home/fazzz/kernel-shadows/season-4-devops-automation/episode-14-docker-basics
./tests/test.sh
```

**Что проверяют тесты:**
- ✅ Dockerfile существует и валидный
- ✅ docker-compose.yml существует и валидный
- ✅ Образ собирается без ошибок
- ✅ Контейнеры запускаются
- ✅ Веб-сервер отвечает на http://localhost:8080
- ✅ Healthcheck работает
- ✅ PostgreSQL доступен
- ✅ Сеть работает (контейнеры общаются)
- ✅ Volumes созданы

---

## 🚨 Troubleshooting

### Проблема: Docker daemon не запущен

```bash
# Error: Cannot connect to the Docker daemon

# Start Docker service
sudo systemctl start docker

# Enable автозапуск
sudo systemctl enable docker

# Проверить статус
sudo systemctl status docker
```

---

### Проблема: Permission denied

```bash
# Error: Got permission denied while trying to connect to the Docker daemon socket

# Добавить себя в группу docker
sudo usermod -aG docker $USER

# Logout и login (или reboot)
```

---

### Проблема: Port already in use

```bash
# Error: Bind for 0.0.0.0:8080 failed: port is already allocated

# Найти процесс на порту 8080
sudo lsof -i :8080
# или
sudo netstat -tulpn | grep 8080

# Убить процесс
sudo kill -9 <PID>

# Или изменить порт в docker-compose.yml
ports:
  - "8081:80"  # Вместо 8080
```

---

### Проблема: Build failed

```bash
# Проверить синтаксис Dockerfile
docker build -t test .

# Смотри ERROR сообщение:
# - Опечатка в команде?
# - Файл не найден в COPY?
# - Неправильный путь?

# Включить debug output
docker build --progress=plain -t test .
```

---

### Проблема: Container exits immediately

```bash
# Проверить логи
docker logs shadow-web

# Частые причины:
# - CMD неправильный (daemon должен быть off для nginx)
# - Ошибка в nginx.conf
# - Permissions проблемы
# - Healthcheck падает слишком быстро
```

---

### Проблема: Healthcheck failing

```bash
# Проверить healthcheck вручную внутри контейнера
docker-compose exec web curl -f http://localhost/health

# Если падает:
# - /health endpoint настроен в nginx.conf?
# - curl установлен в контейнере? (RUN apk add curl)
# - nginx вообще запустился?
```

---

### Проблема: Database connection refused

```bash
# Проверить что db контейнер запущен
docker-compose ps

# Проверить что db healthy
docker inspect shadow-db | grep Health

# Проверить сеть
docker-compose exec web ping db

# Проверить PostgreSQL порт
docker-compose exec db netstat -tulpn | grep 5432

# Connection string должен использовать имя сервиса:
postgresql://shadow_user:password@db:5432/operation_shadow
#                                  ^^
#                            Имя из docker-compose services
```

---

## 📚 Полезные команды

### Docker Images

```bash
# Список образов
docker images

# Удалить образ
docker rmi <image_id>

# Удалить неиспользуемые образы
docker image prune

# Inspect образа
docker inspect operation-shadow/web
```

### Docker Containers

```bash
# Список запущенных
docker ps

# Список всех (включая остановленные)
docker ps -a

# Остановить контейнер
docker stop <container_id>

# Удалить контейнер
docker rm <container_id>

# Подключиться к контейнеру
docker exec -it shadow-web sh

# Просмотр логов
docker logs shadow-web
docker logs -f shadow-web  # follow
```

### Docker Compose

```bash
# Build и запуск
docker-compose up -d

# Rebuild
docker-compose up -d --build

# Остановка
docker-compose stop

# Остановка и удаление
docker-compose down

# Логи
docker-compose logs -f

# Exec команда в сервисе
docker-compose exec web sh
docker-compose exec db psql -U shadow_user

# Статус сервисов
docker-compose ps

# Resource usage
docker-compose stats
```

### Docker Networks

```bash
# Список сетей
docker network ls

# Inspect сети
docker network inspect operation-shadow-network

# Создать сеть
docker network create mynetwork

# Подключить контейнер к сети
docker network connect mynetwork shadow-web
```

### Docker Volumes

```bash
# Список volumes
docker volume ls

# Inspect volume
docker volume inspect shadow-db-data

# Удалить volume
docker volume rm shadow-db-data

# Удалить неиспользуемые volumes
docker volume prune
```

---

## 💡 Best Practices (Sophie's notes)

### ✅ DO

- ✅ Используй alpine образы (меньше размер, меньше уязвимостей)
- ✅ Запускай контейнеры от non-root пользователя (USER nginx)
- ✅ Добавляй HEALTHCHECK в Dockerfile
- ✅ Используй .dockerignore (как .gitignore)
- ✅ Pin версии в FROM (nginx:1.24-alpine, не nginx:latest)
- ✅ Объединяй RUN команды (меньше layers)
- ✅ Используй multi-stage builds для компилируемых языков
- ✅ Храни secrets отдельно (Docker secrets, не в образе)
- ✅ Используй named volumes для данных
- ✅ Настраивай restart: unless-stopped
- ✅ Добавляй labels для организации

### ❌ DON'T

- ❌ НЕ используй root в контейнере
- ❌ НЕ используй latest tag в production
- ❌ НЕ храни secrets в Dockerfile/docker-compose
- ❌ НЕ коммить secrets в git
- ❌ НЕ запускай apt-get upgrade в Dockerfile
- ❌ НЕ храни данные в контейнере (используй volumes)
- ❌ НЕ забывай про .dockerignore
- ❌ НЕ создавай слишком много layers

---

## 🔗 Дополнительные ресурсы

### Docker Documentation

- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Compose File Reference](https://docs.docker.com/compose/compose-file/)
- [Docker Security](https://docs.docker.com/engine/security/)

### Tutorials

- [Docker для начинающих (RU)](https://habr.com/ru/post/353238/)
- [Play with Docker (interactive)](https://labs.play-with-docker.com/)

---

## 🎓 Вопросы для самопроверки

После выполнения задания, ответь на вопросы:

1. **В чём разница между image и container?**
   <details><summary>Ответ</summary>
   Image — это шаблон (класс), container — это экземпляр (объект). Из одного image можно запустить много containers.
   </details>

2. **Зачем USER nginx в Dockerfile?**
   <details><summary>Ответ</summary>
   SECURITY! Если контейнер скомпрометирован, атакующий получит только права nginx (не root).
   </details>

3. **Что делает docker-compose up -d?**
   <details><summary>Ответ</summary>
   Запускает все сервисы из docker-compose.yml в detached mode (в фоне).
   </details>

4. **Как контейнеры общаются между собой?**
   <details><summary>Ответ</summary>
   Через Docker network. Контейнеры в одной сети общаются по имени (Docker DNS резолвит имя в IP).
   </details>

5. **Что произойдёт с данными при docker-compose down?**
   <details><summary>Ответ</summary>
   Контейнеры удалятся, но named volumes останутся (данные сохранятся). docker-compose down -v удалит и volumes.
   </details>

6. **Зачем HEALTHCHECK?**
   <details><summary>Ответ</summary>
   Docker автоматически перезапустит unhealthy контейнеры. Предотвращает ситуацию когда контейнер работает, но приложение зависло.
   </details>

---

**"Containers zijn als LEGO. Simple blocks, complex systems. Build once, run anywhere."**

— Sophie van Dijk, Docker Architect

**Amsterdam, Netherlands • Docker Mastery!** 🇳🇱

---


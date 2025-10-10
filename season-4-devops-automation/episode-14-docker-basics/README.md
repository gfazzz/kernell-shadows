# EPISODE 14: DOCKER BASICS 🐳🇳🇱

> **"Containers zijn als LEGO. Simple blocks, complex systems. Build once, run anywhere."**
> — Sophie van Dijk, Docker Architect

---

## 📍 Контекст операции

**День:** 27-28 из 60
**Локация:** 🇳🇱 Amsterdam, Netherlands (Science Park datacenter)
**Время:** 5-6 часов
**Сложность:** ⭐⭐⭐☆☆

**Предыдущий эпизод:** [Episode 13: Git & Version Control](../episode-13-git-version-control/README.md) (Berlin, Germany)
**Следующий эпизод:** Episode 15: CI/CD Pipelines (Berlin, Germany)

---

## 🎬 Сюжет

### Переход Episode 13 → Episode 14

**Hans Müller (прощание в Берлине, день 26):**
> *"Max, Dmitry — git foundation готов. Теперь контейнеры. Sophie van Dijk в Амстердаме — бывший Docker Inc. architect. Если кто знает Docker, то это она. Летите завтра. И помните что сказал Alex: supply chain attacks на Docker images. Проверяйте всё."*

**Alex (текстовое сообщение после прощания с Hans):**
> *"Max. Krylov готовит supply chain attack. Docker Hub легко компрометировать — достаточно одного malicious image. Viktor использует Docker для всех инструментов операции. Если образ скомпрометирован — всё скомпрометировано. Будь параноиком. Проверяй checksums. Сканируй на уязвимости. — A."*

### День 27: Прилёт в Амстердам

**08:00 — Schiphol Airport**

Max и Dmitry прилетают в Амстердам. Совершенно другая атмосфера после промышленного Берлина: велосипеды везде, каналы, толерантность, минимализм.

**Dmitry:**
> *"Амстердам — Docker HQ Europe. Здесь родилась европейская контейнеризация. Sophie работала в Docker Inc. с 2015 по 2020. Если кто-то понимает containers philosophy, это голландцы: pragmatic, minimal, efficient."*

**10:00 — Science Park Amsterdam (Datacenter District)**

Современный технопарк. University of Amsterdam рядом, стартапы, дата-центры. Велосипедные дорожки вместо автомобильных. Очень зелёно.

Sophie van Dijk встречает у входа в datacenter. 32 года, прямая, деловитая, без лишних слов. Голландская прагматичность.

**Sophie:**
> *"Max, Dmitry. Добро пожаловать в Амстердам. Viktor сказал, что вам нужно контейнеризировать всё. Отлично. Containers zijn als LEGO — простые блоки, сложные системы. Docker — это не магия. Это просто очень хорошая изоляция. Начнём."*

**10:30 — Datacenter Tour**

Sophie показывает инфраструктуру: ряды серверов с Docker Swarm кластерами, Kubernetes, monitoring dashboards (Grafana + Prometheus).

**Sophie:**
> *"Видишь это? 500 контейнеров работают на 50 серверах. Каждый контейнер — изолированный, воспроизводимый, масштабируемый. Без Docker? 500 VM, 500 копий ОС, огромный overhead. С Docker? Одна ОС, 500 процессов, минимальный overhead. Вот в чём сила."*

**Max (впечатлён):**
> *"500 контейнеров? На 50 серверах?"*

**Sophie:**
> *"Ja. И мы можем масштабировать до 5000, если нужно. Docker orchestration. Но сначала — basics. Тебе нужно понять контейнеры до orchestration. Пойдём, покажу."*

### 11:00 — Docker Workshop Begins

**Sophie's office:** Минималистичный голландский дизайн. Большие окна, natural light, одно растение, один монитор, mechanical keyboard. Efficiency.

**Sophie:**
> *"Философия Docker простая:
> 1. Build once, run anywhere.
> 2. Изоляция без overhead.
> 3. Воспроизводимые окружения.
> 4. Microservices архитектура.
>
> Операции Viktor нужно всё это. 50 серверов сегодня, 100 завтра. Без контейнеров? Невозможно управлять. С контейнерами? Просто. Покажу тебе Dockerfile."*

(Sophie открывает editor, пишет Dockerfile за 2 минуты)

```dockerfile
FROM nginx:alpine
COPY nginx.conf /etc/nginx/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Sophie:**
> *"Четыре строки. Production-ready web server. Alpine base — 5MB. Nginx — 10MB total. Запускается за 1 секунду. Это Docker."*

### ИНЦИДЕНТ (происходит в середине Episode, ~15:30)

**15:30 — Emergency Alert**

Ноутбук Dmitry начинает пищать. Security alert от системы мониторинга.

**Dmitry (проверяет):**
> *"Чёрт! Sophie, у нас проблема. Один из Docker images Viktor — подозрительная активность. Исходящие соединения к 185.220.101.52 — это Tor exit node Krylov!"*

**Sophie (мгновенно переключается в режим безопасности):**
> *"Какой image? Покажи мне."*

**Dmitry:**
> *"viktor/crypto-toolkit:latest — мы используем его на 20 серверах!"*

**Sophie:**
> *"Останови все контейнеры СЕЙЧАС. Это supply chain attack. Кто-то запушил скомпрометированный image в ваш registry. Классическая атака на Docker Hub."*

**Max (паника):**
> *"20 серверов скомпрометированы?!"*

**Sophie (спокойно, но быстро):**
> *"Ещё нет. Мы поймали это. Но нам нужно:
> 1. Остановить все контейнеры, использующие этот image
> 2. Просканировать image на malware
> 3. Проверить Docker Hub на компрометацию
> 4. Пересобрать из чистого source
> 5. Проверить checksums
>
> У вас установлен Trivy?"*

**Dmitry:**
> *"Что?"*

**Sophie:**
> *"Trivy. Сканер уязвимостей для контейнеров. Устанавливай. Сейчас."*

#### Emergency Response (15:35 - 16:00)

**Tasks:**

1. **Stop compromised containers:**
```bash
docker ps | grep crypto-toolkit
docker stop $(docker ps -q --filter ancestor=viktor/crypto-toolkit:latest)
```

2. **Scan image with Trivy:**
```bash
trivy image viktor/crypto-toolkit:latest
# Output: CRITICAL: Backdoor detected in /usr/bin/crypto_tool
```

**Sophie:**
> *"Backdoor. Кто-то изменил ваш toolkit. Проверяйте Docker Hub credentials."*

3. **Check Docker Hub:**
```bash
docker history viktor/crypto-toolkit:latest
# Layer 3 pushed by unknown user: "maintenance@viktor-ops.net"
```

**Dmitry:**
> *"Этот email не наш! Кто-то получил доступ к Docker Hub account!"*

**Sophie:**
> *"Меняйте пароль. Отзывайте токены доступа. Удаляйте скомпрометированный image. Пересобирайте из source. И в следующий раз — используйте Docker Content Trust. Цифровые подписи. Этого бы не случилось."*

4. **Rebuild from clean source:**
```bash
git clone https://github.com/viktor-ops/crypto-toolkit
cd crypto-toolkit
docker build -t viktor/crypto-toolkit:v2.0-clean .
docker scan viktor/crypto-toolkit:v2.0-clean  # Clean!
```

5. **Enable Docker Content Trust:**
```bash
export DOCKER_CONTENT_TRUST=1
docker push viktor/crypto-toolkit:v2.0-clean
# Automatically signs image with your key
```

**16:00 — Resolution**

**Sophie:**
> *"Image очищен. Контейнеры перезапущены. Никакой утечки данных. Вам повезло — monitoring поймал это быстро. Но это урок: НИКОГДА не доверяйте Docker images слепо. Всегда сканируйте. Всегда проверяйте. Supply chain attacks реальны."*

**Anna (видеозвонок):**
> *"Forensics завершён. Backdoor был от Krylov. Он скомпрометировал аккаунт Docker Hub через фишинговую атаку на одного из сотрудников Viktor. Повторное использование пароля. Классическая ошибка. Все пароли ротированы. 2FA включён."*

**Alex (текстовое):**
> *"Я предупреждал. Supply chain — самая опасная атака. Хорошо что Sophie знала что делать. — A."*

**Sophie:**
> *"В Нидерландах мы говорим: 'Vertrouwen is goed, controle is beter.' Доверяй, но проверяй. Всегда проверяй. Всегда сканируй. Docker security — не опция."*

### Финал Episode 14

**18:00 — Debriefing**

**Viktor (видеозвонок):**
> *"Crisis averted. Image cleaned. Sophie, thank you. Max, Dmitry — you learned important lesson today. Containers are powerful. But with power comes responsibility. Security first."*

**Sophie:**
> *"Хорошая работа сегодня. Docker basics — готово. Multi-container applications — готово. Security scanning — изучили на горьком опыте. Завтра вы летите обратно в Берлин для CI/CD. Hans научит вас автоматизации. Но помните основы Docker. Всё строится на этом."*

**Dmitry:**
> *"Sophie, спасибо. Ты спасла операцию."*

**Sophie (улыбается):**
> *"Вот что делают Docker architects. Мы строим, защищаем, исправляем. Добро пожаловать в мир контейнеризации. Теперь ты понимаешь, почему Docker изменил мир."*

**Max:**
> *"Containers zijn als LEGO... Теперь понятно."*

**Sophie:**
> *"Goed! Ты учишь голландский. И Docker. Оба полезных навыка."*

**Cliffhanger:**

**Hans (текстовое из Берлина):**
> *"Max, Dmitry. CI/CD pipeline готов в Берлине. Завтра автоматизируем всё. Docker images будут собираться автоматически, тестироваться автоматически, деплоиться автоматически. Но сначала — вы должны понять, что автоматизируете. Увидимся завтра. — Hans"*

---

## 🎯 Миссия Episode 14

**Основная задача:** Контейнеризировать компоненты инфраструктуры операции Viktor, настроить Docker Compose, научиться Docker security.

**Конкретные задания:**

1. ✅ **Install Docker** (Docker Engine + Docker Compose)
2. ✅ **Create Dockerfile** для nginx web server
3. ✅ **Build and run container** (docker build, docker run)
4. ✅ **Docker networking** (bridge, custom networks)
5. ✅ **Docker volumes** (data persistence)
6. ✅ **Multi-stage builds** (optimization, minimal image size)
7. ✅ **Docker Compose** (multi-container: web + database + redis)
8. ✅ **Security scanning** (Trivy для обнаружения уязвимостей)
9. ✅ **INCIDENT: Detect compromised image** (supply chain attack response)

**Финальный артефакт:**
- Рабочие Dockerfiles для всех компонентов
- docker-compose.yml для полного стека
- Security scanning pipeline
- Incident response playbook

---

## 📚 Теория: Docker & Containerization

### Зачем нужен Docker?

**Проблемы без Docker:**
- ❌ "Works on my machine" (разные environments)
- ❌ Dependency hell (библиотеки конфликтуют)
- ❌ Медленный deployment (установка зависимостей каждый раз)
- ❌ Heavyweight VMs (полная ОС для каждого приложения)
- ❌ Сложный scaling (нужно настраивать каждый сервер)

**С Docker:**
- ✅ Воспроизводимые окружения ("works everywhere")
- ✅ Изолированные зависимости (каждый контейнер — своё окружение)
- ✅ Fast deployment (образ уже готов, запуск за секунды)
- ✅ Lightweight (shared OS kernel, minimal overhead)
- ✅ Easy scaling (запустить 100 containers = одна команда)

### Containers vs Virtual Machines

```
┌─────────────────────────────────────┐  ┌─────────────────────────────────────┐
│     Traditional Virtual Machines    │  │         Docker Containers            │
├─────────────────────────────────────┤  ├─────────────────────────────────────┤
│  ┌────────┐ ┌────────┐ ┌────────┐  │  │  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │ App A  │ │ App B  │ │ App C  │  │  │  │ App A  │ │ App B  │ │ App C  │  │
│  ├────────┤ ├────────┤ ├────────┤  │  │  ├────────┤ ├────────┤ ├────────┤  │
│  │ Libs   │ │ Libs   │ │ Libs   │  │  │  │ Libs   │ │ Libs   │ │ Libs   │  │
│  ├────────┤ ├────────┤ ├────────┤  │  │  └────────┘ └────────┘ └────────┘  │
│  │Guest OS│ │Guest OS│ │Guest OS│  │  │           Docker Engine              │
│  └────────┘ └────────┘ └────────┘  │  │  ┌─────────────────────────────────┐ │
│          Hypervisor                 │  │  │         Host OS                 │ │
│  ┌─────────────────────────────────┐ │  │  └─────────────────────────────────┘ │
│  │         Host OS                 │ │  │         Infrastructure               │
│  └─────────────────────────────────┘ │  └─────────────────────────────────────┘
│         Infrastructure              │
└─────────────────────────────────────┘

Heavy: 3 full OS copies                Light: 1 OS, 3 isolated processes
Slow start: 30-60 seconds              Fast start: 1-2 seconds
Large: GB per VM                       Small: MB per container
```

### Docker Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    Docker Client                         │
│              (docker build, docker run, ...)             │
└────────────────────────┬─────────────────────────────────┘
                         │ REST API
┌────────────────────────▼─────────────────────────────────┐
│                   Docker Daemon                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Images         Containers       Networks        │   │
│  │  (templates)    (running)        (connectivity)  │   │
│  │                                                   │   │
│  │  Volumes                         Plugins         │   │
│  │  (data)                          (extend)        │   │
│  └──────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘
```

**Key concepts:**
- **Image:** Template (like a class in programming)
- **Container:** Running instance (like an object)
- **Dockerfile:** Instructions to build image
- **Registry:** Storage for images (Docker Hub, private registry)

---

## 💻 Практика: 9 заданий

### Задание 1: Install Docker

**Миссия:** Установить Docker Engine и Docker Compose на Ubuntu.

**Задача:**

```bash
# 1. Update package index
sudo apt update

# 2. Install prerequisites
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 3. Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 4. Set up repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 6. Add user to docker group (no sudo needed)
sudo usermod -aG docker $USER
newgrp docker  # Refresh group membership

# 7. Verify installation
docker --version
docker compose version

# 8. Test Docker
docker run hello-world
```

**Expected output:**
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

<details>
<summary>💡 Hint 1: Permission denied error (если застряли > 5 минут)</summary>

If you get "permission denied" when running `docker`:

```bash
# Add your user to docker group
sudo usermod -aG docker $USER

# Refresh group membership
newgrp docker

# Or logout and login again
```

</details>

<details>
<summary>💡 Hint 2: Docker Compose not found (если застряли > 10 минут)</summary>

Docker Compose v2 is now a plugin:

```bash
# Old way (Compose v1):
docker-compose --version  # May not exist

# New way (Compose v2):
docker compose version    # Use this!

# Install if missing:
sudo apt install docker-compose-plugin
```

</details>

<details>
<summary>✅ Solution (если застряли > 15 минут)</summary>

Complete installation script:

```bash
#!/bin/bash
set -euo pipefail

# Update and install prerequisites
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Configure user
sudo usermod -aG docker $USER
newgrp docker

# Verify
docker --version
docker compose version
docker run hello-world

echo "✅ Docker installed successfully!"
```

</details>

---

### Задание 2: Create Dockerfile для Nginx

**Миссия:** Создать Dockerfile для web server (nginx).

**Задача:**

```bash
# Create project directory
mkdir -p ~/operation-shadow-docker/web
cd ~/operation-shadow-docker/web

# Create Dockerfile
cat > Dockerfile << 'EOF'
# Используем Alpine Linux для минимального размера
FROM nginx:alpine

# Metadata
LABEL maintainer="max@operation-shadow.net"
LABEL version="1.0"
LABEL description="Nginx web server for Operation Shadow"

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy static HTML content
COPY html/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
EOF

# Create nginx configuration
cat > nginx.conf << 'EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    tcp_nopush on;
    keepalive_timeout 65;
    gzip on;

    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html;
        }

        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }
    }
}
EOF

# Create HTML content
mkdir -p html
cat > html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Operation Shadow</title>
    <style>
        body { font-family: Arial; text-align: center; padding: 50px; background: #1a1a1a; color: #00ff00; }
        h1 { color: #00ff00; }
    </style>
</head>
<body>
    <h1>OPERATION SHADOW</h1>
    <p>Infrastructure Online</p>
    <p>Amsterdam Datacenter</p>
    <p>Episode 14: Docker Basics</p>
</body>
</html>
EOF
```

**Build and run:**
```bash
# Build image
docker build -t operation-shadow/web:latest .

# Run container
docker run -d -p 8080:80 --name shadow-web operation-shadow/web:latest

# Test
curl http://localhost:8080
# Should show HTML page

# Check logs
docker logs shadow-web

# Stop and remove
docker stop shadow-web
docker rm shadow-web
```

<details>
<summary>💡 Hint: Dockerfile best practices</summary>

**Good practices:**
1. Use specific base image tags (not `latest`)
2. Minimize layers (combine RUN commands)
3. Use `.dockerignore` (like `.gitignore`)
4. Add HEALTHCHECK
5. Run as non-root user (security)
6. Use multi-stage builds (smaller images)

**Example improvements:**
```dockerfile
FROM nginx:1.25-alpine  # Specific version

# Create non-root user
RUN adduser -D -u 1000 nginx-user

# Copy files
COPY --chown=nginx-user:nginx-user html/ /usr/share/nginx/html/

# Switch to non-root
USER nginx-user

# Expose port
EXPOSE 8080  # Non-privileged port

CMD ["nginx", "-g", "daemon off;"]
```

</details>

---

### Задание 3: Docker Networking

**Миссия:** Настроить custom Docker network для изоляции containers.

**Задача:**

```bash
# 1. List networks
docker network ls
# Default: bridge, host, none

# 2. Create custom bridge network
docker network create shadow-network

# 3. Inspect network
docker network inspect shadow-network

# 4. Run container on custom network
docker run -d \
  --name web1 \
  --network shadow-network \
  operation-shadow/web:latest

# 5. Run another container on same network
docker run -d \
  --name web2 \
  --network shadow-network \
  operation-shadow/web:latest

# 6. Test connectivity between containers
docker exec web1 ping -c 3 web2  # Should work!
docker exec web1 wget -qO- http://web2  # Access by name!

# 7. Remove network (after stopping containers)
docker stop web1 web2
docker rm web1 web2
docker network rm shadow-network
```

**Network types:**
- `bridge` — default, isolated network
- `host` — use host's network (no isolation)
- `none` — no network
- Custom bridge — best for multi-container apps

---

### Задание 4: Docker Volumes

**Миссия:** Persist data using Docker volumes.

**Задача:**

```bash
# 1. Create volume
docker volume create shadow-data

# 2. Run container with volume
docker run -d \
  --name db-container \
  -v shadow-data:/var/lib/mysql \
  mysql:8.0

# 3. Write data (persisted in volume)
docker exec db-container sh -c 'echo "test data" > /var/lib/mysql/test.txt'

# 4. Stop and remove container
docker stop db-container
docker rm db-container

# 5. Data still exists!
docker volume inspect shadow-data

# 6. Run new container with same volume
docker run -d \
  --name db-container-2 \
  -v shadow-data:/var/lib/mysql \
  mysql:8.0

# 7. Data is still there!
docker exec db-container-2 cat /var/lib/mysql/test.txt
# Output: test data

# Cleanup
docker stop db-container-2
docker rm db-container-2
docker volume rm shadow-data
```

**Volume types:**
- **Named volumes:** `docker volume create myvolume` (managed by Docker)
- **Bind mounts:** `-v /host/path:/container/path` (direct host filesystem)
- **tmpfs mounts:** In-memory, temporary

---

### Задание 5: Multi-stage Builds

**Миссия:** Optimize Dockerfile size using multi-stage builds.

**Problem:** Full toolchain in final image (compilers, dev tools) → large size.

**Solution:** Multi-stage build — build in one stage, copy artifacts to clean stage.

**Example:** Golang application

```dockerfile
# Stage 1: Build
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp

# Stage 2: Final image (minimal)
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/myapp .
CMD ["./myapp"]
```

**Result:**
- Builder stage: 300MB (includes Go compiler)
- Final image: 10MB (only binary + Alpine)

**Task:** Create multi-stage Dockerfile for Operation Shadow tool:

```bash
mkdir -p ~/operation-shadow-docker/tool
cd ~/operation-shadow-docker/tool

cat > Dockerfile << 'EOF'
# Stage 1: Build environment
FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    make

WORKDIR /build
COPY crypto_tool.c .
RUN gcc -o crypto_tool crypto_tool.c

# Stage 2: Runtime environment
FROM alpine:latest

# Install minimal runtime dependencies
RUN apk add --no-cache libc6-compat

WORKDIR /app
COPY --from=builder /build/crypto_tool .

CMD ["./crypto_tool"]
EOF

# Create sample C program
cat > crypto_tool.c << 'EOF'
#include <stdio.h>
int main() {
    printf("Operation Shadow Crypto Tool\n");
    printf("Episode 14: Docker Multi-stage Build\n");
    return 0;
}
EOF

# Build and compare sizes
docker build -t shadow-tool:multi-stage .
docker images shadow-tool:multi-stage
# Size: ~10MB (Alpine + binary)

# Without multi-stage (for comparison):
docker build --target builder -t shadow-tool:full .
docker images shadow-tool:full
# Size: ~200MB (full Ubuntu + build tools)
```

---

### Задание 6: Docker Compose

**Миссия:** Orchestrate multi-container application (web + database + cache).

**docker-compose.yml:**

```yaml
version: '3.8'

services:
  # Web server
  web:
    image: nginx:alpine
    container_name: shadow-web
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
    networks:
      - shadow-net
    depends_on:
      - api
    restart: unless-stopped

  # API backend
  api:
    build: ./api
    container_name: shadow-api
    ports:
      - "5000:5000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/shadowdb
      - REDIS_URL=redis://cache:6379
    networks:
      - shadow-net
    depends_on:
      - db
      - cache
    restart: unless-stopped

  # PostgreSQL database
  db:
    image: postgres:15-alpine
    container_name: shadow-db
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=shadowdb
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - shadow-net
    restart: unless-stopped

  # Redis cache
  cache:
    image: redis:7-alpine
    container_name: shadow-cache
    networks:
      - shadow-net
    restart: unless-stopped

networks:
  shadow-net:
    driver: bridge

volumes:
  db-data:
```

**Commands:**

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Check status
docker compose ps

# Stop services
docker compose stop

# Remove containers
docker compose down

# Remove containers + volumes
docker compose down -v
```

---

### Задание 7: Security Scanning with Trivy

**Миссия:** Scan Docker images for vulnerabilities.

**Install Trivy:**

```bash
# Install
sudo apt install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update
sudo apt install trivy
```

**Scan image:**

```bash
# Scan for vulnerabilities
trivy image nginx:latest

# Filter by severity
trivy image --severity HIGH,CRITICAL nginx:latest

# Scan local Dockerfile
trivy config Dockerfile

# Generate report
trivy image --format json --output report.json nginx:latest
```

**Example output:**
```
nginx:latest (alpine 3.18.4)
===========================
Total: 15 (UNKNOWN: 0, LOW: 10, MEDIUM: 3, HIGH: 2, CRITICAL: 0)

┌─────────────┬────────────────┬──────────┬───────────────────┬───────────────┬──────────────────────────────────────┐
│  Library    │ Vulnerability  │ Severity │ Installed Version │ Fixed Version │             Title                    │
├─────────────┼────────────────┼──────────┼───────────────────┼───────────────┼──────────────────────────────────────┤
│ openssl     │ CVE-2023-12345 │ HIGH     │ 3.1.0             │ 3.1.1         │ OpenSSL vulnerability                │
└─────────────┴────────────────┴──────────┴───────────────────┴───────────────┴──────────────────────────────────────┘
```

---

### Задание 8: INCIDENT — Detect Compromised Image

**‼️ EMERGENCY SCENARIO ‼️**

**Scenario (from plot):**

**15:30 — Dmitry's alert:**
> *"Подозрительная активность! viktor/crypto-toolkit:latest делает исходящие соединения к 185.220.101.52 (Tor exit node Krylov)!"*

**Tasks:**

**1. Stop compromised containers:**
```bash
# List running containers
docker ps | grep crypto-toolkit

# Stop all containers using compromised image
docker stop $(docker ps -q --filter ancestor=viktor/crypto-toolkit:latest)

# Remove containers
docker rm $(docker ps -aq --filter ancestor=viktor/crypto-toolkit:latest)
```

**2. Scan image for malware:**
```bash
# Scan with Trivy
trivy image viktor/crypto-toolkit:latest

# Output shows:
# CRITICAL: Backdoor detected in /usr/bin/crypto_tool
# Suspicious network activity: connections to 185.220.101.52
```

**3. Inspect image history:**
```bash
# Check who built the image
docker history viktor/crypto-toolkit:latest

# Output shows suspicious layer:
# Layer 3: pushed by "maintenance@viktor-ops.net" (unknown user!)
```

**4. Check Docker Hub credentials:**
```bash
# Review Docker Hub account
docker login
# Check access tokens in Docker Hub web interface
# Revoke suspicious tokens
```

**5. Rebuild from clean source:**
```bash
# Clone from verified Git repository
git clone https://github.com/viktor-ops/crypto-toolkit
cd crypto-toolkit

# Verify Git commit signatures
git log --show-signature

# Build new image
docker build -t viktor/crypto-toolkit:v2.0-clean .

# Scan new image
trivy image viktor/crypto-toolkit:v2.0-clean
# Output: No vulnerabilities found ✓
```

**6. Enable Docker Content Trust:**
```bash
# Enable image signing
export DOCKER_CONTENT_TRUST=1

# Push with automatic signing
docker push viktor/crypto-toolkit:v2.0-clean

# All future pulls will verify signature
docker pull viktor/crypto-toolkit:v2.0-clean
# Pulls only signed, verified images
```

**7. Update docker-compose.yml:**
```yaml
services:
  crypto-tool:
    image: viktor/crypto-toolkit:v2.0-clean  # Use clean version
    # ...
```

**Sophie (после разрешения инцидента):**
> *"Хорошее время реакции. Ключевые уроки:
> 1. Всегда сканируйте images перед деплойментом
> 2. Используйте Docker Content Trust (подписи)
> 3. Мониторьте исходящие сетевые соединения
> 4. Регулярно ротируйте credentials
> 5. Включайте 2FA на Docker Hub
>
> Supply chain attacks реальны. Будьте параноиками."*

---

### Задание 9: Generate Docker Audit Report

**Миссия:** Create comprehensive audit of Docker environment.

**Script:** `scripts/docker_audit.sh`

```bash
#!/bin/bash

REPORT="docker_audit_report.txt"

echo "========================================" > "$REPORT"
echo "   DOCKER AUDIT REPORT" >> "$REPORT"
echo "   Operation Shadow Infrastructure" >> "$REPORT"
echo "   Generated: $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT"
echo "========================================" >> "$REPORT"
echo "" >> "$REPORT"

# Docker version
echo "## DOCKER VERSION" >> "$REPORT"
docker --version >> "$REPORT"
docker compose version >> "$REPORT"
echo "" >> "$REPORT"

# Running containers
echo "## RUNNING CONTAINERS" >> "$REPORT"
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" >> "$REPORT"
echo "" >> "$REPORT"

# All containers (including stopped)
echo "## ALL CONTAINERS" >> "$REPORT"
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" >> "$REPORT"
echo "" >> "$REPORT"

# Images
echo "## IMAGES" >> "$REPORT"
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" >> "$REPORT"
echo "" >> "$REPORT"

# Volumes
echo "## VOLUMES" >> "$REPORT"
docker volume ls >> "$REPORT"
echo "" >> "$REPORT"

# Networks
echo "## NETWORKS" >> "$REPORT"
docker network ls >> "$REPORT"
echo "" >> "$REPORT"

# Disk usage
echo "## DISK USAGE" >> "$REPORT"
docker system df >> "$REPORT"
echo "" >> "$REPORT"

# Security scan (if Trivy installed)
echo "## SECURITY SCAN" >> "$REPORT"
if command -v trivy &> /dev/null; then
    echo "Scanning images for vulnerabilities..." >> "$REPORT"
    for img in $(docker images --format "{{.Repository}}:{{.Tag}}"); do
        echo "--- $img ---" >> "$REPORT"
        trivy image --severity HIGH,CRITICAL --quiet "$img" >> "$REPORT" 2>&1 || echo "Scan failed" >> "$REPORT"
    done
else
    echo "Trivy not installed. Install: sudo apt install trivy" >> "$REPORT"
fi
echo "" >> "$REPORT"

echo "========================================" >> "$REPORT"
echo "   END OF AUDIT REPORT" >> "$REPORT"
echo "========================================" >> "$REPORT"

echo "✅ Docker audit report generated: $REPORT"
cat "$REPORT"
```

---

## 📖 Docker Commands: Справочник

<details>
<summary><strong>🔹 Основные команды</strong></summary>

```bash
# Images
docker images                  # List images
docker build -t name:tag .     # Build image
docker pull name:tag           # Download image
docker push name:tag           # Upload image
docker rmi name:tag            # Remove image
docker tag old new             # Tag image

# Containers
docker ps                      # List running containers
docker ps -a                   # List all containers
docker run name                # Run container
docker run -d name             # Run in background
docker run -it name /bin/bash  # Interactive shell
docker stop container          # Stop container
docker start container         # Start stopped container
docker restart container       # Restart container
docker rm container            # Remove container
docker exec container cmd      # Run command in container
docker logs container          # View logs
docker inspect container       # Inspect configuration

# Networks
docker network ls              # List networks
docker network create name     # Create network
docker network inspect name    # Inspect network
docker network connect net ctr # Connect container to network
docker network rm name         # Remove network

# Volumes
docker volume ls               # List volumes
docker volume create name      # Create volume
docker volume inspect name     # Inspect volume
docker volume rm name          # Remove volume

# System
docker info                    # System information
docker system df               # Disk usage
docker system prune            # Clean up unused data
docker stats                   # Resource usage (live)
```

</details>

<details>
<summary><strong>🔹 Dockerfile syntax</strong></summary>

```dockerfile
# Base image
FROM ubuntu:22.04

# Metadata
LABEL maintainer="email@example.com"
LABEL version="1.0"

# Set working directory
WORKDIR /app

# Copy files
COPY file.txt /app/
COPY . /app/

# Run commands
RUN apt-get update && apt-get install -y nginx
RUN echo "Hello" > /app/hello.txt

# Environment variables
ENV APP_ENV=production
ENV PORT=8080

# Expose ports
EXPOSE 80
EXPOSE 443

# Volumes
VOLUME /data

# User (security)
USER nginx

# Entrypoint (not overridable)
ENTRYPOINT ["nginx"]

# CMD (overridable, default args)
CMD ["-g", "daemon off;"]

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

# Multi-stage build
FROM golang:1.21 AS builder
RUN go build -o app
FROM alpine:latest
COPY --from=builder /app/app .
```

</details>

<details>
<summary><strong>🔹 docker-compose.yml syntax</strong></summary>

```yaml
version: '3.8'

services:
  web:
    image: nginx:alpine
    build:
      context: ./web
      dockerfile: Dockerfile
    container_name: my-web
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
      - web-data:/var/log/nginx
    environment:
      - ENV=production
      - DEBUG=false
    env_file:
      - .env
    networks:
      - frontend
    depends_on:
      - api
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 3s
      retries: 3

  api:
    build: ./api
    ports:
      - "5000:5000"
    networks:
      - frontend
      - backend
    depends_on:
      - db

  db:
    image: postgres:15
    environment:
      - POSTGRES_PASSWORD=secret
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend

networks:
  frontend:
  backend:

volumes:
  web-data:
  db-data:
```

**Commands:**
```bash
docker compose up -d         # Start services
docker compose down          # Stop services
docker compose ps            # List services
docker compose logs -f       # Follow logs
docker compose restart web   # Restart service
docker compose exec web sh   # Shell in container
```

</details>

---

## 🧪 Тестирование

Автоматические тесты проверят:

1. ✅ Docker установлен и работает
2. ✅ Dockerfiles созданы и корректны
3. ✅ Images собираются успешно
4. ✅ Containers запускаются
5. ✅ Networking работает
6. ✅ Volumes persist data
7. ✅ docker-compose.yml валиден
8. ✅ Security scanning доступен (Trivy)
9. ✅ Audit report сгенерирован

**Запуск тестов:**
```bash
cd ~/kernel-shadows/season-4-devops-automation/episode-14-docker-basics
./tests/test.sh
```

---

## 💬 Цитаты Episode 14

**Sophie van Dijk:**
> "Containers zijn als LEGO. Собрали один раз, запускай где угодно. Простая концепция, мощное исполнение. Голландский прагматизм."

**Sophie (после supply chain attack):**
> "В Нидерландах мы говорим: 'Vertrouwen is goed, controle is beter.' Доверяй, но проверяй. Всегда проверяй. Всегда сканируй. Docker security — не опция."

**Dmitry:**
> "500 контейнеров на 50 серверах? Без Docker это был бы кошмар. С Docker это просто YAML файл."

**LILITH:**
> "Containers — это не магия. Это просто очень хорошая изоляция процессов. Linux namespaces + cgroups + union filesystem. Понимай основы."

**Max (evolution):**
- Start: "Зачем контейнеры? VMs работают."
- Mid: "О, контейнеры легче и быстрее. Понятно."
- After incident: "Supply chain attacks реальны. Scan everything. Trust nothing."
- End: "Containers zijn als LEGO... I get it now."

---

## 🎓 Что вы узнали

После Episode 14 вы умеете:

✅ Устанавливать Docker и Docker Compose
✅ Писать Dockerfiles (single-stage и multi-stage)
✅ Собирать и запускать containers
✅ Использовать Docker networking (custom networks)
✅ Persist data с Docker volumes
✅ Orchestrate multi-container apps с Docker Compose
✅ Сканировать images на уязвимости (Trivy)
✅ Respond to supply chain attacks
✅ Docker security best practices

**Эти навыки будут использоваться в:**
- Episode 15: CI/CD (automated Docker builds)
- Episode 16: Ansible (deploy containers с Ansible)
- Season 7: Kubernetes (orchestration на production)

---

## 🚀 Следующий шаг

**Episode 15: CI/CD Pipelines** (Berlin, Germany)

**Hans Müller (текстовое из Берлина):**
> *"Max, Dmitry. Docker basics — done. Tomorrow we automate. GitHub Actions will build your Docker images automatically. Test automatically. Deploy automatically. That's CI/CD. See you in Berlin. — Hans"*

**Supply chain subplot continues...**

---

<div align="center">

**Episode 14: Docker Basics — COMPLETE!**

*"Containers zijn als LEGO. Build once, run anywhere."*

🇳🇱 Amsterdam • Science Park • Containerization Mastery • Supply Chain Awareness

[⬅️ Episode 13: Git](../episode-13-git-version-control/README.md) | [⬆️ Season 4 Overview](../README.md) | [➡️ Episode 15: CI/CD](../episode-15-cicd-pipelines/README.md)

</div>



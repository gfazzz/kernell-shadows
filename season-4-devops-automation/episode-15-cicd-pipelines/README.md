# EPISODE 15: CI/CD PIPELINES ⚙️🇩🇪

> **"If it hurts, automate it. If it still hurts, you automated the wrong thing."**
> — Hans Müller, Chaos Computer Club

---

## 📍 Контекст операции

**День:** 29-30 из 60
**Локация:** 🇩🇪 Berlin, Germany (Chaos Computer Club, returns)
**Время:** 5-6 часов
**Сложность:** ⭐⭐⭐⭐☆

**Предыдущий эпизод:** [Episode 14: Docker Basics](../episode-14-docker-basics/README.md) (Amsterdam, Netherlands)
**Следующий эпизод:** Episode 16: Ansible & IaC (Amsterdam/Berlin)

---

## 🎬 Сюжет

### Переход Episode 14 → Episode 15

**Sophie (прощание в Амстердаме, день 28):**
> *"Max, Dmitry — Docker fundamentals готовы. Теперь automation. Hans в Берлине настроил CI/CD pipeline. Автоматические builds, tests, deployments. Но помните: automation усиливает и успех, и провал. Один сломанный pipeline = 50 серверов offline. Будьте осторожны."*

**День 29: Возврат в Берлин**

**10:00 — Tegel Airport, Berlin**

Max и Dmitry возвращаются в Берлин из Амстердама. Уже знакомая атмосфера: industrial aesthetic, graffiti, Chaos Computer Club.

**Dmitry:**
> *"Хорошо вернуться в Берлин. Hans уже неделю готовит CI/CD infrastructure. GitHub Actions runners, staging servers, production deployment pipeline. Всё автоматизировано. Почти слишком автоматизировано..."*

**11:00 — Chaos Computer Club**

Hans Müller встречает у входа. Выглядит уставшим — явно не спал несколько дней.

**Hans:**
> *"Max, Dmitry. С возвращением. CI/CD pipeline готов. Смотрите на это."*

(Hans показывает dashboard: GitHub Actions workflows, автоматические builds каждый commit, tests зелёные, deployments в staging успешные)

**Hans:**
> *"Каждый git push запускает:
> 1. Lint code
> 2. Run tests
> 3. Build Docker image
> 4. Push to registry
> 5. Deploy to staging
> 6. Если тесты проходят → deploy в production
>
> Полностью автоматизировано. Ноль человеческого вмешательства. Эффективно. Быстро. Опасно."*

**Max:**
> *"Опасно?"*

**Hans:**
> *"Автоматизация — это электроинструмент. Можешь построить дом за день. Или разрушить дом за секунду. Один плохой commit → автоматический deployment → 50 серверов сломаны. Вот почему нам нужны: rollback strategy, blue-green deployments, automated tests, monitoring, alerts. Идём, покажу."*

### 12:00 — CI/CD Workshop

**Hans's office:** Monitors everywhere. GitHub Actions dashboards, Grafana metrics, Prometheus alerts. Real-time CI/CD в действии.

**Hans:**
> *"Философия CI/CD:
> - **Continuous Integration:** Каждый commit тестируется автоматически
> - **Continuous Delivery:** Каждый commit МОЖЕТ быть задеплоен (ручной триггер)
> - **Continuous Deployment:** Каждый commit деплоится автоматически
>
> Мы используем Continuous Delivery. Production deployment требует ручного одобрения. Безопасность."*

(Hans открывает GitHub Actions workflow file)

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, development]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: ./tests/test.sh

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build Docker image
        run: docker build -t app:${{ github.sha }} .
      - name: Push to registry
        run: docker push registry.io/app:${{ github.sha }}

  deploy-staging:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to staging
        run: ssh staging "docker pull app:${{ github.sha }} && docker-compose up -d"

  deploy-production:
    needs: deploy-staging
    if: github.ref == 'refs/heads/main'
    environment: production  # Manual approval required
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to production
        run: ssh production "docker pull app:${{ github.sha }} && docker-compose up -d"
```

**Hans:**
> *"Видишь? Каждый stage зависит от предыдущего. Tests fail → no build. Build fails → no deploy. Staging fails → no production. Цепь доверия. Но..."*

**Max:**
> *"Но?"*

**Hans:**
> *"Tests могут пройти, но код всё равно сломан. Приложение может запуститься, но работать неправильно. Monitoring необходим. Rollback strategy необходима. Вот что мы практикуем сегодня."*

### ИНЦИДЕНТ (происходит около 15:45, день 29)

**15:30 — Normal operations**

Max и Dmitry практикуют CI/CD. Создали несколько commits, pipelines проходят успешно. Всё зелёное.

**15:45 — BROKEN DEPLOYMENT**

Dmitry делает commit с "minor fix" в database connection code. Тесты проходят (неполное покрытие!). Сборка успешна. Deploy в staging — OK. Pipeline предлагает deploy в production.

**Dmitry:**
> *"Tests зелёные, staging работает. Deploying to production..."*

(нажимает "Approve" для production deployment)

**15:47 — DISASTER**

Grafana alerts начинают кричать. Prometheus: **HTTP 500 errors spike: 0 → 5000/min**.

**Hans (мгновенно к мониторам):**
> *"Scheisse! Production упал! Все 50 серверов отдают HTTP 500!"*

**Max (паника):**
> *"Что случилось?!"*

**Hans:**
> *"Ваш deployment сломал database connections! Приложение стартует, тесты проходят, но production database config отличается от staging! Классическая ошибка!"*

**Dmitry (в ужасе):**
> *"Я сломал production?!"*

**Hans (спокойно, но быстро):**
> *"Ja. Теперь исправляем. У вас 5 минут до звонка Viktor clients. ROLLBACK. СЕЙЧАС."*

#### Emergency Rollback (15:47 - 15:52)

**Tasks (under pressure):**

1. **Identify broken deployment:**
```bash
# Проверяем GitHub Actions — последний успешный deploy
git log --oneline -5
# Output: a1b2c3d (HEAD) Fix database connection  ← BROKEN
#         e4f5g6h Previous working version        ← ROLLBACK TARGET
```

2. **Rollback production deployment:**
```bash
# Method 1: Redeploy previous version
ssh production "docker pull app:e4f5g6h && docker-compose up -d"

# Method 2: Use previous image tag
ssh production "docker tag app:e4f5g6h app:latest && docker-compose restart"
```

3. **Verify rollback:**
```bash
# Check Grafana — HTTP 500 errors должны упасть до 0
# Check application logs
ssh production "docker logs app-container | tail -50"
```

4. **Post-mortem analysis:**
```bash
# What broke?
git diff e4f5g6h a1b2c3d database_config.py

# Output shows: staging DB = localhost, production DB = db-cluster.vpc
# Code assumed localhost, broke in production
```

**15:52 — Resolution**

Production восстановлен. HTTP 500 errors: 5000/min → 0. Rollback успешен. Total downtime: **5 minutes**.

**Hans:**
> *"Хорошее время реакции. 5 минут downtime приемлемо. Но такого не должно повторяться. Что мы усвоили?"*

**Dmitry:**
> *"Тесты прошли, но не покрывали production config..."*

**Hans:**
> *"Точно. Тесты должны соответствовать production environment. Staging должен быть идентичен production. И всегда имейте rollback plan. ВСЕГДА."*

**Viktor (звонок через 2 минуты):**
> *"Hans, что случилось? Monitoring показал downtime."*

**Hans:**
> *"Ошибка deployment. Уже откачена. 5 минут downtime. Никакой потери данных. Post-mortem report готов."*

**Viktor:**
> *"5 minutes acceptable. But no more mistakes. Clients angry."*

**Hans (после звонка):**
> *"Это реальность CI/CD. Автоматизация быстро = провалы быстро. Но также: восстановление быстро. Manual deployment? 30 минут rollback. Automated? 5 минут. Вот в чём разница."*

### Финал Episode 15

**18:00 — Debriefing + Improvements**

**Hans:**
> *"Сегодня вы усвоили важнейший урок: автоматизация — не магия. Автоматизация усиливает. Хороший код → быстрый deployment. Плохой код → быстрая катастрофа. Нам нужно:
>
> 1. **Лучшие tests** — production-like environment
> 2. **Staging = production clone** — идентичная конфигурация
> 3. **Automated rollback** — восстановление одной кнопкой
> 4. **Blue-green deployment** — апгрейды без downtime
> 5. **Canary releases** — постепенный rollout
> 6. **Monitoring + alerts** — быстро детектить проблемы
>
> Всё это мы добавим сейчас. Завтра вы изучите Ansible — массовую автоматизацию. Но запомните сегодня: автоматизируйте осторожно."*

**Max:**
> *"Я никогда не забуду как мы сломали 50 серверов одним commit..."*

**Hans:**
> *"Хорошо. Страх здоров. Но не парализующий. Мы автоматизируем С защитными сетками. Это и есть инженерия."*

**Cliffhanger:**

**Klaus Schmidt (видеозвонок из Tempelhof datacenter):**
> *"Hans, Max, Dmitry. Ansible infrastructure готова. 50 серверов ждут конфигурацию. Один playbook, одна команда, массовая автоматизация. Завтра заканчиваем Season 4. Но после сегодняшнего инцидента... будьте осторожны. Ansible может сломать 50 серверов ещё быстрее, чем CI/CD. Увидимся завтра. — Klaus"*

---

## 🎯 Миссия Episode 15

**Основная задача:** Настроить CI/CD pipeline (GitHub Actions) для автоматизированных сборок, тестирования и deployment с rollback strategy.

**Конкретные задания:**

1. ✅ **Create GitHub Actions workflow** (.github/workflows/ci.yml)
2. ✅ **Automated testing** (lint, unit tests, integration tests)
3. ✅ **Docker build automation** (build on every commit)
4. ✅ **Push to Docker registry** (automated image publishing)
5. ✅ **Deploy to staging** (automatic after tests pass)
6. ✅ **Deploy to production** (manual approval, environment protection)
7. ✅ **Rollback strategy** (revert to previous working version)
8. ✅ **Blue-green deployment** (zero-downtime updates)
9. ✅ **INCIDENT: Production broken, emergency rollback** (time pressure: 5 minutes)

**Финальный артефакт:**
- Working CI/CD pipeline
- Automated tests integrated
- Rollback playbook
- Post-mortem report

---

## 📚 Теория: CI/CD

### Зачем нужен CI/CD?

**Проблемы без CI/CD:**
- ❌ Manual testing (забыли запустить тесты → broken code в production)
- ❌ Manual builds (inconsistent, "works on my machine")
- ❌ Manual deployment (slow, error-prone, 30+ минут)
- ❌ No rollback strategy (downtime hours)
- ❌ Fear of deployment ("deploy only Friday" → bugs accumulate)

**С CI/CD:**
- ✅ Automated testing (каждый commit тестируется автоматически)
- ✅ Согласованные сборки (Docker image из одного Dockerfile)
- ✅ Fast deployment (минуты вместо часов)
- ✅ Easy rollback (одна команда → previous version)
- ✅ Frequent deployments (10+ раз в день, маленькие изменения)

### CI vs CD vs CD

```
┌─────────────────────────────────────────────────────────────┐
│  Continuous Integration (CI)                                │
│  Every commit → automatic build + test                      │
│  Goal: Catch bugs early                                     │
└─────────────────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────────────────┐
│  Continuous Delivery (CD)                                   │
│  Every commit CAN be deployed (manual approval)             │
│  Goal: Always deployment-ready                              │
└─────────────────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────────────────┐
│  Continuous Deployment (CD)                                 │
│  Every commit IS deployed automatically (no approval)       │
│  Goal: Maximum velocity                                     │
└─────────────────────────────────────────────────────────────┘
```

**Какой выбрать?**
- **CI only:** Минимум — automated testing
- **CI + Continuous Delivery:** Recommended для production (manual approval)
- **CI + Continuous Deployment:** Максимум — полная автоматизация (требует отличных тестов!)

### GitHub Actions Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                    GitHub Repository                         │
│  .github/workflows/ci.yml                                    │
└────────────────────────┬─────────────────────────────────────┘
                         │ Git Push / PR
                         ↓
┌──────────────────────────────────────────────────────────────┐
│                  GitHub Actions Runner                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Job 1:     │  │   Job 2:     │  │   Job 3:     │      │
│  │   Test       │→ │   Build      │→ │   Deploy     │      │
│  │              │  │              │  │              │      │
│  │ - Checkout   │  │ - Checkout   │  │ - SSH        │      │
│  │ - Run tests  │  │ - Docker     │  │ - Deploy     │      │
│  │ - Report     │  │ - Push       │  │ - Verify     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└──────────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────────┐
│              Deployment Targets                              │
│  ┌──────────────┐      ┌──────────────┐                     │
│  │   Staging    │      │  Production  │                     │
│  │   Server     │      │   Servers    │                     │
│  └──────────────┘      └──────────────┘                     │
└──────────────────────────────────────────────────────────────┘
```

**Key concepts:**
- **Workflow:** YAML file defining pipeline
- **Job:** Set of steps (test, build, deploy)
- **Step:** Individual task (checkout code, run command)
- **Runner:** Machine executing workflow (GitHub-hosted или self-hosted)
- **Trigger:** Event starting workflow (push, PR, schedule)

---

## 💻 Практика: 9 заданий

### Задание 1: Create GitHub Actions Workflow

**Миссия:** Создать базовый CI/CD workflow.

**Задача:**

```bash
# Create workflow directory
mkdir -p .github/workflows

# Create basic CI workflow
cat > .github/workflows/ci.yml << 'EOF'
name: CI Pipeline

on:
  push:
    branches: [main, development]
  pull_request:
    branches: [main]

jobs:
  test:
    name: Run Tests
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Run linter
        run: |
          echo "Running linter..."
          # Add your linter here

      - name: Run tests
        run: |
          echo "Running tests..."
          # Add your tests here

      - name: Test summary
        if: always()
        run: echo "Tests completed"

  build:
    name: Build Docker Image
    needs: test
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Build Docker image
        run: |
          docker build -t operation-shadow/app:${{ github.sha }} .
          docker build -t operation-shadow/app:latest .

      - name: List images
        run: docker images | grep operation-shadow
EOF

# Commit and push
git add .github/workflows/ci.yml
git commit -m "feat: add GitHub Actions CI pipeline"
git push
```

**Verify:**
- Go to GitHub repo → Actions tab
- Should see workflow running

<details>
<summary>💡 Hint: Workflow syntax</summary>

**Workflow structure:**
```yaml
name: Workflow Name

on: [trigger events]

jobs:
  job-name:
    runs-on: ubuntu-latest
    steps:
      - name: Step name
        uses: action@version  # Or 'run: command'
```

**Common actions:**
- `actions/checkout@v3` — Clone repository
- `actions/setup-node@v3` — Install Node.js
- `docker/setup-buildx-action@v2` — Docker builder
- `docker/login-action@v2` — Login to registry

</details>

---

### Задание 2: Automated Testing

**Миссия:** Integrate automated tests в CI pipeline.

**Create test script:**

```bash
# Create tests directory
mkdir -p tests

# Create test script
cat > tests/test.sh << 'EOF'
#!/bin/bash
set -e

echo "Running tests..."

# Test 1: Check Dockerfile exists
if [ ! -f Dockerfile ]; then
    echo "❌ Dockerfile not found"
    exit 1
fi
echo "✓ Dockerfile exists"

# Test 2: Dockerfile syntax
if ! docker build --no-cache -t test-image . > /dev/null 2>&1; then
    echo "❌ Dockerfile syntax error"
    exit 1
fi
echo "✓ Dockerfile builds successfully"

# Test 3: Application starts
CONTAINER=$(docker run -d -p 8080:80 test-image)
sleep 2
if ! curl -f http://localhost:8080 > /dev/null 2>&1; then
    echo "❌ Application doesn't respond"
    docker stop $CONTAINER
    exit 1
fi
docker stop $CONTAINER
echo "✓ Application starts and responds"

echo "All tests passed!"
EOF

chmod +x tests/test.sh

# Update workflow to use tests
# Edit .github/workflows/ci.yml:
# - name: Run tests
#   run: ./tests/test.sh
```

---

### Задание 3: Docker Registry Integration

**Миссия:** Automatically push Docker images to registry.

**Update workflow:**

```yaml
build-and-push:
  name: Build and Push Docker Image
  needs: test
  runs-on: ubuntu-latest

  steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}

    - name: Build and push
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: |
          ${{ secrets.DOCKER_USERNAME }}/operation-shadow:${{ github.sha }}
          ${{ secrets.DOCKER_USERNAME }}/operation-shadow:latest
```

**Setup secrets:**
1. GitHub repo → Settings → Secrets → New repository secret
2. Add `DOCKER_USERNAME` (your Docker Hub username)
3. Add `DOCKER_PASSWORD` (Docker Hub access token)

---

### Задание 4: Deploy to Staging

**Миссия:** Автоматический deployment в staging environment.

**Create deployment job:**

```yaml
deploy-staging:
  name: Deploy to Staging
  needs: build-and-push
  runs-on: ubuntu-latest
  environment: staging

  steps:
    - name: Deploy via SSH
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.STAGING_HOST }}
        username: ${{ secrets.STAGING_USER }}
        key: ${{ secrets.STAGING_SSH_KEY }}
        script: |
          cd /opt/operation-shadow
          docker-compose pull
          docker-compose up -d
          docker-compose ps

    - name: Health check
      run: |
        sleep 10
        curl -f ${{ secrets.STAGING_URL }}/health || exit 1

    - name: Notify success
      if: success()
      run: echo "✓ Staging deployment successful"
```

**Setup staging secrets:**
- `STAGING_HOST` — staging server IP
- `STAGING_USER` — SSH username
- `STAGING_SSH_KEY` — SSH private key
- `STAGING_URL` — staging URL

---

### Задание 5: Production Deployment with Approval

**Миссия:** Deploy to production with manual approval (safety gate).

**Create production job:**

```yaml
deploy-production:
  name: Deploy to Production
  needs: deploy-staging
  runs-on: ubuntu-latest
  if: github.ref == 'refs/heads/main'  # Only on main branch
  environment:
    name: production
    url: https://operation-shadow.net

  steps:
    - name: Deploy via SSH
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.PRODUCTION_HOST }}
        username: ${{ secrets.PRODUCTION_USER }}
        key: ${{ secrets.PRODUCTION_SSH_KEY }}
        script: |
          cd /opt/operation-shadow

          # Backup current version (for rollback)
          docker tag operation-shadow/app:latest operation-shadow/app:rollback

          # Pull new version
          docker-compose pull
          docker-compose up -d

          # Health check
          sleep 10
          curl -f http://localhost/health || exit 1

    - name: Smoke tests
      run: |
        # Run production smoke tests
        curl -f ${{ secrets.PRODUCTION_URL }}/health
        curl -f ${{ secrets.PRODUCTION_URL }}/api/status

    - name: Notify team
      if: success()
      run: echo "🚀 Production deployment successful!"
```

**Setup environment protection:**
1. GitHub repo → Settings → Environments → New environment "production"
2. Enable "Required reviewers" (добавить Max, Dmitry, Hans)
3. Deployment будет ждать approval перед запуском

---

### Задание 6: Rollback Strategy

**Миссия:** Create automated rollback procedure.

**Create rollback workflow:**

```yaml
# .github/workflows/rollback.yml
name: Rollback Production

on:
  workflow_dispatch:  # Manual trigger
    inputs:
      version:
        description: 'Version to rollback to (git sha or tag)'
        required: true

jobs:
  rollback:
    name: Rollback Production Deployment
    runs-on: ubuntu-latest
    environment: production

    steps:
      - name: Rollback via SSH
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.PRODUCTION_HOST }}
          username: ${{ secrets.PRODUCTION_USER }}
          key: ${{ secrets.PRODUCTION_SSH_KEY }}
          script: |
            cd /opt/operation-shadow

            echo "Rolling back to version: ${{ github.event.inputs.version }}"

            # Pull specific version
            docker pull operation-shadow/app:${{ github.event.inputs.version }}
            docker tag operation-shadow/app:${{ github.event.inputs.version }} operation-shadow/app:latest

            # Restart services
            docker-compose up -d

            # Verify
            sleep 10
            curl -f http://localhost/health || exit 1

      - name: Verify rollback
        run: |
          curl -f ${{ secrets.PRODUCTION_URL }}/health
          echo "✓ Rollback successful"

      - name: Notify team
        run: echo "⚠️ Production rolled back to ${{ github.event.inputs.version }}"
```

**Usage:**
1. GitHub repo → Actions → "Rollback Production"
2. Click "Run workflow"
3. Enter version (git SHA или tag)
4. Approve and run

---

### Задание 7: Blue-Green Deployment

**Миссия:** Zero-downtime deployment using blue-green strategy.

**Concept:**
- **Blue:** Currently running production
- **Green:** New version deploying
- **Switch:** Load balancer redirects traffic blue → green
- **Rollback:** Switch back green → blue if problems

**Implementation:**

```yaml
deploy-blue-green:
  name: Blue-Green Deployment
  runs-on: ubuntu-latest
  environment: production

  steps:
    - name: Deploy to green environment
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.PRODUCTION_HOST }}
        username: ${{ secrets.PRODUCTION_USER }}
        key: ${{ secrets.PRODUCTION_SSH_KEY }}
        script: |
          cd /opt/operation-shadow

          # Deploy to green (port 8081)
          docker run -d -p 8081:80 --name app-green \
            operation-shadow/app:${{ github.sha }}

          # Health check green
          sleep 10
          curl -f http://localhost:8081/health || exit 1

          # Switch nginx to green
          sed -i 's/proxy_pass.*8080/proxy_pass http:\/\/localhost:8081/' /etc/nginx/nginx.conf
          nginx -t && nginx -s reload

          # Stop blue
          docker stop app-blue
          docker rm app-blue

          # Rename green → blue
          docker rename app-green app-blue
          docker update --restart always app-blue

    - name: Verify deployment
      run: curl -f ${{ secrets.PRODUCTION_URL }}/health
```

---

### Задание 8: Monitoring & Alerts

**Миссия:** Добавить monitoring и alerts к CI/CD pipeline.

**Add monitoring checks:**

```yaml
monitor:
  name: Post-Deployment Monitoring
  needs: deploy-production
  runs-on: ubuntu-latest

  steps:
    - name: Wait for metrics
      run: sleep 60  # Let metrics accumulate

    - name: Check error rate
      run: |
        # Query Prometheus for error rate
        ERROR_RATE=$(curl -s "http://prometheus:9090/api/v1/query?query=rate(http_errors_total[5m])" | jq '.data.result[0].value[1]')

        if (( $(echo "$ERROR_RATE > 0.01" | bc -l) )); then
          echo "❌ High error rate: $ERROR_RATE"
          exit 1
        fi
        echo "✓ Error rate acceptable: $ERROR_RATE"

    - name: Check response time
      run: |
        # Query Prometheus for p99 latency
        P99=$(curl -s "http://prometheus:9090/api/v1/query?query=histogram_quantile(0.99, http_request_duration_seconds_bucket)" | jq '.data.result[0].value[1]')

        if (( $(echo "$P99 > 1.0" | bc -l) )); then
          echo "⚠️ High latency: ${P99}s"
        fi
        echo "✓ Latency acceptable: ${P99}s"

    - name: Alert on failure
      if: failure()
      uses: 8398a7/action-slack@v3
      with:
        status: ${{ job.status }}
        text: '🚨 Production deployment monitoring failed!'
        webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

---

### Задание 9: INCIDENT — Production Broken, Emergency Rollback

**‼️ EMERGENCY SCENARIO ‼️**

**Scenario (from plot):**

**15:47 — Production is DOWN!**

Dmitry задеплоил commit с database config bug. Тесты прошли (неполное покрытие!). Production возвращает HTTP 500 на всех 50 серверах.

**Hans:** *"You have 5 minutes before Viktor calls. ROLLBACK. NOW."*

**Tasks (under extreme pressure):**

**1. Identify broken deployment (30 seconds):**
```bash
# Check recent deployments
git log --oneline -5
# a1b2c3d (HEAD) Fix database connection  ← BROKEN
# e4f5g6h Previous working version        ← ROLLBACK TARGET

# Or check GitHub Actions history
gh run list --limit 5
```

**2. Trigger emergency rollback (1 minute):**
```bash
# Method 1: GitHub Actions rollback workflow
gh workflow run rollback.yml -f version=e4f5g6h

# Method 2: Direct SSH rollback
ssh production << 'SCRIPT'
cd /opt/operation-shadow
docker pull operation-shadow/app:e4f5g6h
docker tag operation-shadow/app:e4f5g6h operation-shadow/app:latest
docker-compose up -d
SCRIPT
```

**3. Verify rollback (1 minute):**
```bash
# Check HTTP 500 errors (should drop to 0)
curl -I https://operation-shadow.net/health
# HTTP/1.1 200 OK ✓

# Check Grafana
open http://grafana:3000/d/production-dashboard
# Error rate: 5000/min → 0 ✓
```

**4. Post-mortem analysis (2 minutes):**
```bash
# What broke?
git diff e4f5g6h a1b2c3d

# Find the bug
# Config file: DB_HOST=localhost (staging) vs DB_HOST=db-cluster.vpc (production)
# Tests didn't catch this because staging used same config
```

**5. Document incident (after resolution):**

Create `docs/incidents/2025-10-10-deployment-failure.md`:
```markdown
# Incident: Production Deployment Failure

**Date:** 2025-10-10 15:47
**Duration:** 5 minutes
**Impact:** 50 servers, HTTP 500 errors
**Root cause:** Database configuration hardcoded for staging

## Timeline
- 15:45: Deployment triggered (commit a1b2c3d)
- 15:47: Production down, HTTP 500 errors
- 15:47: Rollback initiated
- 15:52: Production restored

## Root Cause
Database connection config assumed `localhost`, worked in staging but not production (db-cluster.vpc).

## Resolution
Rolled back to e4f5g6h (previous working version).

## Prevention
1. Add integration tests with production-like config
2. Use environment variables for DB config
3. Make staging identical to production
4. Add database connection health check

## Action Items
- [ ] Fix database config (use env vars)
- [ ] Add integration tests
- [ ] Update staging to match production
- [ ] Add pre-deployment health check
```

**Hans (after 5-minute resolution):**
> *"Good. 5 minutes downtime. Acceptable. Now we learn and prevent. That's engineering."*

---

## 📖 CI/CD Best Practices

<details>
<summary><strong>🔹 Testing Strategy</strong></summary>

**Test pyramid:**
```
         ┌─────────────┐
         │   E2E Tests │  ← Few, slow, expensive
         └─────────────┘
       ┌─────────────────┐
       │ Integration Tests│  ← Some, medium speed
       └─────────────────┘
    ┌──────────────────────┐
    │     Unit Tests       │  ← Many, fast, cheap
    └──────────────────────┘
```

**What to test:**
1. **Unit tests:** Individual functions (fast, many)
2. **Integration tests:** Multiple components together
3. **E2E tests:** Full user journey (slow, few)
4. **Smoke tests:** Basic functionality after deployment

**CI/CD integration:**
- Run unit tests on every commit
- Run integration tests before deployment
- Run smoke tests after deployment
- Run E2E tests nightly (too slow for every commit)

</details>

<details>
<summary><strong>🔹 Deployment Strategies</strong></summary>

**1. Rolling Deployment:**
```
Server 1: v1.0 → v1.1 → done
Server 2: v1.0 → v1.1 → done
Server 3: v1.0 → v1.1 → done
...
```
**Pros:** Simple, no extra servers
**Cons:** Mixed versions during deployment

**2. Blue-Green Deployment:**
```
Blue (old):  v1.0 ──┐
                    ├─ Load Balancer (switch)
Green (new): v1.1 ──┘
```
**Pros:** Zero downtime, instant rollback
**Cons:** Requires 2x servers

**3. Canary Release:**
```
Server 1-49: v1.0 (99%)
Server 50:   v1.1 (1%)  ← Monitor errors
If OK → gradually increase v1.1 to 100%
```
**Pros:** Gradual, safe
**Cons:** Complex routing

</details>

<details>
<summary><strong>🔹 Rollback Strategy</strong></summary>

**Always have rollback plan:**
1. **Tag previous version:** Before deploy, tag current as `rollback`
2. **One-command rollback:** Automate (5 minutes, not 30)
3. **Test rollback:** Practice rollback procedure quarterly
4. **Database migrations:** Ensure backward compatibility

**Rollback checklist:**
```bash
# 1. Stop new deployment
# 2. Revert to previous version
# 3. Verify health checks
# 4. Check monitoring (errors dropped?)
# 5. Notify team
# 6. Post-mortem analysis
```

</details>

---

## 🧪 Тестирование

Автоматические тесты проверят:

1. ✅ GitHub Actions workflow exists
2. ✅ Workflow syntax valid
3. ✅ Tests integrated in pipeline
4. ✅ Docker build automated
5. ✅ Staging deployment configured
6. ✅ Production deployment has approval
7. ✅ Rollback workflow exists
8. ✅ Secrets properly configured
9. ✅ Post-deployment monitoring

**Запуск тестов:**
```bash
cd ~/kernel-shadows/season-4-devops-automation/episode-15-cicd-pipelines
./tests/test.sh
```

---

## 💬 Цитаты Episode 15

**Hans Müller:**
> "Автоматизация — это электроинструмент. Можешь построить дом за день. Или разрушить за секунду. Вот почему у нас tests, monitoring, rollback. Инженерия."

**Hans (после инцидента):**
> "Если болит — автоматизируй. Если всё ещё болит — автоматизировал не то. Сегодня болело. Значит, улучшаем автоматизацию."

**Dmitry (после того как сломал production):**
> "Я никогда не забуду эти 5 минут..."

**Hans:**
> "Хорошо. Страх здоров. Но не парализующий. Мы автоматизируем С защитными сетками."

**LILITH:**
> "CI/CD amplifies everything. Good code → fast success. Bad code → fast disaster. But also: fast recovery. That's the difference between automation and manual."

**Max (evolution):**
- Start: "Automation сложная. Зачем, если можно руками?"
- Mid: "О, каждый commit автоматически тестируется и деплоится!"
- После инцидента: "Автоматизация опасна без защитных сеток..."
- End: "Automation WITH tests, monitoring, rollback = powerful AND safe."

---

## 🎓 Что вы узнали

После Episode 15 вы умеете:

✅ Создавать GitHub Actions workflows
✅ Автоматизированное тестирование в CI pipeline
✅ Docker builds automation
✅ Deploy в staging и production
✅ Manual approval gates (safety)
✅ Rollback strategies (emergency recovery)
✅ Blue-green deployments (zero downtime)
✅ Monitoring после deployment
✅ Incident response (under pressure!)

**Эти навыки будут использоваться в:**
- Episode 16: Ansible (automated server configuration)
- Season 5: Security (security scanning в CI/CD)
- Season 7: Kubernetes (production orchestration)

---

## 🚀 Следующий шаг

**Episode 16: Ansible & IaC** (Amsterdam/Berlin)

**Klaus Schmidt (видеозвонок):**
> *"CI/CD автоматизирует deployment. Ansible автоматизирует configuration. 50 servers, одна команда, одна минута. Last episode Season 4. Tomorrow we finish. — Klaus"*

---

<div align="center">

**Episode 15: CI/CD Pipelines — COMPLETE!**

*"If it hurts, automate it. But automate carefully."*

🇩🇪 Berlin • Chaos Computer Club • CI/CD Mastery • Incident Response Excellence

[⬅️ Episode 14: Docker](../episode-14-docker-basics/README.md) | [⬆️ Season 4 Overview](../README.md) | [➡️ Episode 16: Ansible](../episode-16-ansible-iac/README.md)

</div>



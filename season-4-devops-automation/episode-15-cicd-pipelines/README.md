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
> *"Макс, Дмитрий — Docker fundamentals готовы. Теперь automation. Hans в Берлине настроил CI/CD pipeline. Автоматические builds, tests, deployments. Но помните: automation усиливает и успех, и провал. Один сломанный pipeline = 50 серверов offline. Будьте осторожны."*

**День 29: Возврат в Берлин**

**10:00 — Tegel Airport, Berlin**

Макс и Дмитрий возвращаются в Берлин из Амстердама. Уже знакомая атмосфера: industrial aesthetic, graffiti, Chaos Computer Club.

**Дмитрий:**
> *"Хорошо вернуться в Берлин. Hans уже неделю готовит CI/CD infrastructure. GitHub Actions runners, staging servers, production deployment pipeline. Всё автоматизировано. Почти слишком автоматизировано..."*

**11:00 — Chaos Computer Club**

Hans Müller встречает у входа. Выглядит уставшим — явно не спал несколько дней.

**Hans:**
> *"Макс, Дмитрий. С возвращением. CI/CD pipeline готов. Смотрите на это."*

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

**Макс:**
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

**Макс:**
> *"Но?"*

**Hans:**
> *"Tests могут пройти, но код всё равно сломан. Приложение может запуститься, но работать неправильно. Monitoring необходим. Rollback strategy необходима. Вот что мы практикуем сегодня."*

### ИНЦИДЕНТ (происходит около 15:45, день 29)

**15:30 — Normal operations**

Max и Dmitry практикуют CI/CD. Создали несколько commits, pipelines проходят успешно. Всё зелёное.

**15:45 — BROKEN DEPLOYMENT**

Dmitry делает commit с "minor fix" в database connection code. Тесты проходят (неполное покрытие!). Сборка успешна. Deploy в staging — OK. Pipeline предлагает deploy в production.

**Дмитрий:**
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

**Дмитрий:**
> *"Тесты прошли, но не покрывали production config..."*

**Hans:**
> *"Точно. Тесты должны соответствовать production environment. Staging должен быть идентичен production. И всегда имейте rollback plan. ВСЕГДА."*

**Viktor (звонок через 2 минуты):**
> *"Hans, что случилось? Monitoring показал downtime."*

**Hans:**
> *"Ошибка deployment. Уже откачена. 5 минут downtime. Никакой потери данных. Post-mortem report готов."*

**Виктор:**
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

**Макс:**
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
- GitHub Actions workflows для CI/CD
- Rollback scripts/procedures
- Blue-green deployment configuration
- Monitoring integration (Grafana/Prometheus)

---

## 🎓 Учебная программа: 7 циклов

**Продолжительность:** 5-6 часов
**Формат:** Interleaving (Сюжет → Теория → Практика → Проверка)

1. **Цикл 1:** CI/CD Basics — Конвейер на фабрике 🏭 (10-15 мин)
2. **Цикл 2:** GitHub Actions — Роботы-сборщики 🤖 (10-15 мин)
3. **Цикл 3:** Automated Testing — Инспектор качества 🔍 (10-15 мин)
4. **Цикл 4:** Docker Registry — Склад готовых изделий 📦 (10-15 мин)
5. **Цикл 5:** INCIDENT — Broken Deployment & Rollback 🔥 (15-20 мин)
6. **Цикл 6:** Blue-Green Deployment — Две дороги 🛣️ (15-20 мин)
7. **Цикл 7:** Monitoring & Observability — Глаза на производстве 👁️ (10-15 мин)

---

## ЦИКЛ 1: CI/CD Basics — Конвейер на фабрике 🏭
### (10-15 минут)

### 🎬 Сюжет: Hans показывает автоматизацию

**12:15 — Hans's office**

Hans открывает терминал. Один `git push`.

```bash
git add .
git commit -m "feat: add new feature"
git push origin main
```

Через 30 секунд: GitHub Actions dashboard светится зелёным. Tests passed. Build passed. Deployed to staging.

**Hans:**
> *"30 секунд. От commit до working application на staging. Manual deployment? 30 минут. Вот что такое автоматизация."*

**Max (впечатлён):**
> *"Как assembly line на заводе..."*

**Hans:**
> *"Genau! CI/CD — это assembly line для кода. Каждый commit проходит через конвейер: тестирование, сборка, упаковка, доставка. Автоматически. Как car factory."*

**LILITH:**
> *"CI/CD — это конвейер для кода. Henry Ford изобрёл assembly line для машин. DevOps инженеры изобрели CI/CD для приложений. Принцип тот же: автоматизация повторяемых задач."*

---

### 📚 Теория: Зачем нужен CI/CD?

**Проблемы без автоматизации:**

❌ **Manual testing:** "У меня работает" → production сломан
❌ **Manual builds:** Забыл флаг, образ broken
❌ **Manual deployment:** SSH в 50 серверов, копировать вручную → 3 часа
❌ **Integration hell:** 10 developers, 50 commits → мерж conflicts неделю
❌ **Fear of deployment:** "Не деплой в пятницу!" → slow releases

**С CI/CD:**

✅ **Automated testing:** Каждый commit тестируется → bugs caught early
✅ **Automated builds:** Один способ собрать → consistent results
✅ **Automated deployment:** Одна команда → 50 серверов за 5 минут
✅ **Continuous integration:** Merge часто → small changes, easy fixes
✅ **Frequent deployments:** Deploy 10 раз в день → fast iteration

**LILITH:**
> *"Manual deployment — это как печатать книги вручную. Медленно, ошибки, дорого. CI/CD — это printing press. Быстро, consistent, scalable."*

---

### 💡 Метафора: CI/CD = Assembly Line

```
🏭 Car Factory (Assembly Line)
│
├─ Station 1: Frame welding (automated)
├─ Station 2: Engine install (automated)
├─ Station 3: Paint job (automated)
├─ Station 4: Quality control (automated)
└─ Result: Car ready in 18 hours

⚙️ CI/CD Pipeline
│
├─ Stage 1: Code checkout (automated)
├─ Stage 2: Run tests (automated)
├─ Stage 3: Build Docker image (automated)
├─ Stage 4: Deploy to servers (automated)
└─ Result: App deployed in 5 minutes
```

**Before assembly line:**
- Build car by hand → 12 days per car
- Errors frequent, slow, expensive

**With assembly line:**
- Automated steps → 18 hours per car
- Consistent quality, fast, cheap

**Same with CI/CD:**
- Manual deployment → 3 hours, error-prone
- Automated CI/CD → 5 minutes, reliable

**Hans:**
> *"Henry Ford revolutionized manufacturing. CI/CD revolutionized software delivery. Same principle: automate the boring stuff."*

---

### 📖 CI vs CD vs CD (Визуализация)

```
┌────────────────────────────────────────────────────────────┐
│                   CODE CHANGES                              │
└───────────────────────┬────────────────────────────────────┘
                        │
                        ▼
┌────────────────────────────────────────────────────────────┐
│           CONTINUOUS INTEGRATION (CI)                       │
│  • Automated testing on every commit                        │
│  • Early bug detection                                      │
│  • Merge conflicts resolved frequently                      │
└───────────────────────┬────────────────────────────────────┘
                        │
                        ▼
┌────────────────────────────────────────────────────────────┐
│         CONTINUOUS DELIVERY (CD #1)                         │
│  • Code READY for deployment anytime                        │
│  • Manual approval before production                        │
│  • One-click deploy                                         │
└───────────────────────┬────────────────────────────────────┘
                        │
                        ▼ (optional)
┌────────────────────────────────────────────────────────────┐
│         CONTINUOUS DEPLOYMENT (CD #2)                       │
│  • FULLY automated to production                            │
│  • No human intervention                                    │
│  • Every commit → production (if tests pass)                │
└────────────────────────────────────────────────────────────┘
```

**Differences:**

| Aspect | CI | Continuous Delivery | Continuous Deployment |
|--------|------|---------------------|----------------------|
| **Testing** | ✅ Automated | ✅ Automated | ✅ Automated |
| **Build** | ✅ Automated | ✅ Automated | ✅ Automated |
| **Deploy to Staging** | ✅ Automated | ✅ Automated | ✅ Automated |
| **Deploy to Production** | ❌ Manual | 🟡 Manual button | ✅ Fully automated |
| **Risk** | Low | Medium | High |

**Hans:**
> *"Мы используем Continuous Delivery. Production deployment — manual approval. Safety first."*

**LILITH:**
> *"Continuous Deployment = autopilot. Sounds cool, но если autopilot ошибается → crash. Continuous Delivery = pilot with autopilot assist. Safer."*

---

### 💻 Практика 1: First GitHub Actions Workflow

```bash
cd ~/kernel-shadows/season-4-devops-automation/episode-15-cicd-pipelines/starter

# 1. Create .github/workflows directory
mkdir -p .github/workflows

# 2. Create basic workflow
cat > .github/workflows/ci.yml << 'EOF'
name: CI Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Run tests
        run: |
          echo "Running tests..."
          ./tests/test.sh || echo "Tests would run here"
      
      - name: Success
        run: echo "✅ Tests passed!"
EOF

# 3. Commit and push
git add .github/
git commit -m "ci: add basic GitHub Actions workflow"
git push origin main

# 4. Check GitHub Actions tab to see pipeline running
# https://github.com/YOUR_REPO/actions
```

**Hans:**
> *"Твой первый CI pipeline. Каждый push теперь тестируется автоматически."*

---

### 🤔 Проверка понимания: Цикл 1

**Вопрос 1:** В чём главное отличие Continuous Delivery от Continuous Deployment?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Production deployment.**

- **Continuous Delivery:** Deploy to production = MANUAL (требует одобрения)
- **Continuous Deployment:** Deploy to production = FULLY AUTOMATED

Оба автоматизируют testing, build, staging. Разница — кто нажимает кнопку "deploy to production".

**Hans:** *"Continuous Delivery = безопасность. Continuous Deployment = скорость. Choose based on risk tolerance."*

</details>

**Вопрос 2:** Почему CI/CD сравнивают с assembly line?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Автоматизация повторяемых шагов.**

Assembly line:
- Raw materials → Station 1 → Station 2 → ... → Finished product
- Автоматизировано, быстро, consistent

CI/CD:
- Code → Test → Build → Deploy → Running app
- Автоматизировано, быстро, reliable

**LILITH:** *"Оба превращают ручной труд в автоматизированный процесс. Assembly line для физических вещей. CI/CD для кода."*

</details>

---

## ЦИКЛ 2: GitHub Actions — Роботы-сборщики 🤖
### (10-15 минут)

### 🎬 Сюжет: Anatomy of Workflow

**12:45 — Hans открывает workflow file**

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, development]

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
      - name: Build Docker image
        run: docker build -t app:latest .
```

**Hans:**
> *"GitHub Actions — это роботы-сборщики. Ты описываешь ЧТО делать (YAML), GitHub предоставляет ГДЕ (runners), роботы делают работу."*

**Dmitry:**
> *"Runners — это что?"*

**Hans:**
> *"Virtual machines в GitHub cloud. Каждый job запускается на отдельной VM. Job завершён → VM уничтожена. Ephemeral, clean, isolated."*

**LILITH:**
> *"GitHub Actions runners — как temp workers. Нанял, сделал задачу, уволил. Next job — new worker. No state, no history. Clean slate."*

---

### 📚 Теория: GitHub Actions Architecture

**Workflow structure:**

```yaml
name: Pipeline Name          # Имя workflow

on:                          # Triggers (когда запускать)
  push:
    branches: [main]
  pull_request:

jobs:                        # Jobs (что делать)
  job1:                      # Job name
    runs-on: ubuntu-latest   # Runner OS
    steps:                   # Steps (шаги)
      - name: Step 1
        run: echo "Hello"
      - name: Step 2
        run: ./script.sh
```

**Key concepts:**

1. **Workflow:** Automation process (YAML file in `.github/workflows/`)
2. **Job:** Collection of steps (runs on single runner)
3. **Step:** Individual task (command or action)
4. **Runner:** VM that executes jobs
5. **Action:** Reusable component (like `actions/checkout@v3`)

---

### 💡 Метафора: Jobs = Workers on Assembly Line

```
🏭 Assembly Line Analogy

Worker 1 (Test Job):
├─ Step 1: Get raw materials (checkout code)
├─ Step 2: Inspect quality (run tests)
└─ Result: Pass/Fail

Worker 2 (Build Job):
├─ Waits for Worker 1 (needs: test)
├─ Step 1: Get approved materials
├─ Step 2: Assemble parts (build Docker image)
└─ Result: Packaged product

Worker 3 (Deploy Job):
├─ Waits for Worker 2 (needs: build)
├─ Step 1: Ship to warehouse (deploy to servers)
└─ Result: Product delivered
```

**Dependencies (`needs`):**
```yaml
jobs:
  test:
    # Runs first
  
  build:
    needs: test      # Waits for 'test' to complete
  
  deploy:
    needs: build     # Waits for 'build' to complete
```

**If test fails → build never starts → deploy never starts.**

**Hans:**
> *"Chain of trust. Each stage depends on previous. One fails → chain breaks."*

---

### 📖 Actions = Lego Blocks

GitHub provides thousands of reusable Actions:

```yaml
steps:
  # Checkout code from repo
  - uses: actions/checkout@v3
  
  # Setup Node.js
  - uses: actions/setup-node@v3
    with:
      node-version: '18'
  
  # Cache dependencies
  - uses: actions/cache@v3
    with:
      path: node_modules
      key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
  
  # Custom command
  - name: Run tests
    run: npm test
```

**Popular actions:**
- `actions/checkout` — Clone repo
- `actions/setup-*` — Install language runtimes
- `actions/cache` — Cache dependencies
- `docker/build-push-action` — Build and push Docker images

**LILITH:**
> *"Actions — это библиотеки для CI/CD. Не переписывай checkout logic. Используй `actions/checkout`. DRY principle для workflows."*

---

### 💻 Практика 2: Multi-Job Workflow

```yaml
# .github/workflows/ci-cd.yml
name: Full CI/CD Pipeline

on:
  push:
    branches: [main, development]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Lint code
        run: |
          echo "Linting..."
          # shellcheck scripts/*.sh || true
      
      - name: Run unit tests
        run: |
          echo "Testing..."
          ./tests/test.sh
  
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build Docker image
        run: |
          docker build -t myapp:${{ github.sha }} .
          docker tag myapp:${{ github.sha }} myapp:latest
      
      - name: Save image
        run: docker save myapp:latest > myapp.tar
      
      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: docker-image
          path: myapp.tar
  
  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to staging
        run: |
          echo "Deploying to staging..."
          # ssh staging "docker pull myapp:latest && docker-compose up -d"
```

---

### 🤔 Проверка понимания: Цикл 2

**Вопрос 1:** Что произойдёт если test job fails?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Build и deploy НЕ запустятся.**

```yaml
jobs:
  test:
    # FAIL! ❌
  
  build:
    needs: test  # Waiting for test... NEVER STARTS
  
  deploy:
    needs: build # Waiting for build... NEVER STARTS
```

**Dependency chain:** test → build → deploy

Один сломан → вся цепь останавливается.

**Hans:** *"Это защита. Broken tests → no deployment. Safety mechanism."*

</details>

**Вопрос 2:** Зачем `uses: actions/checkout@v3`?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Клонировать repo на runner.**

Runner = clean VM (нет твоего кода!). Нужно сначала checkout.

```yaml
steps:
  - uses: actions/checkout@v3  # Clone repo
  - run: ls                    # Now you see your files
```

Без checkout:
```yaml
steps:
  - run: ./script.sh  # ❌ FAIL: script.sh not found
```

**LILITH:** *"Runner — это чистый лист. Checkout — это принести свои заметки."*

</details>

---

## ЦИКЛ 3: Automated Testing — Инспектор качества 🔍
### (10-15 минут)

### 🎬 Сюжет: Tests catch bugs

**13:15 — Hans демонстрирует test failure**

Hans делает намеренную ошибку в коде:

```python
# app.py (broken code)
def calculate_total(items):
    return sum(item.price for item in items) * 0  # BUG: multiplying by 0!
```

```bash
git add app.py
git commit -m "feat: calculate total"
git push
```

GitHub Actions: **Tests FAIL** ❌

```
test_calculate_total ... FAILED
Expected: 100, Got: 0
```

**Hans:**
> *"Tests нашли bug до production. Без тестов? Bug доходит до клиентов. Automated testing — это quality control inspector."*

**LILITH:**
> *"Tests — это инспектор на фабрике. Проверяет каждую деталь перед отправкой клиенту. Бракованную деталь отклоняет. В CI/CD: tests fail → deployment stops."*

---

### 📚 Теория: Test Pyramid

```
         ▲
        ╱ ╲
       ╱ E2E╲          E2E (End-to-End): Slow, expensive
      ╱─────╲          • Full application
     ╱       ╲         • Browser automation
    ╱Integration╲      • Few tests
   ╱───────────╲
  ╱             ╲      Integration: Medium speed
 ╱    Unit       ╲     • Multiple components
╱─────────────────╲    • Database, API calls
                        • Moderate number

                        Unit: Fast, cheap
                        • Single function
                        • No dependencies
                        • Many tests
```

**Test pyramid principle:**

1. **Unit tests (base):** MANY (100s), FAST (seconds), CHEAP
2. **Integration tests (middle):** SOME (10s), MEDIUM (minutes), MODERATE
3. **E2E tests (top):** FEW (5-10), SLOW (hours), EXPENSIVE

**Why pyramid shape?**

- Unit tests: Fast feedback (catch most bugs)
- Integration tests: Verify components work together
- E2E tests: Verify full user journey

**Hans:**
> *"Хочешь 100% E2E tests? Tests будут running 10 hours. Practical CI/CD: 80% unit, 15% integration, 5% E2E."*

---

### 💡 "Aha!" момент: Test Coverage ≠ Bug-Free

**Common misconception:**
> "100% test coverage → No bugs!"

**Reality:**
```python
# Code with 100% coverage, still has bug!
def divide(a, b):
    return a / b  # No zero check!

# Test (covers 100% of lines)
def test_divide():
    assert divide(10, 2) == 5  # ✅ Passes

# But this breaks in production:
divide(10, 0)  # 💥 ZeroDivisionError!
```

**Test coverage measures** = which lines executed
**Test coverage DOESN'T measure** = which scenarios tested

**Better approach:**

```python
def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b

# Tests for edge cases
def test_divide_normal():
    assert divide(10, 2) == 5

def test_divide_by_zero():
    with pytest.raises(ValueError):
        divide(10, 0)  # Test the error case!
```

**LILITH:**
> *"100% coverage — это как проверить что все комнаты в доме посещены. Но это не значит что в комнатах нет проблем. Test quality > test quantity."*

---

### 💻 Практика 3: Add Automated Tests

```yaml
# .github/workflows/ci.yml
name: CI with Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      # Unit tests (fast)
      - name: Run unit tests
        run: |
          echo "Running unit tests..."
          ./tests/unit_tests.sh
      
      # Integration tests (medium)
      - name: Run integration tests
        run: |
          echo "Running integration tests..."
          ./tests/integration_tests.sh
      
      # Linting (style check)
      - name: Lint code
        run: |
          shellcheck scripts/*.sh || true
      
      # Security scan
      - name: Security scan
        run: |
          trivy filesystem . || true
      
      # Test coverage report
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage.xml
```

---

### 🤔 Проверка понимания: Цикл 3

**Вопрос 1:** Почему unit tests в base of pyramid?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Fast + Cheap + Catch most bugs.**

- **Unit tests:** Test single function, no dependencies → fast (milliseconds)
- **Integration tests:** Test multiple components → slower (seconds/minutes)
- **E2E tests:** Test full app + browser → very slow (minutes/hours)

**Fast tests = fast feedback.**

CI/CD нужно быстро: commit → test → deploy (5-10 minutes total).
Если тесты running 2 hours → CI/CD бесполезен.

**Hans:** *"Unit tests — это 80% bug detection за 20% времени. Pareto principle."*

</details>

**Вопрос 2:** 100% test coverage гарантирует нет bugs?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **НЕТ!**

Coverage = which lines executed (quantity)
Quality = which scenarios tested (quality)

Можно иметь 100% coverage но не тестировать edge cases:
- Division by zero
- Null/empty inputs
- Large numbers (overflow)
- Special characters
- Network failures

**LILITH:** *"Coverage показывает ГДЕ тесты есть. Не показывает ХОРОШИ ЛИ тесты. Можно проверить все комнаты, но не заметить пожар."*

</details>

---

## ЦИКЛ 4: Docker Registry — Склад готовых изделий 📦
### (10-15 минут)

### 🎬 Сюжет: Build Once, Deploy Many

**14:00 — Hans показывает Docker Registry**

```bash
# Build image locally
docker build -t myapp:v1.0 .

# Push to registry
docker push registry.io/operation-shadow/myapp:v1.0

# Now deploy to 50 servers
for server in $(cat servers.txt); do
  ssh $server "docker pull registry.io/operation-shadow/myapp:v1.0 && docker-compose up -d"
done
```

**Hans:**
> *"Build once, deploy many. Image в registry — это product на складе. 50 servers просто берут с склада. Не пересобирают каждый раз."*

**LILITH:**
> *"Registry — это Amazon warehouse для Docker images. Собрал product (image) → положил на склад (registry) → 50 магазинов (servers) заказывают с склада."*

---

### 📚 Теория: Docker Registry Integration

**Docker registries:**

1. **Docker Hub** (public, free tier)
   ```bash
   docker push username/image:tag
   ```

2. **GitHub Container Registry** (integrated with GitHub)
   ```bash
   docker push ghcr.io/username/image:tag
   ```

3. **Private registry** (self-hosted)
   ```bash
   docker run -d -p 5000:5000 registry:2
   docker push localhost:5000/image:tag
   ```

4. **Cloud registries** (AWS ECR, Azure ACR, Google GCR)

---

### 💡 Метафора: Registry = Warehouse

```
🏭 Factory (CI/CD)
    │
    ├─ Build product (Docker image)
    │
    ▼
📦 Warehouse (Docker Registry)
    │
    ├─ Store inventory (tagged images)
    │
    ▼
🏪 Stores (Servers)
    │
    └─ Pull from warehouse (docker pull)
```

**Why registry?**

✅ **Build once:** No need to rebuild on every server
✅ **Consistent:** Same image everywhere
✅ **Fast:** Pull is faster than build
✅ **Versioned:** Tag images (v1.0, v1.1, v2.0)
✅ **Rollback:** Keep old versions for rollback

**Without registry:**

```bash
# 😱 Bad: Build on every server (slow, inconsistent)
for server in servers; do
  ssh $server "git clone repo && docker build -t app ."
done
# 50 servers × 5 min build = 250 minutes!
```

**With registry:**

```bash
# ✅ Good: Build once, pull everywhere (fast, consistent)
docker build -t app:v1.0 .
docker push registry/app:v1.0

for server in servers; do
  ssh $server "docker pull registry/app:v1.0"
done
# 5 min build + (50 servers × 30 sec pull) = 30 minutes total!
```

---

### 💻 Практика 4: CI/CD with Registry

```yaml
# .github/workflows/build-push.yml
name: Build and Push

on:
  push:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Log in to registry
        uses: docker/login-action@v2
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v4
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=sha
            type=semver,pattern={{version}}
            type=raw,value=latest,enable={{is_default_branch}}
      
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
```

**Hans:**
> *"Каждый commit → build → push to registry. Automatic versioning. Ready for deployment."*

---

### 🤔 Проверка понимания: Цикл 4

**Вопрос 1:** Почему build once, deploy many?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Speed + Consistency.**

**Build on every server:**
- 50 servers × 5 min build = 250 min
- Different build environments → inconsistent results
- Network issues during build → some servers fail

**Build once, push to registry, pull everywhere:**
- 1 build (5 min) + 50 pulls (30 sec each) = 30 min
- Same image everywhere → consistent
- Pull is idempotent → retry safe

**LILITH:** *"Зачем каждому магазину производить товар? Производишь на фабрике, магазины забирают со склада. Registry = склад."*

</details>

**Вопрос 2:** Зачем tag images (v1.0, v1.1, etc.)?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Versioning + Rollback.**

```bash
# Without tags (only latest)
docker push myapp:latest  # v1.0
# Deploy, works fine

docker push myapp:latest  # v2.0 (overwrites!)
# Deploy, BROKEN! 💥
# Rollback? No old version! 😱

# With tags
docker push myapp:v1.0
docker push myapp:v2.0

# Deploy v2.0, BROKEN!
# Rollback to v1.0:
docker pull myapp:v1.0 && docker-compose up -d  # ✅ Easy!
```

**Tags = time machine для images.**

**Hans:** *"Always tag. latest — это alias, не version. Real versions: v1.0, v1.1, v2.0."*

</details>

---

## ЦИКЛ 5: INCIDENT — Broken Deployment & Emergency Rollback 🔥
### (15-20 минут)

### 🎬 Сюжет: Production Down!

**15:30 — Calm before storm**

Max и Dmitry практикуют CI/CD. Несколько commits, pipelines зелёные. Всё работает отлично.

**Dmitry:**
> *"Hans, мы создали несколько features. Tests проходят. Staging работает. Deploying to production..."*

**15:45 — THE COMMIT**

Dmitry делает "minor fix" в database connection code:

```python
# database.py (looks innocent!)
def get_connection():
    # Changed from env var to hardcoded (for "simplicity")
    return psycopg2.connect("host=localhost dbname=app")
```

```bash
git add database.py
git commit -m "fix: simplify database connection"
git push origin main
```

**CI/CD Pipeline:**
- ✅ Tests pass (staging uses localhost DB)
- ✅ Build pass
- ✅ Staging deployment pass

**Dmitry (нажимает Approve для production):**
> *"All green. Deploying to production..."*

---

**15:47 — DISASTER** 🔥🚨

```
🚨 GRAFANA ALERT: HTTP 500 errors
0/min → 5000/min in 30 seconds

🚨 PROMETHEUS ALERT: All 50 production servers failing

🚨 SLACK ALERT: #incidents channel exploding
```

**Hans (мгновенно к мониторам):**
> *"SCHEISSE! Production DOWN! All 50 servers!"*

Grafana dashboard: сплошной красный. Prometheus metrics: HTTP 500 errors spike.

**Max (паника):**
> *"Что случилось?!"*

**Hans (быстро анализирует):**
> *"Database connection error! Production DB — не localhost! Staging = localhost. Production = db-cluster.vpc.internal. Ваш код assumes localhost!"*

**Dmitry (ужас):**
> *"Я сломал всю production?!"*

**Hans (спокойно, но срочно):**
> *"Ja. Теперь FIX. У вас 5 минут до звонка Viktor. ROLLBACK. NOW."*

**LILITH:**
> *"This is why we fear automation. One commit, one button click, 50 servers down. But also why we love automation: rollback in minutes, not hours."*

---

### 📚 Теория: Emergency Response Protocol

**Incident Response Timeline:**

```
15:47:00 — Incident detected (alerts fired)
15:47:30 — Team assembled (Hans, Max, Dmitry)
15:48:00 — Root cause identified (DB config)
15:49:00 — Rollback initiated
15:50:00 — Rollback complete, monitoring
15:52:00 — Service restored, alerts cleared
```

**Total downtime: 5 minutes** ⏱️

**Phases:**

1. **DETECT** (0-1 min): Alerts fired
2. **IDENTIFY** (1-2 min): Find broken deployment
3. **ROLLBACK** (2-4 min): Revert to working version
4. **VERIFY** (4-5 min): Check service restored
5. **POST-MORTEM** (later): Analyze what went wrong

---

### 💡 Emergency Rollback (15:47 - 15:52)

**Phase 1: IDENTIFY (15:47-15:48)**

```bash
# Check recent deployments
git log --oneline -5
# Output:
# a1b2c3d (HEAD) fix: simplify database connection  ← BROKEN
# e4f5g6h feat: add user dashboard                 ← LAST GOOD
# ...

# Check GitHub Actions
# Last successful: e4f5g6h
# Latest (broken): a1b2c3d
```

**Hans:**
> *"Target для rollback: commit e4f5g6h. Previous working version."*

---

**Phase 2: ROLLBACK (15:48-15:50)**

```bash
# Method 1: Redeploy previous image (FASTEST)
ROLLBACK_IMAGE="registry.io/app:e4f5g6h"

for server in $(cat production_servers.txt); do
  echo "Rolling back $server..."
  ssh $server "
    docker pull $ROLLBACK_IMAGE && \
    docker tag $ROLLBACK_IMAGE app:latest && \
    docker-compose up -d --force-recreate
  " &
done

wait  # Wait for all servers

echo "✅ Rollback complete"
```

**Hans (typing furiously):**
> *"Rollback script running... 50 servers..."*

---

**Phase 3: VERIFY (15:50-15:52)**

```bash
# Check Grafana
# HTTP 500 errors: 5000/min → 100/min → 10/min → 0/min

# Check application health
for server in $(cat production_servers.txt); do
  curl -f http://$server/health || echo "❌ $server still broken"
done

# All servers: ✅ Healthy
```

**15:52 — Resolution**

Grafana dashboard: зелёный. HTTP 500 errors: 0. Production восстановлен.

**Hans:**
> *"Production restored. Total downtime: 5 minutes. Acceptable."*

**Dmitry (облегчение):**
> *"5 минут... Мог быть час..."*

**Hans:**
> *"С automated rollback — 5 минут. Manual rollback? 30 минут минимум. Вот разница."*

---

**Phase 4: POST-MORTEM (after incident)**

**Root Cause:**

```python
# BROKEN CODE (committed):
def get_connection():
    return psycopg2.connect("host=localhost dbname=app")
    # ❌ Hardcoded localhost

# SHOULD BE:
def get_connection():
    db_host = os.getenv("DB_HOST", "localhost")
    return psycopg2.connect(f"host={db_host} dbname=app")
    # ✅ Environment-aware
```

**Why tests passed?**

- Staging: DB_HOST=localhost ✅
- Production: DB_HOST=db-cluster.vpc ❌
- Tests didn't catch environment difference!

**Hans:**
> *"Lesson learned:
> 1. **Staging MUST match production** (same env vars, same config)
> 2. **Tests MUST use production-like environment**
> 3. **ALWAYS have rollback plan**
> 4. **Monitor everything**"*

**Viktor (звонок через 2 минуты):**
> *"Hans, downtime detected. Status?"*

**Hans:**
> *"Resolved. 5 minutes downtime. Rollback successful. Post-mortem report ready."*

**Viktor:**
> *"5 minutes acceptable. But no more mistakes. Clients complaining."*

---

### 📖 Rollback Strategies

**1. Previous Image (FASTEST)**

```bash
# Redeploy last known good image
docker pull app:e4f5g6h
docker-compose up -d --force-recreate
```
⏱️ Time: 1-2 minutes

**2. Git Revert + Redeploy (SAFER)**

```bash
# Revert commit, trigger CI/CD
git revert a1b2c3d
git push origin main
# Wait for CI/CD pipeline...
```
⏱️ Time: 5-10 minutes

**3. Blue-Green Switch (INSTANT)**

```bash
# Switch load balancer to "green" environment
# (We'll learn this in Cycle 6)
```
⏱️ Time: < 30 seconds

---

### 💡 "Aha!" момент: Fast Rollback = Safety Net

**Without automated rollback:**

```
15:47 — Production down
15:50 — Team discusses what to do
16:00 — Manually SSH to servers
16:15 — Git checkout previous version
16:20 — Rebuild Docker images on each server
16:45 — Services gradually restored
Total: 58 minutes downtime 😱
```

**With automated rollback:**

```
15:47 — Production down
15:48 — Identify last good version
15:49 — Run rollback script
15:52 — All services restored
Total: 5 minutes downtime ✅
```

**LILITH:**
> *"Automated deployment делает mistakes fast. Но automated rollback делает recovery fast. Скорость ошибки = скорость исправления. CI/CD — это не только про deploy, но и про rollback."*

---

### 🤔 Проверка понимания: Цикл 5

**Вопрос 1:** Почему tests passed, но production broken?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Staging ≠ Production environment.**

```python
# Code assumes localhost
db = connect("host=localhost")

# Staging: ✅ DB actually IS localhost
# Production: ❌ DB is db-cluster.vpc (not localhost!)
```

**Tests проходят в staging environment:**
- Staging DB = localhost
- Code expects localhost
- Everything works!

**Breaks in production environment:**
- Production DB = db-cluster.vpc
- Code still expects localhost
- Connection fails!

**Fix:** Staging MUST be identical to production (env vars, config, infra).

**Hans:** *"Staging — это dress rehearsal. Если rehearsal отличается от show → show fails."*

</details>

**Вопрос 2:** Почему automated rollback лучше manual?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Speed + Reliability.**

**Manual rollback:**
- Human decides what to do (slow, stress)
- SSH to 50 servers manually (error-prone)
- Different commands on different servers (inconsistent)
- 30-60 minutes

**Automated rollback:**
- Script knows what to do (fast, tested)
- Parallel execution (all servers at once)
- Consistent commands (reliable)
- 3-5 minutes

**Downtime cost:**
- 5 min downtime: Acceptable
- 60 min downtime: Unacceptable (SLA violation, money lost)

**LILITH:** *"Panic + SSH + 50 servers = bad mix. Automation removes panic. Just run the script."*

</details>

**Вопрос 3:** Что важнее: prevent incidents или fast recovery?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **ОБА! Но recovery critical.**

**Prevention (important):**
- Good tests
- Staging = production
- Code reviews
- Gradual rollouts

**Recovery (CRITICAL):**
- Automated rollback
- Monitoring/alerts
- Incident response plan
- Post-mortem process

**Reality:** Incidents WILL happen. Perfect prevention impossible.

**Hans:**
> *"Немецкая поговорка: 'Hoffen auf das Beste, vorbereiten auf das Schlimmste.' Hope for the best, prepare for the worst. Prevention = hope. Recovery = preparation."*

**LILITH:**
> *"Prevention reduces frequency. Recovery reduces impact. Incident 1 time/month с 5 min downtime лучше чем incident 1 time/year с 6 hours downtime."*

</details>

**Hans (after incident resolved):**
> *"Вы пережили свой первый production incident. Congratulations! Теперь вы знаете: автоматизация — это power. Но с power comes responsibility. Далее — advanced deployment strategies."*

---

## ЦИКЛ 6: Blue-Green Deployment — Две дороги 🛣️
### (15-20 минут)

### 🎬 Сюжет: Zero-Downtime Upgrades

**16:15 — Hans показывает Blue-Green**

**Hans:**
> *"После incident вы поняли: rollback важен. Но есть лучший способ — blue-green deployment. Zero downtime. Instant rollback."*

(Hans рисует схему на whiteboard)

```
Load Balancer
    ├─→ BLUE environment (v1.0) — ACTIVE (100% traffic)
    └─→ GREEN environment (idle)

Deploy v2.0 to GREEN:
Load Balancer
    ├─→ BLUE environment (v1.0) — ACTIVE (100% traffic)
    └─→ GREEN environment (v2.0) — ready, testing

Switch traffic to GREEN:
Load Balancer
    ├─→ BLUE environment (v1.0) — idle (0% traffic)
    └─→ GREEN environment (v2.0) — ACTIVE (100% traffic)

If problem? Switch back to BLUE instantly!
```

**Max:**
> *"Как две дороги. Одна активна, другая в резерве."*

**Hans:**
> *"Ja! Two roads. Traffic flows on one. Build new road. When ready, redirect traffic. Old road still exists for rollback."*

**LILITH:**
> *"Blue-green — это как иметь spare tire. Большинство времени не нужен. Но когда нужен — бесценен. Instant switch."*

---

### 📚 Теория: Blue-Green Deployment

**Traditional deployment (downtime):**

```
16:00 — Stop old version
16:05 — Deploy new version  ← 5 minutes DOWNTIME
16:10 — Start new version
```

**Blue-Green deployment (zero downtime):**

```
16:00 — Deploy to GREEN (BLUE still running)
16:05 — Test GREEN (BLUE still serving traffic)
16:10 — Switch load balancer BLUE→GREEN  ← < 1 second switch
16:10 — GREEN active, BLUE idle (instant rollback available)
```

---

### 💡 Метафора: Two Lanes Highway

```
🛣️ Two-lane highway

┌────────────────────────────────────┐
│  LANE 1 (BLUE) ← 🚗🚗🚗 (traffic)  │
│  LANE 2 (GREEN) (empty)             │
└────────────────────────────────────┘

Upgrade LANE 2:
┌────────────────────────────────────┐
│  LANE 1 (BLUE) ← 🚗🚗🚗 (traffic)  │
│  LANE 2 (GREEN) ✨ (upgraded)       │
└────────────────────────────────────┘

Switch traffic to LANE 2:
┌────────────────────────────────────┐
│  LANE 1 (BLUE) (empty)              │
│  LANE 2 (GREEN) ← 🚗🚗🚗 (traffic)  │
└────────────────────────────────────┘

Problem? Switch back instantly!
```

**Benefits:**

✅ **Zero downtime:** Traffic never stops
✅ **Instant rollback:** Switch back to BLUE
✅ **Testing in production:** Test GREEN with real traffic (canary)
✅ **Easy rollback:** BLUE environment preserved

---

### 💻 Практика 6: Blue-Green with Docker Compose

```yaml
# docker-compose-blue.yml
version: '3.8'
services:
  web-blue:
    image: app:v1.0
    container_name: web-blue
    ports:
      - "8001:80"  # Blue on port 8001

# docker-compose-green.yml
version: '3.8'
services:
  web-green:
    image: app:v2.0
    container_name: web-green
    ports:
      - "8002:80"  # Green on port 8002

# nginx.conf (load balancer)
upstream backend {
    # Active environment
    server localhost:8001;  # BLUE active
    # server localhost:8002;  # GREEN (comment out)
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}
```

**Deployment script:**

```bash
#!/bin/bash
# blue_green_deploy.sh

CURRENT=$(cat /etc/nginx/active_env.txt)  # "blue" or "green"

if [ "$CURRENT" == "blue" ]; then
    NEW="green"
    NEW_PORT=8002
else
    NEW="blue"
    NEW_PORT=8001
fi

echo "Current: $CURRENT, deploying to: $NEW"

# 1. Deploy to inactive environment
docker-compose -f docker-compose-$NEW.yml up -d

# 2. Health check
sleep 5
curl -f http://localhost:$NEW_PORT/health || { echo "Health check failed!"; exit 1; }

# 3. Switch nginx to NEW environment
sed -i "s/server localhost:[0-9]*/server localhost:$NEW_PORT/" /etc/nginx/nginx.conf
nginx -s reload

# 4. Update active environment marker
echo "$NEW" > /etc/nginx/active_env.txt

echo "✅ Switched to $NEW environment"
```

---

### 🤔 Проверка понимания: Цикл 6

**Вопрос 1:** Почему blue-green = zero downtime?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Both environments running, instant switch.**

**Traditional:**
```
Stop old → 5 min downtime → Start new
```

**Blue-Green:**
```
BLUE running → Deploy GREEN → Both running → Switch (instant) → GREEN running
```

**Switch = change load balancer config (< 1 second).**

No stop-start cycle = no downtime.

**Hans:** *"Like changing train tracks. Train doesn't stop, just changes direction."*

</details>

**Вопрос 2:** Что если GREEN broken after switch?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Instant rollback to BLUE.**

```bash
# GREEN broken after switch
# BLUE still running (idle)

# Rollback (change load balancer):
sed -i "s/server localhost:8002/server localhost:8001/" /etc/nginx/nginx.conf
nginx -s reload

# < 1 second rollback!
```

**BLUE environment preserved** → instant fallback.

**LILITH:** *"Blue-green — это паранойя в хорошем смысле. Always have Plan B ready."*

</details>

---

## ЦИКЛ 7: Monitoring & Observability — Глаза на производстве 👁️
### (10-15 минут)

### 🎬 Сюжет: Hans's Monitoring Setup

**17:00 — Monitoring War Room**

Hans показывает стену мониторов: Grafana dashboards, Prometheus metrics, alert channels.

**Hans:**
> *"После incident сегодня вы поняли: monitoring = early warning system. Видишь проблему рано → исправляешь быстро. Не видишь → узнаёшь от angry clients."*

(Hans указывает на dashboards)

**Hans:**
> *"Три вопроса для monitoring:
> 1. **Is it working?** (uptime, health checks)
> 2. **Is it fast?** (response time, latency)
> 3. **Is it correct?** (error rates, business metrics)
>
> Отвечаешь на все три → observability."*

**LILITH:**
> *"Monitoring — это глаза на production. Без глаз — слепой. Слепой системный администратор = unemployed системный администратор."*

---

### 📚 Теория: Observability Pillars

**Three pillars:**

1. **Metrics** (numbers)
   - CPU, RAM, disk usage
   - Request rate, error rate
   - Response time

2. **Logs** (events)
   - Application logs
   - Error stack traces
   - Audit trails

3. **Traces** (journeys)
   - Request path through system
   - Which services called
   - Where time spent

---

### 💡 Метафора: Car Dashboard

```
🚗 Car Dashboard (Observability)

┌─────────────────────────────────┐
│  🔧 Engine health   (Metrics)   │
│     Speed, RPM, fuel            │
│                                  │
│  📋 Warning lights  (Logs)      │
│     Check engine, low oil       │
│                                  │
│  🗺️  GPS route      (Traces)    │
│     Where you've been           │
└─────────────────────────────────┘
```

**Without dashboard:**
> "Engine light broken. Don't know car status. Breakdown surprise!"

**With dashboard:**
> "Engine temperature rising. Slow down before overheating."

**Same with servers:**

**Without monitoring:**
> "Server down. Didn't know. Clients angry."

**With monitoring:**
> "CPU at 90%. Add capacity before crash."

---

### 💻 Практика 7: Monitoring Integration

```yaml
# .github/workflows/deploy-with-monitoring.yml
name: Deploy with Monitoring

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy
        run: ./scripts/deploy.sh
      
      # Monitor deployment
      - name: Check health after deploy
        run: |
          sleep 10  # Wait for app to start
          
          # Health check
          curl -f https://production.example.com/health || exit 1
      
      - name: Check metrics spike
        run: |
          # Query Prometheus for error rate
          ERROR_RATE=$(curl -s 'http://prometheus:9090/api/v1/query?query=rate(http_errors_total[1m])' | jq '.data.result[0].value[1]')
          
          if (( $(echo "$ERROR_RATE > 0.05" | bc -l) )); then
            echo "❌ Error rate too high after deployment!"
            exit 1
          fi
      
      - name: Notify success
        if: success()
        run: |
          curl -X POST https://hooks.slack.com/... \
            -d '{"text":"✅ Deployment successful, metrics healthy"}'
      
      - name: Notify failure
        if: failure()
        run: |
          curl -X POST https://hooks.slack.com/... \
            -d '{"text":"🚨 Deployment failed or metrics unhealthy! Investigate!"}'
```

---

### 📖 Essential Metrics

**RED Method** (for services):

1. **Rate:** Requests per second
2. **Errors:** Error percentage
3. **Duration:** Response time

```prometheus
# Prometheus queries
rate(http_requests_total[5m])              # Request rate
rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m])  # Error rate
histogram_quantile(0.95, http_request_duration_seconds)  # 95th percentile latency
```

**USE Method** (for resources):

1. **Utilization:** % time resource busy
2. **Saturation:** Queue depth
3. **Errors:** Error count

```prometheus
# CPU utilization
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage
node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100
```

---

### 🤔 Проверка понимания: Цикл 7

**Вопрос 1:** Почему metrics, logs И traces — все три нужны?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Different questions, different tools.**

**Metrics:** "WHAT is happening?"
- CPU 90%, error rate 5%, latency 500ms
- Aggregate numbers, trends

**Logs:** "WHY is it happening?"
- "Database connection timeout at 15:47:23"
- Specific events, debugging

**Traces:** "WHERE is the problem?"
- Request: API → Database → slow query (800ms)
- End-to-end journey

**All three together = full picture.**

**Hans:** *"Metrics tell you fire exists. Logs tell you what's burning. Traces tell you where fire started."*

</details>

**Вопрос 2:** Когда alerts should fire?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Early enough to act, not too noisy.**

**❌ Too sensitive:**
```
CPU > 50% → ALERT  # Too many alerts, ignored
```

**❌ Too late:**
```
CPU > 99% → ALERT  # Too late, already crashed
```

**✅ Just right:**
```
CPU > 80% for 5 minutes → ALERT  # Time to act
```

**Alert fatigue:** Too many alerts → ignored → real problem missed.

**LILITH:** *"Alerts — как автомобильная сигнализация. Слишком чувствительна (срабатывает от ветра) → игнорируешь. Слишком поздно (только когда машина уже украдена) → бесполезна. Balance."*

</details>

---

## 📁 Структура файлов

```
episode-15-cicd-pipelines/
├── README.md                        # Теория + micro-cycles (этот файл)
├── artifacts/
│   └── README.md                    # Тестовые данные
│
├── starter/                         # 🎯 НАЧНИ ЗДЕСЬ!
│   ├── .github/
│   │   └── workflows/
│   │       ├── ci.yml               # Basic CI workflow с TODO
│   │       └── cd.yml               # Deployment workflow с TODO
│   ├── scripts/
│   │   ├── deploy.sh                # Deployment script
│   │   ├── rollback.sh              # Rollback script
│   │   └── blue_green_deploy.sh    # Blue-green deployment
│   ├── configs/
│   │   └── nginx.conf               # Load balancer config
│   └── README.md                    # Workflow instructions
│
├── solution/                        # Референсное решение
│   ├── .github/workflows/
│   ├── scripts/
│   ├── configs/
│   └── README.md
│
└── tests/
    └── test.sh                      # Автотесты
```

**LILITH:** *"Type B episode. Ты пишешь GitHub Actions YAML workflows. Bash scripts — minimal wrappers для deploy/rollback. Real work = CI/CD configs."*

---

## 💬 Цитаты Episode 15

**Hans Müller:**
> "If it hurts, automate it. If it still hurts, you automated the wrong thing."

> "Автоматизация — это электроинструмент. Можешь построить дом за день. Или разрушить дом за секунду."

> "Automation быстро = failures быстро. Но recovery тоже быстро. Manual rollback? 30 минут. Automated? 5 минут."

> "Staging — это dress rehearsal. Если rehearsal отличается от show → show fails."

**LILITH:**
> "CI/CD — это конвейер для кода. Henry Ford для software delivery."

> "Tests — это quality inspector. Бракованная деталь не проходит."

> "Blue-green — это паранойя в хорошем смысле. Always have Plan B."

> "Monitoring — это глаза на production. Без глаз — слепой."

---

## 🎓 Что вы узнали

После Episode 15 вы умеете:

✅ Создавать GitHub Actions workflows (CI/CD)
✅ Автоматизировать testing (lint, unit, integration)
✅ Build и push Docker images автоматически
✅ Deploy to staging and production
✅ Implement rollback strategy
✅ Blue-green deployments (zero downtime)
✅ Emergency incident response (production down → rollback)
✅ Monitoring integration (Grafana, Prometheus)

**Key concepts:**
- **CI:** Continuous Integration (automated testing)
- **CD:** Continuous Delivery (manual prod deploy)
- **CD:** Continuous Deployment (fully automated)
- **Rollback:** Revert to previous working version
- **Blue-Green:** Two environments, instant switch
- **Observability:** Metrics + Logs + Traces

---

## 🏆 Финальная проверка

```bash
cd ~/kernel-shadows/season-4-devops-automation/episode-15-cicd-pipelines
./tests/test.sh
```

**Expected output:**
```
✅ GitHub Actions workflows created
✅ CI pipeline works (test, build)
✅ CD pipeline works (deploy)
✅ Rollback script exists and works
✅ Blue-green deployment configured
✅ Monitoring integration present

ALL TESTS PASSED! 🎉

Hans would be proud. Welcome to automation!
```

---

## 🚀 Следующий шаг

**Episode 16: Ansible & Infrastructure as Code** (Berlin/Amsterdam)

**Klaus Schmidt (from Tempelhof datacenter):**
> *"Max, Dmitry. CI/CD готов. Теперь массовая автоматизация. Ansible playbooks: 50 servers, одна команда, полная конфигурация. Season 4 финал. Увидимся завтра. — Klaus"*

**Hans:**
> *"Remember today's lesson: automate carefully. Test thoroughly. Monitor constantly. Rollback ready. Ansible amplifies this ×10. Good luck."*

---

<div align="center">

**Episode 15: CI/CD Pipelines — COMPLETE!**

*"If it hurts, automate it."*

🇩🇪 Berlin • Chaos Computer Club • Hans Müller • DevOps Philosophy

[⬅️ Episode 14: Docker](../episode-14-docker-basics/README.md) | [⬆️ Season 4 Overview](../README.md) | [➡️ Episode 16: Ansible](../episode-16-ansible-iac/README.md)

</div>


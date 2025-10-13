# EPISODE 26: MONITORING & OBSERVABILITY
**Season 7: Production & Advanced Topics** | Рейкьявик, Исландия 🇮🇸

> *"Without monitoring — you are blind. With bad monitoring — you are blind with false confidence. Good monitoring shows truth: what works, what breaks, what matters."* — Guðrún Ásta

---

## 📋 ИНФОРМАЦИЯ ОБ ЭПИЗОДЕ

- **Локация:** Рейкьявик, Verne Global Datacenter (monitoring center)
- **Дни операции:** 51-52 из 60
- **Время прохождения:** 5-6 часов
- **Сложность:** ⭐⭐⭐⭐☆
- **Тип:** Type B (Configuration — Prometheus + Grafana, minimal bash)

**Персонажи:**
- **Макс Соколов** — главный герой (вы), 49 дней операции позади
- **Виктор Петров** — координатор операции
- **Guðrún Ásta** — Monitoring engineer, ex-DataDog, observability expert
- **Björn Sigurdsson** — Kubernetes SRE (консультант)
- **LILITH v7.0** — AI-помощник (Production Mode)

**Цель эпизода:** Настроить production monitoring для Kubernetes infrastructure (Prometheus + Grafana + Alertmanager)

---

## 🎬 PROLOGUE: БЕЗ ГЛАЗ — СЛЕПОЙ

### День 51, 09:00 — Verne Global Monitoring Center

Макс входит в monitoring center. Стена из мониторов: графики CPU, Memory, Network, Kubernetes pods. Real-time dashboards мигают зелёным и жёлтым. В центре комнаты стоит женщина с рыжими волосами, смотрит на графики.

**Guðrún:** "Welcome. I'm Guðrún Ásta. Monitoring engineer. Ex-DataDog, now here. Björn told me about you — Kubernetes deployed, pods running, services exposed. Good. But question: how you know it works?"

**Макс:** "Я могу проверить — kubectl get pods, всё Running."

**Guðrún:** "Manual check. Every 5 minutes you run command? What if pod crashes at night? What if CPU 90% but still Running? What if memory leak grows slowly for 3 days?"

*[Guðrún кликает мышкой — на экране появляется Grafana dashboard с 20 графиками]*

**Guðrún:** "This is production monitoring. Not 'kubectl get pods' every hour. Real-time metrics. Every second. CPU, memory, disk, network, HTTP requests, database queries, cache hit rate. Everything. And when something wrong — alert fires. SMS, email, Slack. Before users notice problem."

**Макс:** "Впечатляюще. Сколько времени это настраивать?"

**Guðrún:** "For simple setup — 2 hours. For production-ready — 2 days. Today you learn basics: Prometheus collects metrics. Grafana visualizes. Alertmanager sends alerts. Tomorrow you have eyes."

**LILITH:** "Макс, Episode 25 дал тебе Kubernetes. Episode 26 — глаза для Kubernetes. Without monitoring — система работает, но ты не знаешь как долго. With monitoring — ты видишь всё: health, performance, trends, anomalies. Production требует visibility."

---

## 🔄 ЦИКЛ 1: WHY MONITORING? (10 минут)

### 🎬 Сюжет (2 мин)

**Guðrún:** "Before we start — I tell story. DataDog, 2019. Customer runs e-commerce. Black Friday. 10x traffic. Everything looks good — 'kubectl get pods' shows all Running. Then — users report: checkout не работает. We investigate. Problem: memory leak in payment service. Pod Running, but service dead inside. Took 2 hours to find. Lost $500,000 revenue."

**Guðrún:** "If monitoring existed? Alert fires: 'Payment service response time > 5 seconds.' We investigate immediately. Fix in 10 minutes. Save $500,000. This is why monitoring matters."

**Макс:** "Значит мониторинг — это not just 'смотреть графики', а 'знать о проблемах раньше пользователей'?"

**Guðrún:** "Exactly. Monitoring is early warning system. Problems always happen. Question is: who notices first — you or users? If you — fix before impact. If users — reputation damage, money loss, trust broken."

### 📚 Теория: Observability Triangle (5-7 мин)

**Метафора: Monitoring = Датчики в автомобиле**

Представь машину без dashboard:
- **Скорость?** Неизвестно (смотришь на пейзаж за окном)
- **Топливо?** Неизвестно (пока не заглохла)
- **Температура двигателя?** Неизвестно (пока дым не пошёл)

Машина работает, но ты слепой. Один датчик сломался — ты не узнаешь пока не поздно.

**Production система = та же машина.** Без мониторинга:
- CPU 100%? Узнаешь когда система виснет
- Memory leak? Узнаешь когда OOMKilled
- Disk 95% full? Узнаешь когда запись fails

**Observability Triangle** (3 столпа monitoring):

```
         📊 METRICS
        (Prometheus)
       /            \
      /              \
     /                \
    /                  \
   /                    \
📝 LOGS          🔍 TRACES
(Loki/ELK)      (Jaeger)
```

**1. Metrics** (числовые данные):
- CPU usage: 45%
- Memory usage: 2.3 GB
- HTTP requests/sec: 1,240
- Response time: 150ms
- Error rate: 0.02%

**Когда использовать:** Trends, alerting, dashboards (Episode 26 фокус)

**2. Logs** (текстовые события):
- `2025-10-13 12:34:56 ERROR Database connection timeout`
- `2025-10-13 12:35:10 WARN Retry attempt 3/5`
- `2025-10-13 12:35:15 INFO Request processed successfully`

**Когда использовать:** Debugging, audit trails (уже изучено в Season 1-3)

**3. Traces** (request flow):
- Request path: API → Auth Service → Database → Cache → Response
- Each step timing: 10ms → 50ms → 200ms → 5ms → 15ms
- Bottleneck: Database (200ms)

**Когда использовать:** Performance debugging, microservices (advanced, beyond scope)

**Episode 26 фокус: Metrics** (Prometheus + Grafana)

---

### **Prometheus: Time-series database для metrics**

**Что это:**
- Open-source monitoring system (CNCF project, как Kubernetes)
- Собирает metrics через HTTP endpoints (scraping)
- Хранит как time-series data (timestamp + value)
- Поддерживает powerful query language (PromQL)

**Архитектура:**

```
┌─────────────────────────────────────────────────────────┐
│                   PROMETHEUS SERVER                      │
│  ┌──────────┐   ┌──────────┐   ┌──────────────┐        │
│  │ Retrieval│──→│Time-series│──→│  HTTP Server │        │
│  │ (scrape) │   │  Database │   │   (API)      │        │
│  └──────────┘   └──────────┘   └──────────────┘        │
│       ↓                                  ↑               │
│  ┌──────────────────────────────────────┘               │
│  │         ┌──────────────┐                             │
│  └────────→│ Alertmanager │ (alerts)                    │
│            └──────────────┘                             │
└─────────────────────────────────────────────────────────┘
         ↓                           ↑
    (scrape metrics)            (query metrics)
         ↓                           ↑
┌─────────────────┐          ┌──────────────┐
│  TARGETS        │          │   GRAFANA    │
│  - Kubernetes   │          │  (dashboards)│
│  - Node Exporter│          └──────────────┘
│  - Apps         │
└─────────────────┘
```

**Как работает:**

1. **Targets expose metrics:**
```
# Kubernetes pod exposes /metrics endpoint
http://my-app:8080/metrics

# Output (Prometheus format):
http_requests_total{method="GET",status="200"} 1523
http_requests_total{method="POST",status="201"} 342
memory_usage_bytes 2147483648
cpu_usage_seconds_total 456.78
```

2. **Prometheus scrapes targets** (pulls metrics every 15-30 seconds):
```yaml
scrape_configs:
  - job_name: 'kubernetes-pods'
    scrape_interval: 15s
    kubernetes_sd_configs:
      - role: pod
```

3. **Data stored as time-series:**
```
Metric: http_requests_total{method="GET"}
Timestamp 1: 1000 requests
Timestamp 2: 1050 requests (+50 in 15 sec)
Timestamp 3: 1120 requests (+70 in 15 sec)
...
```

4. **Query with PromQL:**
```promql
rate(http_requests_total[5m])  # Requests per second (5-min window)
```

5. **Alerting rules:**
```yaml
- alert: HighCPU
  expr: cpu_usage > 0.9
  for: 5m
  annotations:
    summary: "CPU usage > 90% for 5 minutes"
```

---

### **Grafana: Visualization для Prometheus**

**Что это:**
- Open-source dashboards and visualization
- Connects to Prometheus (and other data sources)
- Beautiful graphs, charts, tables
- Templating, variables, annotations

**Почему отдельно от Prometheus?**
- Prometheus = data collection & storage (backend)
- Grafana = visualization & exploration (frontend)
- Разделение concerns: Prometheus фокус на reliability, Grafana на UX

---

### **Alertmanager: Notifications для проблем**

**Что это:**
- Handles alerts от Prometheus
- Deduplication (same alert не отправляется 100 раз)
- Grouping (multiple related alerts → one notification)
- Routing (разные alerts → разные каналы)
- Silencing (временно отключить alerts)

**Alert flow:**
```
Prometheus detects: CPU > 90%
      ↓
Prometheus fires alert → Alertmanager
      ↓
Alertmanager processes:
  - Deduplicates (same alert already sent?)
  - Groups (CPU alert + Memory alert = "Server Issues")
  - Routes to channel (Slack/Email/PagerDuty)
      ↓
Notification sent → Team responds
```

---

**Best Practices:**

✅ **DO:**
- Monitor что важно (not everything)
- Set alerts на проблемы (not cosmetic issues)
- Use dashboards для exploration, alerts для action
- Define SLOs (Service Level Objectives) — target metrics

❌ **DON'T:**
- Alert на всё (alert fatigue → ignored alerts)
- Monitor metrics you don't understand
- Set alerts без runbooks (что делать когда alert fires?)
- Забывай про retention (metrics хранятся 15 дней default, настрой для production)

**Guðrún's wisdom:**
> "Good monitoring answers 3 questions: What is broken? Why is broken? What to do? Bad monitoring shows 1000 metrics but no answers. Focus on actionable insights, not vanity metrics."

**LILITH:**
> "Monitoring — это не просто 'смотреть графики и радоваться зелёным линиям'. Это система раннего предупреждения. CPU 80% — ещё не проблема. CPU 80% и растёт — проблема через 10 минут. Monitoring видит тренды, не только snapshots. Kubectl показывает 'сейчас'. Prometheus показывает 'что было, что будет'."

### 💻 Практика (3-5 мин)

**Задание 1: Понимание мониторинга**

Scenario: Production web app, 1000 req/sec.

Какие metrics важны для monitoring? (выбери 5 самых критичных)

<details>
<summary>💡 Думай перед проверкой</summary>

**Top 5 критичных метрик:**

1. **Request rate** (requests/sec)
   - Почему: Детектирует traffic spikes или drops
   - Alert: Если упал на 50% → возможно проблема

2. **Error rate** (%  HTTP 5xx errors)
   - Почему: Показывает broken functionality
   - Alert: Если > 1% → users affected

3. **Response time** (p95 latency)
   - Почему: User experience metric
   - Alert: Если > 500ms → slow для users

4. **CPU usage** (%)
   - Почему: Resource saturation indicator
   - Alert: Если > 90% → risk of crash

5. **Memory usage** (%)
   - Почему: Memory leaks detection
   - Alert: Если растёт continuously → OOMKilled soon

**Также полезны (но не top 5):**
- Disk I/O, Network bandwidth, Database connections, Cache hit rate

**Vanity metrics (не critical):**
- Total users count (интересно, но не для alerts)
- Number of features (не влияет на availability)

</details>

### 🤔 Вопрос LILITH (1 мин)

**LILITH:** "Kubernetes pod status: Running. CPU: 95%. Memory: 90%. Response time: 10 seconds (было 100ms). Kubectl показывает 'Running'. Проблема есть?"

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ:** **ДА, серьёзная проблема!**

**Почему:**
- Pod status = Running (контейнер жив)
- Но service degraded (response time 100x slower)
- CPU/Memory near saturation → bottleneck
- Users experiencing slowness (10 sec intolerable)

**kubectl limitations:**
- Показывает container status (alive/dead)
- НЕ показывает service health (fast/slow)
- НЕ показывает resource saturation
- НЕ показывает trends (ухудшается ли?)

**Monitoring видит:**
- Response time график: был 100ms, стал 10s (резкий скачок)
- CPU usage: постоянно 95% (saturation)
- Alert fires: "Response time > 1s for 5 minutes"

**Вывод:** kubectl говорит "всё работает". Monitoring говорит "работает, но плохо". Для production нужен monitoring, не только kubectl.

</details>

---

## 🔄 ЦИКЛ 2: PROMETHEUS ARCHITECTURE (12 минут)

### 🎬 Сюжет (2 мин)

**День 51, 10:30 — Prometheus installation начинается**

**Guðrún:** "First — understand how Prometheus works. Not magic. Simple design: pull metrics from targets, store in database, allow queries. Let me show architecture."

*[Guðrún рисует на whiteboard архитектуру Prometheus]*

**Guðrún:** "Prometheus = time-series database. Every metric — series of (timestamp, value) pairs. Example: CPU usage at 10:00 = 45%, at 10:01 = 47%, at 10:02 = 50%. Time-series. Prometheus stores millions of these."

**Макс:** "А откуда Prometheus получает metrics? Каждое приложение должно отправлять?"

**Guðrún:** "No. Prometheus **pulls** metrics (scraping model). Your application exposes /metrics endpoint. Prometheus regularly fetches it. This is different from push-based systems like StatsD. Pull = simpler, more reliable. Target down? Prometheus knows immediately — scrape fails."

### 📚 Теория: Prometheus Deep Dive (7-10 мин)

**Метафора: Prometheus = Врач с обходом палат**

Представь больницу:
- **Пациенты** = Targets (Kubernetes pods, servers)
- **Врач** = Prometheus (делает обход)
- **Измерения** = Metrics (температура, пульс, давление)
- **Карты пациентов** = Time-series database
- **Медсестра** = Alertmanager (вызывает врача если проблема)

Врач не ждёт пока пациенты позвонят. Он регулярно обходит палаты и измеряет показатели. Если что-то не так — сразу видит и реагирует.

---

### **Prometheus Components:**

#### 1. **Prometheus Server** (core):

```
┌────────────────────────────────────────────┐
│         PROMETHEUS SERVER                  │
│                                            │
│  ┌────────────┐      ┌─────────────────┐  │
│  │  Retrieval │─────→│ Time-series DB  │  │
│  │  (scraper) │      │   (TSDB)        │  │
│  └────────────┘      └─────────────────┘  │
│        ↓                      ↑            │
│  ┌────────────┐      ┌─────────────────┐  │
│  │  Service   │      │   HTTP Server   │  │
│  │ Discovery  │      │  (API + Web UI) │  │
│  └────────────┘      └─────────────────┘  │
│                                            │
│  ┌────────────────────────────────────┐   │
│  │    Rules Engine (alerts)           │   │
│  └────────────────────────────────────┘   │
└────────────────────────────────────────────┘
```

**Retrieval (scraper):**
- Pulls metrics from `/metrics` endpoints
- Default interval: 15s (configurable)
- Parallel scraping (hundreds of targets simultaneously)
- Timeout: 10s default

**Time-series DB (TSDB):**
- Compressed storage (1 byte per sample typical)
- Retention: 15 days default (configurable)
- Efficient для millions of time-series
- Stored on disk (persistent volume needed)

**HTTP Server:**
- Web UI: http://prometheus:9090
- API: http://prometheus:9090/api/v1/query
- Query PromQL interactively

**Rules Engine:**
- Recording rules (pre-compute expensive queries)
- Alerting rules (detect problems, send to Alertmanager)

---

#### 2. **Targets** (what Prometheus monitors):

**Types:**
- **Kubernetes resources:** pods, nodes, services
- **Exporters:** node_exporter (system metrics), blackbox_exporter (endpoint probes)
- **Applications:** your app with `/metrics` endpoint

**Metrics endpoint format (Prometheus exposition format):**

```
# HELP http_requests_total Total HTTP requests
# TYPE http_requests_total counter
http_requests_total{method="GET",status="200"} 1523
http_requests_total{method="GET",status="404"} 42
http_requests_total{method="POST",status="201"} 342

# HELP memory_usage_bytes Current memory usage
# TYPE memory_usage_bytes gauge
memory_usage_bytes 2147483648

# HELP http_request_duration_seconds HTTP request latency
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{le="0.1"} 500
http_request_duration_seconds_bucket{le="0.5"} 800
http_request_duration_seconds_bucket{le="1.0"} 950
http_request_duration_seconds_bucket{le="+Inf"} 1000
http_request_duration_seconds_sum 450.5
http_request_duration_seconds_count 1000
```

---

#### 3. **Service Discovery** (automatic target detection):

Вместо hardcoded IP addresses:

```yaml
# ❌ BAD: manual targets
scrape_configs:
  - job_name: 'my-app'
    static_configs:
      - targets: ['10.0.1.5:8080', '10.0.1.6:8080']
```

Используй service discovery:

```yaml
# ✅ GOOD: automatic discovery
scrape_configs:
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
```

Prometheus автоматически находит все pods с annotation `prometheus.io/scrape: "true"`.

**Supported service discovery:**
- Kubernetes (pods, services, nodes, endpoints)
- Consul, Eureka, Zookeeper
- AWS EC2, Azure, GCP
- File-based (JSON/YAML файл с targets)

---

#### 4. **Metric Types:**

**Counter** (only goes up):
```
http_requests_total 1000
# ...15 seconds later...
http_requests_total 1050  # +50 requests
```
Use cases: requests count, errors count, bytes sent

**Gauge** (can go up and down):
```
memory_usage_bytes 2147483648
# ...later...
memory_usage_bytes 2047483648  # decreased
```
Use cases: CPU %, memory usage, temperature, concurrent requests

**Histogram** (distribution of values):
```
http_request_duration_seconds_bucket{le="0.1"} 500   # 500 requests < 100ms
http_request_duration_seconds_bucket{le="0.5"} 800   # 800 requests < 500ms
http_request_duration_seconds_bucket{le="1.0"} 950   # 950 requests < 1s
```
Use cases: latency, request sizes

**Summary** (like histogram but client-side quantiles):
```
http_request_duration_seconds{quantile="0.5"} 0.15   # Median: 150ms
http_request_duration_seconds{quantile="0.95"} 0.45  # p95: 450ms
http_request_duration_seconds{quantile="0.99"} 0.80  # p99: 800ms
```
Use cases: latency percentiles

---

#### 5. **Labels** (dimensions для filtering):

Metrics с labels позволяют slice and dice data:

```promql
# Total requests:
sum(http_requests_total)

# Requests только GET:
sum(http_requests_total{method="GET"})

# Requests GET + status 200:
sum(http_requests_total{method="GET",status="200"})

# Requests by method (группировка):
sum by (method) (http_requests_total)
```

**Best practices для labels:**
- ✅ Low cardinality (method: GET/POST/PUT/DELETE — OK)
- ❌ High cardinality (user_id label — BAD! millions of users = millions of time-series)
- ✅ Filterable dimensions (status code, method, endpoint)
- ❌ Dynamic values (timestamps, UUIDs)

---

**Prometheus Configuration:**

`prometheus.yml` (main config file):

```yaml
global:
  scrape_interval: 15s       # How often to scrape targets
  evaluation_interval: 15s   # How often to evaluate rules
  scrape_timeout: 10s        # Scrape timeout

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets: ['alertmanager:9093']

# Load alerting rules
rule_files:
  - "alerts.yml"

# Scrape configurations
scrape_configs:
  # Job 1: Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Job 2: Kubernetes nodes
  - job_name: 'kubernetes-nodes'
    kubernetes_sd_configs:
      - role: node
    relabel_configs:
      - source_labels: [__address__]
        regex: '(.*):10250'
        replacement: '${1}:9100'
        target_label: __address__

  # Job 3: Kubernetes pods (auto-discovery)
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        target_label: __address__
```

---

**Guðrún's wisdom:**
> "Prometheus is pull-based for reason. Push systems — targets must know where to send. Pull — Prometheus controls scraping. Target down? Prometheus sees immediately (scrape fails). Target up? Prometheus discovers automatically. Simple, reliable, scalable."

**LILITH:**
> "Prometheus architecture — элегантная простота. Pull metrics, store time-series, query с PromQL. Не пытается быть всем для всех. Metrics only. Logs — Loki. Traces — Jaeger. Focused tool does one thing well. Unix philosophy в мире monitoring."

### 💻 Практика (3-5 мин)

**Задание 2: Metric types**

Match metric type to use case:

1. HTTP requests count → ?
2. Current memory usage → ?
3. Request latency distribution → ?
4. Current temperature → ?
5. Bytes transferred total → ?

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответы:**

1. **HTTP requests count** → **Counter**
   - Only increases (never decreases)
   - Use `rate()` to get requests/sec

2. **Current memory usage** → **Gauge**
   - Can go up and down
   - Use directly in queries

3. **Request latency distribution** → **Histogram**
   - Need percentiles (p50, p95, p99)
   - Shows distribution across buckets

4. **Current temperature** → **Gauge**
   - Can increase or decrease
   - Snapshot of current value

5. **Bytes transferred total** → **Counter**
   - Only increases
   - Use `rate()` to get bytes/sec

**Правило большого пальца:**
- Counting events → Counter
- Measuring current value → Gauge
- Measuring distribution → Histogram/Summary

</details>

### 🤔 Вопрос LILITH (1 мин)

**LILITH:** "Почему Prometheus использует pull model (scraping), а не push model (targets отправляют metrics)?"

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответы (3 главных причины):**

**1. Failure detection:**
- **Pull:** Scrape fails → Prometheus сразу знает target down
- **Push:** Target down → просто нет данных (может быть network issue или target dead, неясно)

**2. Centralized control:**
- **Pull:** Prometheus контролирует scraping (interval, timeout, targets)
- **Push:** Targets контролируют (могут overwhelm collector, DDoS risk)

**3. Service discovery:**
- **Pull:** Prometheus автоматически находит targets (Kubernetes service discovery)
- **Push:** Targets должны знать куда отправлять (configuration propagation problem)

**4. Debugging (bonus):**
- **Pull:** Можно вручную curl target `/metrics` endpoint для проверки
- **Push:** Нужен доступ к target для debugging

**Когда push лучше:**
- Short-lived jobs (batch jobs, serverless) — используй Pushgateway
- Firewall ограничения (target не доступен извне) — используй agent

**Вывод:** Pull = default choice для long-running services. Push = edge cases only.

</details>

---

## 🔄 ЦИКЛ 3: PROMETHEUS INSTALLATION (15 минут)

### 🎬 Сюжет (2 мин)

**День 51, 11:30 — Практика начинается**

**Guðrún:** "Theory enough. Time for practice. We deploy Prometheus on your Kubernetes cluster. I prepared manifests. But you apply them — learn by doing."

**Макс:** "Prometheus как обычный pod в Kubernetes?"

**Guðrún:** "Yes. StatefulSet for Prometheus (needs persistent storage for TSDB). ConfigMap для prometheus.yml. Service для access. Standard Kubernetes patterns. Prometheus designed for containerized environments from start."

**Guðrún:** "After deployment — Prometheus automatically discovers your Kubernetes pods, nodes, services. No manual configuration. Magic of service discovery."

### 📚 Теория: Prometheus на Kubernetes (7-10 мин)

**Deployment Options:**

#### Option 1: Prometheus Operator (recommended для production)
- CRDs: ServiceMonitor, PodMonitor, PrometheusRule
- Автоматическая конфигурация
- Сложнее для начала

#### Option 2: Helm Chart
- Быстрый старт
- Pre-configured для Kubernetes
- Используем для Episode 26

#### Option 3: Manual manifests (educational)
- Полный контроль
- Понимание каждого компонента

**Мы используем Helm** (баланс между простотой и production-readiness).

### Prometheus Stack Components:

```
┌──────────────────────────────────────────────┐
│         PROMETHEUS STACK                     │
│                                              │
│  ┌─────────────┐      ┌────────────────┐   │
│  │ Prometheus  │◄────→│  Alertmanager  │   │
│  │   Server    │      │                │   │
│  └─────────────┘      └────────────────┘   │
│         ↓                                    │
│  ┌─────────────┐      ┌────────────────┐   │
│  │   Grafana   │◄─────│  Prometheus    │   │
│  │ Dashboards  │      │ (data source)  │   │
│  └─────────────┘      └────────────────┘   │
│                                              │
│  ┌─────────────┐      ┌────────────────┐   │
│  │ node-       │      │  kube-state-   │   │
│  │ exporter    │      │  metrics       │   │
│  └─────────────┘      └────────────────┘   │
└──────────────────────────────────────────────┘
```

**Components:**

1. **Prometheus Server** — core (scraping, storage, queries)
2. **Alertmanager** — alert handling
3. **Grafana** — visualization
4. **node-exporter** — system metrics (CPU, Memory, Disk)
5. **kube-state-metrics** — Kubernetes state metrics (deployments, pods status)

### Installation Steps:

```bash
# 1. Add Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# 2. Create namespace
kubectl create namespace monitoring

# 3. Install Prometheus stack
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.retention=15d \
  --set grafana.adminPassword=admin

# 4. Verify installation
kubectl get pods -n monitoring
```

**Installed resources:**

```
NAME                                                     READY   STATUS
prometheus-prometheus-kube-prometheus-prometheus-0       2/2     Running
prometheus-grafana-xxxxx                                 3/3     Running
prometheus-kube-state-metrics-xxxxx                      1/1     Running
prometheus-prometheus-node-exporter-xxxxx                1/1     Running
alertmanager-prometheus-kube-prometheus-alertmanager-0   2/2     Running
prometheus-kube-prometheus-operator-xxxxx                1/1     Running
```

**Access URLs:**

```bash
# Prometheus UI
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
# Open: http://localhost:9090

# Grafana UI
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
# Open: http://localhost:3000
# Login: admin / admin

# Alertmanager UI
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-alertmanager 9093:9093
# Open: http://localhost:9093
```

**LILITH:**
> "Helm chart устанавливает всё за одну команду. Production-ready setup. Но понимай что внутри: Prometheus StatefulSet (persistent storage), ConfigMap (prometheus.yml), Service (exposure), ServiceAccount (RBAC permissions). Helm удобен, но не magic. Всё — Kubernetes resources."

### 💻 Практика (3-5 мин)

**Задание 3: Install Prometheus Stack**

```bash
# 1. Add Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# 2. Create monitoring namespace
kubectl create namespace monitoring

# 3. Install stack
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.retention=15d \
  --set grafana.adminPassword=admin123

# 4. Wait for pods ready
kubectl wait --for=condition=Ready pods --all -n monitoring --timeout=300s

# 5. Port-forward Prometheus
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090 &

# 6. Port-forward Grafana
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80 &

# 7. Open browser
echo "Prometheus: http://localhost:9090"
echo "Grafana: http://localhost:3000 (admin/admin123)"
```

### 🤔 Вопрос LILITH (1 мин)

**LILITH:** "Почему Prometheus использует StatefulSet, а не Deployment?"

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ:** **Persistent storage + stable identity.**

**StatefulSet provides:**
1. **Persistent Volume** — TSDB data сохраняется при restart
2. **Stable network identity** — prometheus-0 (не random pod name)
3. **Ordered deployment** — guaranteed startup order
4. **Controlled updates** — rolling update с контролем

**Почему важно:**
- Prometheus хранит time-series data на диске (retention 15 дней)
- Pod restart → data должна сохраниться (PersistentVolume)
- Deployment бы создал новый pod с empty disk (data loss!)

**Kubernetes patterns:**
- **Stateless apps** (nginx, API) → Deployment
- **Stateful apps** (databases, Prometheus) → StatefulSet

</details>

---

## 🔄 ЦИКЛ 4: PROMQL BASICS (12 минут)

### 🎬 Сюжет (2 мин)

**День 51, 13:00 — Prometheus UI**

**Guðrún:** "Prometheus installed. Now — query language. PromQL. Like SQL for metrics. You ask question — Prometheus answers with numbers."

*[Guðrún opens Prometheus UI: http://localhost:9090]*

**Guðrún:** "Simple query: `up`. Shows which targets are up (1) or down (0). Try it."

*[Макс вводит query]*

**Guðrún:** "Good. Now complex query: `rate(http_requests_total[5m])`. Shows requests per second over last 5 minutes. PromQL powerful but not intuitive. I teach you patterns."

### 📚 Теория: PromQL Query Language (6-8 мин)

**PromQL = SQL для time-series**

| SQL | PromQL |
|-----|--------|
| SELECT * FROM table | metric_name |
| WHERE status='200' | metric{status="200"} |
| COUNT(*) | sum(metric) |
| AVG(value) | avg(metric) |
| GROUP BY method | sum by (method) (metric) |

**Basic Queries:**

```promql
# 1. Instant vector (current value)
up  # Is target up? 1 = yes, 0 = no

# 2. Filter by labels
up{job="kubernetes-nodes"}  # Only nodes

# 3. Range vector (last 5 minutes)
http_requests_total[5m]  # All values from last 5m

# 4. Rate (per-second rate)
rate(http_requests_total[5m])  # Requests/sec

# 5. Sum aggregation
sum(rate(http_requests_total[5m]))  # Total req/sec

# 6. Group by label
sum by (method) (rate(http_requests_total[5m]))  # Per HTTP method
```

**Common Functions:**

```promql
# Rate (for counters)
rate(metric[5m])  # Per-second rate

# irate (instant rate, более responsive)
irate(metric[5m])  # Instant rate

# Increase (total increase)
increase(metric[5m])  # Total count increase

# Avg/Min/Max
avg(metric)
min(metric)
max(metric)

# Aggregations
sum(metric)          # Total
avg(metric)          # Average
count(metric)        # Count of time-series
topk(5, metric)      # Top 5 values
bottomk(3, metric)   # Bottom 3 values
```

**Example Queries для Kubernetes:**

```promql
# CPU usage per pod
sum by (pod) (rate(container_cpu_usage_seconds_total[5m]))

# Memory usage
container_memory_usage_bytes{namespace="shadow-ops"}

# Pod restarts
kube_pod_container_status_restarts_total

# HTTP request rate
rate(http_requests_total{status="200"}[5m])

# Error rate (%)
sum(rate(http_requests_total{status=~"5.."}[5m])) / 
sum(rate(http_requests_total[5m])) * 100
```

**LILITH:**
> "PromQL сначала кажется странным. rate([5m]), sum by (), {} vs []. Но логика простая: metric — что, {labels} — фильтр, [time] — окно, function — агрегация. Запомни patterns: rate для counters, {} для filter, by () для group. Остальное — практика."

### 💻 Практика (3 мин)

Open Prometheus UI (http://localhost:9090) and try:

```promql
# 1. Check targets status
up

# 2. CPU usage
rate(node_cpu_seconds_total[5m])

# 3. Memory usage
node_memory_MemAvailable_bytes

# 4. Kubernetes pods count
count(kube_pod_info)

# 5. Pod CPU by namespace
sum by (namespace) (rate(container_cpu_usage_seconds_total[5m]))
```

---

## 🔄 ЦИКЛ 5: GRAFANA DASHBOARDS (12 минут)

### 🎬 Сюжет (2 мин)

**День 51, 14:00 — Grafana UI**

**Guðrún:** "Prometheus queries work. But staring at numbers — not comfortable. Grafana — visualization. Graphs, charts, alerts. Beautiful dashboards. I show you."

*[Opens Grafana: http://localhost:3000, login: admin/admin123]*

**Guðrún:** "Pre-installed dashboards from kube-prometheus-stack. Kubernetes cluster overview, node metrics, pod resources. Everything out of box. But you learn to create custom dashboard. This is real skill."

### 📚 Теория: Grafana Dashboards (6-8 мин)

**Dashboard Structure:**
```
Dashboard (collection of panels)
  ├─ Row 1: System Overview
  │   ├─ Panel 1: CPU Usage (graph)
  │   └─ Panel 2: Memory Usage (graph)
  ├─ Row 2: Network
  │   ├─ Panel 3: Network Traffic (graph)
  │   └─ Panel 4: Connections (stat)
  └─ Row 3: Alerts
      └─ Panel 5: Alert list
```

**Panel Types:**
- **Graph:** Time-series line chart
- **Stat:** Single number with trend
- **Gauge:** Progress bar/gauge
- **Table:** Data in table format
- **Heatmap:** Density visualization
- **Alert list:** Active alerts

**Creating Dashboard:**

1. Add data source (Prometheus already configured)
2. Create dashboard
3. Add panel
4. Write PromQL query
5. Configure visualization
6. Save dashboard

**Example Panel — CPU Usage:**

```
Query: rate(node_cpu_seconds_total{mode!="idle"}[5m]) * 100
Legend: {{instance}} - {{mode}}
Unit: percent (0-100)
Visualization: Time series
```

**Variables (templating):**

```
Variable: $namespace
Query: label_values(kube_pod_info, namespace)
Usage in query: container_memory_usage_bytes{namespace="$namespace"}
```

Позволяет переключаться между namespaces в dropdown.

**LILITH:**
> "Grafana — Photoshop для метрик. PromQL даёт данные, Grafana делает их красивыми. Pre-built dashboards хороши для старта. Custom dashboards — для production. Фокусируй на actionable metrics: что broken? что bottleneck? не vanity metrics."

### 💻 Практика (3 мин)

**Задание: Create simple dashboard**

1. Open Grafana → Dashboards → New Dashboard
2. Add panel → Prometheus query:
   ```promql
   sum(rate(container_cpu_usage_seconds_total{namespace="shadow-ops"}[5m])) by (pod)
   ```
3. Panel title: "CPU Usage by Pod"
4. Visualization: Time series
5. Legend: {{pod}}
6. Save dashboard: "Shadow Ops Monitoring"

---

## 🔄 ЦИКЛ 6: ALERTMANAGER & ALERTING RULES (15 минут)

### 🎬 Сюжет (2 мин)

**День 51, 15:30 — Alert testing**

**Guðrún:** "Dashboards pretty. But you не можешь watch screens 24/7. Alerts — automatic notifications. Prometheus detects problem, Alertmanager sends alert. Email, Slack, PagerDuty. Whatever you need."

*[Guðrún показывает alert firing]*

**Guðrún:** "This alert: 'Pod не Ready more than 5 minutes'. Fires when problem. Resolves when fixed. Self-healing notifications. Production requires this."

### 📚 Теория: Alerting (7-10 мин)

**Alerting Rule Example:**

```yaml
# prometheus-rules.yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: shadow-ops-alerts
  namespace: monitoring
spec:
  groups:
  - name: shadow-ops
    interval: 30s
    rules:
    # Alert 1: High CPU
    - alert: HighCPU
      expr: sum by (pod) (rate(container_cpu_usage_seconds_total{namespace="shadow-ops"}[5m])) > 0.9
      for: 5m
      labels:
        severity: warning
      annotations:
        summary: "High CPU usage on pod {{ $labels.pod }}"
        description: "CPU usage > 90% for 5 minutes"
    
    # Alert 2: Pod not Ready
    - alert: PodNotReady
      expr: kube_pod_status_phase{namespace="shadow-ops",phase!="Running"} == 1
      for: 5m
      labels:
        severity: critical
      annotations:
        summary: "Pod {{ $labels.pod }} not Ready"
        description: "Pod in {{ $labels.phase }} phase for 5 minutes"
```

**Alert States:**
- **Inactive:** Condition false (no problem)
- **Pending:** Condition true, waiting `for` duration
- **Firing:** Condition true for `for` duration → alert sent

**Alertmanager Config:**

```yaml
# alertmanager-config.yaml
apiVersion: v1
kind: Secret
metadata:
  name: alertmanager-prometheus-kube-prometheus-alertmanager
  namespace: monitoring
stringData:
  alertmanager.yaml: |
    global:
      slack_api_url: 'https://hooks.slack.com/services/xxx'
    
    route:
      receiver: 'slack-notifications'
      group_by: ['alertname', 'cluster']
      group_wait: 30s
      group_interval: 5m
      repeat_interval: 4h
    
    receivers:
    - name: 'slack-notifications'
      slack_configs:
      - channel: '#alerts'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
```

**Best Practices:**
- ✅ Alert на symptoms (high latency) не causes (high CPU)
- ✅ Include runbooks в annotations
- ✅ Use severity levels (critical, warning, info)
- ✅ Group related alerts (не spam 100 alerts)
- ❌ Don't alert на everything (alert fatigue)

---

## 🔄 ЦИКЛ 7: KUBERNETES MONITORING (12 минут)

### 📚 Теория: Monitoring K8s (сокращённо)

**Key Metrics:**

```promql
# Cluster health
up{job="kubernetes-nodes"}

# Pod status
kube_pod_status_phase

# Resource usage
container_cpu_usage_seconds_total
container_memory_usage_bytes

# Deployment status
kube_deployment_status_replicas_available
```

**ServiceMonitor CRD** (auto-discovery):

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: shadow-web-monitor
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: shadow-web
  endpoints:
  - port: metrics
    interval: 30s
```

---

## 🔄 ЦИКЛ 8: TROUBLESHOOTING & BEST PRACTICES (12 минут)

### 📚 Теория: Common Issues (сокращённо)

**Issue 1: No Data in Grafana**
- Check: Prometheus targets (Status → Targets)
- Check: Prometheus data source в Grafana
- Check: PromQL query syntax

**Issue 2: Alert не fires**
- Check: Alerting rules loaded (Status → Rules)
- Check: Alert condition true (Graph → Expression)
- Check: `for` duration (pending → firing time)

**Issue 3: High Cardinality**
- Problem: Too many unique label combinations
- Symptom: Prometheus OOMKilled, slow queries
- Solution: Reduce labels (remove user_id, request_id)

**Best Practices:**
- ✅ Monitor SLIs (Service Level Indicators): latency, availability, error rate
- ✅ Define SLOs (Service Level Objectives): 99.9% uptime, p95 < 500ms
- ✅ Alert на SLO violations
- ✅ Use dashboards для exploration, alerts для action
- ✅ Retention: 15-30 days (longer = more storage)

---

## 📋 ПРАКТИЧЕСКИЕ ЗАДАНИЯ

### Задание 1: Install Prometheus Stack ✅ (выполнено в Цикле 3)

### Задание 2: Create Custom Dashboard

1. Login to Grafana
2. Create new dashboard
3. Add panels:
   - CPU usage by pod
   - Memory usage by pod
   - Network traffic
   - Pod status
4. Add variables: $namespace
5. Save dashboard

### Задание 3: Configure Alert Rule

Create `custom-alerts.yaml`:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: custom-alerts
  namespace: monitoring
spec:
  groups:
  - name: custom
    rules:
    - alert: HighMemory
      expr: container_memory_usage_bytes{namespace="shadow-ops"} / container_spec_memory_limit_bytes > 0.9
      for: 5m
      annotations:
        summary: "High memory usage"
```

Apply: `kubectl apply -f custom-alerts.yaml`

### Задание 4: Test Alert

1. Generate high CPU: `kubectl run stress --image=polinux/stress -- stress --cpu 4`
2. Wait 5 minutes
3. Check Alertmanager: http://localhost:9093
4. Verify alert fires
5. Delete stress pod: `kubectl delete pod stress`
6. Verify alert resolves

---

## 🎬 EPILOGUE: ГЛАЗА ОТКРЫТЫ

### День 52, 17:00 — Monitoring Dashboard

**Guðrún:** "Good work. Prometheus collects. Grafana visualizes. Alertmanager notifies. You have eyes now. Production infrastructure visible."

*[На мониторе: 10+ dashboards, all green, metrics flowing]*

**Guðrún:** "Before — kubectl get pods. Now — real-time visibility. CPU, memory, disk, network, HTTP requests, errors, latency. Everything. And when problem — alert fires before users notice."

**Макс:** "Мониторинг показывает не только 'что сломалось', но и 'что скоро сломается'. Тренды."

**Guðrún:** "Exactly. This is observability. Not just 'is it up?' but 'how is it performing?'. Production requires this. Without monitoring — you are blind. With monitoring — you see everything."

**Viktor** (видеозвонок): "Макс, Episode 26 complete. Monitoring активен. Prometheus scraping, Grafana dashboards, Alertmanager configured. Real-time visibility. Tomorrow — Episode 27. Ólafur teaches performance tuning. Monitoring shows problems. Performance tuning fixes them."

**LILITH:** "От слепого kubectl к полной observability. Prometheus видит каждую метрику. Grafana визуализирует тренды. Alertmanager предупреждает о проблемах. Production infrastructure готова к мониторингу. Episode 27 — оптимизация того что видишь."

---

## 📊 СТАТИСТИКА ЭПИЗОДА

**Что вы изучили:**
- ✅ Observability principles (metrics, logs, traces)
- ✅ Prometheus architecture (scraping, TSDB, PromQL)
- ✅ Prometheus installation (Helm chart, Kubernetes deployment)
- ✅ PromQL queries (rate, sum, aggregations)
- ✅ Grafana dashboards (panels, variables, visualization)
- ✅ Alertmanager (alerting rules, notifications)
- ✅ Kubernetes monitoring (ServiceMonitor, kube-state-metrics)
- ✅ Troubleshooting (no data, alert issues, high cardinality)

**Monitoring stack deployed:**
- 1 Prometheus Server (StatefulSet)
- 1 Grafana instance
- 1 Alertmanager
- N node-exporters (per node)
- 1 kube-state-metrics
- Custom dashboards + alert rules

**Time spent:** 5-6 hours  
**Complexity:** ⭐⭐⭐⭐☆  
**Production readiness:** 70% (monitoring active, needs alert tuning)

---

## 🔗 СЛЕДУЮЩИЙ ЭПИЗОД

**Episode 27: Performance Tuning**
- Performance profiling (perf, top, iostat)
- Kernel tuning (sysctl optimization)
- Database optimization (SQL queries, indexes)
- Caching strategies (Redis)
- **Персонаж:** Ólafur Þórsson (performance engineer)

**День 53 операции** — 7 дней до финала

---

<div align="center">

**"Without monitoring — you are blind. With monitoring — you have eyes."** — Guðrún Ásta

**EPISODE 26 COMPLETE** ✅

*День 52 из 60 | Рейкьявик, Исландия 🇮🇸 | Monitoring infrastructure active*

**Next:** Episode 27 — Performance Tuning ⚡

</div>
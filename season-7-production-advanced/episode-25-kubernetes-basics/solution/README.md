# Episode 25: Solution Files
**Kubernetes Basics** | Season 7: Production & Advanced Topics

⚠️ **SPOILER ALERT:** This directory contains complete solutions. Try solving yourself first!

## 📁 Files

### Kubernetes Manifests:
- `deployment.yaml` — Complete Deployment with health checks
- `service.yaml` — Complete Service (ClusterIP)
- `configmap.yaml` — Complete ConfigMap with full config
- `hpa.yaml` — (Optional) Horizontal Pod Autoscaler

### Scripts:
- `k8s_audit.sh` — Kubernetes audit script (Type B: kubectl collection)

## 🎯 How to Use

### Quick Deploy (all resources):

```bash
# 1. Create namespace
kubectl create namespace shadow-ops

# 2. Apply ConfigMap first (referenced by Deployment)
kubectl apply -f configmap.yaml

# 3. Create Secret
kubectl create secret generic shadow-secrets \
  --from-literal=db_password=supersecret123 \
  -n shadow-ops

# 4. Apply Deployment
kubectl apply -f deployment.yaml

# 5. Apply Service
kubectl apply -f service.yaml

# 6. (Optional) Apply HPA
kubectl apply -f hpa.yaml

# 7. Verify
kubectl get all -n shadow-ops
```

### Run Audit:

```bash
chmod +x k8s_audit.sh
./k8s_audit.sh

# View report
cat k8s_audit_report.txt
```

## 📊 Expected Output

### Successful deployment:

```
$ kubectl get all -n shadow-ops

NAME                              READY   STATUS    RESTARTS   AGE
pod/shadow-web-xxx-yyy            1/1     Running   0          2m
pod/shadow-web-xxx-zzz            1/1     Running   0          2m
pod/shadow-web-xxx-aaa            1/1     Running   0          2m

NAME                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/shadow-web-service   ClusterIP   10.43.xxx.xxx   <none>        80/TCP    2m

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/shadow-web   3/3     3            3           2m

NAME                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/shadow-web-xxxxxxxxxx   3         3         3       2m
```

### Audit report summary:

```
Resources in namespace 'shadow-ops':
  - Deployments: 1
  - Pods: 3 (Running: 3)
  - Services: 1
  - ConfigMaps: 1
  - Secrets: 1

Health Status:
  ✓ Cluster is healthy
  ✓ Pods are running
  ✓ Services are exposed

Björn Sigurdsson:
"Good work. Deployment running. Pods healthy. Service exposed..."

Status: ✓ EPISODE 25 COMPLETE
```

## 🔍 Key Features

### deployment.yaml:
- ✅ **3 replicas** for high availability
- ✅ **Resource limits** (CPU 500m, Memory 256Mi)
- ✅ **Health checks** (liveness + readiness probes)
- ✅ **Rolling update strategy** (maxUnavailable: 1, maxSurge: 1)
- ✅ **Environment variables** from ConfigMap and Secret

### service.yaml:
- ✅ **ClusterIP** type (internal service)
- ✅ **Selector** matches Deployment labels
- ✅ **Port mapping** (80 → 80)

### configmap.yaml:
- ✅ **Complete configuration** (API, logging, app settings)
- ✅ **Environment variables** for all components

### hpa.yaml (optional):
- ✅ **Autoscaling** based on CPU (70%) and Memory (80%)
- ✅ **Scale range** 2-10 replicas
- ✅ **Behavior policies** (scale up fast, scale down gradual)

### k8s_audit.sh:
- ✅ **Type B pattern** (uses kubectl, minimal bash)
- ✅ **Comprehensive checks** (cluster, nodes, namespace, resources)
- ✅ **Resource counting** and health validation
- ✅ **Björn's assessment** based on deployment status
- ✅ **Colored output** for readability

## 🧪 Testing

### Manual tests:

```bash
# Test Service connectivity
kubectl port-forward service/shadow-web-service 8080:80 -n shadow-ops
curl http://localhost:8080

# Test pod logs
kubectl logs -l app=shadow-web -n shadow-ops

# Test ConfigMap
kubectl exec deployment/shadow-web -n shadow-ops -- env | grep -E "(api_url|log_level)"

# Test scaling
kubectl scale deployment shadow-web --replicas=5 -n shadow-ops
kubectl get pods -n shadow-ops

# Test rolling update
kubectl set image deployment/shadow-web nginx=nginx:1.26-alpine -n shadow-ops
kubectl rollout status deployment shadow-web -n shadow-ops

# Test rollback
kubectl rollout undo deployment shadow-web -n shadow-ops
```

### Run automated tests:

```bash
cd ../tests
./test.sh
```

## 📝 Notes

### Type B Episode:
This is a **Type B episode** (Configuration, not Scripting):
- Focus: Using kubectl to configure Kubernetes
- `k8s_audit.sh` is for **collection/reporting** only, NOT for deployment
- Students should use `kubectl apply -f` directly, not wrapper scripts
- Episode teaches Kubernetes itself, not bash automation

### Best Practices Demonstrated:
1. ✅ Resource requests and limits set
2. ✅ Health checks configured (liveness + readiness)
3. ✅ Rolling update strategy defined
4. ✅ Multiple replicas for HA
5. ✅ ConfigMaps for configuration (not hardcoded)
6. ✅ Secrets for sensitive data
7. ✅ Labels for organization
8. ✅ Namespaces for isolation

### Common Issues:

**ImagePullBackOff:**
- Check image name: `nginx:1.25-alpine` (not `nginx:latest`)

**CrashLoopBackOff:**
- Check logs: `kubectl logs <pod-name> -n shadow-ops`
- Check health checks: may be failing too fast

**Service not working:**
- Check endpoints: `kubectl get endpoints -n shadow-ops`
- If empty → selector mismatch between Service and Deployment

**HPA shows `<unknown>`:**
- Metrics server may need 1-2 minutes to collect data
- Or metrics-server not installed (in k3s it's built-in)

## 🎓 Learning Points

After completing this episode, you should understand:

1. **Kubernetes Architecture:**
   - Control Plane vs Worker Nodes
   - Pods, Deployments, Services, ConfigMaps, Secrets

2. **Declarative Configuration:**
   - YAML manifests define desired state
   - Kubernetes converges actual → desired state

3. **Self-Healing:**
   - Pods die → Deployment recreates them
   - Health checks fail → Kubernetes restarts container

4. **Zero-Downtime Deployments:**
   - Rolling updates replace pods gradually
   - Old version serves traffic while new version deploys
   - Rollback available if new version fails

5. **Scaling:**
   - Manual: `kubectl scale`
   - Automatic: HorizontalPodAutoscaler
   - Based on CPU/Memory metrics

6. **Troubleshooting:**
   - `kubectl describe` for events
   - `kubectl logs` for application output
   - `kubectl exec` for interactive debugging

---

**Björn's wisdom:**
> "Kubernetes is not tool. It's operating system for distributed applications. Master basics first — Pods, Deployments, Services. Advanced features become easier after foundation solid."

**LILITH v7.0:**
> "От Docker контейнеров до Kubernetes оркестрации. Ты управляешь 3 pods как единым приложением. Self-healing, load balancing, rolling updates — автоматически. Это production way. Episode 26 — мониторинг этой красоты."

---

## 🔗 Next Steps

Episode 26 will add:
- Prometheus (metrics collection)
- Grafana (visualization)
- Alertmanager (alerting)
- Full observability для production

Continue to: `../../season-7-production-advanced/episode-26-monitoring-observability/`


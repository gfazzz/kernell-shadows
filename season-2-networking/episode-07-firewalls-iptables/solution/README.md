# Episode 07: Firewalls & iptables — SOLUTION (Type B)

**Type B Philosophy:** "ufw exists → use it, don't wrap it"

---

## 📁 Solution Structure

```
solution/
├── configs/
│   ├── ufw_rules.sh             # UFW firewall configuration
│   └── iptables_backup.sh       # iptables alternative (advanced)
├── scripts/
│   └── generate_firewall_report.sh  # Report generator (minimal)
└── README.md                    # This file
```

---

## 🎯 Type B Approach: Firewall Configuration (NOT bash wrapper)

### ❌ Type A (Wrong for firewalls):
```bash
# firewall_wrapper.sh
#!/bin/bash
while read ip; do
    ufw deny from "$ip"  # ← Wrapping ufw in bash
done < blocked_ips.txt
```

### ✅ Type B (Correct for firewalls):
```bash
# Manual UFW commands
sudo ufw default deny incoming
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# Or run configuration script
./configs/ufw_rules.sh
```

**Difference:**
- Type A: Bash loop around ufw → student never learns ufw
- Type B: Student uses ufw directly → real Linux admin skill

---

## 📋 Episode Workflow (Type B)

### Phase 1: Understand Firewall Concepts (Cycles 1-3)

You already learned these **concepts** in the episode:
- Default policies (deny incoming, allow outgoing)
- Stateful vs stateless firewalls
- Rule order matters (first match wins)
- Rate limiting (SSH brute-force protection)

---

### Phase 2: Configure UFW (Recommended)

#### 1. Run UFW Configuration Script

```bash
# Deploy firewall rules
sudo ./solution/configs/ufw_rules.sh

# Or manually (same commands):
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw limit 22/tcp          # SSH with rate limiting
sudo ufw allow 80/tcp          # HTTP
sudo ufw allow 443/tcp         # HTTPS
sudo ufw logging on
sudo ufw --force enable
```

#### 2. Verify Configuration

```bash
# Check status
sudo ufw status verbose

# Check numbered rules
sudo ufw status numbered

# Check logs
sudo tail -f /var/log/ufw.log
```

#### 3. Test Firewall

```bash
# External test (from another machine)
nmap -p 22,80,443,3306,5432 YOUR_SERVER_IP

# Should show:
# 22/tcp   open     ssh
# 80/tcp   open     http
# 443/tcp  open     https
# 3306/tcp filtered mysql   (blocked)
# 5432/tcp filtered postgresql (blocked)
```

#### 4. Test Rate Limiting

```bash
# SSH brute-force simulation (from external machine)
for i in {1..10}; do
    ssh -o ConnectTimeout=2 wrong_user@YOUR_SERVER_IP
    sleep 1
done

# After 6 attempts, should see:
# "Connection refused" (rate limit kicked in)

# Check logs:
sudo grep "LIMIT" /var/log/ufw.log
```

---

### Phase 3: Configure iptables (Advanced Alternative)

**⚠️ Only if you prefer low-level control over UFW**

```bash
# Check if UFW is active
sudo ufw status

# If active, disable first (UFW uses iptables internally)
sudo ufw disable

# Run iptables configuration
sudo ./solution/configs/iptables_backup.sh

# Verify
sudo iptables -L -v -n

# Make persistent
sudo apt install iptables-persistent
sudo netfilter-persistent save
```

---

### Phase 4: Block Malicious IPs

#### Manual Blocking (Type B):

```bash
# Block single IP
sudo ufw deny from 185.220.101.45 comment 'Krylov C2 server'

# Block subnet
sudo ufw deny from 185.220.101.0/24 comment 'Krylov C2 network'

# Block from file (bash loop is OK here for bulk operations)
while read -r ip; do
    sudo ufw deny from "$ip" comment 'Botnet IP'
done < ../artifacts/botnet_ips.txt
```

**Verify blocked IPs:**
```bash
sudo ufw status numbered | grep DENY
```

---

### Phase 5: Monitor Firewall Activity

```bash
# Real-time log monitoring
sudo tail -f /var/log/ufw.log

# Show only blocked connections
sudo grep "UFW BLOCK" /var/log/ufw.log

# Show blocked IPs (top 10 attackers)
sudo grep "UFW BLOCK" /var/log/ufw.log | \
    awk '{print $(NF-2)}' | \
    sort | uniq -c | sort -rn | head -10

# Statistics (connections per rule)
sudo iptables -L -v -n
```

---

### Phase 6: Generate Report

```bash
# Generate firewall audit report
./solution/scripts/generate_firewall_report.sh

# View report
cat ../artifacts/firewall_audit_report.txt
```

---

## 📊 Type B vs Type A Comparison

| Task | Type A ❌ | Type B ✅ |
|------|----------|----------|
| Enable firewall | `./firewall_enable.sh` | `sudo ufw enable` |
| Add rule | `./firewall_add.sh 80` | `sudo ufw allow 80/tcp` |
| Block IP | `./block_ip.sh 1.2.3.4` | `sudo ufw deny from 1.2.3.4` |
| Check status | `./firewall_status.sh` | `sudo ufw status verbose` |
| Report | `./firewall_audit.sh` (348 lines) | `./generate_firewall_report.sh` (100 lines) |

**Episode 07 is Type B:**
- ✅ 95% manual UFW commands
- ✅ 5% minimal helper (report generator)
- ❌ NO bash wrapper around ufw

---

## 🔍 Configuration Files Explained

### 1. `ufw_rules.sh` — UFW Configuration

**What:** Complete UFW setup script (NOT a wrapper, just batched commands)  
**Why:** Documents exact commands student should run  
**How:** Can run entire script OR copy-paste individual commands

```bash
# These are DIRECT ufw commands, not wrapped:
sudo ufw limit 22/tcp         # Rate limiting
sudo ufw allow 80/tcp         # HTTP
sudo ufw deny from 1.2.3.4    # Block IP
```

**Type B because:**
- Each command is standalone ufw command
- Student can run manually or via script
- No abstraction, no wrapper logic

### 2. `iptables_backup.sh` — Low-level Alternative

**What:** iptables rules (more powerful but complex)  
**When:** Advanced scenarios requiring custom rules  
**Why:** UFW is iptables wrapper, this gives direct control

```bash
# Same rules as UFW, but using iptables directly:
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

**iptables vs UFW:**
- UFW: Simple, beginner-friendly, recommended
- iptables: Complex, powerful, for experts
- **Both do the same thing** (UFW uses iptables internally)

---

## 🧪 Testing Your Configuration

### Test 1: Port Accessibility
```bash
# From external machine
nmap -p 1-1000 YOUR_SERVER_IP

# Expected:
# 22/tcp   open     ssh
# 80/tcp   open     http
# 443/tcp  open     https
# All others: filtered
```

### Test 2: SSH Rate Limiting
```bash
# Simulate brute-force (10 rapid connections)
for i in {1..10}; do
    timeout 2 telnet YOUR_SERVER_IP 22 &
done

# After 6 connections, should be blocked
sudo grep "LIMIT" /var/log/ufw.log
```

### Test 3: Blocked IPs
```bash
# From blocked IP, try to connect
telnet YOUR_SERVER_IP 22
# → Should timeout or refuse immediately

# Check logs
sudo grep "185.220.101" /var/log/ufw.log
```

### Test 4: Internal Services Protected
```bash
# From external machine, try to connect to Prometheus
telnet YOUR_SERVER_IP 9090
# → Should timeout (only allowed from 10.20.30.0/24)

# From internal machine (10.20.30.X)
telnet YOUR_SERVER_IP 9090
# → Should connect (allowed for internal network)
```

### Test 5: Firewall Persistence
```bash
# Reboot server
sudo reboot

# After reboot, check if rules persisted
sudo ufw status verbose
# → Should show same rules (UFW is persistent by default)
```

---

## 🎓 What You Learned (Type B Skills)

### Firewall Tools (NOT bash wrappers):
- ✅ `ufw` — User-friendly firewall (recommended)
- ✅ `iptables` — Low-level netfilter interface (advanced)
- ✅ `nmap` — Port scanner (testing)
- ✅ `netstat` / `ss` — Network connections

### Configuration:
- ✅ Default policies (deny incoming, allow outgoing)
- ✅ Service rules (allow 22, 80, 443)
- ✅ Rate limiting (SSH brute-force protection)
- ✅ IP blocking (malicious sources)
- ✅ Logging (monitor attacks)

### Security Concepts:
- ✅ **Stateful firewall:** Tracks connection state (ESTABLISHED, NEW)
- ✅ **Rate limiting:** Max 6 SSH attempts per 30s per IP
- ✅ **Default deny:** Whitelist approach (more secure)
- ✅ **Rule order:** First match wins (specific before general)

### Real-World Skills:
- ✅ Protect SSH from brute-force (rate limiting)
- ✅ Block malicious IPs (C2 servers, botnets)
- ✅ Monitor firewall logs (identify attacks)
- ✅ Test firewall rules (nmap, telnet)

---

## 💡 Type B Philosophy (Kristjan's Wisdom)

> **"ufw exists for a reason. Use it. Don't wrap it in bash."**

**Why NOT bash wrapper?**
1. **Learning:** Wrapping ufw → student never learns ufw syntax
2. **Safety:** Direct commands → clear what's happening, wrapper → obscured
3. **Debugging:** ufw error messages are clear, wrapper errors are not
4. **Industry:** Real admins use ufw/iptables directly, not wrappers

**When is bash OK?**
- ✅ Bulk operations (block 1000 IPs from file)
- ✅ Report generation (format firewall status)
- ✅ Batch configuration (run multiple ufw commands)
- ❌ NOT for wrapping single ufw commands

---

## 🚀 Deployment (Production)

### 50 servers (Episode 16 preview):

**❌ Wrong (bash SSH loop):**
```bash
for server in $(cat servers.txt); do
    scp configs/ufw_rules.sh $server:/tmp/
    ssh $server "sudo /tmp/ufw_rules.sh"
done
```

**✅ Right (Ansible):**
```yaml
- name: Configure firewall
  hosts: all
  tasks:
    - name: Reset UFW
      ufw:
        state: reset
    
    - name: Set default policies
      ufw:
        direction: "{{ item.direction }}"
        policy: "{{ item.policy }}"
      loop:
        - { direction: incoming, policy: deny }
        - { direction: outgoing, policy: allow }
    
    - name: Allow SSH with rate limiting
      ufw:
        rule: limit
        port: 22
        proto: tcp
    
    - name: Allow HTTP/HTTPS
      ufw:
        rule: allow
        port: "{{ item }}"
        proto: tcp
      loop: [80, 443]
    
    - name: Enable UFW
      ufw:
        state: enabled
```

**Kristjan:** "For 1 machine: manual ufw. For 50: Ansible. Not bash SSH loop."

---

## 📝 Comparison with OLD solution

### OLD (Type A contradiction):
```
solution/
└── firewall_setup.sh    # 348 lines, checks ufw status via bash
```

❌ **Problem:** README says "use ufw directly", but solution wraps ufw in bash

### NEW (Type B correct):
```
solution/
├── configs/
│   ├── ufw_rules.sh             # Batched ufw commands (NOT wrapper)
│   └── iptables_backup.sh       # iptables alternative
└── scripts/
    └── generate_firewall_report.sh  # 100 lines, only formats report
```

✅ **Correct:** Direct ufw commands + minimal helper, NO ufw wrapper

---

## 🎯 Success Criteria

- ✅ You configured UFW manually (or via ufw_rules.sh)
- ✅ You enabled SSH rate limiting (`sudo ufw limit 22/tcp`)
- ✅ You blocked malicious IPs
- ✅ You tested with nmap (external scan)
- ✅ You monitored logs (`tail -f /var/log/ufw.log`)
- ✅ Report generated from YOUR configuration

---

## 🔗 Related Episodes

- **Episode 04:** Type B reference (apt exists → use it)
- **Episode 06:** Type B networking (dig exists → use it)
- **Episode 16:** Ansible for multi-server deployment

---

**"Rate limiting on SSH saved us from Krylov's bots."** — Kristjan Tamm

**Tallinn, Estonia • Firewall Defense Complete!** 🇪🇪


# Episode 06: DNS & Name Resolution — SOLUTION (Type B)

**Type B Philosophy:** "dig exists → use it, don't wrap it"

---

## 📁 Solution Structure

```
solution/
├── configs/
│   ├── resolv.conf              # /etc/resolv.conf — DNS resolvers
│   ├── hosts                    # /etc/hosts — local DNS overrides
│   └── systemd-resolved.conf   # /etc/systemd/resolved.conf — modern DNS
├── scripts/
│   └── generate_dns_report.sh   # Report generator (minimal helper)
└── README.md                    # This file
```

---

## 🎯 Type B Approach: DNS Configuration (NOT bash wrapper)

### ❌ Type A (Wrong for DNS):
```bash
# dns_wrapper.sh
#!/bin/bash
while read domain; do
    dig +short "$domain"  # ← Wrapping dig in bash
done < domains.txt
```

### ✅ Type B (Correct for DNS):
```bash
# Manual DNS queries
dig +short google.com              # Use dig directly
resolvectl query google.com        # Use systemd-resolved directly

# Configure DNS
sudo cp configs/systemd-resolved.conf /etc/systemd/
sudo systemctl restart systemd-resolved
```

**Difference:**
- Type A: Bash script wraps DNS tools → student never learns dig
- Type B: Student uses DNS tools directly → real Linux admin skill

---

## 📋 Episode Workflow (Type B)

### Phase 1: Manual DNS Queries (Cycles 1-7)

You already completed these **manually** in the episode:

```bash
# Cycle 2: Check shadow servers in public DNS
dig +short shadow-server-01.operation-shadow.net
dig +short shadow-server-02.operation-shadow.net
# → Should return NXDOMAIN (not leaked)

# Cycle 6: Detect DNS spoofing
dig @1.1.1.1 +short suspicious-banking.ru
dig @8.8.8.8 +short suspicious-banking.ru
# → Compare results from different resolvers

# Cycle 7: DNSSEC validation
resolvectl query google.com --type=DNSKEY
resolvectl query cloudflare.com --type=DNSKEY
# → Check for DNSKEY records (DNSSEC enabled)
```

**No bash wrapper needed!** You used dig/resolvectl directly.

---

### Phase 2: DNS Configuration

#### 1. Configure DNS Resolvers

**Option A: Legacy /etc/resolv.conf** (older Ubuntu)

```bash
# Check current DNS
cat /etc/resolv.conf

# Backup
sudo cp /etc/resolv.conf /etc/resolv.conf.backup

# Deploy new config
sudo cp configs/resolv.conf /etc/resolv.conf

# Test
dig +short google.com
```

**Option B: systemd-resolved** (Ubuntu 22.04+, recommended)

```bash
# Check if systemd-resolved is active
ls -la /etc/resolv.conf
# → If symlink to /run/systemd/resolve/* → using systemd-resolved

# Deploy config
sudo cp configs/systemd-resolved.conf /etc/systemd/resolved.conf

# Restart service
sudo systemctl restart systemd-resolved
sudo systemctl status systemd-resolved

# Test
resolvectl status
resolvectl query google.com
```

#### 2. Configure Local DNS Overrides

```bash
# Backup
sudo cp /etc/hosts /etc/hosts.backup

# Deploy (merge with existing)
sudo bash -c 'cat configs/hosts >> /etc/hosts'

# Or replace completely
sudo cp configs/hosts /etc/hosts

# Test
ping shadow-server-01.internal   # Should resolve to 10.20.30.10
getent hosts shadow-ops.net      # Should resolve to 127.0.0.1 (blocked)
```

---

### Phase 3: Verify Configuration

```bash
# DNS resolvers
resolvectl status | grep "DNS Servers"

# DNSSEC
resolvectl query google.com --type=DNSKEY

# DNS over TLS (check logs)
sudo journalctl -u systemd-resolved | grep -i tls

# DNS cache statistics
resolvectl statistics

# Test blocked domains
dig shadow-ops.net
# → Should return 127.0.0.1 (from /etc/hosts)
```

---

### Phase 4: Generate Report

```bash
# Mark queries as complete
touch artifacts/.dns_queries_done

# Generate report (minimal helper script)
./solution/scripts/generate_dns_report.sh

# View report
cat artifacts/dns_security_report.txt
```

---

## 📊 Type B vs Type A Comparison

| Task | Type A ❌ | Type B ✅ |
|------|----------|----------|
| DNS lookup | `./dns_wrapper.sh domain` | `dig +short domain` |
| DNS config | `./configure_dns.sh` | `sudo cp configs/systemd-resolved.conf /etc/systemd/` |
| Check DNSSEC | `./check_dnssec.sh domain` | `resolvectl query domain --type=DNSKEY` |
| Report | `./dns_audit.sh` (380 lines) | `./generate_dns_report.sh` (80 lines) |

**Episode 06 is Type B:**
- ✅ 95% manual DNS commands (dig, resolvectl)
- ✅ 5% minimal helper (report generator)
- ❌ NO bash wrapper around dig

---

## 🔍 Configuration Files Explained

### 1. `resolv.conf` — DNS Resolvers

**What:** Tells system which DNS servers to query  
**Where:** `/etc/resolv.conf`  
**When:** Legacy systems or when systemd-resolved disabled

```bash
nameserver 1.1.1.1      # Cloudflare (privacy-first)
nameserver 8.8.8.8      # Google (fast)
options timeout:2       # 2 seconds timeout
```

### 2. `hosts` — Local DNS Overrides

**What:** Static hostname-to-IP mapping, checked BEFORE DNS  
**Where:** `/etc/hosts`  
**Why:** 
- Block malicious domains (127.0.0.1 malware.com)
- Hide internal infrastructure from public DNS
- Speed up frequently accessed hosts

```bash
10.20.30.10  shadow-server-01.internal  shadow-01
127.0.0.1    shadow-ops.net             # Block from public DNS
```

### 3. `systemd-resolved.conf` — Modern DNS

**What:** Modern DNS resolver with DNSSEC + DNS over TLS  
**Where:** `/etc/systemd/resolved.conf`  
**Why:**
- **DNSSEC:** Validates DNS signatures (prevents spoofing)
- **DNS over TLS:** Encrypts queries (privacy)
- **Caching:** Faster lookups

```ini
[Resolve]
DNS=1.1.1.1 8.8.8.8
DNSSEC=allow-downgrade      # Validate when available
DNSOverTLS=opportunistic    # Encrypt when available
```

---

## 🧪 Testing Your Configuration

### Test 1: DNS Resolution
```bash
# Query public domain
dig +short google.com

# Query with specific resolver
dig @1.1.1.1 +short cloudflare.com

# Query via systemd-resolved
resolvectl query github.com
```

### Test 2: DNSSEC Validation
```bash
# Should have DNSKEY records
resolvectl query google.com --type=DNSKEY

# Should fail if DNSSEC=yes (test domain)
resolvectl query dnssec-failed.org
```

### Test 3: DNS over TLS
```bash
# Check logs for TLS connections
sudo journalctl -u systemd-resolved | grep -i tls
```

### Test 4: Local Overrides
```bash
# Should resolve to internal IP
ping shadow-server-01.internal

# Should resolve to 127.0.0.1 (blocked)
ping shadow-ops.net
```

### Test 5: DNS Cache
```bash
# Check cache statistics
resolvectl statistics

# Clear cache
sudo resolvectl flush-caches
```

---

## 🎓 What You Learned (Type B Skills)

### DNS Tools (NOT bash wrappers):
- ✅ `dig` — Query DNS records directly
- ✅ `resolvectl` — Query systemd-resolved
- ✅ `getent hosts` — Check hostname resolution
- ✅ `nslookup` — Alternative DNS query tool

### Configuration Files:
- ✅ `/etc/resolv.conf` — DNS resolvers (legacy)
- ✅ `/etc/hosts` — Local DNS overrides
- ✅ `/etc/systemd/resolved.conf` — Modern DNS config

### Security Features:
- ✅ **DNSSEC** — Validates DNS signatures (prevents spoofing)
- ✅ **DNS over TLS** — Encrypts queries (privacy)
- ✅ **Local blocking** — Block malicious domains in /etc/hosts

### Real-World Skills:
- ✅ Troubleshoot DNS issues (not found, slow, spoofed)
- ✅ Configure DNS for privacy (DoT + privacy-focused resolvers)
- ✅ Secure DNS with DNSSEC (protect from Krylov's attacks)
- ✅ Hide infrastructure (local DNS overrides)

---

## 💡 Type B Philosophy (Erik's Wisdom)

> **"dig exists for a reason. Use it. Don't wrap it in bash."**

**Why NOT bash wrapper?**
1. **Learning:** Wrapping dig → student never learns dig syntax
2. **Flexibility:** dig has 100+ options, wrapper has 5
3. **Debugging:** Direct commands → clear errors, wrapper → obscured
4. **Industry:** Real admins use dig directly, not wrappers

**When is bash OK?**
- ✅ Report generation (format results)
- ✅ Convenience scripts (run multiple commands)
- ❌ NOT for wrapping single-purpose tools (dig, apt, systemctl)

---

## 🚀 Deployment (Production)

### 50 servers (Episode 16 preview):

**❌ Wrong (bash loop):**
```bash
for server in $(cat servers.txt); do
    scp configs/systemd-resolved.conf $server:/etc/systemd/
    ssh $server "systemctl restart systemd-resolved"
done
```

**✅ Right (Ansible):**
```yaml
- name: Configure DNS
  hosts: all
  tasks:
    - name: Deploy systemd-resolved config
      copy:
        src: configs/systemd-resolved.conf
        dest: /etc/systemd/resolved.conf
      notify: restart systemd-resolved
```

**Erik:** "For 1 machine: manual commands. For 50: Ansible. Not bash loop."

---

## 📝 Comparison with OLD solution

### OLD (Type A contradiction):
```
solution/
└── dns_audit.sh         # 380 lines, wraps dig in bash
```

❌ **Problem:** README says "don't wrap dig", but solution DOES wrap dig

### NEW (Type B correct):
```
solution/
├── configs/
│   ├── resolv.conf      # Real DNS config
│   ├── hosts            # Real local overrides
│   └── systemd-resolved.conf  # Real systemd config
└── scripts/
    └── generate_dns_report.sh  # 80 lines, only formats report
```

✅ **Correct:** Configuration files + minimal helper, NO dig wrapper

---

## 🎯 Success Criteria

- ✅ You used `dig` manually (not bash wrapper)
- ✅ You configured DNS (systemd-resolved.conf or resolv.conf)
- ✅ You tested DNSSEC (`resolvectl query ... --type=DNSKEY`)
- ✅ You verified DoT (journalctl logs)
- ✅ You blocked domains in /etc/hosts
- ✅ Report generated from YOUR manual queries

---

## 🔗 Related Episodes

- **Episode 04:** Type B reference (apt exists → use it)
- **Episode 07:** Type B networking (ufw exists → use it)
- **Episode 16:** Ansible for multi-server deployment

---

**"DNS is the phonebook. DNSSEC + DoT = secure phonebook."** — Erik Johansson

**Stockholm, Sweden • DNS Security Complete!** 🇸🇪


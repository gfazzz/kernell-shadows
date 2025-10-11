# /etc/sudoers.d/ — Sudo Configuration for KERNEL SHADOWS

## 📁 Structure

```
/etc/sudoers.d/
├── alex      # Network Administrator (limited sudo)
├── viktor    # Operations Lead (full sudo)
├── dmitry    # DevOps Engineer (DevOps commands only)
└── README.md # This file (for reference, NOT deployed to /etc/)
```

---

## 🎯 Principle of Least Privilege

Each user has **minimum necessary sudo access** for their role:

| User | Role | Sudo Access | Password? |
|------|------|-------------|-----------|
| **Viktor** | Operations Lead | ALL commands | YES |
| **Alex** | Network Admin | Network commands only | NO (NOPASSWD) |
| **Dmitry** | DevOps Engineer | Docker, systemctl, apt | NO (NOPASSWD) |
| **Anna** | Forensics | NO sudo (read-only via ACL) | N/A |

---

## 📋 Deployment Instructions

### 1. Deploy sudoers Files

```bash
# Copy each file to /etc/sudoers.d/
sudo cp sudoers.d/alex /etc/sudoers.d/alex
sudo cp sudoers.d/viktor /etc/sudoers.d/viktor
sudo cp sudoers.d/dmitry /etc/sudoers.d/dmitry

# Set correct permissions (440 = read-only)
sudo chmod 440 /etc/sudoers.d/alex
sudo chmod 440 /etc/sudoers.d/viktor
sudo chmod 440 /etc/sudoers.d/dmitry

# Set ownership (root:root)
sudo chown root:root /etc/sudoers.d/alex
sudo chown root:root /etc/sudoers.d/viktor
sudo chown root:root /etc/sudoers.d/dmitry
```

### 2. Validate Syntax (CRITICAL!)

```bash
# ALWAYS validate before deploying!
# Invalid syntax can lock you out of sudo!

sudo visudo -c -f /etc/sudoers.d/alex
sudo visudo -c -f /etc/sudoers.d/viktor
sudo visudo -c -f /etc/sudoers.d/dmitry

# Should output: "parsed OK"
```

### 3. Test Each User's Access

```bash
# Test Alex (network commands)
sudo -i -u alex
sudo ip addr show          # Should work
sudo useradd test          # Should fail
exit

# Test Viktor (full sudo)
sudo -i -u viktor
sudo useradd test          # Should work (requires password)
exit

# Test Dmitry (DevOps commands)
sudo -i -u dmitry
sudo docker ps             # Should work
sudo useradd test          # Should fail
exit
```

---

## 🔍 Verification Commands

```bash
# List all sudoers files
ls -la /etc/sudoers.d/

# Check permissions (should be 440)
stat /etc/sudoers.d/alex

# View effective sudo rules for user
sudo -l -U alex
sudo -l -U viktor
sudo -l -U dmitry

# Check sudo logs
sudo grep "sudo:" /var/log/auth.log | tail -20

# See who can run what
sudo -l
```

---

## 🛡️ Security Best Practices

### 1. File Permissions (440)
```bash
# Correct:
-r--r----- 1 root root 1234 Oct 10 12:00 /etc/sudoers.d/alex

# Wrong (644):
-rw-r--r-- 1 root root 1234 Oct 10 12:00 /etc/sudoers.d/alex
# ^ World-readable = security risk!
```

### 2. Always Validate Syntax
```bash
# Before deploying:
sudo visudo -c -f /etc/sudoers.d/alex

# If invalid:
# /etc/sudoers.d/alex: syntax error near line 15 <<<
# Fix the error, test again
```

### 3. NOPASSWD Usage
```bash
# Convenient but risky:
alex ALL=(root) NOPASSWD: /usr/sbin/ip

# More secure (require password):
alex ALL=(root) PASSWD: /usr/sbin/ip

# Balance: NOPASSWD for read-only, PASSWD for modifications
```

### 4. Explicit Denials (Defense in Depth)
```bash
# Even if user gains broader access, block dangerous commands:
alex ALL=(root) !/usr/sbin/visudo, \
                !/bin/rm -rf /

# Example attack scenario:
# 1. Attacker compromises Alex's account
# 2. Tries to edit sudoers: sudo visudo
# 3. Blocked by explicit denial
```

### 5. Logging and Auditing
```bash
# Monitor sudo usage:
sudo journalctl -u sudo

# Check specific user:
sudo grep "alex.*sudo:" /var/log/auth.log

# Real-time monitoring:
sudo tail -f /var/log/auth.log | grep sudo
```

---

## 🧪 Testing Scenarios

### Scenario 1: Alex tries to add user
```bash
$ sudo useradd attacker
Sorry, user alex is not allowed to execute '/usr/sbin/useradd attacker' as root
```
✅ **Expected:** Blocked (Alex only has network commands)

### Scenario 2: Alex manages network
```bash
$ sudo ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
    inet 127.0.0.1/8 scope host lo
...
```
✅ **Expected:** Works (network commands allowed)

### Scenario 3: Dmitry restarts service
```bash
$ sudo systemctl restart nginx
```
✅ **Expected:** Works (DevOps commands allowed)

### Scenario 4: Dmitry modifies firewall
```bash
$ sudo ufw allow 8080/tcp
Sorry, user dmitry is not allowed to execute '/usr/sbin/ufw allow 8080/tcp' as root
```
✅ **Expected:** Blocked (firewall = security team, not DevOps)

### Scenario 5: Viktor does anything
```bash
$ sudo useradd test
$ sudo reboot
$ sudo rm /etc/important-file
```
✅ **Expected:** All work (Viktor has full sudo)

---

## 📊 Sudo Access Matrix

| Command | Viktor | Alex | Dmitry | Anna |
|---------|--------|------|--------|------|
| `useradd` | ✅ | ❌ | ❌ | ❌ |
| `ip addr` | ✅ | ✅ | ❌ | ❌ |
| `ufw allow` | ✅ | ✅ | ❌ | ❌ |
| `docker ps` | ✅ | ❌ | ✅ | ❌ |
| `systemctl restart` | ✅ | ❌ | ✅ | ❌ |
| `apt install` | ✅ | ❌ | ✅ | ❌ |
| `reboot` | ✅ | ❌ | ❌ | ❌ |
| `visudo` | ✅ | ❌ | ❌ | ❌ |

---

## 🚨 Common Mistakes

### 1. Wrong Permissions
```bash
# WRONG:
sudo chmod 644 /etc/sudoers.d/alex
# ^ World-readable! Anyone can see sudo rules

# CORRECT:
sudo chmod 440 /etc/sudoers.d/alex
# ^ Only root can read
```

### 2. No Syntax Validation
```bash
# WRONG:
sudo cp sudoers.d/alex /etc/sudoers.d/alex
# ^ Didn't test! If syntax error, sudo breaks!

# CORRECT:
sudo visudo -c -f sudoers.d/alex    # Test first
sudo cp sudoers.d/alex /etc/sudoers.d/alex  # Then deploy
```

### 3. Overly Broad NOPASSWD
```bash
# WRONG:
alex ALL=(root) NOPASSWD: ALL
# ^ Alex can do ANYTHING without password!

# CORRECT:
alex ALL=(root) NOPASSWD: /usr/sbin/ip, /usr/bin/ss
# ^ Only specific commands
```

### 4. Forgotten Wildcards
```bash
# WRONG:
alex ALL=(root) /usr/sbin/ip
# ^ Only exact command, no arguments!

# CORRECT:
alex ALL=(root) /usr/sbin/ip *
# ^ Allows arguments: sudo ip addr show
```

### 5. No Logging Monitoring
```bash
# Deploy sudoers files, but never check logs!
# → Attacker could abuse sudo for weeks unnoticed

# CORRECT:
# Monitor logs weekly:
sudo grep "sudo:" /var/log/auth.log | less
```

---

## 🔗 Related Documentation

- **man sudoers** — Full sudoers syntax reference
- **man visudo** — Sudo configuration editor
- **man sudo** — Sudo command usage
- `/etc/sudoers` — Main sudo configuration file

---

**"Least privilege — Alex gets network tools, nothing more. If compromised, damage is contained."**

— Professor Andrei Volkov, Saint Petersburg

**LETI, Russia • Principle of Least Privilege Applied!** 🇷🇺


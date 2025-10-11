# Episode 08: Artifacts — SSH & VPN Reference

**KERNEL SHADOWS — Season 2, Episode 08**

Этот каталог содержит сгенерированные конфиги и reference guides для SSH и VPN setup.

---

## 📁 Структура файлов

После запуска `solution/vpn_setup.sh`:

```
artifacts/
├── ssh_keys/              # SSH ключи для команды
│   ├── viktor_key         # Viktor private key
│   ├── viktor_key.pub     # Viktor public key
│   ├── alex_key
│   ├── alex_key.pub
│   ├── anna_key
│   ├── anna_key.pub
│   ├── dmitry_key
│   ├── dmitry_key.pub
│   ├── max_key
│   └── max_key.pub
│
├── wireguard/             # WireGuard конфиги
│   ├── wg0-server.conf    # Server config
│   ├── wg0-viktor.conf    # Viktor client
│   ├── wg0-alex.conf      # Alex client
│   ├── wg0-anna.conf      # Anna client
│   ├── wg0-dmitry.conf    # Dmitry client
│   └── wg0-max.conf       # Max client
│
├── ssh_config             # SSH config (copy to ~/.ssh/config)
└── season2_final_audit.txt # Final audit report
```

---

## 🔑 SSH Keys Guide

### Generation (already done by solution script)

```bash
# Generate ed25519 key
ssh-keygen -t ed25519 -C "user@example.com" -f ~/.ssh/my_key

# Параметры:
#   -t ed25519      : Algorithm (modern, fast, secure)
#   -C "comment"    : Comment (обычно email)
#   -f filename     : Output file
#   -N ""           : No passphrase (опционально)
```

### Key Security

**Private key permissions (CRITICAL!):**
```bash
chmod 600 ~/.ssh/my_key        # Private: только ты можешь читать
chmod 644 ~/.ssh/my_key.pub    # Public: все могут читать
```

**Если permissions неправильные:**
```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0644 for '~/.ssh/id_rsa' are too open.
```

### Deploy Public Key to Server

```bash
# Method 1: ssh-copy-id (automatic)
ssh-copy-id -i ~/.ssh/my_key.pub user@server

# Method 2: Manual
cat ~/.ssh/my_key.pub | ssh user@server "cat >> ~/.ssh/authorized_keys"

# Method 3: Paste directly
# 1. cat ~/.ssh/my_key.pub (копируешь вывод)
# 2. ssh user@server
# 3. nano ~/.ssh/authorized_keys (вставляешь)
# 4. chmod 600 ~/.ssh/authorized_keys
```

### Test SSH Key Authentication

```bash
# Test connection
ssh -i ~/.ssh/my_key user@server

# Success: подключается БЕЗ пароля ✓

# Debug connection issues
ssh -v -i ~/.ssh/my_key user@server
# -v = verbose (показывает что происходит)

# More verbose
ssh -vvv -i ~/.ssh/my_key user@server
```

---

## 📝 SSH Config Guide

### Basic Structure

```bash
# ~/.ssh/config

Host alias-name
    HostName actual-hostname-or-ip
    User username
    Port port-number
    IdentityFile path-to-key
```

### Real Example

```bash
Host zurich
    HostName vpn-zurich.kernel-shadows.com
    User max
    Port 22
    IdentityFile ~/.ssh/kernel_shadows_key
    ServerAliveInterval 60
    
# Now you can: ssh zurich
# Instead of: ssh -i ~/.ssh/kernel_shadows_key max@vpn-zurich.kernel-shadows.com
```

### Advanced Options

```bash
# Jump Host (Bastion)
Host production-db
    HostName 10.0.0.100
    ProxyJump bastion-server
    # Connects: you → bastion → production-db

# Wildcard Patterns
Host *.kernel-shadows.com
    User admin
    IdentityFile ~/.ssh/team_key
    # Applies to all servers in domain

# Connection Multiplexing (faster!)
Host *
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h:%p
    ControlPersist 10m
    # Reuses existing connections (no re-authentication)

# Keep-Alive
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    # Send keep-alive every 60 sec, disconnect after 3 failures
```

### Config Permissions

```bash
chmod 600 ~/.ssh/config
# SSH won't use config if permissions too open!
```

---

## 🔀 SSH Tunneling Guide

### Local Forward (-L)

**Access remote service через tunnel:**

```bash
ssh -L [local_port]:[target_host]:[target_port] ssh_server

# Example: Access remote PostgreSQL
ssh -L 5432:localhost:5432 moscow

# Now: psql -h localhost -p 5432
# Actually connects to: moscow:5432 через encrypted tunnel
```

**Use cases:**
- Database access через firewall
- Web admin panels (internal only)
- Any TCP service за firewall

### Remote Forward (-R)

**Expose local service to remote:**

```bash
ssh -R [remote_port]:[local_host]:[local_port] ssh_server

# Example: Expose local webhook
ssh -R 8080:localhost:3000 moscow

# Now: curl moscow:8080
# Actually connects to: your localhost:3000 через tunnel
```

**Use cases:**
- Webhook development (GitHub → your localhost)
- Demo local app (client → your localhost)
- Temporary service exposure

### Dynamic Forward (-D)

**SOCKS proxy для ALL traffic:**

```bash
ssh -D [local_port] ssh_server

# Example: SOCKS proxy
ssh -D 1080 moscow

# Configure browser:
#   SOCKS Host: localhost
#   Port: 1080
#   SOCKS v5: ☑
#   Proxy DNS: ☑ (CRITICAL for DNS leak prevention!)

# Now ALL browser traffic goes through moscow
```

**Use cases:**
- Browse corporate network
- Access multiple internal services
- VPN-like experience without VPN

### Useful Options

```bash
# Background mode (-f)
ssh -L 5432:localhost:5432 moscow -f
# Runs in background, terminal free

# No shell (-N)
ssh -L 5432:localhost:5432 moscow -N
# Only tunnel, no interactive shell (efficient!)

# Combined
ssh -L 5432:localhost:5432 moscow -N -f
# Background tunnel, no shell

# Kill background tunnel
pkill -f "ssh -L 5432"
```

---

## 🔐 WireGuard Guide

### Config Structure

**Server config (`/etc/wireguard/wg0.conf`):**

```ini
[Interface]
PrivateKey = <server-private-key>
Address = 10.8.0.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT

[Peer]  # Client 1
PublicKey = <client1-public-key>
AllowedIPs = 10.8.0.2/32

[Peer]  # Client 2
PublicKey = <client2-public-key>
AllowedIPs = 10.8.0.3/32
```

**Client config (`wg0.conf`):**

```ini
[Interface]
PrivateKey = <your-private-key>
Address = 10.8.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = <server-public-key>
Endpoint = vpn-server.com:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
```

### Key Generation

```bash
# Generate private key
wg genkey > private.key

# Generate public key from private
wg pubkey < private.key > public.key

# Or one-liner
wg genkey | tee private.key | wg pubkey > public.key
```

### Start/Stop VPN

```bash
# Start VPN
sudo wg-quick up wg0

# Stop VPN
sudo wg-quick down wg0

# Status
sudo wg show

# Detailed status
sudo wg show wg0
```

### Check Connection

```bash
# Ping VPN server
ping 10.8.0.1

# Check your external IP (should be VPN server IP)
curl https://ifconfig.me

# Check DNS (should use VPN DNS)
cat /etc/resolv.conf

# WireGuard status
sudo wg

# Should show:
#   interface: wg0
#   latest handshake: X seconds ago
#   transfer: X GB received, X GB sent
```

### Troubleshooting

**No handshake:**
```bash
# Check if server port open
nc -zvu vpn-server.com 51820

# Check firewall
sudo ufw allow 51820/udp

# Check server logs
sudo journalctl -u wg-quick@wg0 -f
```

**DNS not working:**
```bash
# Check /etc/resolv.conf
cat /etc/resolv.conf
# Should show VPN DNS (1.1.1.1)

# If not, add to client config:
[Interface]
DNS = 1.1.1.1
PostUp = echo "nameserver 1.1.1.1" > /etc/resolv.conf
```

**Slow connection:**
```bash
# Check MTU
ip link show wg0

# Reduce MTU if needed (in config):
[Interface]
MTU = 1420  # Default: 1420, try 1380 if issues
```

---

## 🛡️ Security Best Practices

### SSH Keys

✅ **DO:**
- Use ed25519 (modern, fast, secure)
- Set permissions: 600 private, 644 public
- Use passphrase for extra security
- Rotate keys periodically (every 6-12 months)
- Keep private keys on encrypted disk
- Use different keys for different purposes

❌ **DON'T:**
- Share private keys
- Commit private keys to git
- Email private keys
- Use weak algorithms (DSA, RSA < 2048-bit)
- Reuse same key everywhere

### SSH Config

✅ **DO:**
- Set permissions: 600
- Use ServerAliveInterval (keep-alive)
- Use ControlMaster (connection reuse)
- Document aliases

❌ **DON'T:**
- Store passwords in config
- Use weak ciphers
- Allow root login (in sshd_config)

### WireGuard

✅ **DO:**
- Keep private keys SECRET (chmod 600)
- Use strong VPN network (10.0.0.0/8 private range)
- Enable PostUp/PostDown firewall rules
- Monitor connections: `wg show`
- Use PersistentKeepalive for NAT
- Test for DNS leaks: https://dnsleaktest.com

❌ **DON'T:**
- Share private keys
- Use weak AllowedIPs (0.0.0.0/0 only if needed)
- Expose WireGuard port unnecessarily
- Forget firewall rules

### General

✅ **DO:**
- Use encryption always (SSH, VPN)
- Test security: DNS leaks, IP leaks
- Monitor logs: journalctl, auth.log
- Keep software updated: apt update && apt upgrade
- Use fail2ban for SSH brute-force protection

❌ **DON'T:**
- Trust unencrypted connections
- Ignore security warnings
- Use default passwords
- Disable firewall "for testing"

---

## 🔧 Troubleshooting Common Issues

### SSH: Permission Denied

```bash
# Check key permissions
ls -la ~/.ssh/
# Private keys: 600, Public keys: 644, Config: 600

# Fix permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/id_*.pub
chmod 600 ~/.ssh/config

# Check server: authorized_keys permissions
ssh user@server "ls -la ~/.ssh/authorized_keys"
# Should be: 600

# Fix server
ssh user@server "chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
```

### SSH: Connection Timeout

```bash
# Check if server reachable
ping server-hostname

# Check if SSH port open
nc -zv server-hostname 22

# Try different port (if non-standard)
ssh -p 2222 user@server

# Check firewall
sudo ufw status
```

### SSH Tunnel: Connection Refused

```bash
# Check if service running on remote
ssh server "netstat -tlnp | grep PORT"

# Check tunnel created
ps aux | grep "ssh -L"

# Try with verbose
ssh -v -L 8080:localhost:80 server
```

### WireGuard: No Handshake

```bash
# Check server running
ssh server "sudo wg show"

# Check client config
cat /etc/wireguard/wg0.conf
# Verify: server public key, endpoint, port

# Check firewall
sudo ufw allow 51820/udp

# Check server logs
ssh server "sudo journalctl -u wg-quick@wg0 -f"

# Test connection
nc -zvu server-hostname 51820
```

### WireGuard: DNS Leak

```bash
# Test DNS leak
curl https://dnsleaktest.com

# If leaked, fix client config:
[Interface]
DNS = 1.1.1.1
PostUp = echo "nameserver 1.1.1.1" > /etc/resolv.conf

# Or use systemd-resolved
[Interface]
DNS = 1.1.1.1
PostUp = resolvectl dns wg0 1.1.1.1
```

---

## 📊 Monitoring & Testing

### SSH Connection Monitoring

```bash
# Active SSH connections
who

# SSH login history
last -a

# Failed SSH attempts
sudo grep "Failed password" /var/log/auth.log

# SSH connection logs
sudo journalctl -u ssh -f
```

### VPN Monitoring

```bash
# WireGuard status
sudo wg show

# Connection details
sudo wg show wg0

# Traffic stats
sudo wg show wg0 transfer

# Client list
sudo wg show wg0 peers

# Check VPN interface
ip addr show wg0

# Check VPN routing
ip route show | grep wg0
```

### Security Testing

```bash
# Test DNS leak
curl https://dnsleaktest.com
# Should show VPN DNS, NOT ISP DNS

# Test IP leak
curl https://ifconfig.me
# Should show VPN server IP

# Test IPv6 leak (if IPv6 enabled)
curl -6 https://ifconfig.co
# Should fail OR show VPN IPv6

# Test WebRTC leak (browser)
# Visit: https://browserleaks.com/webrtc
# Should NOT show your real IP

# Full VPN test
# Visit: https://www.dnsleaktest.com/
# Run Extended Test → should show VPN provider only
```

---

## 📖 Reference Commands

### SSH Essentials

```bash
# Generate key
ssh-keygen -t ed25519 -C "user@example.com" -f ~/.ssh/key

# Copy key to server
ssh-copy-id -i ~/.ssh/key.pub user@server

# Connect with key
ssh -i ~/.ssh/key user@server

# Test config
ssh -T git@github.com

# Remove host from known_hosts
ssh-keygen -R hostname
```

### SSH Tunneling

```bash
# Local forward
ssh -L local_port:target:target_port server

# Remote forward
ssh -R remote_port:localhost:local_port server

# Dynamic forward (SOCKS)
ssh -D local_port server

# Background + no shell
ssh -L 5432:localhost:5432 server -N -f

# Kill tunnel
pkill -f "ssh -L"
```

### WireGuard

```bash
# Generate keys
wg genkey | tee private.key | wg pubkey > public.key

# Start VPN
sudo wg-quick up wg0

# Stop VPN
sudo wg-quick down wg0

# Status
sudo wg show

# Reload config
sudo wg syncconf wg0 <(wg-quick strip wg0)
```

---

## 🎓 Learning Resources

### Man Pages

```bash
man ssh           # SSH client
man ssh_config    # SSH config format
man ssh-keygen    # Key generation
man sshd_config   # SSH server config
man wg            # WireGuard
man wg-quick      # WireGuard quick setup
```

### Online Resources

- **SSH:** https://www.ssh.com/academy/ssh
- **SSH Tunneling:** https://www.ssh.com/academy/ssh/tunneling
- **WireGuard:** https://www.wireguard.com/
- **WireGuard Quickstart:** https://www.wireguard.com/quickstart/
- **DNS Leak Test:** https://dnsleaktest.com
- **IP Check:** https://ifconfig.me

---

## ✅ Quick Reference

### SSH Key Setup (3 steps)

```bash
# 1. Generate
ssh-keygen -t ed25519 -C "user@example.com"

# 2. Copy to server
ssh-copy-id user@server

# 3. Connect
ssh user@server  # No password!
```

### SSH Config (copy-paste)

```bash
Host myserver
    HostName 192.168.1.100
    User admin
    Port 22
    IdentityFile ~/.ssh/my_key
```

### SSH Tunnel (quick start)

```bash
# Access remote DB
ssh -L 5432:localhost:5432 server

# Use SOCKS proxy
ssh -D 1080 server
# Configure browser: SOCKS5 localhost:1080
```

### WireGuard (quick start)

```bash
# Generate keys
wg genkey | tee private.key | wg pubkey > public.key

# Copy configs from artifacts/wireguard/

# Start VPN
sudo wg-quick up wg0

# Check
sudo wg show
curl https://ifconfig.me  # Should show VPN IP
```

---

**Успехов в Episode 08!** 🚀

*"Encryption — не paranoia. Encryption — hygiene. Как чистить зубы. Не делаешь — проблемы."* — LILITH

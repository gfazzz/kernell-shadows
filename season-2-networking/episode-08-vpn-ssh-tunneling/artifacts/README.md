# Episode 08: VPN & SSH Tunneling — Artifacts

**Season 2 Finale**

Эта директория содержит конфигурационные файлы и примеры для Episode 08.

---

## 📁 Структура

```
artifacts/
├── README.md                   (этот файл)
├── ssh_keys/                   (генерируется скриптом)
│   ├── viktor_key
│   ├── viktor_key.pub
│   ├── alex_key
│   ├── alex_key.pub
│   ├── anna_key
│   ├── anna_key.pub
│   ├── dmitry_key
│   ├── dmitry_key.pub
│   ├── max_key
│   └── max_key.pub
│
├── wireguard/                  (генерируется скриптом)
│   ├── server_wg0.conf         (server config)
│   ├── viktor.conf             (client configs)
│   ├── alex.conf
│   ├── anna.conf
│   ├── dmitry.conf
│   ├── max.conf
│   ├── server_private.key      (keys)
│   ├── server_public.key
│   └── ...
│
├── ssh_config                  (генерируется скриптом)
└── season2_final_audit.txt     (генерируется скриптом)
```

---

## 🔑 SSH Keys

**Генерация:**
```bash
./starter.sh
# или
./solution/vpn_setup.sh
```

**Алгоритм:** ed25519 (256-bit, современная эллиптическая криптография)

**Использование:**
```bash
# Скопировать ключи
cp artifacts/ssh_keys/max_key ~/.ssh/
chmod 600 ~/.ssh/max_key

# Скопировать public key на сервер
ssh-copy-id -i ~/.ssh/max_key.pub user@server

# Подключение
ssh -i ~/.ssh/max_key user@server
```

**Security:**
- ✅ **Private keys** (без .pub) — СЕКРЕТНЫЕ! Никогда не публикуйте
- ✅ **Public keys** (.pub) — можно публиковать безопасно
- ✅ Permissions: private key = 600, public key = 644

---

## ⚙️ SSH Config

**Файл:** `artifacts/ssh_config`

**Установка:**
```bash
# Backup текущего конфига (если есть)
cp ~/.ssh/config ~/.ssh/config.backup

# Установить новый
cp artifacts/ssh_config ~/.ssh/config
chmod 600 ~/.ssh/config
```

**Использование:**
```bash
# Простое подключение
ssh vpn              # Вместо ssh -i ~/.ssh/max_key max@195.14.20.10
ssh shadow-02        # Автоматически через VPN!
ssh viktor           # Через VPN jump

# Port forwarding (уже настроен в config)
ssh shadow-02
# Теперь localhost:8080 → shadow-02:80
```

**Проверка:**
```bash
# Показать что будет использовано
ssh -G shadow-02 | grep -E 'user|hostname|identityfile|proxyjump'
```

---

## 🔐 WireGuard VPN

### Server Setup

**Файл:** `artifacts/wireguard/server_wg0.conf`

**Установка на сервере (Zürich):**
```bash
# 1. Install WireGuard
sudo apt update
sudo apt install wireguard

# 2. Copy config
sudo cp artifacts/wireguard/server_wg0.conf /etc/wireguard/wg0.conf
sudo chmod 600 /etc/wireguard/wg0.conf

# 3. Enable IP forwarding
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.all.forwarding=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# 4. Start VPN
sudo wg-quick up wg0

# 5. Enable on boot
sudo systemctl enable wg-quick@wg0
```

**Проверка:**
```bash
sudo wg show
sudo systemctl status wg-quick@wg0
```

---

### Client Setup

**Файлы:** `artifacts/wireguard/{viktor,alex,anna,dmitry,max}.conf`

**Установка на клиенте:**
```bash
# 1. Install WireGuard
sudo apt update
sudo apt install wireguard

# 2. Copy your config (example: max)
sudo cp artifacts/wireguard/max.conf /etc/wireguard/max.conf
sudo chmod 600 /etc/wireguard/max.conf

# 3. Start VPN
sudo wg-quick up max

# 4. Enable on boot (optional)
sudo systemctl enable wg-quick@max
```

**Проверка:**
```bash
# WireGuard status
sudo wg show

# Ping VPN gateway
ping 10.8.0.1

# Check IP (should show VPN server IP)
curl http://ifconfig.me

# DNS leak test
curl https://dnsleaktest.com/
```

**Остановка:**
```bash
sudo wg-quick down max
```

---

## 📊 Мониторинг

### VPN Status

```bash
# Активные peers
sudo wg show

# Transfer statistics
sudo wg show wg0 transfer

# Interface status
ip addr show wg0

# Routes
ip route | grep wg0
```

### SSH Tunnels

```bash
# Активные SSH tunnels
ps aux | grep 'ssh -[LRD]'

# Открытые порты
lsof -i -P | grep ssh | grep LISTEN

# Kill tunnel
kill $(pgrep -f 'ssh -L 3000')
```

### Security Tests

```bash
# Public IP check
curl http://ifconfig.me

# DNS servers
cat /etc/resolv.conf

# DNS leak test (online)
# Visit: https://dnsleaktest.com/
```

---

## 🎯 Common Tasks

### Create SSH Tunnel (Local Forward)

```bash
# Grafana access
ssh -L 3000:localhost:3000 -N -f shadow-02

# PostgreSQL access
ssh -L 5432:10.50.1.25:5432 -N -f shadow-02

# Web service
ssh -L 8080:localhost:80 -N -f shadow-02
```

### Create SOCKS Proxy

```bash
# Start proxy
ssh -D 1080 -N -f vpn-zurich

# Configure browser:
#   Proxy: SOCKS5
#   Host: localhost
#   Port: 1080

# Test
curl --socks5 localhost:1080 http://ifconfig.me
```

### VPN Reconnect

```bash
# Restart VPN
sudo wg-quick down max
sudo wg-quick up max

# Force reload
sudo systemctl restart wg-quick@max
```

---

## 🐛 Troubleshooting

### SSH Issues

**Problem:** `Permission denied (publickey)`
```bash
# Check key permissions
ls -la ~/.ssh/
chmod 600 ~/.ssh/max_key
chmod 644 ~/.ssh/max_key.pub

# Verify key on server
ssh-copy-id -i ~/.ssh/max_key.pub user@server
```

**Problem:** `Connection refused`
```bash
# Check SSH service
sudo systemctl status ssh

# Check port
ss -tulpn | grep :22
```

---

### VPN Issues

**Problem:** `wg-quick: wg0 already exists`
```bash
# Stop existing
sudo wg-quick down wg0

# Restart
sudo wg-quick up wg0
```

**Problem:** `Cannot resolve host name`
```bash
# Check DNS
cat /etc/resolv.conf

# Use IP instead of hostname in Endpoint
# Edit: /etc/wireguard/max.conf
# Change: Endpoint = vpn-zurich.com:51820
# To:     Endpoint = 195.14.20.10:51820
```

**Problem:** `No internet through VPN`
```bash
# Check IP forwarding (on server)
cat /proc/sys/net/ipv4/ip_forward  # Should be 1

# Check iptables (on server)
sudo iptables -t nat -L POSTROUTING

# Check routes (on client)
ip route
```

---

### DNS Leak

**Problem:** DNS shows ISP servers
```bash
# Edit VPN config
sudo nano /etc/wireguard/max.conf

# Add/check:
[Interface]
DNS = 1.1.1.1

# Restart
sudo wg-quick down max
sudo wg-quick up max
```

---

## 🔒 Security Best Practices

### SSH Keys

- ✅ Use ed25519 (or RSA 4096 for legacy)
- ✅ Set passphrase for private keys
- ✅ Rotate keys annually
- ✅ Revoke compromised keys immediately
- ✅ Use different keys for different servers (advanced)

### VPN

- ✅ Use WireGuard (modern, fast, audited)
- ✅ Enable DNS through VPN
- ✅ Test for leaks (IP, DNS, WebRTC)
- ✅ Monitor connections
- ✅ Log access (but not traffic content)

### General

- ✅ Keep software updated
- ✅ Use firewall (UFW/iptables)
- ✅ Monitor logs
- ✅ Document everything
- ✅ Test backups

---

## 📖 References

- [WireGuard Official Docs](https://www.wireguard.com/)
- [SSH Config Man Page](https://man.openbsd.org/ssh_config)
- [iptables Tutorial](https://www.netfilter.org/documentation/)
- [DNS Leak Test](https://dnsleaktest.com/)

---

## ✅ Checklist

Before deploying to production:

- [ ] SSH keys generated and secured (chmod 600)
- [ ] SSH config tested (ssh -G hostname)
- [ ] WireGuard server config reviewed
- [ ] WireGuard client configs distributed
- [ ] IP forwarding enabled on server
- [ ] Firewall allows UDP 51820 (WireGuard)
- [ ] VPN tested (ping, internet access)
- [ ] DNS leak tested
- [ ] IP leak tested
- [ ] Documentation complete
- [ ] Team trained

---

*"Security through obscurity is not security. Security through strong cryptography is."*  
— Katarina Lindström

**Episode 08: VPN & SSH Tunneling — Season 2 Finale** ✓

---

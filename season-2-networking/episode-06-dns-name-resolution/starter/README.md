# Starter — Episode 06: DNS

## Quick Start

1. Fill TODO in `configs/`:
   - `resolv.conf` (DNS servers)
   - `hosts` (local DNS)

2. Copy to system (backup first!):
```bash
sudo cp /etc/resolv.conf /etc/resolv.conf.backup
sudo cp /etc/hosts /etc/hosts.backup
sudo cp configs/resolv.conf /etc/
sudo cp configs/hosts /etc/
```

3. Test:
```bash
dig google.com
ping shadow-01
```

**Restore backup if needed:**
```bash
sudo cp /etc/resolv.conf.backup /etc/resolv.conf
sudo cp /etc/hosts.backup /etc/hosts
```

**LILITH:** *"DNS конфиги — редактируй напрямую. Используй dig/nslookup, не bash wrapper."*


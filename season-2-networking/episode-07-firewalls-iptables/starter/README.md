# Starter — Episode 07: Firewalls

## Quick Start

1. Fill TODO in `configs/ufw_setup.sh`

2. Run setup:
```bash
chmod +x configs/ufw_setup.sh
sudo ./configs/ufw_setup.sh
```

3. Check status:
```bash
sudo ufw status verbose
```

4. Test firewall:
```bash
# Should work (allowed)
curl http://localhost:80

# Should timeout (blocked)
telnet localhost 3306
```

**Common UFW commands:**
```bash
sudo ufw status
sudo ufw allow 22/tcp
sudo ufw deny 3306/tcp
sudo ufw delete allow 80/tcp
sudo ufw disable
sudo ufw enable
```

**LILITH:** *"Firewall — используй ufw напрямую, не оборачивай в bash. Automation = список ufw команд, не wrapper."*


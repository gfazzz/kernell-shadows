#!/bin/bash
# KERNEL SHADOWS: Episode 07 — UFW Firewall Rules
# Stockholm, Sweden → Tallinn, Estonia
#
# ⚠️ This is NOT a wrapper! This is a rule definition script.
# You apply these rules MANUALLY or via configuration management (Ansible)
#
# Philosophy: ufw exists → use it directly
# This file documents the exact commands you should run

set -e
set -u

echo "═══════════════════════════════════════════════════════════════"
echo "  UFW FIREWALL RULES — Operation Shadow Infrastructure"
echo "  Tallinn, Estonia — Protecting against Krylov's attacks"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# ============================================================================
# STEP 1: Reset UFW (clean slate)
# ============================================================================
echo "[1/7] Resetting UFW to defaults..."
sudo ufw --force reset

# ============================================================================
# STEP 2: Set default policies (deny all incoming, allow all outgoing)
# ============================================================================
echo "[2/7] Setting default policies..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw default deny routed

# ============================================================================
# STEP 3: Allow critical services
# ============================================================================
echo "[3/7] Allowing critical services..."

# SSH (with rate limiting to prevent brute-force)
sudo ufw limit 22/tcp comment 'SSH with rate limiting (6 attempts/30s)'

# HTTP
sudo ufw allow 80/tcp comment 'HTTP web server'

# HTTPS
sudo ufw allow 443/tcp comment 'HTTPS web server'

# Internal monitoring (Prometheus)
sudo ufw allow from 10.20.30.0/24 to any port 9090 comment 'Prometheus (internal only)'

# Internal monitoring (Grafana)
sudo ufw allow from 10.20.30.0/24 to any port 3000 comment 'Grafana (internal only)'

# Database (only from app servers)
sudo ufw allow from 10.20.30.10 to any port 5432 comment 'PostgreSQL from app-01'
sudo ufw allow from 10.20.30.11 to any port 5432 comment 'PostgreSQL from app-02'

# ============================================================================
# STEP 4: Block known malicious IPs (Krylov's infrastructure)
# ============================================================================
echo "[4/7] Blocking known malicious IPs..."

# Krylov's known C2 servers
sudo ufw deny from 185.220.101.0/24 comment 'Krylov C2 network'
sudo ufw deny from 45.138.172.0/24 comment 'FSB tracking infrastructure'
sudo ufw deny from 195.154.146.0/24 comment 'Suspicious Russian VPS'

# TOR exit nodes (suspicious activity)
sudo ufw deny from 199.249.230.0/24 comment 'Tor exit nodes'

# China-based attackers
sudo ufw deny from 218.92.0.0/16 comment 'China botnet source'

# Example: block specific IPs from artifacts/botnet_ips.txt
# while read ip; do
#     sudo ufw deny from "$ip" comment 'Botnet IP'
# done < ../artifacts/botnet_ips.txt

# ============================================================================
# STEP 5: Application-specific rules
# ============================================================================
echo "[5/7] Configuring application rules..."

# Docker containers (if using Docker)
# sudo ufw allow from 172.17.0.0/16 comment 'Docker internal network'

# VPN (if using OpenVPN/WireGuard)
# sudo ufw allow 1194/udp comment 'OpenVPN'
# sudo ufw allow 51820/udp comment 'WireGuard'

# ============================================================================
# STEP 6: Enable logging
# ============================================================================
echo "[6/7] Enabling firewall logging..."
sudo ufw logging on

# For more verbose logging (debugging):
# sudo ufw logging medium
# sudo ufw logging high

# ============================================================================
# STEP 7: Enable UFW
# ============================================================================
echo "[7/7] Enabling UFW..."
sudo ufw --force enable

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "✓ UFW Configuration Complete!"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# ============================================================================
# Verification
# ============================================================================
echo "Verification commands:"
echo "  sudo ufw status verbose        # Check rules"
echo "  sudo ufw status numbered       # Show rule numbers"
echo "  sudo tail -f /var/log/ufw.log  # Monitor blocked connections"
echo ""

# Show current status
sudo ufw status verbose

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "Kristjan: \"Firewall is your first line of defense."
echo "           Rate limiting on SSH = protection from Krylov.\""
echo "═══════════════════════════════════════════════════════════════"

# ============================================================================
# IMPORTANT NOTES:
#
# 1. Rate Limiting (limit vs allow):
#    - 'limit': Max 6 connections per 30 seconds per IP
#    - 'allow': Unlimited connections
#    - Use 'limit' for SSH to prevent brute-force
#
# 2. Rule Order Matters:
#    - UFW processes rules top-to-bottom
#    - More specific rules should come first
#    - Example: 'allow from 10.0.0.1' before 'deny from 10.0.0.0/24'
#
# 3. Default Policies:
#    - incoming: deny (whitelist approach, more secure)
#    - outgoing: allow (servers need to connect out)
#    - routed: deny (prevent router mode unless needed)
#
# 4. Logging:
#    - Logs go to /var/log/ufw.log
#    - Default level: 'low' (blocked packets only)
#    - 'medium': blocked + allowed packets
#    - 'high': includes rate limiting
#
# 5. Testing Rules:
#    - Test from external IP: nmap -p 22,80,443 YOUR_IP
#    - Check blocked: sudo grep 'UFW BLOCK' /var/log/ufw.log
#    - Monitor live: sudo ufw status verbose
#
# 6. Removing Rules:
#    - By number: sudo ufw delete 3
#    - By rule: sudo ufw delete allow 80/tcp
#    - Reset all: sudo ufw --force reset
#
# 7. Application Profiles:
#    - List: sudo ufw app list
#    - Info: sudo ufw app info 'Nginx Full'
#    - Allow: sudo ufw allow 'Nginx Full'
#
# ============================================================================


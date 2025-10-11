#!/bin/bash
# KERNEL SHADOWS: Episode 07 — UFW Setup with TODO

set -e

echo "Setting up UFW firewall..."

# TODO 1: Reset UFW to defaults
# Подсказка: sudo ufw --force reset
sudo ufw --force ???

# TODO 2: Set default policies
# Подсказка: sudo ufw default deny incoming
sudo ufw default ??? incoming
sudo ufw default ??? outgoing

# TODO 3: Allow SSH (port 22)
# Подсказка: sudo ufw allow 22/tcp
sudo ufw allow ???

# TODO 4: Allow HTTP (port 80)
# Подсказка: sudo ufw allow 80/tcp
sudo ufw allow ???

# TODO 5: Allow HTTPS (port 443)
# Подсказка: sudo ufw allow 443/tcp  
sudo ufw allow ???

# TODO 6: Enable UFW
# Подсказка: sudo ufw --force enable
sudo ufw --force ???

echo "✓ UFW configured!"
sudo ufw status verbose


# Episode 21: Raspberry Pi & GPIO Programming

> *"Embedded Linux — это где software встречает hardware. Без GUI. Без прощения."* — Li Wei

```
Season 6: Embedded Linux & IoT Security
Episode 21 of 32
Location: Шэньчжэнь 🇨🇳, Китай (Huaqiangbei Electronics Market)
Days: 41-42 of Operation KERNEL SHADOWS
Duration: 4-5 hours
Difficulty: ⭐⭐⭐⭐⭐
Type: Embedded Basics (Type B + C programming)
```

---

## 📋 Обзор

### Что вы изучите

В этом эпизоде вы освоите **embedded Linux basics** через Raspberry Pi:

**Технологии:**
- 🤖 **Raspberry Pi** — embedded Linux platform
- 🔌 **GPIO programming** — hardware control в C
- 📹 **Camera streaming** — surveillance feed
- 🔧 **Device configuration** — boot config, Device Tree
- 🔐 **SSH remote access** — secure connection

**Навыки:**
- Embedded Linux architecture понимание
- C programming для hardware control
- GPIO pins manipulation (LED, sensors)
- Camera setup и streaming
- Cross-compilation basics
- systemd services для автостарта

**Важно:** Это **НЕ MOONLIGHT уровень C**! Мы пишем простой C код для GPIO, не algorithms. Фокус на hardware integration, не на advanced C.

---

## 🎬 Сюжет: Surveillance начинается

### День 41, утро — Шэньчжэнь, Huaqiangbei Market

**Дмитрий Орлов** (DevOps engineer, core team):

*"Макс, нам нужна surveillance система. Камера у здания где Крылов может появиться. Скрытая."*

**Виктор:** *"Raspberry Pi. Ubuntu. Remote access. Live stream к нам. Можешь?"*

**Макс:** *"Raspberry Pi? Это же... маленький компьютер?"*

**Li Wei** (ex-DJI engineer, 45 лет, спокойный, точный):

*"Не просто компьютер. Это embedded Linux platform. GPIO pins — прямой доступ к hardware. Камера, sensors, всё."*

Он показывает Raspberry Pi 4:

```
Raspberry Pi 4:
- ARM Cortex-A72 CPU (4 cores, 1.5 GHz)
- 4GB RAM
- 40 GPIO pins
- Camera interface (CSI)
- Ubuntu 22.04 LTS support
```

**Li Wei:** *"Huaqiangbei market — здесь делают 90% мировых дронов. Здесь можно купить ВСЁ. Raspberry Pi, камера, sensors — 30 минут."*

---

### Electronics Market — Shopping

10-этажное здание. Электроника везде. Тысячи маленьких магазинов.

**Li Wei покупает:**
- Raspberry Pi 4 (4GB)
- Pi Camera Module v2
- LEDs, резисторы, провода
- MicroSD 64GB
- Power supply 5V 3A

**Стоимость:** $80 total

**Li Wei:** *"В США это $200. Здесь — $80. Welcome to Shenzhen."*

---

### Lab Setup

**Li Wei:** *"Embedded Linux отличается от server Linux. No GUI. No safety net. Direct hardware access. Один неправильный вольтаж — fried Pi."*

Он подключает LED к GPIO 17:

```
GPIO 17 (Pin 11) → LED → Resistor (220Ω) → GND (Pin 6)
```

**Li Wei:** *"Resistor обязателен. Без resistor — LED сгорит. Или Pi сгорит. Или оба."*

**Макс:** *"Это сложнее чем systemd..."*

**Li Wei:** *"Hardware не прощает. Software crash — restart. Hardware crash — physical damage. Поэтому embedded programming — это ответственность."*

---

### Миссия

**Цель:** Surveillance система на базе Raspberry Pi

**Requirements:**
1. Ubuntu на Raspberry Pi
2. GPIO control program (C) для LED signal
3. Camera streaming к HQ
4. SSH remote access (hardened)
5. systemd autostart

**Timeline:** 4-5 часов

**Li Wei:** *"Начнём с basics. GPIO control. Потом camera. Потом production deployment."*

**LILITH** (активируется): *"Embedded Linux как LEGO для взрослых. Но с проводами. И вольтажом. И возможностью всё спалить. Exciting!"*

---

## 🎓 Структура эпизода: 6 микро-циклов

Каждый цикл = 20-30 минут:
- 🎬 Сюжет (2-3 мин)
- 📚 Теория (10-15 мин)
- 💻 Практика (7-12 мин)
- 🤔 Проверка понимания (1 мин)

**Общее время:** ~2.5 часа теория + 2 часа практика = 4-5 часов

---

## 🔄 Цикл 1: Embedded Linux Architecture (25 мин)

### 🎬 Сюжет

**Li Wei рисует на whiteboard:**

```
Desktop/Server Linux:
┌─────────────────┐
│  Applications   │
├─────────────────┤
│   Libraries     │
├─────────────────┤
│   Kernel        │
├─────────────────┤
│   Hardware      │
└─────────────────┘

Embedded Linux:
┌─────────────────┐
│  App + Hardware │ ← Direct access!
├─────────────────┤
│   Kernel        │
├─────────────────┤
│   Hardware      │
└─────────────────┘
```

**Li Wei:** *"Embedded Linux — это минимализм. Нет X server. Нет desktop environment. Только kernel + ваши программы + hardware."*

### 📚 Теория: Что такое Embedded Linux

#### Embedded vs Desktop Linux

**Desktop/Server Linux:**
- Full OS (Ubuntu Desktop, Fedora)
- GUI (GNOME, KDE)
- Package managers (apt, dnf)
- Abstraction layers
- **Много памяти, много storage**

**Embedded Linux:**
- Minimal OS (Buildroot, Yocto, или minimal Ubuntu)
- No GUI (headless)
- Custom packages only
- Direct hardware access
- **Ограниченная память, ограниченный storage**

#### 🏠 Метафора: Автомобиль vs Космический корабль

**Desktop Linux:**
- Как автомобиль: комфорт, много функций, abstraction
- Power windows, климат-контроль, автоматика
- Если что-то сломалось — можно продолжить ехать

**Embedded Linux:**
- Как космический корабль: каждая система critical
- Прямое управление двигателями
- Если что-то сломалось — катастрофа

#### Raspberry Pi Position

Raspberry Pi — это **hybrid**:
- Достаточно мощный для full Linux (Ubuntu)
- Но с GPIO pins для direct hardware access
- **Best of both worlds для обучения embedded**

#### ARM Architecture

**x86 vs ARM:**

```
x86 (Desktop/Server):
- Intel/AMD
- CISC (Complex Instruction Set)
- Высокое энергопотребление
- Высокая производительность

ARM (Embedded):
- ARM Holdings design
- RISC (Reduced Instruction Set)
- Низкое энергопотребление  
- Достаточная производительность
```

**Raspberry Pi 4:**
- ARM Cortex-A72 (ARMv8, 64-bit)
- 4 cores @ 1.5 GHz
- Power: 5V × 3A = 15W (vs Desktop 100-300W!)

#### Boot Process

```
Power ON
    ↓
GPU bootloader (в ROM chip)
    ↓
bootcode.bin (SD card)
    ↓
start.elf (GPU firmware)
    ↓
config.txt читается
    ↓
Kernel загружается (kernel8.img)
    ↓
Device Tree применяется
    ↓
Init system (systemd)
    ↓
User space
```

**config.txt** — это как BIOS settings, но в text file!

---

### 💻 Практика: Pi Setup и First Boot

**Задание:**

1. **Flash Ubuntu на microSD:**
```bash
# Download Ubuntu for Raspberry Pi
# https://ubuntu.com/download/raspberry-pi

# Flash с Raspberry Pi Imager или:
sudo dd if=ubuntu-22.04-preinstalled-server-arm64+raspi.img of=/dev/sdX bs=4M status=progress
sync
```

2. **First Boot:**
```bash
# Insert SD в Pi, power ON
# Default credentials:
# User: ubuntu
# Pass: ubuntu (change on first login!)

# SSH access (если Pi в сети):
ssh ubuntu@raspberrypi.local
```

3. **Initial Setup:**
```bash
# Change password
passwd

# Update system
sudo apt update && sudo apt upgrade -y

# Install basics
sudo apt install -y build-essential git vim
```

4. **Check hardware:**
```bash
# CPU info
cat /proc/cpuinfo

# Memory
free -h

# GPIO info
cat /sys/kernel/debug/gpio  # если доступно

# Temperature
vcgencmd measure_temp
```

5. **Enable camera (if using):**
```bash
# Edit config
sudo nano /boot/firmware/config.txt

# Add:
# start_x=1
# gpu_mem=256

# Reboot
sudo reboot
```

---

### 🤔 Проверка понимания

**LILITH:** *"Embedded Linux использует больше RAM чем desktop Linux. True или False?"*

<details>
<summary>🤔 Embedded vs Desktop resources</summary>

**Ответ:** **FALSE!**

**Embedded Linux использует МЕНЬШЕ resources:**

**Desktop Linux (Ubuntu Desktop):**
- RAM usage: 1-2 GB idle (GUI, services)
- Storage: 10-20 GB minimum
- Processes: 200-300 running

**Embedded Linux (Minimal):**
- RAM usage: 50-200 MB idle (no GUI)
- Storage: 100-500 MB possible
- Processes: 20-50 running

**Raspberry Pi with Ubuntu Server:**
- RAM usage: ~300-500 MB idle
- Компромисс: full Ubuntu convenience + embedded access

**Почему embedded меньше:**
- No GUI (X server, desktop environment)
- Minimal packages (only needed)
- Optimized kernel config
- Custom init system

**Li Wei:** *"Embedded system на 512MB RAM может работать годами. Desktop Linux на 512MB даже не загрузится. Minimalism — это сила embedded мира."*

</details>

---

[Продолжение следует...]

*Part 1 of Episode 21 README.md*
*Циклы 2-6 + финал в следующей части*
## 🔄 Цикл 2: GPIO Basics & Pin Control (30 мин)

### 🎬 Сюжет

**Li Wei показывает GPIO pinout:**

```
Raspberry Pi GPIO (40 pins):
 1: 3.3V      2: 5V
 3: GPIO2     4: 5V
 5: GPIO3     6: GND
 7: GPIO4     8: GPIO14
 9: GND      10: GPIO15
11: GPIO17   12: GPIO18
...
```

**Li Wei:** *"40 pins. Но только ~26 GPIO. Остальные — power и ground. Каждый GPIO — это line к kernel. libgpiod library — это ваш интерфейс."*

Он подключает LED:

**Li Wei:** *"GPIO 17 → LED anode (+) → resistor 220Ω → LED cathode (-) → GND. Без resistor = boom."*

**Макс:** *"Почему resistor?"*

**Li Wei:** *"LED ток ~20mA. GPIO max 16mA. Без resistor — overcurrent, LED сгорит или GPIO повредится. Resistor ограничивает ток. Basic electronics."*

### 📚 Теория: GPIO Programming

#### What is GPIO?

**GPIO (General Purpose Input/Output):**
- Physical pins на Raspberry Pi
- Digital signals: HIGH (3.3V) или LOW (0V)
- Input mode: читать voltage (button, sensor)
- Output mode: установить voltage (LED, relay)

#### libgpiod Library

**Modern GPIO access (вместо deprecated sysfs):**

```c
#include <gpiod.h>

// 1. Open chip
struct gpiod_chip *chip = gpiod_chip_open_by_name("gpiochip0");

// 2. Get line (pin)
struct gpiod_line *line = gpiod_chip_get_line(chip, PIN_NUMBER);

// 3. Request direction
gpiod_line_request_output(line, "consumer_name", initial_value);
// or
gpiod_line_request_input(line, "consumer_name");

// 4. Use line
gpiod_line_set_value(line, 1);  // Set HIGH
int val = gpiod_line_get_value(line);  // Read value

// 5. Cleanup
gpiod_line_release(line);
gpiod_chip_close(chip);
```

#### Voltage Levels

**КРИТИЧНО:**
- Raspberry Pi GPIO: **3.3V logic**
- Arduino: 5V logic (НЕ совместимо напрямую!)
- Connect 5V sensor к Pi 3.3V pin = **Pi damage!**

**Level shifter needed для 5V devices.**

#### Current Limits

- Single GPIO pin: **16mA max**
- All GPIO combined: **50mA max**
- LED обычно 20mA — resistor обязателен!

**Ohm's Law для resistor:**
```
V = I × R
R = V / I

Для LED:
V_supply = 3.3V
V_led_forward = 2.0V (typical)
I_desired = 15mA = 0.015A

R = (3.3 - 2.0) / 0.015 = 86.7Ω
→ Use 220Ω (safe, common value)
```

---

### 💻 Практика: GPIO LED Control

**Задание:**

1. **Install libgpiod:**
```bash
sudo apt update
sudo apt install -y gpiod libgpiod-dev libgpiod2
```

2. **Complete starter code:**
```bash
cd ~/kernel-shadows/season-6-embedded-iot/episode-21-raspberry-pi/starter/c-code

# Edit gpio_control.c (complete TODOs)
nano gpio_control.c
```

3. **Key TODOs:**
```c
// TODO 1: Open chip
chip = gpiod_chip_open_by_name("gpiochip0");

// TODO 2: Get line
line = gpiod_chip_get_line(chip, LED_PIN);

// TODO 3: Request output
ret = gpiod_line_request_output(line, "gpio_control", 0);

// TODO 4: Blink
gpiod_line_set_value(line, 1);  // ON
sleep(1);
gpiod_line_set_value(line, 0);  // OFF

// TODO 5: Cleanup
gpiod_line_release(line);
gpiod_chip_close(chip);
```

4. **Compile and run:**
```bash
make
sudo ./gpio_control
```

5. **Hardware setup (if available):**
```
GPIO 17 (pin 11) → LED long leg (+)
LED short leg (-) → 220Ω resistor
Resistor → GND (pin 6)
```

**Output:**
```
=== GPIO LED Control - Episode 21 ===
✓ GPIO chip opened
✓ GPIO line 17 acquired
✓ GPIO configured as output

Blinking LED 5 times...
  [1] LED ON
  [1] LED OFF
  ...
✓ Signal complete!
✓ GPIO resources released
```

---

### 🤔 Проверка понимания

**LILITH:** *"5V Arduino sensor можно подключить к Raspberry Pi 3.3V GPIO напрямую. Safe?"*

<details>
<summary>🤔 Voltage compatibility</summary>

**Ответ:** **НЕТ! Опасно для Pi!**

**Проблема:**

**Raspberry Pi GPIO:**
- Input voltage: 3.3V max
- Output voltage: 3.3V
- **НЕ 5V tolerant!**

**Arduino (5V logic):**
- Output voltage: 5V
- Input threshold: ~2.5V

**Если подключить 5V к Pi 3.3V GPIO:**
- **Pi GPIO сгорит!**
- Internal protection diodes могут повредиться
- Возможно damage всей board

**Правильное решение:**

**Option 1: Level Shifter**
```
Arduino 5V → Level Shifter → Pi 3.3V
(Bidirectional voltage conversion)
```

**Option 2: Voltage Divider (input only)**
```
5V signal → Resistor 1kΩ → GPIO
                          ↓
                     Resistor 2kΩ
                          ↓
                         GND

Output = 5V × (2kΩ / (1kΩ + 2kΩ)) = 3.33V ✓
```

**Option 3: Use 3.3V sensor**
```
Many sensors have 3.3V variant
Check datasheet!
```

**Li Wei:** *"Voltage mismatch — это #1 причина fried Raspberry Pi. Всегда проверяй datasheets. 5V к 3.3V GPIO — это как 220V к 110V прибору. Boom."*

</details>

---

## 🔄 Цикл 3: Camera Setup & Streaming (30 мин)

### 🎬 Сюжет

**Li Wei подключает Camera Module:**

Тонкий ribbon cable. CSI connector на Pi. Click.

**Li Wei:** *"Camera Serial Interface. Direct к GPU. Hardware accelerated H.264 encoding. 1080p@30fps легко."*

**Дмитрий (видеозвонок):** *"Нам нужен live stream. К HQ. Encrypted если возможно."*

**Li Wei:** *"libcamera-vid для capture. ffmpeg для stream. TLS tunnel для encryption. Можно."*

### 📚 Теория: Raspberry Pi Camera

#### Camera Module v2

**Specs:**
- Sony IMX219 sensor
- 8 megapixels
- 1080p30, 720p60 video
- CSI-2 interface (direct to GPU)
- Hardware H.264 encoding

#### libcamera Stack

**Modern camera framework (вместо deprecated raspivid):**

```bash
# Capture image
libcamera-still -o image.jpg

# Video recording
libcamera-vid -t 10000 -o video.h264  # 10 sec

# Streaming
libcamera-vid -t 0 --inline -o - | ffmpeg -i - [stream]
```

**Parameters:**
- `-t 0`: Infinite recording
- `--inline`: Insert SPS/PPS headers (для streaming)
- `-o -`: Output to stdout (pipe to ffmpeg)

#### Streaming Options

**Method 1: UDP Stream (fast, no reliability)**
```bash
libcamera-vid -t 0 --inline -o - | \
  ffmpeg -i - -f mpegts udp://IP:PORT
```

**Method 2: TCP Stream (reliable)**
```bash
libcamera-vid -t 0 --inline --listen -o tcp://0.0.0.0:8080
```

**Method 3: RTSP (professional)**
```bash
# Requires mediamtx или rtsp-simple-server
# Stream: rtsp://IP:8554/stream
```

---

### 💻 Практика: Camera Streaming

**Задание:**

1. **Enable camera:**
```bash
# Check detection
vcgencmd get_camera
# supported=1 detected=1

# If not detected:
sudo nano /boot/firmware/config.txt
# Ensure: start_x=1, gpu_mem=256
sudo reboot
```

2. **Install camera tools:**
```bash
sudo apt install -y libcamera-apps ffmpeg
```

3. **Test capture:**
```bash
# Take photo
libcamera-still -o /tmp/test.jpg

# View (if GUI available)
# Or transfer to local machine
scp ubuntu@pi:/tmp/test.jpg .
```

4. **Complete streaming script:**
```bash
cd ~/kernel-shadows/season-6-embedded-iot/episode-21-raspberry-pi/starter

# Edit camera_stream.sh
nano camera_stream.sh
```

**Add:**
```bash
# Get Pi IP
PI_IP=$(hostname -I | awk '{print $1}')

# Start stream
libcamera-vid -t 0 \
  --width 1280 --height 720 \
  --framerate 30 \
  --inline \
  -o - | \
ffmpeg -i - \
  -c:v copy \
  -f mpegts \
  udp://192.168.1.100:8080  # Replace with HQ IP
```

5. **Run:**
```bash
bash camera_stream.sh
```

6. **View stream (на receiving машине):**
```bash
# VLC
vlc udp://@:8080

# ffplay
ffplay udp://0.0.0.0:8080
```

---

## 🔄 Цикл 4: SSH Hardening & Remote Access (20 мин)

### 🎬 Сюжет

**Алекс (видеозвонок, обеспокоенный):**

*"Li Wei, Pi будет в поле. Крылов может попытаться подключиться если найдёт. SSH hardening обязателен."*

**Li Wei:** *"Season 5 Episode 20 skills. SSH keys only. No password. Port change. Все standard precautions."*

### 📚 Теория: Embedded Security

**Embedded devices = attractive targets:**
- Often deployed remotely
- Physical access possible
- Default credentials common
- Updates neglected

**SSH Hardening essentials:**
```bash
# /etc/ssh/sshd_config
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
Port 2222  # Non-standard
AllowUsers ubuntu@192.168.1.0/24  # Whitelist
```

---

### 💻 Практика: SSH Setup

**Задание:**

1. **Generate SSH key (на local machine):**
```bash
ssh-keygen -t ed25519 -C "pi-surveillance"
```

2. **Copy key to Pi:**
```bash
ssh-copy-id ubuntu@raspberrypi.local
```

3. **Harden SSH:**
```bash
# On Pi
sudo nano /etc/ssh/sshd_config

# Apply hardening
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes

# Restart
sudo systemctl restart sshd
```

4. **Test key-only access:**
```bash
ssh ubuntu@raspberrypi.local
# Should work without password
```

---

## 🔄 Цикл 5: systemd Service & Autostart (20 мин)

### 🎬 Сюжет

**Виктор:** *"Pi будет в поле 24/7. Если power cycle — stream должен автоматически восстанавливаться. systemd service."*

**Li Wei:** *"Season 3 Episode 10 знания. systemd .service file. WantedBy=multi-user.target. Enable. Done."*

### 📚 Теория: systemd на Embedded

**Service unit file:**
```ini
[Unit]
Description=Surveillance Camera Stream
After=network.target

[Service]
Type=simple
User=ubuntu
ExecStart=/path/to/camera_stream.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

---

### 💻 Практика: Autostart

**Задание:**

1. **Create service:**
```bash
sudo nano /etc/systemd/system/surveillance.service
```

Add:
```ini
[Unit]
Description=Surveillance Camera
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu
ExecStart=/home/ubuntu/camera_stream.sh
Restart=always

[Install]
WantedBy=multi-user.target
```

2. **Enable and start:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable surveillance
sudo systemctl start surveillance
```

3. **Check status:**
```bash
sudo systemctl status surveillance
```

4. **Test autostart:**
```bash
sudo reboot
# After reboot:
sudo systemctl status surveillance
# Should be active
```

---

## 🔄 Цикл 6: Production Deployment (20 мин)

### 🎬 Сюжет — День 42, вечер

**Виктор:** *"Система готова?"*

**Макс:** *"Да. Raspberry Pi configured. GPIO signal работает. Camera stream активен. SSH hardened. systemd autostart. Всё."*

**Дмитрий:** *"Я вижу stream. 720p, 30fps, clear. Deploying сейчас."*

**Li Wei:** *"Помни: Pi в поле — это exposed system. Regular updates обязательны. Monitoring power, temperature."*

### 📚 Теория: Production Checklist

**Embedded deployment:**
- ✅ Auto-start services (systemd)
- ✅ Watchdog для crashes
- ✅ Temperature monitoring (`vcgencmd measure_temp`)
- ✅ Log rotation (limited storage!)
- ✅ Remote update mechanism
- ✅ Backup configuration

---

### 💻 Практика: Final Integration

**Задание:**

1. **Temperature monitor:**
```bash
# Add to crontab
crontab -e

# Every 5 min
*/5 * * * * vcgencmd measure_temp >> /var/log/pi_temp.log
```

2. **Log rotation:**
```bash
sudo nano /etc/logrotate.d/pi-logs

# Config
/var/log/pi_temp.log {
    daily
    rotate 7
    compress
    missingok
}
```

3. **Watchdog (optional):**
```bash
sudo apt install -y watchdog
sudo systemctl enable watchdog
```

4. **Backup config:**
```bash
# Save config
sudo cp /boot/firmware/config.txt ~/config.txt.backup
tar -czf pi-config-backup.tar.gz ~/*.backup /etc/systemd/system/surveillance.service
```

---

## 🎯 Финальное задание

### Сюжет — Deploy

**Виктор:** *"Координаты: 55.7558° N, 37.6173° E. Москва. Здание где Крылов может появиться. Установи Pi. Скрытно."*

**Макс (в Москве, 03:00):**

Крыша здания. Тёмно. Pi в waterproof case. Power от solar panel.

Camera направлена на вход. LED blinks 3 раза — signal: "I'm alive".

SSH connection к HQ. Stream начинается.

**Анна (HQ):** *"Stream received. Clear visual. Good work."*

**LILITH:** *"Embedded Linux deployed. GPIO controlled. Camera streaming. systemd managing. From junior sysadmin к embedded engineer за 5 часов. Not bad."*

---

### Итоговая работа

**Обязательно:**

- [ ] **Raspberry Pi setup complete**
  ```bash
  # Ubuntu installed
  # SSH key-only access
  # System updated
  ```

- [ ] **GPIO control program работает**
  ```bash
  cd starter/c-code
  make
  sudo ./gpio_control
  # LED должен blink 5 раз
  ```

- [ ] **Camera streaming active**
  ```bash
  bash camera_stream.sh
  # Stream видно на remote machine
  ```

- [ ] **systemd service enabled**
  ```bash
  sudo systemctl status surveillance
  # Should be active and enabled
  ```

- [ ] **Production configs applied**
  ```bash
  # /boot/firmware/config.txt оптимизирован
  # SSH hardened
  # Autostart working
  ```

**Бонус:**
- [ ] Encryption для stream (TLS/SSH tunnel)
- [ ] Multiple GPIO sensors
- [ ] Web dashboard для monitoring

---

### Критерии успеха

**Минимум (Pass):**
- ✅ Pi boots Ubuntu
- ✅ GPIO LED control компилируется и работает
- ✅ Camera stream видно
- ✅ SSH access (key-based)

**Идеально (Excellence):**
- ✅ systemd autostart работает
- ✅ Production hardening applied
- ✅ Temperature monitoring
- ✅ Stream stable 24/7
- ✅ Clean C code (no warnings)

---

## 🧪 Автотесты

```bash
cd ~/kernel-shadows/season-6-embedded-iot/episode-21-raspberry-pi
./tests/test.sh
```

Тесты проверят:
- File structure
- C code quality
- Solution completeness
- Compilation (if env available)

---

## 📚 Ресурсы

### Documentation
- **Raspberry Pi Docs:** https://www.raspberrypi.com/documentation/
- **libgpiod:** https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/
- **libcamera:** https://libcamera.org/

### Hardware
- **GPIO Pinout:** https://pinout.xyz/
- **Camera Module:** https://www.raspberrypi.com/products/camera-module-v2/

### Learning
- **Embedded Linux Primer** (book)
- **Mastering Embedded Linux Programming** (book)

---

## 🎓 Итоги Episode 21

### Что изучили

**Embedded Linux:**
- ✅ Architecture понимание
- ✅ ARM vs x86
- ✅ Boot process (bootloader, config.txt)
- ✅ systemd на embedded

**GPIO Programming:**
- ✅ libgpiod library
- ✅ C programming для hardware
- ✅ Voltage levels и current limits
- ✅ LED control practical

**Camera & Streaming:**
- ✅ libcamera framework
- ✅ H.264 encoding
- ✅ Network streaming (UDP/TCP)
- ✅ ffmpeg integration

**Production Skills:**
- ✅ SSH hardening
- ✅ systemd autostart
- ✅ Monitoring (temperature, logs)
- ✅ Remote deployment

---

## 🏆 Achievement Unlocked

**Embedded Linux Engineer! 🤖**

**Макс теперь может:**
- Setup Raspberry Pi for production
- Program GPIO hardware control
- Stream camera feed remotely
- Deploy embedded surveillance systems

**Li Wei:** *"Episode 21 — это foundation. GPIO, camera, systemd. Episode 22 — drones. MAVLink protocol. Autonomous flight. Harder. Much harder. Готов?"*

**Макс:** *"После Season 5 security hardening и сейчас embedded? Готов к чему угодно."*

**LILITH:** *"Embedded Linux — это не просто Linux. Это где software engineer становится hardware engineer. Ты теперь оба."*

---

**Status:** Episode 21 COMPLETE ✅  
**Next:** [Episode 22: Drones & UAV Control](../episode-22-drones/)  
**Season:** [Season 6: Embedded Linux & IoT](../)  
**Course:** [KERNEL SHADOWS](../../../)

---

*"Hardware — это reality check для software. Embedded Linux — это где они встречаются."* — Li Wei

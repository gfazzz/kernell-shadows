# EPISODE 11: DISK MANAGEMENT & LVM
## Season 3: System Administration | Tallinn, Estonia 🇪🇪

> *"e-Estonia работает на доверии к данным. Если диск умирает — доверие умирает."* — Kristjan Tamm

---

## 📍 Контекст миссии

**Локация:** 🇪🇪 Tallinn, Estonia
**Место:** e-Residency Center, Старый город Таллина
**День операции:** 21-22 из 60
**Время прохождения:** 4-5 часов
**Сложность:** ⭐⭐⭐⭐☆

**Персонажи:**
- **Max Sokolov** — вы, изучаете disk management
- **Kristjan Tamm** — e-Government infrastructure architect
- **Liisa Kask** — backup & recovery specialist
- **Viktor Petrov** — координатор операции
- **LILITH** — AI-помощник (я!)

---

## 🎬 Сюжет

### День 21. Переезд: Санкт-Петербург → Tallinn.

Max садится на автобус из Санкт-Петербурга в Таллин (8 часов в пути через границу). Boris провожает:

**Boris:** *"Max, ты освоил systemd. Процессы под контролем. Но процессы бессмысленны без данных. Данные живут на дисках. Без правильного disk management — ты теряешь всё."*

**Max:** *"LVM? RAID? Слышал эти термины, но никогда не работал с ними."*

**Boris:** *"Kristjan научит. В Таллине — e-Estonia. Вся страна работает онлайн. Паспорта, голосование, бизнес — всё на серверах. Если диск умирает — страна останавливается. Они знают disk management как никто."*

---

### 11:00. Tallinn. Старый город.

Max прибывает в Таллин. Средневековый город с современной IT-инфраструктурой. Встреча у e-Residency Center.

**Kristjan Tamm** (встречает Max у входа):
*"Max! Welcome to Tallinn! Viktor told me about your operation. You've learned processes, permissions, networking. Now — storage. In Estonia, we say: 'Data is the new oil'. But oil is useless if the tank leaks."*

**Max:** *"Boris said you're the best in disk management."*

**Kristjan:**
*"e-Estonia runs on trust. Citizens trust government because data is always available. Always secure. How? Redundancy. LVM for flexibility. RAID for reliability. Backups for recovery. I'll show you."*

Они проходят в серверную e-Residency. Десятки серверов, мигающие индикаторы дисков.

**Kristjan:**
*"Here we store digital identities of 100,000+ e-residents. Disk failure? Not an option. Downtime? Not acceptable. Let me introduce you to Liisa."*

**Liisa Kask** (backup engineer, headphones на шее, laptop с monitoring dashboard):
*"Max? Viktor said you're good with scripts. Perfect. We need someone who understands automation. Disk management without automation — это chaos."*

---

### 12:00. Emergency call.

Внезапно — alarm на monitoring dashboard Liisa.

**Liisa** (резко встаёт):
*"Disk failure on production server! `/dev/sdb` — one of our data drives. SMART reports critical errors. We have maybe 2-3 hours before complete failure."*

**Kristjan:**
*"Max, you're about to learn disk management the hard way. Real incident. We need to:
1. Check disk health (SMART status)
2. Migrate data to new disk (before failure)
3. Set up LVM properly (for future flexibility)
4. Configure RAID (redundancy for next time)
5. Test recovery procedures"*

**Max:** *"I've never done this before..."*

**Kristjan:**
*"Perfect time to learn. In production. Under pressure. Just like real sysadmin work. Don't worry — we have backups. Probably."*

**Liisa** (улыбается):
*"Kristjan loves 'learning by fire'. But seriously, I'll guide you. Disk management is critical. Mistakes here — and you lose everything."*

---

## 🎯 Твоя миссия

Научиться **управлять дисками, LVM, RAID** на production сервере.

**Цель:**
- Понять как работают диски в Linux
- Научиться создавать partitions и filesystems
- Освоить LVM (Logical Volume Manager)
- Настроить RAID для redundancy
- Правильно монтировать filesystems
- Провести миграцию данных с failing disk

**Итог:** Production-ready disk management с redundancy и monitoring.

---

## 📝 Задания

### Задание 1: Disk Health Check — SMART monitoring
**Цель:** Проверить здоровье дисков и найти failing disk

**Что нужно сделать:**
1. Список всех дисков в системе (`lsblk`, `fdisk -l`)
2. Проверить SMART status (`smartctl`)
3. Найти диск с ошибками
4. Определить тип disk (HDD vs SSD)
5. Проверить I/O statistics

<details>
<summary>💡 Подсказка 1 (после 5 минут размышлений)</summary>

Основные команды для disk inspection:
- `lsblk` — tree view всех block devices
- `fdisk -l` — detailed partition information
- `df -h` — mounted filesystems
- `smartctl -a /dev/sdX` — SMART health status
- `iostat` — I/O statistics

Проверь:
- Какие диски есть в системе?
- Какие диски смонтированы?
- Есть ли SMART ошибки?
- Какой диск failing?

</details>

<details>
<summary>💡 Подсказка 2 (после 10 минут)</summary>

Детальная проверка:

```bash
# Список всех block devices
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,MODEL

# SMART status (requires smartmontools)
sudo apt install smartmontools
sudo smartctl -H /dev/sda  # Health status
sudo smartctl -a /dev/sda  # All SMART data

# I/O statistics
iostat -x 1 5  # 5 samples, 1 sec interval

# Disk errors in kernel log
dmesg | grep -i "error\|fail" | grep sd
```

Ищи:
- `SMART overall-health self-assessment test result: FAILED`
- High `Reallocated_Sector_Ct` (плохие сектора)
- `Current_Pending_Sector` (pending reallocation)
- Kernel messages: "I/O error"

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

echo "=== Disk Health Check ==="

# 1. List all block devices
echo -e "\n1. Block Devices:"
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL

# 2. Detailed disk information
echo -e "\n2. Detailed Disk Info:"
sudo fdisk -l | grep "Disk /dev/sd"

# 3. Mounted filesystems
echo -e "\n3. Mounted Filesystems:"
df -h | grep "^/dev"

# 4. Check SMART status for all disks
echo -e "\n4. SMART Health Check:"
for disk in /dev/sd?; do
    if [[ -b "$disk" ]]; then
        echo "Checking $disk..."
        sudo smartctl -H "$disk" 2>/dev/null | grep -E "SMART|result"

        # Check critical SMART attributes
        sudo smartctl -A "$disk" 2>/dev/null | grep -E "Reallocated_Sector|Current_Pending|Offline_Uncorrectable"
    fi
done

# 5. Check kernel log for disk errors
echo -e "\n5. Kernel Disk Errors:"
dmesg | grep -i "error\|fail" | grep "sd[a-z]" | tail -10

# 6. I/O statistics
echo -e "\n6. I/O Statistics:"
iostat -x 1 3 | grep "sd[a-z]"
```

**Kristjan:** *"If SMART says FAIL — replace disk immediately. Don't wait."*

**Liisa:** *"I've seen people ignore SMART warnings. Disk died 2 hours later. All data gone."*

</details>

---

### Задание 2: Partitioning — создать partition на новом диске
**Цель:** Подготовить новый диск для замены failing disk

**Требования:**
- Создать GPT partition table
- Создать partition на весь диск
- Установить правильный type (Linux LVM)

<details>
<summary>💡 Подсказка 1</summary>

Partitioning tools:
- `fdisk` — classic (MBR + GPT)
- `parted` — more powerful (GPT focus)
- `gdisk` — GPT-only
- `cfdisk` — interactive TUI

Для современных систем: **GPT** (GUID Partition Table)
- Supports disks > 2TB
- More reliable
- No primary/extended/logical limitations

Шаги:
1. Identify new disk (`/dev/sdc`)
2. Create GPT table
3. Create partition
4. Set type to Linux LVM (code 8e)

</details>

<details>
<summary>💡 Подсказка 2</summary>

Partitioning с `parted`:

```bash
# Создать GPT table
sudo parted /dev/sdc mklabel gpt

# Создать partition на весь диск
sudo parted /dev/sdc mkpart primary 0% 100%

# Установить LVM flag
sudo parted /dev/sdc set 1 lvm on

# Проверить
sudo parted /dev/sdc print
```

Или с `fdisk`:

```bash
sudo fdisk /dev/sdc
  g    # create GPT table
  n    # new partition
  1    # partition number
  <enter> # default start
  <enter> # default end (full disk)
  t    # change type
  31   # Linux LVM (or 8e for MBR)
  w    # write changes

# Проверить
sudo fdisk -l /dev/sdc
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

NEW_DISK="/dev/sdc"

echo "=== Creating Partition on $NEW_DISK ==="

# Safety check
if [[ ! -b "$NEW_DISK" ]]; then
    echo "Error: $NEW_DISK not found"
    exit 1
fi

# Check if disk already has partitions
if lsblk "$NEW_DISK" | grep -q part; then
    echo "Warning: $NEW_DISK already has partitions"
    read -p "Wipe and recreate? (yes/no): " confirm
    if [[ "$confirm" != "yes" ]]; then
        exit 1
    fi
fi

# Create GPT partition table
echo "Creating GPT partition table..."
sudo parted "$NEW_DISK" mklabel gpt

# Create partition (full disk)
echo "Creating partition..."
sudo parted "$NEW_DISK" mkpart primary 0% 100%

# Set LVM flag
echo "Setting LVM type..."
sudo parted "$NEW_DISK" set 1 lvm on

# Verify
echo -e "\n=== Partition Table ==="
sudo parted "$NEW_DISK" print

# Update kernel partition table
sudo partprobe "$NEW_DISK"

echo "✓ Partition ${NEW_DISK}1 created successfully"
```

**Kristjan:** *"Always use GPT for new disks. MBR is legacy. 2TB limit is not acceptable in 2025."*

</details>

---

### Задание 3: LVM Setup — Physical Volume, Volume Group, Logical Volume
**Цель:** Создать LVM структуру для гибкого управления storage

**LVM hierarchy:**
```
Physical Disk (/dev/sdc)
  └─ Partition (/dev/sdc1)
      └─ Physical Volume (PV)
          └─ Volume Group (VG)
              └─ Logical Volume (LV)
                  └─ Filesystem (ext4)
```

**Задачи:**
1. Создать Physical Volume (PV)
2. Создать Volume Group (VG)
3. Создать Logical Volume (LV)
4. Создать filesystem

<details>
<summary>💡 Подсказка 1</summary>

LVM commands:
- **Physical Volume:**
  - `pvcreate` — create PV
  - `pvdisplay` — show PVs
  - `pvs` — short PV list

- **Volume Group:**
  - `vgcreate` — create VG
  - `vgdisplay` — show VGs
  - `vgs` — short VG list
  - `vgextend` — add PV to VG

- **Logical Volume:**
  - `lvcreate` — create LV
  - `lvdisplay` — show LVs
  - `lvs` — short LV list
  - `lvresize` — resize LV

Naming convention:
- VG: `vg_data`, `vg_backups`
- LV: `lv_data`, `lv_logs`

</details>

<details>
<summary>💡 Подсказка 2</summary>

LVM setup step by step:

```bash
# 1. Create Physical Volume
sudo pvcreate /dev/sdc1
sudo pvdisplay

# 2. Create Volume Group
sudo vgcreate vg_data /dev/sdc1
sudo vgdisplay vg_data

# 3. Create Logical Volume (80% of VG space)
sudo lvcreate -l 80%FREE -n lv_data vg_data
sudo lvdisplay /dev/vg_data/lv_data

# 4. Create filesystem (ext4)
sudo mkfs.ext4 /dev/vg_data/lv_data

# 5. Mount
sudo mkdir -p /mnt/data
sudo mount /dev/vg_data/lv_data /mnt/data
```

Почему LVM?
- **Resize:** увеличить/уменьшить LV без переразбиения диска
- **Snapshots:** моментальные снимки для backups
- **Multiple PVs:** объединить несколько дисков в один VG

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

PARTITION="/dev/sdc1"
VG_NAME="vg_data"
LV_NAME="lv_data"
LV_SIZE="80%FREE"  # Leave 20% for snapshots
MOUNT_POINT="/mnt/data"

echo "=== LVM Setup ==="

# 1. Create Physical Volume
echo "Creating Physical Volume..."
sudo pvcreate "$PARTITION"

echo -e "\nPhysical Volumes:"
sudo pvdisplay "$PARTITION"

# 2. Create Volume Group
echo -e "\nCreating Volume Group: $VG_NAME..."
sudo vgcreate "$VG_NAME" "$PARTITION"

echo -e "\nVolume Groups:"
sudo vgdisplay "$VG_NAME"

# 3. Create Logical Volume
echo -e "\nCreating Logical Volume: $LV_NAME..."
sudo lvcreate -l "$LV_SIZE" -n "$LV_NAME" "$VG_NAME"

echo -e "\nLogical Volumes:"
sudo lvdisplay "/dev/$VG_NAME/$LV_NAME"

# 4. Create filesystem
echo -e "\nCreating ext4 filesystem..."
sudo mkfs.ext4 -L "DATA" "/dev/$VG_NAME/$LV_NAME"

# 5. Create mount point
echo -e "\nCreating mount point: $MOUNT_POINT..."
sudo mkdir -p "$MOUNT_POINT"

# 6. Mount
echo "Mounting..."
sudo mount "/dev/$VG_NAME/$LV_NAME" "$MOUNT_POINT"

# 7. Verify
echo -e "\n=== Verification ==="
echo "Mounted filesystems:"
df -h | grep "$MOUNT_POINT"

echo -e "\nLVM summary:"
sudo vgs
sudo lvs

echo "✓ LVM setup complete"
```

**Kristjan:** *"LVM is like virtualization for storage. One disk looks like many. Many disks look like one."*

**Liisa:** *"Always leave 20% free space for snapshots. Snapshot before major changes — lifesaver."*

</details>

---

### Задание 4: Data Migration — копирование данных с failing disk
**Цель:** Скопировать данные до того как диск окончательно умрёт

**Требования:**
- Смонтировать старый диск (read-only)
- Скопировать данные на новый LVM volume
- Проверить целостность (checksums)
- Unmount старый диск

<details>
<summary>💡 Подсказка 1</summary>

Data migration tools:
- `rsync` — incremental copy, preserves permissions
- `cp -a` — archive mode (permissions, timestamps)
- `dd` — block-level copy (для полного клонирования)

Best practice:
```bash
# Mount old disk read-only (защита от случайных изменений)
sudo mount -o ro /dev/sdb1 /mnt/old_data

# Copy with rsync (best)
sudo rsync -avP /mnt/old_data/ /mnt/data/

# Verify checksums
find /mnt/old_data -type f -exec md5sum {} \; > /tmp/old_checksums.txt
find /mnt/data -type f -exec md5sum {} \; > /tmp/new_checksums.txt
diff /tmp/old_checksums.txt /tmp/new_checksums.txt
```

</details>

<details>
<summary>💡 Подсказка 2</summary>

Полный процесс миграции:

```bash
# 1. Mount old disk (read-only!)
sudo mkdir -p /mnt/old_data
sudo mount -o ro /dev/sdb1 /mnt/old_data

# 2. Check space
du -sh /mnt/old_data
df -h /mnt/data

# 3. Copy with progress
sudo rsync -avP --stats /mnt/old_data/ /mnt/data/

# Options:
#   -a archive (preserve permissions, timestamps, etc)
#   -v verbose
#   -P progress + partial (resume if interrupted)
#   --stats show statistics

# 4. Verify
echo "Old disk files:"
find /mnt/old_data -type f | wc -l

echo "New disk files:"
find /mnt/data -type f | wc -l

# 5. Checksum verification (важно!)
echo "Generating checksums..."
cd /mnt/old_data && find . -type f -exec md5sum {} \; | sort > /tmp/old.md5
cd /mnt/data && find . -type f -exec md5sum {} \; | sort > /tmp/new.md5

diff /tmp/old.md5 /tmp/new.md5
if [[ $? -eq 0 ]]; then
    echo "✓ Checksums match — migration successful"
else
    echo "✗ Checksum mismatch!"
fi

# 6. Unmount old disk
sudo umount /mnt/old_data
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

OLD_DISK="/dev/sdb1"
OLD_MOUNT="/mnt/old_data"
NEW_MOUNT="/mnt/data"

echo "=== Data Migration from Failing Disk ==="

# 1. Mount old disk (READ-ONLY!)
echo "Mounting old disk (read-only)..."
sudo mkdir -p "$OLD_MOUNT"
if sudo mount -o ro "$OLD_DISK" "$OLD_MOUNT"; then
    echo "✓ Old disk mounted"
else
    echo "✗ Failed to mount old disk"
    exit 1
fi

# 2. Check available space
echo -e "\n=== Space Check ==="
OLD_SIZE=$(du -sb "$OLD_MOUNT" | awk '{print $1}')
NEW_AVAIL=$(df -B1 "$NEW_MOUNT" | tail -1 | awk '{print $4}')

echo "Old disk data: $(numfmt --to=iec $OLD_SIZE)"
echo "New disk available: $(numfmt --to=iec $NEW_AVAIL)"

if [[ $OLD_SIZE -gt $NEW_AVAIL ]]; then
    echo "✗ Not enough space on new disk!"
    sudo umount "$OLD_MOUNT"
    exit 1
fi

# 3. Copy data with rsync
echo -e "\n=== Copying Data ==="
echo "This may take several minutes..."

sudo rsync -avP --stats "$OLD_MOUNT/" "$NEW_MOUNT/"

if [[ $? -ne 0 ]]; then
    echo "✗ Copy failed!"
    exit 1
fi

# 4. Verify file counts
echo -e "\n=== Verification ==="
OLD_COUNT=$(find "$OLD_MOUNT" -type f | wc -l)
NEW_COUNT=$(find "$NEW_MOUNT" -type f | wc -l)

echo "Files on old disk: $OLD_COUNT"
echo "Files on new disk: $NEW_COUNT"

if [[ $OLD_COUNT -ne $NEW_COUNT ]]; then
    echo "⚠ File count mismatch!"
fi

# 5. Checksum verification
echo -e "\nVerifying checksums (may take time)..."
cd "$OLD_MOUNT" && find . -type f -exec md5sum {} \; 2>/dev/null | sort > /tmp/old_checksums.txt
cd "$NEW_MOUNT" && find . -type f -exec md5sum {} \; 2>/dev/null | sort > /tmp/new_checksums.txt

if diff /tmp/old_checksums.txt /tmp/new_checksums.txt > /dev/null; then
    echo "✓ Checksums match — data integrity verified"
else
    echo "✗ Checksum mismatch — data corruption detected!"
    exit 1
fi

# 6. Unmount old disk
echo -e "\n=== Cleanup ==="
sudo umount "$OLD_MOUNT"
echo "✓ Old disk unmounted"

echo -e "\n✓ Data migration complete and verified!"
echo "Old disk can now be safely removed"
```

**Kristjan:** *"Always mount old disk read-only. One accidental rm -rf and everything is gone."*

**Liisa:** *"Checksum verification is NOT optional. I've seen 'successful' migrations with corrupted files."*

</details>

---

### Задание 5: RAID Configuration — redundancy для критических данных
**Цель:** Настроить RAID1 (mirroring) для redundancy

**RAID levels:**
- **RAID 0:** Striping (performance, no redundancy)
- **RAID 1:** Mirroring (redundancy, 50% capacity)
- **RAID 5:** Striping + parity (N-1 drives capacity, 1 drive failure tolerance)
- **RAID 10:** Mirror + Stripe (50% capacity, high performance)

**Задача:** Создать RAID1 из 2 дисков

<details>
<summary>💡 Подсказка 1</summary>

RAID в Linux: **mdadm** (multiple device admin)

Основные команды:
```bash
# Install mdadm
sudo apt install mdadm

# Create RAID1
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdd1 /dev/sde1

# Check status
cat /proc/mdstat
sudo mdadm --detail /dev/md0

# Save configuration
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u
```

RAID1 (mirroring):
- Минимум 2 диска
- Данные дублируются на оба диска
- Capacity = размер одного диска
- Выживает failure одного диска

</details>

<details>
<summary>💡 Подсказка 2</summary>

Полный RAID setup:

```bash
# 1. Prepare partitions
sudo parted /dev/sdd mklabel gpt
sudo parted /dev/sdd mkpart primary 0% 100%
sudo parted /dev/sdd set 1 raid on

sudo parted /dev/sde mklabel gpt
sudo parted /dev/sde mkpart primary 0% 100%
sudo parted /dev/sde set 1 raid on

# 2. Create RAID1
sudo mdadm --create /dev/md0 \
    --level=1 \
    --raid-devices=2 \
    /dev/sdd1 /dev/sde1

# 3. Wait for sync
watch cat /proc/mdstat

# 4. Create filesystem
sudo mkfs.ext4 /dev/md0

# 5. Mount
sudo mkdir -p /mnt/raid
sudo mount /dev/md0 /mnt/raid

# 6. Save config
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u

# 7. Auto-mount (add to /etc/fstab)
echo "/dev/md0 /mnt/raid ext4 defaults 0 2" | sudo tee -a /etc/fstab
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

DISK1="/dev/sdd"
DISK2="/dev/sde"
RAID_DEVICE="/dev/md0"
MOUNT_POINT="/mnt/raid"

echo "=== RAID1 Configuration ==="

# Safety check
for disk in "$DISK1" "$DISK2"; do
    if [[ ! -b "$disk" ]]; then
        echo "Error: $disk not found"
        exit 1
    fi
done

# 1. Prepare partitions
echo "Preparing partitions..."
for disk in "$DISK1" "$DISK2"; do
    echo "  Processing $disk..."
    sudo parted "$disk" mklabel gpt
    sudo parted "$disk" mkpart primary 0% 100%
    sudo parted "$disk" set 1 raid on
done

sudo partprobe

# 2. Create RAID1 array
echo -e "\nCreating RAID1 array..."
sudo mdadm --create "$RAID_DEVICE" \
    --level=1 \
    --raid-devices=2 \
    "${DISK1}1" "${DISK2}1" \
    --assume-clean  # Skip initial resync for demo

# 3. Check RAID status
echo -e "\n=== RAID Status ==="
cat /proc/mdstat
sudo mdadm --detail "$RAID_DEVICE"

# 4. Create filesystem
echo -e "\nCreating ext4 filesystem..."
sudo mkfs.ext4 -L "RAID_DATA" "$RAID_DEVICE"

# 5. Create mount point and mount
echo "Mounting RAID array..."
sudo mkdir -p "$MOUNT_POINT"
sudo mount "$RAID_DEVICE" "$MOUNT_POINT"

# 6. Verify
echo -e "\n=== Verification ==="
df -h | grep "$MOUNT_POINT"

# 7. Save RAID configuration
echo -e "\nSaving RAID configuration..."
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u

# 8. Add to fstab (persistent mount)
if ! grep -q "$RAID_DEVICE" /etc/fstab; then
    echo "$RAID_DEVICE $MOUNT_POINT ext4 defaults 0 2" | sudo tee -a /etc/fstab
    echo "✓ Added to /etc/fstab"
fi

echo -e "\n✓ RAID1 setup complete"
echo "  Device: $RAID_DEVICE"
echo "  Mount: $MOUNT_POINT"
echo "  Redundancy: 1 disk can fail without data loss"
```

**Kristjan:** *"RAID is NOT backup. RAID protects from disk failure, not from rm -rf or ransomware."*

**Liisa:** *"RAID1 saved us twice. Disk failed at 3 AM. Service continued. Replaced disk next morning."*

</details>

---

### Задание 6: Filesystem Management — ext4, xfs, monitoring
**Цель:** Понять разные filesystems и их особенности

**Filesystems:**
- **ext4:** Default для Linux, reliable, mature
- **xfs:** High-performance, large files, no shrink
- **btrfs:** Copy-on-write, snapshots, compression
- **zfs:** Advanced features, не в mainline kernel

**Задачи:**
1. Создать разные filesystems
2. Сравнить performance
3. Настроить mount options
4. Включить quotas

<details>
<summary>💡 Подсказка 1</summary>

Filesystem creation:

```bash
# ext4 (default)
sudo mkfs.ext4 /dev/vg_data/lv_data

# xfs (high performance)
sudo mkfs.xfs /dev/vg_data/lv_logs

# btrfs (advanced features)
sudo mkfs.btrfs /dev/vg_data/lv_snapshots
```

Mount options (в `/etc/fstab`):
```
/dev/vg_data/lv_data /mnt/data ext4 defaults,noatime 0 2
```

- `noatime` — не обновлять access time (performance boost)
- `nodiratime` — то же для directories
- `discard` — TRIM для SSD
- `usrquota,grpquota` — enable quotas

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

echo "=== Filesystem Management ==="

# 1. Create different filesystems on LVs
echo "Creating filesystems..."

# ext4 for data
sudo mkfs.ext4 -L "DATA" /dev/vg_data/lv_data

# xfs for logs (better for sequential writes)
if lsblk | grep -q lv_logs; then
    sudo mkfs.xfs -L "LOGS" /dev/vg_data/lv_logs
fi

# 2. Mount with optimized options
echo -e "\nMounting with optimized options..."
sudo mkdir -p /mnt/data
sudo mount -o noatime,nodiratime /dev/vg_data/lv_data /mnt/data

# 3. Add to /etc/fstab
echo -e "\nUpdating /etc/fstab..."
echo "/dev/vg_data/lv_data /mnt/data ext4 defaults,noatime 0 2" | sudo tee -a /etc/fstab

# 4. Enable quotas (optional)
# sudo tune2fs -O quota /dev/vg_data/lv_data
# sudo mount -o remount,usrquota,grpquota /mnt/data

# 5. Filesystem info
echo -e "\n=== Filesystem Info ==="
sudo tune2fs -l /dev/vg_data/lv_data | grep -E "Filesystem|Block count|Block size"

echo "✓ Filesystem management complete"
```

</details>

---

### Задание 7: Итоговый отчёт — Disk Management Audit
**Цель:** Создать comprehensive отчёт для Viktor

**Отчёт должен включать:**
1. Disk health status (all disks)
2. LVM configuration (PV, VG, LV)
3. RAID status
4. Mounted filesystems
5. Space usage
6. Backup recommendations

<details>
<summary>✅ Решение</summary>

См. solution/disk_manager.sh для полного кода генерации отчёта.

</details>

---

## 📚 Теория: Disk Management & LVM

### 1. Block Devices в Linux

**Block device** — устройство которое хранит данные блоками (обычно 512 bytes или 4KB).

**Hierarchy:**
```
/dev/sda              # Physical disk
  ├─ /dev/sda1        # Partition 1
  └─ /dev/sda2        # Partition 2
```

**Naming convention:**
- `/dev/sda`, `/dev/sdb` — SATA/SCSI disks
- `/dev/nvme0n1` — NVMe SSD
- `/dev/vda` — Virtual disk (VM)
- `/dev/md0` — RAID array

---

### 2. Partitioning

**Partition table types:**

| Type | Max Size | Max Partitions | Modern? |
|------|----------|----------------|---------|
| MBR | 2 TB | 4 primary | ❌ Legacy |
| GPT | 9.4 ZB | 128 | ✅ Modern |

**Partitioning tools:**
- `fdisk` — classic (MBR + GPT)
- `parted` — powerful (GPT focus)
- `gdisk` — GPT-only
- `cfdisk` — interactive TUI

---

### 3. LVM (Logical Volume Manager)

**LVM advantages:**
- ✅ Resize volumes online (не нужно reboot)
- ✅ Snapshots (для backups)
- ✅ Stripe across multiple disks
- ✅ Thin provisioning

**LVM architecture:**
```
Physical Disks → Physical Volumes (PV) → Volume Groups (VG) → Logical Volumes (LV) → Filesystems
```

**Commands:**
```bash
# Physical Volume
pvcreate /dev/sda1
pvdisplay
pvs

# Volume Group
vgcreate vg_data /dev/sda1
vgextend vg_data /dev/sdb1  # add another PV
vgdisplay
vgs

# Logical Volume
lvcreate -L 10G -n lv_data vg_data
lvresize -L +5G /dev/vg_data/lv_data
lvdisplay
lvs

# Snapshots
lvcreate -L 2G -s -n lv_data_snap /dev/vg_data/lv_data
```

---

### 4. RAID

**RAID levels:**

| Level | Disks | Capacity | Failure Tolerance | Use Case |
|-------|-------|----------|-------------------|----------|
| RAID 0 | 2+ | 100% | None | Performance |
| RAID 1 | 2 | 50% | 1 disk | Redundancy |
| RAID 5 | 3+ | (N-1)/N | 1 disk | Balance |
| RAID 6 | 4+ | (N-2)/N | 2 disks | High redundancy |
| RAID 10 | 4+ | 50% | 1 per mirror | Performance + redundancy |

**mdadm commands:**
```bash
# Create RAID1
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1

# Check status
cat /proc/mdstat
mdadm --detail /dev/md0

# Add spare
mdadm --add /dev/md0 /dev/sdc1

# Remove failed disk
mdadm --fail /dev/md0 /dev/sda1
mdadm --remove /dev/md0 /dev/sda1

# Save config
mdadm --detail --scan >> /etc/mdadm/mdadm.conf
```

---

### 5. Filesystems

**Common Linux filesystems:**

| FS | Features | Best For |
|----|----------|----------|
| ext4 | Reliable, journaling, resize | General purpose |
| xfs | High performance, large files | Databases, logs |
| btrfs | CoW, snapshots, compression | Advanced features |
| zfs | Everything, but not mainline | Enterprise (if you can use it) |

**Filesystem commands:**
```bash
# Create
mkfs.ext4 /dev/vg_data/lv_data
mkfs.xfs /dev/vg_data/lv_logs

# Check
fsck /dev/sda1

# Tune
tune2fs -l /dev/sda1  # info
tune2fs -O quota /dev/sda1  # enable quotas

# Resize
resize2fs /dev/vg_data/lv_data  # ext4
xfs_growfs /mnt/logs  # xfs (cannot shrink!)
```

---

### 6. Mount & /etc/fstab

**Mount options:**
```bash
# Temporary mount
mount /dev/vg_data/lv_data /mnt/data

# With options
mount -o noatime,nodiratime /dev/vg_data/lv_data /mnt/data

# Remount with new options
mount -o remount,ro /mnt/data

# Unmount
umount /mnt/data
```

**/etc/fstab format:**
```
<device> <mount_point> <type> <options> <dump> <pass>
/dev/vg_data/lv_data /mnt/data ext4 defaults,noatime 0 2
```

**Options:**
- `defaults` — rw, suid, dev, exec, auto, nouser, async
- `noatime` — don't update access time (performance)
- `nodiratime` — don't update directory access time
- `discard` — TRIM for SSD
- `usrquota,grpquota` — enable quotas

**dump:** 0 = no backup, 1 = backup
**pass:** 0 = no fsck, 1 = fsck first (root), 2 = fsck after root

---

### 7. SMART Monitoring

**SMART (Self-Monitoring, Analysis, and Reporting Technology)**

**Install:**
```bash
sudo apt install smartmontools
```

**Commands:**
```bash
# Health check
smartctl -H /dev/sda

# All SMART data
smartctl -a /dev/sda

# Run self-test
smartctl -t short /dev/sda
smartctl -t long /dev/sda

# Check test results
smartctl -l selftest /dev/sda
```

**Critical SMART attributes:**
- `Reallocated_Sector_Ct` — bad sectors remapped
- `Current_Pending_Sector` — sectors waiting for remap
- `Offline_Uncorrectable` — uncorrectable sectors
- `Temperature_Celsius` — disk temperature

**When to replace:**
- `SMART overall-health: FAILED`
- Reallocated sectors > 0 and growing
- Current pending > 0
- Temperature > 55°C (HDD) or > 70°C (SSD)

---

## 🎯 Итоги Episode 11

### Что вы освоили:

✅ **Disk Management:**
   - lsblk, fdisk, parted
   - GPT vs MBR
   - SMART monitoring

✅ **LVM (Logical Volume Manager):**
   - Physical Volumes (PV)
   - Volume Groups (VG)
   - Logical Volumes (LV)
   - Snapshots

✅ **RAID:**
   - mdadm
   - RAID levels (0, 1, 5, 10)
   - Redundancy strategies

✅ **Filesystems:**
   - ext4, xfs, btrfs
   - mkfs, tune2fs, resize2fs
   - Mount options

✅ **Data Migration:**
   - rsync
   - Checksum verification
   - Read-only mounts

✅ **Production Skills:**
   - Disk failure response
   - Zero-downtime migration
   - Redundancy planning

---

### Сюжетный итог:

**Kristjan:** *"Max, you did well. Disk failed. Data survived. That's what matters. LVM gives flexibility. RAID gives redundancy. Together — reliability."*

**Liisa:** *"I've seen many sysadmins lose data. You didn't. You verified checksums. You used read-only mounts. Professional."*

**Viktor (видеозвонок):**
*"Отлично. Tallinn — готово. Disk management — критический навык. Без данных система бесполезна. Next: Amsterdam. Тебя ждёт Hans Müller. Docker и контейнеризация. Season 4 начинается."*

**Max:** *"LVM... RAID... Раньше казалось сложным. Теперь понимаю. Это просто инструменты для надёжности."*

---

**LILITH:**
*"Диски — это фундамент. Процессы работают в памяти, но умирают при reboot. Данные на дисках — permanent. Ты научился защищать данные. LVM для гибкости. RAID для redundancy. Snapshots для безопасности. Next: контейнеры. Docker изолирует процессы. Kubernetes оркестрирует их. Готовься."*

---

## 📖 Дополнительные ресурсы

### Man pages:
```bash
man lsblk
man fdisk
man parted
man pvcreate
man vgcreate
man lvcreate
man mdadm
man mkfs.ext4
man mount
man fstab
man smartctl
```

### Online:
- [LVM HOWTO](https://tldp.org/HOWTO/LVM-HOWTO/)
- [Linux RAID Wiki](https://raid.wiki.kernel.org/)
- [Arch Wiki: LVM](https://wiki.archlinux.org/title/LVM)
- [Red Hat: LVM Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_logical_volumes/)

---

<div align="center">

**Next:** [Episode 12: Logs & Monitoring](../episode-12-logs-monitoring/) → Still in Tallinn 🇪🇪

*"Данные без backup — это не данные. Это временные файлы."*

**Day 21-22 / 60 Complete! 🎉**

</div>



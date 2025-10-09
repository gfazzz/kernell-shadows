#!/bin/bash
################################################################################
# KERNEL SHADOWS - Episode 11: Disk Management & LVM
# Season 3: System Administration
# Starter Script Template
################################################################################
#
# Mission: Disk Management, LVM, RAID Configuration
# Location: Tallinn, Estonia
# Mentors: Kristjan Tamm (e-Gov architect), Liisa Kask (backup specialist)
#
# Your tasks:
#   1. Disk health check (SMART monitoring)
#   2. Partitioning (GPT)
#   3. LVM setup (PV, VG, LV)
#   4. Data migration (from failing disk)
#   5. RAID configuration
#   6. Filesystem management
#   7. Generate audit report
#
# Hints:
#   - Use lsblk, fdisk, parted for disk inspection
#   - LVM: pvcreate, vgcreate, lvcreate
#   - RAID: mdadm for RAID arrays
#   - Always verify data integrity (checksums!)
#   - SMART: smartctl for disk health
#
################################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
NEW_DISK="/dev/sdc"
OLD_DISK="/dev/sdb"
RAID_DISK1="/dev/sdd"
RAID_DISK2="/dev/sde"
VG_NAME="vg_data"
LV_NAME="lv_data"
MOUNT_POINT="/mnt/data"
RAID_MOUNT="/mnt/raid"
REPORT_FILE="/var/operations/disk_audit_ep11.txt"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  KERNEL SHADOWS - Episode 11${NC}"
echo -e "${BLUE}  Disk Management & LVM${NC}"
echo -e "${BLUE}========================================${NC}"
echo

################################################################################
# Task 1: Disk Health Check
################################################################################

disk_health_check() {
    echo -e "${YELLOW}=== Task 1: Disk Health Check ===${NC}"

    # TODO: List all block devices
    # Hint: lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL

    # TODO: Check SMART status for all disks
    # Hint: smartctl -H /dev/sdX
    # Hint: smartctl -A /dev/sdX | grep -E "Reallocated|Pending|Uncorrectable"

    # TODO: Check for disk errors in kernel log
    # Hint: dmesg | grep -i "error\|fail" | grep "sd[a-z]"

    # TODO: Check I/O statistics
    # Hint: iostat -x 1 3

    echo "TODO: Implement disk health check"
    echo "      Check README.md Task 1 for hints"
}

################################################################################
# Task 2: Partitioning
################################################################################

create_partition() {
    echo -e "${YELLOW}=== Task 2: Create Partition ===${NC}"

    local disk="$NEW_DISK"

    # TODO: Check if disk exists
    # Hint: if [[ ! -b "$disk" ]]; then

    # TODO: Create GPT partition table
    # Hint: parted $disk mklabel gpt

    # TODO: Create partition (full disk)
    # Hint: parted $disk mkpart primary 0% 100%

    # TODO: Set LVM type
    # Hint: parted $disk set 1 lvm on

    # TODO: Update kernel partition table
    # Hint: partprobe $disk

    # TODO: Verify partition created
    # Hint: parted $disk print

    echo "TODO: Implement partitioning"
    echo "      Check README.md Task 2 for hints"
}

################################################################################
# Task 3: LVM Setup
################################################################################

setup_lvm() {
    echo -e "${YELLOW}=== Task 3: LVM Setup ===${NC}"

    local partition="${NEW_DISK}1"

    # TODO: Create Physical Volume
    # Hint: pvcreate $partition
    # Hint: pvdisplay

    # TODO: Create Volume Group
    # Hint: vgcreate $VG_NAME $partition
    # Hint: vgdisplay $VG_NAME

    # TODO: Create Logical Volume (80% of space)
    # Hint: lvcreate -l 80%FREE -n $LV_NAME $VG_NAME
    # Hint: lvdisplay /dev/$VG_NAME/$LV_NAME

    # TODO: Create filesystem (ext4)
    # Hint: mkfs.ext4 /dev/$VG_NAME/$LV_NAME

    # TODO: Create mount point and mount
    # Hint: mkdir -p $MOUNT_POINT
    # Hint: mount /dev/$VG_NAME/$LV_NAME $MOUNT_POINT

    # TODO: Verify mounted
    # Hint: df -h | grep $MOUNT_POINT

    echo "TODO: Implement LVM setup"
    echo "      Check README.md Task 3 for hints"
}

################################################################################
# Task 4: Data Migration
################################################################################

migrate_data() {
    echo -e "${YELLOW}=== Task 4: Data Migration ===${NC}"

    local old_mount="/mnt/old_data"

    # TODO: Mount old disk (READ-ONLY!)
    # Hint: mkdir -p $old_mount
    # Hint: mount -o ro ${OLD_DISK}1 $old_mount

    # TODO: Check space
    # Hint: du -sh $old_mount
    # Hint: df -h $MOUNT_POINT

    # TODO: Copy data with rsync
    # Hint: rsync -avP $old_mount/ $MOUNT_POINT/

    # TODO: Verify file counts
    # Hint: find $old_mount -type f | wc -l
    # Hint: find $MOUNT_POINT -type f | wc -l

    # TODO: Checksum verification
    # Hint: cd $old_mount && find . -type f -exec md5sum {} \; | sort > /tmp/old.md5
    # Hint: cd $MOUNT_POINT && find . -type f -exec md5sum {} \; | sort > /tmp/new.md5
    # Hint: diff /tmp/old.md5 /tmp/new.md5

    # TODO: Unmount old disk
    # Hint: umount $old_mount

    echo "TODO: Implement data migration"
    echo "      Check README.md Task 4 for hints"
}

################################################################################
# Task 5: RAID Configuration
################################################################################

setup_raid() {
    echo -e "${YELLOW}=== Task 5: RAID Configuration ===${NC}"

    # TODO: Check if disks exist
    # Hint: for disk in $RAID_DISK1 $RAID_DISK2; do

    # TODO: Create partitions on RAID disks
    # Hint: parted $disk mklabel gpt
    # Hint: parted $disk mkpart primary 0% 100%
    # Hint: parted $disk set 1 raid on

    # TODO: Create RAID1 array
    # Hint: mdadm --create /dev/md0 --level=1 --raid-devices=2 ${RAID_DISK1}1 ${RAID_DISK2}1

    # TODO: Check RAID status
    # Hint: cat /proc/mdstat
    # Hint: mdadm --detail /dev/md0

    # TODO: Create filesystem on RAID
    # Hint: mkfs.ext4 /dev/md0

    # TODO: Mount RAID
    # Hint: mkdir -p $RAID_MOUNT
    # Hint: mount /dev/md0 $RAID_MOUNT

    # TODO: Save RAID configuration
    # Hint: mdadm --detail --scan | tee -a /etc/mdadm/mdadm.conf
    # Hint: update-initramfs -u

    # TODO: Add to fstab
    # Hint: echo "/dev/md0 $RAID_MOUNT ext4 defaults 0 2" >> /etc/fstab

    echo "TODO: Implement RAID configuration"
    echo "      Check README.md Task 5 for hints"
}

################################################################################
# Task 6: Filesystem Management
################################################################################

manage_filesystems() {
    echo -e "${YELLOW}=== Task 6: Filesystem Management ===${NC}"

    # TODO: Get filesystem info
    # Hint: tune2fs -l /dev/$VG_NAME/$LV_NAME

    # TODO: Check mount options
    # Hint: mount | grep $MOUNT_POINT

    # TODO: Remount with optimized options (noatime)
    # Hint: mount -o remount,noatime $MOUNT_POINT

    # TODO: Add to /etc/fstab for persistent mount
    # Hint: echo "/dev/$VG_NAME/$LV_NAME $MOUNT_POINT ext4 defaults,noatime 0 2" >> /etc/fstab

    # TODO: Display all mounted filesystems
    # Hint: df -h

    echo "TODO: Implement filesystem management"
    echo "      Check README.md Task 6 for hints"
}

################################################################################
# Task 7: Generate Audit Report
################################################################################

generate_report() {
    echo -e "${YELLOW}=== Task 7: Generate Disk Audit Report ===${NC}"

    # TODO: Create report directory
    # Hint: mkdir -p $(dirname $REPORT_FILE)

    # TODO: Generate comprehensive report including:
    #   1. Disk health status (all disks)
    #   2. LVM configuration (pvs, vgs, lvs)
    #   3. RAID status (if configured)
    #   4. Mounted filesystems (df -h)
    #   5. Space usage per mount point
    #   6. fstab entries
    #   7. Recommendations

    # TODO: Set correct permissions
    # Hint: chmod 640 $REPORT_FILE
    # Hint: chown viktor:operations $REPORT_FILE

    echo "TODO: Implement report generation"
    echo "      Check README.md Task 7 for hints"
    echo "      Expected output: $REPORT_FILE"
}

################################################################################
# Main execution
################################################################################

main() {
    # Check if running with appropriate privileges
    if [[ $EUID -ne 0 ]]; then
        echo -e "${YELLOW}Warning: Many operations require root privileges.${NC}"
        echo -e "${YELLOW}Will use sudo where necessary.${NC}"
        echo
    fi

    echo -e "${BLUE}Kristjan Tamm:${NC} 'e-Estonia работает на доверии к данным."
    echo -e "${BLUE}                  Если диск умирает — доверие умирает.'${NC}"
    echo

    # Execute tasks
    disk_health_check
    echo

    create_partition
    echo

    setup_lvm
    echo

    migrate_data
    echo

    setup_raid
    echo

    manage_filesystems
    echo

    generate_report
    echo

    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Episode 11 tasks outlined!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Implement each TODO section"
    echo "  2. Test with: sudo ./starter.sh"
    echo "  3. Run tests: cd tests && sudo ./test.sh"
    echo "  4. Compare with solution/ if stuck"
    echo
    echo -e "${BLUE}LILITH:${NC} 'Диски — это фундамент. Без данных процессы бессмысленны.'"
    echo
    echo -e "${YELLOW}IMPORTANT NOTES:${NC}"
    echo "  - ALWAYS backup before disk operations"
    echo "  - SMART warnings = replace disk immediately"
    echo "  - RAID is NOT backup (protects from disk failure only)"
    echo "  - Test restore procedures regularly"
    echo "  - LVM snapshots before major changes"
    echo
}

# Run main function
main "$@"



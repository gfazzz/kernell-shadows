#!/bin/bash
################################################################################
# EPISODE 12: BACKUP & RECOVERY - AUTOMATED TESTS
# Season 3: System Administration | Tallinn, Estonia 🇪🇪
################################################################################

set -euo pipefail

PASS_COUNT=0
FAIL_COUNT=0
TOTAL_COUNT=0

pass() {
    echo "  ✓ $1"
    ((PASS_COUNT++))
    ((TOTAL_COUNT++))
}

fail() {
    echo "  ✗ $1"
    ((FAIL_COUNT++))
    ((TOTAL_COUNT++))
}

test_section() {
    echo
    echo "=== $1 ==="
}

test_section "1. File Structure"

if [[ -f "starter.sh" ]]; then
    pass "starter.sh exists"
else
    fail "starter.sh not found"
fi

if [[ -f "solution/backup_manager.sh" ]]; then
    pass "solution/backup_manager.sh exists"
else
    fail "solution/backup_manager.sh not found"
fi

if [[ -d "artifacts" ]]; then
    pass "artifacts/ directory exists"
else
    fail "artifacts/ directory not found"
fi

test_section "2. Script Permissions"

if [[ -x "starter.sh" ]] || head -1 starter.sh | grep -q "^#!/bin/bash"; then
    pass "starter.sh is executable or has shebang"
else
    fail "starter.sh missing shebang or execute permission"
fi

if [[ -x "solution/backup_manager.sh" ]] || head -1 solution/backup_manager.sh | grep -q "^#!/bin/bash"; then
    pass "solution/backup_manager.sh has shebang"
else
    fail "solution/backup_manager.sh missing shebang"
fi

test_section "3. Required Commands"

REQUIRED_COMMANDS=("tar" "rsync" "sha256sum" "find" "date" "du" "df")

for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if command -v "$cmd" &>/dev/null; then
        pass "Command available: $cmd"
    else
        fail "Command not found: $cmd"
    fi
done

test_section "4. Test Data Setup"

mkdir -p /tmp/ep12-test-data
for i in {1..10}; do
    echo "Test file $i" > "/tmp/ep12-test-data/file${i}.txt"
done

if [[ $(ls /tmp/ep12-test-data/*.txt 2>/dev/null | wc -l) -eq 10 ]]; then
    pass "Test data created (10 files)"
else
    fail "Failed to create test data"
fi

test_section "5. Full Backup Test"

mkdir -p /tmp/ep12-backup/full

if tar -czf /tmp/ep12-backup/full/test-backup.tar.gz /tmp/ep12-test-data &>/dev/null; then
    pass "Full backup created with tar"
else
    fail "Failed to create full backup"
fi

if [[ -f "/tmp/ep12-backup/full/test-backup.tar.gz" ]]; then
    BACKUP_SIZE=$(du -h /tmp/ep12-backup/full/test-backup.tar.gz | cut -f1)
    pass "Backup file exists (size: $BACKUP_SIZE)"
else
    fail "Backup file not found"
fi

sha256sum /tmp/ep12-backup/full/test-backup.tar.gz > /tmp/ep12-backup/full/test-backup.tar.gz.sha256
if [[ -f "/tmp/ep12-backup/full/test-backup.tar.gz.sha256" ]]; then
    pass "Checksum file created"
else
    fail "Checksum file not created"
fi

test_section "6. Checksum Verification"

cd /tmp/ep12-backup/full
if sha256sum -c test-backup.tar.gz.sha256 &>/dev/null; then
    pass "Checksum verification successful"
else
    fail "Checksum verification failed"
fi

test_section "7. Incremental Backup Test"

mkdir -p /tmp/ep12-backup/incremental/{backup1,backup2}

rsync -a /tmp/ep12-test-data/ /tmp/ep12-backup/incremental/backup1/ &>/dev/null
if [[ -d "/tmp/ep12-backup/incremental/backup1" ]]; then
    pass "First incremental backup created"
else
    fail "First incremental backup failed"
fi

echo "New file" > /tmp/ep12-test-data/new-file.txt

rsync -a --link-dest=/tmp/ep12-backup/incremental/backup1 \
    /tmp/ep12-test-data/ /tmp/ep12-backup/incremental/backup2/ &>/dev/null

if [[ -f "/tmp/ep12-backup/incremental/backup2/new-file.txt" ]]; then
    pass "Second incremental backup with new file"
else
    fail "Second incremental backup failed"
fi

test_section "8. Restore Test"

mkdir -p /tmp/ep12-restore

if tar -xzf /tmp/ep12-backup/full/test-backup.tar.gz -C /tmp/ep12-restore &>/dev/null; then
    pass "Backup restored successfully"
else
    fail "Backup restore failed"
fi

if [[ -f "/tmp/ep12-restore/tmp/ep12-test-data/file1.txt" ]]; then
    pass "Restored files exist"
else
    fail "Restored files not found"
fi

test_section "9. Backup Age Check"

BACKUP_FILE="/tmp/ep12-backup/full/test-backup.tar.gz"
AGE_SECONDS=$(( $(date +%s) - $(stat -c %Y "$BACKUP_FILE") ))
AGE_HOURS=$(( AGE_SECONDS / 3600 ))

if (( AGE_HOURS < 48 )); then
    pass "Backup age is acceptable ($AGE_HOURS hours)"
else
    fail "Backup is too old ($AGE_HOURS hours)"
fi

test_section "10. Cleanup Test"

touch -d "40 days ago" /tmp/ep12-backup/full/old-backup.tar.gz

OLD_COUNT_BEFORE=$(find /tmp/ep12-backup/full -name "*.tar.gz" -mtime +30 | wc -l)

if (( OLD_COUNT_BEFORE > 0 )); then
    pass "Old backup detected (>30 days)"
else
    fail "No old backup to test cleanup"
fi

find /tmp/ep12-backup/full -name "*.tar.gz" -mtime +30 -delete &>/dev/null

OLD_COUNT_AFTER=$(find /tmp/ep12-backup/full -name "*.tar.gz" -mtime +30 | wc -l)

if (( OLD_COUNT_AFTER == 0 )) && (( OLD_COUNT_BEFORE > OLD_COUNT_AFTER )); then
    pass "Old backups cleaned up"
else
    fail "Cleanup did not remove old backups"
fi

test_section "11. Disaster Recovery Simulation"

DR_TEST_DIR="/tmp/ep12-dr-test-$$"
mkdir -p "$DR_TEST_DIR/data"

for i in {1..20}; do
    echo "DR test file $i" > "$DR_TEST_DIR/data/file${i}.txt"
done

cd "$DR_TEST_DIR/data"
sha256sum * > checksums.txt

if [[ -f "checksums.txt" ]]; then
    pass "Checksums generated for DR test"
else
    fail "Failed to generate checksums"
fi

tar -czf "$DR_TEST_DIR/dr-backup.tar.gz" -C "$DR_TEST_DIR" data &>/dev/null

rm -rf "$DR_TEST_DIR/data"

if [[ ! -d "$DR_TEST_DIR/data" ]]; then
    pass "Data destroyed (simulating disaster)"
else
    fail "Failed to destroy data"
fi

tar -xzf "$DR_TEST_DIR/dr-backup.tar.gz" -C "$DR_TEST_DIR" &>/dev/null

cd "$DR_TEST_DIR/data"
if sha256sum -c checksums.txt &>/dev/null; then
    pass "Data restored and verified (checksums match)"
else
    fail "Data restore verification failed"
fi

rm -rf "$DR_TEST_DIR"

test_section "12. Solution Script Functions"

if grep -q "backup_full" solution/backup_manager.sh; then
    pass "Solution contains backup_full function"
else
    fail "Solution missing backup_full function"
fi

if grep -q "backup_incremental" solution/backup_manager.sh; then
    pass "Solution contains backup_incremental function"
else
    fail "Solution missing backup_incremental function"
fi

if grep -q "restore_from_backup" solution/backup_manager.sh; then
    pass "Solution contains restore_from_backup function"
else
    fail "Solution missing restore_from_backup function"
fi

if grep -q "check_backup_health" solution/backup_manager.sh; then
    pass "Solution contains check_backup_health function"
else
    fail "Solution missing check_backup_health function"
fi

if grep -q "disaster_recovery_test" solution/backup_manager.sh; then
    pass "Solution contains disaster_recovery_test function"
else
    fail "Solution missing disaster_recovery_test function"
fi

test_section "Cleanup"

rm -rf /tmp/ep12-test-data
rm -rf /tmp/ep12-backup
rm -rf /tmp/ep12-restore

pass "Test environment cleaned up"

echo
echo "========================================="
echo "          TEST SUMMARY"
echo "========================================="
echo "Total tests: $TOTAL_COUNT"
echo "Passed:      $PASS_COUNT"
echo "Failed:      $FAIL_COUNT"
echo "========================================="

if (( FAIL_COUNT == 0 )); then
    echo "✓ ALL TESTS PASSED!"
    echo
    echo "Liisa Kask: 'Good work. Your backup system is solid.'"
    echo "            'Now test it in production. Every month.'"
    exit 0
else
    echo "✗ SOME TESTS FAILED"
    echo
    echo "Liisa: 'Untested backup = no backup. Fix the issues.'"
    exit 1
fi


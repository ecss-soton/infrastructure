#!/bin/bash
# Exit immediately if any command fails
set -e

# --- 1. INPUT VALIDATION ---
if [[ $# -eq 0 ]] ; then
    echo "Error: Please provide a backup file to restore from."
    echo "Usage: ./restore-db.sh backups/db/backup-db-YYYY-MM-DD.tar.gz"
    exit 1
fi

BACKUP_FILE=$(readlink -f "$1")

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file not found at $BACKUP_FILE"
    exit 1
fi

cd ~/infrastructure

if [ ! -f secrets/db_mongo.txt ]; then
  echo "Error: secrets/db_mongo.txt not found"
  exit 1
fi

MONGO_URI=$(cat secrets/db_mongo.txt)

echo "Starting database restore process..."

# --- 2. EXTRACT BACKUP ---
mkdir -p backups/db/tmp
echo "Extracting backup to temporary directory..."
tar -xvzf "$BACKUP_FILE" -C backups/db/tmp

# Clean up MacOS-specific hidden files (prevents restoring junk data)
find backups/db/tmp -name "._*" -type f -delete 2>/dev/null || true

# --- 3. RESTORE MONGODB ---
echo "Restoring MongoDB..."
# Copy the extracted dump to the container
docker cp backups/db/tmp/mongo_dump/. db_mongo:/restore_tmp
# Execute mongorestore (--drop cleans the DB before restoring)
docker exec db_mongo mongorestore --uri="$MONGO_URI" --drop --db=ecss-website-cms /restore_tmp/ecss-website-cms

# --- 4. RESTORE POSTGRESQL ---
echo "Restoring PostgreSQL..."
# Copy the SQL file to the container
docker cp backups/db/tmp/postgres_all.sql infrastructure-postgres-1:/tmp/postgres_all.sql
# Execute the SQL file using psql
docker exec infrastructure-postgres-1 psql -U ecss -f /tmp/postgres_all.sql

# --- 5. RESTORE VAULTWARDEN ---
echo "Checking for Vaultwarden backup data..."
if [ -d "backups/db/tmp/vaultwarden_data" ]; then
    echo "Restoring Vaultwarden..."
    # Stop the container to prevent database corruption during file overwrite
    docker stop vaultwarden

    # Use a temporary alpine container to mount the docker volume, wipe it clean, and copy the backup files exactly
    docker run --rm \
      -v vaultwarden_data:/data \
      -v "$(pwd)/backups/db/tmp/vaultwarden_data:/backup" \
      alpine sh -c "rm -rf /data/* && cp -a /backup/. /data/"

    # Restart the container with the restored data
    docker start vaultwarden
else
    echo "Notice: No Vaultwarden data found in this backup archive. Skipping Vaultwarden restore."
fi

# --- 5. CLEANUP ---
echo "Cleaning up temporary host files..."
rm -rf backups/db/tmp

echo "Cleaning up temporary container files..."
docker exec db_mongo rm -rf /restore_tmp
docker exec infrastructure-postgres-1 rm -f /tmp/postgres_all.sql

echo "Database restore complete!"
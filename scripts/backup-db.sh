#!/bin/bash
# Exit immediately if any command fails
set -e

cd ~/infrastructure

# --- 1. SETUP & VALIDATION ---
if [ ! -f secrets/db_mongo.txt ]; then
  echo "Error: secrets/db_mongo.txt not found"
  exit 1
fi

MONGO_URI=$(cat secrets/db_mongo.txt)
DATE=$(date +"%Y-%m-%dT%H%M%S")

echo "Starting backup process..."

# Create necessary directories
mkdir -p backups/db/tmp
mkdir -p backups/media/latest

# --- 2. DATABASE BACKUP ---
echo "Dumping databases inside containers..."
# Dump Mongo to a temp folder inside the container
docker exec db_mongo mongodump --uri="$MONGO_URI" --db=ecss-website-cms --out=/backup_tmp
# Dump Postgres to a SQL file inside the container
docker exec infrastructure-postgres-1 pg_dumpall -U ecss -f /tmp/postgres_all.sql

echo "Copying database dumps to host..."
docker cp db_mongo:/backup_tmp backups/db/tmp/mongo_dump
docker cp infrastructure-postgres-1:/tmp/postgres_all.sql backups/db/tmp/postgres_all.sql

echo "Compressing database backup..."
tar -zcf "backups/db/backup-db-${DATE}.tar.gz" -C backups/db/tmp .

# --- 3. MEDIA BACKUP (Incremental Sync) ---
echo "Syncing media files..."
mkdir -p backups/media/tmp_extract
# Copy files from docker to a temporary folder
docker cp web_main:/home/node/app/media/. backups/media/tmp_extract/
# Use rsync to efficiently mirror the temp folder to the 'latest' folder. 
# --delete ensures files deleted in production are removed from the backup mirror.
rsync -a --delete backups/media/tmp_extract/ backups/media/latest/

# --- 4. CLEANUP ---
echo "Cleaning up temporary host files..."
rm -rf backups/db/tmp
rm -rf backups/media/tmp_extract

echo "Cleaning up temporary container files..."
docker exec db_mongo rm -rf /backup_tmp
docker exec infrastructure-postgres-1 rm -f /tmp/postgres_all.sql

echo "Backup complete! DB archive: backups/db/backup-db-${DATE}.tar.gz"
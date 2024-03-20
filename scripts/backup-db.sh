#! /bin/bash

# Create directory for backup to go
mkdir -p backups/db

# Create a backup of the database
docker exec db_mongo mongodump --uri="mongodb://root:example@db_mongo:27017/ecss-website-cms?authSource=admin" --db=ecss-website-cms --out=/

# Copy the backup from docker to the host
docker cp db_mongo:/ecss-website-cms/. backups/db/ecss-website-cms

# Get the current date in the format YYYY-MM-DD HHMMSS
date=$(date +"%Y-%m-%dT%H%M%S")

# Create a tarball of the backup
tar -zcvf "backups/db/backup-db-${date}".tar.gz backups/db/ecss-website-cms

# Remove the backup folder
rm -rf backups/db/ecss-website-cms

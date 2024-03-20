#! /bin/bash

# Create directory for backup to go
mkdir -p backups/db/tmp

# Create a backup of the database (https://www.mongodb.com/docs/database-tools/mongodump/)
docker exec db_mongo mongodump --uri="mongodb://root:example@db_mongo:27017/ecss-website-cms?authSource=admin" --db=ecss-website-cms --out=/

# Copy the backup from docker to the host
docker cp db_mongo:/ecss-website-cms backups/db/tmp/ecss-website-cms
docker cp web_main:/home/node/app/media backups/db/tmp/media

# Get the current date in the format YYYY-MM-DD HHMMSS
date=$(date +"%Y-%m-%dT%H%M%S")

# Create a tarball of the backup
tar -zcf "backups/db/backup-db-${date}.tar.gz" backups/db/tmp

# Remove the backup folder on the host
rm -rf backups/db/ecss-website-cms

# Remove the backup from the docker container
docker exec db_mongo rm -rf /ecss-website-cms

echo "Mongodb database backup created at backups/db/backup-db-${date}.tar.gz"

#! /bin/bash

# Navigate to the infrastructure directory, necessary for cron jobs
cd ~/infrastructure

# Check the secrets/db_mongo.txt file exists
if [ ! -f secrets/db_mongo.txt ]; then
  echo "secrets/db_mongo.txt file not found"
  exit 1
fi

# Create directory for backup to go
mkdir -p backups/db/tmp

uri=$(cat secrets/db_mongo.txt)

# Create a backup of the database (https://www.mongodb.com/docs/database-tools/mongodump/)
docker exec db_mongo mongodump --uri="$uri" --db=ecss-website-cms --out=/

# Copy the backup from docker to the host
docker cp db_mongo:/ecss-website-cms backups/db/tmp/ecss-website-cms
docker cp web_main:/home/node/app/media backups/db/tmp/media

# Get the current date in the format YYYY-MM-DD HHMMSS
date=$(date +"%Y-%m-%dT%H%M%S")

# Create a tarball of the backup
tar -zcf "backups/db/backup-db-${date}.tar.gz" -C backups/db/tmp .

# Remove the backup folder on the host
rm -rf backups/db/tmp

# Remove the backup from the docker container
docker exec db_mongo rm -rf /ecss-website-cms

echo "Mongodb database backup created at backups/db/backup-db-${date}.tar.gz"

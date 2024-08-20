#! /bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Please provide a backup file to restore from as the first argument.'
    exit 0
fi

cd ~/infrastructure

# Check the secrets/db_mongo.txt file exists
if [ ! -f secrets/db_mongo.txt ]; then
  echo "secrets/db_mongo.txt file not found"
  exit 1
fi

uri=$(cat secrets/db_mongo.txt)

# Create a directory for the backup to go
mkdir -p backups/db/tmp

# Extract the backup
tar -xvzf $1 -C backups/db/tmp

# Remove MacOS specific meta-files from extract
rm backups/db/tmp/._*
rm backups/db/tmp/ecss-website-cms/._*
rm backups/db/tmp/media/._*

# Copy the backup from docker to the host
docker cp backups/db/tmp/ecss-website-cms/. db_mongo:/ecss-website-cms
docker cp backups/db/tmp/media/. web_main:/home/node/app/media

# Restore the database (https://www.mongodb.com/docs/database-tools/mongorestore/)
docker exec db_mongo mongorestore --uri="$uri" --db=ecss-website-cms /ecss-website-cms

# Remove the backup from the docker container
docker exec db_mongo rm -rf /ecss-website-cms

# Remove the backup folder from the host
rm -rf backups/db/tmp

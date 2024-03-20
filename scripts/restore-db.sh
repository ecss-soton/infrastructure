#! /bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Please provide a backup file to restore from as the first argument.'
    exit 0
fi

# Create a directory for the backup to go
mkdir -p backups/db/tmp

# Extract the backup
tar -xvzf $1 -C backups/db/tmp

# Copy the backup from docker to the host
docker cp backups/db/tmp/backups/db/ecss-website-cms db_mongo:/ecss-website-cms

# Restore the database (https://www.mongodb.com/docs/database-tools/mongorestore/)
docker exec db_mongo mongorestore --uri="mongodb://root:example@db_mongo:27017/ecss-website-cms?authSource=admin" --db=ecss-website-cms /ecss-website-cms

# Remove the backup from the docker container
docker exec db_mongo rm -rf /ecss-website-cms

# Remove the backup folder from the host
rm -rf backups/db/tmp

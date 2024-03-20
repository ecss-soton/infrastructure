#! /bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Please provide a backup file to restore from as the first argument.'
    exit 0
fi

# Create a directory for the backup to go
mkdir -p backus/db/tmp

# Extract the backup
tar -xvzf $1 -C backus/db/tmp

# Remove the backup folder from the host
rm -rf backups/db/tmp

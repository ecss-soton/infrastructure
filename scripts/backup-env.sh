#! /bin/bash

mkdir -p backups

# Get the current date in the format YYYY-MM-DD HH:MM:SS
date=$(date +"%Y-%m-%d %H:%M:%S")

# Create a backup of the environment files
tar --exclude='*.example' -zcvf "backups/backup-env-${date}".tar.gz env

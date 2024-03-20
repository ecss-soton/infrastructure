#! /bin/bash

mkdir -p backups/env

# Get the current date in the format YYYY-MM-DD HHMMSS
date=$(date +"%Y-%m-%dT%H%M%S")

# Create a backup of the environment files
tar --exclude='*.example' -zcvf "backups/env/backup-env-${date}".tar.gz env

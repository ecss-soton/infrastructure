#! /bin/bash

# Navigate to the infrastructure directory, necessary for cron jobs
cd ~/infrastructure

mkdir -p backups/env

# Get the current date in the format YYYY-MM-DD HHMMSS
date=$(date +"%Y-%m-%dT%H%M%S")

# Create a backup of the environment files
tar --exclude='*.example' -zcf "backups/env/backup-env-${date}.tar.gz" env

echo "Environment variable backup created at backups/env/backup-env-${date}.tar.gz"
